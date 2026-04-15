<script setup lang="ts">
import { ref, reactive, computed, onMounted, onBeforeUnmount } from 'vue'
import {
  fetchStocks,
  fetchScoreTrendStats,
  fetchSectors,
  fetchPortfolios,
  fetchExchanges,
  deleteStock,
  enrichFiltered,
  fetchFeaturesRefreshStatus,
} from '../services/api'
import { maybeAutoRefreshStaleFeatures } from '../utils/featuresRefresh'
import type { Stock, StockFilters, ScoreTrendStats, Portfolio, Exchange } from '../types'
import { parseQualifiedEquityInput } from '../utils/qualifiedSearch'

const stocks = ref<Stock[]>([])
const loading = ref(false)
const total = ref(0)
const pages = ref(0)
const sectors = ref<string[]>([])
const exchanges = ref<Exchange[]>([])
const portfolios = ref<Portfolio[]>([])
const stats = ref<ScoreTrendStats | null>(null)
const loadError = ref('')
const deletingId = ref<number | null>(null)
const batchRefreshing = ref(false)
const batchMsg = ref('')
const lastFeatureMaxAt = ref<string | null>(null)
const autoRefreshNote = ref('')
/** Parallel Yahoo calls for refresh batch (backend caps at 8; 1 = sequential + delays). */
const refreshWorkers = ref(4)

const SCORE_TREND_STORAGE_KEY = 'stockUnifier.scoreTrend.v1'

function persistScoreTrendState() {
  try {
    const payload = {
      scoreBand: scoreBand.value,
      customMin: customMin.value,
      customMax: customMax.value,
      refreshWorkers: refreshWorkers.value,
      listState: { ...listState },
    }
    sessionStorage.setItem(SCORE_TREND_STORAGE_KEY, JSON.stringify(payload))
  } catch {
    /* quota / private mode */
  }
}

function restoreScoreTrendState() {
  try {
    const raw = sessionStorage.getItem(SCORE_TREND_STORAGE_KEY)
    if (!raw) return
    const p = JSON.parse(raw) as Record<string, unknown>
    const bands: ScoreBand[] = ['all', 'strong', 'moderate', 'weak', 'poor', 'custom']
    if (typeof p.scoreBand === 'string' && bands.includes(p.scoreBand as ScoreBand)) {
      scoreBand.value = p.scoreBand as ScoreBand
    }
    if (p.customMin === null || typeof p.customMin === 'number') customMin.value = p.customMin as number | null
    if (p.customMax === null || typeof p.customMax === 'number') customMax.value = p.customMax as number | null
    if (typeof p.refreshWorkers === 'number' && p.refreshWorkers >= 1 && p.refreshWorkers <= 8) {
      refreshWorkers.value = p.refreshWorkers
    }
    const ls = p.listState as Record<string, unknown> | undefined
    if (ls && typeof ls === 'object') {
      const divs = ['', 'strong_below_selected', 'poor_above_any', 'poor_above_all'] as const
      if (typeof ls.exchange === 'string') listState.exchange = ls.exchange
      if (typeof ls.sector === 'string') listState.sector = ls.sector
      if (typeof ls.search === 'string') listState.search = ls.search
      if (typeof ls.quanfury_only === 'boolean') listState.quanfury_only = ls.quanfury_only
      if (typeof ls.sort_by === 'string') listState.sort_by = ls.sort_by
      if (ls.order === 'asc' || ls.order === 'desc') listState.order = ls.order
      if (typeof ls.page === 'number' && ls.page >= 1) listState.page = Math.floor(ls.page)
      if (typeof ls.page_size === 'number' && ls.page_size >= 1 && ls.page_size <= 500) {
        listState.page_size = Math.floor(ls.page_size)
      }
      if (typeof ls.divergence === 'string' && divs.includes(ls.divergence as (typeof divs)[number])) {
        listState.divergence = ls.divergence as (typeof listState)['divergence']
      }
      if (typeof ls.ema_52_for_div === 'boolean') listState.ema_52_for_div = ls.ema_52_for_div
      if (typeof ls.ema_200_for_div === 'boolean') listState.ema_200_for_div = ls.ema_200_for_div
      if (typeof ls.portfolioId === 'string') listState.portfolioId = ls.portfolioId
      else if (typeof ls.portfolioId === 'number' && Number.isFinite(ls.portfolioId)) {
        listState.portfolioId = String(Math.floor(ls.portfolioId))
      }
      if (typeof ls.tech_complete === 'boolean') listState.tech_complete = ls.tech_complete
    }
  } catch {
    /* corrupt JSON */
  }
}

