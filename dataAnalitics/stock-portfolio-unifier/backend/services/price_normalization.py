"""
Yahoo-based fundamentals bundle for stock detail ("normalización de precio"):
scaled ratios, dividend score, TTM from quarterly statements, 1Y vol — live fetch, not DB-backed.
"""
from __future__ import annotations

from typing import Any, List, Optional

import numpy as np
import pandas as pd


def ttm_from_quarterly(qf: Optional[pd.DataFrame], row_candidates: List[str]) -> Optional[float]:
    if qf is None or qf.empty:
        return None
    row_name = next((n for n in row_candidates if n in qf.index), None)
    if row_name is None:
        return None
    s = qf.loc[row_name].dropna()
    if len(s) < 4:
        return None
    return finite_float(s.iloc[:4].sum())


def finite_float(x: Any) -> Optional[float]:
    """Coerce to float; None if missing, NaN, or not finite (JSON-safe for FastAPI)."""
    if x is None:
        return None
    if isinstance(x, (int, np.integer)) and not isinstance(x, bool):
        return float(x)
    if isinstance(x, (float, np.floating)):
        v = float(x)
        return v if np.isfinite(v) else None
    try:
        v = float(x)
    except (TypeError, ValueError):
        return None
    return v if np.isfinite(v) else None


def safe_get(info: dict, keys: List[str]) -> Optional[Any]:
    for k in keys:
        v = info.get(k)
        if v is not None and pd.notna(v):
            return v
    return None


def compute_div_growth_5y_cagr(div_series: Optional[pd.Series]) -> Optional[float]:
    """5Y dividend CAGR from annualized dividend sums. Decimal (0.08 = 8%)."""
    if div_series is None or div_series.empty:
        return None
    div_series = div_series.dropna()
    if div_series.empty:
        return None
    annual = div_series.resample("YE").sum()
    annual = annual[annual > 0]
    if len(annual) < 6:
        return None
    end = float(annual.iloc[-1])
    start = float(annual.iloc[-6])
    if start <= 0 or end <= 0:
        return None
    return float((end / start) ** (1 / 5) - 1)


def compute_volatility_1y(history_df: Optional[pd.DataFrame]) -> Optional[float]:
    """Annualized vol: std(daily returns) * sqrt(252). Decimal (0.25 = 25%)."""
    if history_df is None or history_df.empty or "Close" not in history_df.columns:
        return None
    close = history_df["Close"].dropna()
    if len(close) < 30:
        return None
    rets = close.pct_change().dropna()
    if rets.empty:
        return None
    return finite_float(rets.std(ddof=0) * np.sqrt(252))


def clamp(x: Optional[float], lo: float, hi: float) -> Optional[float]:
    if x is None or pd.isna(x):
        return None
    return max(lo, min(hi, float(x)))


def dividend_score(
    dividend_yield: Optional[float],
    payout_ratio: Optional[float],
    div_growth_5y: Optional[float],
    volatility: Optional[float],
    beta: Optional[float],
) -> Optional[float]:
    """0–100 composite; None if no usable inputs."""
    if all(v is None for v in [dividend_yield, payout_ratio, div_growth_5y, volatility, beta]):
        return None

    y = clamp(dividend_yield, 0, 0.10)
    g = clamp(div_growth_5y, -0.10, 0.20)
    p = clamp(payout_ratio, 0, 1.2)
    v = clamp(volatility, 0.10, 0.60)
    b = clamp(beta, 0.5, 2.0)

    yield_s = (y / 0.10) if y is not None else None
    growth_s = ((g + 0.10) / 0.30) if g is not None else None

    if p is None:
        payout_s = None
    else:
        payout_s = 1.0 if p <= 0.60 else max(0.0, 1.0 - (p - 0.60) / 0.60)

    vol_s = (1.0 - (v - 0.10) / 0.50) if v is not None else None
    beta_s = (1.0 - (b - 0.5) / 1.5) if b is not None else None

    parts: List[float] = []
    weights: List[float] = []

    def add_part(val: Optional[float], w: float) -> None:
        if val is not None and not pd.isna(val):
            parts.append(float(val) * w)
            weights.append(w)

    add_part(yield_s, 0.30)
    add_part(growth_s, 0.25)
    add_part(payout_s, 0.20)
    add_part(vol_s, 0.15)
    add_part(beta_s, 0.10)

    if not weights:
        return None
    score_0_1 = sum(parts) / sum(weights)
    return finite_float(score_0_1 * 100)


