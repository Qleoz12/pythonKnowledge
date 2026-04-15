from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import date, datetime, timedelta
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from database import get_db
from models import Stock, StockOHLCV, FairValueRevision
from services.fair_value import (
    RevisionPoint,
    build_daily_series,
    downsample_weekly,
    downsample_monthly,
    build_annual_table,
)
from routers.charts import _ensure_ohlcv_cache, PERIOD_DAYS
from logger import get_logger

log = get_logger("fair_value")

router = APIRouter(prefix="/api/stocks", tags=["fair-value"])


class FairValueRevisionIn(BaseModel):
    effective_date: date
    fair_value: float = Field(gt=0)
    uncertainty: Optional[str] = None
    source: str = "manual"


class FairValueRevisionBatch(BaseModel):
    revisions: List[FairValueRevisionIn]


class FairValueRevisionOut(BaseModel):
    id: int
    effective_date: date
    fair_value: float
    uncertainty: Optional[str]
    source: str
    created_at: datetime

    class Config:
        from_attributes = True


def _load_revisions(db: Session, stock_id: int, source: Optional[str]) -> List[RevisionPoint]:
    q = db.query(FairValueRevision).filter(FairValueRevision.stock_id == stock_id)
    if source:
        q = q.filter(FairValueRevision.source == source)
    rows = q.order_by(FairValueRevision.effective_date.asc()).all()
    return [
        RevisionPoint(
            effective_date=r.effective_date,
            fair_value=r.fair_value,
            uncertainty=r.uncertainty,
        )
        for r in rows
    ]


def _load_ohlcv_range(db: Session, stock_id: int, days: int) -> List[StockOHLCV]:
    cutoff = date.today() - timedelta(days=days)
    return (
        db.query(StockOHLCV)
        .filter(StockOHLCV.stock_id == stock_id, StockOHLCV.date >= cutoff)
        .order_by(StockOHLCV.date.asc())
        .all()
    )


@router.get("/{stock_id}/fair-value-revisions", response_model=List[FairValueRevisionOut])
def list_fair_value_revisions(
    stock_id: int,
    source: Optional[str] = Query(None),
    db: Session = Depends(get_db),
):
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")
    q = db.query(FairValueRevision).filter(FairValueRevision.stock_id == stock_id)
    if source:
        q = q.filter(FairValueRevision.source == source)
    return q.order_by(FairValueRevision.effective_date.asc()).all()


@router.post("/{stock_id}/fair-value-revisions", response_model=List[FairValueRevisionOut])
def upsert_fair_value_revisions(
    stock_id: int,
    body: FairValueRevisionBatch,
    db: Session = Depends(get_db),
):
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")
    if not body.revisions:
        raise HTTPException(status_code=400, detail="revisions must not be empty")

    out: List[FairValueRevision] = []
    for item in body.revisions:
        src = (item.source or "manual").strip() or "manual"
        existing = (
            db.query(FairValueRevision)
            .filter(
                FairValueRevision.stock_id == stock_id,
                FairValueRevision.effective_date == item.effective_date,
                FairValueRevision.source == src,
            )
            .first()
        )
        if existing:
            existing.fair_value = item.fair_value
            existing.uncertainty = item.uncertainty
            out.append(existing)
        else:
            r = FairValueRevision(
                stock_id=stock_id,
                effective_date=item.effective_date,
                fair_value=item.fair_value,
                uncertainty=item.uncertainty,
                source=src,
            )
            db.add(r)
            out.append(r)
    db.commit()
    for r in out:
        db.refresh(r)
    log.info("FVE upsert stock_id=%s count=%s", stock_id, len(out))
    return sorted(out, key=lambda x: x.effective_date)


@router.delete("/{stock_id}/fair-value-revisions/{revision_id}", status_code=204)
def delete_fair_value_revision(
    stock_id: int,
    revision_id: int,
    db: Session = Depends(get_db),
):
    r = (
        db.query(FairValueRevision)
        .filter(
            FairValueRevision.id == revision_id,
            FairValueRevision.stock_id == stock_id,
        )
        .first()
    )
    if not r:
        raise HTTPException(status_code=404, detail="Revision not found")
    db.delete(r)
    db.commit()


