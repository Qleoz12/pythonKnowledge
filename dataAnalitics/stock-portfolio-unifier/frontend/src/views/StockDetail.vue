<script setup lang="ts">
import { onMounted, ref, computed, watch, nextTick } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useStocksStore } from '../stores/stocks'
import { usePortfoliosStore } from '../stores/portfolios'
import { refreshStock, deleteStock } from '../services/api'
import StockChart from '../components/StockChart.vue'
import PriceFairValuePanel from '../components/PriceFairValuePanel.vue'
import PriceNormalizationPanel from '../components/PriceNormalizationPanel.vue'

const route = useRoute()
const router = useRouter()
const stocksStore = useStocksStore()
const portfoliosStore = usePortfoliosStore()

const showAddToPortfolio = ref(false)
const selectedPortfolioId = ref<number | null>(null)
const addShares = ref(1)
const addPrice = ref(0)
const refreshing = ref(false)
const refreshMsg = ref('')
const deleting = ref(false)

/** Exposed `load` from PriceNormalizationPanel — Yahoo fundamentals block */
const priceNormPanel = ref<{ load: () => Promise<void> } | null>(null)

const stock = computed(() => stocksStore.currentStock)

const dataMissing = computed(() => {
  if (!stock.value) return false
  return !stock.value.last_close || !stock.value.week_52_high
})

async function loadStockData(id: number) {
  await Promise.all([
    stocksStore.loadStock(id),
    portfoliosStore.loadPortfolios(),
  ])
  if (stock.value?.last_close) {
    addPrice.value = stock.value.last_close
  }
  await nextTick()
  await runAutoPipelineFromScoreTrend()
}

/** From Score vs trend: refresh DB row from Yahoo, then load live Yahoo fundamentals panel. */
async function runAutoPipelineFromScoreTrend() {
  if (route.query.fromScoreTrend !== '1' || !stock.value) return
  const id = stock.value.id
  try {
    await triggerRefresh()
    await nextTick()
    await priceNormPanel.value?.load()
  } finally {
    if (String(route.params.id) === String(id)) {
      await router.replace({ name: 'StockDetail', params: { id: String(id) } })
    }
  }
}

async function triggerRefresh() {
  if (!stock.value || refreshing.value) return
  refreshing.value = true
  refreshMsg.value = ''
  try {
    const result = await refreshStock(stock.value.id)
    await stocksStore.loadStock(stock.value.id)
    if (result.last_close) {
      refreshMsg.value = `Updated: price ${result.last_close}, sector ${result.sector || 'N/A'}`
    } else {
      refreshMsg.value = 'Yahoo Finance could not find price data (stock may be delisted). Sector info was updated if available.'
    }
  } catch (e: any) {
    refreshMsg.value = `Refresh failed: ${e.message}`
  } finally {
    refreshing.value = false
  }
}

onMounted(() => loadStockData(Number(route.params.id)))

watch(() => route.params.id, (newId) => {
  if (newId) {
    showAddToPortfolio.value = false
    refreshMsg.value = ''
    loadStockData(Number(newId))
  }
})

function fmt(n: number | null | undefined, decimals = 2): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}

function rawRangePct(price: number | null, high: number | null, low: number | null): number {
  if (!price || !high || !low || high === low) return 0
  return Math.round(((price - low) / (high - low)) * 100)
}

function rangePct(price: number | null, high: number | null, low: number | null): number {
  return Math.max(0, Math.min(100, rawRangePct(price, high, low)))
}

function distanceFromLow(price: number | null, low: number | null): number | null {
  if (!price || !low || low === 0) return null
  return ((price - low) / low) * 100
}

function distanceFromHigh(price: number | null, high: number | null): number | null {
  if (!price || !high || high === 0) return null
  return ((price - high) / high) * 100
}

function proximitySignal(pct: number): { label: string; color: string; bgColor: string } {
  if (pct <= 5) return { label: 'Very Near', color: 'text-red-400', bgColor: 'bg-red-900/30 border-red-800' }
  if (pct <= 10) return { label: 'Near', color: 'text-yellow-400', bgColor: 'bg-yellow-900/30 border-yellow-800' }
  return { label: 'Far', color: 'text-gray-400', bgColor: 'bg-gray-800 border-gray-700' }
}

