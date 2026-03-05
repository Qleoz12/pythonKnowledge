export interface Stock {
  id: number
  ticker_yf: string
  symbol: string
  company_name: string
  exchange_code: string | null
  sector: string
  currency: string
  market_cap: number
  is_quanfury_available: boolean
  last_close: number | null
  div_yield_ttm: number | null
  rsi_14: number | null
  ema_20: number | null
  ema_52: number | null
  ema_200: number | null
  macd: number | null
  macd_signal: number | null
  dividend_ttm: number | null
  payments_ttm: number | null
  div_freq: string | null
  last_div_date: string | null
  max_drawdown: number | null
  week_52_high: number | null
  week_52_low: number | null
  week_52_pct: number | null
  next_earnings_date: string | null
}

export interface StockDetail extends Stock {
  isin: string
  eps_estimate: number | null
  reported_eps: number | null
  surprise_pct: number | null
  week_100_high: number | null
  week_100_low: number | null
  week_200_high: number | null
  week_200_low: number | null
  dividend_history: DividendHistoryItem[]
  portfolios: { id: number; name: string; shares: number }[]
}

export interface DividendHistoryItem {
  date: string
  amount: number
}

export interface PaginatedStocks {
  items: Stock[]
  total: number
  page: number
  page_size: number
  pages: number
}

export interface DividendCalendarItem {
  date: string
  ticker: string
  stock_id: number | null
  company_name: string
  amount: number
  source: string
  exchange_code: string | null
  currency: string | null
  last_close: number | null
  div_yield_ttm: number | null
  is_quanfury: boolean
  in_portfolio: boolean
  portfolio_names: string[]
}

export interface Portfolio {
  id: number
  name: string
  broker: string
  description: string
  created_at: string
  total_value: number | null
  total_cost: number | null
  total_gain_pct: number | null
  estimated_annual_dividends: number | null
  avg_yield: number | null
  holdings_count: number
}

export interface PortfolioDetail extends Portfolio {
  holdings: Holding[]
  snapshots: Snapshot[]
}

export interface Holding {
  id: number
  stock_id: number
  ticker_yf: string
  company_name: string
  symbol: string
  shares: number
  avg_price: number
  current_price: number | null
  current_value: number | null
  gain_pct: number | null
  div_yield_ttm: number | null
  annual_dividend: number | null
  is_quanfury: boolean
}

export interface Snapshot {
  id: number
  month: number
  year: number
  total_value: number
  total_dividends: number
  notes: string
}

export interface DashboardStats {
  total_stocks: number
  stocks_by_exchange: Record<string, number>
  stocks_with_dividends: number
  quanfury_available: number
  avg_div_yield: number | null
  near_52w_high_count: number
  near_52w_low_count: number
}

export interface WeekProximityItem {
  id: number
  ticker_yf: string
  company_name: string
  exchange_code: string | null
  sector: string
  last_close: number | null
  is_quanfury: boolean
  week_52_high: number | null
  week_52_low: number | null
  week_52_pct: number | null
  near_52w_high: boolean
  near_52w_low: boolean
  div_yield_ttm: number | null
  rsi_14: number | null
}

export interface Exchange {
  id: number
  code: string
  name: string
}

export interface SectorStat {
  sector: string
  count: number
  avg_div_yield: number | null
  quanfury_count: number
  with_dividends: number
}

export interface StockFilters {
  exchange: string
  sector: string
  search: string
  quanfury_only: boolean
  sort_by: string
  order: string
  min_div_yield: number | null
  min_rsi: number | null
  max_rsi: number | null
  near_52w_high: boolean
  near_52w_low: boolean
  page: number
  page_size: number
}
