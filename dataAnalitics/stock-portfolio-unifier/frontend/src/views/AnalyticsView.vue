<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import type { WeekProximityItem } from '../types'
import { fetchWeekProximity, fetchTopDividendYields, searchStockByTicker } from '../services/api'

const router = useRouter()
const results = ref<WeekProximityItem[]>([])
const topYields = ref<any[]>([])
const loading = ref(true)

const period = ref('52')
const direction = ref('low')
const threshold = ref(10)
const filterMode = ref('distance')
const exchange = ref('')
const quanfuryOnly = ref(false)
const minYield = ref<number | null>(null)

onMounted(() => loadData())

async function loadData() {
  loading.value = true
  try {
    const params: Record<string, any> = {
      period: period.value,
      direction: direction.value,
      threshold: threshold.value,
      filter_mode: filterMode.value,
      limit: 100,
    }
    if (exchange.value) params.exchange = exchange.value
    if (quanfuryOnly.value) params.quanfury_only = true
    if (minYield.value) params.min_div_yield = minYield.value

    const [prox, yields] = await Promise.all([
      fetchWeekProximity(params),
      fetchTopDividendYields({
        exchange: exchange.value || undefined,
        quanfury_only: quanfuryOnly.value || undefined,
        limit: 25,
      }),
    ])
    results.value = prox
    topYields.value = yields
  } finally {
    loading.value = false
  }
}

async function goToYieldStock(ticker: string) {
  const id = await searchStockByTicker(ticker)
  if (id) router.push(`/stocks/${id}`)
}

function fmt(n: number | null | undefined, decimals = 2): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}
</script>

