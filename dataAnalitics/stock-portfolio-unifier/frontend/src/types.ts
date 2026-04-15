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
  health_score: number | null
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
  net_income_margin: number | null
  return_on_assets: number | null
  free_cash_flow: number | null
  operating_cash_flow: number | null
  fcf_yield: number | null
  revenue: number | null
  net_income: number | null
  total_debt: number | null
  debt_to_equity: number | null
  health_score: number | null
  dividend_history: DividendHistoryItem[]
  portfolios: { id: number; name: string; shares: number }[]
}

/** Live Yahoo snapshot (on-demand); not the same as Financial Health Score (DB after refresh). */
export interface PriceNormalization {
  ticker_yf: string
  company_name: string | null
  symbol: string | null
  sector: string | null
  industry: string | null
  price: number | null
  market_cap: number | null
  dividend_yield: number | null
  payout_ratio: number | null
  div_growth_5y_cagr: number | null
  volatility_1y: number | null
  beta: number | null
  dividend_score: number | null
  forward_pe: number | null
  net_income_ttm: number | null
  ebitda_ttm: number | null
  net_debt: number | null
  balance_sheet_date: string | null
  price_to_book: number | null
}

export interface FairValueSummary {
  has_fair_value: boolean
  ticker_yf: string
  last_price: number | null
  fair_value: number | null
  price_to_fve: number | null
  uncertainty: string | null
  fair_value_as_of: string | null
  fair_value_revision_id?: number | null
}

export interface FairValueSeries {
  ticker_yf: string
  granularity: string
  period: string
  /** At least one FVE row exists in DB (may not overlap chart dates). */
  has_revisions?: boolean
  has_fair_value: boolean
  dates: string[]
  close: number[]
  fve: (number | null)[]
  uncertainty: (string | null)[]
  price_to_fve: (number | null)[]
  undervalued: boolean[]
}

export interface FairValueAnnualRow {
  year: number
  last_date: string
  price_to_fve: number | null
  /** step = FVE vigente en esa fecha; constant_latest = cierre ÷ último FVE guardado */
  price_to_fve_basis?: 'step' | 'constant_latest' | null
  total_return_pct: number | null
}

export interface FairValueRevision {
  id: number
  effective_date: string
  fair_value: number
  uncertainty: string | null
  source: string
  created_at: string
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
  /** DB payment date one year earlier when source is yahoo_forward / seasonal projection */
  prior_year_div_date?: string | null
  projection_source?: string | null
  /** Set when source === 'manual'; DELETE /dividends/calendar/manual/:id */
  manual_entry_id?: number | null
}

/** Reminder attached to a calendar day (dividend calendar screen). */
export interface DividendCalendarNote {
  id: number
  note_date: string
  body: string
  created_at: string
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
  missing_prices: number
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
  min_health_score?: number | null
  max_health_score?: number | null
  divergence?: string | null
  ema_52_for_div?: boolean
  ema_200_for_div?: boolean
  portfolio_id?: number | null
  tech_complete?: boolean
}

export interface ScoreTrendStats {
  total: number
  strong_below_ema200: number
  strong_below_both_emas: number
  poor_above_ema200: number
  poor_above_any_ema: number
}

// ─── Arbitrage ───────────────────────────────────────────────────────────────

export interface ArbitrageRateItem {
  source: string
  pair: string
  bid: number | null
  ask: number | null
  mid: number | null
  volume_24h: number | null
  fetched_at: string
}

export interface ArbitragePairSummary {
  pair: string
  sources_count: number
  best_bid: number | null
  best_bid_source: string | null
  best_ask: number | null
  best_ask_source: string | null
  spread_pct: number | null
}

export interface ArbitrageOpportunity {
  description: string
  usdt_cop_avg: number | null
  usdt_cad_avg: number | null
  fx_cop_per_cad: number | null
  usdt_in_cad_via_cop: number | null
  arb_spread_pct: number | null
  viable: boolean
}

export interface ArbitrageSummary {
  fetched_at: string
  total_data_points: number
  pairs: ArbitragePairSummary[]
  fx_reference: {
    usd_cop: number | null
    usd_cad: number | null
    cop_per_cad: number | null
  }
  opportunity: ArbitrageOpportunity | null
  all_pairs_available: string[]
}

export interface ArbitrageSource {
  id: string
  name: string
  description: string
  pairs: string[]
}

export interface ArbitrageOperation {
  id: number
  pair: string
  buy_source: string
  sell_source: string
  buy_price: number
  sell_price: number
  amount_usdt: number
  fee_total: number
  net_profit: number
  net_profit_pct: number
  status: string
  notes: string
  created_at: string
}

export interface ArbitrageStats {
  total_trades: number
  total_profit: number
  total_invested: number
  roi_pct: number
  avg_profit_pct: number
  best_trade: { id: number; profit_pct: number; pair: string } | null
  worst_trade: { id: number; profit_pct: number; pair: string } | null
}

export interface P2PAdvertiser {
  adv_no: string
  exchange: string
  exchange_id: string
  price: number
  available_usdt: number
  min_fiat: number
  max_fiat: number
  min_usdt: number
  max_usdt: number
  pay_time_limit_min: number | null
  pay_methods: string[]
  is_tradable: boolean
  remarks: string
  seller_name: string
  seller_type: string
  seller_grade: number
  is_merchant: boolean
  month_orders: number
  month_finish_rate: number
  positive_rate: number
  active_label: string
  active_secs: number | null
  link: string
}

export interface P2PBook {
  asset: string
  fiat: string
  trade_type: string
  count: number
  fetched_at: string
  errors: Record<string, string>
  advertisers: P2PAdvertiser[]
}