@router.get("/{stock_id}/fair-value-summary")
def fair_value_summary(
    stock_id: int,
    ensure_ohlcv: bool = Query(True, description="Refresh OHLCV cache from Yahoo if stale"),
    source: Optional[str] = Query(None),
    db: Session = Depends(get_db),
):
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")
    if ensure_ohlcv:
        _ensure_ohlcv_cache(stock, db)

    revs_db = (
        db.query(FairValueRevision)
        .filter(FairValueRevision.stock_id == stock_id)
    )
    if source:
        revs_db = revs_db.filter(FairValueRevision.source == source)
    latest = revs_db.order_by(FairValueRevision.effective_date.desc()).first()

    last_row = (
        db.query(StockOHLCV)
        .filter(StockOHLCV.stock_id == stock_id)
        .order_by(StockOHLCV.date.desc())
        .first()
    )
    last_price = float(last_row.close) if last_row and last_row.close else None

    if not latest or last_price is None:
        return {
            "has_fair_value": bool(latest),
            "ticker_yf": stock.ticker_yf,
            "last_price": last_price,
            "fair_value": latest.fair_value if latest else None,
            "price_to_fve": None,
            "uncertainty": latest.uncertainty if latest else None,
            "fair_value_as_of": latest.effective_date.isoformat() if latest else None,
            "fair_value_revision_id": latest.id if latest else None,
        }

    fve, _ = latest.fair_value, latest.uncertainty
    ratio = (last_price / fve) if fve and fve > 0 else None
    return {
        "has_fair_value": True,
        "ticker_yf": stock.ticker_yf,
        "last_price": round(last_price, 6),
        "fair_value": round(fve, 6),
        "price_to_fve": round(ratio, 6) if ratio is not None else None,
        "uncertainty": latest.uncertainty,
        "fair_value_as_of": latest.effective_date.isoformat(),
        "fair_value_revision_id": latest.id,
    }


@router.get("/{stock_id}/fair-value-series")
def fair_value_series(
    stock_id: int,
    granularity: str = Query("daily", description="daily, weekly, or monthly"),
    period: str = Query("5y", description="1m, 3m, 6m, 1y, 2y, 5y"),
    ensure_ohlcv: bool = Query(True),
    source: Optional[str] = Query(None),
    db: Session = Depends(get_db),
):
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")
    if granularity not in ("daily", "weekly", "monthly"):
        raise HTTPException(
            status_code=400, detail="granularity must be daily, weekly, or monthly"
        )

    if ensure_ohlcv:
        _ensure_ohlcv_cache(stock, db)

    days = PERIOD_DAYS.get(period, 1825)
    rows = _load_ohlcv_range(db, stock_id, days)
    revisions_early = _load_revisions(db, stock_id, source)
    has_revisions_any = len(revisions_early) > 0

    if not rows:
        return {
            "ticker_yf": stock.ticker_yf,
            "granularity": granularity,
            "period": period,
            "has_revisions": has_revisions_any,
            "has_fair_value": False,
            "dates": [],
            "close": [],
            "fve": [],
            "uncertainty": [],
            "price_to_fve": [],
            "undervalued": [],
        }

    revisions = revisions_early
    dates: List[date] = []
    closes: List[float] = []
    for r in rows:
        if r.close is None:
            continue
        dates.append(r.date)
        closes.append(float(r.close))

    ds, dc, df, du, dr, dunder = build_daily_series(dates, closes, revisions)
    has_fve = any(v is not None for v in df)
    has_revisions = has_revisions_any

    if granularity in ("weekly", "monthly"):
        d_obj = [date.fromisoformat(x) for x in ds]
        if granularity == "weekly":
            ds, dc, df, du, dr, dunder = downsample_weekly(d_obj, dc, df, du, dr, dunder)
        else:
            ds, dc, df, du, dr, dunder = downsample_monthly(d_obj, dc, df, du, dr, dunder)

    return {
        "ticker_yf": stock.ticker_yf,
        "granularity": granularity,
        "period": period,
        "has_revisions": has_revisions,
        "has_fair_value": has_fve,
        "dates": ds,
        "close": dc,
        "fve": df,
        "uncertainty": du,
        "price_to_fve": dr,
        "undervalued": dunder,
    }


@router.get("/{stock_id}/fair-value-annual-table")
def fair_value_annual_table(
    stock_id: int,
    year_from: int = Query(2018, ge=1990, le=2100),
    year_to: Optional[int] = Query(None, description="Inclusive end year; default current year"),
    ensure_ohlcv: bool = Query(True),
    source: Optional[str] = Query(None),
    annual_fve_basis: str = Query(
        "constant_latest",
        description="constant_latest: fill missing years with latest FVE; strict: only stepped FVE",
    ),
    db: Session = Depends(get_db),
):
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")
    y_end = year_to if year_to is not None else date.today().year
    if y_end < year_from:
        raise HTTPException(status_code=400, detail="year_to must be >= year_from")
    if annual_fve_basis not in ("strict", "constant_latest"):
        raise HTTPException(
            status_code=400,
            detail="annual_fve_basis must be strict or constant_latest",
        )

    if ensure_ohlcv:
        _ensure_ohlcv_cache(stock, db)

    today = date.today()
    start = date(year_from, 1, 1)
    rows = (
        db.query(StockOHLCV)
        .filter(StockOHLCV.stock_id == stock_id, StockOHLCV.date >= start, StockOHLCV.date <= today)
        .order_by(StockOHLCV.date.asc())
        .all()
    )
    revisions = _load_revisions(db, stock_id, source)
    dates: List[date] = []
    closes: List[float] = []
    for r in rows:
        if r.close is None:
            continue
        dates.append(r.date)
        closes.append(float(r.close))

    return {
        "ticker_yf": stock.ticker_yf,
        "annual_fve_basis": annual_fve_basis,
        "rows": build_annual_table(
            dates, closes, revisions, year_from, y_end, annual_fve_basis=annual_fve_basis
        ),
    }
