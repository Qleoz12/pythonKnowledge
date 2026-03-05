# Stock Portfolio Unifier

Unified stock analysis across **TSX, NYSE, LSE, NASDAQ** and any exchange supported by Yahoo Finance, with **Quanfury** cross-referencing. Built with **FastAPI + SQLite** backend and **Vue 3 + Tailwind** frontend.

---

## Quick Start (Local)

### One command — start both servers

**Windows:**

```cmd
start.bat
```

**Linux / macOS:**

```bash
./start.sh
```

This installs dependencies, starts backend and frontend, and opens the browser.

### Or start each server manually

**Backend:**

```bash
cd backend
pip install -r requirements.txt
python main.py
```

**Frontend (in a second terminal):**

```bash
cd frontend
npm install
npm run dev
```

- Backend API: `http://localhost:8000` (docs at `/docs`)
- Frontend: `http://localhost:5173`

On first run, visit the Dashboard and click **"Load/Refresh Data"** to import CSV/JSON data.

---

## Quick Start (Docker)

```bash
docker-compose up --build
```

- Frontend: `http://localhost:3000`
- Backend API: `http://localhost:8000`

The SQLite database persists in a Docker volume. Mount your data directory by editing `docker-compose.yml` volumes.

---

## Adding Stocks Manually

The ETL pipeline loads stocks from pre-existing CSVs (TSX, NYSE, LSE). To add stocks from **any exchange** (NASDAQ, AMEX, etc.) or stocks not in the CSVs, use the cross-platform script or the API directly.

### Recommended: Use the Python script (Windows, Linux, macOS)

```bash
# Add one stock
python scripts/add_stocks.py NFLX

# Add several at once
python scripts/add_stocks.py NFLX GOOG AMZN TSLA

# Add to a portfolio with shares and price
python scripts/add_stocks.py NFLX --portfolio 1 --shares 10 --price 950

# From a file (one ticker per line)
python scripts/add_stocks.py --file my_tickers.txt

# Check data health
python scripts/add_stocks.py --enrich-status

# Enrich 20 stocks with missing data
python scripts/add_stocks.py --enrich-batch 20

# Fill missing sectors
python scripts/add_stocks.py --enrich-batch 10 --mode missing_sector
```

The script uses only Python stdlib (`urllib`) — no extra dependencies needed.

### Alternative: curl commands

> **Windows CMD** uses double quotes for the body and escaped inner quotes.
> **Linux/macOS** uses single quotes.

**Linux / macOS / Git Bash:**

```bash
curl -X POST http://localhost:8000/api/stocks \
  -H "Content-Type: application/json" \
  -d '{"ticker": "NFLX", "enrich": true}'
```

**Windows CMD:**

```cmd
curl -X POST http://localhost:8000/api/stocks -H "Content-Type: application/json" -d "{\"ticker\": \"NFLX\", \"enrich\": true}"
```

**Windows PowerShell:**

```powershell
Invoke-RestMethod -Method POST -Uri "http://localhost:8000/api/stocks" `
  -ContentType "application/json" `
  -Body '{"ticker": "NFLX", "enrich": true}'
```

### Add a stock to a portfolio in one step

**Linux / macOS:**

```bash
curl -X POST http://localhost:8000/api/stocks \
  -H "Content-Type: application/json" \
  -d '{"ticker": "NFLX", "portfolio_id": 1, "shares": 10, "avg_price": 950.0, "enrich": true}'
```

**Windows CMD:**

```cmd
curl -X POST http://localhost:8000/api/stocks -H "Content-Type: application/json" -d "{\"ticker\": \"NFLX\", \"portfolio_id\": 1, \"shares\": 10, \"avg_price\": 950.0, \"enrich\": true}"
```

### What happens on enrich

When `enrich: true` (the default), the API:
- Detects the exchange (NASDAQ) via yfinance
- Creates the exchange if it doesn't exist
- Fetches price, sector, industry, 52/100/200W ranges, dividend data
- Returns the created stock with its `id`

