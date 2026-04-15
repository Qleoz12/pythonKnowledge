<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import type { DashboardStats, SectorStat } from '../types'
import { fetchDashboard, fetchTopDividendYields, fetchSectorStats, runETL, fetchEnrichStatus, enrichBatch } from '../services/api'

const router = useRouter()
const stats = ref<DashboardStats | null>(null)
const topYields = ref<any[]>([])
const sectorStats = ref<SectorStat[]>([])
const loading = ref(true)
const etlRunning = ref(false)
const etlResult = ref<string>('')

const enrichStatus = ref<{ total_stocks: number; missing_prices: number; missing_sector: number; health_pct: number } | null>(null)
const enrichRunning = ref(false)
const enrichProgress = ref('')

const sectorIcons: Record<string, string> = {
  'Technology': 'M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z',
  'Healthcare': 'M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z',
  'Financial Services': 'M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
  'Energy': 'M13 10V3L4 14h7v7l9-11h-7z',
  'Industrials': 'M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z',
  'Real Estate': 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6',
  'Consumer Cyclical': 'M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 100 4 2 2 0 000-4z',
  'Consumer Defensive': 'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4',
  'Mining': 'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4',
  'Oil & Gas': 'M17.657 18.657A8 8 0 016.343 7.343S7 9 9 10c0-2 .5-5 2.986-7C14 5 16.09 5.777 17.656 7.343A7.975 7.975 0 0120 13a7.975 7.975 0 01-2.343 5.657z',
  'Utilities': 'M13 10V3L4 14h7v7l9-11h-7z',
  'Communication Services': 'M8.111 16.404a5.5 5.5 0 017.778 0M12 20h.01m-7.08-7.071c3.904-3.905 10.236-3.905 14.141 0M1.394 9.393c5.857-5.858 15.355-5.858 21.213 0',
  'Basic Materials': 'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4',
}

const defaultIcon = 'M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10'

const sectorColors: Record<string, string> = {
  'Technology': 'bg-blue-900/50 text-blue-400',
  'Healthcare': 'bg-pink-900/50 text-pink-400',
  'Financial Services': 'bg-emerald-900/50 text-emerald-400',
  'Energy': 'bg-orange-900/50 text-orange-400',
  'Oil & Gas': 'bg-orange-900/50 text-orange-400',
  'Industrials': 'bg-slate-700/50 text-slate-300',
  'Real Estate': 'bg-cyan-900/50 text-cyan-400',
  'Consumer Cyclical': 'bg-violet-900/50 text-violet-400',
  'Consumer Defensive': 'bg-lime-900/50 text-lime-400',
  'Mining': 'bg-amber-900/50 text-amber-400',
  'Utilities': 'bg-yellow-900/50 text-yellow-400',
  'Utilities & Pipelines': 'bg-yellow-900/50 text-yellow-400',
  'Communication Services': 'bg-indigo-900/50 text-indigo-400',
  'Basic Materials': 'bg-stone-700/50 text-stone-300',
}

const defaultColor = 'bg-gray-700/50 text-gray-400'

onMounted(async () => {
  try {
    const [s, ty, sec] = await Promise.all([
      fetchDashboard(),
      fetchTopDividendYields({ limit: 10 }),
      fetchSectorStats().catch(() => [] as SectorStat[]),
    ])
    stats.value = s
    topYields.value = ty
    sectorStats.value = sec
    fetchEnrichStatus().then(es => enrichStatus.value = es).catch(() => {})
  } catch (e) {
    console.error('Failed to load dashboard:', e)
  } finally {
    loading.value = false
  }
})

function goToSector(sector: string) {
  router.push({ path: '/stocks', query: { sector } })
}

async function runEnrichBatch(mode = 'missing_prices') {
  enrichRunning.value = true
  enrichProgress.value = `Enriching batch (${mode})...`
  try {
    const result = await enrichBatch(10, mode)
    enrichProgress.value = `Done: ${result.enriched} enriched, ${result.failed} failed. ${result.total_missing} remaining.`
    enrichStatus.value = await fetchEnrichStatus()
    const [s, ty] = await Promise.all([fetchDashboard(), fetchTopDividendYields({ limit: 10 })])
    stats.value = s
    topYields.value = ty
  } catch (e: any) {
    enrichProgress.value = `Error: ${e.message}`
  } finally {
    enrichRunning.value = false
  }
}

async function triggerETL() {
  etlRunning.value = true
  etlResult.value = ''
  try {
    const result = await runETL()
    etlResult.value = 'ETL completed successfully'
    const [s, ty] = await Promise.all([
      fetchDashboard(),
      fetchTopDividendYields({ limit: 10 }),
    ])
    stats.value = s
    topYields.value = ty
    fetchEnrichStatus().then(es => enrichStatus.value = es).catch(() => {})
  } catch (e: any) {
    etlResult.value = `ETL failed: ${e.message}`
  } finally {
    etlRunning.value = false
  }
}