onBeforeUnmount(() => {
  persistScoreTrendState()
})

type ScoreBand = 'all' | 'strong' | 'moderate' | 'weak' | 'poor' | 'custom'
const scoreBand = ref<ScoreBand>('all')
const customMin = ref<number | null>(null)
const customMax = ref<number | null>(null)

const listState = reactive({
  exchange: '',
  sector: '',
  search: '',
  quanfury_only: false,
  sort_by: 'health_score',
  order: 'desc',
  page: 1,
  page_size: 100,
  divergence: '' as '' | 'strong_below_selected' | 'poor_above_any' | 'poor_above_all',
  ema_52_for_div: true,
  ema_200_for_div: true,
  /** '' = all stocks in DB (any exchange); avoids <option :value="null"> quirks in some browsers */
  portfolioId: '' as string,
  tech_complete: false,
})

function normalizePortfolioId(): number | null {
  const v = listState.portfolioId
  if (v === '' || v == null) return null
  const n = Number(v)
  return Number.isFinite(n) ? n : null
}

function bandHealthRange(): { min: number | null; max: number | null } {
  switch (scoreBand.value) {
    case 'strong':
      return { min: 70, max: 100 }
    case 'moderate':
      return { min: 45, max: 69.999 }
    case 'weak':
      return { min: 25, max: 44.999 }
    case 'poor':
      return { min: 0, max: 24.999 }
    case 'custom':
      return { min: customMin.value, max: customMax.value }
    default:
      return { min: null, max: null }
  }
}

/** Body fields for POST /stocks/enrich/filtered — mirrors current Score vs trend filters. */
function enrichPayloadFromUi() {
  const f = toStockFilters()
  return {
    exchange: f.exchange || undefined,
    sector: f.sector || undefined,
    search: f.search?.trim() || undefined,
    quanfury_only: f.quanfury_only ? true : undefined,
    near_52w_high: f.near_52w_high ? true : undefined,
    near_52w_low: f.near_52w_low ? true : undefined,
    min_div_yield: f.min_div_yield ?? undefined,
    min_rsi: f.min_rsi ?? undefined,
    max_rsi: f.max_rsi ?? undefined,
    min_health_score: f.min_health_score ?? undefined,
    max_health_score: f.max_health_score ?? undefined,
    divergence: f.divergence || undefined,
    ema_52_for_div: f.ema_52_for_div,
    ema_200_for_div: f.ema_200_for_div,
    portfolio_id: f.portfolio_id ?? undefined,
    tech_complete: f.tech_complete ? true : undefined,
    max_workers: refreshWorkers.value,
  }
}

function toStockFilters(): StockFilters {
  const { min, max } = bandHealthRange()
  const pq = parseQualifiedEquityInput(listState.search)
  return {
    exchange: pq.exchange || listState.exchange,
    sector: listState.sector,
    search: pq.exchange != null ? pq.displaySymbol : listState.search.trim(),
    quanfury_only: listState.quanfury_only,
    sort_by: listState.sort_by,
    order: listState.order,
    min_div_yield: null,
    min_rsi: null,
    max_rsi: null,
    near_52w_high: false,
    near_52w_low: false,
    page: listState.page,
    page_size: listState.page_size,
    min_health_score: min,
    max_health_score: max,
    divergence: listState.divergence || null,
    ema_52_for_div: listState.ema_52_for_div,
    ema_200_for_div: listState.ema_200_for_div,
    portfolio_id: normalizePortfolioId(),
    tech_complete: listState.tech_complete,
  }
}

function apiErrorMessage(e: unknown): string {
  const err = e as { message?: string; response?: { status?: number; data?: { detail?: unknown } } }
  if (err.response?.status === 404) {
    return 'API returned 404. Use `npm run dev` (Vite proxies /api → http://127.0.0.1:8000) and run the FastAPI backend on port 8000.'
  }
  const d = err.response?.data?.detail
  if (typeof d === 'string') return d
  if (Array.isArray(d)) return d.map((x: { msg?: string }) => x.msg).filter(Boolean).join('; ') || 'Request failed'
  if (err.message === 'Network Error' || !err.response) {
    return 'Cannot reach API (network error). Start the backend: `uvicorn main:app --host 127.0.0.1 --port 8000` from the backend folder, then reload.'
  }
  return err.message || 'Failed to load stocks'
}

