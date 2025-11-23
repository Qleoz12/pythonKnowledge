import math
import datetime as dt
from typing import Dict, Any
import numpy as np
import pandas as pd
import yfinance as yf

TICKERS = ["jepq","ARR","DX","PSEC","AGNC","PFLT","EFC","CSWC","APLE","LTC"]

# Overrides por si Yahoo no trae sector/industria:
SECTOR_OVERRIDE = {
    "jepq": ("REIT hipotecario (mREIT)", "Financial / Mortgage REIT"),
    "ARR": ("REIT hipotecario (mREIT)", "Financial / Mortgage REIT"),
    "DX":  ("REIT hipotecario (mREIT)", "Financial / Mortgage REIT"),
    "AGNC":("REIT hipotecario (mREIT)", "Financial / Mortgage REIT"),
    "EFC": ("REIT híbrido",            "Financial / Mortgage Credit"),
    "APLE":("REIT hotelero",           "Real Estate / Hospitality"),
    "LTC": ("REIT salud/senior housing","Real Estate / Healthcare"),
    "PSEC":("BDC",                     "Financial / Private Credit"),
    "PFLT":("BDC",                     "Financial / Floating Rate"),
    "CSWC":("BDC",                     "Financial / Private Credit"),
}

def safe_get(d: Dict[str, Any], key: str, default=None):
    try:
        v = d.get(key, default)
        if isinstance(v, (int, float)) and (v is None or np.isnan(v)):
            return default
        return v if v not in ("", None) else default
    except Exception:
        return default

def billions(x):
    if x is None or np.isnan(x):
        return None
    return float(x)/1e9

def pct(x):
    return None if x is None or np.isnan(x) else float(x)*100.0

def infer_div_freq(dividends: pd.Series) -> str:
    """Detecta frecuencia a partir de cantidad de pagos últimos 12 meses."""
    if dividends is None or dividends.empty:
        return "—"
    now = dividends.index.max()
    year_ago = now - pd.Timedelta(days=365)
    last12 = dividends[dividends.index >= year_ago]
    n = last12.shape[0]
    if n >= 10:
        return "Mensual"
    if 3 <= n <= 5:
        return "Trimestral"
    if 1 <= n <= 2:
        return "Anual/Semestral"
    return "—"

def ttm_dividend(dividends: pd.Series) -> float:
    if dividends is None or dividends.empty:
        return None
    now = dividends.index.max()
    year_ago = now - pd.Timedelta(days=365)
    return float(dividends[dividends.index >= year_ago].sum())

def five_year_cagr(dividends: pd.Series) -> float:
    """Crecimiento compuesto a 5 años: compara suma anualizada actual vs hace 5 años (±6 meses)."""
    if dividends is None or dividends.empty:
        return None
    end = dividends.index.max()
    start_window_center = end - pd.DateOffset(years=5)
    # Ventana de 12 meses alrededor del punto de hace 5 años
    start_from = start_window_center - pd.Timedelta(days=365/2)
    start_to   = start_window_center + pd.Timedelta(days=365/2)

    start_sum = float(dividends[(dividends.index >= start_from) & (dividends.index <= start_to)].sum())
    end_sum   = ttm_dividend(dividends)

    if start_sum and end_sum and start_sum > 0:
        years = 5.0
        return (end_sum / start_sum) ** (1/years) - 1
    return None

def volatility_1y(hist: pd.DataFrame) -> float:
    """Volatilidad anualizada usando rendimientos diarios 1Y (σ * sqrt(252))."""
    if hist is None or hist.empty or 'Close' not in hist:
        return None
    prices = hist['Close'].dropna()
    if prices.size < 30:
        return None
    rets = prices.pct_change().dropna()
    return float(rets.std() * np.sqrt(252) * 100.0)

def fiftytwo_week_range(hist: pd.DataFrame) -> str:
    if hist is None or hist.empty or 'Close' not in hist:
        return "—"
    last = hist.index.max()
    first = last - pd.Timedelta(days=365)
    span = hist[(hist.index >= first) & (hist.index <= last)]
    if span.empty:
        return "—"
    lo = float(span['Close'].min())
    hi = float(span['Close'].max())
    return f"{lo:.2f}–{hi:.2f}"

