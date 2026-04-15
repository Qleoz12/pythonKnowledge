from fastapi import APIRouter, Depends, Query, HTTPException, Response
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import or_, and_, false, func, asc
from typing import Optional
from pydantic import BaseModel, Field
from datetime import datetime, timedelta
from concurrent.futures import ThreadPoolExecutor
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from database import get_db, SessionLocal
from models import Stock, StockFeature, Exchange, DividendEvent, PortfolioHolding, StockOHLCV, ChartDrawing, FairValueRevision
from logger import get_logger

log = get_logger("stocks")

router = APIRouter(prefix="/api/stocks", tags=["stocks"])


class StockOut(BaseModel):
    id: int
    ticker_yf: str
    symbol: str
    company_name: str
    exchange_code: Optional[str] = None
    sector: str
    currency: str
    market_cap: float
    is_quanfury_available: bool
    last_close: Optional[float] = None
    div_yield_ttm: Optional[float] = None
    rsi_14: Optional[float] = None
    ema_20: Optional[float] = None
    ema_52: Optional[float] = None
    ema_200: Optional[float] = None
    macd: Optional[float] = None
    macd_signal: Optional[float] = None
    dividend_ttm: Optional[float] = None
    payments_ttm: Optional[float] = None
    div_freq: Optional[str] = None
    last_div_date: Optional[str] = None
    max_drawdown: Optional[float] = None
    week_52_high: Optional[float] = None
    week_52_low: Optional[float] = None
    week_52_pct: Optional[float] = None
    next_earnings_date: Optional[str] = None
    health_score: Optional[float] = None
    class Config:
        from_attributes = True


class StockDetailOut(StockOut):
    isin: str = ""
    eps_estimate: Optional[float] = None
    reported_eps: Optional[float] = None
    surprise_pct: Optional[float] = None
    week_100_high: Optional[float] = None
    week_100_low: Optional[float] = None
    week_200_high: Optional[float] = None
    week_200_low: Optional[float] = None
    net_income_margin: Optional[float] = None
    return_on_assets: Optional[float] = None
    free_cash_flow: Optional[float] = None
    operating_cash_flow: Optional[float] = None
    fcf_yield: Optional[float] = None
    revenue: Optional[float] = None
    net_income: Optional[float] = None
    total_debt: Optional[float] = None
    debt_to_equity: Optional[float] = None
    dividend_history: list = []
    portfolios: list = []


class PriceNormalizationOut(BaseModel):
    """Live Yahoo bundle: dividend score, vol, quarterly TTM — not persisted (see Financial Health for DB-backed score)."""

    ticker_yf: str
    company_name: Optional[str] = None
    symbol: Optional[str] = None
    sector: Optional[str] = None
    industry: Optional[str] = None
    price: Optional[float] = None
    market_cap: Optional[float] = None
    dividend_yield: Optional[float] = None
    payout_ratio: Optional[float] = None
    div_growth_5y_cagr: Optional[float] = None
    volatility_1y: Optional[float] = None
    beta: Optional[float] = None
    dividend_score: Optional[float] = None
    forward_pe: Optional[float] = None
    net_income_ttm: Optional[float] = None
    ebitda_ttm: Optional[float] = None
    net_debt: Optional[float] = None
    balance_sheet_date: Optional[str] = None
    price_to_book: Optional[float] = None


class PaginatedStocks(BaseModel):
    items: list[StockOut]
    total: int
    page: int
    page_size: int
    pages: int


def compute_week_pct(price, high, low):
    if not price or not high or not low or high == low:
        return None
    return max(0, min(100, round((price - low) / (high - low) * 100, 2)))


def _stocks_list_base_query(
    db: Session,
    *,
    exchange: Optional[str] = None,
    sector: Optional[str] = None,
    quanfury_only: bool = False,
    search: Optional[str] = None,
    min_div_yield: Optional[float] = None,
    min_rsi: Optional[float] = None,
    max_rsi: Optional[float] = None,
    near_52w_high: bool = False,
    near_52w_low: bool = False,
    min_health_score: Optional[float] = None,
    max_health_score: Optional[float] = None,
    divergence: Optional[str] = None,
    ema_52_for_div: bool = True,
    ema_200_for_div: bool = True,
    portfolio_id: Optional[int] = None,
    tech_complete: bool = False,
    for_list: bool = True,
):
    """Shared filters for stock list + score-trend stats. When for_list=True, eager-loads relations."""
    opts = [joinedload(Stock.features), joinedload(Stock.exchange_rel)] if for_list else []
    query = db.query(Stock).options(*opts).outerjoin(StockFeature).outerjoin(Exchange)
    if portfolio_id is not None:
        query = query.join(PortfolioHolding, PortfolioHolding.stock_id == Stock.id).filter(
            PortfolioHolding.portfolio_id == portfolio_id
        )
    if exchange:
        codes = [c.strip().upper() for c in exchange.split(",")]
        query = query.filter(Exchange.code.in_(codes))
    if sector:
        query = query.filter(Stock.sector.ilike(f"%{sector}%"))
    if quanfury_only:
        query = query.filter(Stock.is_quanfury_available == True)
    if search:
        search_clean = search.strip()
        # Substring on company name only; tickers use prefix match so "LX" does not match "NFLX".
        term_sub = f"%{search_clean}%"
        term_pre = f"{search_clean}%"
        base = _extract_base_symbol(search_clean)
        base_pre = f"{base}%"
        search_conds = or_(
            Stock.symbol.ilike(term_pre),
            Stock.ticker_yf.ilike(term_pre),
            Stock.company_name.ilike(term_sub),
        )
        if base.upper() != search_clean.upper():
            search_conds = or_(
                search_conds,
                Stock.symbol.ilike(base_pre),
                Stock.ticker_yf.ilike(base_pre),
            )
        query = query.filter(search_conds)
    if min_div_yield:
        query = query.filter(StockFeature.div_yield_ttm >= min_div_yield)
    if min_rsi is not None:
        query = query.filter(StockFeature.rsi_14.isnot(None), StockFeature.rsi_14 >= min_rsi)
    if max_rsi is not None:
        query = query.filter(StockFeature.rsi_14.isnot(None), StockFeature.rsi_14 <= max_rsi)
    if near_52w_high:
        query = query.filter(StockFeature.last_close.isnot(None), StockFeature.week_52_high.isnot(None),
                             StockFeature.last_close >= StockFeature.week_52_high * 0.95)
    if near_52w_low:
        query = query.filter(StockFeature.last_close.isnot(None), StockFeature.week_52_low.isnot(None),
                             StockFeature.last_close <= StockFeature.week_52_low * 1.05)
    if tech_complete:
        query = query.filter(
            StockFeature.last_close.isnot(None),
            StockFeature.ema_52.isnot(None),
            StockFeature.ema_200.isnot(None),
        )
    if min_health_score is not None:
        query = query.filter(StockFeature.health_score.isnot(None), StockFeature.health_score >= min_health_score)
    if max_health_score is not None:
        query = query.filter(StockFeature.health_score.isnot(None), StockFeature.health_score <= max_health_score)

    if divergence == "strong_below_selected":
        parts = [StockFeature.health_score >= 70]
        if ema_52_for_div:
            parts.append(and_(StockFeature.ema_52.isnot(None), StockFeature.last_close < StockFeature.ema_52))
        if ema_200_for_div:
            parts.append(and_(StockFeature.ema_200.isnot(None), StockFeature.last_close < StockFeature.ema_200))
        if len(parts) == 1:
            query = query.filter(false())
        else:
            query = query.filter(and_(*parts))
    elif divergence == "poor_above_any":
        above_bits = []
        if ema_52_for_div:
            above_bits.append(and_(StockFeature.ema_52.isnot(None), StockFeature.last_close > StockFeature.ema_52))
        if ema_200_for_div:
            above_bits.append(and_(StockFeature.ema_200.isnot(None), StockFeature.last_close > StockFeature.ema_200))
        if not above_bits:
            query = query.filter(false())
        else:
            query = query.filter(
                StockFeature.health_score.isnot(None),
                StockFeature.health_score < 45,
                or_(*above_bits),
            )
    elif divergence == "poor_above_all":
        parts = [
            StockFeature.health_score.isnot(None),
            StockFeature.health_score < 45,
        ]
        if ema_52_for_div:
            parts.append(and_(StockFeature.ema_52.isnot(None), StockFeature.last_close > StockFeature.ema_52))
        if ema_200_for_div:
            parts.append(and_(StockFeature.ema_200.isnot(None), StockFeature.last_close > StockFeature.ema_200))
        if len(parts) == 2:
            query = query.filter(false())
        else:
            query = query.filter(and_(*parts))
    return query


