# TODO — Stock Portfolio Unifier

Revisión completa del backend y frontend, con un plan de cómo conectar óptimamente el frontend al backend.

---

## 1. Bugs / Inconsistencias (Backend ↔ Frontend)

### CRÍTICOS — rompen funcionalidad

| # | Problema | Estado |
|---|---------|--------|
| 1 | **`stock_id` falta en DividendCalendarItem** — El frontend espera `stock_id` para navegar al detalle del stock desde el calendario de dividendos. | **DONE** — Agregado `stock_id` al modelo Pydantic y populado en ambos loops (historical + quanfury) |
| 2 | **`/api/stocks/sector-stats` no existe** — El frontend (`api.ts`) define `fetchSectorStats()` que llama a este endpoint. | **DONE** — Endpoint creado con `GROUP BY sector`, retorna count, avg_div_yield, quanfury_count, with_dividends |

### MEDIOS — funcionalidad degradada

| # | Problema | Estado |
|---|---------|--------|
| 3 | **`quanfury_only` ignorado en `/api/dividends/calendar`** — Frontend envía este filtro pero el endpoint no lo acepta. | **DONE** — Agregado param `quanfury_only: bool = Query(False)` y filtro `Stock.is_quanfury_available` |
| 4 | **N+1 queries en `list_stocks`** — Cada stock carga `features` y `exchange_rel` lazy. Con 50 stocks por página = 150 queries. | **DONE** — Agregado `joinedload(Stock.features), joinedload(Stock.exchange_rel)` |
| 5 | **Quanfury dividends ignoran `portfolio_id`** — Con `portfolio_id` set, los dividendos Quanfury siempre muestran `in_portfolio=False`. | **DONE** — Cross-reference `qf_stock.id` con `portfolio_stock_ids` |
| 6 | **`add_holding` omite `annual_dividend`** — El response de agregar holding no calcula el dividendo anual estimado. | **DONE** — Agregado cálculo `(feat.dividend_ttm or 0) * holding.shares` |
| 7 | **Analytics: tabla siempre muestra columnas 52W** — Cuando `period=100` o `200`, debería mostrar las columnas correspondientes. | **DONE** — Columnas dinámicas según `period` seleccionado |

### BAJOS — mejoras menores

| # | Problema | Estado |
|---|---------|--------|
| 8 | `/api/etl/run` es GET pero muta datos → debería ser POST | Pendiente |
| 9 | No hay validación de fechas en `/api/dividends/calendar` | **DONE** — `_parse_date_param()` con try/except y fallback a default |
| 10 | `HoldingUpdate` definido pero no hay PUT endpoint para holdings | Pendiente |
| 11 | `searchQuery` en App.vue declarado pero no usado | **DONE** — Removido |
| 12 | Top yields en Analytics navega a `/stocks` en vez de detalle del stock | **DONE** — Ahora busca por ticker y navega a `/stocks/{id}` |
| 13 | `create_portfolio` no incluye stats en response (todo en 0) | Pendiente (no rompe nada, se refresca al listar) |

---

## 2. Conexión óptima Frontend → Backend

### Principios de diseño

```
Frontend (Vue 3)          Backend (FastAPI)
   │                           │
   ├── api.ts ────────────────►│  Un solo archivo centraliza TODAS las llamadas
   │   (axios instance)        │  Proxy de Vite redirige /api → localhost:8000
   │                           │
   ├── stores/ ───────────────►│  Pinia stores cachean respuestas
   │   (stocks.ts)             │  Evitan re-fetch innecesarios
   │   (portfolios.ts)         │
   │                           │
   └── views/ ────────────────►│  Views llaman stores, NO api.ts directo
       (solo consumen stores)  │  Excepto: one-off calls (ETL, export)
```

### Lo que YA está bien

- **Proxy de Vite** (`/api` → `127.0.0.1:8000`) — correcto, evita CORS en dev
- **api.ts centralizado** — todas las llamadas en un archivo
- **Pinia stores** para stocks y portfolios — cachean estado
- **Tipos TypeScript** bien definidos para cada response
- **StockExplorer lee query params** — navegación desde Dashboard por sector funciona (`/stocks?sector=Technology`)
- **Sector browser en Dashboard** con iconos y colores por sector

### Patrón recomendado por vista

| Vista | Fuente de datos | Caching |
|-------|----------------|---------|
| **Dashboard** | `fetchDashboard()` + `fetchTopDividendYields()` + `fetchSectors()` directo | No cache (siempre fresh) |
| **StockExplorer** | `stocksStore.loadStocks()` | Cache en store, invalida al cambiar filtros |
| **StockDetail** | `stocksStore.loadStock(id)` con `?refresh=true` si `week_52_high` es null | Cache por ID en store |
| **DividendCalendar** | `fetchDividendCalendar()` directo en view | No cache (depende de fechas) |
| **PortfolioManager** | `portfoliosStore.loadPortfolios()` | Cache en store |
| **PortfolioDetail** | `portfoliosStore.loadPortfolio(id)` | Cache por ID en store |
| **Analytics** | `fetchWeekProximity()` + `fetchTopDividendYields()` directo en view | No cache (depende de filtros) |

---

## 3. Mejoras futuras

| # | Mejora | Prioridad |
|---|--------|-----------|
| 1 | Paginar `/api/dividends/calendar` — puede retornar miles de registros | Media |
| 2 | Cache de exchanges/sectors en frontend — cargar una vez en App.vue | Baja |
| 3 | Background refresh en StockDetail — disparar `refresh-prices` async | Baja |
| 4 | WebSocket para ETL progress — mostrar % real en vez de spinner | Baja |
| 5 | PUT endpoint para holdings — `HoldingUpdate` ya definido | Baja |
| 6 | Cambiar `/api/etl/run` de GET a POST | Baja |
| 7 | Error handling global en api.ts con axios interceptor | Media |
| 8 | Sector enrichment batch — script que llene sector vacío vía yfinance | Media |
