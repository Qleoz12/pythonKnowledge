from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Optional
from pydantic import BaseModel
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from database import get_db
from models import Portfolio, PortfolioHolding, PortfolioSnapshot, Stock, StockFeature

router = APIRouter(prefix="/api/portfolios", tags=["portfolios"])


class PortfolioCreate(BaseModel):
    name: str
    broker: str = ""
    description: str = ""

class PortfolioUpdate(BaseModel):
    name: Optional[str] = None
    broker: Optional[str] = None
    description: Optional[str] = None

class HoldingCreate(BaseModel):
    stock_id: int
    shares: float
    avg_price: float = 0

class HoldingUpdate(BaseModel):
    shares: Optional[float] = None
    avg_price: Optional[float] = None

class SnapshotCreate(BaseModel):
    month: int
    year: int
    total_value: float = 0
    total_dividends: float = 0
    notes: str = ""

class HoldingOut(BaseModel):
    id: int
    stock_id: int
    ticker_yf: str
    company_name: str
    symbol: str
    shares: float
    avg_price: float
    current_price: Optional[float] = None
    current_value: Optional[float] = None
    gain_pct: Optional[float] = None
    div_yield_ttm: Optional[float] = None
    annual_dividend: Optional[float] = None
    is_quanfury: bool = False

class PortfolioOut(BaseModel):
    id: int
    name: str
    broker: str
    description: str
    created_at: str
    total_value: Optional[float] = None
    total_cost: Optional[float] = None
    total_gain_pct: Optional[float] = None
    estimated_annual_dividends: Optional[float] = None
    avg_yield: Optional[float] = None
    holdings_count: int = 0

class PortfolioDetailOut(PortfolioOut):
    holdings: list[HoldingOut] = []
    snapshots: list[dict] = []


def _stats(db: Session, pid: int) -> dict:
    holdings = db.query(PortfolioHolding).filter_by(portfolio_id=pid).all()
    tv, tc, td, cnt = 0.0, 0.0, 0.0, 0
    for h in holdings:
        feat = db.query(StockFeature).filter_by(stock_id=h.stock_id).first()
        p = feat.last_close if feat else None
        if p and h.shares:
            tv += p * h.shares
            tc += (h.avg_price or 0) * h.shares
            td += (feat.dividend_ttm or 0) * h.shares if feat else 0
        cnt += 1
    gp = ((tv - tc) / tc * 100) if tc > 0 else None
    ay = (td / tv * 100) if tv > 0 else None
    return {"holdings_count": cnt, "total_value": round(tv, 2) or None, "total_cost": round(tc, 2) or None,
            "total_gain_pct": round(gp, 2) if gp is not None else None,
            "estimated_annual_dividends": round(td, 2) or None, "avg_yield": round(ay, 2) if ay is not None else None}


@router.get("", response_model=list[PortfolioOut])
def list_portfolios(db: Session = Depends(get_db)):
    results = []
    for p in db.query(Portfolio).order_by(Portfolio.created_at.desc()).all():
        s = _stats(db, p.id)
        results.append(PortfolioOut(id=p.id, name=p.name, broker=p.broker or "", description=p.description or "",
                                     created_at=str(p.created_at), **s))
    return results


@router.post("", response_model=PortfolioOut)
def create_portfolio(data: PortfolioCreate, db: Session = Depends(get_db)):
    p = Portfolio(name=data.name, broker=data.broker, description=data.description)
    db.add(p)
    db.commit()
    db.refresh(p)
    return PortfolioOut(id=p.id, name=p.name, broker=p.broker or "", description=p.description or "", created_at=str(p.created_at))


@router.get("/{pid}", response_model=PortfolioDetailOut)
def get_portfolio(pid: int, db: Session = Depends(get_db)):
    portfolio = db.query(Portfolio).filter_by(id=pid).first()
    if not portfolio:
        raise HTTPException(status_code=404, detail="Portfolio not found")

    holdings_out = []
    for h in db.query(PortfolioHolding).filter_by(portfolio_id=pid).all():
        stock = db.query(Stock).filter_by(id=h.stock_id).first()
        feat = db.query(StockFeature).filter_by(stock_id=h.stock_id).first()
        if not stock:
            continue
        cp = feat.last_close if feat else None
        cv = cp * h.shares if cp and h.shares else None
        cost = h.avg_price * h.shares if h.avg_price and h.shares else None
        gp = ((cv - cost) / cost * 100) if cv and cost and cost > 0 else None
        ad = (feat.dividend_ttm or 0) * h.shares if feat else None
        holdings_out.append(HoldingOut(
            id=h.id, stock_id=h.stock_id, ticker_yf=stock.ticker_yf, company_name=stock.company_name,
            symbol=stock.symbol, shares=h.shares, avg_price=h.avg_price, current_price=cp, current_value=cv,
            gain_pct=round(gp, 2) if gp is not None else None, div_yield_ttm=feat.div_yield_ttm if feat else None,
            annual_dividend=round(ad, 2) if ad else None, is_quanfury=stock.is_quanfury_available))

    snaps = [{"id": s.id, "month": s.month, "year": s.year, "total_value": s.total_value,
              "total_dividends": s.total_dividends, "notes": s.notes or ""}
             for s in db.query(PortfolioSnapshot).filter_by(portfolio_id=pid).order_by(PortfolioSnapshot.year, PortfolioSnapshot.month).all()]

    st = _stats(db, pid)
    return PortfolioDetailOut(id=portfolio.id, name=portfolio.name, broker=portfolio.broker or "",
                               description=portfolio.description or "", created_at=str(portfolio.created_at),
                               holdings=holdings_out, snapshots=snaps, **st)


