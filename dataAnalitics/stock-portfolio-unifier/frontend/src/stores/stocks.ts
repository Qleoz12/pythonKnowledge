import { defineStore } from 'pinia'
import { ref, reactive } from 'vue'
import type { Stock, StockDetail, PaginatedStocks, StockFilters, Exchange } from '../types'
import { fetchStocks, fetchStock, fetchExchanges, fetchSectors } from '../services/api'
import { parseQualifiedEquityInput } from '../utils/qualifiedSearch'

export const useStocksStore = defineStore('stocks', () => {
  const stocks = ref<Stock[]>([])
  const currentStock = ref<StockDetail | null>(null)
  const loading = ref(false)
  const total = ref(0)
  const pages = ref(0)
  const exchanges = ref<Exchange[]>([])
  const sectors = ref<string[]>([])

  const filters = reactive<StockFilters>({
    exchange: '',
    sector: '',
    search: '',
    quanfury_only: false,
    sort_by: 'ticker_yf',
    order: 'asc',
    min_div_yield: null,
    min_rsi: null,
    max_rsi: null,
    near_52w_high: false,
    near_52w_low: false,
    page: 1,
    page_size: 50,
  })

  async function loadStocks() {
    loading.value = true
    try {
      const p = parseQualifiedEquityInput(filters.search)
      const payload: StockFilters = {
        ...filters,
        search: p.exchange != null ? p.displaySymbol : filters.search.trim(),
        exchange: p.exchange || filters.exchange,
      }
      const result = await fetchStocks(payload)
      stocks.value = result.items
      total.value = result.total
      pages.value = result.pages
    } finally {
      loading.value = false
    }
  }

  async function loadStock(id: number) {
    loading.value = true
    try {
      currentStock.value = await fetchStock(id)
    } finally {
      loading.value = false
    }
  }

  async function loadMeta() {
    const [exc, sec] = await Promise.all([fetchExchanges(), fetchSectors()])
    exchanges.value = exc
    sectors.value = sec
  }

  function setSort(field: string) {
    if (filters.sort_by === field) {
      filters.order = filters.order === 'asc' ? 'desc' : 'asc'
    } else {
      filters.sort_by = field
      filters.order = 'desc'
    }
    filters.page = 1
    loadStocks()
  }

  function setPage(p: number) {
    filters.page = p
    loadStocks()
  }

  function resetFilters() {
    Object.assign(filters, {
      exchange: '', sector: '', search: '', quanfury_only: false,
      sort_by: 'ticker_yf', order: 'asc', min_div_yield: null,
      min_rsi: null, max_rsi: null,
      near_52w_high: false, near_52w_low: false, page: 1, page_size: 50,
    })
    loadStocks()
  }

  return {
    stocks, currentStock, loading, total, pages, exchanges, sectors, filters,
    loadStocks, loadStock, loadMeta, setSort, setPage, resetFilters,
  }
})