### Add without enrichment (manual entry)

```bash
# Linux/macOS
curl -X POST http://localhost:8000/api/stocks \
  -H "Content-Type: application/json" \
  -d '{"ticker": "CUSTOM.X", "exchange": "OTHER", "enrich": false}'

# Windows CMD
curl -X POST http://localhost:8000/api/stocks -H "Content-Type: application/json" -d "{\"ticker\": \"CUSTOM.X\", \"exchange\": \"OTHER\", \"enrich\": false}"
```

### Exchange auto-detection mapping

The system maps Yahoo Finance exchange codes to standard names:

| yfinance code | Mapped to |
|---------------|-----------|
| NMS, NGM, NCM | NASDAQ |
| NYQ | NYSE |
| TSE, TOR | TSX |
| LSE, LON | LSE |

Any other exchange code is stored as-is (e.g., `AMEX`, `ASX`, etc.).

---

## Features

- **Stock Explorer**: Browse all stocks across exchanges with filters (sector, exchange, Quanfury, 52W proximity, dividend yield)
- **Stock Detail**: Full technical indicators (RSI, MACD, EMAs), dividend history, 52/100/200W price range analysis
- **Dividend Calendar**: Timeline of historical and Quanfury dividend events with list/calendar views
- **Portfolio Manager**: Create portfolios by broker (Quanfury, XTB, etc.), track holdings, gain/loss, dividend income
- **Portfolio Tracking**: Monthly snapshots to track portfolio evolution over time
- **Analytics**: 52/100/200W proximity analysis, top dividend yields, buy signals near lows
- **Quanfury Integration**: Cross-reference which stocks are available on Quanfury
- **CSV Export**: Download all stock data as CSV
- **Dark Mode**: Default dark theme

---

## Sector & Industry Reference

Stocks are categorized by **sector** (broad economic category) and **industry** (specific sub-category). Two sector taxonomies exist depending on the data source:

### GICS-style Sectors (from Yahoo Finance / Quanfury)

These are the 11 standard sectors used by yfinance and the Quanfury stock universe. When you add stocks via `POST /api/stocks` with `enrich: true`, they get classified into these:

| Sector | Description | Example Tickers |
|--------|-------------|-----------------|
| **Technology** | Software, hardware, semiconductors, IT services | AAPL, MSFT, NVDA, NFLX |
| **Healthcare** | Pharma, biotech, medical devices, health plans | JNJ, PFE, UNH, ABBV |
| **Financial Services** | Banks, insurance, capital markets, credit | JPM, BAC, GS, V |
| **Consumer Cyclical** | Retail, auto, entertainment, travel, luxury | AMZN, TSLA, NKE, SBUX |
| **Consumer Defensive** | Food, beverages, household, tobacco, groceries | PG, KO, WMT, COST |
| **Communication Services** | Telecom, media, internet, broadcasting | GOOG, META, DIS, T |
| **Industrials** | Aerospace, machinery, construction, logistics | BA, CAT, HON, UPS |
| **Energy** | Oil, gas, exploration, refining, midstream | XOM, CVX, SLB, OXY |
| **Basic Materials** | Chemicals, metals, mining, paper, gold | LIN, NEM, FCX, NUE |
| **Real Estate** | REITs (retail, office, industrial, residential) | AMT, PLD, SPG, O |
| **Utilities** | Electric, gas, water, renewable energy | NEE, DUK, SO, D |

### TSX-specific Sectors (from TMX/TSX listings)

The TSX exchange uses its own sector classification. These appear in stocks loaded from `tsx_features.csv`:

| Sector | Description |
|--------|-------------|
| **Mining** | Gold, silver, copper, lithium producers |
| **Oil & Gas** | Canadian energy producers and services |
| **Financial Services** | Canadian banks, insurance, fintech |
| **Technology** | Tech companies listed on TSX |
| **Clean Technology & Renewable Energy** | Green energy, EV, cleantech |
| **Real Estate** | Canadian REITs and developers |
| **Life Sciences** | Biotech, pharma, cannabis |
| **Industrial Products & Services** | Manufacturing, construction |
| **Consumer Products & Services** | Retail, food, consumer goods |
| **Utilities & Pipelines** | Regulated utilities, pipelines |
| **Comm. & Media** | Telecom, broadcasting, media |
| **Closed-End Funds** | Investment funds listed on TSX |
| **ETP** | Exchange-Traded Products |
| **SPAC** | Special Purpose Acquisition Companies |
| **CPC** | Capital Pool Companies |

### Industries (140 categories from Quanfury/yfinance)

Each sector contains multiple industries for more granular filtering. Key examples:

| Sector | Industries |
|--------|-----------|
| Technology | Software - Application, Software - Infrastructure, Semiconductors, Semiconductor Equipment & Materials, Computer Hardware, Electronic Components, Information Technology Services, Communication Equipment |
| Healthcare | Drug Manufacturers - General, Drug Manufacturers - Specialty & Generic, Biotechnology, Medical Devices, Medical Instruments & Supplies, Health Information Services, Healthcare Plans, Diagnostics & Research |
| Financial Services | Banks - Diversified, Banks - Regional, Capital Markets, Insurance - Property & Casualty, Insurance - Life, Credit Services, Financial Data & Stock Exchanges, Mortgage Finance, Asset Management |
| Consumer Cyclical | Internet Retail, Auto Manufacturers, Restaurants, Apparel Retail, Home Improvement Retail, Specialty Retail, Luxury Goods, Leisure, Entertainment, Gambling |
| Energy | Oil & Gas Integrated, Oil & Gas E&P, Oil & Gas Midstream, Oil & Gas Refining & Marketing, Oil & Gas Equipment & Services, Oil & Gas Drilling, Solar, Uranium |
| Industrials | Aerospace & Defense, Specialty Industrial Machinery, Railroads, Trucking, Integrated Freight & Logistics, Engineering & Construction, Farm & Heavy Construction Machinery |
| Real Estate | REIT - Industrial, REIT - Retail, REIT - Residential, REIT - Office, REIT - Specialty, REIT - Healthcare Facilities, Real Estate Services, Real Estate - Development |
| Utilities | Utilities - Regulated Electric, Utilities - Regulated Gas, Utilities - Regulated Water, Utilities - Renewable, Utilities - Diversified, Utilities - Independent Power Producers |
| Basic Materials | Gold, Copper, Steel, Aluminum, Specialty Chemicals, Chemicals, Other Industrial Metals & Mining, Lumber & Wood Production |

### How to explore by sector

**Via API:**

```bash
# List all sectors in the database
GET /api/stocks/sectors

# Filter stocks by sector
GET /api/stocks?sector=Technology
GET /api/stocks?sector=Healthcare&exchange=NYSE
GET /api/stocks?sector=Real Estate&quanfury_only=true

# Top dividend yields in a sector
GET /api/analytics/top-dividend-yields?exchange=NYSE
GET /api/analytics/top-dividend-yields?quanfury_only=true

# Stocks near 52W low in a sector (value opportunities)
GET /api/stocks?sector=Energy&near_52w_low=true
GET /api/stocks?sector=Financial Services&min_div_yield=4
```

**Via Frontend (Stock Explorer view):**

1. Navigate to `/stocks`
2. Use the **Sector** dropdown to filter by any loaded sector
3. Combine with **Exchange** filter and **Quanfury only** checkbox
4. Sort by `Yield` column to find highest dividend payers in that sector
5. Use `Near 52W Low` checkbox to find undervalued opportunities

### Data gap: NYSE and LSE stocks lack sector data

**Important for future iterations:** The `nyse_features.csv` and `lse_features.csv` do **not** include a `Sector` column. Only `tsx_features.csv` has sector data from the TMX listing. NYSE and LSE stocks added via the ETL will have **empty sectors** unless:

1. **Enriched via yfinance**: Stocks added through `POST /api/stocks` with `enrich: true` get sector/industry from Yahoo Finance automatically.
2. **Matched with Quanfury data**: `quantfury/stocks.json` contains sector/industry for ~800+ stocks (mostly NYSE). The ETL `load_quanfury.py` currently marks stocks as Quanfury-available but **does not backfill sector/industry**.

**TODO for backend agents:** Enhance `load_quanfury.py` to also update `stock.sector` and `stock.industry` from `quantfury/stocks.json` when the stock's sector is empty. This would cover most NYSE stocks.

**TODO for a future ETL step:** Create a `enrich_sectors.py` script that iterates over stocks with empty sectors and batch-fetches sector/industry from yfinance (respecting rate limits, see `trading-os/python-scripts/RATE_LIMITING.md`).

---

## Data Sources

| Source | Description | Rows |
|--------|-------------|------|
| `cache_yf/tsx_features.csv` | TSX stock features with sectors | ~3,562 |
| `cache_yf/nyse_features.csv` | NYSE stock features (no sector) | ~2,889 |
| `cache_yf/lse_features.csv` | LSE stock features (no sector) | ~1,332 |
| `cache_yf/tsx_div_events.csv` | TSX historical dividends | ~13,765 |
| `cache_yf/nyse_div_events.csv` | NYSE historical dividends | ~106,408 |
| `cache_yf/lse_div_events.csv` | LSE historical dividends | ~34,324 |
| `quanfury_div.json` | Quanfury upcoming dividends | variable |
| `trading-os/quantfury/stocks.json` | Quanfury instrument universe with sector/industry | ~800+ |

---

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/health` | GET | Health check with stock count |
| `/api/stocks` | GET | Paginated stocks with filters (`exchange`, `sector`, `search`, `quanfury_only`, `near_52w_high`, `near_52w_low`, `min_div_yield`, `sort_by`, `order`, `page`, `page_size`) |
| `/api/stocks` | POST | **Create stock** — add any ticker, auto-enriches from yfinance. Body: `{ticker, exchange?, shares?, avg_price?, portfolio_id?, enrich?}` |
| `/api/stocks/{id}` | GET | Stock detail with dividend history and portfolio membership |
| `/api/stocks/{id}/refresh-prices` | POST | Force refresh 52/100/200W price ranges + sector from yfinance |
| `/api/stocks/enrich/status` | GET | Data health: how many stocks need enrichment |
| `/api/stocks/enrich/batch` | POST | Enrich N stocks with missing data. Body: `{batch_size?, mode?}` (modes: `missing_prices`, `missing_sector`) |
| `/api/stocks/exchanges` | GET | List all exchanges |
| `/api/stocks/sectors` | GET | List all distinct sectors |
| `/api/stocks/search?q=` | GET | Search stocks by ticker or name |
| `/api/stocks/by-ticker/{ticker_yf}` | GET | Find stock ID by ticker |
| `/api/dividends/calendar` | GET | Dividend calendar (`start_date`, `end_date`, `exchange`, `portfolio_id`) |
| `/api/dividends/upcoming` | GET | Top dividend payers (`days`, `exchange`, `quanfury_only`) |
| `/api/dividends/stats` | GET | Dividend statistics |
| `/api/portfolios` | GET | List all portfolios with stats |
| `/api/portfolios` | POST | Create portfolio. Body: `{name, broker?, description?}` |
| `/api/portfolios/{id}` | GET | Portfolio detail with holdings and snapshots |
| `/api/portfolios/{id}` | PUT | Update portfolio |
| `/api/portfolios/{id}` | DELETE | Delete portfolio |
| `/api/portfolios/{id}/holdings` | POST | Add/update holding. Body: `{stock_id, shares, avg_price}` |
| `/api/portfolios/{id}/holdings/{hid}` | DELETE | Remove holding |
| `/api/portfolios/{id}/snapshots` | GET | List monthly snapshots |
| `/api/portfolios/{id}/snapshots` | POST | Record snapshot. Body: `{month, year, total_value, total_dividends, notes?}` |
| `/api/analytics/dashboard` | GET | Dashboard stats (totals, by-exchange, near highs/lows) |
| `/api/analytics/week-proximity` | GET | 52/100/200W proximity analysis (`period`, `direction`, `threshold`, `exchange`, `quanfury_only`, `min_div_yield`) |
| `/api/analytics/top-dividend-yields` | GET | Top dividend yields (`exchange`, `quanfury_only`, `limit`) |
| `/api/export/stocks` | GET | CSV export of all stocks |
| `/api/etl/run` | GET | Trigger full ETL pipeline |

---

## Environment Configuration

Copy `.env.example` to `.env` and adjust:

```bash
# Path to SQLite database
DATABASE_PATH=./backend/stock_unifier.db