@router.put("/{pid}", response_model=PortfolioOut)
def update_portfolio(pid: int, data: PortfolioUpdate, db: Session = Depends(get_db)):
    p = db.query(Portfolio).filter_by(id=pid).first()
    if not p:
        raise HTTPException(status_code=404, detail="Portfolio not found")
    if data.name is not None: p.name = data.name
    if data.broker is not None: p.broker = data.broker
    if data.description is not None: p.description = data.description
    db.commit()
    db.refresh(p)
    st = _stats(db, pid)
    return PortfolioOut(id=p.id, name=p.name, broker=p.broker or "", description=p.description or "",
                         created_at=str(p.created_at), **st)


@router.delete("/{pid}")
def delete_portfolio(pid: int, db: Session = Depends(get_db)):
    p = db.query(Portfolio).filter_by(id=pid).first()
    if not p:
        raise HTTPException(status_code=404, detail="Portfolio not found")
    db.delete(p)
    db.commit()
    return {"ok": True}


@router.post("/{pid}/holdings", response_model=HoldingOut)
def add_holding(pid: int, data: HoldingCreate, db: Session = Depends(get_db)):
    if not db.query(Portfolio).filter_by(id=pid).first():
        raise HTTPException(status_code=404, detail="Portfolio not found")
    stock = db.query(Stock).filter_by(id=data.stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="Stock not found")

    existing = db.query(PortfolioHolding).filter_by(portfolio_id=pid, stock_id=data.stock_id).first()
    if existing:
        ts = existing.shares + data.shares
        if ts > 0:
            existing.avg_price = (existing.avg_price * existing.shares + data.avg_price * data.shares) / ts
        existing.shares = ts
        db.commit()
        holding = existing
    else:
        holding = PortfolioHolding(portfolio_id=pid, stock_id=data.stock_id, shares=data.shares, avg_price=data.avg_price)
        db.add(holding)
        db.commit()
        db.refresh(holding)

    feat = db.query(StockFeature).filter_by(stock_id=stock.id).first()
    cp = feat.last_close if feat else None
    cv = cp * holding.shares if cp else None
    cost = holding.avg_price * holding.shares if holding.avg_price else None
    gp = ((cv - cost) / cost * 100) if cv and cost and cost > 0 else None
    ad = (feat.dividend_ttm or 0) * holding.shares if feat else None
    return HoldingOut(id=holding.id, stock_id=holding.stock_id, ticker_yf=stock.ticker_yf,
                       company_name=stock.company_name, symbol=stock.symbol, shares=holding.shares,
                       avg_price=holding.avg_price, current_price=cp, current_value=cv,
                       gain_pct=round(gp, 2) if gp is not None else None,
                       div_yield_ttm=feat.div_yield_ttm if feat else None,
                       annual_dividend=round(ad, 2) if ad else None,
                       is_quanfury=stock.is_quanfury_available)


@router.delete("/{pid}/holdings/{hid}")
def remove_holding(pid: int, hid: int, db: Session = Depends(get_db)):
    h = db.query(PortfolioHolding).filter_by(id=hid, portfolio_id=pid).first()
    if not h:
        raise HTTPException(status_code=404, detail="Holding not found")
    db.delete(h)
    db.commit()
    return {"ok": True}


@router.post("/{pid}/snapshots")
def create_snapshot(pid: int, data: SnapshotCreate, db: Session = Depends(get_db)):
    if not db.query(Portfolio).filter_by(id=pid).first():
        raise HTTPException(status_code=404, detail="Portfolio not found")
    existing = db.query(PortfolioSnapshot).filter_by(portfolio_id=pid, month=data.month, year=data.year).first()
    if existing:
        existing.total_value = data.total_value
        existing.total_dividends = data.total_dividends
        existing.notes = data.notes
    else:
        db.add(PortfolioSnapshot(portfolio_id=pid, month=data.month, year=data.year,
                                  total_value=data.total_value, total_dividends=data.total_dividends, notes=data.notes))
    db.commit()
    return {"ok": True}


@router.get("/{pid}/snapshots")
def get_snapshots(pid: int, db: Session = Depends(get_db)):
    return [{"id": s.id, "month": s.month, "year": s.year, "total_value": s.total_value,
             "total_dividends": s.total_dividends, "notes": s.notes or ""}
            for s in db.query(PortfolioSnapshot).filter_by(portfolio_id=pid).order_by(PortfolioSnapshot.year, PortfolioSnapshot.month).all()]
