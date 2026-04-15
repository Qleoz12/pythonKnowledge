<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { usePortfoliosStore } from '../stores/portfolios'
import { fetchStocks } from '../services/api'
import type { Stock } from '../types'
import PortfolioStressAnalysis from '../components/PortfolioStressAnalysis.vue'

const route = useRoute()
const router = useRouter()
const store = usePortfoliosStore()

const showSnapshot = ref(false)
const showAddHolding = ref(false)
const snapMonth = ref(new Date().getMonth() + 1)
const snapYear = ref(new Date().getFullYear())
const snapValue = ref(0)
const snapDivs = ref(0)
const snapNotes = ref('')

const stockSearch = ref('')
const searchResults = ref<Stock[]>([])
const searchLoading = ref(false)
const selectedStock = ref<Stock | null>(null)
const addShares = ref(1)
const addPrice = ref(0)

const portfolio = computed(() => store.currentPortfolio)

onMounted(async () => {
  await store.loadPortfolio(Number(route.params.id))
  if (portfolio.value?.total_value) {
    snapValue.value = portfolio.value.total_value
  }
})

function fmt(n: number | null | undefined, decimals = 2): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}

let searchTimeout: ReturnType<typeof setTimeout> | null = null
function onStockSearch() {
  if (searchTimeout) clearTimeout(searchTimeout)
  selectedStock.value = null
  if (!stockSearch.value || stockSearch.value.length < 2) {
    searchResults.value = []
    return
  }
  searchTimeout = setTimeout(async () => {
    searchLoading.value = true
    try {
      const result = await fetchStocks({ search: stockSearch.value, page_size: 10 })
      searchResults.value = result.items
    } finally {
      searchLoading.value = false
    }
  }, 300)
}

function selectStock(stock: Stock) {
  selectedStock.value = stock
  stockSearch.value = `${stock.symbol} — ${stock.company_name}`
  searchResults.value = []
  addPrice.value = stock.last_close ?? 0
}

async function addHoldingToPortfolio() {
  if (!selectedStock.value || !portfolio.value) return
  await store.addStock(portfolio.value.id, selectedStock.value.id, addShares.value, addPrice.value)
  showAddHolding.value = false
  selectedStock.value = null
  stockSearch.value = ''
  addShares.value = 1
  addPrice.value = 0
}

async function removeHolding(holdingId: number, ticker: string) {
  if (confirm(`Remove ${ticker} from portfolio?`)) {
    await store.removeStock(portfolio.value!.id, holdingId)
  }
}

async function saveSnapshot() {
  if (!portfolio.value) return
  await store.saveSnapshot(portfolio.value.id, snapMonth.value, snapYear.value, snapValue.value, snapDivs.value, snapNotes.value)
  showSnapshot.value = false
}

const holdingsSorted = computed(() => {
  if (!portfolio.value) return []
  return [...portfolio.value.holdings].sort((a, b) => (b.current_value ?? 0) - (a.current_value ?? 0))
})

function detectExchange(ticker: string): string {
  if (ticker.endsWith('.TO') || ticker.endsWith('.V')) return 'TSX'
  if (ticker.endsWith('.L')) return 'LSE'
  return 'US'
}

const exchangeAllocation = computed(() => {
  if (!portfolio.value) return []
  const map: Record<string, number> = {}
  for (const h of portfolio.value.holdings) {
    const key = detectExchange(h.ticker_yf)
    map[key] = (map[key] || 0) + (h.current_value || 0)
  }
  const total = Object.values(map).reduce((a, b) => a + b, 0)
  return Object.entries(map).map(([name, value]) => ({
    name,
    value: Math.round(value * 100) / 100,
    pct: total > 0 ? Math.round(value / total * 1000) / 10 : 0,
  })).sort((a, b) => b.value - a.value)
})

const totalDividendsReceived = computed(() => {
  if (!portfolio.value?.snapshots.length) return 0
  return portfolio.value.snapshots.reduce((sum, s) => sum + (s.total_dividends || 0), 0)
})

