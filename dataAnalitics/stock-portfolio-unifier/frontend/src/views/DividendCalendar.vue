<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import type { DividendCalendarItem } from '../types'
import { fetchDividendCalendar, fetchDividendStats, searchStockByTicker } from '../services/api'

const router = useRouter()
const items = ref<DividendCalendarItem[]>([])
const stats = ref<any>(null)
const loading = ref(true)
const navigating = ref<string | null>(null)
const filterExchange = ref('')
const filterSource = ref('')
const filterQuanfuryOnly = ref(false)
const viewMode = ref<'list' | 'calendar'>('list')

const startDate = ref(getMonthStart())
const endDate = ref(getMonthEnd())

function getMonthStart(): string {
  const d = new Date()
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-01`
}

function getMonthEnd(): string {
  const d = new Date()
  d.setMonth(d.getMonth() + 3)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(new Date(d.getFullYear(), d.getMonth() + 1, 0).getDate()).padStart(2, '0')}`
}

onMounted(async () => {
  await loadData()
  stats.value = await fetchDividendStats()
})

async function loadData() {
  loading.value = true
  try {
    const params: Record<string, any> = {
      start_date: startDate.value,
      end_date: endDate.value,
    }
    if (filterExchange.value) params.exchange = filterExchange.value
    if (filterQuanfuryOnly.value) params.quanfury_only = true
    items.value = await fetchDividendCalendar(params)
  } finally {
    loading.value = false
  }
}

async function goToStock(item: DividendCalendarItem) {
  if (navigating.value) return
  navigating.value = item.ticker

  try {
    if (item.stock_id) {
      router.push(`/stocks/${item.stock_id}`)
      return
    }
    const stockId = await searchStockByTicker(item.ticker)
    if (stockId) {
      router.push(`/stocks/${stockId}`)
    }
  } finally {
    navigating.value = null
  }
}

const filteredItems = computed(() => {
  let result = items.value
  if (filterSource.value) {
    result = result.filter(i => i.source === filterSource.value)
  }
  return result
})

const groupedByDate = computed(() => {
  const groups: Record<string, DividendCalendarItem[]> = {}
  for (const item of filteredItems.value) {
    if (!groups[item.date]) groups[item.date] = []
    groups[item.date].push(item)
  }
  return Object.entries(groups).sort(([a], [b]) => a.localeCompare(b))
})

const calendarWeeks = computed(() => {
  const start = new Date(startDate.value)
  const days: { date: string; day: number; items: DividendCalendarItem[]; isCurrentMonth: boolean }[] = []

  const current = new Date(start)
  current.setDate(1)
  const dayOfWeek = current.getDay()
  current.setDate(current.getDate() - dayOfWeek)

  const itemMap: Record<string, DividendCalendarItem[]> = {}
  for (const item of filteredItems.value) {
    if (!itemMap[item.date]) itemMap[item.date] = []
    itemMap[item.date].push(item)
  }

  for (let i = 0; i < 42; i++) {
    const dateStr = current.toISOString().slice(0, 10)
    days.push({
      date: dateStr,
      day: current.getDate(),
      items: itemMap[dateStr] || [],
      isCurrentMonth: current.getMonth() === start.getMonth(),
    })
    current.setDate(current.getDate() + 1)
  }

  return days
})

const totalEventsInRange = computed(() => filteredItems.value.length)
const uniqueTickersInRange = computed(() => new Set(filteredItems.value.map(i => i.ticker)).size)

function fmt(n: number | null | undefined, decimals = 4): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}

function fmtPrice(n: number | null | undefined): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
}

function yieldColor(y: number | null | undefined): string {
  if (!y) return 'text-gray-500'
  if (y >= 8) return 'text-green-400'
  if (y >= 4) return 'text-green-300'
  if (y >= 2) return 'text-yellow-400'
  return 'text-gray-400'
}

