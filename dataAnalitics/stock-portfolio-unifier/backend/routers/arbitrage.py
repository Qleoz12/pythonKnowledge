"""
Arbitrage module: USDT vs COP vs CAD
Fetches live prices from multiple public APIs and P2P sources.

Sources:
  - CriptoYa (Argentina/LatAm)  → USDT/COP, USDT/ARS, BTC/COP
  - Binance public ticker API   → USDT/COP (Binance P2P via advertiser endpoint)
  - ExchangeRate-API (free)     → COP/CAD, USD/CAD, USD/COP
  - Kraken REST                 → BTC/USD, ETH/USD (reference)
  - CoinGecko (free)            → USDT market data, BTC, ETH in USD/CAD
  - Bitso (Mexico/LatAm)        → USDT/MXN, BTC/MXN
  - Coinbase Advanced (public)  → BTC/USD, ETH/USD
  - Blockchain.info             → BTC ticker multi-currency
  - Open Exchange Rates (free)  → multi-currency FX
"""

import asyncio
import json
from datetime import datetime, timedelta
from typing import Any

import httpx
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session

from database import get_db
from models import ArbitrageSnapshot, ArbitrageOperation
from logger import get_logger

log = get_logger("arbitrage")

router = APIRouter(prefix="/api/arbitrage", tags=["arbitrage"])

TIMEOUT = httpx.Timeout(12.0)

# ─────────────────────────────────────────────────────────────────────────────
# Pydantic schemas
# ─────────────────────────────────────────────────────────────────────────────

class RateItem(BaseModel):
    source: str
    pair: str
    bid: float | None = None
    ask: float | None = None
    mid: float | None = None
    volume_24h: float | None = None
    fetched_at: str

class OperationCreate(BaseModel):
    pair: str
    buy_source: str
    sell_source: str
    buy_price: float
    sell_price: float
    amount_usdt: float
    fee_total: float = 0.0
    notes: str = ""

class OperationOut(BaseModel):
    id: int
    pair: str
    buy_source: str
    sell_source: str
    buy_price: float
    sell_price: float
    amount_usdt: float
    fee_total: float
    net_profit: float
    net_profit_pct: float
    status: str
    notes: str
    created_at: str

# ─────────────────────────────────────────────────────────────────────────────
# Individual fetchers
# ─────────────────────────────────────────────────────────────────────────────

async def fetch_criptoya(client: httpx.AsyncClient) -> list[dict]:
    """CriptoYa: aggregates P2P / exchange prices for LatAm currencies."""
    results = []
    pairs = [
        ("usdt", "cop", "USDT/COP"),
        ("usdt", "ars", "USDT/ARS"),
        ("btc",  "cop", "BTC/COP"),
        ("eth",  "cop", "ETH/COP"),
    ]
    for crypto, fiat, label in pairs:
        try:
            url = f"https://criptoya.com/api/{crypto}/{fiat}/1"
            r = await client.get(url, timeout=TIMEOUT)
            if r.status_code != 200:
                continue
            data = r.json()
            # CriptoYa returns a dict of exchange → {ask, bid, totalAsk, totalBid, time}
            for exchange_name, vals in data.items():
                if not isinstance(vals, dict):
                    continue
                results.append({
                    "source": f"criptoya_{exchange_name}",
                    "pair": label,
                    "bid": vals.get("bid") or vals.get("totalBid"),
                    "ask": vals.get("ask") or vals.get("totalAsk"),
                    "mid": None,
                    "volume_24h": None,
                    "raw_json": json.dumps(vals),
                })
        except Exception as e:
            log.warning(f"CriptoYa {label} error: {e}")
    return results


async def fetch_exchangerate(client: httpx.AsyncClient) -> list[dict]:
    """ExchangeRate-API free tier — USD base, multi-currency."""
    results = []
    try:
        url = "https://open.er-api.com/v6/latest/USD"
        r = await client.get(url, timeout=TIMEOUT)
        data = r.json()
        rates = data.get("rates", {})
        pairs_wanted = [
            ("USD", "COP", "USD/COP"),
            ("USD", "CAD", "USD/CAD"),
        ]
        cop = rates.get("COP")
        cad = rates.get("CAD")
        for base, quote, label in pairs_wanted:
            val = rates.get(quote)
            if val:
                results.append({
                    "source": "exchangerate_api",
                    "pair": label,
                    "bid": val,
                    "ask": val,
                    "mid": val,
                    "volume_24h": None,
                    "raw_json": json.dumps({"rate": val}),
                })
        # Derived COP/CAD
        if cop and cad:
            cop_per_cad = cop / cad
            results.append({
                "source": "exchangerate_api",
                "pair": "COP/CAD",
                "bid": cop_per_cad,
                "ask": cop_per_cad,
                "mid": cop_per_cad,
                "volume_24h": None,
                "raw_json": json.dumps({"cop": cop, "cad": cad, "rate": cop_per_cad}),
            })
    except Exception as e:
        log.warning(f"ExchangeRate-API error: {e}")
    return results