@router.get("", response_model=PaginatedStocks)
def list_stocks(
    exchange: Optional[str] = Query(None),
    sector: Optional[str] = Query(None),
    quanfury_only: bool = Query(False),
    search: Optional[str] = Query(None),
    sort_by: str = Query("ticker_yf"),
    order: str = Query("asc"),
    near_52w_high: bool = Query(False),
    near_52w_low: bool = Query(False),
    min_div_yield: Optional[float] = Query(None),
    min_rsi: Optional[float] = Query(None),
    max_rsi: Optional[float] = Query(None),
    min_health_score: Optional[float] = Query(None),
    max_health_score: Optional[float] = Query(None),
    divergence: Optional[str] = Query(
        None,
        description="strong_below_selected | poor_above_any | poor_above_all",
    ),
    ema_52_for_div: bool = Query(True),
    ema_200_for_div: bool = Query(True),
    portfolio_id: Optional[int] = Query(None),
    tech_complete: bool = Query(False),
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=500),
    db: Session = Depends(get_db),
):
    query = _stocks_list_base_query(
        db,
        exchange=exchange,
        sector=sector,
        quanfury_only=quanfury_only,
        search=search,
        min_div_yield=min_div_yield,
        min_rsi=min_rsi,
        max_rsi=max_rsi,
        near_52w_high=near_52w_high,
        near_52w_low=near_52w_low,
        min_health_score=min_health_score,
        max_health_score=max_health_score,
        divergence=divergence,
        ema_52_for_div=ema_52_for_div,
        ema_200_for_div=ema_200_for_div,
        portfolio_id=portfolio_id,
        tech_complete=tech_complete,
        for_list=True,
    )

    dist_ema_200 = (StockFeature.last_close - StockFeature.ema_200) / StockFeature.ema_200
    sort_map = {
        "ticker_yf": Stock.ticker_yf,
        "company_name": Stock.company_name,
        "sector": Stock.sector,
        "market_cap": Stock.market_cap,
        "last_close": StockFeature.last_close,
        "div_yield_ttm": StockFeature.div_yield_ttm,
        "rsi_14": StockFeature.rsi_14,
        "dividend_ttm": StockFeature.dividend_ttm,
        "max_drawdown": StockFeature.max_drawdown,
        "health_score": StockFeature.health_score,
        "macd": StockFeature.macd,
        "dist_ema_200": dist_ema_200,
    }
    sort_col = sort_map.get(sort_by, Stock.ticker_yf)
    nullable_sort = sort_by in ("health_score", "rsi_14", "macd", "last_close", "div_yield_ttm", "dist_ema_200", "max_drawdown", "dividend_ttm")
    if order == "desc":
        sort_expr = sort_col.desc()
    else:
        sort_expr = sort_col.asc()
    if nullable_sort:
        sort_expr = sort_expr.nulls_last()

    total = query.count()
    stocks = query.order_by(sort_expr).offset((page - 1) * page_size).limit(page_size).all()

    items = []
    for s in stocks:
        f = s.features
        exc = s.exchange_rel
        items.append(StockOut(
            id=s.id, ticker_yf=s.ticker_yf, symbol=s.symbol, company_name=s.company_name,
            exchange_code=exc.code if exc else None, sector=s.sector, currency=s.currency,
            market_cap=s.market_cap, is_quanfury_available=s.is_quanfury_available,
            last_close=f.last_close if f else None, div_yield_ttm=f.div_yield_ttm if f else None,
            rsi_14=f.rsi_14 if f else None, ema_20=f.ema_20 if f else None,
            ema_52=f.ema_52 if f else None, ema_200=f.ema_200 if f else None,
            macd=f.macd if f else None, macd_signal=f.macd_signal if f else None,
            dividend_ttm=f.dividend_ttm if f else None, payments_ttm=f.payments_ttm if f else None,
            div_freq=f.div_freq if f else None, last_div_date=f.last_div_date if f else None,
            max_drawdown=f.max_drawdown if f else None,
            week_52_high=f.week_52_high if f else None, week_52_low=f.week_52_low if f else None,
            week_52_pct=compute_week_pct(f.last_close if f else None, f.week_52_high if f else None, f.week_52_low if f else None),
            next_earnings_date=f.next_earnings_date if f else None,
            health_score=f.health_score if f else None,
        ))

    return PaginatedStocks(items=items, total=total, page=page, page_size=page_size, pages=(total + page_size - 1) // page_size)


class StockCreate(BaseModel):
    ticker: str
    exchange: str = ""
    shares: float = 0
    avg_price: float = 0
    portfolio_id: Optional[int] = None
    enrich: bool = True


EXCHANGE_ALIASES = {
    "NMS": "NASDAQ", "NGM": "NASDAQ", "NCM": "NASDAQ", "NASDAQ": "NASDAQ",
    "NYQ": "NYSE", "NYSE": "NYSE",
    "TSE": "TSX", "TOR": "TSX", "TSX": "TSX",
    "LSE": "LSE", "LON": "LSE",
}


def _enrich_from_yfinance(ticker_yf: str) -> dict:
    import yfinance as yf
    from datetime import datetime, timedelta

    info = {}
    try:
        t = yf.Ticker(ticker_yf)
        yf_info = t.info or {}

        raw_exchange = yf_info.get("exchange", "")
        exchange_code = EXCHANGE_ALIASES.get(raw_exchange, raw_exchange)

        info["company_name"] = yf_info.get("shortName") or yf_info.get("longName", "")
        info["sector"] = yf_info.get("sector", "")
        info["industry"] = yf_info.get("industry", "")
        info["currency"] = yf_info.get("currency", "USD")
        info["market_cap"] = yf_info.get("marketCap", 0) or 0
        info["exchange_code"] = exchange_code
        info["last_close"] = yf_info.get("previousClose") or yf_info.get("regularMarketPrice")
        info["dividend_ttm"] = yf_info.get("dividendRate")
        info["div_yield_ttm"] = yf_info.get("dividendYield")
        if info["div_yield_ttm"]:
            info["div_yield_ttm"] = info["div_yield_ttm"] * 100

        info["revenue"] = yf_info.get("totalRevenue")
        info["net_income"] = yf_info.get("netIncomeToCommon")
        info["operating_cash_flow"] = yf_info.get("operatingCashflow")
        info["free_cash_flow"] = yf_info.get("freeCashflow")
        info["total_debt"] = yf_info.get("totalDebt")
        de = yf_info.get("debtToEquity")
        info["debt_to_equity"] = de if de is not None else None
        pm = yf_info.get("profitMargins")
        info["net_income_margin"] = round(pm * 100, 2) if pm is not None else None
        roa = yf_info.get("returnOnAssets")
        info["return_on_assets"] = round(roa * 100, 2) if roa is not None else None
        mcap = info.get("market_cap") or 0
        fcf = info.get("free_cash_flow")
        info["fcf_yield"] = round(fcf / mcap * 100, 2) if fcf and mcap and mcap > 0 else None

        end = datetime.now()
        start = end - timedelta(weeks=200)
        hist = yf.download(ticker_yf, start=start, end=end, progress=False, timeout=15, auto_adjust=False)
        if hist is not None and not hist.empty:
            close = hist["Close"].dropna()
            if hasattr(close, 'columns'):
                close = close.iloc[:, 0]
            if not close.empty:
                info["last_close"] = float(close.iloc[-1])
                n52 = min(252, len(close))
                n100 = min(500, len(close))
                w52, w100, w200 = close.iloc[-n52:], close.iloc[-n100:], close
                info["week_52_high"] = float(w52.max())
                info["week_52_low"] = float(w52.min())
                info["week_100_high"] = float(w100.max())
                info["week_100_low"] = float(w100.min())
                info["week_200_high"] = float(w200.max())
                info["week_200_low"] = float(w200.min())
    except Exception as e:
        log.warning("yfinance enrich failed for %s: %s", ticker_yf, e)

    return info


@router.post("", status_code=201)
def create_stock(data: StockCreate, db: Session = Depends(get_db)):
    """Add a new stock by ticker. Optionally enrich from yfinance and add to a portfolio."""
    ticker = data.ticker.strip().upper()
    symbol = ticker.split(".")[0]

    existing = db.query(Stock).filter(
        or_(Stock.ticker_yf == ticker, Stock.symbol == symbol)
    ).first()

    _FEATURE_KEYS = [
        "last_close", "dividend_ttm", "div_yield_ttm",
        "week_52_high", "week_52_low", "week_100_high",
        "week_100_low", "week_200_high", "week_200_low",
        "net_income_margin", "return_on_assets", "free_cash_flow",
        "operating_cash_flow", "fcf_yield", "revenue", "net_income",
        "total_debt", "debt_to_equity",
    ]

    if existing:
        stock = existing
        if data.enrich and not existing.features:
            yf_data = _enrich_from_yfinance(existing.ticker_yf)
            feat = StockFeature(stock_id=existing.id)
            for k in _FEATURE_KEYS:
                if k in yf_data:
                    setattr(feat, k, yf_data[k])
            db.add(feat)
            db.commit()
    else:
        yf_data = _enrich_from_yfinance(ticker) if data.enrich else {}

        exchange_code = data.exchange.upper() or yf_data.get("exchange_code", "OTHER")
        exchange = db.query(Exchange).filter_by(code=exchange_code).first()
        if not exchange:
            exchange = Exchange(code=exchange_code, name=exchange_code)
            db.add(exchange)
            db.flush()

        stock = Stock(
            ticker_yf=ticker,
            symbol=symbol,
            company_name=yf_data.get("company_name", ticker),
            exchange_id=exchange.id,
            sector=yf_data.get("sector", ""),
            industry=yf_data.get("industry", ""),
            currency=yf_data.get("currency", data.exchange or "USD"),
            market_cap=yf_data.get("market_cap", 0),
        )
        db.add(stock)
        db.flush()

        if yf_data.get("last_close"):
            feat = StockFeature(stock_id=stock.id)
            for k in _FEATURE_KEYS:
                if k in yf_data:
                    setattr(feat, k, yf_data[k])
            db.add(feat)

        db.commit()
        db.refresh(stock)

    if data.portfolio_id and data.shares > 0:
        from models import PortfolioHolding, Portfolio
        portfolio = db.query(Portfolio).filter_by(id=data.portfolio_id).first()
        if portfolio:
            existing_holding = db.query(PortfolioHolding).filter_by(
                portfolio_id=data.portfolio_id, stock_id=stock.id
            ).first()
            if existing_holding:
                ts = existing_holding.shares + data.shares
                if ts > 0:
                    existing_holding.avg_price = (
                        existing_holding.avg_price * existing_holding.shares + data.avg_price * data.shares
                    ) / ts
                existing_holding.shares = ts
            else:
                db.add(PortfolioHolding(
                    portfolio_id=data.portfolio_id, stock_id=stock.id,
                    shares=data.shares, avg_price=data.avg_price,
                ))
            db.commit()

    f = stock.features
    exc = stock.exchange_rel
    return {
        "id": stock.id,
        "ticker_yf": stock.ticker_yf,
        "symbol": stock.symbol,
        "company_name": stock.company_name,
        "exchange_code": exc.code if exc else None,
        "sector": stock.sector,
        "currency": stock.currency,
        "last_close": f.last_close if f else None,
        "div_yield_ttm": f.div_yield_ttm if f else None,
        "week_52_high": f.week_52_high if f else None,
        "week_52_low": f.week_52_low if f else None,
        "message": "Stock created and enriched" if data.enrich else "Stock created",
    }


@router.get("/exchanges")
def list_exchanges(db: Session = Depends(get_db)):
    return [{"id": e.id, "code": e.code, "name": e.name} for e in db.query(Exchange).all()]


@router.get("/sectors")
def list_sectors(db: Session = Depends(get_db)):
    return [s[0] for s in db.query(Stock.sector).distinct().filter(Stock.sector != "").order_by(Stock.sector).all()]


@router.get("/sector-stats")
def sector_stats(db: Session = Depends(get_db)):
    from sqlalchemy import func, case
    rows = (
        db.query(
            Stock.sector,
            func.count(Stock.id),
            func.avg(StockFeature.div_yield_ttm),
            func.sum(case((Stock.is_quanfury_available == True, 1), else_=0)),
            func.sum(case((StockFeature.dividend_ttm > 0, 1), else_=0)),
            func.sum(case((StockFeature.last_close.is_(None), 1), else_=0)),
        )
        .outerjoin(StockFeature, Stock.id == StockFeature.stock_id)
        .filter(Stock.sector != "", Stock.sector.isnot(None))
        .group_by(Stock.sector)
        .order_by(func.count(Stock.id).desc())
        .all()
    )
    return [{"sector": r[0], "count": r[1],
             "avg_div_yield": round(float(r[2]), 2) if r[2] else None,
             "quanfury_count": int(r[3] or 0),
             "with_dividends": int(r[4] or 0),
             "missing_prices": int(r[5] or 0)} for r in rows]


def _build_price_normalization(stock_id: int, db: Session) -> PriceNormalizationOut:
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")
    try:
        from services.price_normalization import compute_for_ticker

        return PriceNormalizationOut(**compute_for_ticker(stock.ticker_yf))
    except HTTPException:
        raise
    except Exception as e:
        log.warning("price_normalization failed ticker=%s: %s", stock.ticker_yf, e, exc_info=True)
        raise HTTPException(
            status_code=503,
            detail="Could not load Yahoo fundamentals for this ticker. Try again later.",
        ) from e


@router.get("/fundamentals/yahoo/{stock_id}", response_model=PriceNormalizationOut)
def get_price_normalization_stable_path(stock_id: int, db: Session = Depends(get_db)):
    """
    Same payload as /{stock_id}/price-normalization; static prefix avoids some proxies
    or older servers missing the nested route.
    """
    return _build_price_normalization(stock_id, db)


def _extract_base_symbol(raw: str) -> str:
    """Strip common exchange suffixes like .OQ .N .L .TO .AX etc. to get the base symbol."""
    raw = raw.strip().upper()
    if "." in raw:
        base = raw.split(".")[0]
        if base:
            return base
    return raw


@router.get("/search")
def search_stocks(q: str = Query(...), limit: int = 20, db: Session = Depends(get_db)):
    q_clean = q.strip()
    term_sub = f"%{q_clean}%"
    term_pre = f"{q_clean}%"
    base = _extract_base_symbol(q_clean)
    base_pre = f"{base}%"

    conditions = or_(
        Stock.symbol.ilike(term_pre),
        Stock.company_name.ilike(term_sub),
        Stock.ticker_yf.ilike(term_pre),
    )
    if base.upper() != q_clean.upper():
        conditions = or_(
            conditions,
            Stock.symbol.ilike(base_pre),
            Stock.ticker_yf.ilike(base_pre),
        )

    stocks = db.query(Stock).outerjoin(Exchange).filter(conditions).limit(limit).all()
    return [{"id": s.id, "ticker_yf": s.ticker_yf, "symbol": s.symbol,
             "company_name": s.company_name, "exchange_code": s.exchange_rel.code if s.exchange_rel else None} for s in stocks]


@router.get("/by-ticker/{ticker_yf:path}")
def get_stock_by_ticker(ticker_yf: str, db: Session = Depends(get_db)):
    """Find stock ID by ticker_yf — tries exact match, then symbol, then base symbol."""
    ticker_yf = ticker_yf.strip()
    stock = db.query(Stock).filter(Stock.ticker_yf.ilike(ticker_yf)).first()
    if not stock:
        stock = db.query(Stock).filter(Stock.symbol.ilike(ticker_yf)).first()
    if not stock:
        base = _extract_base_symbol(ticker_yf)
        if base != ticker_yf.upper():
            stock = db.query(Stock).filter(
                or_(Stock.symbol.ilike(base), Stock.ticker_yf.ilike(base))
            ).first()
    if not stock:
        raise HTTPException(status_code=404, detail=f"Stock '{ticker_yf}' not found")
    return {"id": stock.id, "ticker_yf": stock.ticker_yf, "symbol": stock.symbol}


def _calc_rsi(series, period=14):
    """Wilder's RSI."""
    import numpy as np
    delta = series.diff()
    gain = delta.clip(lower=0)
    loss = -delta.clip(upper=0)
    avg_gain = gain.ewm(alpha=1/period, min_periods=period).mean()
    avg_loss = loss.ewm(alpha=1/period, min_periods=period).mean()
    rs = avg_gain / avg_loss.replace(0, np.nan)
    return 100 - (100 / (1 + rs))


def _calc_max_drawdown(series):
    """Max drawdown as a negative percentage."""
    peak = series.cummax()
    dd = (series - peak) / peak
    return float(dd.min()) * 100


def _update_financial_health(yf_info: dict, stock, feature):
    """Extract financial statement metrics from yfinance info and compute a health score (0-100)."""
    feature.revenue = yf_info.get("totalRevenue")
    feature.net_income = yf_info.get("netIncomeToCommon")
    feature.operating_cash_flow = yf_info.get("operatingCashflow")
    feature.free_cash_flow = yf_info.get("freeCashflow")
    feature.total_debt = yf_info.get("totalDebt")

    de = yf_info.get("debtToEquity")
    feature.debt_to_equity = de if de is not None else None

    pm = yf_info.get("profitMargins")
    feature.net_income_margin = round(pm * 100, 2) if pm is not None else None

    roa = yf_info.get("returnOnAssets")
    feature.return_on_assets = round(roa * 100, 2) if roa is not None else None

    mcap = stock.market_cap or yf_info.get("marketCap")
    if feature.free_cash_flow and mcap and mcap > 0:
        feature.fcf_yield = round(feature.free_cash_flow / mcap * 100, 2)
    else:
        feature.fcf_yield = None

    feature.health_score = _calc_health_score(feature)


def _calc_health_score(f) -> float:
    """Weighted 0-100 score based on the video's 3 indicators + debt + EMA position.

    Weights:
      Net Income Margin  25 pts
      Return on Assets   20 pts
      Free Cash Flow     25 pts  (FCF yield)
      Debt to Equity     15 pts
      EMA Position       15 pts  (price below EMAs = value opportunity)
    """
    pts = 0.0
    available = 0

    nim = f.net_income_margin
    if nim is not None:
        available += 25
        if nim > 20:
            pts += 25
        elif nim > 10:
            pts += 20
        elif nim > 5:
            pts += 15
        elif nim > 0:
            pts += 8
        # negative = 0

    roa = f.return_on_assets
    if roa is not None:
        available += 20
        if roa > 15:
            pts += 20
        elif roa > 8:
            pts += 16
        elif roa > 3:
            pts += 10
        elif roa > 0:
            pts += 5

    fcfy = f.fcf_yield
    if fcfy is not None:
        available += 25
        if fcfy > 8:
            pts += 25
        elif fcfy > 5:
            pts += 20
        elif fcfy > 2:
            pts += 15
        elif fcfy > 0:
            pts += 8

    de = f.debt_to_equity
    if de is not None:
        available += 15
        if de < 30:
            pts += 15
        elif de < 60:
            pts += 12
        elif de < 100:
            pts += 8
        elif de < 200:
            pts += 4

    price = f.last_close
    if price and f.ema_20 and f.ema_52:
        available += 15
        below_count = sum(1 for ema in [f.ema_20, f.ema_52, f.ema_200] if ema and price < ema)
        if below_count == 3:
            pts += 15
        elif below_count == 2:
            pts += 10
        elif below_count == 1:
            pts += 5

    if available == 0:
        return None
    return round(pts / available * 100, 1)


def _refresh_stock_data(stock: Stock, feature: StockFeature, db: Session):
    """Fetch price history + info from yfinance. Calculates all technical indicators."""
    import yfinance as yf
    from datetime import datetime, timedelta
    import pandas as pd

    ticker_yf = stock.ticker_yf
    try:
        t = yf.Ticker(ticker_yf)
        yf_info = t.info or {}

        if not stock.sector and yf_info.get("sector"):
            stock.sector = yf_info["sector"]
        if not stock.industry and yf_info.get("industry"):
            stock.industry = yf_info["industry"]
        if not stock.currency and yf_info.get("currency"):
            stock.currency = yf_info["currency"]
        if (not stock.market_cap or stock.market_cap == 0) and yf_info.get("marketCap"):
            stock.market_cap = yf_info["marketCap"]

        if yf_info.get("dividendRate"):
            feature.dividend_ttm = yf_info["dividendRate"]
        if yf_info.get("dividendYield"):
            feature.div_yield_ttm = yf_info["dividendYield"] * 100
        if yf_info.get("trailingAnnualDividendRate") and not feature.dividend_ttm:
            feature.dividend_ttm = yf_info["trailingAnnualDividendRate"]
        if yf_info.get("trailingAnnualDividendYield") and not feature.div_yield_ttm:
            feature.div_yield_ttm = yf_info["trailingAnnualDividendYield"] * 100

        if yf_info.get("epsForward"):
            feature.eps_estimate = yf_info["epsForward"]
        if yf_info.get("trailingEps"):
            feature.reported_eps = yf_info["trailingEps"]
        if feature.eps_estimate and feature.reported_eps and feature.eps_estimate != 0:
            feature.surprise_pct = round((feature.reported_eps - feature.eps_estimate) / abs(feature.eps_estimate) * 100, 2)

        earnings_dates = yf_info.get("earningsTimestamp") or yf_info.get("earningsTimestampStart")
        if earnings_dates:
            from datetime import timezone
            try:
                feature.next_earnings_date = datetime.fromtimestamp(earnings_dates, tz=timezone.utc).strftime("%Y-%m-%d")
            except Exception:
                pass

        div_count = yf_info.get("dividendRate", 0) and yf_info.get("lastDividendValue", 0)
        if yf_info.get("dividendRate") and yf_info.get("lastDividendValue") and yf_info["lastDividendValue"] > 0:
            freq_num = round(yf_info["dividendRate"] / yf_info["lastDividendValue"])
            freq_map = {1: "Annual", 2: "Semi-Annual", 4: "Quarterly", 12: "Monthly"}
            feature.div_freq = freq_map.get(freq_num, f"{freq_num}x/yr")
            feature.payments_ttm = freq_num

        if yf_info.get("lastDividendDate"):
            from datetime import timezone
            try:
                feature.last_div_date = datetime.fromtimestamp(yf_info["lastDividendDate"], tz=timezone.utc).strftime("%Y-%m-%d")
            except Exception:
                pass

        end = datetime.now()
        start = end - timedelta(weeks=200)
        hist = yf.download(ticker_yf, start=start, end=end, progress=False, timeout=15, auto_adjust=False)

        if hist is not None and not hist.empty:
            close = hist["Close"].dropna()
            if hasattr(close, 'columns'):
                close = close.iloc[:, 0]
            if not close.empty and len(close) >= 2:
                feature.last_close = float(close.iloc[-1])

                n52 = min(252, len(close))
                n100 = min(500, len(close))
                w52, w100, w200 = close.iloc[-n52:], close.iloc[-n100:], close

                price = feature.last_close
                ranges = {
                    "52": (float(w52.min()), float(w52.max())),
                    "100": (float(w100.min()), float(w100.max())),
                    "200": (float(w200.min()), float(w200.max())),
                }
                sane = True
                for label, (lo, hi) in ranges.items():
                    if lo < price * 0.05 or hi < price * 0.05:
                        log.warning("Suspicious %sW range for %s: low=%s high=%s vs price=%s — skipping range update",
                                    label, ticker_yf, lo, hi, price)
                        sane = False
                        break

                if sane:
                    feature.week_52_high = ranges["52"][1]
                    feature.week_52_low = ranges["52"][0]
                    feature.week_100_high = ranges["100"][1]
                    feature.week_100_low = ranges["100"][0]
                    feature.week_200_high = ranges["200"][1]
                    feature.week_200_low = ranges["200"][0]

                feature.ema_20 = float(close.ewm(span=20, adjust=False).mean().iloc[-1])
                feature.ema_52 = float(close.ewm(span=52, adjust=False).mean().iloc[-1])
                if len(close) >= 200:
                    feature.ema_200 = float(close.ewm(span=200, adjust=False).mean().iloc[-1])

                if len(close) >= 26:
                    ema12 = close.ewm(span=12, adjust=False).mean()
                    ema26 = close.ewm(span=26, adjust=False).mean()
                    macd_line = ema12 - ema26
                    signal_line = macd_line.ewm(span=9, adjust=False).mean()
                    feature.macd = round(float(macd_line.iloc[-1]), 4)
                    feature.macd_signal = round(float(signal_line.iloc[-1]), 4)

                if len(close) >= 14:
                    rsi = _calc_rsi(close, 14)
                    feature.rsi_14 = round(float(rsi.iloc[-1]), 2)

                feature.max_drawdown = round(_calc_max_drawdown(close), 2)

        _update_financial_health(yf_info, stock, feature)

        db.commit()
        log.info("REFRESH %s: price=%s, rsi=%s, macd=%s, score=%s, sector=%s",
                 ticker_yf, feature.last_close, feature.rsi_14, feature.macd, feature.health_score, stock.sector)
    except Exception as e:
        log.warning("refresh failed for %s: %s", ticker_yf, e, exc_info=True)


class ScoreTrendStatsOut(BaseModel):
    total: int
    strong_below_ema200: int
    strong_below_both_emas: int
    poor_above_ema200: int
    poor_above_any_ema: int


def _score_trend_common_kwargs(
    exchange, sector, quanfury_only, search, portfolio_id, min_health_score, max_health_score, tech_complete,
):
    return dict(
        exchange=exchange,
        sector=sector,
        quanfury_only=quanfury_only,
        search=search,
        portfolio_id=portfolio_id,
        min_health_score=min_health_score,
        max_health_score=max_health_score,
        tech_complete=tech_complete,
        divergence=None,
        for_list=False,
    )


@router.get("/score-trend/stats", response_model=ScoreTrendStatsOut)
def score_trend_stats(
    exchange: Optional[str] = Query(None),
    sector: Optional[str] = Query(None),
    quanfury_only: bool = Query(False),
    search: Optional[str] = Query(None),
    portfolio_id: Optional[int] = Query(None),
    min_health_score: Optional[float] = Query(None),
    max_health_score: Optional[float] = Query(None),
    tech_complete: bool = Query(False),
    db: Session = Depends(get_db),
):
    """Counts for score vs EMA screening (same base filters as list, no divergence filter)."""
    kw = _score_trend_common_kwargs(
        exchange, sector, quanfury_only, search, portfolio_id, min_health_score, max_health_score, tech_complete,
    )
    base = _stocks_list_base_query(db, **kw)
    total = base.count()

    def extra_count(*filters):
        return _stocks_list_base_query(db, **kw).filter(*filters).count()

    strong_below_ema200 = extra_count(
        StockFeature.health_score >= 70,
        StockFeature.last_close.isnot(None),
        StockFeature.ema_200.isnot(None),
        StockFeature.last_close < StockFeature.ema_200,
    )
    strong_below_both_emas = extra_count(
        StockFeature.health_score >= 70,
        StockFeature.last_close.isnot(None),
        StockFeature.ema_52.isnot(None),
        StockFeature.ema_200.isnot(None),
        StockFeature.last_close < StockFeature.ema_52,
        StockFeature.last_close < StockFeature.ema_200,
    )
    poor_above_ema200 = extra_count(
        StockFeature.health_score.isnot(None),
        StockFeature.health_score < 45,
        StockFeature.last_close.isnot(None),
        StockFeature.ema_200.isnot(None),
        StockFeature.last_close > StockFeature.ema_200,
    )
    poor_above_any_ema = extra_count(
        StockFeature.health_score.isnot(None),
        StockFeature.health_score < 45,
        or_(
            and_(StockFeature.ema_52.isnot(None), StockFeature.last_close > StockFeature.ema_52),
            and_(StockFeature.ema_200.isnot(None), StockFeature.last_close > StockFeature.ema_200),
        ),
    )
    return ScoreTrendStatsOut(
        total=total,
        strong_below_ema200=strong_below_ema200,
        strong_below_both_emas=strong_below_both_emas,
        poor_above_ema200=poor_above_ema200,
        poor_above_any_ema=poor_above_any_ema,
    )


@router.delete("/{stock_id}", status_code=204, response_class=Response)
def delete_stock(stock_id: int, db: Session = Depends(get_db)):
    """Remove a stock and related rows (holdings, OHLCV cache, chart drawings, dividends, features)."""
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")
    ticker = stock.ticker_yf
    try:
        db.query(PortfolioHolding).filter(PortfolioHolding.stock_id == stock_id).delete(synchronize_session=False)
        db.query(ChartDrawing).filter(ChartDrawing.stock_id == stock_id).delete(synchronize_session=False)
        db.query(StockOHLCV).filter(StockOHLCV.stock_id == stock_id).delete(synchronize_session=False)
        db.query(DividendEvent).filter(DividendEvent.stock_id == stock_id).delete(synchronize_session=False)
        db.query(StockFeature).filter(StockFeature.stock_id == stock_id).delete(synchronize_session=False)
        db.query(FairValueRevision).filter(FairValueRevision.stock_id == stock_id).delete(synchronize_session=False)
        db.delete(stock)
        db.commit()
        log.info("DELETED stock id=%s ticker_yf=%s", stock_id, ticker)
    except Exception as e:
        db.rollback()
        log.warning("delete stock failed id=%s: %s", stock_id, e, exc_info=True)
        raise HTTPException(status_code=500, detail="Could not delete stock") from e
    return Response(status_code=204)


@router.get("/{stock_id}", response_model=StockDetailOut)
def get_stock(stock_id: int, refresh: bool = Query(False, description="Force refresh price ranges from yfinance"), db: Session = Depends(get_db)):
    stock = db.query(Stock).options(joinedload(Stock.features), joinedload(Stock.exchange_rel), joinedload(Stock.holdings)).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")

    f = stock.features

    if refresh:
        if not f:
            f = StockFeature(stock_id=stock.id)
            db.add(f)
            db.flush()
            stock.features = f
        _refresh_stock_data(stock, f, db)
        db.refresh(f)
        db.refresh(stock)

    exc = stock.exchange_rel
    divs = db.query(DividendEvent).filter_by(stock_id=stock.id).order_by(DividendEvent.div_date.desc()).limit(100).all()
    div_history = [{"date": str(d.div_date), "amount": d.div_amount} for d in divs]

    from models import PortfolioHolding, Portfolio
    portfolio_list = []
    for h in stock.holdings:
        p = db.query(Portfolio).filter_by(id=h.portfolio_id).first()
        if p:
            portfolio_list.append({"id": p.id, "name": p.name, "shares": h.shares})

    return StockDetailOut(
        id=stock.id, ticker_yf=stock.ticker_yf, symbol=stock.symbol, company_name=stock.company_name,
        exchange_code=exc.code if exc else None, sector=stock.sector, currency=stock.currency,
        market_cap=stock.market_cap, is_quanfury_available=stock.is_quanfury_available, isin=stock.isin or "",
        last_close=f.last_close if f else None, div_yield_ttm=f.div_yield_ttm if f else None,
        rsi_14=f.rsi_14 if f else None, ema_20=f.ema_20 if f else None, ema_52=f.ema_52 if f else None,
        ema_200=f.ema_200 if f else None, macd=f.macd if f else None, macd_signal=f.macd_signal if f else None,
        dividend_ttm=f.dividend_ttm if f else None, payments_ttm=f.payments_ttm if f else None,
        div_freq=f.div_freq if f else None, last_div_date=f.last_div_date if f else None,
        max_drawdown=f.max_drawdown if f else None,
        week_52_high=f.week_52_high if f else None, week_52_low=f.week_52_low if f else None,
        week_52_pct=compute_week_pct(f.last_close if f else None, f.week_52_high if f else None, f.week_52_low if f else None),
        next_earnings_date=f.next_earnings_date if f else None,
        eps_estimate=f.eps_estimate if f else None, reported_eps=f.reported_eps if f else None,
        surprise_pct=f.surprise_pct if f else None,
        week_100_high=f.week_100_high if f else None, week_100_low=f.week_100_low if f else None,
        week_200_high=f.week_200_high if f else None, week_200_low=f.week_200_low if f else None,
        net_income_margin=f.net_income_margin if f else None,
        return_on_assets=f.return_on_assets if f else None,
        free_cash_flow=f.free_cash_flow if f else None,
        operating_cash_flow=f.operating_cash_flow if f else None,
        fcf_yield=f.fcf_yield if f else None,
        revenue=f.revenue if f else None,
        net_income=f.net_income if f else None,
        total_debt=f.total_debt if f else None,
        debt_to_equity=f.debt_to_equity if f else None,
        health_score=f.health_score if f else None,
        dividend_history=div_history, portfolios=portfolio_list,
    )


@router.post("/{stock_id}/refresh-prices")
def refresh_stock_prices(stock_id: int, db: Session = Depends(get_db)):
    """Force refresh price ranges for a single stock from yfinance."""
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")

    f = db.query(StockFeature).filter_by(stock_id=stock.id).first()
    if not f:
        f = StockFeature(stock_id=stock.id)
        db.add(f)
        db.flush()

    _refresh_stock_data(stock, f, db)

    return {
        "ticker_yf": stock.ticker_yf,
        "last_close": f.last_close,
        "sector": stock.sector,
        "industry": stock.industry,
        "rsi_14": f.rsi_14,
        "macd": f.macd,
        "macd_signal": f.macd_signal,
        "ema_20": f.ema_20,
        "ema_52": f.ema_52,
        "ema_200": f.ema_200,
        "max_drawdown": f.max_drawdown,
        "dividend_ttm": f.dividend_ttm,
        "div_yield_ttm": f.div_yield_ttm,
        "div_freq": f.div_freq,
        "eps_estimate": f.eps_estimate,
        "reported_eps": f.reported_eps,
        "week_52_high": f.week_52_high,
        "week_52_low": f.week_52_low,
        "week_100_high": f.week_100_high,
        "week_100_low": f.week_100_low,
        "week_200_high": f.week_200_high,
        "week_200_low": f.week_200_low,
    }


@router.get("/{stock_id}/price-normalization", response_model=PriceNormalizationOut)
def get_price_normalization(stock_id: int, db: Session = Depends(get_db)):
    """Alias of GET /fundamentals/yahoo/{stock_id} (on-demand Yahoo snapshot)."""
    return _build_price_normalization(stock_id, db)


class EnrichRequest(BaseModel):
    batch_size: int = 10
    mode: str = "missing_prices"


class EnrichStatus(BaseModel):
    total_missing: int
    enriched: int
    failed: int
    details: list


@router.get("/enrich/status")
def enrich_status(db: Session = Depends(get_db)):
    """How many stocks need enrichment."""
    missing_prices = (
        db.query(Stock)
        .outerjoin(StockFeature)
        .filter(
            (StockFeature.id == None) | (StockFeature.last_close == None)
        )
        .count()
    )
    missing_sector = db.query(Stock).filter(
        (Stock.sector == None) | (Stock.sector == "")
    ).count()
    total = db.query(Stock).count()

    return {
        "total_stocks": total,
        "missing_prices": missing_prices,
        "missing_sector": missing_sector,
        "health_pct": round((1 - missing_prices / max(total, 1)) * 100, 1),
    }


@router.post("/enrich/batch", response_model=EnrichStatus)
def enrich_batch(data: EnrichRequest, db: Session = Depends(get_db)):
    """Enrich a batch of stocks with missing data from yfinance."""
    import time

    if data.mode == "missing_sector":
        stocks = (
            db.query(Stock)
            .outerjoin(StockFeature)
            .filter(
                (Stock.sector == None) | (Stock.sector == "")
            )
            .limit(data.batch_size)
            .all()
        )
    else:
        stocks = (
            db.query(Stock)
            .outerjoin(StockFeature)
            .filter(
                (StockFeature.id == None) | (StockFeature.last_close == None)
            )
            .limit(data.batch_size)
            .all()
        )

    enriched = 0
    failed = 0
    details = []

    for stock in stocks:
        f = db.query(StockFeature).filter_by(stock_id=stock.id).first()
        if not f:
            f = StockFeature(stock_id=stock.id)
            db.add(f)
            db.flush()
        try:
            _refresh_stock_data(stock, f, db)
            enriched += 1
            details.append({"ticker": stock.ticker_yf, "status": "ok", "price": f.last_close, "sector": stock.sector})
        except Exception as e:
            failed += 1
            details.append({"ticker": stock.ticker_yf, "status": "error", "error": str(e)})
        time.sleep(0.3)

    total_remaining = (
        db.query(Stock)
        .outerjoin(StockFeature)
        .filter(
            (StockFeature.id == None) | (StockFeature.last_close == None)
        )
        .count()
    )

    return EnrichStatus(
        total_missing=total_remaining,
        enriched=enriched,
        failed=failed,
        details=details,
    )


class FilteredEnrichRequest(BaseModel):
    """Same dimensions as GET /stocks list filters so batch refresh respects the UI scope."""

    sector: Optional[str] = None
    exchange: Optional[str] = None
    search: Optional[str] = None
    quanfury_only: bool = False
    near_52w_high: bool = False
    near_52w_low: bool = False
    min_div_yield: Optional[float] = None
    min_rsi: Optional[float] = None
    max_rsi: Optional[float] = None
    min_health_score: Optional[float] = None
    max_health_score: Optional[float] = None
    divergence: Optional[str] = Field(
        None,
        description="strong_below_selected | poor_above_any | poor_above_all",
    )
    ema_52_for_div: bool = True
    ema_200_for_div: bool = True
    portfolio_id: Optional[int] = None
    tech_complete: bool = False
    batch_size: int = Field(10, ge=1, le=1000)
    force: bool = False
    offset: int = 0
    stale_first: bool = Field(
        False,
        description="When force=True, refresh rows with oldest StockFeature.updated_at first (NULLs first).",
    )
    max_workers: int = Field(
        3,
        ge=1,
        le=8,
        description="Parallel Yahoo refreshes (each worker uses its own DB session). Use 1 to be gentlest; 3–5 typical; >5 risks Yahoo throttling.",
    )


class FeaturesRefreshStatusOut(BaseModel):
    max_updated_at: Optional[str] = None
    min_updated_at: Optional[str] = None
    stale_count: int
    total_features: int
    hours: float


@router.get("/features/refresh-status", response_model=FeaturesRefreshStatusOut)
def features_refresh_status(
    hours: float = Query(24, ge=1, le=8760, description="Age threshold: rows older than this are 'stale'"),
    db: Session = Depends(get_db),
):
    """Latest / oldest feature timestamps and how many rows are older than `hours` (for auto-refresh logic)."""
    threshold = datetime.utcnow() - timedelta(hours=hours)
    total_features = db.query(StockFeature).count()
    max_u = db.query(func.max(StockFeature.updated_at)).scalar()
    min_u = db.query(func.min(StockFeature.updated_at)).scalar()
    stale_count = (
        db.query(StockFeature)
        .filter((StockFeature.updated_at == None) | (StockFeature.updated_at < threshold))
        .count()
    )

    def _iso(dt):
        if dt is None:
            return None
        if getattr(dt, "tzinfo", None) is not None:
            return dt.isoformat()
        return dt.isoformat() + "Z"

    return FeaturesRefreshStatusOut(
        max_updated_at=_iso(max_u),
        min_updated_at=_iso(min_u),
        stale_count=stale_count,
        total_features=total_features,
        hours=hours,
    )


def _enrich_single_stock_thread(stock_id: int) -> dict:
    """Run yfinance refresh in a worker thread with its own DB session (not the request session)."""
    ldb = SessionLocal()
    ticker = f"id={stock_id}"
    try:
        stock = ldb.query(Stock).filter(Stock.id == stock_id).first()
        if not stock:
            return {"ticker": ticker, "status": "error", "error": "Stock not found"}
        ticker = stock.ticker_yf
        f = ldb.query(StockFeature).filter_by(stock_id=stock_id).first()
        if not f:
            f = StockFeature(stock_id=stock_id)
            ldb.add(f)
            ldb.flush()
        _refresh_stock_data(stock, f, ldb)
        return {"ticker": ticker, "status": "ok", "price": f.last_close}
    except Exception as e:
        return {"ticker": ticker, "status": "error", "error": str(e)}
    finally:
        ldb.close()


@router.post("/enrich/filtered")
def enrich_filtered(data: FilteredEnrichRequest, db: Session = Depends(get_db)):
    """Enrich stocks matching filters that have missing price/indicator data.
    With force=True, re-enrich ALL matching stocks regardless of existing data.
    Filters mirror GET /api/stocks (exchange, score band, divergence preset, portfolio, etc.)."""
    import time

    query = _stocks_list_base_query(
        db,
        exchange=data.exchange,
        sector=data.sector,
        quanfury_only=data.quanfury_only,
        search=data.search,
        min_div_yield=data.min_div_yield,
        min_rsi=data.min_rsi,
        max_rsi=data.max_rsi,
        near_52w_high=data.near_52w_high,
        near_52w_low=data.near_52w_low,
        min_health_score=data.min_health_score,
        max_health_score=data.max_health_score,
        divergence=data.divergence,
        ema_52_for_div=data.ema_52_for_div,
        ema_200_for_div=data.ema_200_for_div,
        portfolio_id=data.portfolio_id,
        tech_complete=data.tech_complete,
        for_list=True,
    )

    total_matching = query.count()

    if data.force:
        total_pending = total_matching
        if data.stale_first:
            id_q = query.order_by(asc(StockFeature.updated_at), Stock.id)
        else:
            id_q = query.order_by(Stock.id)
        id_rows = id_q.offset(data.offset).limit(data.batch_size).with_entities(Stock.id).all()
    else:
        needs_refresh = query.filter(
            (StockFeature.id == None) | (StockFeature.last_close == None)
        ).order_by(Stock.id)
        total_pending = needs_refresh.count()
        id_rows = needs_refresh.limit(data.batch_size).with_entities(Stock.id).all()

    stock_ids = [int(r[0]) for r in id_rows]

    enriched = 0
    failed = 0
    details: list = []
    workers = min(max(int(data.max_workers), 1), 8)

    if workers > 1 and len(stock_ids) > 1:
        with ThreadPoolExecutor(max_workers=workers) as ex:
            for d in ex.map(_enrich_single_stock_thread, stock_ids):
                details.append(d)
                if d.get("status") == "ok":
                    enriched += 1
                else:
                    failed += 1
    else:
        for stock_id in stock_ids:
            d = _enrich_single_stock_thread(stock_id)
            details.append(d)
            if d.get("status") == "ok":
                enriched += 1
            else:
                failed += 1
            if data.batch_size <= 25:
                time.sleep(0.2)
            elif data.batch_size <= 100:
                time.sleep(0.05)
            else:
                time.sleep(0.02)

    if data.force:
        remaining = total_matching - data.offset - len(stock_ids)
    else:
        remaining = total_pending - enriched
    return {
        "total_matching": total_matching,
        "total_pending": max(remaining, 0),
        "enriched": enriched,
        "failed": failed,
        "done": remaining <= 0,
        "details": details,
    }