function rangeBarColor(pct: number): string {
  if (pct <= 15) return 'bg-red-500'
  if (pct <= 30) return 'bg-orange-500'
  if (pct <= 70) return 'bg-yellow-500'
  if (pct <= 85) return 'bg-lime-500'
  return 'bg-green-500'
}

const priceAnalysis = computed(() => {
  if (!stock.value) return null
  const s = stock.value
  const price = s.last_close

  const ranges = [
    { label: '52 Week', weeks: 52, high: s.week_52_high, low: s.week_52_low },
    { label: '100 Week', weeks: 100, high: s.week_100_high, low: s.week_100_low },
    { label: '200 Week', weeks: 200, high: s.week_200_high, low: s.week_200_low },
  ]

  return ranges.map(r => {
    const raw = rawRangePct(price, r.high, r.low)
    const stale = raw < 0 || raw > 100
    const pct = Math.max(0, Math.min(100, raw))
    const fromLow = distanceFromLow(price, r.low)
    const fromHigh = distanceFromHigh(price, r.high)
    const lowSignal = fromLow !== null ? proximitySignal(Math.abs(fromLow)) : null
    const highSignal = fromHigh !== null ? proximitySignal(Math.abs(fromHigh)) : null

    return {
      ...r,
      pct,
      stale,
      fromLow,
      fromHigh,
      lowSignal,
      highSignal,
      barColor: rangeBarColor(pct),
      isNearLow: !stale && pct <= 15,
      isNearHigh: !stale && pct >= 85,
    }
  })
})

const divHistoryStats = computed(() => {
  if (!stock.value?.dividend_history?.length) return null
  const hist = stock.value.dividend_history
  const amounts = hist.map(d => d.amount)
  const min = Math.min(...amounts)
  const max = Math.max(...amounts)
  const avg = amounts.reduce((a, b) => a + b, 0) / amounts.length
  const latest = amounts[0]
  const growing = amounts.length >= 2 && amounts[0] >= amounts[1]

  return { min, max, avg, latest, count: hist.length, growing }
})

const externalLinks = computed(() => {
  if (!stock.value) return []
  const sym = stock.value.symbol
  const tickerYf = stock.value.ticker_yf
  const exc = stock.value.exchange_code

  let tvSymbol = sym
  if (exc === 'TSX') tvSymbol = `TSX:${sym}`
  else if (exc === 'NYSE') tvSymbol = `NYSE:${sym}`
  else if (exc === 'NASDAQ') tvSymbol = `NASDAQ:${sym}`
  else if (exc === 'LSE') tvSymbol = `LSE:${sym}`

  return [
    {
      name: 'TradingView',
      url: `https://www.tradingview.com/symbols/${tvSymbol}/`,
      color: 'hover:text-blue-400',
      icon: 'M3 3v18h18V3H3zm16 16H5V5h14v14zm-2-4l-4-4-3 3-3-3v6h10v-2z',
    },
    {
      name: 'Finviz',
      url: `https://finviz.com/quote.ashx?t=${sym}`,
      color: 'hover:text-green-400',
      icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z',
    },
    {
      name: 'Yahoo Finance',
      url: `https://finance.yahoo.com/quote/${tickerYf}/`,
      color: 'hover:text-purple-400',
      icon: 'M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
    },
    {
      name: 'Google Finance',
      url: `https://www.google.com/finance/quote/${sym}:${exc === 'TSX' ? 'TSE' : exc || 'NYSE'}`,
      color: 'hover:text-yellow-400',
      icon: 'M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z',
    },
  ]
})

