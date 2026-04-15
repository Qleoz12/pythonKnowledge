from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import or_, and_
from sqlalchemy.exc import IntegrityError, OperationalError
from typing import Optional, Any
from pydantic import BaseModel, Field
from datetime import date, datetime, timedelta
import math
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from database import get_db
from models import (
    Stock,
    StockFeature,
    Exchange,
    DividendEvent,
    DividendForwardEvent,
    ManualCalendarDividend,
    DividendCalendarNote,
    QuanfuryDividend,
    PortfolioHolding,
)

router = APIRouter(prefix="/api/dividends", tags=["dividends"])


def _finite_float(x: Any) -> Optional[float]:
    """JSON-safe optional float (no NaN/inf)."""
    if x is None:
        return None
    try:
        v = float(x)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(v):
        return None
    return v


def _finite_amount(x: Any) -> float:
    """Dividend amount must be a number; corrupt DB values become 0."""
    v = _finite_float(x)
    return v if v is not None else 0.0


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
    prior_year_div_date: Optional[str] = None
    projection_source: Optional[str] = None
    manual_entry_id: Optional[int] = None


class CalendarNoteOut(BaseModel):
    id: int
    note_date: str
    body: str
    created_at: str

    class Config:
        from_attributes = True


class CalendarNoteCreate(BaseModel):
    note_date: str
    body: str = Field(..., min_length=1, max_length=8000)


class ManualDividendCreate(BaseModel):
    div_date: str
    ticker_yf: str = Field(..., min_length=1, max_length=32)
    amount: float = Field(..., gt=0)
    currency: str = Field(default="USD", max_length=10)
    company_name: Optional[str] = Field(default=None, max_length=255)
    note: Optional[str] = Field(default=None, max_length=2000)


def _resolve_stock_for_ticker(db: Session, ticker_yf: str) -> Optional[Stock]:
    t = ticker_yf.strip()
    if not t:
        return None
    st = db.query(Stock).filter(Stock.ticker_yf.ilike(t)).first()
    if st:
        return st
    root = t.split(".")[0].split("-")[0]
    if root and root.upper() != t.upper():
        st = db.query(Stock).filter(Stock.ticker_yf.ilike(root)).first()
        if st:
            return st
    return db.query(Stock).filter(Stock.symbol.ilike(root or t)).first()