async def fetch_coingecko(client: httpx.AsyncClient) -> list[dict]:
    """CoinGecko free API — prices in USD, CAD, COP for major coins."""
    results = []
    try:
        url = (
            "https://api.coingecko.com/api/v3/simple/price"
            "?ids=tether,bitcoin,ethereum"
            "&vs_currencies=usd,cad,cop"
            "&include_24hr_vol=true"
        )
        r = await client.get(url, timeout=TIMEOUT)
        if r.status_code != 200:
            return results
        data = r.json()

        coin_labels = {
            "tether": "USDT",
            "bitcoin": "BTC",
            "ethereum": "ETH",
        }
        currency_pairs = [("usd", "USD"), ("cad", "CAD"), ("cop", "COP")]
        vol_keys = {"usd": "usd_24h_vol", "cad": "cad_24h_vol", "cop": "cop_24h_vol"}

        for coin_id, coin_label in coin_labels.items():
            coin_data = data.get(coin_id, {})
            for currency_key, currency_label in currency_pairs:
                price = coin_data.get(currency_key)
                vol = coin_data.get(vol_keys.get(currency_key, ""))
                if price:
                    results.append({
                        "source": "coingecko",
                        "pair": f"{coin_label}/{currency_label}",
                        "bid": price,
                        "ask": price,
                        "mid": price,
                        "volume_24h": vol,
                        "raw_json": json.dumps({"price": price, "vol": vol}),
                    })
    except Exception as e:
        log.warning(f"CoinGecko error: {e}")
    return results


async def fetch_kraken(client: httpx.AsyncClient) -> list[dict]:
    """Kraken REST public ticker — BTC/USD, ETH/USD, BTC/CAD."""
    results = []
    pairs_map = {
        "XXBTZUSD": "BTC/USD",
        "XETHZUSD": "ETH/USD",
        "XXBTZCAD": "BTC/CAD",
        "XETHZCAD": "ETH/CAD",
    }
    try:
        query = ",".join(pairs_map.keys())
        url = f"https://api.kraken.com/0/public/Ticker?pair={query}"
        r = await client.get(url, timeout=TIMEOUT)
        data = r.json()
        result_data = data.get("result", {})
        for kraken_pair, label in pairs_map.items():
            vals = result_data.get(kraken_pair)
            if not vals:
                continue
            bid = float(vals["b"][0])
            ask = float(vals["a"][0])
            vol = float(vals["v"][1])  # 24h volume
            results.append({
                "source": "kraken",
                "pair": label,
                "bid": bid,
                "ask": ask,
                "mid": (bid + ask) / 2,
                "volume_24h": vol,
                "raw_json": json.dumps({"b": vals["b"], "a": vals["a"]}),
            })
    except Exception as e:
        log.warning(f"Kraken error: {e}")
    return results


async def fetch_binance_ticker(client: httpx.AsyncClient) -> list[dict]:
    """Binance public spot ticker — main crypto/USDT pairs."""
    results = []
    symbols = ["BTCUSDT", "ETHUSDT", "USDTCAD"]
    pair_map = {
        "BTCUSDT": "BTC/USDT",
        "ETHUSDT": "ETH/USDT",
        "USDTCAD": "USDT/CAD",
    }
    try:
        symbols_str = json.dumps(symbols)
        url = f"https://api.binance.com/api/v3/ticker/bookTicker?symbols={symbols_str}"
        r = await client.get(url, timeout=TIMEOUT)
        if r.status_code != 200:
            raise Exception(f"HTTP {r.status_code}")
        data = r.json()
        for item in data:
            sym = item.get("symbol")
            label = pair_map.get(sym)
            if not label:
                continue
            bid = float(item["bidPrice"])
            ask = float(item["askPrice"])
            results.append({
                "source": "binance",
                "pair": label,
                "bid": bid,
                "ask": ask,
                "mid": (bid + ask) / 2,
                "volume_24h": None,
                "raw_json": json.dumps(item),
            })
    except Exception as e:
        log.warning(f"Binance ticker error: {e}")
    return results