function formatFeatureSync(iso: string | null): string {
  if (!iso) return '—'
  try {
    const d = new Date(iso)
    if (Number.isNaN(d.getTime())) return iso
    return d.toLocaleString(undefined, { dateStyle: 'short', timeStyle: 'short' })
  } catch {
    return iso
  }
}

async function refreshBatch1000() {
  if (batchRefreshing.value) return
  batchRefreshing.value = true
  batchMsg.value = ''
  autoRefreshNote.value = ''
  try {
    const r = await enrichFiltered({
      force: true,
      batch_size: 1000,
      stale_first: true,
      offset: 0,
      ...enrichPayloadFromUi(),
    })
    const scope = typeof r.total_matching === 'number' ? ` (${r.total_matching} match current filters)` : ''
    batchMsg.value =
      r.failed > 0
        ? `Updated ${r.enriched} stocks${scope} (${r.failed} errors).`
        : `Updated ${r.enriched} stocks${scope}.`
    await load()
    const s = await fetchFeaturesRefreshStatus(24)
    lastFeatureMaxAt.value = s.max_updated_at
  } catch (e: unknown) {
    batchMsg.value = apiErrorMessage(e)
  } finally {
    batchRefreshing.value = false
  }
}

async function load() {
  loading.value = true
  loadError.value = ''
  try {
    const filters = toStockFilters()
    const statsPayload: Partial<StockFilters> = {
      exchange: filters.exchange,
      sector: filters.sector,
      search: filters.search,
      quanfury_only: filters.quanfury_only,
      portfolio_id: filters.portfolio_id,
      min_health_score: filters.min_health_score,
      max_health_score: filters.max_health_score,
      tech_complete: filters.tech_complete,
    }
    const [stocksResult, statsResult] = await Promise.allSettled([
      fetchStocks(filters),
      fetchScoreTrendStats(statsPayload),
    ])

    if (stocksResult.status === 'rejected') {
      throw stocksResult.reason
    }
    const pageData = stocksResult.value
    if (!pageData || typeof pageData.total !== 'number' || !Array.isArray(pageData.items)) {
      throw new Error('Invalid response from /api/stocks (expected JSON with items and total).')
    }
    stocks.value = pageData.items
    total.value = pageData.total
    pages.value = pageData.pages

    if (statsResult.status === 'fulfilled') {
      stats.value = statsResult.value
    } else {
      stats.value = null
      console.warn('score-trend stats failed', statsResult.reason)
    }
  } catch (e) {
    loadError.value = apiErrorMessage(e)
    stocks.value = []
    total.value = 0
    pages.value = 0
    stats.value = null
  } finally {
    loading.value = false
    persistScoreTrendState()
  }
}

onMounted(async () => {
  const [sec, exc, port] = await Promise.all([fetchSectors(), fetchExchanges(), fetchPortfolios()])
  sectors.value = sec
  exchanges.value = exc
  portfolios.value = port
  restoreScoreTrendState()
  await load()
  try {
    const s0 = await fetchFeaturesRefreshStatus(24)
    lastFeatureMaxAt.value = s0.max_updated_at
    const auto = await maybeAutoRefreshStaleFeatures(load, {
      hours: 24,
      batchSize: 1000,
      enrichParams: { ...enrichPayloadFromUi(), max_workers: 2 },
    })
    if (auto.ran) {
      autoRefreshNote.value =
        'Data was older than 24h — refreshed up to 1000 rows matching your current filters (oldest first).'
      const s1 = await fetchFeaturesRefreshStatus(24)
      lastFeatureMaxAt.value = s1.max_updated_at
    }
    if (auto.error) console.warn('auto feature refresh:', auto.error)
  } catch {
    /* offline or API missing */
  }
})

/** Full universe, no ticker required: all stocks in DB, best score first (same as fresh install defaults). */
function resetToGeneralBestFirst() {
  scoreBand.value = 'all'
  customMin.value = null
  customMax.value = null
  listState.exchange = ''
  listState.sector = ''
  listState.search = ''
  listState.quanfury_only = false
  listState.portfolioId = ''
  listState.divergence = ''
  listState.ema_52_for_div = true
  listState.ema_200_for_div = true
  listState.tech_complete = false
  listState.sort_by = 'health_score'
  listState.order = 'desc'
  listState.page = 1
  listState.page_size = 100
  persistScoreTrendState()
  load()
}