<template>
  <div>
    <h1 class="text-3xl font-bold text-white mb-6">Analytics</h1>

    <!-- Filters -->
    <div class="card mb-6">
      <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-4">
        <div>
          <label class="text-xs text-gray-400">Period</label>
          <select v-model="period" class="input-field mt-1">
            <option value="52">52 Weeks</option>
            <option value="100">100 Weeks</option>
            <option value="200">200 Weeks</option>
          </select>
        </div>
        <div>
          <label class="text-xs text-gray-400">Direction</label>
          <select v-model="direction" class="input-field mt-1">
            <option value="low">Near Low (Buy Signal)</option>
            <option value="high">Near High</option>
          </select>
        </div>
        <div>
          <label class="text-xs text-gray-400">Filter Mode</label>
          <select v-model="filterMode" class="input-field mt-1">
            <option value="distance">% from Low/High</option>
            <option value="range">Range Position</option>
          </select>
        </div>
        <div>
          <label class="text-xs text-gray-400">
            {{ filterMode === 'range' ? 'Range %' : 'Threshold %' }}
          </label>
          <input v-model.number="threshold" type="number" min="1" max="50" step="1" class="input-field mt-1" />
        </div>
        <div>
          <label class="text-xs text-gray-400">Exchange</label>
          <select v-model="exchange" class="input-field mt-1">
            <option value="">All</option>
            <option value="TSX">TSX</option>
            <option value="NYSE">NYSE</option>
            <option value="LSE">LSE</option>
          </select>
        </div>
        <div class="flex items-end gap-3">
          <label class="flex items-center gap-2 text-sm text-gray-300 cursor-pointer pb-2">
            <input type="checkbox" v-model="quanfuryOnly"
              class="w-4 h-4 rounded bg-gray-700 border-gray-600 text-primary-600" />
            QF only
          </label>
        </div>
        <div class="flex items-end">
          <button @click="loadData" class="btn-primary w-full">Search</button>
        </div>
      </div>
      <div class="flex items-center gap-4 mt-3">
        <div class="flex items-center gap-2">
          <label class="text-xs text-gray-400">Min Div Yield:</label>
          <input v-model.number="minYield" type="number" min="0" step="0.5" placeholder="any" class="input-field w-20 text-sm" />
          <span class="text-xs text-gray-500">%</span>
        </div>
      </div>
    </div>

    <div v-if="loading" class="text-gray-400 py-12 text-center">Loading analytics...</div>

    <template v-else>
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Week proximity results -->
        <div class="lg:col-span-2">
          <div class="card overflow-x-auto p-0">
            <div class="px-6 py-4 border-b border-gray-800 flex items-center justify-between">
              <h2 class="text-lg font-semibold text-white">
                {{ direction === 'low' ? 'Near ' + period + 'W Low' : 'Near ' + period + 'W High' }}
              </h2>
              <span class="text-sm text-gray-400">{{ results.length }} stocks</span>
            </div>
            <table class="w-full text-sm">
              <thead>
                <tr class="border-b border-gray-800 text-gray-400">
                  <th class="px-4 py-3 text-left font-medium">Ticker</th>
                  <th class="px-4 py-3 text-left font-medium hidden md:table-cell">Company</th>
                  <th class="px-4 py-3 font-medium">Exch</th>
                  <th class="px-4 py-3 text-right font-medium">Price</th>
                  <th class="px-4 py-3 text-right font-medium">{{ period }}W Low</th>
                  <th class="px-4 py-3 text-right font-medium">{{ period }}W High</th>
                  <th class="px-4 py-3 text-right font-medium">Range %</th>
                  <th class="px-4 py-3 text-right font-medium">Yield</th>
                  <th class="px-4 py-3 text-right font-medium hidden lg:table-cell">RSI</th>
                  <th class="px-4 py-3 text-center font-medium">QF</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in results" :key="item.id"
                  class="border-b border-gray-800/50 hover:bg-gray-800/50 cursor-pointer"
                  @click="router.push(`/stocks/${item.id}`)">
                  <td class="px-4 py-2.5 font-mono font-medium text-white">{{ item.ticker_yf }}</td>
                  <td class="px-4 py-2.5 text-gray-300 hidden md:table-cell truncate max-w-[160px]">{{ item.company_name }}</td>
                  <td class="px-4 py-2.5"><span class="badge-blue">{{ item.exchange_code }}</span></td>
                  <td class="px-4 py-2.5 text-right font-mono text-white">{{ fmt(item.last_close) }}</td>
                  <td class="px-4 py-2.5 text-right font-mono text-red-400">{{ fmt(period === '52' ? item.week_52_low : period === '100' ? (item as any).week_100_low : (item as any).week_200_low) }}</td>
                  <td class="px-4 py-2.5 text-right font-mono text-green-400">{{ fmt(period === '52' ? item.week_52_high : period === '100' ? (item as any).week_100_high : (item as any).week_200_high) }}</td>
                  <td class="px-4 py-2.5 text-right">
                    <div class="flex items-center justify-end gap-2">
                      <div class="w-16 h-1.5 bg-gray-700 rounded-full">
                        <div class="h-full rounded-full"
                          :class="((period === '52' ? item.week_52_pct : period === '100' ? (item as any).week_100_pct : (item as any).week_200_pct) ?? 0) < 20 ? 'bg-red-500' : ((period === '52' ? item.week_52_pct : period === '100' ? (item as any).week_100_pct : (item as any).week_200_pct) ?? 0) > 80 ? 'bg-green-500' : 'bg-yellow-500'"
                          :style="{ width: ((period === '52' ? item.week_52_pct : period === '100' ? (item as any).week_100_pct : (item as any).week_200_pct) ?? 0) + '%' }"></div>
                      </div>
                      <span class="text-xs text-gray-400 w-8 text-right">{{ (period === '52' ? item.week_52_pct : period === '100' ? (item as any).week_100_pct : (item as any).week_200_pct) ?? 0 }}%</span>
                    </div>
                  </td>
                  <td class="px-4 py-2.5 text-right font-mono text-green-400">
                    {{ item.div_yield_ttm ? fmt(item.div_yield_ttm) + '%' : '—' }}
                  </td>
                  <td class="px-4 py-2.5 text-right font-mono text-gray-300 hidden lg:table-cell">
                    {{ item.rsi_14 ? fmt(item.rsi_14, 0) : '—' }}
                  </td>
                  <td class="px-4 py-2.5 text-center">
                    <span v-if="item.is_quanfury" class="badge-purple text-[10px]">QF</span>
                  </td>
                </tr>
              </tbody>
            </table>
            <p v-if="results.length === 0" class="text-gray-500 text-sm text-center py-8">
              No stocks match these criteria.
            </p>
          </div>
        </div>

        <!-- Top yields sidebar -->
        <div class="card">
          <h2 class="text-lg font-semibold text-white mb-4">Top Dividend Yields</h2>
          <div class="space-y-2 max-h-[600px] overflow-y-auto">
            <div v-for="(s, i) in topYields" :key="s.ticker_yf"
              class="flex items-center justify-between p-2 bg-gray-800 rounded-lg text-sm cursor-pointer hover:bg-gray-750"
              @click="goToYieldStock(s.ticker_yf)">
              <div class="flex items-center gap-2">
                <span class="text-xs text-gray-500 w-5">{{ i + 1 }}</span>
                <div>
                  <span class="font-mono font-medium text-white">{{ s.ticker_yf }}</span>
                  <div class="flex items-center gap-1 mt-0.5">
                    <span class="badge-blue text-[9px]">{{ s.exchange_code }}</span>
                    <span v-if="s.is_quanfury" class="badge-purple text-[9px]">QF</span>
                  </div>
                </div>
              </div>
              <div class="text-right">
                <p class="font-mono font-bold text-green-400">{{ fmt(s.div_yield_ttm) }}%</p>
                <p class="text-xs text-gray-500">${{ fmt(s.dividend_ttm) }}/yr</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>