async def fetch_binance_24h(client: httpx.AsyncClient) -> list[dict]:
    """Binance 24h stats for BTC/USDT and ETH/USDT."""
    results = []
    symbols = ["BTCUSDT", "ETHUSDT"]
    try:
        for sym in symbols:
            url = f"https://api.binance.com/api/v3/ticker/24hr?symbol={sym}"
            r = await client.get(url, timeout=TIMEOUT)
            if r.status_code != 200:
                continue
            d = r.json()
            label = sym.replace("USDT", "/USDT")
            results.append({
                "source": "binance_24h",
                "pair": label,
                "bid": float(d.get("bidPrice", 0)) or None,
                "ask": float(d.get("askPrice", 0)) or None,
                "mid": float(d.get("lastPrice", 0)) or None,
                "volume_24h": float(d.get("volume", 0)) or None,
                "raw_json": json.dumps({
                    "open": d.get("openPrice"),
                    "high": d.get("highPrice"),
                    "low": d.get("lowPrice"),
                    "close": d.get("lastPrice"),
                    "vol": d.get("volume"),
                }),
            })
    except Exception as e:
        log.warning(f"Binance 24h error: {e}")
    return results


async def fetch_coinbase(client: httpx.AsyncClient) -> list[dict]:
    """Coinbase Advanced public product stats."""
    results = []
    products = [
        ("BTC-USD", "BTC/USD"),
        ("ETH-USD", "ETH/USD"),
        ("BTC-CAD", "BTC/CAD"),
        ("ETH-CAD", "ETH/CAD"),
    ]
    for product_id, label in products:
        try:
            url = f"https://api.coinbase.com/v2/prices/{product_id}/spot"
            r = await client.get(url, timeout=TIMEOUT)
            if r.status_code != 200:
                continue
            d = r.json()
            price = float(d["data"]["amount"])
            results.append({
                "source": "coinbase",
                "pair": label,
                "bid": price,
                "ask": price,
                "mid": price,
                "volume_24h": None,
                "raw_json": json.dumps(d.get("data", {})),
            })
        except Exception as e:
            log.warning(f"Coinbase {product_id} error: {e}")
    return results


async def fetch_blockchain_info(client: httpx.AsyncClient) -> list[dict]:
    """Blockchain.info BTC ticker — USD, CAD."""
    results = []
    try:
        url = "https://blockchain.info/ticker"
        r = await client.get(url, timeout=TIMEOUT)
        data = r.json()
        currency_map = {"USD": "BTC/USD", "CAD": "BTC/CAD"}
        for currency, label in currency_map.items():
            vals = data.get(currency)
            if vals:
                buy = vals.get("buy")
                sell = vals.get("sell")
                last = vals.get("last")
                results.append({
                    "source": "blockchain_info",
                    "pair": label,
                    "bid": sell,
                    "ask": buy,
                    "mid": last,
                    "volume_24h": None,
                    "raw_json": json.dumps(vals),
                })
    except Exception as e:
        log.warning(f"Blockchain.info error: {e}")
    return results


async def fetch_bitso(client: httpx.AsyncClient) -> list[dict]:
    """Bitso public ticker — MXN pairs."""
    results = []
    books = [
        ("usd_mxn", "USD/MXN"),
        ("btc_mxn", "BTC/MXN"),
        ("eth_mxn", "ETH/MXN"),
    ]
    for book, label in books:
        try:
            url = f"https://api.bitso.com/v3/ticker/?book={book}"
            r = await client.get(url, timeout=TIMEOUT)
            data = r.json()
            payload = data.get("payload", {})
            bid = float(payload.get("bid", 0)) or None
            ask = float(payload.get("ask", 0)) or None
            last = float(payload.get("last", 0)) or None
            vol = float(payload.get("volume", 0)) or None
            if bid:
                results.append({
                    "source": "bitso",
                    "pair": label,
                    "bid": bid,
                    "ask": ask,
                    "mid": last,
                    "volume_24h": vol,
                    "raw_json": json.dumps(payload),
                })
        except Exception as e:
            log.warning(f"Bitso {book} error: {e}")
    return results


# ─────────────────────────────────────────────────────────────────────────────
# Aggregator
# ─────────────────────────────────────────────────────────────────────────────

async def fetch_all_rates() -> list[dict]:
    async with httpx.AsyncClient() as client:
        tasks = [
            fetch_criptoya(client),
            fetch_exchangerate(client),
            fetch_coingecko(client),
            fetch_kraken(client),
            fetch_binance_ticker(client),
            fetch_binance_24h(client),
            fetch_coinbase(client),
            fetch_blockchain_info(client),
            fetch_bitso(client),
        ]
        results_list = await asyncio.gather(*tasks, return_exceptions=True)

    all_rates = []
    for r in results_list:
        if isinstance(r, list):
            all_rates.extend(r)
    return all_rates