class RefreshForwardRequest(BaseModel):
    """Same window as the calendar (typically three months)."""

    start_date: str
    end_date: str
    weeks_ahead: int = 5
    max_stocks: int = 200


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
            amount=_finite_amount(div_ev.div_amount), source="historical", exchange_code=exc.code if exc else None,
            currency=stock.currency,
            last_close=_finite_float(feat.last_close) if feat else None,
            div_yield_ttm=_finite_float(feat.div_yield_ttm) if feat else None,
            is_quanfury=stock.is_quanfury_available, in_portfolio=in_pf,
            portfolio_names=portfolio_names_map.get(stock.id, []),
            prior_year_div_date=None,
            projection_source=None,
            manual_entry_id=None,
        ))

    fwd_query = (
        db.query(DividendForwardEvent, Stock, Exchange, StockFeature)
        .join(Stock, DividendForwardEvent.stock_id == Stock.id)
        .outerjoin(Exchange, Stock.exchange_id == Exchange.id)
        .outerjoin(StockFeature, Stock.id == StockFeature.stock_id)
        .filter(DividendForwardEvent.div_date.between(start_dt, end_dt))
    )
    if exchange:
        fwd_query = fwd_query.filter(Exchange.code.in_([c.strip().upper() for c in exchange.split(",")]))
    if quanfury_only:
        fwd_query = fwd_query.filter(Stock.is_quanfury_available == True)

    for fwd, stock, exc, feat in fwd_query.all():
        in_pf = stock.id in portfolio_stock_ids if portfolio_id else False
        results.append(DividendCalendarItem(
            stock_id=stock.id,
            date=str(fwd.div_date),
            ticker=stock.ticker_yf,
            company_name=stock.company_name,
            amount=_finite_amount(fwd.div_amount),
            source="yahoo_forward",
            exchange_code=exc.code if exc else None,
            currency=stock.currency,
            last_close=_finite_float(feat.last_close) if feat else None,
            div_yield_ttm=_finite_float(feat.div_yield_ttm) if feat else None,
            is_quanfury=stock.is_quanfury_available,
            in_portfolio=in_pf,
            portfolio_names=portfolio_names_map.get(stock.id, []),
            prior_year_div_date=str(fwd.prior_year_div_date) if fwd.prior_year_div_date else None,
            projection_source=fwd.projection_source,
            manual_entry_id=None,
        ))

    man_q = (
        db.query(ManualCalendarDividend)
        .filter(ManualCalendarDividend.div_date.between(start_dt, end_dt))
        .outerjoin(Stock, ManualCalendarDividend.stock_id == Stock.id)
        .outerjoin(Exchange, Stock.exchange_id == Exchange.id)
    )
    man_parts = []
    if exchange:
        codes = [c.strip().upper() for c in exchange.split(",")]
        man_parts.append(or_(ManualCalendarDividend.stock_id.is_(None), Exchange.code.in_(codes)))
    if quanfury_only:
        man_parts.append(Stock.is_quanfury_available == True)
    if man_parts:
        man_q = man_q.filter(and_(*man_parts))

    for man in man_q.all():
        stock = None
        if man.stock_id:
            stock = db.query(Stock).filter_by(id=man.stock_id).first()
        if not stock:
            stock = _resolve_stock_for_ticker(db, man.ticker_yf)
        exc = None
        feat = None
        in_pf = False
        pf_names: list[str] = []
        if stock:
            exc = stock.exchange_rel
            feat = db.query(StockFeature).filter_by(stock_id=stock.id).first()
            if portfolio_id:
                in_pf = stock.id in portfolio_stock_ids
                pf_names = portfolio_names_map.get(stock.id, [])
        cname = (man.company_name or "").strip() or (stock.company_name if stock else man.ticker_yf)
        results.append(DividendCalendarItem(
            stock_id=stock.id if stock else None,
            date=str(man.div_date),
            ticker=man.ticker_yf,
            company_name=cname,
            amount=_finite_amount(man.div_amount),
            source="manual",
            exchange_code=exc.code if exc else None,
            currency=man.currency or "USD",
            last_close=_finite_float(feat.last_close) if feat else None,
            div_yield_ttm=_finite_float(feat.div_yield_ttm) if feat else None,
            is_quanfury=stock.is_quanfury_available if stock else False,
            in_portfolio=in_pf,
            portfolio_names=pf_names,
            prior_year_div_date=None,
            projection_source=None,
            manual_entry_id=man.id,
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
            amount=_finite_amount(qd.amount), source="quanfury", currency=qd.currency,
            last_close=_finite_float(qf_feat.last_close) if qf_feat else None,
            div_yield_ttm=_finite_float(qf_feat.div_yield_ttm) if qf_feat else None,
            is_quanfury=True, in_portfolio=in_pf, portfolio_names=pf_names,
            prior_year_div_date=None,
            projection_source=None,
            manual_entry_id=None,
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
        "total_forward_dividend_rows": db.query(DividendForwardEvent).count(),
        "total_manual_calendar_rows": db.query(ManualCalendarDividend).count(),
        "total_calendar_notes": db.query(DividendCalendarNote).count(),
        "stocks_paying_dividends": db.query(Stock).join(StockFeature).filter(StockFeature.dividend_ttm > 0).count(),
    }


@router.get("/calendar-notes", response_model=list[CalendarNoteOut])
def list_calendar_notes(
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None),
    db: Session = Depends(get_db),
):
    start_dt = _parse_date_param(start_date, date.today() - timedelta(days=365))
    end_dt = _parse_date_param(end_date, date.today() + timedelta(days=365))
    if end_dt < start_dt:
        start_dt, end_dt = end_dt, start_dt
    rows = (
        db.query(DividendCalendarNote)
        .filter(DividendCalendarNote.note_date.between(start_dt, end_dt))
        .order_by(DividendCalendarNote.note_date, DividendCalendarNote.id)
        .all()
    )
    out: list[CalendarNoteOut] = []
    for r in rows:
        out.append(
            CalendarNoteOut(
                id=r.id,
                note_date=str(r.note_date),
                body=r.body or "",
                created_at=r.created_at.isoformat() if r.created_at else "",
            )
        )
    return out


@router.post("/calendar-notes", response_model=CalendarNoteOut)
def create_calendar_note(body: CalendarNoteCreate, db: Session = Depends(get_db)):
    nd = _parse_date_param(body.note_date, date.today())
    text = (body.body or "").strip()
    if not text:
        raise HTTPException(status_code=400, detail="El texto de la nota no puede estar vacío.")
    row = DividendCalendarNote(note_date=nd, body=text)
    db.add(row)
    db.commit()
    db.refresh(row)
    return CalendarNoteOut(
        id=row.id,
        note_date=str(row.note_date),
        body=row.body or "",
        created_at=row.created_at.isoformat() if row.created_at else "",
    )


