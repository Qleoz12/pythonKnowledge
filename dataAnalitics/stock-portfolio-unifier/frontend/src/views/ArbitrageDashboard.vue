<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import {
  fetchArbitrageSummary,
  fetchArbitrageLiveRates,
  fetchArbitrageCachedRates,
  fetchArbitrageHistory,
  fetchArbitrageSources,
  fetchArbitrageOperations,
  fetchArbitrageStats,
  createArbitrageOperation,
} from '../services/api'
import type {
  ArbitrageSummary,
  ArbitrageRateItem,
  ArbitragePairSummary,
  ArbitrageOperation,
  ArbitrageStats,
  ArbitrageSource,
} from '../types'
import {
  arbitrageSourceTradeUrl,
  arbitrageSourcePlatformLabel,
} from '../utils/arbitragePlatformLinks'

// ─── State ───────────────────────────────────────────────────────────────────
const loading = ref(false)
const loadingHistory = ref(false)
const summary = ref<ArbitrageSummary | null>(null)
const allRates = ref<ArbitrageRateItem[]>([])
const sources = ref<ArbitrageSource[]>([])
const operations = ref<ArbitrageOperation[]>([])
const stats = ref<ArbitrageStats | null>(null)
const historyData = ref<Array<{ source: string; mid: number | null; fetched_at: string }>>([])
const selectedPair = ref('USDT/COP')
const selectedHistoryHours = ref(24)
const autoRefresh = ref(false)
const lastRefreshed = ref<string | null>(null)
const error = ref<string | null>(null)
let refreshTimer: ReturnType<typeof setInterval> | null = null

// ─── Op form ─────────────────────────────────────────────────────────────────
const showOpForm = ref(false)
const opForm = ref({
  pair: 'USDT/COP',
  buy_source: '',
  sell_source: '',
  buy_price: 0,
  sell_price: 0,
  amount_usdt: 100,
  fee_total: 0,
  notes: '',
})
const savingOp = ref(false)

// ─── Computed ─────────────────────────────────────────────────────────────────
const keyPairs = ['USDT/COP', 'USDT/CAD', 'USD/COP', 'USD/CAD', 'COP/CAD', 'BTC/USD', 'BTC/CAD', 'ETH/USD']

const pairMap = computed(() => {
  const m: Record<string, ArbitragePairSummary> = {}
  if (summary.value) {
    for (const p of summary.value.pairs) m[p.pair] = p
  }
  return m
})

const ratesByPair = computed(() => {
  const m: Record<string, ArbitrageRateItem[]> = {}
  for (const r of allRates.value) {
    if (!m[r.pair]) m[r.pair] = []
    m[r.pair].push(r)
  }
  return m
})

const availablePairs = computed(() => Object.keys(ratesByPair.value).sort())

const selectedPairRates = computed(() =>
  (ratesByPair.value[selectedPair.value] || []).sort((a, b) => {
    const am = a.mid ?? a.ask ?? a.bid ?? 0
    const bm = b.mid ?? b.ask ?? b.bid ?? 0
    return bm - am
  })
)

const opportunity = computed(() => summary.value?.opportunity ?? null)

const opProfit = computed(() => {
  if (!opForm.value.buy_price || !opForm.value.sell_price || !opForm.value.amount_usdt) return null
  const gross = (opForm.value.sell_price - opForm.value.buy_price) * opForm.value.amount_usdt
  const net = gross - opForm.value.fee_total
  const pct = (net / (opForm.value.buy_price * opForm.value.amount_usdt)) * 100
  return { gross: gross.toFixed(4), net: net.toFixed(4), pct: pct.toFixed(3) }
})