# ─────────────────────────────────────────────────────────────────────────────
# Endpoints
# ─────────────────────────────────────────────────────────────────────────────

@router.get("/rates", response_model=list[RateItem])
async def get_live_rates(db: Session = Depends(get_db)):
    """Fetch live rates from all sources and persist them."""
    raw = await fetch_all_rates()
    now = datetime.utcnow()
    now_str = now.isoformat()

    items = []
    for r in raw:
        snap = ArbitrageSnapshot(
            source=r["source"],
            pair=r["pair"],
            bid=r.get("bid"),
            ask=r.get("ask"),
            mid=r.get("mid"),
            volume_24h=r.get("volume_24h"),
            raw_json=r.get("raw_json", ""),
            fetched_at=now,
        )
        db.add(snap)
        items.append(RateItem(
            source=r["source"],
            pair=r["pair"],
            bid=r.get("bid"),
            ask=r.get("ask"),
            mid=r.get("mid"),
            volume_24h=r.get("volume_24h"),
            fetched_at=now_str,
        ))

    try:
        db.commit()
    except Exception as e:
        db.rollback()
        log.error(f"DB commit error: {e}")

    return items


@router.get("/rates/cached", response_model=list[RateItem])
def get_cached_rates(minutes: int = 10, db: Session = Depends(get_db)):
    """Return the most recent cached snapshot (within N minutes)."""
    cutoff = datetime.utcnow() - timedelta(minutes=minutes)
    snaps = (
        db.query(ArbitrageSnapshot)
        .filter(ArbitrageSnapshot.fetched_at >= cutoff)
        .order_by(ArbitrageSnapshot.fetched_at.desc())
        .all()
    )
    return [
        RateItem(
            source=s.source,
            pair=s.pair,
            bid=s.bid,
            ask=s.ask,
            mid=s.mid,
            volume_24h=s.volume_24h,
            fetched_at=s.fetched_at.isoformat(),
        )
        for s in snaps
    ]


@router.get("/summary")
async def get_summary(db: Session = Depends(get_db)):
    """
    Returns a consolidated summary:
    - Best bid/ask per pair across all sources
    - Spread analysis for USDT/COP and USDT/CAD
    - COP/CAD derived cross-rate
    - Opportunity score
    """
    raw = await fetch_all_rates()
    now = datetime.utcnow().isoformat()

    # Group by pair
    by_pair: dict[str, list[dict]] = {}
    for r in raw:
        by_pair.setdefault(r["pair"], []).append(r)

    def best_for_pair(pair: str) -> dict[str, Any]:
        entries = by_pair.get(pair, [])
        if not entries:
            return {"pair": pair, "sources": [], "best_bid": None, "best_ask": None, "spread_pct": None}
        bids = [(e["bid"], e["source"]) for e in entries if e.get("bid") and e["bid"] > 0]
        asks = [(e["ask"], e["source"]) for e in entries if e.get("ask") and e["ask"] > 0]
        best_bid = max(bids, key=lambda x: x[0]) if bids else (None, None)
        best_ask = min(asks, key=lambda x: x[0]) if asks else (None, None)
        spread_pct = None
        if best_bid[0] and best_ask[0] and best_ask[0] > 0:
            spread_pct = round((best_bid[0] - best_ask[0]) / best_ask[0] * 100, 3)
        return {
            "pair": pair,
            "sources_count": len(entries),
            "best_bid": best_bid[0],
            "best_bid_source": best_bid[1],
            "best_ask": best_ask[0],
            "best_ask_source": best_ask[1],
            "spread_pct": spread_pct,
        }

    key_pairs = ["USDT/COP", "USDT/CAD", "USD/COP", "USD/CAD", "COP/CAD",
                 "BTC/USD", "BTC/CAD", "ETH/USD", "ETH/CAD", "BTC/COP"]
    summary_pairs = [best_for_pair(p) for p in key_pairs]

    # Derive USDT/COP vs USDT/CAD opportunity
    cop_entries = by_pair.get("USDT/COP", [])
    cad_entries = by_pair.get("USDT/CAD", [])

    cop_prices = [e["mid"] or e["ask"] or e["bid"] for e in cop_entries if (e.get("mid") or e.get("ask") or e.get("bid"))]
    cad_prices = [e["mid"] or e["ask"] or e["bid"] for e in cad_entries if (e.get("mid") or e.get("ask") or e.get("bid"))]

    cop_avg = sum(cop_prices) / len(cop_prices) if cop_prices else None
    cad_avg = sum(cad_prices) / len(cad_prices) if cad_prices else None

    # FX reference from exchangerate
    fx_usd_cop = next((r["mid"] for r in by_pair.get("USD/COP", []) if r.get("mid")), None)
    fx_usd_cad = next((r["mid"] for r in by_pair.get("USD/CAD", []) if r.get("mid")), None)
    fx_cop_cad = next((r["mid"] for r in by_pair.get("COP/CAD", []) if r.get("mid")), None)

    opportunity = None
    if cop_avg and cad_avg and fx_cop_cad:
        # 1 USDT in COP → convert to CAD → compare vs direct USDT/CAD
        usdt_in_cop = cop_avg
        cop_to_cad = usdt_in_cop / fx_cop_cad if fx_cop_cad else None
        if cop_to_cad and cad_avg:
            arb_spread = round((cad_avg - cop_to_cad) / cop_to_cad * 100, 3)
            opportunity = {
                "description": "Buy USDT with COP, sell USDT for CAD",
                "usdt_cop_avg": cop_avg,
                "usdt_cad_avg": cad_avg,
                "fx_cop_per_cad": fx_cop_cad,
                "usdt_in_cad_via_cop": round(cop_to_cad, 5) if cop_to_cad else None,
                "arb_spread_pct": arb_spread,
                "viable": arb_spread is not None and arb_spread > 1.0,
            }

    return {
        "fetched_at": now,
        "total_data_points": len(raw),
        "pairs": summary_pairs,
        "fx_reference": {
            "usd_cop": fx_usd_cop,
            "usd_cad": fx_usd_cad,
            "cop_per_cad": fx_cop_cad,
        },
        "opportunity": opportunity,
        "all_pairs_available": list(by_pair.keys()),
    }


