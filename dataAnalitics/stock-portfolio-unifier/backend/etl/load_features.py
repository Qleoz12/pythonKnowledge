import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

import pandas as pd
from sqlalchemy.orm import Session
from database import engine, SessionLocal
from models import Base, Exchange, Stock, StockFeature
from logger import get_logger

log = get_logger("etl.features")

from config import DATA_DIR
CACHE_DIR = os.path.join(DATA_DIR, "cache_yf")

EXCHANGE_MAP = {
    "tsx_features.csv": {"code": "TSX", "name": "Toronto Stock Exchange"},
    "nyse_features.csv": {"code": "NYSE", "name": "New York Stock Exchange"},
    "lse_features.csv": {"code": "LSE", "name": "London Stock Exchange"},
}


def safe_float(val):
    try:
        if pd.isna(val):
            return None
        return float(val)
    except (ValueError, TypeError):
        return None


def load_features_file(db: Session, filename: str, exchange_info: dict):
    filepath = os.path.join(CACHE_DIR, filename)
    if not os.path.exists(filepath):
        log.warning("SKIP %s not found", filepath)
        return 0

    df = pd.read_csv(filepath)
    log.info("READ %s: %d rows, columns: %s", filename, len(df), list(df.columns))

    exchange = db.query(Exchange).filter_by(code=exchange_info["code"]).first()
    if not exchange:
        exchange = Exchange(code=exchange_info["code"], name=exchange_info["name"])
        db.add(exchange)
        db.flush()

    count = 0
    for _, row in df.iterrows():
        ticker_yf = str(row.get("ticker_yf", "")).strip()
        if not ticker_yf:
            continue

        symbol = str(row.get("Symbol", ticker_yf)).strip()
        company_name = str(row.get("Company Name", "")).strip()
        sector = str(row.get("Sector", row.get("sector", ""))).strip()
        currency = str(row.get("Currency", "")).strip()
        isin = str(row.get("ISIN", "")).strip()

        market_cap_col = [c for c in df.columns if "Market Cap" in c or "market_cap" in c.lower()]
        market_cap = safe_float(row[market_cap_col[0]]) if market_cap_col else None

        stock = db.query(Stock).filter_by(ticker_yf=ticker_yf).first()
        if not stock:
            stock = Stock(
                ticker_yf=ticker_yf, symbol=symbol,
                company_name=company_name if company_name != "nan" else "",
                exchange_id=exchange.id,
                sector=sector if sector != "nan" else "",
                currency=currency if currency != "nan" else "",
                market_cap=market_cap or 0,
                isin=isin if isin != "nan" else "",
            )
            db.add(stock)
            db.flush()

        feature = db.query(StockFeature).filter_by(stock_id=stock.id).first()
        if not feature:
            feature = StockFeature(stock_id=stock.id)
            db.add(feature)

        feature.last_close = safe_float(row.get("last_close"))
        feature.max_drawdown = safe_float(row.get("max_drawdown"))
        feature.ema_20 = safe_float(row.get("EMA_20"))
        feature.ema_52 = safe_float(row.get("EMA_52"))
        feature.ema_200 = safe_float(row.get("EMA_200"))
        feature.macd = safe_float(row.get("MACD"))
        feature.macd_signal = safe_float(row.get("MACD_signal"))
        feature.rsi_14 = safe_float(row.get("RSI_14"))
        feature.dividend_ttm = safe_float(row.get("dividend_ttm"))
        feature.payments_ttm = safe_float(row.get("payments_ttm"))
        feature.div_freq = str(row.get("div_freq", "")) if pd.notna(row.get("div_freq")) else None
        feature.last_div_date = str(row.get("last_div_date", "")) if pd.notna(row.get("last_div_date")) else None
        feature.div_yield_ttm = safe_float(row.get("div_yield_ttm"))
        feature.next_earnings_date = str(row.get("next_earnings_date", "")) if pd.notna(row.get("next_earnings_date")) else None
        feature.eps_estimate = safe_float(row.get("eps_estimate"))
        feature.reported_eps = safe_float(row.get("reported_eps"))
        feature.surprise_pct = safe_float(row.get("surprise_pct"))
        count += 1

    db.commit()
    log.info("DONE %s: %d stocks loaded", filename, count)
    return count


def run():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        total = 0
        for filename, exchange_info in EXCHANGE_MAP.items():
            log.info("Loading %s...", filename)
            total += load_features_file(db, filename, exchange_info)
        log.info("=== Total stocks loaded: %d ===", total)
    finally:
        db.close()


if __name__ == "__main__":
    run()
