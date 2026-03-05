import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

import pandas as pd
from datetime import datetime
from database import engine, SessionLocal
from models import Base, Stock, DividendEvent

from config import DATA_DIR
CACHE_DIR = os.path.join(DATA_DIR, "cache_yf")
DIV_FILES = ["tsx_div_events.csv", "nyse_div_events.csv", "lse_div_events.csv"]


def parse_date(val):
    try:
        if pd.isna(val):
            return None
        return datetime.strptime(str(val).strip()[:10], "%Y-%m-%d").date()
    except (ValueError, TypeError):
        return None


def load_div_events_file(db, filename, ticker_cache):
    filepath = os.path.join(CACHE_DIR, filename)
    if not os.path.exists(filepath):
        print(f"  [SKIP] {filepath} not found")
        return 0

    df = pd.read_csv(filepath)
    print(f"  [READ] {filename}: {len(df)} rows")

    count, skipped, batch = 0, 0, []
    for _, row in df.iterrows():
        ticker_yf = str(row.get("ticker_yf", "")).strip()
        if not ticker_yf:
            continue
        stock_id = ticker_cache.get(ticker_yf)
        if not stock_id:
            skipped += 1
            continue
        div_date = parse_date(row.get("div_date"))
        if not div_date:
            continue
        try:
            div_amount = float(row.get("div_amount", 0))
        except (ValueError, TypeError):
            continue
        batch.append(DividendEvent(stock_id=stock_id, div_date=div_date, div_amount=div_amount))
        count += 1
        if len(batch) >= 5000:
            db.add_all(batch)
            db.commit()
            batch = []

    if batch:
        db.add_all(batch)
        db.commit()
    print(f"  [DONE] {filename}: {count} events, {skipped} skipped")
    return count


def run():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        ticker_cache = {s.ticker_yf: s.id for s in db.query(Stock.id, Stock.ticker_yf).all()}
        print(f"  {len(ticker_cache)} stocks in cache")
        db.query(DividendEvent).delete()
        db.commit()

        total = 0
        for f in DIV_FILES:
            print(f"\nLoading {f}...")
            total += load_div_events_file(db, f, ticker_cache)
        print(f"\n=== Total events: {total} ===")
    finally:
        db.close()


if __name__ == "__main__":
    run()