// ─── Helpers ─────────────────────────────────────────────────────────────────
function fmt(val: number | null | undefined, decimals = 2): string {
  if (val == null) return '—'
  return val.toLocaleString('en-CA', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}

function fmtBig(val: number | null | undefined): string {
  if (val == null) return '—'
  if (val >= 1_000_000) return (val / 1_000_000).toFixed(2) + 'M'
  if (val >= 1_000) return (val / 1_000).toFixed(1) + 'K'
  return val.toFixed(2)
}

function spreadColor(pct: number | null): string {
  if (pct == null) return 'text-gray-400'
  if (pct > 2) return 'text-emerald-400'
  if (pct > 1) return 'text-yellow-400'
  if (pct > 0) return 'text-orange-400'
  return 'text-red-400'
}

function profitColor(pct: number): string {
  if (pct > 2) return 'text-emerald-400'
  if (pct > 0) return 'text-yellow-400'
  return 'text-red-400'
}

function timeAgo(iso: string): string {
  const diff = (Date.now() - new Date(iso).getTime()) / 1000
  if (diff < 60) return `${Math.round(diff)}s ago`
  if (diff < 3600) return `${Math.round(diff / 60)}m ago`
  return `${Math.round(diff / 3600)}h ago`
}

function tradeUrlForRate(rate: ArbitrageRateItem): string | null {
  return arbitrageSourceTradeUrl(rate.source, rate.pair)
}

function sourceBadge(source: string): string {
  if (source.startsWith('criptoya')) return 'bg-purple-900/50 text-purple-300'
  if (source.startsWith('binance')) return 'bg-yellow-900/50 text-yellow-300'
  if (source === 'coingecko') return 'bg-teal-900/50 text-teal-300'
  if (source === 'kraken') return 'bg-blue-900/50 text-blue-300'
  if (source === 'coinbase') return 'bg-sky-900/50 text-sky-300'
  if (source === 'blockchain_info') return 'bg-orange-900/50 text-orange-300'
  if (source === 'exchangerate_api') return 'bg-green-900/50 text-green-300'
  if (source === 'bitso') return 'bg-pink-900/50 text-pink-300'
  return 'bg-gray-800 text-gray-300'
}

// ─── History chart (simple SVG sparkline) ─────────────────────────────────────
const chartPoints = computed(() => {
  const pts = historyData.value
    .filter(d => d.mid != null)
    .map(d => ({ t: new Date(d.fetched_at).getTime(), v: d.mid as number }))
  if (pts.length < 2) return ''
  const xs = pts.map(p => p.t)
  const ys = pts.map(p => p.v)
  const minX = Math.min(...xs), maxX = Math.max(...xs)
  const minY = Math.min(...ys), maxY = Math.max(...ys)
  const W = 800, H = 120
  const scaleX = (x: number) => maxX === minX ? W / 2 : ((x - minX) / (maxX - minX)) * W
  const scaleY = (y: number) => maxY === minY ? H / 2 : H - ((y - minY) / (maxY - minY)) * H
  return pts.map((p, i) => `${i === 0 ? 'M' : 'L'}${scaleX(p.t).toFixed(1)},${scaleY(p.v).toFixed(1)}`).join(' ')
})

const chartYRange = computed(() => {
  const vs = historyData.value.filter(d => d.mid != null).map(d => d.mid as number)
  if (!vs.length) return { min: 0, max: 0 }
  return { min: Math.min(...vs), max: Math.max(...vs) }
})

// ─── Data loading ─────────────────────────────────────────────────────────────
async function loadAll(live = true) {
  loading.value = true
  error.value = null
  try {
    const [sum, rates, src, ops, st] = await Promise.allSettled([
      live ? fetchArbitrageSummary() : Promise.resolve(summary.value),
      live ? fetchArbitrageLiveRates() : fetchArbitrageCachedRates(30),
      fetchArbitrageSources(),
      fetchArbitrageOperations(20),
      fetchArbitrageStats(),
    ])
    if (sum.status === 'fulfilled' && sum.value) summary.value = sum.value as ArbitrageSummary
    if (rates.status === 'fulfilled') allRates.value = rates.value as ArbitrageRateItem[]
    if (src.status === 'fulfilled') sources.value = src.value as ArbitrageSource[]
    if (ops.status === 'fulfilled') operations.value = ops.value as ArbitrageOperation[]
    if (st.status === 'fulfilled') stats.value = st.value as ArbitrageStats
    lastRefreshed.value = new Date().toLocaleTimeString()
  } catch (e: any) {
    error.value = e?.message || 'Error fetching data'
  } finally {
    loading.value = false
  }
}

async function loadHistory() {
  loadingHistory.value = true
  try {
    const data = await fetchArbitrageHistory(selectedPair.value, selectedHistoryHours.value)
    historyData.value = data
  } catch {
    historyData.value = []
  } finally {
    loadingHistory.value = false
  }
}

async function refresh() {
  await loadAll(true)
  await loadHistory()
}

function toggleAutoRefresh() {
  autoRefresh.value = !autoRefresh.value
  if (autoRefresh.value) {
    refreshTimer = setInterval(refresh, 30_000)
  } else {
    if (refreshTimer) clearInterval(refreshTimer)
  }
}

async function submitOperation() {
  savingOp.value = true
  try {
    await createArbitrageOperation(opForm.value)
    showOpForm.value = false
    const [ops, st] = await Promise.all([fetchArbitrageOperations(20), fetchArbitrageStats()])
    operations.value = ops
    stats.value = st
    opForm.value = { pair: 'USDT/COP', buy_source: '', sell_source: '', buy_price: 0, sell_price: 0, amount_usdt: 100, fee_total: 0, notes: '' }
  } catch (e: any) {
    alert('Error saving: ' + (e?.message || 'unknown'))
  } finally {
    savingOp.value = false
  }
}

onMounted(async () => {
  await loadAll(false)
  await loadHistory()
})

onUnmounted(() => {
  if (refreshTimer) clearInterval(refreshTimer)
})
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-white flex items-center gap-2">
          <span class="text-2xl">₿</span>
          Arbitrage Monitor
        </h1>
        <p class="text-sm text-gray-400 mt-1">
          USDT · COP · CAD — live prices from 9 sources
          <span v-if="lastRefreshed" class="ml-2 text-gray-500">· updated {{ lastRefreshed }}</span>
        </p>
      </div>
      <div class="flex items-center gap-2 flex-wrap">
        <button
          @click="toggleAutoRefresh"
          :class="['px-3 py-1.5 rounded-lg text-sm font-medium transition-colors', autoRefresh ? 'bg-emerald-600 text-white' : 'bg-gray-800 text-gray-300 hover:bg-gray-700']"
        >
          {{ autoRefresh ? '● Auto 30s' : 'Auto refresh' }}
        </button>
        <button
          @click="refresh"
          :disabled="loading"
          class="px-4 py-1.5 bg-primary-600 hover:bg-primary-500 disabled:opacity-50 text-white rounded-lg text-sm font-medium transition-colors flex items-center gap-2"
        >
          <svg v-if="loading" class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"/>
          </svg>
          <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
          </svg>
          Refresh live
        </button>
      </div>
    </div>

    <!-- Error banner -->
    <div v-if="error" class="bg-red-900/30 border border-red-700 rounded-xl p-4 text-red-300 text-sm">
      {{ error }}
    </div>

    <!-- Opportunity Alert -->
    <div
      v-if="opportunity"
      :class="['rounded-xl p-4 border', opportunity.viable ? 'bg-emerald-900/30 border-emerald-700' : 'bg-gray-800/60 border-gray-700']"
    >
      <div class="flex items-start gap-3">
        <div :class="['text-2xl mt-0.5', opportunity.viable ? '' : 'grayscale opacity-60']">
          {{ opportunity.viable ? '🚀' : '📊' }}
        </div>
        <div class="flex-1 min-w-0">
          <div class="flex items-center gap-2 flex-wrap">
            <span :class="['font-bold text-base', opportunity.viable ? 'text-emerald-400' : 'text-gray-300']">
              {{ opportunity.description }}
            </span>
            <span
              v-if="opportunity.arb_spread_pct != null"
              :class="['px-2 py-0.5 rounded-full text-xs font-bold', opportunity.viable ? 'bg-emerald-500/30 text-emerald-300' : 'bg-gray-700 text-gray-400']"
            >
              {{ opportunity.arb_spread_pct > 0 ? '+' : '' }}{{ fmt(opportunity.arb_spread_pct, 3) }}% spread
            </span>
            <span v-if="opportunity.viable" class="px-2 py-0.5 rounded-full text-xs font-bold bg-emerald-600/40 text-emerald-200">
              VIABLE &gt;1%
            </span>
          </div>
          <div class="mt-2 grid grid-cols-2 sm:grid-cols-4 gap-3 text-sm">
            <div>
              <p class="text-gray-500 text-xs">USDT/COP avg</p>
              <p class="text-white font-mono">{{ fmt(opportunity.usdt_cop_avg, 0) }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs">USDT/CAD avg</p>
              <p class="text-white font-mono">{{ fmt(opportunity.usdt_cad_avg, 4) }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs">COP per CAD (FX)</p>
              <p class="text-white font-mono">{{ fmt(opportunity.fx_cop_per_cad, 1) }}</p>
            </div>
            <div>
              <p class="text-gray-500 text-xs">USDT via COP→CAD</p>
              <p class="text-white font-mono">{{ fmt(opportunity.usdt_in_cad_via_cop, 5) }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- FX Reference Row -->
    <div v-if="summary" class="grid grid-cols-3 gap-4">
      <div class="bg-gray-900 rounded-xl p-4 border border-gray-800">
        <p class="text-xs text-gray-500 mb-1">USD / COP</p>
        <p class="text-xl font-bold text-white font-mono">{{ fmt(summary.fx_reference.usd_cop, 1) }}</p>
        <p class="text-xs text-gray-500 mt-1">ExchangeRate-API</p>
      </div>
      <div class="bg-gray-900 rounded-xl p-4 border border-gray-800">
        <p class="text-xs text-gray-500 mb-1">USD / CAD</p>
        <p class="text-xl font-bold text-white font-mono">{{ fmt(summary.fx_reference.usd_cad, 4) }}</p>
        <p class="text-xs text-gray-500 mt-1">ExchangeRate-API</p>
      </div>
      <div class="bg-gray-900 rounded-xl p-4 border border-gray-800">
        <p class="text-xs text-gray-500 mb-1">COP / CAD</p>
        <p class="text-xl font-bold text-white font-mono">{{ fmt(summary.fx_reference.cop_per_cad, 1) }}</p>
        <p class="text-xs text-gray-500 mt-1">Derived</p>
      </div>
    </div>

    <!-- Key Pairs Grid -->
    <div>
      <h2 class="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3">Key pairs — best bid / ask across all sources</h2>
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
        <div
          v-for="pairKey in keyPairs"
          :key="pairKey"
          @click="selectedPair = pairKey; loadHistory()"
          :class="[
            'bg-gray-900 rounded-xl p-4 border cursor-pointer transition-all',
            selectedPair === pairKey ? 'border-primary-500 ring-1 ring-primary-500/40' : 'border-gray-800 hover:border-gray-700'
          ]"
        >
          <div class="flex items-center justify-between mb-2">
            <span class="text-xs font-semibold text-gray-400">{{ pairKey }}</span>
            <span
              v-if="pairMap[pairKey]?.spread_pct != null"
              :class="['text-xs font-bold', spreadColor(pairMap[pairKey].spread_pct)]"
            >
              {{ fmt(pairMap[pairKey].spread_pct, 2) }}%
            </span>
          </div>
          <template v-if="pairMap[pairKey]">
            <p class="text-lg font-bold text-white font-mono truncate">
              {{ fmt(pairMap[pairKey].best_bid, pairKey.includes('COP') ? 0 : 4) }}
            </p>
            <p class="text-xs text-gray-500 mt-1 truncate">{{ pairMap[pairKey].sources_count }} sources</p>
          </template>
          <template v-else>
            <p class="text-lg text-gray-600">—</p>
            <p class="text-xs text-gray-600 mt-1">no data</p>
          </template>
        </div>
      </div>
    </div>

    <!-- Main two-column layout -->
    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">

      <!-- Left: Rates table for selected pair -->
      <div class="xl:col-span-2 space-y-4">
        <div class="bg-gray-900 rounded-xl border border-gray-800">
          <div class="flex items-center justify-between px-5 py-4 border-b border-gray-800">
            <div>
              <h2 class="text-sm font-semibold text-white">All sources for <span class="text-primary-400">{{ selectedPair }}</span></h2>
              <p class="text-xs text-gray-500 mt-0.5">{{ selectedPairRates.length }} data points</p>
            </div>
            <select
              v-model="selectedPair"
              @change="loadHistory"
              class="bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-3 py-1.5 focus:outline-none focus:border-primary-500"
            >
              <option v-for="p in availablePairs" :key="p" :value="p">{{ p }}</option>
            </select>
          </div>

          <div class="overflow-x-auto">
            <table class="w-full text-sm">
              <thead>
                <tr class="text-xs text-gray-500 border-b border-gray-800">
                  <th class="text-left px-5 py-3 font-medium">
                    Source
                    <span class="block font-normal text-gray-600 normal-case tracking-normal">clic → plataforma</span>
                  </th>
                  <th class="text-right px-4 py-3 font-medium">Bid</th>
                  <th class="text-right px-4 py-3 font-medium">Ask</th>
                  <th class="text-right px-4 py-3 font-medium">Mid</th>
                  <th class="text-right px-4 py-3 font-medium">Volume 24h</th>
                  <th class="text-right px-5 py-3 font-medium">Updated</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="rate in selectedPairRates"
                  :key="rate.source + rate.fetched_at"
                  class="border-b border-gray-800/50 hover:bg-gray-800/40 transition-colors"
                >
                  <td class="px-5 py-3">
                    <a
                      v-if="tradeUrlForRate(rate)"
                      :href="tradeUrlForRate(rate)!"
                      target="_blank"
                      rel="noopener noreferrer"
                      :title="`Abrir ${arbitrageSourcePlatformLabel(rate.source)} (nueva pestaña)`"
                      class="inline-flex items-center gap-1.5 max-w-full group"
                    >
                      <span
                        :class="[
                          'px-2 py-0.5 rounded-full text-xs font-medium underline underline-offset-2 decoration-white/25 group-hover:decoration-primary-400',
                          sourceBadge(rate.source),
                        ]"
                      >
                        {{ rate.source }}
                      </span>
                      <svg
                        class="w-3.5 h-3.5 shrink-0 text-gray-500 group-hover:text-primary-400"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                        aria-hidden="true"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                        />
                      </svg>
                    </a>
                    <span
                      v-else
                      :class="['px-2 py-0.5 rounded-full text-xs font-medium', sourceBadge(rate.source)]"
                    >
                      {{ rate.source }}
                    </span>
                  </td>
                  <td class="px-4 py-3 text-right font-mono text-gray-200">
                    {{ rate.bid != null ? fmt(rate.bid, selectedPair.includes('COP') ? 0 : 4) : '—' }}
                  </td>
                  <td class="px-4 py-3 text-right font-mono text-gray-200">
                    {{ rate.ask != null ? fmt(rate.ask, selectedPair.includes('COP') ? 0 : 4) : '—' }}
                  </td>
                  <td class="px-4 py-3 text-right font-mono text-white font-semibold">
                    {{ rate.mid != null ? fmt(rate.mid, selectedPair.includes('COP') ? 0 : 4) : '—' }}
                  </td>
                  <td class="px-4 py-3 text-right text-gray-400 font-mono text-xs">
                    {{ fmtBig(rate.volume_24h) }}
                  </td>
                  <td class="px-5 py-3 text-right text-gray-500 text-xs">
                    {{ timeAgo(rate.fetched_at) }}
                  </td>
                </tr>
                <tr v-if="selectedPairRates.length === 0">
                  <td colspan="6" class="px-5 py-8 text-center text-gray-600">
                    No data for this pair yet. Click "Refresh live" to fetch.
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- History Chart -->
        <div class="bg-gray-900 rounded-xl border border-gray-800 p-5">
          <div class="flex items-center justify-between mb-4">
            <h2 class="text-sm font-semibold text-white">
              Price history — <span class="text-primary-400">{{ selectedPair }}</span>
            </h2>
            <div class="flex items-center gap-2">
              <select
                v-model="selectedHistoryHours"
                @change="loadHistory"
                class="bg-gray-800 border border-gray-700 text-gray-200 text-xs rounded-lg px-2 py-1 focus:outline-none"
              >
                <option :value="1">1h</option>
                <option :value="6">6h</option>
                <option :value="24">24h</option>
                <option :value="72">3 days</option>
                <option :value="168">7 days</option>
              </select>
            </div>
          </div>

          <div v-if="loadingHistory" class="h-32 flex items-center justify-center">
            <div class="w-6 h-6 border-2 border-primary-500 border-t-transparent rounded-full animate-spin"/>
          </div>
          <div v-else-if="chartPoints" class="w-full">
            <div class="flex justify-between text-xs text-gray-500 mb-1 font-mono">
              <span>{{ fmt(chartYRange.max, selectedPair.includes('COP') ? 0 : 4) }}</span>
              <span>{{ historyData.length }} points</span>
            </div>
            <svg viewBox="0 0 800 120" class="w-full h-28 overflow-visible">
              <defs>
                <linearGradient id="histGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stop-color="#6366f1" stop-opacity="0.3"/>
                  <stop offset="100%" stop-color="#6366f1" stop-opacity="0"/>
                </linearGradient>
              </defs>
              <path
                :d="chartPoints + ' L800,120 L0,120 Z'"
                fill="url(#histGrad)"
              />
              <path
                :d="chartPoints"
                fill="none"
                stroke="#818cf8"
                stroke-width="2"
                stroke-linejoin="round"
                stroke-linecap="round"
              />
            </svg>
            <div class="flex justify-between text-xs text-gray-500 mt-1 font-mono">
              <span>{{ fmt(chartYRange.min, selectedPair.includes('COP') ? 0 : 4) }}</span>
            </div>
          </div>
          <div v-else class="h-28 flex items-center justify-center text-gray-600 text-sm">
            No history yet. Refresh live a few times to build history.
          </div>
        </div>
      </div>

      <!-- Right: Summary + Stats + Sources -->
      <div class="space-y-4">
        <!-- Summary pairs spread table -->
        <div class="bg-gray-900 rounded-xl border border-gray-800">
          <div class="px-5 py-4 border-b border-gray-800">
            <h2 class="text-sm font-semibold text-white">Spread summary</h2>
            <p class="text-xs text-gray-500 mt-0.5">best bid − best ask / ask</p>
          </div>
          <div class="divide-y divide-gray-800">
            <div
              v-for="row in summary?.pairs ?? []"
              :key="row.pair"
              class="px-5 py-3 flex items-center justify-between"
            >
              <div>
                <p class="text-sm text-gray-200 font-medium">{{ row.pair }}</p>
                <p class="text-xs text-gray-500">{{ row.sources_count }} src</p>
              </div>
              <div class="text-right">
                <p :class="['text-sm font-bold font-mono', spreadColor(row.spread_pct)]">
                  {{ row.spread_pct != null ? (row.spread_pct > 0 ? '+' : '') + fmt(row.spread_pct, 2) + '%' : '—' }}
                </p>
                <p class="text-xs text-gray-600 font-mono">
                  {{ row.best_bid != null ? fmt(row.best_bid, row.pair.includes('COP') ? 0 : 4) : '—' }}
                </p>
              </div>
            </div>
            <div v-if="!summary" class="px-5 py-8 text-center text-gray-600 text-sm">
              Click Refresh to load
            </div>
          </div>
        </div>

        <!-- Stats card -->
        <div v-if="stats" class="bg-gray-900 rounded-xl border border-gray-800 p-5">
          <h2 class="text-sm font-semibold text-white mb-3">Trade performance</h2>
          <div class="grid grid-cols-2 gap-3">
            <div class="bg-gray-800/60 rounded-lg p-3">
              <p class="text-xs text-gray-500">Total trades</p>
              <p class="text-xl font-bold text-white">{{ stats.total_trades }}</p>
            </div>
            <div class="bg-gray-800/60 rounded-lg p-3">
              <p class="text-xs text-gray-500">Net profit</p>
              <p :class="['text-xl font-bold font-mono', stats.total_profit >= 0 ? 'text-emerald-400' : 'text-red-400']">
                {{ stats.total_profit >= 0 ? '+' : '' }}{{ fmt(stats.total_profit, 2) }}
              </p>
            </div>
            <div class="bg-gray-800/60 rounded-lg p-3">
              <p class="text-xs text-gray-500">ROI</p>
              <p :class="['text-xl font-bold', profitColor(stats.roi_pct)]">{{ fmt(stats.roi_pct, 2) }}%</p>
            </div>
            <div class="bg-gray-800/60 rounded-lg p-3">
              <p class="text-xs text-gray-500">Avg/trade</p>
              <p :class="['text-xl font-bold', profitColor(stats.avg_profit_pct)]">{{ fmt(stats.avg_profit_pct, 2) }}%</p>
            </div>
          </div>
          <div v-if="stats.best_trade" class="mt-3 text-xs text-gray-500">
            Best: <span class="text-emerald-400 font-mono">+{{ fmt(stats.best_trade.profit_pct, 2) }}%</span>
            · Worst: <span class="text-red-400 font-mono">{{ fmt(stats.worst_trade?.profit_pct, 2) }}%</span>
          </div>
        </div>

        <!-- Sources -->
        <div class="bg-gray-900 rounded-xl border border-gray-800">
          <div class="px-5 py-4 border-b border-gray-800">
            <h2 class="text-sm font-semibold text-white">Data sources</h2>
          </div>
          <div class="divide-y divide-gray-800 max-h-64 overflow-y-auto">
            <div v-for="src in sources" :key="src.id" class="px-5 py-3">
              <div class="flex items-center gap-2 mb-1">
                <span :class="['text-xs px-2 py-0.5 rounded-full font-medium', sourceBadge(src.id)]">{{ src.name }}</span>
              </div>
              <p class="text-xs text-gray-500">{{ src.description }}</p>
              <div class="flex flex-wrap gap-1 mt-1.5">
                <span v-for="pair in src.pairs" :key="pair" class="text-xs bg-gray-800 text-gray-400 px-1.5 py-0.5 rounded font-mono">{{ pair }}</span>
              </div>
            </div>
            <div v-if="!sources.length" class="px-5 py-4 text-center text-gray-600 text-sm">Loading sources…</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Trade Operations -->
    <div class="bg-gray-900 rounded-xl border border-gray-800">
      <div class="flex items-center justify-between px-5 py-4 border-b border-gray-800">
        <h2 class="text-sm font-semibold text-white">Trade log</h2>
        <button
          @click="showOpForm = !showOpForm"
          class="px-3 py-1.5 bg-primary-600 hover:bg-primary-500 text-white text-sm rounded-lg font-medium transition-colors"
        >
          + Log trade
        </button>
      </div>

      <!-- Op form -->
      <div v-if="showOpForm" class="p-5 border-b border-gray-800 bg-gray-800/30">
        <h3 class="text-sm font-medium text-gray-300 mb-3">New arbitrage trade</h3>
        <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3 mb-3">
          <div>
            <label class="text-xs text-gray-500 block mb-1">Pair</label>
            <select v-model="opForm.pair" class="w-full bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-2 py-1.5 focus:outline-none focus:border-primary-500">
              <option v-for="p in availablePairs" :key="p" :value="p">{{ p }}</option>
            </select>
          </div>
          <div>
            <label class="text-xs text-gray-500 block mb-1">Buy source</label>
            <input v-model="opForm.buy_source" placeholder="e.g. binance" class="w-full bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-2 py-1.5 focus:outline-none focus:border-primary-500"/>
          </div>
          <div>
            <label class="text-xs text-gray-500 block mb-1">Sell source</label>
            <input v-model="opForm.sell_source" placeholder="e.g. criptoya_binance" class="w-full bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-2 py-1.5 focus:outline-none focus:border-primary-500"/>
          </div>
          <div>
            <label class="text-xs text-gray-500 block mb-1">Buy price</label>
            <input v-model.number="opForm.buy_price" type="number" step="0.0001" class="w-full bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-2 py-1.5 focus:outline-none focus:border-primary-500"/>
          </div>
          <div>
            <label class="text-xs text-gray-500 block mb-1">Sell price</label>
            <input v-model.number="opForm.sell_price" type="number" step="0.0001" class="w-full bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-2 py-1.5 focus:outline-none focus:border-primary-500"/>
          </div>
          <div>
            <label class="text-xs text-gray-500 block mb-1">Amount USDT</label>
            <input v-model.number="opForm.amount_usdt" type="number" step="1" class="w-full bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-2 py-1.5 focus:outline-none focus:border-primary-500"/>
          </div>
        </div>
        <div class="grid grid-cols-2 sm:grid-cols-3 gap-3 mb-3">
          <div>
            <label class="text-xs text-gray-500 block mb-1">Total fees</label>
            <input v-model.number="opForm.fee_total" type="number" step="0.01" class="w-full bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-2 py-1.5 focus:outline-none focus:border-primary-500"/>
          </div>
          <div class="sm:col-span-2">
            <label class="text-xs text-gray-500 block mb-1">Notes</label>
            <input v-model="opForm.notes" class="w-full bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-2 py-1.5 focus:outline-none focus:border-primary-500"/>
          </div>
        </div>
        <!-- Preview -->
        <div v-if="opProfit" class="flex items-center gap-4 mb-3 text-sm">
          <span class="text-gray-500">Gross: <span class="font-mono text-white">{{ opProfit.gross }}</span></span>
          <span class="text-gray-500">Net: <span :class="['font-mono font-bold', Number(opProfit.net) >= 0 ? 'text-emerald-400' : 'text-red-400']">{{ opProfit.net }}</span></span>
          <span class="text-gray-500">%: <span :class="['font-mono font-bold', Number(opProfit.pct) >= 0 ? 'text-emerald-400' : 'text-red-400']">{{ opProfit.pct }}%</span></span>
        </div>
        <div class="flex gap-2">
          <button @click="submitOperation" :disabled="savingOp" class="px-4 py-1.5 bg-primary-600 hover:bg-primary-500 disabled:opacity-50 text-white text-sm rounded-lg font-medium transition-colors">
            {{ savingOp ? 'Saving…' : 'Save trade' }}
          </button>
          <button @click="showOpForm = false" class="px-4 py-1.5 bg-gray-700 hover:bg-gray-600 text-gray-300 text-sm rounded-lg font-medium transition-colors">
            Cancel
          </button>
        </div>
      </div>

      <!-- Operations table -->
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead>
            <tr class="text-xs text-gray-500 border-b border-gray-800">
              <th class="text-left px-5 py-3 font-medium">Pair</th>
              <th class="text-left px-4 py-3 font-medium">Buy / Sell source</th>
              <th class="text-right px-4 py-3 font-medium">Buy px</th>
              <th class="text-right px-4 py-3 font-medium">Sell px</th>
              <th class="text-right px-4 py-3 font-medium">USDT</th>
              <th class="text-right px-4 py-3 font-medium">Net profit</th>
              <th class="text-right px-5 py-3 font-medium">%</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="op in operations"
              :key="op.id"
              class="border-b border-gray-800/50 hover:bg-gray-800/40 transition-colors"
            >
              <td class="px-5 py-3 font-mono text-gray-300 text-xs">{{ op.pair }}</td>
              <td class="px-4 py-3">
                <div class="text-xs">
                  <span :class="['px-1.5 py-0.5 rounded text-xs', sourceBadge(op.buy_source)]">{{ op.buy_source }}</span>
                  <span class="text-gray-600 mx-1">→</span>
                  <span :class="['px-1.5 py-0.5 rounded text-xs', sourceBadge(op.sell_source)]">{{ op.sell_source }}</span>
                </div>
              </td>
              <td class="px-4 py-3 text-right font-mono text-gray-300 text-xs">{{ fmt(op.buy_price, op.pair.includes('COP') ? 0 : 5) }}</td>
              <td class="px-4 py-3 text-right font-mono text-gray-300 text-xs">{{ fmt(op.sell_price, op.pair.includes('COP') ? 0 : 5) }}</td>
              <td class="px-4 py-3 text-right font-mono text-gray-400 text-xs">{{ fmt(op.amount_usdt, 0) }}</td>
              <td class="px-4 py-3 text-right font-mono text-xs" :class="op.net_profit >= 0 ? 'text-emerald-400' : 'text-red-400'">
                {{ op.net_profit >= 0 ? '+' : '' }}{{ fmt(op.net_profit, 4) }}
              </td>
              <td class="px-5 py-3 text-right font-mono font-bold text-sm" :class="profitColor(op.net_profit_pct)">
                {{ op.net_profit_pct >= 0 ? '+' : '' }}{{ fmt(op.net_profit_pct, 3) }}%
              </td>
            </tr>
            <tr v-if="!operations.length">
              <td colspan="7" class="px-5 py-8 text-center text-gray-600">
                No trades logged yet. Use "Log trade" to record an arbitrage operation.
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
