from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import or_
from typing import Optional
from pydantic import BaseModel
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from database import get_db
from models import Stock, StockFeature, Exchange, DividendEvent

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
    dividend_history: list = []
    portfolios: list = []


class PaginatedStocks(BaseModel):
    items: list[StockOut]
    total: int
    page: int
    page_size: int
    pages: int


def compute_week_pct(price, high, low):
    if not price or not high or not low or high == low:
        return None
    return round((price - low) / (high - low) * 100, 2)


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
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=500),
    db: Session = Depends(get_db),
):
    query = (
        db.query(Stock)
        .options(joinedload(Stock.features), joinedload(Stock.exchange_rel))
        .outerjoin(StockFeature)
        .outerjoin(Exchange)
    )
    if exchange:
        codes = [c.strip().upper() for c in exchange.split(",")]
        query = query.filter(Exchange.code.in_(codes))
    if sector:
        query = query.filter(Stock.sector.ilike(f"%{sector}%"))
    if quanfury_only:
        query = query.filter(Stock.is_quanfury_available == True)
    if search:
        term = f"%{search}%"
        query = query.filter(or_(Stock.ticker_yf.ilike(term), Stock.company_name.ilike(term), Stock.symbol.ilike(term)))
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

    sort_map = {
        "ticker_yf": Stock.ticker_yf, "company_name": Stock.company_name,
        "sector": Stock.sector, "market_cap": Stock.market_cap,
        "last_close": StockFeature.last_close, "div_yield_ttm": StockFeature.div_yield_ttm,
        "rsi_14": StockFeature.rsi_14, "dividend_ttm": StockFeature.dividend_ttm,
        "max_drawdown": StockFeature.max_drawdown,
    }
    sort_col = sort_map.get(sort_by, Stock.ticker_yf)
    if order == "desc":
        sort_col = sort_col.desc()

    total = query.count()
    stocks = query.order_by(sort_col).offset((page - 1) * page_size).limit(page_size).all()

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

        end = datetime.now()
        start = end - timedelta(weeks=200)
        hist = yf.download(ticker_yf, start=start, end=end, progress=False, timeout=15)
        if hist is not None and not hist.empty:
            close = hist["Close"].dropna()
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
        print(f"[WARN] yfinance enrich failed for {ticker_yf}: {e}")

    return info


@router.post("", status_code=201)
def create_stock(data: StockCreate, db: Session = Depends(get_db)):
    """Add a new stock by ticker. Optionally enrich from yfinance and add to a portfolio."""
    ticker = data.ticker.strip().upper()
    symbol = ticker.split(".")[0]

    existing = db.query(Stock).filter(
        or_(Stock.ticker_yf == ticker, Stock.symbol == symbol)
    ).first()

    if existing:
        stock = existing
        if data.enrich and not existing.features:
            yf_data = _enrich_from_yfinance(existing.ticker_yf)
            feat = StockFeature(stock_id=existing.id)
            for k in ["last_close", "dividend_ttm", "div_yield_ttm",
                       "week_52_high", "week_52_low", "week_100_high",
                       "week_100_low", "week_200_high", "week_200_low"]:
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
            for k in ["last_close", "dividend_ttm", "div_yield_ttm",
                       "week_52_high", "week_52_low", "week_100_high",
                       "week_100_low", "week_200_high", "week_200_low"]:
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
             "with_dividends": int(r[4] or 0)} for r in rows]


@router.get("/search")
def search_stocks(q: str = Query(...), limit: int = 20, db: Session = Depends(get_db)):
    term = f"%{q}%"
    stocks = db.query(Stock).outerjoin(Exchange).filter(
        or_(Stock.symbol.ilike(term), Stock.company_name.ilike(term), Stock.ticker_yf.ilike(term))
    ).limit(limit).all()
    return [{"id": s.id, "ticker_yf": s.ticker_yf, "symbol": s.symbol,
             "company_name": s.company_name, "exchange_code": s.exchange_rel.code if s.exchange_rel else None} for s in stocks]


@router.get("/by-ticker/{ticker_yf:path}")
def get_stock_by_ticker(ticker_yf: str, db: Session = Depends(get_db)):
    """Find stock ID by ticker_yf (used to navigate from dividend calendar)."""
    stock = db.query(Stock).filter(Stock.ticker_yf == ticker_yf).first()
    if not stock:
        stock = db.query(Stock).filter(Stock.symbol == ticker_yf).first()
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
        hist = yf.download(ticker_yf, start=start, end=end, progress=False, timeout=15)

        if hist is not None and not hist.empty:
            close = hist["Close"].dropna()
            if hasattr(close, 'columns'):
                close = close.iloc[:, 0]
            if not close.empty and len(close) >= 2:
                feature.last_close = float(close.iloc[-1])

                n52 = min(252, len(close))
                n100 = min(500, len(close))
                w52, w100, w200 = close.iloc[-n52:], close.iloc[-n100:], close
                feature.week_52_high = float(w52.max())
                feature.week_52_low = float(w52.min())
                feature.week_100_high = float(w100.max())
                feature.week_100_low = float(w100.min())
                feature.week_200_high = float(w200.max())
                feature.week_200_low = float(w200.min())

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

        db.commit()
        print(f"  [REFRESH] {ticker_yf}: price={feature.last_close}, rsi={feature.rsi_14}, macd={feature.macd}, sector={stock.sector}")
    except Exception as e:
        import traceback
        print(f"  [WARN] refresh failed for {ticker_yf}: {e}")
        traceback.print_exc()


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
    sector: Optional[str] = None
    exchange: Optional[str] = None
    search: Optional[str] = None
    quanfury_only: bool = False
    batch_size: int = 10


@router.post("/enrich/filtered")
def enrich_filtered(data: FilteredEnrichRequest, db: Session = Depends(get_db)):
    """Enrich stocks matching filters that have missing price/indicator data."""
    import time

    query = (
        db.query(Stock)
        .outerjoin(StockFeature)
        .outerjoin(Exchange)
    )

    if data.sector:
        query = query.filter(Stock.sector.ilike(f"%{data.sector}%"))
    if data.exchange:
        codes = [c.strip().upper() for c in data.exchange.split(",")]
        query = query.filter(Exchange.code.in_(codes))
    if data.search:
        term = f"%{data.search}%"
        query = query.filter(or_(Stock.ticker_yf.ilike(term), Stock.company_name.ilike(term)))
    if data.quanfury_only:
        query = query.filter(Stock.is_quanfury_available == True)

    total_matching = query.count()
    needs_refresh = query.filter(
        (StockFeature.id == None) | (StockFeature.last_close == None)
    )
    total_pending = needs_refresh.count()
    stocks = needs_refresh.limit(data.batch_size).all()

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
            details.append({"ticker": stock.ticker_yf, "status": "ok", "price": f.last_close})
        except Exception as e:
            failed += 1
            details.append({"ticker": stock.ticker_yf, "status": "error", "error": str(e)})
        time.sleep(0.2)

    remaining = total_pending - enriched
    return {
        "total_matching": total_matching,
        "total_pending": max(remaining, 0),
        "enriched": enriched,
        "failed": failed,
        "done": remaining <= 0,
        "details": details,
    }
