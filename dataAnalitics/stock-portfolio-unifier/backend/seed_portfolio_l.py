"""
Crea el portafolio "L" con posiciones alineadas al análisis de estrés (preview.html).
Ejecutar desde la carpeta backend:  python seed_portfolio_l.py
Requiere que MAIN, AGNC, STWD, FSK y ARCC existan en la tabla stocks (tras ETL).
"""
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))

from sqlalchemy.orm import Session
from database import SessionLocal
from models import Portfolio, PortfolioHolding, Stock

# ticker_yf, shares, avg_price
HOLDINGS = [
    ("MAIN", 621, 51.53),
    ("AGNC", 2164, 9.69),
    ("STWD", 565, 17.04),
    ("FSK", 496, 9.91),
    ("ARCC", 259, 20.0),
]

DESCRIPTION = "Portafolio L — análisis de estrés y equity en la app (vista detalle)."


def run(db: Session) -> None:
    existing = db.query(Portfolio).filter(Portfolio.name == "L").first()
    if existing:
        p = existing
        if not (p.description or "").strip():
            p.description = DESCRIPTION
    else:
        p = Portfolio(name="L", broker="", description=DESCRIPTION)
        db.add(p)
        db.flush()

    for ticker_yf, shares, avg_price in HOLDINGS:
        stock = db.query(Stock).filter(Stock.ticker_yf == ticker_yf).first()
        if not stock:
            print(f"[skip] No stock in DB: {ticker_yf} — cargar ETL o crear el ticker.")
            continue
        h = (
            db.query(PortfolioHolding)
            .filter_by(portfolio_id=p.id, stock_id=stock.id)
            .first()
        )
        if h:
            h.shares = shares
            h.avg_price = avg_price
        else:
            db.add(
                PortfolioHolding(
                    portfolio_id=p.id,
                    stock_id=stock.id,
                    shares=shares,
                    avg_price=avg_price,
                )
            )
    db.commit()
    print(f"OK portfolio id={p.id} name=L holdings updated.")


if __name__ == "__main__":
    s = SessionLocal()
    try:
        run(s)
    finally:
        s.close()