const showStressAnalysis = computed(() => portfolio.value?.name?.trim() === 'L')
</script>

<template>
  <div>
    <button @click="router.push('/portfolios')" class="text-gray-400 hover:text-white text-sm mb-4 flex items-center gap-1">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
      </svg>
      All Portfolios
    </button>

    <div v-if="store.loading" class="text-gray-400 py-20 text-center">Loading...</div>

    <template v-else-if="portfolio">
      <!-- Header -->
      <div class="flex items-start justify-between mb-8">
        <div>
          <h1 class="text-3xl font-bold text-white">{{ portfolio.name }}</h1>
          <div class="flex items-center gap-2 mt-1">
            <span v-if="portfolio.broker" class="badge-blue">{{ portfolio.broker }}</span>
            <span class="text-sm text-gray-400">{{ portfolio.holdings_count }} holdings</span>
          </div>
          <p v-if="portfolio.description" class="text-sm text-gray-400 mt-1">{{ portfolio.description }}</p>
        </div>
        <div class="flex items-center gap-3">
          <button @click="showAddHolding = !showAddHolding" class="btn-secondary text-sm">
            {{ showAddHolding ? 'Cancel' : '+ Add Stock' }}
          </button>
          <button @click="showSnapshot = !showSnapshot" class="btn-primary text-sm">
            {{ showSnapshot ? 'Cancel' : 'Record Snapshot' }}
          </button>
        </div>
      </div>

      <!-- Summary cards -->
      <div class="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
        <div class="card !p-4">
          <p class="text-xs text-gray-400">Total Value</p>
          <p class="text-2xl font-bold text-white">${{ fmt(portfolio.total_value) }}</p>
        </div>
        <div class="card !p-4">
          <p class="text-xs text-gray-400">Total Cost</p>
          <p class="text-2xl font-bold text-gray-300">${{ fmt(portfolio.total_cost) }}</p>
        </div>
        <div class="card !p-4">
          <p class="text-xs text-gray-400">Gain / Loss</p>
          <p class="text-2xl font-bold" :class="(portfolio.total_gain_pct ?? 0) >= 0 ? 'text-green-400' : 'text-red-400'">
            {{ portfolio.total_gain_pct != null ? fmt(portfolio.total_gain_pct, 1) + '%' : '—' }}
          </p>
        </div>
        <div class="card !p-4">
          <p class="text-xs text-gray-400">Est. Annual Dividends</p>
          <p class="text-2xl font-bold text-green-400">${{ fmt(portfolio.estimated_annual_dividends) }}</p>
        </div>
        <div class="card !p-4">
          <p class="text-xs text-gray-400">Avg Yield</p>
          <p class="text-2xl font-bold text-green-300">{{ portfolio.avg_yield ? fmt(portfolio.avg_yield) + '%' : '—' }}</p>
        </div>
      </div>

      <PortfolioStressAnalysis v-if="showStressAnalysis" />

      <!-- Add holding panel -->
      <div v-if="showAddHolding" class="card mb-6">
        <h3 class="text-sm font-medium text-white mb-3">Add Stock to Portfolio</h3>
        <div class="relative mb-4">
          <input
            v-model="stockSearch"
            @input="onStockSearch"
            type="text"
            placeholder="Search by ticker or company name..."
            class="input-field"
          />
          <div v-if="searchResults.length > 0"
            class="absolute z-10 w-full mt-1 bg-gray-800 border border-gray-700 rounded-lg shadow-xl max-h-60 overflow-y-auto">
            <button
              v-for="s in searchResults"
              :key="s.id"
              @click="selectStock(s)"
              class="w-full flex items-center justify-between px-4 py-2.5 hover:bg-gray-700 text-left transition-colors"
            >
              <div class="flex items-center gap-3">
                <span class="font-mono font-medium text-white text-sm">{{ s.symbol }}</span>
                <span class="text-gray-400 text-sm truncate max-w-[200px]">{{ s.company_name }}</span>
                <span class="badge-blue text-[10px]">{{ s.exchange_code }}</span>
                <span v-if="s.is_quanfury_available" class="badge-purple text-[10px]">QF</span>
              </div>
              <div class="text-right text-sm">
                <span class="text-white font-mono">{{ s.last_close ? fmt(s.last_close) : '—' }}</span>
                <span v-if="s.div_yield_ttm" class="text-green-400 ml-2">{{ fmt(s.div_yield_ttm) }}%</span>
              </div>
            </button>
          </div>
          <p v-if="searchLoading" class="text-xs text-gray-500 mt-1">Searching...</p>
        </div>
        <div v-if="selectedStock" class="flex items-end gap-4 flex-wrap">
          <div>
            <label class="text-xs text-gray-400">Selected</label>
            <p class="text-sm text-white font-medium mt-1">{{ selectedStock.symbol }} — {{ selectedStock.company_name }}</p>
          </div>
          <div>
            <label class="text-xs text-gray-400">Shares</label>
            <input v-model.number="addShares" type="number" min="0.01" step="0.01" class="input-field mt-1 w-28" />
          </div>
          <div>
            <label class="text-xs text-gray-400">Avg Price</label>
            <input v-model.number="addPrice" type="number" min="0" step="0.01" class="input-field mt-1 w-32" />
          </div>
          <button @click="addHoldingToPortfolio" class="btn-primary">Add to Portfolio</button>
        </div>
      </div>

      <!-- Snapshot form -->
      <div v-if="showSnapshot" class="card mb-6">
        <h3 class="text-sm font-medium text-white mb-3">Monthly Snapshot</h3>
        <div class="grid grid-cols-2 md:grid-cols-5 gap-4 mb-4">
          <div>
            <label class="text-xs text-gray-400">Month</label>
            <input v-model.number="snapMonth" type="number" min="1" max="12" class="input-field mt-1" />
          </div>
          <div>
            <label class="text-xs text-gray-400">Year</label>
            <input v-model.number="snapYear" type="number" min="2020" class="input-field mt-1" />
          </div>
          <div>
            <label class="text-xs text-gray-400">Total Value</label>
            <input v-model.number="snapValue" type="number" step="0.01" class="input-field mt-1" />
          </div>
          <div>
            <label class="text-xs text-gray-400">Dividends Received</label>
            <input v-model.number="snapDivs" type="number" step="0.01" class="input-field mt-1" />
          </div>
          <div>
            <label class="text-xs text-gray-400">Notes</label>
            <input v-model="snapNotes" type="text" class="input-field mt-1" />
          </div>
        </div>
        <button @click="saveSnapshot" class="btn-primary">Save Snapshot</button>
      </div>

      <!-- Exchange allocation -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
        <div class="card lg:col-span-1">
          <h3 class="text-sm font-medium text-gray-400 mb-4">Exchange Allocation</h3>
          <div class="space-y-3">
            <div v-for="a in exchangeAllocation" :key="a.name">
              <div class="flex justify-between text-sm mb-1">
                <span class="text-gray-300">{{ a.name }}</span>
                <span class="text-gray-400">{{ a.pct }}% (${{ fmt(a.value) }})</span>
              </div>
              <div class="h-2 bg-gray-800 rounded-full">
                <div class="h-full bg-primary-500 rounded-full" :style="{ width: a.pct + '%' }"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- Snapshots timeline -->
        <div class="card lg:col-span-2">
          <h3 class="text-sm font-medium text-gray-400 mb-4">Monthly Snapshots</h3>
          <div v-if="portfolio.snapshots.length > 0" class="overflow-x-auto">
            <table class="w-full text-sm">
              <thead>
                <tr class="border-b border-gray-800 text-gray-400">
                  <th class="px-3 py-2 text-left font-medium">Period</th>
                  <th class="px-3 py-2 text-right font-medium">Value</th>
                  <th class="px-3 py-2 text-right font-medium">Dividends</th>
                  <th class="px-3 py-2 text-left font-medium">Notes</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="s in portfolio.snapshots" :key="s.id" class="border-b border-gray-800/50">
                  <td class="px-3 py-2 text-gray-300">{{ s.year }}-{{ String(s.month).padStart(2, '0') }}</td>
                  <td class="px-3 py-2 text-right text-white font-mono">${{ fmt(s.total_value) }}</td>
                  <td class="px-3 py-2 text-right text-green-400 font-mono">${{ fmt(s.total_dividends) }}</td>
                  <td class="px-3 py-2 text-gray-400 truncate max-w-[200px]">{{ s.notes }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <p v-else class="text-gray-500 text-sm text-center py-4">No snapshots yet. Record your first monthly snapshot.</p>
        </div>
      </div>

      <!-- Holdings table -->
      <div class="card overflow-x-auto p-0">
        <div class="px-6 py-4 border-b border-gray-800">
          <h3 class="text-lg font-semibold text-white">Holdings</h3>
        </div>
        <table class="w-full text-sm">
          <thead>
            <tr class="border-b border-gray-800 text-gray-400">
              <th class="px-4 py-3 text-left font-medium">Ticker</th>
              <th class="px-4 py-3 text-left font-medium hidden md:table-cell">Company</th>
              <th class="px-4 py-3 text-right font-medium">Shares</th>
              <th class="px-4 py-3 text-right font-medium">Avg Price</th>
              <th class="px-4 py-3 text-right font-medium">Current</th>
              <th class="px-4 py-3 text-right font-medium">Value</th>
              <th class="px-4 py-3 text-right font-medium">Gain</th>
              <th class="px-4 py-3 text-right font-medium hidden lg:table-cell">Yield</th>
              <th class="px-4 py-3 text-right font-medium hidden lg:table-cell">Ann. Div</th>
              <th class="px-4 py-3 text-center font-medium">QF</th>
              <th class="px-4 py-3"></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="h in holdingsSorted" :key="h.id"
              class="border-b border-gray-800/50 hover:bg-gray-800/50 cursor-pointer"
              @click="router.push(`/stocks/${h.stock_id}`)">
              <td class="px-4 py-3 font-mono font-medium text-white">{{ h.symbol }}</td>
              <td class="px-4 py-3 text-gray-300 hidden md:table-cell truncate max-w-[180px]">{{ h.company_name }}</td>
              <td class="px-4 py-3 text-right text-gray-200 font-mono">{{ h.shares }}</td>
              <td class="px-4 py-3 text-right text-gray-400 font-mono">{{ fmt(h.avg_price) }}</td>
              <td class="px-4 py-3 text-right text-white font-mono">{{ fmt(h.current_price) }}</td>
              <td class="px-4 py-3 text-right text-white font-mono font-medium">${{ fmt(h.current_value) }}</td>
              <td class="px-4 py-3 text-right font-mono font-medium"
                :class="(h.gain_pct ?? 0) >= 0 ? 'text-green-400' : 'text-red-400'">
                {{ h.gain_pct != null ? fmt(h.gain_pct, 1) + '%' : '—' }}
              </td>
              <td class="px-4 py-3 text-right text-green-300 font-mono hidden lg:table-cell">
                {{ h.div_yield_ttm ? fmt(h.div_yield_ttm) + '%' : '—' }}
              </td>
              <td class="px-4 py-3 text-right text-green-400 font-mono hidden lg:table-cell">
                {{ h.annual_dividend ? '$' + fmt(h.annual_dividend) : '—' }}
              </td>
              <td class="px-4 py-3 text-center">
                <span v-if="h.is_quanfury" class="badge-purple text-[10px]">QF</span>
              </td>
              <td class="px-4 py-3 text-center">
                <button @click.stop="removeHolding(h.id, h.ticker_yf)"
                  class="text-gray-500 hover:text-red-400 transition-colors p-1">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        <p v-if="holdingsSorted.length === 0" class="text-gray-500 text-sm text-center py-8">
          No holdings yet. Add stocks from the Stock Explorer.
        </p>
      </div>
    </template>
  </div>
</template>