@router.get("/history")
def get_history(pair: str = "USDT/COP", hours: int = 24, db: Session = Depends(get_db)):
    """Historical rate snapshots for a pair over the last N hours."""
    cutoff = datetime.utcnow() - timedelta(hours=hours)
    snaps = (
        db.query(ArbitrageSnapshot)
        .filter(
            ArbitrageSnapshot.pair == pair,
            ArbitrageSnapshot.fetched_at >= cutoff,
        )
        .order_by(ArbitrageSnapshot.fetched_at.asc())
        .all()
    )
    return [
        {
            "source": s.source,
            "pair": s.pair,
            "bid": s.bid,
            "ask": s.ask,
            "mid": s.mid,
            "fetched_at": s.fetched_at.isoformat(),
        }
        for s in snaps
    ]


@router.get("/sources")
async def get_sources():
    """List all configured data sources."""
    return {
        "sources": [
            {"id": "criptoya", "name": "CriptoYa", "description": "Aggregates LatAm P2P exchanges (Binance P2P, LocalBitcoins, etc)", "pairs": ["USDT/COP", "USDT/ARS", "BTC/COP"]},
            {"id": "exchangerate_api", "name": "ExchangeRate-API", "description": "Official FX rates, free tier", "pairs": ["USD/COP", "USD/CAD", "COP/CAD"]},
            {"id": "coingecko", "name": "CoinGecko", "description": "Crypto prices in multiple fiat currencies", "pairs": ["USDT/USD", "USDT/CAD", "USDT/COP", "BTC/USD", "BTC/CAD", "ETH/USD"]},
            {"id": "kraken", "name": "Kraken", "description": "Spot market order book", "pairs": ["BTC/USD", "ETH/USD", "BTC/CAD", "ETH/CAD"]},
            {"id": "binance", "name": "Binance Spot", "description": "Global exchange book ticker", "pairs": ["BTC/USDT", "ETH/USDT", "USDT/CAD"]},
            {"id": "binance_24h", "name": "Binance 24h", "description": "24-hour OHLCV stats", "pairs": ["BTC/USDT", "ETH/USDT"]},
            {"id": "coinbase", "name": "Coinbase", "description": "Spot prices in USD and CAD", "pairs": ["BTC/USD", "ETH/USD", "BTC/CAD", "ETH/CAD"]},
            {"id": "blockchain_info", "name": "Blockchain.info", "description": "BTC ticker reference", "pairs": ["BTC/USD", "BTC/CAD"]},
            {"id": "bitso", "name": "Bitso", "description": "Mexican exchange, MXN pairs", "pairs": ["USD/MXN", "BTC/MXN", "ETH/MXN"]},
        ]
    }