@router.delete("/calendar-notes/{note_id}")
def delete_calendar_note(note_id: int, db: Session = Depends(get_db)):
    row = db.query(DividendCalendarNote).filter_by(id=note_id).first()
    if not row:
        raise HTTPException(status_code=404, detail="Nota no encontrada")
    db.delete(row)
    db.commit()
    return {"ok": True}


def _create_manual_calendar_dividend_impl(body: ManualDividendCreate, db: Session) -> dict:
    div_dt = _parse_date_param(body.div_date, date.today())
    ticker = body.ticker_yf.strip().upper()
    if not ticker:
        raise HTTPException(status_code=400, detail="ticker_yf required")
    stock = _resolve_stock_for_ticker(db, ticker)
    if stock and stock.ticker_yf.upper() != ticker.upper():
        ticker = stock.ticker_yf
    cname = (body.company_name or "").strip()
    if not cname and stock:
        cname = stock.company_name or ""
    note = (body.note or "").strip() if body.note else ""
    row = ManualCalendarDividend(
        div_date=div_dt,
        ticker_yf=ticker,
        div_amount=_finite_amount(body.amount),
        currency=(body.currency or "USD").strip()[:10] or "USD",
        company_name=cname,
        stock_id=stock.id if stock else None,
        note=note,
    )
    db.add(row)
    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Ya existe una fila manual para esa fecha y ese ticker. Bórrala o edítala desde el calendario.",
        )
    except OperationalError as e:
        db.rollback()
        msg = str(e.orig) if getattr(e, "orig", None) else str(e)
        if "no such table" in msg.lower():
            raise HTTPException(
                status_code=503,
                detail="Falta la tabla manual_calendar_dividends. Detén y vuelve a arrancar el backend para que se cree con create_all.",
            ) from e
        raise HTTPException(
            status_code=503,
            detail=f"Error de base de datos al guardar: {msg}",
        ) from e
    db.refresh(row)
    return {"ok": True, "id": row.id}


@router.post("/calendar/manual", response_model=dict)
def create_manual_calendar_dividend_v2(body: ManualDividendCreate, db: Session = Depends(get_db)):
    """Guardar dividendo manual por día (no requiere que el ticker exista en stocks)."""
    return _create_manual_calendar_dividend_impl(body, db)


@router.post("/manual", response_model=dict, include_in_schema=False)
def create_manual_calendar_dividend_legacy(body: ManualDividendCreate, db: Session = Depends(get_db)):
    """Alias antiguo por si un cliente aún llama /manual."""
    return _create_manual_calendar_dividend_impl(body, db)


@router.delete("/calendar/manual/{entry_id}")
def delete_manual_calendar_dividend_v2(entry_id: int, db: Session = Depends(get_db)):
    row = db.query(ManualCalendarDividend).filter_by(id=entry_id).first()
    if not row:
        raise HTTPException(status_code=404, detail="Manual entry not found")
    db.delete(row)
    db.commit()
    return {"ok": True}


@router.delete("/manual/{entry_id}", include_in_schema=False)
def delete_manual_calendar_dividend_legacy(entry_id: int, db: Session = Depends(get_db)):
    return delete_manual_calendar_dividend_v2(entry_id, db)


@router.post("/refresh-forward")
def refresh_forward_dividends(body: RefreshForwardRequest, db: Session = Depends(get_db)):
    """
    Rebuild forward dividend rows for stocks that paid in the DB during the
    prior-year equivalent of [start_date, end_date]. Projects +1y dates and
    optionally confirms near-term dates with Yahoo Finance (see service docstring).
    """
    from services.dividend_forward_refresh import refresh_forward_dividends as run_refresh

    start_dt = _parse_date_param(body.start_date, date.today())
    end_dt = _parse_date_param(body.end_date, date.today() + timedelta(days=90))
    if end_dt < start_dt:
        return {"ok": False, "error": "end_date before start_date"}

    weeks = max(1, min(body.weeks_ahead, 26))
    cap = max(1, min(body.max_stocks, 500))
    summary = run_refresh(db, start_dt, end_dt, weeks_ahead=weeks, max_stocks=cap)
    summary["ok"] = True
    return summary