function fmtBig(n: number | null | undefined): string {
  if (n === null || n === undefined) return '—'
  const abs = Math.abs(n)
  const sign = n < 0 ? '-' : ''
  if (abs >= 1e12) return sign + (abs / 1e12).toFixed(1) + 'T'
  if (abs >= 1e9) return sign + (abs / 1e9).toFixed(1) + 'B'
  if (abs >= 1e6) return sign + (abs / 1e6).toFixed(1) + 'M'
  if (abs >= 1e3) return sign + (abs / 1e3).toFixed(1) + 'K'
  return sign + abs.toFixed(0)
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

const healthIndicators = computed(() => {
  if (!stock.value) return []
  const s = stock.value
  const indicators = []

  indicators.push({
    name: 'Net Income Margin',
    value: s.net_income_margin,
    display: s.net_income_margin !== null ? fmt(s.net_income_margin, 1) + '%' : '—',
    good: s.net_income_margin !== null && s.net_income_margin > 0,
    desc: 'Revenue kept as profit after all expenses',
    weight: '25%',
  })

  indicators.push({
    name: 'Return on Assets',
    value: s.return_on_assets,
    display: s.return_on_assets !== null ? fmt(s.return_on_assets, 1) + '%' : '—',
    good: s.return_on_assets !== null && s.return_on_assets > 0,
    desc: 'Efficiency using company assets to generate profit',
    weight: '20%',
  })

  indicators.push({
    name: 'Free Cash Flow',
    value: s.free_cash_flow,
    display: s.free_cash_flow !== null ? fmtBig(s.free_cash_flow) : '—',
    good: s.free_cash_flow !== null && s.free_cash_flow > 0,
    desc: 'Cash generated after capital expenditures',
    weight: '25%',
  })

  indicators.push({
    name: 'Debt / Equity',
    value: s.debt_to_equity,
    display: s.debt_to_equity !== null ? fmt(s.debt_to_equity, 0) + '%' : '—',
    good: s.debt_to_equity !== null && s.debt_to_equity < 100,
    desc: 'Total debt relative to shareholder equity',
    weight: '15%',
  })

  const price = s.last_close
  const belowEmaCount = price ? [s.ema_20, s.ema_52, s.ema_200].filter(e => e && price < e).length : 0
  indicators.push({
    name: 'EMA Position',
    value: belowEmaCount,
    display: price ? `Below ${belowEmaCount}/3 EMAs` : '—',
    good: belowEmaCount >= 2,
    desc: 'Price below EMAs signals potential value entry',
    weight: '15%',
  })

  return indicators
})

async function addToPortfolio() {
  if (!selectedPortfolioId.value || !stock.value) return
  await portfoliosStore.addStock(selectedPortfolioId.value, stock.value.id, addShares.value, addPrice.value)
  showAddToPortfolio.value = false
}

async function removeStockFromDatabase() {
  if (!stock.value || deleting.value) return
  const s = stock.value
  const pf = s.portfolios?.length
    ? ` It will be removed from ${s.portfolios.length} portfolio(s).`
    : ''
  const ok = window.confirm(
    `Remove ${s.ticker_yf} (${s.symbol}) from the database?${pf} Dividends, fair value revisions, chart data, and cached prices for this ticker will be deleted. This cannot be undone.`,
  )
  if (!ok) return
  deleting.value = true
  try {
    await deleteStock(s.id)
    stocksStore.currentStock = null
    await portfoliosStore.loadPortfolios()
    router.push('/stocks')
  } catch (e: any) {
    refreshMsg.value = `Delete failed: ${e.response?.data?.detail || e.message}`
  } finally {
    deleting.value = false
  }
}
</script>

<template>
  <div>
    <button @click="router.back()" class="text-gray-400 hover:text-white text-sm mb-4 flex items-center gap-1">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
      </svg>
      Back
    </button>

    <div v-if="stocksStore.loading" class="text-gray-400 py-20 text-center">Loading...</div>

    <template v-else-if="stock">
      <!-- Missing data banner -->
      <div v-if="dataMissing && !refreshing" class="mb-6 p-4 bg-amber-900/30 border border-amber-700 rounded-xl flex items-center justify-between">
        <div class="flex items-center gap-3">
          <svg class="w-6 h-6 text-amber-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z" />
          </svg>
          <div>
            <p class="text-sm font-medium text-amber-300">Missing price data</p>
            <p class="text-xs text-amber-400/70">This stock was imported from CSV without real-time data. Click refresh to fetch from Yahoo Finance.</p>
          </div>
        </div>
        <button @click="triggerRefresh" class="btn-primary text-sm whitespace-nowrap ml-4">
          Fetch Data
        </button>
      </div>

      <!-- Refreshing indicator -->
      <div v-if="refreshing" class="mb-6 p-4 bg-blue-900/30 border border-blue-700 rounded-xl flex items-center gap-3">
        <svg class="w-5 h-5 text-blue-400 animate-spin" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
        </svg>
        <p class="text-sm text-blue-300">Fetching data from Yahoo Finance...</p>
      </div>

      <!-- Refresh result -->
      <div v-if="refreshMsg && !refreshing" class="mb-6 p-3 rounded-xl text-sm"
        :class="refreshMsg.includes('failed') ? 'bg-red-900/30 border border-red-700 text-red-300' : 'bg-green-900/30 border border-green-700 text-green-300'">
        {{ refreshMsg }}
      </div>

      <!-- Header -->
      <div class="flex items-start justify-between mb-8">
        <div>
          <div class="flex items-center gap-3">
            <h1 class="text-3xl font-bold text-white font-mono">{{ stock.symbol }}</h1>
            <span class="badge-blue">{{ stock.exchange_code }}</span>
            <span v-if="stock.is_quanfury_available" class="badge-purple">Quanfury</span>
          </div>
          <p class="text-gray-400 mt-1">{{ stock.company_name }}</p>
          <p class="text-sm text-gray-500 mt-1">{{ stock.sector }} · {{ stock.currency }} · {{ stock.ticker_yf }}</p>
          <div class="flex items-center gap-3 mt-2">
            <a v-for="link in externalLinks" :key="link.name"
              :href="link.url" target="_blank" rel="noopener noreferrer"
              class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-gray-800 border border-gray-700 text-xs text-gray-400 transition-colors"
              :class="link.color">
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="link.icon" />
              </svg>
              {{ link.name }}
              <svg class="w-2.5 h-2.5 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
              </svg>
            </a>
          </div>
        </div>
        <div class="text-right">
          <p class="text-3xl font-bold text-white font-mono">{{ fmt(stock.last_close) }}</p>
          <p class="text-sm text-gray-400">{{ stock.currency }}</p>
          <div class="flex items-center gap-2 mt-2 justify-end">
            <button @click="triggerRefresh" :disabled="refreshing"
              class="text-xs px-3 py-1.5 rounded-lg bg-gray-700 hover:bg-gray-600 text-gray-300 transition-colors"
              :title="'Refresh from Yahoo Finance'">
              <svg v-if="refreshing" class="w-3.5 h-3.5 animate-spin inline mr-1" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
              Refresh
            </button>
            <button @click="showAddToPortfolio = !showAddToPortfolio" class="btn-primary text-sm">
              + Add to Portfolio
            </button>
            <button
              type="button"
              @click="removeStockFromDatabase"
              :disabled="deleting"
              class="text-xs px-3 py-1.5 rounded-lg border border-red-800 bg-red-950/40 text-red-300 hover:bg-red-900/50 transition-colors disabled:opacity-50"
              title="Remove this ticker from the database"
            >
              {{ deleting ? 'Removing…' : 'Remove from database' }}
            </button>
          </div>
        </div>
      </div>

      <!-- Add to portfolio panel -->
      <div v-if="showAddToPortfolio" class="card mb-6">
        <h3 class="text-sm font-medium text-white mb-3">Add to Portfolio</h3>
        <div class="flex items-end gap-4 flex-wrap">
          <div>
            <label class="text-xs text-gray-400">Portfolio</label>
            <select v-model="selectedPortfolioId" class="input-field mt-1">
              <option :value="null" disabled>Select portfolio</option>
              <option v-for="p in portfoliosStore.portfolios" :key="p.id" :value="p.id">{{ p.name }}</option>
            </select>
          </div>
          <div>
            <label class="text-xs text-gray-400">Shares</label>
            <input v-model.number="addShares" type="number" min="0.01" step="0.01" class="input-field mt-1 w-28" />
          </div>
          <div>
            <label class="text-xs text-gray-400">Avg Price</label>
            <input v-model.number="addPrice" type="number" min="0" step="0.01" class="input-field mt-1 w-32" />
          </div>
          <button @click="addToPortfolio" :disabled="!selectedPortfolioId" class="btn-primary">Add</button>
        </div>
      </div>

      <!-- OHLC: solo velas/EMA (sin FVE) -->
      <StockChart
        v-if="stock.last_close"
        :stock-id="stock.id"
        :ticker-yf="stock.ticker_yf"
        class="mb-8"
      />

      <PriceFairValuePanel
        v-if="stock.last_close"
        :stock-id="stock.id"
        :ticker-yf="stock.ticker_yf"
      />

      <!-- Key metrics -->
      <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4 mb-8">
        <div class="card !p-4">
          <p class="text-xs text-gray-400">Div Yield TTM</p>
          <p class="text-xl font-bold text-green-400">{{ stock.div_yield_ttm ? fmt(stock.div_yield_ttm) + '%' : '—' }}</p>
        </div>
        <div class="card !p-4">
          <p class="text-xs text-gray-400">Dividend TTM</p>
          <p class="text-xl font-bold text-white">{{ fmt(stock.dividend_ttm) }}</p>
          <p class="text-xs text-gray-500">{{ stock.div_freq || '—' }}</p>
        </div>
        <div class="card !p-4">
          <p class="text-xs text-gray-400">RSI (14)</p>
          <p class="text-xl font-bold" :class="(stock.rsi_14 ?? 50) > 70 ? 'text-red-400' : (stock.rsi_14 ?? 50) < 30 ? 'text-green-400' : 'text-white'">
            {{ fmt(stock.rsi_14, 1) }}
          </p>
        </div>
        <div class="card !p-4">
          <p class="text-xs text-gray-400">Max Drawdown</p>
          <p class="text-xl font-bold text-red-400">{{ fmt(stock.max_drawdown, 1) }}%</p>
        </div>
        <div class="card !p-4">
          <p class="text-xs text-gray-400">MACD</p>
          <p class="text-xl font-bold" :class="(stock.macd ?? 0) >= 0 ? 'text-green-400' : 'text-red-400'">
            {{ fmt(stock.macd, 3) }}
          </p>
          <p class="text-xs text-gray-500">Signal: {{ fmt(stock.macd_signal, 3) }}</p>
        </div>
        <div class="card !p-4">
          <p class="text-xs text-gray-400">EPS Est / Report</p>
          <p class="text-lg font-bold text-white">{{ fmt(stock.eps_estimate) }} / {{ fmt(stock.reported_eps) }}</p>
          <p class="text-xs" :class="(stock.surprise_pct ?? 0) >= 0 ? 'text-green-400' : 'text-red-400'">
            {{ stock.surprise_pct ? fmt(stock.surprise_pct, 1) + '% surprise' : '' }}
          </p>
        </div>
      </div>

      <!-- Financial Health Score -->
      <div class="card mb-8" v-if="stock.health_score !== null || healthIndicators.some(i => i.value !== null)">
        <div class="flex items-center justify-between mb-4">
          <div>
            <h3 class="text-lg font-semibold text-white">Financial Health Score</h3>
            <p class="text-sm text-gray-400">Based on financial statements analysis</p>
          </div>
          <div class="text-right">
            <div class="flex items-center gap-3">
              <div class="text-3xl font-bold font-mono" :class="scoreColor(stock.health_score)">
                {{ stock.health_score !== null ? stock.health_score : '—' }}
              </div>
              <div>
                <span class="text-xs px-2 py-0.5 rounded border font-semibold" :class="scoreBg(stock.health_score) + ' ' + scoreColor(stock.health_score)">
                  {{ scoreLabel(stock.health_score) }}
                </span>
                <p class="text-[10px] text-gray-500 mt-1">/ 100</p>
              </div>
            </div>
          </div>
        </div>

        <div class="mb-4 h-2 bg-gray-800 rounded-full overflow-hidden">
          <div class="h-full rounded-full transition-all duration-500"
            :class="(stock.health_score ?? 0) >= 70 ? 'bg-green-500' : (stock.health_score ?? 0) >= 45 ? 'bg-yellow-500' : (stock.health_score ?? 0) >= 25 ? 'bg-orange-500' : 'bg-red-500'"
            :style="{ width: Math.min(100, stock.health_score ?? 0) + '%' }">
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3 mb-4">
          <div v-if="stock.revenue !== null" class="p-3 bg-gray-800/50 rounded-lg">
            <p class="text-xs text-gray-500">Revenue</p>
            <p class="text-sm font-mono font-medium text-white">{{ fmtBig(stock.revenue) }}</p>
          </div>
          <div v-if="stock.net_income !== null" class="p-3 bg-gray-800/50 rounded-lg">
            <p class="text-xs text-gray-500">Net Income</p>
            <p class="text-sm font-mono font-medium" :class="(stock.net_income ?? 0) >= 0 ? 'text-green-400' : 'text-red-400'">{{ fmtBig(stock.net_income) }}</p>
          </div>
          <div v-if="stock.operating_cash_flow !== null" class="p-3 bg-gray-800/50 rounded-lg">
            <p class="text-xs text-gray-500">Operating Cash Flow</p>
            <p class="text-sm font-mono font-medium" :class="(stock.operating_cash_flow ?? 0) >= 0 ? 'text-green-400' : 'text-red-400'">{{ fmtBig(stock.operating_cash_flow) }}</p>
          </div>
          <div v-if="stock.free_cash_flow !== null" class="p-3 bg-gray-800/50 rounded-lg">
            <p class="text-xs text-gray-500">Free Cash Flow</p>
            <p class="text-sm font-mono font-medium" :class="(stock.free_cash_flow ?? 0) >= 0 ? 'text-green-400' : 'text-red-400'">{{ fmtBig(stock.free_cash_flow) }}</p>
          </div>
          <div v-if="stock.total_debt !== null" class="p-3 bg-gray-800/50 rounded-lg">
            <p class="text-xs text-gray-500">Total Debt</p>
            <p class="text-sm font-mono font-medium text-white">{{ fmtBig(stock.total_debt) }}</p>
          </div>
          <div v-if="stock.fcf_yield !== null" class="p-3 bg-gray-800/50 rounded-lg">
            <p class="text-xs text-gray-500">FCF Yield</p>
            <p class="text-sm font-mono font-medium" :class="(stock.fcf_yield ?? 0) >= 0 ? 'text-green-400' : 'text-red-400'">{{ fmt(stock.fcf_yield, 1) }}%</p>
          </div>
        </div>

        <div class="border-t border-gray-800 pt-4">
          <p class="text-xs text-gray-500 mb-3">Score Breakdown</p>
          <div class="space-y-2">
            <div v-for="ind in healthIndicators" :key="ind.name" class="flex items-center gap-3">
              <div class="w-3 h-3 rounded-full flex-shrink-0" :class="ind.value === null ? 'bg-gray-700' : ind.good ? 'bg-green-500' : 'bg-red-500'"></div>
              <div class="flex-1 min-w-0">
                <div class="flex items-center justify-between">
                  <span class="text-xs text-gray-300">{{ ind.name }}</span>
                  <span class="text-xs font-mono" :class="ind.value === null ? 'text-gray-600' : ind.good ? 'text-green-400' : 'text-red-400'">
                    {{ ind.display }}
                  </span>
                </div>
                <p class="text-[10px] text-gray-600">{{ ind.desc }} · Weight: {{ ind.weight }}</p>
              </div>
            </div>
          </div>
          <router-link to="/score" class="text-xs text-primary-400 hover:text-primary-300 mt-3 inline-block">
            How is this score calculated?
          </router-link>
        </div>
      </div>

      <PriceNormalizationPanel ref="priceNormPanel" :stock-id="stock.id" />

      <!-- Price Range Analysis (min/max) -->
      <div class="card mb-8" v-if="priceAnalysis">
        <h3 class="text-lg font-semibold text-white mb-2">Price Range Analysis</h3>
        <p class="text-sm text-gray-400 mb-5">Current price position relative to historical highs and lows</p>

        <div class="space-y-6">
          <div v-for="range in priceAnalysis" :key="range.label">
            <div v-if="range.stale" class="flex items-center gap-2 mb-2 px-3 py-1.5 bg-amber-900/20 border border-amber-800/40 rounded-lg">
              <span class="text-[10px] font-semibold text-amber-400">STALE DATA</span>
              <span class="text-[10px] text-amber-500/80">Range values look wrong for this price. Click Refresh to fix.</span>
            </div>
            <div class="flex items-center justify-between mb-2">
              <div class="flex items-center gap-3">
                <span class="text-sm font-medium text-white">{{ range.label }}</span>
                <span v-if="range.isNearLow"
                  class="inline-flex items-center gap-1 px-2 py-0.5 rounded text-[10px] font-semibold bg-red-900/40 text-red-400 border border-red-800">
                  NEAR LOW
                </span>
                <span v-if="range.isNearHigh"
                  class="inline-flex items-center gap-1 px-2 py-0.5 rounded text-[10px] font-semibold bg-green-900/40 text-green-400 border border-green-800">
                  NEAR HIGH
                </span>
              </div>
              <span class="text-sm font-mono font-bold" :class="range.stale ? 'text-amber-400' : range.pct <= 30 ? 'text-red-400' : range.pct >= 70 ? 'text-green-400' : 'text-yellow-400'">
                {{ range.stale ? 'N/A' : range.pct + '% of range' }}
              </span>
            </div>

            <!-- Range bar -->
            <div class="flex items-center gap-3 mb-2">
              <div class="text-right min-w-[70px]">
                <p class="text-xs text-red-400 font-mono">{{ fmt(range.low, 2) }}</p>
                <p class="text-[10px] text-gray-500">Low</p>
              </div>
              <div class="flex-1 h-3 bg-gray-700 rounded-full relative overflow-hidden">
                <div class="absolute h-full rounded-full transition-all duration-300"
                  :class="range.barColor"
                  :style="{ width: Math.min(100, Math.max(2, range.pct)) + '%' }">
                </div>
                <div class="absolute top-0 h-full w-0.5 bg-white/60"
                  :style="{ left: Math.min(98, Math.max(2, range.pct)) + '%' }">
                </div>
              </div>
              <div class="min-w-[70px]">
                <p class="text-xs text-green-400 font-mono">{{ fmt(range.high, 2) }}</p>
                <p class="text-[10px] text-gray-500">High</p>
              </div>
            </div>

            <!-- Distance metrics -->
            <div class="flex items-center gap-6 text-xs">
              <div class="flex items-center gap-2">
                <span class="text-gray-500">From Low:</span>
                <span class="font-mono" :class="(range.fromLow ?? 0) <= 10 ? 'text-red-400 font-bold' : 'text-gray-300'">
                  +{{ fmt(range.fromLow, 1) }}%
                </span>
                <span v-if="range.lowSignal"
                  class="px-1.5 py-0.5 rounded text-[9px] font-medium border"
                  :class="range.lowSignal.bgColor">
                  {{ range.lowSignal.label }}
                </span>
              </div>
              <div class="flex items-center gap-2">
                <span class="text-gray-500">From High:</span>
                <span class="font-mono" :class="Math.abs(range.fromHigh ?? 0) <= 10 ? 'text-green-400 font-bold' : 'text-gray-300'">
                  {{ fmt(range.fromHigh, 1) }}%
                </span>
                <span v-if="range.highSignal"
                  class="px-1.5 py-0.5 rounded text-[9px] font-medium border"
                  :class="range.highSignal.bgColor">
                  {{ range.highSignal.label }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- EMAs & Moving Averages -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <div class="card">
          <h3 class="text-lg font-semibold text-white mb-4">Moving Averages</h3>
          <div class="space-y-3">
            <div v-for="ema in [
              { label: 'EMA 20', value: stock.ema_20, color: 'bg-blue-500' },
              { label: 'EMA 52', value: stock.ema_52, color: 'bg-yellow-500' },
              { label: 'EMA 200', value: stock.ema_200, color: 'bg-red-500' },
            ]" :key="ema.label" class="flex items-center justify-between">
              <div class="flex items-center gap-2">
                <div :class="ema.color" class="w-3 h-3 rounded-full"></div>
                <span class="text-sm text-gray-300">{{ ema.label }}</span>
              </div>
              <div class="flex items-center gap-3">
                <span class="font-mono text-white">{{ fmt(ema.value) }}</span>
                <span v-if="ema.value && stock.last_close" class="text-xs font-mono"
                  :class="stock.last_close >= ema.value ? 'text-green-400' : 'text-red-400'">
                  {{ stock.last_close >= ema.value ? 'Above' : 'Below' }}
                </span>
              </div>
            </div>
          </div>

          <div v-if="stock.next_earnings_date" class="mt-5 pt-4 border-t border-gray-800">
            <p class="text-xs text-gray-400">Next Earnings</p>
            <p class="text-sm font-medium text-white mt-1">{{ stock.next_earnings_date }}</p>
          </div>
        </div>

        <!-- Dividend Stats -->
        <div class="card">
          <h3 class="text-lg font-semibold text-white mb-4">Dividend Summary</h3>
          <template v-if="divHistoryStats">
            <div class="grid grid-cols-2 gap-4 mb-4">
              <div>
                <p class="text-xs text-gray-400">Highest Payment</p>
                <p class="text-lg font-bold text-green-400 font-mono">{{ fmt(divHistoryStats.max, 4) }}</p>
              </div>
              <div>
                <p class="text-xs text-gray-400">Lowest Payment</p>
                <p class="text-lg font-bold text-red-400 font-mono">{{ fmt(divHistoryStats.min, 4) }}</p>
              </div>
              <div>
                <p class="text-xs text-gray-400">Average Payment</p>
                <p class="text-lg font-bold text-white font-mono">{{ fmt(divHistoryStats.avg, 4) }}</p>
              </div>
              <div>
                <p class="text-xs text-gray-400">Total Payments</p>
                <p class="text-lg font-bold text-white">{{ divHistoryStats.count }}</p>
              </div>
            </div>
            <div class="flex items-center gap-2 text-sm">
              <span class="text-gray-400">Trend:</span>
              <span :class="divHistoryStats.growing ? 'text-green-400' : 'text-red-400'" class="font-medium">
                {{ divHistoryStats.growing ? 'Growing' : 'Declining' }}
              </span>
              <span class="text-gray-500">vs previous</span>
            </div>
          </template>
          <p v-else class="text-gray-500 text-sm">No dividend data available.</p>
        </div>
      </div>

      <!-- Dividend History Table -->
      <div class="card mb-8">
        <h3 class="text-lg font-semibold text-white mb-4">
          Dividend History
          <span class="text-sm text-gray-400 font-normal ml-2">({{ stock.dividend_history.length }} events)</span>
        </h3>
        <div v-if="stock.dividend_history.length > 0" class="overflow-x-auto max-h-[400px] overflow-y-auto">
          <table class="w-full text-sm">
            <thead class="sticky top-0 bg-gray-900">
              <tr class="border-b border-gray-800 text-gray-400">
                <th class="px-4 py-2 text-left font-medium">Date</th>
                <th class="px-4 py-2 text-right font-medium">Amount</th>
                <th class="px-4 py-2 text-right font-medium">vs Avg</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="d in stock.dividend_history" :key="d.date" class="border-b border-gray-800/50">
                <td class="px-4 py-2 text-gray-300 font-mono">{{ d.date }}</td>
                <td class="px-4 py-2 text-right text-green-400 font-mono">{{ fmt(d.amount, 4) }}</td>
                <td class="px-4 py-2 text-right font-mono text-xs"
                  :class="divHistoryStats && d.amount >= divHistoryStats.avg ? 'text-green-400' : 'text-red-400'">
                  <template v-if="divHistoryStats">
                    {{ d.amount >= divHistoryStats.avg ? '+' : '' }}{{ fmt((d.amount - divHistoryStats.avg) / divHistoryStats.avg * 100, 1) }}%
                  </template>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <p v-else class="text-gray-500 text-sm">No dividend history available.</p>
      </div>

      <!-- In portfolios -->
      <div v-if="stock.portfolios.length > 0" class="card">
        <h3 class="text-lg font-semibold text-white mb-4">In Portfolios</h3>
        <div class="flex flex-wrap gap-3">
          <RouterLink
            v-for="p in stock.portfolios"
            :key="p.id"
            :to="`/portfolios/${p.id}`"
            class="flex items-center gap-2 px-3 py-2 bg-gray-800 rounded-lg hover:bg-gray-700 transition-colors"
          >
            <span class="text-sm text-white">{{ p.name }}</span>
            <span class="text-xs text-gray-400">{{ p.shares }} shares</span>
          </RouterLink>
        </div>
      </div>
    </template>
  </div>
</template>
