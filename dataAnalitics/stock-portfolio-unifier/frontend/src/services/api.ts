import axios from 'axios'
import type {
  PaginatedStocks, StockDetail, StockFilters,
  DividendCalendarItem, Portfolio, PortfolioDetail,
  DashboardStats, WeekProximityItem, Exchange, SectorStat,
} from '../types'

const api = axios.create({
  baseURL: '/api',
  headers: { 'Content-Type': 'application/json' },
})

// --- Stocks ---

export async function fetchStocks(filters: Partial<StockFilters> = {}): Promise<PaginatedStocks> {
  const params: Record<string, any> = {}
  if (filters.exchange) params.exchange = filters.exchange
  if (filters.sector) params.sector = filters.sector
  if (filters.search) params.search = filters.search
  if (filters.quanfury_only) params.quanfury_only = true
  if (filters.sort_by) params.sort_by = filters.sort_by
  if (filters.order) params.order = filters.order
  if (filters.min_div_yield) params.min_div_yield = filters.min_div_yield
  if (filters.min_rsi != null) params.min_rsi = filters.min_rsi
  if (filters.max_rsi != null) params.max_rsi = filters.max_rsi
  if (filters.near_52w_high) params.near_52w_high = true
  if (filters.near_52w_low) params.near_52w_low = true
  params.page = filters.page || 1
  params.page_size = filters.page_size || 50
  const { data } = await api.get<PaginatedStocks>('/stocks', { params })
  return data
}

export async function fetchStock(id: number): Promise<StockDetail> {
  const { data } = await api.get<StockDetail>(`/stocks/${id}`)
  return data
}

export async function fetchExchanges(): Promise<Exchange[]> {
  const { data } = await api.get<Exchange[]>('/stocks/exchanges')
  return data
}

export async function fetchSectors(): Promise<string[]> {
  const { data } = await api.get<string[]>('/stocks/sectors')
  return data
}

export async function fetchSectorStats(): Promise<SectorStat[]> {
  const { data } = await api.get<SectorStat[]>('/stocks/sector-stats')
  return data
}

export async function createStock(payload: {
  ticker: string
  exchange?: string
  shares?: number
  avg_price?: number
  portfolio_id?: number
  enrich?: boolean
}) {
  const { data } = await api.post('/stocks', payload)
  return data
}

export async function searchStockByTicker(ticker: string): Promise<number | null> {
  const { data } = await api.get<PaginatedStocks>('/stocks', {
    params: { search: ticker, page_size: 5 },
  })
  const exact = data.items.find(
    s => s.ticker_yf === ticker || s.symbol === ticker || s.ticker_yf.toLowerCase() === ticker.toLowerCase()
  )
  return exact?.id ?? data.items[0]?.id ?? null
}

// --- Dividends ---

export async function fetchDividendCalendar(params: Record<string, any> = {}): Promise<DividendCalendarItem[]> {
  const { data } = await api.get<DividendCalendarItem[]>('/dividends/calendar', { params })
  return data
}

export async function fetchDividendStats() {
  const { data } = await api.get('/dividends/stats')
  return data
}

// --- Portfolios ---

export async function fetchPortfolios(): Promise<Portfolio[]> {
  const { data } = await api.get<Portfolio[]>('/portfolios')
  return data
}

export async function fetchPortfolio(id: number): Promise<PortfolioDetail> {
  const { data } = await api.get<PortfolioDetail>(`/portfolios/${id}`)
  return data
}

export async function createPortfolio(payload: { name: string; broker?: string; description?: string }): Promise<Portfolio> {
  const { data } = await api.post<Portfolio>('/portfolios', payload)
  return data
}

export async function updatePortfolio(id: number, payload: Record<string, any>): Promise<Portfolio> {
  const { data } = await api.put<Portfolio>(`/portfolios/${id}`, payload)
  return data
}

export async function deletePortfolio(id: number): Promise<void> {
  await api.delete(`/portfolios/${id}`)
}

export async function addHolding(portfolioId: number, payload: { stock_id: number; shares: number; avg_price: number }) {
  const { data } = await api.post(`/portfolios/${portfolioId}/holdings`, payload)
  return data
}

export async function removeHolding(portfolioId: number, holdingId: number): Promise<void> {
  await api.delete(`/portfolios/${portfolioId}/holdings/${holdingId}`)
}

export async function createSnapshot(portfolioId: number, payload: {
  month: number; year: number; total_value: number; total_dividends: number; notes?: string
}) {
  const { data } = await api.post(`/portfolios/${portfolioId}/snapshots`, payload)
  return data
}

// --- Analytics ---

export async function fetchDashboard(): Promise<DashboardStats> {
  const { data } = await api.get<DashboardStats>('/analytics/dashboard')
  return data
}

export async function fetchWeekProximity(params: Record<string, any> = {}): Promise<WeekProximityItem[]> {
  const { data } = await api.get<WeekProximityItem[]>('/analytics/week-proximity', { params })
  return data
}

export async function fetchTopDividendYields(params: Record<string, any> = {}) {
  const { data } = await api.get('/analytics/top-dividend-yields', { params })
  return data
}

// --- ETL & Enrichment ---

export async function runETL() {
  const { data } = await api.get('/etl/run')
  return data
}

export async function healthCheck() {
  const { data } = await api.get('/health')
  return data
}

export async function fetchEnrichStatus(): Promise<{
  total_stocks: number
  missing_prices: number
  missing_sector: number
  health_pct: number
}> {
  const { data } = await api.get('/stocks/enrich/status')
  return data
}

export async function enrichBatch(batch_size = 10, mode = 'missing_prices') {
  const { data } = await api.post('/stocks/enrich/batch', { batch_size, mode })
  return data
}

export async function refreshStock(stockId: number) {
  const { data } = await api.post(`/stocks/${stockId}/refresh-prices`)
  return data
}

export async function enrichFiltered(params: {
  sector?: string
  exchange?: string
  search?: string
  quanfury_only?: boolean
  batch_size?: number
}) {
  const { data } = await api.post('/stocks/enrich/filtered', params)
  return data as {
    total_matching: number
    total_pending: number
    enriched: number
    failed: number
    done: boolean
    details: Array<{ ticker: string; status: string; price?: number; error?: string }>
  }
}

// --- Charts & Drawings ---

export async function fetchOHLCV(stockId: number, period = '1y') {
  const { data } = await api.get(`/stocks/${stockId}/ohlcv`, { params: { period } })
  return data as {
    ticker_yf: string
    count: number
    data: Array<{ date: string; open: number; high: number; low: number; close: number; volume: number }>
  }
}

export async function fetchDrawings(stockId: number) {
  const { data } = await api.get(`/stocks/${stockId}/drawings`)
  return data as Array<{
    id: number; drawing_type: string; price1: number; price2: number | null
    date1: string | null; date2: string | null; color: string; label: string
  }>
}

export async function createDrawing(stockId: number, drawing: {
  drawing_type: string; price1: number; price2?: number
  date1?: string; date2?: string; color?: string; label?: string
}) {
  const { data } = await api.post(`/stocks/${stockId}/drawings`, drawing)
  return data
}

export async function updateDrawing(stockId: number, drawingId: number, updates: Record<string, any>) {
  const { data } = await api.put(`/stocks/${stockId}/drawings/${drawingId}`, updates)
  return data
}

export async function deleteDrawing(stockId: number, drawingId: number) {
  await api.delete(`/stocks/${stockId}/drawings/${drawingId}`)
}

export default api
