import axios from 'axios'
import type {
  PaginatedStocks, StockDetail, StockFilters, ScoreTrendStats,
  DividendCalendarItem, DividendCalendarNote, Portfolio, PortfolioDetail,
  DashboardStats, WeekProximityItem, Exchange, SectorStat,
  ArbitrageRateItem, ArbitrageSummary, ArbitrageSource,
  ArbitrageOperation, ArbitrageStats, P2PBook,
  FairValueSummary, FairValueSeries, FairValueRevision, FairValueAnnualRow,
  PriceNormalization,
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
  if (filters.min_health_score != null) params.min_health_score = filters.min_health_score
  if (filters.max_health_score != null) params.max_health_score = filters.max_health_score
  if (filters.divergence) params.divergence = filters.divergence
  if (filters.ema_52_for_div === false) params.ema_52_for_div = false
  if (filters.ema_200_for_div === false) params.ema_200_for_div = false
  if (filters.portfolio_id != null) params.portfolio_id = filters.portfolio_id
  if (filters.tech_complete) params.tech_complete = true
  params.page = filters.page || 1
  params.page_size = filters.page_size || 50
  const { data } = await api.get<PaginatedStocks>('/stocks', { params })
  return data
}

export async function fetchScoreTrendStats(filters: Partial<StockFilters> = {}): Promise<ScoreTrendStats> {
  const params: Record<string, unknown> = {}
  if (filters.exchange) params.exchange = filters.exchange
  if (filters.sector) params.sector = filters.sector
  if (filters.quanfury_only) params.quanfury_only = true
  if (filters.search) params.search = filters.search
  if (filters.min_health_score != null) params.min_health_score = filters.min_health_score
  if (filters.max_health_score != null) params.max_health_score = filters.max_health_score
  if (filters.portfolio_id != null) params.portfolio_id = filters.portfolio_id
  if (filters.tech_complete) params.tech_complete = true
  const { data } = await api.get<ScoreTrendStats>('/stocks/score-trend/stats', { params })
  return data
}

export async function fetchStock(id: number): Promise<StockDetail> {
  const { data } = await api.get<StockDetail>(`/stocks/${id}`)
  return data
}

export async function fetchPriceNormalization(stockId: number): Promise<PriceNormalization> {
  const { data } = await api.get<PriceNormalization>(`/stocks/fundamentals/yahoo/${stockId}`)
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
    params: { search: ticker, page_size: 10 },
  })
  const t = ticker.trim().toUpperCase()
  const base = t.includes('.') ? t.split('.')[0] : t
  const exact = data.items.find(
    s => s.ticker_yf.toUpperCase() === t || s.symbol.toUpperCase() === t
      || s.ticker_yf.toUpperCase() === base || s.symbol.toUpperCase() === base
  )
  return exact?.id ?? data.items[0]?.id ?? null
}

// --- Dividends ---

export async function fetchDividendCalendar(params: Record<string, any> = {}): Promise<DividendCalendarItem[]> {
  const { data } = await api.get<DividendCalendarItem[]>('/dividends/calendar', { params })
  return data
}

export async function fetchCalendarNotes(params: { start_date: string; end_date: string }): Promise<DividendCalendarNote[]> {
  const { data } = await api.get<DividendCalendarNote[]>('/dividends/calendar-notes', { params })
  return data
}

export async function createCalendarNote(body: { note_date: string; body: string }): Promise<DividendCalendarNote> {
  const { data } = await api.post<DividendCalendarNote>('/dividends/calendar-notes', body)
  return data
}

export async function deleteCalendarNote(id: number): Promise<void> {
  await api.delete(`/dividends/calendar-notes/${id}`)
}

export async function fetchDividendStats() {
  const { data } = await api.get('/dividends/stats')
  return data
}

export async function refreshDividendForward(body: {
  start_date: string
  end_date: string
  weeks_ahead?: number
  max_stocks?: number
}): Promise<Record<string, unknown>> {
  const { data } = await api.post('/dividends/refresh-forward', body)
  return data
}

export async function createManualCalendarDividend(body: {
  div_date: string
  ticker_yf: string
  amount: number
  currency?: string
  company_name?: string
  note?: string
}): Promise<{ ok: boolean; id: number }> {
  const { data } = await api.post('/dividends/calendar/manual', body)
  return data
}