# ─────────────────────────────────────────────────────────────────────────────
# Operations (trade log)
# ─────────────────────────────────────────────────────────────────────────────

@router.post("/operations", response_model=OperationOut)
def create_operation(payload: OperationCreate, db: Session = Depends(get_db)):
    """Log a completed arbitrage trade."""
    net_profit = (payload.sell_price - payload.buy_price) * payload.amount_usdt - payload.fee_total
    net_profit_pct = (net_profit / (payload.buy_price * payload.amount_usdt)) * 100 if payload.buy_price > 0 else 0
    op = ArbitrageOperation(
        pair=payload.pair,
        buy_source=payload.buy_source,
        sell_source=payload.sell_source,
        buy_price=payload.buy_price,
        sell_price=payload.sell_price,
        amount_usdt=payload.amount_usdt,
        fee_total=payload.fee_total,
        net_profit=round(net_profit, 4),
        net_profit_pct=round(net_profit_pct, 4),
        notes=payload.notes,
    )
    db.add(op)
    db.commit()
    db.refresh(op)
    return OperationOut(
        id=op.id, pair=op.pair, buy_source=op.buy_source, sell_source=op.sell_source,
        buy_price=op.buy_price, sell_price=op.sell_price, amount_usdt=op.amount_usdt,
        fee_total=op.fee_total, net_profit=op.net_profit, net_profit_pct=op.net_profit_pct,
        status=op.status, notes=op.notes, created_at=op.created_at.isoformat(),
    )


@router.get("/operations", response_model=list[OperationOut])
def list_operations(limit: int = 50, db: Session = Depends(get_db)):
    ops = db.query(ArbitrageOperation).order_by(ArbitrageOperation.created_at.desc()).limit(limit).all()
    return [
        OperationOut(
            id=o.id, pair=o.pair, buy_source=o.buy_source, sell_source=o.sell_source,
            buy_price=o.buy_price, sell_price=o.sell_price, amount_usdt=o.amount_usdt,
            fee_total=o.fee_total, net_profit=o.net_profit, net_profit_pct=o.net_profit_pct,
            status=o.status, notes=o.notes, created_at=o.created_at.isoformat(),
        )
        for o in ops
    ]


@router.get("/p2p/book")
async def get_p2p_book(
    asset: str = "USDT",
    fiat: str = "COP",
    trade_type: str = "SELL",
    rows: int = 20,
    merchant_only: bool = False,
):
    """
    Fetch live P2P advertisers from Binance, OKX and KuCoin in parallel.
    trade_type: SELL = sellers (you want to BUY crypto), BUY = buyers (you want to SELL crypto).
    """
    results = await asyncio.gather(
        _fetch_binance_p2p(asset, fiat, trade_type, rows, merchant_only),
        _fetch_okx_p2p(asset, fiat, trade_type, rows),
        _fetch_kucoin_p2p(asset, fiat, trade_type, rows),
        return_exceptions=True,
    )

    all_ads = []
    errors = {}
    for source_name, result in zip(["binance", "okx", "kucoin"], results):
        if isinstance(result, Exception):
            errors[source_name] = str(result)
            log.warning(f"P2P {source_name} error: {result}")
        else:
            all_ads.extend(result)

    # Sort: SELL → cheapest first; BUY → most expensive first
    if trade_type.upper() == "SELL":
        all_ads.sort(key=lambda x: x["price"])
    else:
        all_ads.sort(key=lambda x: x["price"], reverse=True)

    return {
        "asset": asset.upper(),
        "fiat": fiat.upper(),
        "trade_type": trade_type.upper(),
        "count": len(all_ads),
        "fetched_at": datetime.utcnow().isoformat(),
        "errors": errors,
        "advertisers": all_ads,
    }


