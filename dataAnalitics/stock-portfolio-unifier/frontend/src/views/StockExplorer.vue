<script setup lang="ts">
import { onMounted, watch, computed, ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useStocksStore } from '../stores/stocks'
import { enrichFiltered } from '../services/api'

const store = useStocksStore()
const router = useRouter()
const route = useRoute()

const refreshing = ref(false)
const refreshProgress = ref('')
const refreshTotal = ref(0)
const refreshDone = ref(0)
const refreshStopped = ref(false)

onMounted(async () => {
  if (route.query.sector) {
    store.filters.sector = route.query.sector as string
  }
  if (route.query.exchange) {
    store.filters.exchange = route.query.exchange as string
  }
  if (route.query.quanfury_only === 'true') {
    store.filters.quanfury_only = true
  }
  await store.loadMeta()
  await store.loadStocks()
})

watch(() => route.query, (q) => {
  if (q.sector !== undefined) {
    store.filters.sector = (q.sector as string) || ''
    store.filters.page = 1
    store.loadStocks()
  }
})

function applyFilters() {
  store.filters.page = 1
  store.loadStocks()
}

let searchTimeout: any = null
function onSearchInput() {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => applyFilters(), 300)
}

function goToStock(id: number) {
  router.push(`/stocks/${id}`)
}

function fmt(n: number | null | undefined, decimals = 2): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}

function yieldColor(y: number | null): string {
  if (!y) return 'text-gray-500'
  if (y >= 8) return 'text-green-400'
  if (y >= 4) return 'text-green-300'
  if (y >= 2) return 'text-yellow-400'
  return 'text-gray-400'
}

function rsiColor(r: number | null): string {
  if (!r) return 'text-gray-500'
  if (r >= 70) return 'text-red-400'
  if (r <= 30) return 'text-green-400'
  return 'text-gray-300'
}

const hasActiveFilter = computed(() => {
  return store.filters.sector || store.filters.exchange || store.filters.search || store.filters.quanfury_only
})

const stocksMissingData = computed(() => {
  return store.stocks.filter(s => !s.last_close).length
})

async function refreshAllFiltered() {
  if (refreshing.value) {
    refreshStopped.value = true
    return
  }

  refreshing.value = true
  refreshStopped.value = false
  refreshDone.value = 0
  refreshProgress.value = 'Starting...'

  const BATCH = 10
  const params: any = { batch_size: BATCH }
  if (store.filters.sector) params.sector = store.filters.sector
  if (store.filters.exchange) params.exchange = store.filters.exchange
  if (store.filters.search) params.search = store.filters.search
  if (store.filters.quanfury_only) params.quanfury_only = true

  try {
    let iteration = 0
    while (!refreshStopped.value) {
      const result = await enrichFiltered(params)
      iteration++

      if (iteration === 1) {
        refreshTotal.value = result.total_pending + result.enriched
      }
      refreshDone.value += result.enriched

      const tickers = result.details.map(d => d.ticker).join(', ')
      refreshProgress.value = `Batch ${iteration}: ${result.enriched} enriched (${tickers})`

      await store.loadStocks()

      if (result.done || result.enriched === 0) {
        refreshProgress.value = `Done! ${refreshDone.value} stocks enriched.`
        break
      }
    }

    if (refreshStopped.value) {
      refreshProgress.value = `Stopped. ${refreshDone.value} stocks enriched so far.`
    }
  } catch (e: any) {
    refreshProgress.value = `Error: ${e.message}`
  } finally {
    refreshing.value = false
  }
}

const sortIcon = (field: string) => {
  if (store.filters.sort_by !== field) return ''
  return store.filters.order === 'asc' ? ' ↑' : ' ↓'
}

