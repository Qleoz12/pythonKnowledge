#!/usr/bin/env python3
"""
Cross-platform script to add stocks to Stock Portfolio Unifier.
Works on Windows, Linux, and macOS — no curl quoting issues.

Usage:
    python scripts/add_stocks.py NFLX
    python scripts/add_stocks.py NFLX GOOG AMZN TSLA
    python scripts/add_stocks.py NFLX --portfolio 1 --shares 10 --price 950
    python scripts/add_stocks.py NFLX GOOG --no-enrich
    python scripts/add_stocks.py --file stocks.txt
    python scripts/add_stocks.py --enrich-batch 20
    python scripts/add_stocks.py --enrich-status
"""

import argparse
import json
import sys
import urllib.request
import urllib.error

BASE_URL = "http://localhost:8000"


def _set_base_url(url: str):
    global BASE_URL
    BASE_URL = url


def api_get(path: str):
    req = urllib.request.Request(f"{BASE_URL}{path}")
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read().decode())


def api_post(path: str, body: dict):
    data = json.dumps(body).encode()
    req = urllib.request.Request(
        f"{BASE_URL}{path}",
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            return json.loads(resp.read().decode()), resp.status
    except urllib.error.HTTPError as e:
        error_body = e.read().decode()
        try:
            error_body = json.loads(error_body)
        except json.JSONDecodeError:
            pass
        return {"error": error_body, "status": e.code}, e.code


def add_stock(ticker: str, portfolio_id=None, shares=0, avg_price=0, enrich=True):
    payload = {"ticker": ticker.strip().upper(), "enrich": enrich}
    if portfolio_id:
        payload["portfolio_id"] = portfolio_id
    if shares > 0:
        payload["shares"] = shares
        payload["avg_price"] = avg_price

    print(f"  Adding {payload['ticker']}...", end=" ", flush=True)
    result, status = api_post("/api/stocks", payload)

    if status in (200, 201):
        name = result.get("company_name", "")
        exchange = result.get("exchange_code", "?")
        sector = result.get("sector", "")
        price = result.get("last_close")
        div_yield = result.get("div_yield_ttm")
        print(f"OK  [{exchange}] {name}")
        print(f"         sector={sector}, price={price}, yield={div_yield}%")
        return True
    else:
        print(f"FAIL  {result}")
        return False


def enrich_status():
    result = api_get("/api/stocks/enrich/status")
    total = result["total_stocks"]
    missing_p = result["missing_prices"]
    missing_s = result["missing_sector"]
    health = result["health_pct"]

    print(f"\n  Data Health: {health}%")
    print(f"  Total stocks:     {total:,}")
    print(f"  Missing prices:   {missing_p:,}")
    print(f"  Missing sectors:  {missing_s:,}")
    print(f"  With full data:   {total - missing_p:,}\n")
    return result


def enrich_batch(batch_size: int, mode: str = "missing_prices"):
    print(f"  Enriching {batch_size} stocks (mode={mode})...", flush=True)
    result, status = api_post("/api/stocks/enrich/batch", {
        "batch_size": batch_size,
        "mode": mode,
    })

    if status in (200, 201):
        print(f"  Enriched: {result['enriched']}, Failed: {result['failed']}, Remaining: {result['total_missing']}")
        for d in result.get("details", []):
            icon = "OK" if d["status"] == "ok" else "FAIL"
            print(f"    {icon}  {d['ticker']}  sector={d.get('sector', '?')}  price={d.get('price')}")
    else:
        print(f"  Error: {result}")


def main():
    parser = argparse.ArgumentParser(
        description="Add stocks to Stock Portfolio Unifier",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python scripts/add_stocks.py NFLX
  python scripts/add_stocks.py NFLX GOOG AMZN TSLA
  python scripts/add_stocks.py NFLX --portfolio 1 --shares 10 --price 950
  python scripts/add_stocks.py --file my_tickers.txt
  python scripts/add_stocks.py --enrich-batch 20
  python scripts/add_stocks.py --enrich-batch 10 --mode missing_sector
  python scripts/add_stocks.py --enrich-status
        """,
    )
    parser.add_argument("tickers", nargs="*", help="One or more ticker symbols (e.g. NFLX GOOG AAPL)")
    parser.add_argument("--file", "-f", help="Text file with one ticker per line")
    parser.add_argument("--portfolio", "-p", type=int, help="Portfolio ID to add stocks to")
    parser.add_argument("--shares", "-s", type=float, default=0, help="Number of shares (requires --portfolio)")
    parser.add_argument("--price", type=float, default=0, help="Average purchase price (requires --portfolio)")
    parser.add_argument("--no-enrich", action="store_true", help="Skip yfinance enrichment")
    parser.add_argument("--enrich-batch", type=int, metavar="N", help="Enrich N stocks with missing data")
    parser.add_argument("--enrich-status", action="store_true", help="Show data health status")
    parser.add_argument("--mode", default="missing_prices", choices=["missing_prices", "missing_sector"],
                        help="Enrichment mode (default: missing_prices)")
    parser.add_argument("--url", default=BASE_URL, help=f"API base URL (default: {BASE_URL})")

    args = parser.parse_args()
    _set_base_url(args.url)

    try:
        health = api_get("/api/health")
        print(f"Connected to API ({health.get('stocks_count', 0):,} stocks in DB)")
    except Exception as e:
        print(f"ERROR: Cannot connect to {BASE_URL} — is the backend running?\n  {e}")
        sys.exit(1)

    if args.enrich_status:
        enrich_status()
        return

    if args.enrich_batch:
        enrich_batch(args.enrich_batch, args.mode)
        return

    tickers = list(args.tickers)
    if args.file:
        with open(args.file) as f:
            for line in f:
                t = line.strip().split(",")[0].split()[0]
                if t and not t.startswith("#"):
                    tickers.append(t)

    if not tickers:
        parser.print_help()
        sys.exit(1)

    print(f"\nAdding {len(tickers)} stock(s)...\n")
    ok, fail = 0, 0
    for ticker in tickers:
        success = add_stock(
            ticker,
            portfolio_id=args.portfolio,
            shares=args.shares,
            avg_price=args.price,
            enrich=not args.no_enrich,
        )
        if success:
            ok += 1
        else:
            fail += 1

    print(f"\nDone: {ok} added, {fail} failed")


if __name__ == "__main__":
    main()