function applyFilters() {
  listState.page = 1
  load()
}

function setSort(field: string) {
  if (listState.sort_by === field) {
    listState.order = listState.order === 'asc' ? 'desc' : 'asc'
  } else {
    listState.sort_by = field
    listState.order = field === 'health_score' ? 'desc' : 'desc'
  }
  listState.page = 1
  load()
}

function setScoreOrder(bestFirst: boolean) {
  listState.sort_by = 'health_score'
  listState.order = bestFirst ? 'desc' : 'asc'
  listState.page = 1
  load()
}

function setPage(p: number) {
  listState.page = p
  load()
}

function fmt(n: number | null | undefined, decimals = 2): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}

function scoreColor(score: number | null): string {
  if (score === null) return 'text-gray-500'
  if (score >= 70) return 'text-green-400'
  if (score >= 45) return 'text-yellow-400'
  if (score >= 25) return 'text-orange-400'
  return 'text-red-400'
}

function scoreLabel(score: number | null): string {
  if (score === null) return 'N/A'
  if (score >= 70) return 'Strong'
  if (score >= 45) return 'Moderate'
  if (score >= 25) return 'Weak'
  return 'Poor'
}

function scoreBg(score: number | null): string {
  if (score === null) return 'bg-gray-800 border-gray-700'
  if (score >= 70) return 'bg-green-900/30 border-green-800'
  if (score >= 45) return 'bg-yellow-900/30 border-yellow-800'
  if (score >= 25) return 'bg-orange-900/30 border-orange-800'
  return 'bg-red-900/30 border-red-800'
}

function rsiColor(r: number | null): string {
  if (r === null) return 'text-gray-500'
  if (r >= 70) return 'text-red-400'
  if (r <= 30) return 'text-green-400'
  return 'text-gray-300'
}

function vsEma(close: number | null, ema: number | null): 'above' | 'below' | 'na' {
  if (close === null || ema === null) return 'na'
  return close > ema ? 'above' : 'below'
}

function vsBadge(kind: 'above' | 'below' | 'na') {
  if (kind === 'na') return { text: '—', cls: 'bg-gray-800 text-gray-500' }
  if (kind === 'above') return { text: 'Above', cls: 'bg-amber-900/40 text-amber-300 border border-amber-800' }
  return { text: 'Below', cls: 'bg-sky-900/40 text-sky-300 border border-sky-800' }
}

function distPct(close: number | null, ema: number | null): number | null {
  if (close === null || ema === null || ema === 0) return null
  return ((close - ema) / ema) * 100
}

const sortIcon = (field: string) => {
  if (listState.sort_by !== field) return ''
  return listState.order === 'asc' ? ' ↑' : ' ↓'
}

/** Explicit label so it matches Best→worst / Worst→best (↓ = highest scores first). */
function healthScoreSortSuffix(): string {
  if (listState.sort_by !== 'health_score') return ''
  return listState.order === 'desc' ? ' · high→low' : ' · low→high'
}

const pageNumbers = computed(() => {
  const current = listState.page
  const last = pages.value
  const out: number[] = []
  const start = Math.max(1, current - 2)
  const end = Math.min(last, current + 2)
  for (let i = start; i <= end; i++) out.push(i)
  return out
})

const scoreOrderLabel = computed(() => {
  if (listState.sort_by !== 'health_score') return ''
  return listState.order === 'desc' ? '(best → worst)' : '(worst → best)'
})

async function deleteStockRow(row: Stock) {
  if (deletingId.value != null) return
  const ok = window.confirm(
    `Remove ${row.ticker_yf} (${row.symbol}) from the database? Holdings and cached data will be deleted. Cannot be undone.`,
  )
  if (!ok) return
  deletingId.value = row.id
  try {
    await deleteStock(row.id)
    await load()
  } catch (e: any) {
    window.alert(e.response?.data?.detail || e.message || 'Delete failed')
  } finally {
    deletingId.value = null
  }
}
</script>

