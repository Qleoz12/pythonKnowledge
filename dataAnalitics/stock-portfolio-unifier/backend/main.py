import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import engine
from models import Base

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Stock Portfolio Unifier", version="1.0.0")

from config import CORS_ORIGINS

app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

from routers.stocks import router as stocks_router
from routers.portfolios import router as portfolios_router
from routers.dividends import router as dividends_router
from routers.analytics import router as analytics_router
from routers.charts import router as charts_router

app.include_router(stocks_router)
app.include_router(portfolios_router)
app.include_router(dividends_router)
app.include_router(analytics_router)
app.include_router(charts_router)


@app.get("/api/health")
def health():
    from sqlalchemy import text
    from database import SessionLocal
    db = SessionLocal()
    try:
        result = db.execute(text("SELECT COUNT(*) FROM stocks")).scalar()
        return {"status": "ok", "stocks_count": result}
    except Exception:
        return {"status": "ok", "stocks_count": 0, "note": "DB may need ETL run"}
    finally:
        db.close()


@app.get("/api/etl/run")
def run_etl():
    from etl.load_features import run as run_features
    from etl.load_div_events import run as run_divs
    from etl.load_quanfury import run as run_quanfury
    results = {}
    try:
        run_features()
        results["features"] = "ok"
    except Exception as e:
        results["features"] = str(e)
    try:
        run_divs()
        results["div_events"] = "ok"
    except Exception as e:
        results["div_events"] = str(e)
    try:
        run_quanfury()
        results["quanfury"] = "ok"
    except Exception as e:
        results["quanfury"] = str(e)
    return {"status": "completed", "results": results}


@app.get("/api/export/stocks")
def export_stocks_csv():
    import csv
    import io
    from fastapi.responses import StreamingResponse
    from database import SessionLocal
    from models import Stock, StockFeature, Exchange
    db = SessionLocal()
    try:
        stocks = db.query(Stock, StockFeature, Exchange).outerjoin(
            StockFeature, Stock.id == StockFeature.stock_id
        ).outerjoin(Exchange, Stock.exchange_id == Exchange.id).all()
        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow(["ticker_yf", "symbol", "company_name", "exchange", "sector", "currency",
                          "last_close", "div_yield_ttm", "dividend_ttm", "rsi_14", "is_quanfury"])
        for s, f, e in stocks:
            writer.writerow([s.ticker_yf, s.symbol, s.company_name, e.code if e else "", s.sector,
                              s.currency, f.last_close if f else "", f.div_yield_ttm if f else "",
                              f.dividend_ttm if f else "", f.rsi_14 if f else "", s.is_quanfury_available])
        output.seek(0)
        return StreamingResponse(iter([output.getvalue()]), media_type="text/csv",
                                  headers={"Content-Disposition": "attachment; filename=stocks_export.csv"})
    finally:
        db.close()


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