function shiftMonth(delta: number) {
  const d = new Date(startDate.value)
  d.setMonth(d.getMonth() + delta)
  startDate.value = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-01`

  const e = new Date(endDate.value)
  e.setMonth(e.getMonth() + delta)
  endDate.value = `${e.getFullYear()}-${String(e.getMonth() + 1).padStart(2, '0')}-${String(new Date(e.getFullYear(), e.getMonth() + 1, 0).getDate()).padStart(2, '0')}`

  loadData()
}
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-6">
      <div>
        <h1 class="text-3xl font-bold text-white">Dividend Calendar</h1>
        <p v-if="stats" class="text-sm text-gray-400 mt-1">
          {{ stats.total_dividend_events?.toLocaleString() }} historical events ·
          {{ stats.total_quanfury_dividends?.toLocaleString() }} Quanfury dividends ·
          {{ stats.stocks_paying_dividends }} stocks paying dividends
        </p>
      </div>
      <div class="flex items-center gap-2">
        <button @click="viewMode = 'list'" :class="viewMode === 'list' ? 'btn-primary' : 'btn-secondary'" class="text-sm !px-3 !py-1.5">List</button>
        <button @click="viewMode = 'calendar'" :class="viewMode === 'calendar' ? 'btn-primary' : 'btn-secondary'" class="text-sm !px-3 !py-1.5">Calendar</button>
      </div>
    </div>

    <!-- Filters -->
    <div class="card mb-6">
      <div class="flex items-end gap-4 flex-wrap">
        <div>
          <label class="text-xs text-gray-400">Start Date</label>
          <input v-model="startDate" type="date" class="input-field mt-1" />
        </div>
        <div>
          <label class="text-xs text-gray-400">End Date</label>
          <input v-model="endDate" type="date" class="input-field mt-1" />
        </div>
        <div>
          <label class="text-xs text-gray-400">Exchange</label>
          <select v-model="filterExchange" class="input-field mt-1">
            <option value="">All</option>
            <option value="TSX">TSX</option>
            <option value="NYSE">NYSE</option>
            <option value="LSE">LSE</option>
          </select>
        </div>
        <div>
          <label class="text-xs text-gray-400">Source</label>
          <select v-model="filterSource" class="input-field mt-1">
            <option value="">All</option>
            <option value="historical">Historical</option>
            <option value="quanfury">Quanfury</option>
          </select>
        </div>
        <label class="flex items-center gap-2 text-sm text-gray-300 cursor-pointer pb-2">
          <input type="checkbox" v-model="filterQuanfuryOnly" @change="loadData"
            class="w-4 h-4 rounded bg-gray-700 border-gray-600 text-primary-600" />
          Quanfury only
        </label>
        <button @click="loadData" class="btn-primary">Apply</button>
      </div>
      <div class="flex items-center gap-4 mt-3 text-sm text-gray-400">
        <span>{{ totalEventsInRange }} events in range</span>
        <span>·</span>
        <span>{{ uniqueTickersInRange }} unique tickers</span>
        <div class="flex-1"></div>
        <button @click="shiftMonth(-1)" class="text-gray-400 hover:text-white transition-colors">← Prev Month</button>
        <button @click="shiftMonth(1)" class="text-gray-400 hover:text-white transition-colors">Next Month →</button>
      </div>
    </div>

    <div v-if="loading" class="text-gray-400 py-12 text-center">Loading dividends...</div>

    <!-- List View -->
    <template v-else-if="viewMode === 'list'">
      <!-- Column header -->
      <div class="grid grid-cols-[1fr_auto_auto_auto_auto] items-center gap-x-4 px-6 py-2 text-xs text-gray-500 font-medium mb-2">
        <span>Stock</span>
        <span class="text-right min-w-[70px]">Price</span>
        <span class="text-right min-w-[55px]">Yield</span>
        <span class="text-right min-w-[80px]">Dividend</span>
        <span class="w-4"></span>
      </div>

      <div class="space-y-4">
        <div v-for="[date, dateItems] in groupedByDate" :key="date" class="card !p-4">
          <h3 class="text-sm font-medium text-primary-400 mb-3">
            {{ date }}
            <span class="text-gray-500 ml-2">({{ dateItems.length }} events)</span>
          </h3>
          <div class="space-y-1.5">
            <button
              v-for="item in dateItems"
              :key="item.ticker + item.amount + item.source"
              @click="goToStock(item)"
              class="w-full grid grid-cols-[1fr_auto_auto_auto_auto] items-center gap-x-4 p-2.5 bg-gray-800 rounded-lg hover:bg-gray-700/80 transition-colors text-left group relative"
            >
              <div class="flex items-center gap-3 min-w-0">
                <span class="font-mono font-medium text-white text-sm group-hover:text-primary-400 transition-colors">{{ item.ticker }}</span>
                <span class="text-xs text-gray-400 truncate max-w-[160px] hidden sm:inline">{{ item.company_name }}</span>
                <span v-if="item.exchange_code" class="badge-blue text-[10px]">{{ item.exchange_code }}</span>
                <span v-if="item.is_quanfury" class="badge-purple text-[10px]">QF</span>
                <span v-if="item.in_portfolio" class="badge-green text-[10px]">IN PORTFOLIO</span>
              </div>
              <div class="text-right min-w-[70px]">
                <span class="font-mono text-white text-sm">{{ item.last_close ? fmtPrice(item.last_close) : '—' }}</span>
              </div>
              <div class="text-right min-w-[55px]">
                <span class="font-mono text-sm font-medium" :class="yieldColor(item.div_yield_ttm)">
                  {{ item.div_yield_ttm ? fmtPrice(item.div_yield_ttm) + '%' : '—' }}
                </span>
              </div>
              <div class="text-right min-w-[80px]">
                <span class="font-mono text-green-400 text-sm">{{ fmt(item.amount) }}</span>
                <span class="text-xs text-gray-500 ml-1">{{ item.currency }}</span>
              </div>
              <svg class="w-4 h-4 text-gray-600 group-hover:text-primary-400 transition-colors flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
              <span v-if="navigating === item.ticker"
                class="absolute inset-0 flex items-center justify-center bg-gray-800/80 rounded-lg">
                <span class="text-xs text-primary-400">Loading...</span>
              </span>
            </button>
          </div>
        </div>
        <p v-if="groupedByDate.length === 0" class="text-gray-500 text-center py-8">No dividend events in this range.</p>
      </div>
    </template>

    <!-- Calendar View -->
    <template v-else>
      <div class="card !p-4">
        <div class="grid grid-cols-7 gap-px">
          <div v-for="day in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']" :key="day"
            class="text-center text-xs text-gray-500 font-medium py-2">{{ day }}</div>
          <div v-for="cell in calendarWeeks" :key="cell.date"
            :class="[
              'min-h-[90px] p-1.5 border border-gray-800 rounded',
              cell.isCurrentMonth ? 'bg-gray-900' : 'bg-gray-950',
            ]">
            <p class="text-xs font-medium mb-1" :class="cell.isCurrentMonth ? 'text-gray-400' : 'text-gray-600'">{{ cell.day }}</p>
            <button
              v-for="item in cell.items.slice(0, 3)"
              :key="item.ticker + item.source"
              @click="goToStock(item)"
              :class="[
                'w-full text-left text-[10px] px-1 py-0.5 rounded mb-0.5 truncate cursor-pointer transition-colors',
                item.source === 'quanfury'
                  ? 'bg-purple-900/50 text-purple-300 hover:bg-purple-800/60'
                  : 'bg-green-900/50 text-green-300 hover:bg-green-800/60',
              ]"
            >
              {{ item.ticker }} {{ item.amount.toFixed(2) }}
            </button>
            <p v-if="cell.items.length > 3" class="text-[10px] text-gray-500">+{{ cell.items.length - 3 }} more</p>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>