def build_row_csv(ticker: str) -> str:
    tk = yf.Ticker(ticker)
    info = tk.info or {}

    hist = tk.history(period="1y", auto_adjust=False)
    price = float(hist["Close"].iloc[-1]) if not hist.empty else safe_get(info, "currentPrice")

    div = tk.dividends
    mcap_b = billions(safe_get(info, "marketCap"))
    beta = safe_get(info, "beta")
    pe = safe_get(info, "trailingPE")
    dte = safe_get(info, "debtToEquity")
    eps_ttm = safe_get(info, "trailingEps")
    div_ttm = ttm_dividend(div)

    payout = (div_ttm / eps_ttm) * 100.0 if eps_ttm and eps_ttm > 0 and div_ttm else None
    yield_pct = (div_ttm / price) * 100.0 if price and div_ttm else None
    vol_pct = volatility_1y(hist)
    freq = infer_div_freq(div)
    cagr5 = five_year_cagr(div)

    sector, industry = SECTOR_OVERRIDE.get(ticker.upper(), (safe_get(info, "sector"), safe_get(info, "industry")))
    rango52 = fiftytwo_week_range(hist)

    # Construir la línea CSV separada por comas
    row = ",".join([
        ticker.upper(),
        f'"{sector or "—"}"',
        f'{round(mcap_b, 2) if mcap_b else ""}',
        f'{round(yield_pct, 2) if yield_pct else ""}',
        f'{freq}',
        f'{(cagr5*100):.2f}' if cagr5 else "",
        f'{round(beta, 2) if beta else ""}',
        f'{round(vol_pct, 2) if vol_pct else ""}',
        f'{round(payout, 1) if payout else ""}',
        f'{round(dte, 2) if dte else ""}',
        f'{round(pe, 2) if pe else ""}',
        f'{round(price, 2) if price else ""}',
        f'"{rango52}"'
    ])

    return row


def build_row(ticker: str) -> Dict[str, Any]:
    tk = yf.Ticker(ticker)
    info = tk.info or {}

    # Precio e histórico 1Y
    hist = tk.history(period="1y", auto_adjust=False)
    price = None
    try:
        price = float(hist["Close"].iloc[-1])
    except Exception:
        price = safe_get(info, "currentPrice")

    # Dividends series (yfinance ya da serie por fecha)
    div = tk.dividends
    # Métricas
    mcap_b = billions(safe_get(info, "marketCap"))
    beta = safe_get(info, "beta") or safe_get(info, "beta3Year") or safe_get(info, "betaFiveYear")
    pe = safe_get(info, "trailingPE")
    dte = safe_get(info, "debtToEquity")
    payout = None
    eps_ttm = safe_get(info, "trailingEps")
    div_ttm = ttm_dividend(div)
    if eps_ttm and eps_ttm > 0 and div_ttm:
        payout = (div_ttm / eps_ttm) * 100.0

    yield_pct = None
    if price and div_ttm:
        yield_pct = (div_ttm / price) * 100.0

    vol_pct = volatility_1y(hist)
    freq = infer_div_freq(div)
    cagr5 = five_year_cagr(div)

    # Sector / overrides
    sector = safe_get(info, "sector")
    industry = safe_get(info, "industry")
    if ticker.upper() in SECTOR_OVERRIDE:
        sector, industry = SECTOR_OVERRIDE[ticker.upper()]

    return {
        "Ticker": ticker.upper(),
        "Sector": sector or "—",
        "Market Cap (B)": None if mcap_b is None else round(mcap_b, 2),
        "Yield (%)": None if yield_pct is None else round(yield_pct, 2),
        "Div. Freq": freq,
        "5Y Div Growth": "—" if cagr5 is None else f"{cagr5*100:.2f}",
        "Beta": None if beta is None else round(float(beta), 2),
        "Volatilidad (%)": None if vol_pct is None else round(vol_pct, 2),
        "Payout Ratio (%)": None if payout is None else round(payout, 1),
        "Debt/Equity": "—" if dte is None else round(float(dte), 2),
        "P/E": "—" if pe is None or (isinstance(pe, float) and (math.isinf(pe) or np.isnan(pe))) else round(float(pe), 2),
        "Precio": None if price is None else round(price, 2),
        "Rango 52W": fiftytwo_week_range(hist),
    }

rows = [build_row(t) for t in TICKERS]
df = pd.DataFrame(rows, columns=[
    "Ticker","Sector","Market Cap (B)","Yield (%)","Div. Freq","5Y Div Growth",
    "Beta","Volatilidad (%)","Payout Ratio (%)","Debt/Equity","P/E","Precio","Rango 52W"
])

# Ordenar por ticker
df = df.sort_values("Ticker").reset_index(drop=True)

print(df.to_string(index=False))

# Exporta
csv_path = "dividend_table.csv"
xlsx_path = "dividend_table.xlsx"
df.to_csv(csv_path, index=False, encoding="utf-8-sig")
with pd.ExcelWriter(xlsx_path, engine="openpyxl") as w:
    df.to_excel(w, index=False, sheet_name="Dividendos")

print(f"\nGuardado: {csv_path} / {xlsx_path}")