<template>
  <div>
    <div class="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-4 mb-6">
      <div>
        <h1 class="text-3xl font-bold text-white">Score vs trend</h1>
        <p class="text-sm text-gray-400 mt-1 max-w-2xl">
          Browse stocks sorted by health score (default: whole database). Use exchange, score band, divergence preset, portfolio, etc. to narrow the list.
          <span class="text-gray-300">Refresh batch (1000)</span> only hits Yahoo for rows that match the filters you have applied (up to 1000, stale first) — not the entire DB.
          EMA 52 / 200 are daily. Combining <span class="text-amber-400/90">Strong</span>, <span class="text-amber-400/90">Quanfury only</span>, and
          <span class="text-amber-400/90">only full EMA rows</span> often returns zero rows.
        </p>
        <p class="text-xs text-gray-500 mt-2">
          Newest feature sync:
          <span class="font-mono text-gray-400">{{ formatFeatureSync(lastFeatureMaxAt) }}</span>
          <span v-if="batchMsg" class="text-emerald-400/90 ml-2">{{ batchMsg }}</span>
          <span v-if="autoRefreshNote" class="text-amber-400/90 ml-2">{{ autoRefreshNote }}</span>
        </p>
        <router-link to="/score" class="text-xs text-primary-400 hover:text-primary-300 mt-2 inline-block">
          How is the score calculated?
        </router-link>
        <p class="text-[11px] text-gray-600 mt-2 max-w-2xl">
          Dev setup: run the API on <span class="font-mono text-gray-500">127.0.0.1:8000</span> and the UI with
          <span class="font-mono text-gray-500">npm run dev</span> or <span class="font-mono text-gray-500">npm run preview</span>
          so <span class="font-mono text-gray-500">/api</span> is proxied. Opening <span class="font-mono text-gray-500">dist/index.html</span>
          directly in the browser shows zero rows.
        </p>
      </div>
      <div class="flex flex-wrap gap-2 items-center">
        <label class="flex items-center gap-1.5 text-xs text-gray-400">
          <span class="whitespace-nowrap">Hilos Yahoo</span>
          <select v-model.number="refreshWorkers" class="input-field py-1 px-2 text-xs w-14 font-mono" title="Más hilos = más rápido pero mayor riesgo de que Yahoo limite o falle peticiones. 1 = uno tras otro (más lento).">
            <option v-for="w in [1, 2, 3, 4, 5, 6, 8]" :key="w" :value="w">{{ w }}</option>
          </select>
        </label>
        <button
          type="button"
          class="btn-primary text-sm"
          :disabled="batchRefreshing || loading"
          :title="'Recompute price, indicators, and health score via yfinance for up to 1000 rows that match the filters above (stale first). Uses ' + refreshWorkers + ' parallel worker(s) when >1.'"
          @click="refreshBatch1000"
        >
          {{ batchRefreshing ? 'Refreshing batch…' : 'Refresh batch (1000 · filtered)' }}
        </button>
        <button
          type="button"
          class="btn-secondary text-sm"
          :class="listState.sort_by === 'health_score' && listState.order === 'desc' ? 'ring-1 ring-primary-500' : ''"
          @click="setScoreOrder(true)"
        >
          Best → worst
        </button>
        <button
          type="button"
          class="btn-secondary text-sm"
          :class="listState.sort_by === 'health_score' && listState.order === 'asc' ? 'ring-1 ring-primary-500' : ''"
          @click="setScoreOrder(false)"
        >
          Worst → best
        </button>
      </div>
    </div>

    <div
      v-if="loadError"
      class="mb-6 p-4 rounded-xl border border-red-800 bg-red-950/40 text-red-200 text-sm flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3"
    >
      <div>
        <p class="font-medium text-red-100">Could not load data</p>
        <p class="text-red-200/90 text-xs mt-1">{{ loadError }}</p>
      </div>
      <button type="button" class="btn-primary text-sm shrink-0" @click="load">Retry</button>
    </div>

    <!-- KPIs -->
    <div v-if="stats" class="grid grid-cols-2 md:grid-cols-5 gap-3 mb-6">
      <div class="card !p-4">
        <p class="text-[10px] text-gray-500 uppercase tracking-wide">Universe</p>
        <p class="text-2xl font-bold text-white font-mono">{{ stats.total }}</p>
      </div>
      <div class="card !p-4 border-l-2 border-green-600">
        <p class="text-[10px] text-gray-500 uppercase tracking-wide">Strong &amp; below EMA200</p>
        <p class="text-2xl font-bold text-green-400 font-mono">{{ stats.strong_below_ema200 }}</p>
      </div>
      <div class="card !p-4 border-l-2 border-green-700">
        <p class="text-[10px] text-gray-500 uppercase tracking-wide">Strong &amp; below both EMAs</p>
        <p class="text-2xl font-bold text-green-300 font-mono">{{ stats.strong_below_both_emas }}</p>
      </div>
      <div class="card !p-4 border-l-2 border-red-600">
        <p class="text-[10px] text-gray-500 uppercase tracking-wide">Poor &amp; above EMA200</p>
        <p class="text-2xl font-bold text-red-400 font-mono">{{ stats.poor_above_ema200 }}</p>
      </div>
      <div class="card !p-4 border-l-2 border-red-700">
        <p class="text-[10px] text-gray-500 uppercase tracking-wide">Poor &amp; above any EMA</p>
        <p class="text-2xl font-bold text-red-300 font-mono">{{ stats.poor_above_any_ema }}</p>
      </div>
    </div>

    <!-- Filters -->
    <div class="card mb-6 space-y-4">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-7 gap-4">
        <div class="lg:col-span-2">
          <label class="block text-xs text-gray-500 mb-1">Search (optional)</label>
          <input
            v-model="listState.search"
            type="text"
            placeholder="Optional: name, or WING:NASDAQ, SHOP@TSX…"
            class="input-field"
            @keyup.enter="applyFilters"
          />
        </div>
        <div>
          <label class="block text-xs text-gray-500 mb-1">Exchange</label>
          <select v-model="listState.exchange" class="input-field" @change="applyFilters">
            <option value="">All exchanges</option>
            <option v-for="e in exchanges" :key="e.id" :value="e.code">{{ e.code }} — {{ e.name }}</option>
          </select>
        </div>
        <div>
          <label class="block text-xs text-gray-500 mb-1">Sector</label>
          <select v-model="listState.sector" class="input-field" @change="applyFilters">
            <option value="">All sectors</option>
            <option v-for="s in sectors" :key="s" :value="s">{{ s }}</option>
          </select>
        </div>
        <div>
          <label class="block text-xs text-gray-500 mb-1">Portfolio</label>
          <select v-model="listState.portfolioId" class="input-field" @change="applyFilters">
            <option value="">None (all tickers)</option>
            <option v-for="p in portfolios" :key="p.id" :value="String(p.id)">{{ p.name }}</option>
          </select>
        </div>
        <div>
          <label class="block text-xs text-gray-500 mb-1">Score band</label>
          <select v-model="scoreBand" class="input-field" @change="applyFilters">
            <option value="all">All scores</option>
            <option value="strong">Strong (≥70)</option>
            <option value="moderate">Moderate (45–69)</option>
            <option value="weak">Weak (25–44)</option>
            <option value="poor">Poor (&lt;25)</option>
            <option value="custom">Custom min / max</option>
          </select>
        </div>
        <div class="flex items-end">
          <label class="flex items-center gap-2 text-sm text-gray-300 cursor-pointer">
            <input
              v-model="listState.quanfury_only"
              type="checkbox"
              class="w-4 h-4 rounded bg-gray-700 border-gray-600 text-primary-600"
              @change="applyFilters"
            />
            Quanfury only
          </label>
        </div>
      </div>

      <div v-if="scoreBand === 'custom'" class="flex flex-wrap gap-4 items-end">
        <div>
          <label class="block text-xs text-gray-500 mb-1">Min score</label>
          <input v-model.number="customMin" type="number" min="0" max="100" class="input-field w-24" @change="applyFilters" />
        </div>
        <div>
          <label class="block text-xs text-gray-500 mb-1">Max score</label>
          <input v-model.number="customMax" type="number" min="0" max="100" class="input-field w-24" @change="applyFilters" />
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 border-t border-gray-800 pt-4">
        <div>
          <label class="block text-xs text-gray-500 mb-1">Divergence preset</label>
          <select v-model="listState.divergence" class="input-field" @change="applyFilters">
            <option value="">None</option>
            <option value="strong_below_selected">Strong (≥70) below all selected EMAs</option>
            <option value="poor_above_any">Poor (&lt;45) above any selected EMA</option>
            <option value="poor_above_all">Poor (&lt;45) above all selected EMAs</option>
          </select>
          <p class="text-[10px] text-gray-600 mt-1">EMAs in scope for divergence:</p>
          <div class="flex gap-4 mt-1">
            <label class="flex items-center gap-2 text-xs text-gray-400 cursor-pointer">
              <input v-model="listState.ema_52_for_div" type="checkbox" class="w-3.5 h-3.5 rounded bg-gray-700" @change="applyFilters" />
              EMA 52
            </label>
            <label class="flex items-center gap-2 text-xs text-gray-400 cursor-pointer">
              <input v-model="listState.ema_200_for_div" type="checkbox" class="w-3.5 h-3.5 rounded bg-gray-700" @change="applyFilters" />
              EMA 200
            </label>
          </div>
        </div>
        <div class="flex flex-col justify-end">
          <label class="flex items-center gap-2 text-sm text-gray-300 cursor-pointer">
            <input
              v-model="listState.tech_complete"
              type="checkbox"
              class="w-4 h-4 rounded bg-gray-700 border-gray-600 text-primary-600"
              @change="applyFilters"
            />
            Only rows with close + EMA52 + EMA200
          </label>
        </div>
      </div>

      <div class="flex flex-wrap items-center gap-2">
        <button type="button" class="btn-primary text-sm" @click="applyFilters">Apply</button>
        <button type="button" class="btn-secondary text-sm" @click="resetToGeneralBestFirst">
          All stocks · best score first
        </button>
        <span class="text-sm text-gray-500">{{ total.toLocaleString() }} matches</span>
        <span v-if="listState.sort_by === 'health_score'" class="text-xs text-gray-600">{{ scoreOrderLabel }}</span>
      </div>
    </div>

    <!-- Table -->
    <div class="card overflow-x-auto p-0">
      <table class="w-full text-sm">
        <thead>
          <tr class="border-b border-gray-800 text-left">
            <th class="px-4 py-3 cursor-pointer hover:text-primary-400 text-gray-400 font-medium" @click="setSort('ticker_yf')">
              Symbol{{ sortIcon('ticker_yf') }}
            </th>
            <th class="px-4 py-3 text-gray-400 font-medium hidden md:table-cell">Sector</th>
            <th
              class="px-4 py-3 cursor-pointer hover:text-primary-400 text-gray-400 font-medium text-right"
              @click="setSort('health_score')"
            >
              <span class="text-gray-400">Score</span><span class="text-gray-500 font-normal">{{ healthScoreSortSuffix() }}</span>{{ sortIcon('health_score') }}
            </th>
            <th class="px-4 py-3 text-gray-400 font-medium text-center hidden sm:table-cell">Band</th>
            <th
              class="px-4 py-3 cursor-pointer hover:text-primary-400 text-gray-400 font-medium text-right"
              @click="setSort('last_close')"
            >
              Close{{ sortIcon('last_close') }}
            </th>
            <th class="px-4 py-3 text-gray-400 font-medium text-center">vs 52</th>
            <th class="px-4 py-3 text-gray-400 font-medium text-center hidden lg:table-cell">vs 200</th>
            <th
              class="px-4 py-3 cursor-pointer hover:text-primary-400 text-gray-400 font-medium text-right hidden xl:table-cell"
              @click="setSort('dist_ema_200')"
            >
              Δ% EMA200{{ sortIcon('dist_ema_200') }}
            </th>
            <th
              class="px-4 py-3 cursor-pointer hover:text-primary-400 text-gray-400 font-medium text-right"
              @click="setSort('rsi_14')"
            >
              RSI{{ sortIcon('rsi_14') }}
            </th>
            <th
              class="px-4 py-3 cursor-pointer hover:text-primary-400 text-gray-400 font-medium text-right hidden lg:table-cell"
              @click="setSort('macd')"
            >
              MACD{{ sortIcon('macd') }}
            </th>
            <th class="px-2 py-3 w-12"></th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading" class="border-b border-gray-800/50">
            <td colspan="11" class="px-4 py-8 text-center text-gray-500">Loading...</td>
          </tr>
          <tr v-else-if="stocks.length === 0" class="border-b border-gray-800/50">
            <td colspan="11" class="px-4 py-8 text-center">
              <p class="text-gray-400 mb-2">No stocks match these filters.</p>
              <p class="text-xs text-gray-600 mb-4 max-w-md mx-auto">
                If you used Strong + Quanfury + “only full EMA rows”, the intersection may be empty. Use the button below to load the whole database sorted by score.
              </p>
              <button type="button" class="btn-primary text-sm" @click="resetToGeneralBestFirst">
                All stocks · best score first
              </button>
            </td>
          </tr>
          <template v-else>
            <RouterLink
              v-for="row in stocks"
              :key="row.id"
              v-slot="{ navigate }"
              :to="{ name: 'StockDetail', params: { id: String(row.id) }, query: { fromScoreTrend: '1' } }"
              custom
            >
              <tr
                class="border-b border-gray-800/50 hover:bg-gray-800/50 cursor-pointer transition-colors"
                role="link"
                tabindex="0"
                @click="() => navigate()"
                @keydown.enter.prevent="() => navigate()"
              >
              <td class="px-4 py-3 font-mono font-medium text-white">{{ row.symbol }}</td>
              <td class="px-4 py-3 text-gray-400 text-xs hidden md:table-cell truncate max-w-[140px]">{{ row.sector || '—' }}</td>
              <td class="px-4 py-3 text-right">
                <span class="font-mono font-bold" :class="scoreColor(row.health_score)">{{ fmt(row.health_score, 1) }}</span>
              </td>
              <td class="px-4 py-3 text-center hidden sm:table-cell">
                <span
                  class="text-[10px] px-2 py-0.5 rounded border font-semibold whitespace-nowrap"
                  :class="scoreBg(row.health_score) + ' ' + scoreColor(row.health_score)"
                >
                  {{ scoreLabel(row.health_score) }}
                </span>
              </td>
              <td class="px-4 py-3 text-right font-mono text-gray-200">{{ fmt(row.last_close) }}</td>
              <td class="px-4 py-3 text-center">
                <span
                  class="text-[10px] px-2 py-0.5 rounded"
                  :class="vsBadge(vsEma(row.last_close, row.ema_52)).cls"
                >
                  {{ vsBadge(vsEma(row.last_close, row.ema_52)).text }}
                </span>
              </td>
              <td class="px-4 py-3 text-center hidden lg:table-cell">
                <span
                  class="text-[10px] px-2 py-0.5 rounded"
                  :class="vsBadge(vsEma(row.last_close, row.ema_200)).cls"
                >
                  {{ vsBadge(vsEma(row.last_close, row.ema_200)).text }}
                </span>
              </td>
              <td class="px-4 py-3 text-right font-mono text-gray-400 text-xs hidden xl:table-cell">
                {{ fmt(distPct(row.last_close, row.ema_200), 2) }}{{ distPct(row.last_close, row.ema_200) != null ? '%' : '' }}
              </td>
              <td class="px-4 py-3 text-right font-mono" :class="rsiColor(row.rsi_14)">{{ fmt(row.rsi_14, 0) }}</td>
              <td class="px-4 py-3 text-right font-mono hidden lg:table-cell" :class="(row.macd ?? 0) >= 0 ? 'text-green-400' : 'text-red-400'">
                {{ fmt(row.macd, 3) }}
              </td>
              <td class="px-2 py-3 text-center" @click.stop>
                <button
                  type="button"
                  class="p-1.5 rounded-lg text-gray-500 hover:text-red-400 hover:bg-red-950/40 transition-colors disabled:opacity-40"
                  :disabled="deletingId === row.id"
                  title="Remove from database"
                  @click="deleteStockRow(row)"
                >
                  <svg v-if="deletingId === row.id" class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                  </svg>
                  <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                </button>
              </td>
              </tr>
            </RouterLink>
          </template>
        </tbody>
      </table>
    </div>

    <div v-if="pages > 1" class="flex items-center justify-center gap-2 mt-6">
      <button type="button" class="btn-secondary text-sm px-3 py-1" :disabled="listState.page <= 1" @click="setPage(listState.page - 1)">
        Prev
      </button>
      <button
        v-for="p in pageNumbers"
        :key="p"
        type="button"
        @click="setPage(p)"
        :class="[
          'px-3 py-1 rounded-lg text-sm font-medium transition-colors',
          p === listState.page ? 'bg-primary-600 text-white' : 'bg-gray-800 text-gray-400 hover:bg-gray-700',
        ]"
      >
        {{ p }}
      </button>
      <button
        type="button"
        class="btn-secondary text-sm px-3 py-1"
        :disabled="listState.page >= pages"
        @click="setPage(listState.page + 1)"
      >
        Next
      </button>
    </div>
  </div>
</template>
