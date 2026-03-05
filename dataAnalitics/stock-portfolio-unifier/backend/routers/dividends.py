from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import Optional
from pydantic import BaseModel
from datetime import date, datetime, timedelta
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from database import get_db
from models import Stock, StockFeature, Exchange, DividendEvent, QuanfuryDividend, PortfolioHolding

router = APIRouter(prefix="/api/dividends", tags=["dividends"])


class DividendCalendarItem(BaseModel):
    stock_id: Optional[int] = None
    date: str
    ticker: str
    company_name: str
    amount: float
    source: str
    exchange_code: Optional[str] = None
    currency: Optional[str] = None
    last_close: Optional[float] = None
    div_yield_ttm: Optional[float] = None
    is_quanfury: bool = False
    in_portfolio: bool = False
    portfolio_names: list[str] = []


def _parse_date_param(val: Optional[str], default: date) -> date:
    if not val:
        return default
    try:
        return datetime.strptime(val.strip()[:10], "%Y-%m-%d").date()
    except (ValueError, TypeError):
        return default


@router.get("/calendar", response_model=list[DividendCalendarItem])
def dividend_calendar(
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None),
    exchange: Optional[str] = Query(None),
    portfolio_id: Optional[int] = Query(None),
    quanfury_only: bool = Query(False),
    db: Session = Depends(get_db),
):
    start_dt = _parse_date_param(start_date, date.today() - timedelta(days=30))
    end_dt = _parse_date_param(end_date, date.today() + timedelta(days=90))

    portfolio_stock_ids = set()
    portfolio_names_map: dict[int, list[str]] = {}
    if portfolio_id:
        from models import Portfolio
        for h in db.query(PortfolioHolding).filter_by(portfolio_id=portfolio_id).all():
            portfolio_stock_ids.add(h.stock_id)
            p = db.query(Portfolio).filter_by(id=h.portfolio_id).first()
            if p:
                portfolio_names_map.setdefault(h.stock_id, []).append(p.name)

    results = []
    div_query = (
        db.query(DividendEvent, Stock, Exchange, StockFeature)
        .join(Stock, DividendEvent.stock_id == Stock.id)
        .outerjoin(Exchange, Stock.exchange_id == Exchange.id)
        .outerjoin(StockFeature, Stock.id == StockFeature.stock_id)
        .filter(DividendEvent.div_date.between(start_dt, end_dt))
    )
    if exchange:
        div_query = div_query.filter(Exchange.code.in_([c.strip().upper() for c in exchange.split(",")]))
    if quanfury_only:
        div_query = div_query.filter(Stock.is_quanfury_available == True)

    for div_ev, stock, exc, feat in div_query.all():
        in_pf = stock.id in portfolio_stock_ids if portfolio_id else False
        results.append(DividendCalendarItem(
            stock_id=stock.id,
            date=str(div_ev.div_date), ticker=stock.ticker_yf, company_name=stock.company_name,
            amount=div_ev.div_amount, source="historical", exchange_code=exc.code if exc else None,
            currency=stock.currency,
            last_close=feat.last_close if feat else None,
            div_yield_ttm=feat.div_yield_ttm if feat else None,
            is_quanfury=stock.is_quanfury_available, in_portfolio=in_pf,
            portfolio_names=portfolio_names_map.get(stock.id, []),
        ))

    for qd in db.query(QuanfuryDividend).filter(QuanfuryDividend.div_date.between(start_dt, end_dt)).all():
        qf_stock = db.query(Stock).filter(Stock.symbol == qd.short_name).first()
        qf_feat = None
        qf_stock_id = None
        in_pf = False
        pf_names: list[str] = []
        if qf_stock:
            qf_stock_id = qf_stock.id
            qf_feat = db.query(StockFeature).filter_by(stock_id=qf_stock.id).first()
            if portfolio_id:
                in_pf = qf_stock.id in portfolio_stock_ids
                pf_names = portfolio_names_map.get(qf_stock.id, [])
        results.append(DividendCalendarItem(
            stock_id=qf_stock_id,
            date=str(qd.div_date), ticker=qd.short_name,
            company_name=qf_stock.company_name if qf_stock else qd.short_name,
            amount=qd.amount, source="quanfury", currency=qd.currency,
            last_close=qf_feat.last_close if qf_feat else None,
            div_yield_ttm=qf_feat.div_yield_ttm if qf_feat else None,
            is_quanfury=True, in_portfolio=in_pf, portfolio_names=pf_names,
        ))

    results.sort(key=lambda x: x.date)
    return results


@router.get("/upcoming")
def upcoming_dividends(
    days: int = Query(30), exchange: Optional[str] = Query(None),
    quanfury_only: bool = Query(False), db: Session = Depends(get_db),
):
    query = db.query(Stock, StockFeature, Exchange).outerjoin(StockFeature, Stock.id == StockFeature.stock_id).outerjoin(Exchange, Stock.exchange_id == Exchange.id).filter(StockFeature.dividend_ttm.isnot(None), StockFeature.dividend_ttm > 0)
    if exchange:
        query = query.filter(Exchange.code.in_([c.strip().upper() for c in exchange.split(",")]))
    if quanfury_only:
        query = query.filter(Stock.is_quanfury_available == True)
    query = query.order_by(StockFeature.div_yield_ttm.desc())

    return [{"ticker": s.ticker_yf, "company_name": s.company_name, "last_div_date": f.last_div_date if f else None,
             "div_yield_ttm": f.div_yield_ttm if f else None, "div_freq": f.div_freq if f else None,
             "dividend_ttm": f.dividend_ttm if f else None, "exchange_code": e.code if e else None,
             "is_quanfury": s.is_quanfury_available} for s, f, e in query.limit(200).all()]


@router.get("/stats")
def dividend_stats(db: Session = Depends(get_db)):
    return {
        "total_dividend_events": db.query(DividendEvent).count(),
        "total_quanfury_dividends": db.query(QuanfuryDividend).count(),
        "stocks_paying_dividends": db.query(Stock).join(StockFeature).filter(StockFeature.dividend_ttm > 0).count(),
    }