function fmt(n: number | null | undefined, decimals = 2): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold text-white">Dashboard</h1>
        <p class="text-gray-400 mt-1">Stock Portfolio Unifier — TSX, NYSE, LSE + Quanfury</p>
      </div>
      <div class="flex items-center gap-3">
        <span v-if="etlResult" class="text-sm" :class="etlResult.includes('failed') ? 'text-red-400' : 'text-green-400'">
          {{ etlResult }}
        </span>
        <button @click="triggerETL" :disabled="etlRunning" class="btn-primary flex items-center gap-2">
          <svg v-if="etlRunning" class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
          </svg>
          {{ etlRunning ? 'Loading Data...' : 'Load/Refresh Data' }}
        </button>
      </div>
    </div>

    <div v-if="loading" class="flex items-center justify-center py-20">
      <div class="text-gray-400">Loading dashboard...</div>
    </div>

    <template v-else-if="stats">
      <!-- Stats cards -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <div class="card">
          <p class="text-sm text-gray-400 mb-1">Total Stocks</p>
          <p class="text-3xl font-bold text-white">{{ stats.total_stocks.toLocaleString() }}</p>
          <div class="mt-2 flex flex-wrap gap-2">
            <span v-for="(count, code) in stats.stocks_by_exchange" :key="code" class="badge-blue">
              {{ code }}: {{ count }}
            </span>
          </div>
        </div>

        <div class="card">
          <p class="text-sm text-gray-400 mb-1">Paying Dividends</p>
          <p class="text-3xl font-bold text-green-400">{{ stats.stocks_with_dividends.toLocaleString() }}</p>
          <p class="text-sm text-gray-500 mt-2">Avg Yield: {{ fmt(stats.avg_div_yield) }}%</p>
        </div>

        <div class="card">
          <p class="text-sm text-gray-400 mb-1">Quanfury Available</p>
          <p class="text-3xl font-bold text-purple-400">{{ stats.quanfury_available }}</p>
          <p class="text-sm text-gray-500 mt-2">Cross-referenced tickers</p>
        </div>

        <div class="card">
          <p class="text-sm text-gray-400 mb-1">52W Signals</p>
          <div class="flex items-baseline gap-4 mt-1">
            <div>
              <span class="text-2xl font-bold text-red-400">{{ stats.near_52w_low_count }}</span>
              <span class="text-xs text-gray-500 ml-1">near low</span>
            </div>
            <div>
              <span class="text-2xl font-bold text-green-400">{{ stats.near_52w_high_count }}</span>
              <span class="text-xs text-gray-500 ml-1">near high</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Data Health / Enrichment -->
      <div v-if="enrichStatus && enrichStatus.missing_prices > 0" class="mb-8 p-5 bg-gray-900 border border-amber-800/50 rounded-xl">
        <div class="flex items-start justify-between">
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-amber-900/50 rounded-lg flex items-center justify-center flex-shrink-0">
              <svg class="w-5 h-5 text-amber-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
              </svg>
            </div>
            <div>
              <h3 class="text-sm font-semibold text-white">Data Enrichment Needed</h3>
              <p class="text-xs text-gray-400 mt-0.5">
                {{ enrichStatus.missing_prices.toLocaleString() }} stocks missing price data ·
                {{ enrichStatus.missing_sector.toLocaleString() }} missing sector ·
                {{ enrichStatus.health_pct }}% healthy
              </p>
            </div>
          </div>
          <div class="flex items-center gap-2">
            <button @click="runEnrichBatch('missing_prices')" :disabled="enrichRunning"
              class="btn-primary text-xs flex items-center gap-1.5">
              <svg v-if="enrichRunning" class="w-3.5 h-3.5 animate-spin" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
              Enrich Batch (10)
            </button>
            <button v-if="enrichStatus.missing_sector > 0"
              @click="runEnrichBatch('missing_sector')" :disabled="enrichRunning"
              class="text-xs px-3 py-1.5 rounded-lg bg-gray-700 hover:bg-gray-600 text-gray-300 transition-colors">
              Fill Sectors (10)
            </button>
          </div>
        </div>
        <!-- Health bar -->
        <div class="mt-3 h-2 bg-gray-800 rounded-full overflow-hidden">
          <div class="h-full rounded-full transition-all duration-500"
            :class="enrichStatus.health_pct >= 80 ? 'bg-green-500' : enrichStatus.health_pct >= 50 ? 'bg-yellow-500' : 'bg-red-500'"
            :style="{ width: enrichStatus.health_pct + '%' }">
          </div>
        </div>
        <p v-if="enrichProgress" class="text-xs mt-2" :class="enrichProgress.includes('Error') ? 'text-red-400' : 'text-gray-400'">
          {{ enrichProgress }}
        </p>
      </div>

      <!-- Quick actions -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <div class="card">
          <h2 class="text-lg font-semibold text-white mb-4">Quick Navigation</h2>
          <div class="grid grid-cols-2 gap-3">
            <RouterLink to="/stocks" class="flex items-center gap-3 p-3 bg-gray-800 hover:bg-gray-750 rounded-lg transition-colors">
              <div class="w-10 h-10 bg-blue-900/50 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                </svg>
              </div>
              <div>
                <p class="text-sm font-medium text-white">Stock Explorer</p>
                <p class="text-xs text-gray-400">Browse & filter</p>
              </div>
            </RouterLink>
            <RouterLink to="/dividends" class="flex items-center gap-3 p-3 bg-gray-800 hover:bg-gray-750 rounded-lg transition-colors">
              <div class="w-10 h-10 bg-green-900/50 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <div>
                <p class="text-sm font-medium text-white">Dividend Calendar</p>
                <p class="text-xs text-gray-400">Upcoming dates</p>
              </div>
            </RouterLink>
            <RouterLink to="/portfolios" class="flex items-center gap-3 p-3 bg-gray-800 hover:bg-gray-750 rounded-lg transition-colors">
              <div class="w-10 h-10 bg-purple-900/50 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-purple-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                </svg>
              </div>
              <div>
                <p class="text-sm font-medium text-white">Portfolios</p>
                <p class="text-xs text-gray-400">Manage holdings</p>
              </div>
            </RouterLink>
            <RouterLink to="/analytics" class="flex items-center gap-3 p-3 bg-gray-800 hover:bg-gray-750 rounded-lg transition-colors">
              <div class="w-10 h-10 bg-yellow-900/50 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-yellow-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
              <div>
                <p class="text-sm font-medium text-white">Analytics</p>
                <p class="text-xs text-gray-400">52W proximity</p>
              </div>
            </RouterLink>
          </div>
        </div>

        <!-- Top dividend yields -->
        <div class="card">
          <h2 class="text-lg font-semibold text-white mb-4">Top Dividend Yields</h2>
          <div class="space-y-2 max-h-72 overflow-y-auto">
            <div
              v-for="stock in topYields"
              :key="stock.ticker_yf"
              class="flex items-center justify-between p-2 bg-gray-800 rounded-lg"
            >
              <div class="flex items-center gap-3">
                <div>
                  <p class="text-sm font-medium text-white">{{ stock.ticker_yf }}</p>
                  <p class="text-xs text-gray-400 truncate max-w-[180px]">{{ stock.company_name }}</p>
                </div>
              </div>
              <div class="text-right">
                <p class="text-sm font-bold text-green-400">{{ fmt(stock.div_yield_ttm) }}%</p>
                <div class="flex items-center gap-1">
                  <span class="badge-blue text-[10px]">{{ stock.exchange_code }}</span>
                  <span v-if="stock.is_quanfury" class="badge-purple text-[10px]">QF</span>
                </div>
              </div>
            </div>
            <p v-if="topYields.length === 0" class="text-sm text-gray-500 text-center py-4">
              No data yet. Click "Load/Refresh Data" to import.
            </p>
          </div>
        </div>
      </div>
      <!-- Sector Browser -->
      <div v-if="sectorStats.length > 0" class="mb-8">
        <div class="flex items-center justify-between mb-4">
          <div>
            <h2 class="text-lg font-semibold text-white">Browse by Sector</h2>
            <p class="text-sm text-gray-400 mt-0.5">{{ sectorStats.length }} sectors · Click to explore stocks</p>
          </div>
        </div>
        <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3">
          <button
            v-for="ss in sectorStats"
            :key="ss.sector"
            @click="goToSector(ss.sector)"
            class="flex items-start gap-3 p-3 bg-gray-900 border border-gray-800 rounded-xl hover:border-primary-700 hover:bg-gray-800/80 transition-all group cursor-pointer text-left"
          >
            <div class="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5"
              :class="sectorColors[ss.sector] || defaultColor">
              <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" :d="sectorIcons[ss.sector] || defaultIcon" />
              </svg>
            </div>
            <div class="min-w-0 flex-1">
              <span class="text-sm font-medium text-gray-300 group-hover:text-primary-400 transition-colors leading-tight truncate block">
                {{ ss.sector }}
              </span>
              <div class="flex items-center gap-2 mt-1">
                <span class="text-[10px] text-gray-500 font-medium">{{ ss.count }} stocks</span>
                <span v-if="ss.missing_prices > 0" class="text-[10px] text-amber-500 font-medium">{{ ss.missing_prices }} pending</span>
                <span v-else class="text-[10px] text-green-500 font-medium">up to date</span>
              </div>
            </div>
          </button>
        </div>
      </div>
    </template>

    <div v-else class="card text-center py-12">
      <p class="text-gray-400 mb-4">No data loaded yet. Click the button to import your CSV/JSON data.</p>
      <button @click="triggerETL" :disabled="etlRunning" class="btn-primary">
        {{ etlRunning ? 'Loading...' : 'Load Data (ETL)' }}
      </button>
    </div>
  </div>
</template>