async def _fetch_binance_p2p(asset: str, fiat: str, trade_type: str, rows: int, merchant_only: bool) -> list[dict]:
    payload = {
        "asset": asset.upper(),
        "fiat": fiat.upper(),
        "merchantCheck": merchant_only,
        "page": 1,
        "payTypes": [],
        "publisherType": "merchant" if merchant_only else None,
        "rows": min(rows, 20),
        "tradeType": trade_type.upper(),
    }
    headers = {"Content-Type": "application/json", "User-Agent": "Mozilla/5.0"}
    async with httpx.AsyncClient() as client:
        r = await client.post(
            "https://p2p.binance.com/bapi/c2c/v2/friendly/c2c/adv/search",
            json=payload, headers=headers, timeout=TIMEOUT,
        )
    ads = r.json().get("data", [])
    result = []
    for item in ads:
        adv = item.get("adv", {})
        seller = item.get("advertiser", {})
        if not adv.get("isTradable"):
            continue
        pay_methods = [m.get("tradeMethodName", m.get("payType", "")) for m in adv.get("tradeMethods", [])]
        active_secs = seller.get("activeTimeInSecond")
        result.append({
            "exchange": "Binance P2P",
            "exchange_id": "binance",
            "adv_no": adv.get("advNo"),
            "price": float(adv.get("price", 0)),
            "available_usdt": float(adv.get("tradableQuantity", 0)),
            "min_fiat": float(adv.get("minSingleTransAmount", 0)),
            "max_fiat": float(adv.get("maxSingleTransAmount", 0)),
            "min_usdt": float(adv.get("minSingleTransQuantity", 0)),
            "max_usdt": float(adv.get("maxSingleTransQuantity", 0)),
            "pay_time_limit_min": adv.get("payTimeLimit"),
            "pay_methods": pay_methods,
            "is_tradable": True,
            "remarks": adv.get("remarks") or "",
            "seller_name": seller.get("nickName", ""),
            "seller_type": seller.get("userType", "user"),
            "seller_grade": seller.get("userGrade", 0),
            "is_merchant": seller.get("userType") == "merchant",
            "month_orders": seller.get("monthOrderCount", 0),
            "month_finish_rate": round((seller.get("monthFinishRate") or 0) * 100, 1),
            "positive_rate": round((seller.get("positiveRate") or 0) * 100, 1),
            "active_label": _active_label(active_secs),
            "active_secs": active_secs,
            "link": f"https://p2p.binance.com/en/advertiserDetail?advertiserNo={seller.get('userNo')}",
        })
    return result


async def _fetch_okx_p2p(asset: str, fiat: str, trade_type: str, rows: int) -> list[dict]:
    # OKX side: sell = sellers list, buy = buyers list
    side = "sell" if trade_type.upper() == "SELL" else "buy"
    url = (
        f"https://www.okx.com/v3/c2c/tradingOrders/books"
        f"?quoteCurrency={fiat.lower()}&baseCurrency={asset.lower()}"
        f"&side={side}&paymentMethod=0&userType=all"
        f"&showTrade=false&showFollow=false&showAlreadyTraded=false&isAbleFilter=false"
        f"&limit={min(rows, 20)}&offset=0"
    )
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"}
    async with httpx.AsyncClient() as client:
        r = await client.get(url, headers=headers, timeout=TIMEOUT)
    data = r.json()
    ads = data.get("data", {}).get(side, [])
    result = []
    for item in ads:
        if not item.get("receivingAds", True) and side == "sell":
            pass  # still include
        pay_str = item.get("paymentMethods", "")
        if isinstance(pay_str, list):
            pay_methods = [p.strip() for p in pay_str if p.strip()]
        elif isinstance(pay_str, str):
            pay_methods = [p.strip() for p in pay_str.split() if p.strip()]
        else:
            pay_methods = []
        completed = item.get("completedOrderQuantity", 0)
        completion_rate = float(item.get("completedRate", 0)) * 100
        result.append({
            "exchange": "OKX P2P",
            "exchange_id": "okx",
            "adv_no": str(item.get("id", "")),
            "price": float(item.get("price", 0)),
            "available_usdt": float(item.get("availableAmount", 0)),
            "min_fiat": float(item.get("quoteMinAmountPerOrder", 0)),
            "max_fiat": float(item.get("quoteMaxAmountPerOrder", 0)),
            "min_usdt": 0.0,
            "max_usdt": float(item.get("availableAmount", 0)),
            "pay_time_limit_min": item.get("paymentTimeoutMinutes"),
            "pay_methods": pay_methods,
            "is_tradable": True,
            "remarks": "",
            "seller_name": item.get("nickName", ""),
            "seller_type": item.get("creatorType", ""),
            "seller_grade": 3 if item.get("creatorType") == "diamond" else 2,
            "is_merchant": item.get("creatorType") in ("diamond", "certified"),
            "month_orders": completed,
            "month_finish_rate": round(completion_rate, 1),
            "positive_rate": round(float(item.get("posReviewPercentage", 0) or 0), 1) if item.get("posReviewPercentage") not in (None, "-1") else 0,
            "active_label": "OKX online",
            "active_secs": None,
            "link": f"https://www.okx.com/p2p/ads-merchant?publicUserId={item.get('publicUserId')}",
        })
    return result