export async function deleteManualCalendarDividend(id: number): Promise<void> {
  await api.delete(`/dividends/calendar/manual/${id}`)
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

export async function deleteStock(stockId: number): Promise<void> {
  await api.delete(`/stocks/${stockId}`)
}

export async function enrichFiltered(params: {
  sector?: string
  exchange?: string
  search?: string
  quanfury_only?: boolean
  near_52w_high?: boolean
  near_52w_low?: boolean
  min_div_yield?: number | null
  min_rsi?: number | null
  max_rsi?: number | null
  min_health_score?: number | null
  max_health_score?: number | null
  divergence?: string | null
  ema_52_for_div?: boolean
  ema_200_for_div?: boolean
  portfolio_id?: number | null
  tech_complete?: boolean
  batch_size?: number
  force?: boolean
  offset?: number
  stale_first?: boolean
  /** 1 = sequential (slow, gentle); 3–5 parallel Yahoo workers (own DB session each). */
  max_workers?: number
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

export async function fetchFeaturesRefreshStatus(hours = 24) {
  const { data } = await api.get<{
    max_updated_at: string | null
    min_updated_at: string | null
    stale_count: number
    total_features: number
    hours: number
  }>('/stocks/features/refresh-status', { params: { hours } })
  return data
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

// --- Fair value (manual FVE revisions) ---

export async function fetchFairValueSummary(stockId: number, ensureOhlcv = true): Promise<FairValueSummary> {
  const { data } = await api.get<FairValueSummary>(`/stocks/${stockId}/fair-value-summary`, {
    params: { ensure_ohlcv: ensureOhlcv },
  })
  return data
}

export async function fetchFairValueSeries(
  stockId: number,
  opts: {
    granularity?: 'daily' | 'weekly' | 'monthly'
    period?: string
    ensureOhlcv?: boolean
  } = {},
): Promise<FairValueSeries> {
  const { data } = await api.get<FairValueSeries>(`/stocks/${stockId}/fair-value-series`, {
    params: {
      granularity: opts.granularity ?? 'weekly',
      period: opts.period ?? '5y',
      ensure_ohlcv: opts.ensureOhlcv ?? true,
    },
  })
  return data
}

export async function fetchFairValueAnnualTable(
  stockId: number,
  opts: {
    yearFrom?: number
    yearTo?: number
    ensureOhlcv?: boolean
    /** constant_latest (default): rellena años sin FVE histórico usando tu último FVE */
    annualFveBasis?: 'strict' | 'constant_latest'
  } = {},
) {
  const { data } = await api.get<{
    ticker_yf: string
    annual_fve_basis: string
    rows: FairValueAnnualRow[]
  }>(`/stocks/${stockId}/fair-value-annual-table`, {
    params: {
      year_from: opts.yearFrom,
      year_to: opts.yearTo,
      ensure_ohlcv: opts.ensureOhlcv ?? true,
      annual_fve_basis: opts.annualFveBasis ?? 'constant_latest',
    },
  })
  return data
}

export async function fetchFairValueRevisions(stockId: number): Promise<FairValueRevision[]> {
  const { data } = await api.get<FairValueRevision[]>(`/stocks/${stockId}/fair-value-revisions`)
  return data
}

export async function upsertFairValueRevisions(
  stockId: number,
  body: {
    revisions: Array<{
      effective_date: string
      fair_value: number
      uncertainty?: string
      source?: string
    }>
  },
): Promise<FairValueRevision[]> {
  const { data } = await api.post<FairValueRevision[]>(`/stocks/${stockId}/fair-value-revisions`, body)
  return data
}

export async function deleteFairValueRevision(stockId: number, revisionId: number): Promise<void> {
  await api.delete(`/stocks/${stockId}/fair-value-revisions/${revisionId}`)
}

// ─── Arbitrage ───────────────────────────────────────────────────────────────

export async function fetchArbitrageLiveRates(): Promise<ArbitrageRateItem[]> {
  const { data } = await api.get<ArbitrageRateItem[]>('/arbitrage/rates')
  return data
}

export async function fetchArbitrageCachedRates(minutes = 10): Promise<ArbitrageRateItem[]> {
  const { data } = await api.get<ArbitrageRateItem[]>('/arbitrage/rates/cached', { params: { minutes } })
  return data
}

export async function fetchArbitrageSummary(): Promise<ArbitrageSummary> {
  const { data } = await api.get<ArbitrageSummary>('/arbitrage/summary')
  return data
}

export async function fetchArbitrageHistory(pair: string, hours = 24) {
  const { data } = await api.get('/arbitrage/history', { params: { pair, hours } })
  return data as Array<{ source: string; pair: string; bid: number | null; ask: number | null; mid: number | null; fetched_at: string }>
}

export async function fetchArbitrageSources(): Promise<ArbitrageSource[]> {
  const { data } = await api.get<{ sources: ArbitrageSource[] }>('/arbitrage/sources')
  return data.sources
}

export async function createArbitrageOperation(payload: {
  pair: string; buy_source: string; sell_source: string
  buy_price: number; sell_price: number; amount_usdt: number
  fee_total?: number; notes?: string
}): Promise<ArbitrageOperation> {
  const { data } = await api.post<ArbitrageOperation>('/arbitrage/operations', payload)
  return data
}

export async function fetchArbitrageOperations(limit = 50): Promise<ArbitrageOperation[]> {
  const { data } = await api.get<ArbitrageOperation[]>('/arbitrage/operations', { params: { limit } })
  return data
}

export async function fetchArbitrageStats(): Promise<ArbitrageStats> {
  const { data } = await api.get<ArbitrageStats>('/arbitrage/operations/stats')
  return data
}

export async function fetchP2PBook(params: {
  asset?: string
  fiat?: string
  trade_type?: string
  rows?: number
  merchant_only?: boolean
}): Promise<P2PBook> {
  const { data } = await api.get<P2PBook>('/arbitrage/p2p/book', { params })
  return data
}

export default api
