import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

import json
from datetime import datetime
from database import engine, SessionLocal
from models import Base, Stock, QuanfuryDividend

from config import DATA_DIR
QF_DIV_PATH = os.path.join(DATA_DIR, "quanfury_div.json")
QF_STOCKS_PATH = os.path.join(DATA_DIR, "trading-os", "quantfury", "stocks.json")


def load_quanfury_dividends(db):
    if not os.path.exists(QF_DIV_PATH):
        print(f"  [SKIP] {QF_DIV_PATH} not found")
        return 0
    with open(QF_DIV_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)
    items = data.get("data", [])
    print(f"  [READ] quanfury_div.json: {len(items)} records")

    db.query(QuanfuryDividend).delete()
    db.commit()

    count, batch = 0, []
    for item in items:
        sn = item.get("shortName", "").strip()
        if not sn:
            continue
        ts = item.get("date")
        if not ts:
            continue
        div_date = datetime.utcfromtimestamp(ts / 1000).date()
        batch.append(QuanfuryDividend(
            qf_id=str(item.get("id", "")), short_name=sn,
            amount=float(item.get("amount", 0)), div_date=div_date,
            div_yield=float(item.get("yield", 0)) if item.get("yield") else None,
            currency=item.get("currency", "USD"),
        ))
        count += 1
        if len(batch) >= 5000:
            db.add_all(batch)
            db.commit()
            batch = []
    if batch:
        db.add_all(batch)
        db.commit()
    print(f"  [DONE] {count} Quanfury dividends loaded")
    return count


def mark_quanfury_stocks(db):
    if not os.path.exists(QF_STOCKS_PATH):
        print(f"  [SKIP] {QF_STOCKS_PATH} not found")
        return 0
    with open(QF_STOCKS_PATH, "r", encoding="utf-8") as f:
        qf_stocks = json.load(f)
    print(f"  [READ] quantfury/stocks.json: {len(qf_stocks)} instruments")

    qf_by_ticker = {}
    for item in qf_stocks:
        ticker = item.get("ticker", "").strip()
        if ticker:
            qf_by_ticker[ticker] = item

    matched = 0
    sectors_filled = 0
    for stock in db.query(Stock).all():
        base = stock.symbol.replace(".TO", "").replace(".L", "").strip()
        qf_item = qf_by_ticker.get(stock.symbol) or qf_by_ticker.get(base)
        if qf_item:
            stock.is_quanfury_available = True
            matched += 1

            if not stock.sector and qf_item.get("sector"):
                stock.sector = qf_item["sector"]
                sectors_filled += 1
            if not stock.industry and qf_item.get("industry"):
                stock.industry = qf_item["industry"]

    db.commit()
    print(f"  [DONE] {matched} stocks marked as Quanfury-available, {sectors_filled} sectors backfilled")
    return matched


def run():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        print("Loading Quanfury dividends...")
        load_quanfury_dividends(db)
        print("\nMarking Quanfury-available stocks...")
        mark_quanfury_stocks(db)
    finally:
        db.close()


if __name__ == "__main__":
    run()
