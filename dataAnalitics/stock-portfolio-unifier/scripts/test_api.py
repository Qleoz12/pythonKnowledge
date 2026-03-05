#!/usr/bin/env python3
"""
Quick integration tests for Stock Portfolio Unifier API.
Run with the backend server running on localhost:8000.

Usage:
    python scripts/test_api.py
    python scripts/test_api.py --url http://localhost:8000
"""

import json
import sys
import urllib.request
import urllib.error
import argparse

BASE_URL = "http://localhost:8000"
PASS = 0
FAIL = 0


def api(method: str, path: str, body: dict = None, expect_status: int = None):
    data = json.dumps(body).encode() if body else None
    req = urllib.request.Request(
        f"{BASE_URL}{path}",
        data=data,
        headers={"Content-Type": "application/json"} if data else {},
        method=method,
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            result = json.loads(resp.read().decode())
            if expect_status and resp.status != expect_status:
                return result, resp.status, False
            return result, resp.status, True
    except urllib.error.HTTPError as e:
        body_text = e.read().decode()
        try:
            body_text = json.loads(body_text)
        except json.JSONDecodeError:
            pass
        if expect_status and e.code == expect_status:
            return body_text, e.code, True
        return body_text, e.code, False


def check(label: str, condition: bool, detail: str = ""):
    global PASS, FAIL
    icon = "PASS" if condition else "FAIL"
    if condition:
        PASS += 1
    else:
        FAIL += 1
    msg = f"  [{icon}] {label}"
    if detail and not condition:
        msg += f"  ({detail})"
    print(msg)
    return condition


def test_health():
    print("\n--- Health ---")
    result, status, _ = api("GET", "/api/health")
    check("GET /api/health returns 200", status == 200)
    check("Response has stocks_count", "stocks_count" in result, str(result))


def test_list_stocks():
    print("\n--- List Stocks ---")
    result, status, _ = api("GET", "/api/stocks?page=1&page_size=5")
    check("GET /api/stocks returns 200", status == 200)
    check("Response has items array", "items" in result)
    check("Response has total count", "total" in result)
    check("Items array has stocks", len(result.get("items", [])) > 0, f"got {len(result.get('items', []))}")
    if result.get("items"):
        stock = result["items"][0]
        check("Stock has ticker_yf", "ticker_yf" in stock, str(stock.keys()))
        check("Stock has id", "id" in stock)


def test_stock_detail():
    print("\n--- Stock Detail ---")
    list_result, _, _ = api("GET", "/api/stocks?page=1&page_size=1")
    if not list_result.get("items"):
        check("Has stocks to test detail", False, "no stocks in DB")
        return

    stock_id = list_result["items"][0]["id"]
    result, status, _ = api("GET", f"/api/stocks/{stock_id}")
    check(f"GET /api/stocks/{stock_id} returns 200", status == 200)
    check("Detail has company_name", "company_name" in result)
    check("Detail has dividend_history", "dividend_history" in result)
    check("Detail has portfolios", "portfolios" in result)
    check("Detail has week_52_high", "week_52_high" in result)
    check("Detail has week_100_high", "week_100_high" in result)


def test_create_stock():
    print("\n--- Create Stock ---")
    result, status, _ = api("POST", "/api/stocks", {"ticker": "AAPL", "enrich": False})
    check("POST /api/stocks returns 201 or 200", status in (200, 201), f"status={status}")
    check("Response has ticker_yf", "ticker_yf" in result, str(result))
    check("Response has id", "id" in result, str(result))
    created_id = result.get("id")

    if created_id:
        detail, status2, _ = api("GET", f"/api/stocks/{created_id}")
        check("Created stock is retrievable", status2 == 200)
        check("Ticker matches", detail.get("symbol") == "AAPL", f"got {detail.get('symbol')}")


def test_create_stock_with_enrich():
    print("\n--- Create Stock (with enrich) ---")
    result, status, _ = api("POST", "/api/stocks", {"ticker": "MSFT", "enrich": True})
    check("POST /api/stocks with enrich returns 200/201", status in (200, 201), f"status={status}")
    check("Has company_name", bool(result.get("company_name")), str(result.get("company_name")))
    check("Has exchange_code", bool(result.get("exchange_code")), str(result.get("exchange_code")))
    check("Has sector", bool(result.get("sector")), str(result.get("sector")))


def test_exchanges():
    print("\n--- Exchanges ---")
    result, status, _ = api("GET", "/api/stocks/exchanges")
    check("GET /api/stocks/exchanges returns 200", status == 200)
    check("Returns list", isinstance(result, list))
    check("Has exchanges", len(result) > 0, f"got {len(result)}")


def test_sectors():
    print("\n--- Sectors ---")
    result, status, _ = api("GET", "/api/stocks/sectors")
    check("GET /api/stocks/sectors returns 200", status == 200)
    check("Returns list", isinstance(result, list))
    check("Has sectors", len(result) > 0, f"got {len(result)}")


def test_search():
    print("\n--- Search ---")
    result, status, _ = api("GET", "/api/stocks/search?q=bank")
    check("GET /api/stocks/search returns 200", status == 200)
    check("Returns list", isinstance(result, list))


def test_sector_stats():
    print("\n--- Sector Stats ---")
    result, status, _ = api("GET", "/api/stocks/sector-stats")
    check("GET /api/stocks/sector-stats returns 200", status == 200)
    check("Returns list", isinstance(result, list))
    if result:
        check("Has sector field", "sector" in result[0])
        check("Has count field", "count" in result[0])


def test_enrich_status():
    print("\n--- Enrich Status ---")
    result, status, _ = api("GET", "/api/stocks/enrich/status")
    check("GET /api/stocks/enrich/status returns 200", status == 200)
    check("Has total_stocks", "total_stocks" in result)
    check("Has missing_prices", "missing_prices" in result)
    check("Has missing_sector", "missing_sector" in result)
    check("Has health_pct", "health_pct" in result)
    check("health_pct is a number", isinstance(result.get("health_pct"), (int, float)))


def test_enrich_batch():
    print("\n--- Enrich Batch (1 stock) ---")
    result, status, _ = api("POST", "/api/stocks/enrich/batch", {"batch_size": 1, "mode": "missing_prices"})
    check("POST /api/stocks/enrich/batch returns 200", status == 200, f"status={status}")
    check("Has total_missing", "total_missing" in result)
    check("Has enriched count", "enriched" in result)
    check("Has details array", isinstance(result.get("details"), list))


def test_dividends():
    print("\n--- Dividends ---")
    result, status, _ = api("GET", "/api/dividends/calendar?start_date=2025-01-01&end_date=2025-12-31")
    check("GET /api/dividends/calendar returns 200", status == 200)
    check("Returns list", isinstance(result, list))


def test_portfolios():
    print("\n--- Portfolios ---")
    result, status, _ = api("GET", "/api/portfolios")
    check("GET /api/portfolios returns 200", status == 200)
    check("Returns list", isinstance(result, list))

    result2, status2, _ = api("POST", "/api/portfolios", {"name": "Test Portfolio (auto)", "broker": "Test"})
    check("POST /api/portfolios returns 200/201", status2 in (200, 201), f"status={status2}")
    portfolio_id = result2.get("id")
    check("Portfolio has id", portfolio_id is not None)

    if portfolio_id:
        detail, status3, _ = api("GET", f"/api/portfolios/{portfolio_id}")
        check("GET portfolio detail returns 200", status3 == 200)

        _, del_status, _ = api("DELETE", f"/api/portfolios/{portfolio_id}")
        check("DELETE portfolio returns 200/204", del_status in (200, 204))


def test_analytics():
    print("\n--- Analytics ---")
    result, status, _ = api("GET", "/api/analytics/dashboard")
    check("GET /api/analytics/dashboard returns 200", status == 200)
    check("Has total_stocks", "total_stocks" in result)

    result2, status2, _ = api("GET", "/api/analytics/top-dividend-yields?limit=5")
    check("GET /api/analytics/top-dividend-yields returns 200", status2 == 200)
    check("Returns list", isinstance(result2, list))


def test_stock_not_found():
    print("\n--- Error Handling ---")
    _, status, _ = api("GET", "/api/stocks/999999")
    check("GET /api/stocks/999999 returns 404", status == 404)


def main():
    global BASE_URL
    parser = argparse.ArgumentParser(description="API integration tests")
    parser.add_argument("--url", default=BASE_URL, help=f"API base URL (default: {BASE_URL})")
    parser.add_argument("--quick", action="store_true", help="Skip slow tests (enrich)")
    args = parser.parse_args()
    BASE_URL = args.url

    print(f"Testing API at {BASE_URL}")
    try:
        api("GET", "/api/health")
    except Exception as e:
        print(f"ERROR: Cannot connect to {BASE_URL}\n  {e}")
        sys.exit(1)

    test_health()
    test_list_stocks()
    test_stock_detail()
    test_exchanges()
    test_sectors()
    test_search()
    test_sector_stats()
    test_enrich_status()
    test_dividends()
    test_portfolios()
    test_analytics()
    test_stock_not_found()
    test_create_stock()

    if not args.quick:
        test_create_stock_with_enrich()
        test_enrich_batch()

    print(f"\n{'='*40}")
    print(f"  PASS: {PASS}   FAIL: {FAIL}   TOTAL: {PASS + FAIL}")
    print(f"{'='*40}")
    sys.exit(1 if FAIL > 0 else 0)


if __name__ == "__main__":
    main()