const pageNumbers = computed(() => {
  const current = store.filters.page
  const total = store.pages
  const pages: number[] = []
  const start = Math.max(1, current - 2)
  const end = Math.min(total, current + 2)
  for (let i = start; i <= end; i++) pages.push(i)
  return pages
})
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-6">
      <div>
        <h1 class="text-3xl font-bold text-white">Stock Explorer</h1>
        <p v-if="store.filters.sector" class="text-sm text-gray-400 mt-1">
          Filtered by sector:
          <span class="text-primary-400 font-medium">{{ store.filters.sector }}</span>
          <button @click="store.filters.sector = ''; applyFilters(); router.replace({ query: {} })"
            class="text-gray-500 hover:text-white ml-2 text-xs">(clear)</button>
        </p>
      </div>
      <div v-if="hasActiveFilter && stocksMissingData > 0" class="flex items-center gap-3">
        <span class="text-xs text-amber-400">{{ stocksMissingData }} without data</span>
        <button @click="refreshAllFiltered" class="btn-primary text-sm flex items-center gap-2">
          <svg v-if="refreshing" class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
          </svg>
          <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
          </svg>
          {{ refreshing ? 'Stop' : 'Refresh All' }}
        </button>
      </div>
    </div>

    <!-- Refresh progress -->
    <div v-if="refreshProgress" class="mb-4 p-3 rounded-xl border"
      :class="refreshProgress.startsWith('Error') ? 'bg-red-900/20 border-red-800 text-red-300'
            : refreshProgress.startsWith('Done') || refreshProgress.startsWith('Stopped') ? 'bg-green-900/20 border-green-800 text-green-300'
            : 'bg-blue-900/20 border-blue-800 text-blue-300'">
      <div class="flex items-center justify-between text-sm">
        <span>{{ refreshProgress }}</span>
        <span v-if="refreshing && refreshTotal > 0" class="font-mono text-xs">
          {{ refreshDone }}/{{ refreshTotal }}
        </span>
      </div>
      <div v-if="refreshing && refreshTotal > 0" class="mt-2 h-1.5 bg-gray-800 rounded-full overflow-hidden">
        <div class="h-full bg-blue-500 rounded-full transition-all duration-300"
          :style="{ width: Math.min(100, (refreshDone / refreshTotal) * 100) + '%' }">
        </div>
      </div>
    </div>

    <!-- Filters -->
    <div class="card mb-6">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-6 gap-4">
        <div class="lg:col-span-2">
          <input
            v-model="store.filters.search"
            @input="onSearchInput"
            type="text"
            placeholder="Search ticker or company..."
            class="input-field"
          />
        </div>

        <select v-model="store.filters.exchange" @change="applyFilters" class="input-field">
          <option value="">All Exchanges</option>
          <option v-for="e in store.exchanges" :key="e.code" :value="e.code">{{ e.code }} — {{ e.name }}</option>
        </select>

        <select v-model="store.filters.sector" @change="applyFilters" class="input-field">
          <option value="">All Sectors</option>
          <option v-for="s in store.sectors" :key="s" :value="s">{{ s }}</option>
        </select>

        <div class="flex items-center gap-4">
          <label class="flex items-center gap-2 text-sm text-gray-300 cursor-pointer">
            <input type="checkbox" v-model="store.filters.quanfury_only" @change="applyFilters"
              class="w-4 h-4 rounded bg-gray-700 border-gray-600 text-primary-600 focus:ring-primary-500" />
            Quanfury only
          </label>
        </div>

        <div class="flex items-center gap-2">
          <button @click="store.resetFilters()" class="btn-secondary text-sm">Reset</button>
          <span class="text-sm text-gray-400">{{ store.total.toLocaleString() }} stocks</span>
        </div>
      </div>

      <div class="flex items-center gap-4 mt-3 flex-wrap">
        <label class="flex items-center gap-2 text-sm text-gray-400 cursor-pointer">
          <input type="checkbox" v-model="store.filters.near_52w_low" @change="applyFilters"
            class="w-4 h-4 rounded bg-gray-700 border-gray-600 text-red-600 focus:ring-red-500" />
          Near 52W Low
        </label>
        <label class="flex items-center gap-2 text-sm text-gray-400 cursor-pointer">
          <input type="checkbox" v-model="store.filters.near_52w_high" @change="applyFilters"
            class="w-4 h-4 rounded bg-gray-700 border-gray-600 text-green-600 focus:ring-green-500" />
          Near 52W High
        </label>
        <div class="flex items-center gap-2">
          <span class="text-sm text-gray-400">Min Yield:</span>
          <input v-model.number="store.filters.min_div_yield" @change="applyFilters" type="number" step="0.5" min="0"
            placeholder="0" class="input-field w-20 text-sm" />
          <span class="text-sm text-gray-500">%</span>
        </div>
        <div class="flex items-center gap-2">
          <span class="text-sm text-gray-400">RSI:</span>
          <input v-model.number="store.filters.min_rsi" @change="applyFilters" type="number" step="1" min="0" max="100"
            placeholder="Min" class="input-field w-16 text-sm" />
          <span class="text-sm text-gray-500">–</span>
          <input v-model.number="store.filters.max_rsi" @change="applyFilters" type="number" step="1" min="0" max="100"
            placeholder="Max" class="input-field w-16 text-sm" />
        </div>
      </div>
    </div>

    <!-- Table -->
    <div class="card overflow-x-auto p-0">
      <table class="w-full text-sm">
        <thead>
          <tr class="border-b border-gray-800 text-left">
            <th class="px-4 py-3 cursor-pointer hover:text-primary-400 text-gray-400 font-medium" @click="store.setSort('ticker_yf')">
              Ticker{{ sortIcon('ticker_yf') }}
            </th>
            <th class="px-4 py-3 text-gray-400 font-medium hidden lg:table-cell">Company</th>
            <th class="px-4 py-3 text-gray-400 font-medium">Exch</th>
            <th class="px-4 py-3 text-gray-400 font-medium hidden xl:table-cell">Sector</th>
            <th class="px-4 py-3 cursor-pointer hover:text-primary-400 text-gray-400 font-medium text-right" @click="store.setSort('last_close')">
              Price{{ sortIcon('last_close') }}
            </th>
            <th class="px-4 py-3 cursor-pointer hover:text-primary-400 text-gray-400 font-medium text-right" @click="store.setSort('div_yield_ttm')">
              Yield{{ sortIcon('div_yield_ttm') }}
            </th>
            <th class="px-4 py-3 cursor-pointer hover:text-primary-400 text-gray-400 font-medium text-right hidden md:table-cell" @click="store.setSort('rsi_14')">
              RSI{{ sortIcon('rsi_14') }}
            </th>
            <th class="px-4 py-3 text-gray-400 font-medium text-right hidden lg:table-cell">52W Range</th>
            <th class="px-4 py-3 text-gray-400 font-medium text-center">QF</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="store.loading" class="border-b border-gray-800/50">
            <td colspan="9" class="px-4 py-8 text-center text-gray-500">Loading...</td>
          </tr>
          <tr v-else-if="store.stocks.length === 0" class="border-b border-gray-800/50">
            <td colspan="9" class="px-4 py-8 text-center text-gray-500">No stocks found</td>
          </tr>
          <tr
            v-for="stock in store.stocks"
            :key="stock.id"
            @click="goToStock(stock.id)"
            class="border-b border-gray-800/50 hover:bg-gray-800/50 cursor-pointer transition-colors"
          >
            <td class="px-4 py-3">
              <span class="font-mono font-medium text-white">{{ stock.symbol }}</span>
            </td>
            <td class="px-4 py-3 text-gray-300 hidden lg:table-cell truncate max-w-[200px]">{{ stock.company_name }}</td>
            <td class="px-4 py-3">
              <span class="badge-blue">{{ stock.exchange_code }}</span>
            </td>
            <td class="px-4 py-3 text-gray-400 text-sm hidden xl:table-cell truncate max-w-[120px]">{{ stock.sector }}</td>
            <td class="px-4 py-3 text-right font-mono text-gray-200">{{ fmt(stock.last_close) }}</td>
            <td class="px-4 py-3 text-right font-mono font-medium" :class="yieldColor(stock.div_yield_ttm)">
              {{ stock.div_yield_ttm ? fmt(stock.div_yield_ttm) + '%' : '—' }}
            </td>
            <td class="px-4 py-3 text-right font-mono hidden md:table-cell" :class="rsiColor(stock.rsi_14)">
              {{ stock.rsi_14 ? fmt(stock.rsi_14, 0) : '—' }}
            </td>
            <td class="px-4 py-3 hidden lg:table-cell">
              <div v-if="stock.week_52_high && stock.week_52_low" class="flex items-center gap-2">
                <span class="text-xs text-gray-500 font-mono">{{ fmt(stock.week_52_low, 1) }}</span>
                <div class="flex-1 h-1.5 bg-gray-700 rounded-full relative min-w-[60px]">
                  <div
                    class="absolute h-full rounded-full"
                    :class="(stock.week_52_pct ?? 0) < 20 ? 'bg-red-500' : (stock.week_52_pct ?? 0) > 80 ? 'bg-green-500' : 'bg-yellow-500'"
                    :style="{ width: Math.min(100, Math.max(2, stock.week_52_pct ?? 0)) + '%' }"
                  ></div>
                </div>
                <span class="text-xs text-gray-500 font-mono">{{ fmt(stock.week_52_high, 1) }}</span>
              </div>
              <span v-else class="text-gray-600">—</span>
            </td>
            <td class="px-4 py-3 text-center">
              <span v-if="stock.is_quanfury_available" class="badge-purple text-[10px]">QF</span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div v-if="store.pages > 1" class="flex items-center justify-center gap-2 mt-6">
      <button @click="store.setPage(store.filters.page - 1)" :disabled="store.filters.page <= 1"
        class="btn-secondary text-sm px-3 py-1">Prev</button>
      <button
        v-for="p in pageNumbers"
        :key="p"
        @click="store.setPage(p)"
        :class="[
          'px-3 py-1 rounded-lg text-sm font-medium transition-colors',
          p === store.filters.page ? 'bg-primary-600 text-white' : 'bg-gray-800 text-gray-400 hover:bg-gray-700',
        ]"
      >{{ p }}</button>
      <button @click="store.setPage(store.filters.page + 1)" :disabled="store.filters.page >= store.pages"
        class="btn-secondary text-sm px-3 py-1">Next</button>
    </div>
  </div>
</template>