def _parse_yield_decimal(raw: Optional[float]) -> Optional[float]:
    """
    yfinance usually returns decimal (0.0415 = 4.15%).
    Some responses use whole percent (4.15); values > 1 are treated as percent / 100.
    """
    if raw is None or pd.isna(raw):
        return None
    try:
        v = float(raw)
    except (TypeError, ValueError):
        return None
    if v > 1.0:
        v = v / 100.0
    return v


def _parse_payout_decimal(raw: Optional[float]) -> Optional[float]:
    """Same percent-vs-decimal ambiguity for payoutRatio when Yahoo sends 55 instead of 0.55."""
    if raw is None or pd.isna(raw):
        return None
    try:
        v = float(raw)
    except (TypeError, ValueError):
        return None
    if v > 1.5:
        v = v / 100.0
    return v


def compute_for_ticker(ticker_yf: str) -> dict:
    import yfinance as yf

    t = yf.Ticker(ticker_yf)
    info = t.info or {}

    company_name = safe_get(info, ["shortName", "longName", "displayName"])
    symbol = info.get("symbol") or ticker_yf
    sector = info.get("sector")
    industry = info.get("industry")
    market_cap = info.get("marketCap")
    pbr = info.get("priceToBook")
    price = safe_get(info, ["currentPrice", "regularMarketPrice", "previousClose"])

    dividend_yield = _parse_yield_decimal(info.get("dividendYield"))

    pr = info.get("payoutRatio")
    payout_ratio = _parse_payout_decimal(float(pr)) if pr is not None and pd.notna(pr) else None

    bt = info.get("beta")
    beta = finite_float(bt) if bt is not None and pd.notna(bt) else None

    forward_pe = finite_float(info.get("forwardPE"))

    qf = t.quarterly_financials
    net_income_ttm = ttm_from_quarterly(
        qf,
        ["Net Income", "Net Income Common Stockholders", "Net Income From Continuing Operations"],
    )
    ebitda_ttm = ttm_from_quarterly(qf, ["EBITDA"])

    bs = t.balance_sheet
    balance_date = None
    net_debt = None
    if bs is not None and not bs.empty:
        latest = bs.columns[0]
        balance_date = pd.to_datetime(latest).date().isoformat()
        if "Net Debt" in bs.index:
            try:
                net_debt = finite_float(bs.loc["Net Debt", latest])
            except (TypeError, ValueError, KeyError):
                net_debt = None

    divs = t.dividends
    div_growth_5y = compute_div_growth_5y_cagr(divs)

    hist = t.history(period="1y", interval="1d", auto_adjust=False)
    volatility = compute_volatility_1y(hist)

    div_score = dividend_score(dividend_yield, payout_ratio, div_growth_5y, volatility, beta)

    return {
        "ticker_yf": ticker_yf,
        "company_name": company_name,
        "symbol": symbol,
        "sector": sector,
        "industry": industry,
        "price": finite_float(price) if price is not None and pd.notna(price) else None,
        "market_cap": finite_float(market_cap) if market_cap is not None and pd.notna(market_cap) else None,
        "dividend_yield": finite_float(dividend_yield),
        "payout_ratio": finite_float(payout_ratio),
        "div_growth_5y_cagr": finite_float(div_growth_5y),
        "volatility_1y": finite_float(volatility),
        "beta": beta,
        "dividend_score": finite_float(div_score),
        "forward_pe": forward_pe,
        "net_income_ttm": finite_float(net_income_ttm),
        "ebitda_ttm": finite_float(ebitda_ttm),
        "net_debt": net_debt,
        "balance_sheet_date": balance_date,
        "price_to_book": finite_float(pbr) if pbr is not None and pd.notna(pbr) else None,
    }
