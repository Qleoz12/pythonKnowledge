from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import Optional
from pydantic import BaseModel
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from database import get_db
from models import Stock, StockFeature, Exchange

router = APIRouter(prefix="/api/analytics", tags=["analytics"])


class WeekProximityItem(BaseModel):
    id: int
    ticker_yf: str
    company_name: str
    exchange_code: Optional[str] = None
    sector: str
    currency: str
    last_close: Optional[float] = None
    is_quanfury: bool = False
    week_52_high: Optional[float] = None
    week_52_low: Optional[float] = None
    week_52_pct: Optional[float] = None
    near_52w_high: bool = False
    near_52w_low: bool = False
    week_100_high: Optional[float] = None
    week_100_low: Optional[float] = None
    week_100_pct: Optional[float] = None
    week_200_high: Optional[float] = None
    week_200_low: Optional[float] = None
    week_200_pct: Optional[float] = None
    div_yield_ttm: Optional[float] = None
    rsi_14: Optional[float] = None

class DashboardStats(BaseModel):
    total_stocks: int
    stocks_by_exchange: dict
    stocks_with_dividends: int
    quanfury_available: int
    avg_div_yield: Optional[float] = None
    near_52w_high_count: int = 0
    near_52w_low_count: int = 0


def _pct(price, high, low):
    if not price or not high or not low or high == low:
        return None
    return round((price - low) / (high - low) * 100, 2)


@router.get("/week-proximity", response_model=list[WeekProximityItem])
def week_proximity(
    period: str = Query("52"), direction: str = Query("low"), threshold: float = Query(10.0),
    filter_mode: str = Query("distance", description="'distance' = % from low/high, 'range' = position within range"),
    exchange: Optional[str] = Query(None), quanfury_only: bool = Query(False),
    min_div_yield: Optional[float] = Query(None), limit: int = Query(100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    q = db.query(Stock, StockFeature, Exchange).join(StockFeature, Stock.id == StockFeature.stock_id).outerjoin(Exchange, Stock.exchange_id == Exchange.id).filter(StockFeature.last_close.isnot(None))
    if exchange:
        q = q.filter(Exchange.code.in_([c.strip().upper() for c in exchange.split(",")]))
    if quanfury_only:
        q = q.filter(Stock.is_quanfury_available == True)
    if min_div_yield:
        q = q.filter(StockFeature.div_yield_ttm >= min_div_yield)

    hc = {"52": StockFeature.week_52_high, "100": StockFeature.week_100_high, "200": StockFeature.week_200_high}
    lc = {"52": StockFeature.week_52_low, "100": StockFeature.week_100_low, "200": StockFeature.week_200_low}
    h, l = hc.get(period, StockFeature.week_52_high), lc.get(period, StockFeature.week_52_low)

    q = q.filter(h.isnot(None), l.isnot(None), h != l)

    if filter_mode == "range":
        range_expr = (StockFeature.last_close - l) / (h - l) * 100
        if direction == "high":
            q = q.filter(range_expr >= (100 - threshold)).order_by(range_expr.desc())
        else:
            q = q.filter(range_expr <= threshold).order_by(range_expr.asc())
    else:
        if direction == "high":
            q = q.filter(StockFeature.last_close >= h * (1 - threshold / 100)).order_by(StockFeature.last_close.desc())
        else:
            q = q.filter(StockFeature.last_close <= l * (1 + threshold / 100)).order_by(StockFeature.last_close.asc())

    return [WeekProximityItem(
        id=s.id, ticker_yf=s.ticker_yf, company_name=s.company_name, exchange_code=e.code if e else None,
        sector=s.sector, currency=s.currency, last_close=f.last_close, is_quanfury=s.is_quanfury_available,
        week_52_high=f.week_52_high, week_52_low=f.week_52_low, week_52_pct=_pct(f.last_close, f.week_52_high, f.week_52_low),
        near_52w_high=bool(f.week_52_high and f.last_close and f.last_close >= f.week_52_high * 0.90),
        near_52w_low=bool(f.week_52_low and f.last_close and f.last_close <= f.week_52_low * 1.10),
        week_100_high=f.week_100_high, week_100_low=f.week_100_low, week_100_pct=_pct(f.last_close, f.week_100_high, f.week_100_low),
        week_200_high=f.week_200_high, week_200_low=f.week_200_low, week_200_pct=_pct(f.last_close, f.week_200_high, f.week_200_low),
        div_yield_ttm=f.div_yield_ttm, rsi_14=f.rsi_14,
    ) for s, f, e in q.limit(limit).all()]


@router.get("/dashboard", response_model=DashboardStats)
def dashboard_stats(db: Session = Depends(get_db)):
    total = db.query(Stock).count()
    by_exc = {e.code: db.query(Stock).filter_by(exchange_id=e.id).count() for e in db.query(Exchange).all()}
    with_divs = db.query(Stock).join(StockFeature).filter(StockFeature.dividend_ttm.isnot(None), StockFeature.dividend_ttm > 0).count()
    qf = db.query(Stock).filter(Stock.is_quanfury_available == True).count()
    avg_y = db.query(func.avg(StockFeature.div_yield_ttm)).filter(StockFeature.div_yield_ttm.isnot(None), StockFeature.div_yield_ttm > 0).scalar()
    nh = db.query(Stock).join(StockFeature).filter(StockFeature.last_close.isnot(None), StockFeature.week_52_high.isnot(None), StockFeature.last_close >= StockFeature.week_52_high * 0.90).count()
    nl = db.query(Stock).join(StockFeature).filter(StockFeature.last_close.isnot(None), StockFeature.week_52_low.isnot(None), StockFeature.last_close <= StockFeature.week_52_low * 1.10).count()
    return DashboardStats(total_stocks=total, stocks_by_exchange=by_exc, stocks_with_dividends=with_divs,
                           quanfury_available=qf, avg_div_yield=round(avg_y, 2) if avg_y else None,
                           near_52w_high_count=nh, near_52w_low_count=nl)


@router.get("/top-dividend-yields")
def top_dividend_yields(exchange: Optional[str] = Query(None), quanfury_only: bool = Query(False),
                         limit: int = Query(50, ge=1, le=200), db: Session = Depends(get_db)):
    q = db.query(Stock, StockFeature, Exchange).join(StockFeature, Stock.id == StockFeature.stock_id).outerjoin(Exchange, Stock.exchange_id == Exchange.id).filter(StockFeature.div_yield_ttm.isnot(None), StockFeature.div_yield_ttm > 0)
    if exchange:
        q = q.filter(Exchange.code.in_([c.strip().upper() for c in exchange.split(",")]))
    if quanfury_only:
        q = q.filter(Stock.is_quanfury_available == True)
    q = q.order_by(StockFeature.div_yield_ttm.desc()).limit(limit)
    return [{"ticker_yf": s.ticker_yf, "company_name": s.company_name, "exchange_code": e.code if e else None,
             "sector": s.sector, "last_close": f.last_close, "div_yield_ttm": f.div_yield_ttm,
             "dividend_ttm": f.dividend_ttm, "payments_ttm": f.payments_ttm, "div_freq": f.div_freq,
             "rsi_14": f.rsi_14, "is_quanfury": s.is_quanfury_available} for s, f, e in q.all()]