async def _fetch_kucoin_p2p(asset: str, fiat: str, trade_type: str, rows: int) -> list[dict]:
    # KuCoin side: SELL = sellers (you buy), BUY = buyers (you sell)
    side = "SELL" if trade_type.upper() == "SELL" else "BUY"
    url = (
        f"https://www.kucoin.com/_api/otc/ad/list"
        f"?currency={asset.upper()}&legal={fiat.upper()}"
        f"&side={side}&page=1&pageSize={min(rows, 20)}"
    )
    headers = {"User-Agent": "Mozilla/5.0", "Accept": "application/json"}
    async with httpx.AsyncClient() as client:
        r = await client.get(url, headers=headers, timeout=TIMEOUT)
    data = r.json()
    items = data.get("items", [])
    result = []
    for item in items:
        # adPayTypes is list of dicts-like strings; parse payTypeNameEn
        raw_pays = item.get("adPayTypes", [])
        pay_methods = []
        for p in raw_pays:
            if isinstance(p, dict):
                pay_methods.append(p.get("payTypeNameEn", p.get("payTypeCode", "")))
            elif isinstance(p, str):
                # powershell formatted: "@{...payTypeNameEn=Nequi...}"
                import re
                m = re.search(r'payTypeNameEn=([^;}\s]+)', p)
                if m:
                    pay_methods.append(m.group(1))

        last_active = item.get("lastActiveDesc", "")
        active_online = item.get("lastActiveStatus", "") == "Online"
        finish_rate_str = item.get("dealOrderRate", "0%").replace("%", "")
        result.append({
            "exchange": "KuCoin P2P",
            "exchange_id": "kucoin",
            "adv_no": str(item.get("id", "")),
            "price": float(item.get("floatPrice", 0) or item.get("premium", 0)),
            "available_usdt": float(item.get("currencyBalanceQuantity", 0)),
            "min_fiat": float(item.get("fiatMinAmount", 0) or item.get("limitMinQuote", 0)),
            "max_fiat": float(item.get("limitMaxQuote", 0)),
            "min_usdt": float(item.get("cryptoMinAmount", 0)),
            "max_usdt": float(item.get("currencyBalanceQuantity", 0)),
            "pay_time_limit_min": item.get("tradeTimeLimit"),
            "pay_methods": pay_methods,
            "is_tradable": item.get("displayStatus") == "NORMAL",
            "remarks": item.get("remarks", "")[:200] if item.get("remarks") else "",
            "seller_name": item.get("nickName", ""),
            "seller_type": "merchant" if item.get("goldMerchants") else "user",
            "seller_grade": 3 if item.get("goldMerchants") else 2,
            "is_merchant": bool(item.get("goldMerchants")),
            "month_orders": int(item.get("dealOrderNum", 0) or 0),
            "month_finish_rate": round(float(finish_rate_str), 1) if finish_rate_str else 0,
            "positive_rate": 0,
            "active_label": "Online" if active_online else last_active,
            "active_secs": 0 if active_online else None,
            "link": f"https://www.kucoin.com/otc/buy/{asset.upper()}",
        })
    return result


def _active_label(active_secs: int | None) -> str:
    if active_secs is None:
        return "unknown"
    if active_secs < 60:
        return f"{active_secs}s ago"
    if active_secs < 3600:
        return f"{active_secs // 60}m ago"
    if active_secs < 86400:
        return f"{active_secs // 3600}h ago"
    return f"{active_secs // 86400}d ago"


@router.get("/operations/stats")
def operations_stats(db: Session = Depends(get_db)):
    """Aggregate stats: total profit, ROI, best/worst trade."""
    ops = db.query(ArbitrageOperation).all()
    if not ops:
        return {"total_trades": 0, "total_profit": 0, "avg_profit_pct": 0}
    total_profit = sum(o.net_profit for o in ops)
    total_invested = sum(o.buy_price * o.amount_usdt for o in ops)
    avg_pct = sum(o.net_profit_pct for o in ops) / len(ops)
    best = max(ops, key=lambda o: o.net_profit_pct)
    worst = min(ops, key=lambda o: o.net_profit_pct)
    return {
        "total_trades": len(ops),
        "total_profit": round(total_profit, 4),
        "total_invested": round(total_invested, 4),
        "roi_pct": round(total_profit / total_invested * 100, 3) if total_invested else 0,
        "avg_profit_pct": round(avg_pct, 3),
        "best_trade": {"id": best.id, "profit_pct": best.net_profit_pct, "pair": best.pair},
        "worst_trade": {"id": worst.id, "profit_pct": worst.net_profit_pct, "pair": worst.pair},
    }