# Root directory where cache_yf/, quanfury_div.json, trading-os/ live
DATA_DIR=../

# Allowed CORS origins (comma-separated)
CORS_ORIGINS=http://localhost:5173,http://localhost:3000
```

---

## Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Database | SQLite (WAL mode) | Portable, zero config, supports concurrent reads |
| Backend | Python FastAPI + SQLAlchemy | Async-ready, auto-docs at `/docs` |
| Frontend | Vue 3 + TypeScript + Tailwind CSS | Composition API, Pinia stores, Vue Router |
| Data | pandas, yfinance | ETL pipeline, price enrichment |
| Charts | Planned: vue-echarts | Available in trading-os frontend |
| Deploy | Docker + docker-compose | 2-container setup (backend + nginx frontend) |

---

## Architecture for Contributing Agents

```
┌────────────────────┐     ┌───────────────────┐
│   CSV / JSON Data  │────▶│   ETL Scripts      │
│   (cache_yf/,      │     │   (backend/etl/)   │
│    quanfury_*.json) │     └────────┬──────────┘
└────────────────────┘              │
                                    ▼
                         ┌──────────────────────┐
                         │   SQLite DB           │
                         │   (WAL mode)          │
                         │                      │
                         │   exchanges           │
                         │   stocks              │
                         │   stock_features      │
                         │   dividend_events     │
                         │   quanfury_dividends  │
                         │   portfolios          │
                         │   portfolio_holdings  │
                         │   portfolio_snapshots │
                         └──────────┬───────────┘
                                    │
                         ┌──────────▼───────────┐
                         │   FastAPI :8000       │
                         │   /api/stocks         │
                         │   /api/dividends      │
                         │   /api/portfolios     │
                         │   /api/analytics      │
                         │   POST /api/stocks    │◀── Add any ticker
                         └──────────┬───────────┘
                                    │
                         ┌──────────▼───────────┐
                         │   Vue 3 :5173/:3000   │
                         │   StockExplorer       │
                         │   StockDetail         │
                         │   DividendCalendar    │
                         │   PortfolioManager    │
                         │   PortfolioDetail     │
                         │   AnalyticsView       │
                         │   DashboardView       │
                         └──────────────────────┘
```

### Key files for iterating

| Area | Files to modify |
|------|----------------|
| Database models | `backend/models.py` |
| API endpoints | `backend/routers/stocks.py`, `portfolios.py`, `dividends.py`, `analytics.py` |
| ETL data loading | `backend/etl/load_features.py`, `load_div_events.py`, `load_quanfury.py` |
| Configuration | `backend/config.py`, `.env.example` |
| CLI scripts | `scripts/add_stocks.py` (add stocks), `scripts/test_api.py` (integration tests) |
| Frontend API client | `frontend/src/services/api.ts` |
| TypeScript types | `frontend/src/types.ts` |
| Vue views | `frontend/src/views/*.vue` |
| Pinia stores | `frontend/src/stores/stocks.ts`, `portfolios.ts` |
| Routing | `frontend/src/router.ts` |
