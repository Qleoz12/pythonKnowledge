# pip install yfinance pandas openpyxl
import random

import yfinance as yf
import pandas as pd
from datetime import datetime, timezone

TICKERS = [
  "ECC","EIC","UG","LPG","MPLX","GLP","OHI","CQP","PZZA","DLX","BX","HAFC","MATW","WTRG","LAZ",
  "HTO","GROW","HBT","CWT","BSRR","MRBK","ETR","WBS","HBCP","LVS","MNSB","SFBC","CBNK","AMP","RBA",
  "HXL","GWW","AAPL","NMM","TLF","ETD","TEN","NOMD","BCBP","SIRI","KVUE","TGT","WTBA","AROW","HOMB",
  "PCAR","UVSP","SLB","CBAN","WNEB","JMSB","SIMO","ST","URI","WINA","WT","KINS","WLFC","NBN",
  "GGT","EDF","PDI","PCM","PGZ","VGI","PHK","PFN","PFL","PAXS","PTY","PDO","PCN","NCV","GUT","NCZ",
  "GHY","EAD","HPF","ERC","HPI","ZTR","HPS","PGP","ISD","RCS","ERH","ACV","SDHY","AIO","PDT","HTD",
  "PDX","GGN","GNT","PML","GLU","GDV","TSI","TBLD","PNI","PCQ","DSM","LEO","NFBK","UTL","PROV",
  "STBA","LARK","ZION","CCIF","NHTC","XFLT","HRZN","CRF","CLM","PNNT","ARR","NHS","VVR","SPE","PFLT","MCN","NXG","SRV",
  "NRO","PCF","DMA","VLT","CIF","DHY","NBXG","EFT","EFR","CIK","MIN","ETJ","MCR","MMT","ETW","ETB","EOS","EXG","ETV",
    "EVG","ETY","EOI","VKQ","HIW","MGF","VMO","IQI","VGM","EVT","VPV","VKI","NML","IIM","ALX","VCV","VTN","ETO","OMF",
    "ETG","EIM","SXC","EQNR","UMH","UPS","OIA","CXE","VBF","PRU","ENB","CMU","MFM","ETX","EOT","CXH","MUR","KMPR","SW",
    "CVX","BKH","MC","PECO","DTF","FTS","SO","ADM","CMS","SWX","TRI","JEF","MSEX","BG","NRP","USCB","SPB","HSY","MTG",
    "BOTJ","NATH","WMK","RGA","BKR","AIZ","OSK","CSL","EQT","IPO",
    "AB","ACP","AGD","AOD","AOMR","ARDC","ASGI","ATMU","AUDC","AWP","AZN","BBWI","BCS","BGB","BGX","BHB","BP","BSL","BWG",
    "CBC","CMI","DFP","DMO","EHI","EMD","EMO","FAX","FBIN","FCO","FFC","FLC","FSCO","FSSL","FT","FTF","GDO","GLDI",
    "GOLD","GSK","HCI","HFRO","HGLB","HIO","HIX","HQH","HQL","HYI","IAF","IFN","IGI","AEIS","ATO","AWR","BC","BCC","BTU",
    "CNA","DAC","DLNG","DX","FMN","HCC","IP","IRMD","MCHP","MEGI","MKSI","NOC","NTB","PATK","PRI","PSX","RDN","ROK","TROX",

]

def _to_date(x):
    if x is None or (isinstance(x, float) and pd.isna(x)):
        return None
    if isinstance(x, (pd.Timestamp, datetime)):
        return x.date().isoformat()
    try:
        return pd.to_datetime(x).date().isoformat()
    except Exception:
        return str(x)

def _get_next_dividend_payment(tkr: yf.Ticker):
    """
    Best-effort:
    - yfinance sometimes provides dividendDate (next or last, depends on ticker)
    - If missing, fall back to last known dividends history as "last payment date"
    """
    info = {}
    try:
        info = tkr.get_info() or {}
    except Exception:
        info = {}

    dividend_date = info.get("dividendDate")  # unix seconds or datetime depending on backend
    ex_div_date = info.get("exDividendDate")

    # Convert unix timestamps if needed
    def conv_unix(v):
        if v is None:
            return None
        if isinstance(v, (int, float)) and v > 10_000_000:  # likely unix
            return datetime.fromtimestamp(v, tz=timezone.utc).date().isoformat()
        return _to_date(v)

    dividend_date = conv_unix(dividend_date)
    ex_div_date = conv_unix(ex_div_date)

    # If dividendDate missing, use last dividend payment from history (not always "payment date", but best available)
    last_div_date = None
    last_div_amt = None
    try:
        divs = tkr.dividends
        if divs is not None and len(divs) > 0:
            last_div_date = divs.index[-1].date().isoformat()
            last_div_amt = float(divs.iloc[-1])
    except Exception:
        pass

    return dividend_date, ex_div_date, last_div_date, last_div_amt

rows = []
for sym in TICKERS:
    try:
        t = yf.Ticker(sym)
        info = t.get_info() or {}

        price = info.get("currentPrice") or info.get("regularMarketPrice")
        high52 = info.get("fiftyTwoWeekHigh")
        low52 = info.get("fiftyTwoWeekLow")

        dividend_date, ex_div_date, last_div_date, last_div_amt = _get_next_dividend_payment(t)

        rows.append({
            "ticker": sym,
            "price": price,
            "52w_high": high52,
            "52w_low": low52,
            "ex_dividend_date": ex_div_date,
            "dividend_payment_date": dividend_date,   # may be next or last depending on availability
            "last_dividend_date": last_div_date,      # fallback if payment date missing
            "last_dividend_per_share": last_div_amt,  # fallback
            "currency": info.get("currency"),
            "exchange": info.get("exchange"),
        })

    except Exception as e:
        rows.append({
            "ticker": sym,
            "price": None,
            "52w_high": None,
            "52w_low": None,
            "ex_dividend_date": None,
            "dividend_payment_date": None,
            "last_dividend_date": None,
            "last_dividend_per_share": None,
            "currency": None,
            "exchange": None,
            "error": str(e)
        })

df = pd.DataFrame(rows)

# Parse ex-date to datetime for correct sorting
df["ex_dividend_date_dt"] = pd.to_datetime(df["ex_dividend_date"], errors="coerce")

# Sort: ex-date DESC (latest first), then 52w_low ASC (lower lows first)
df = df.sort_values(
    by=["ex_dividend_date_dt", "52w_low", "ticker"],
    ascending=[False, True, True],
    na_position="last"
).drop(columns=["ex_dividend_date_dt"])


# Save outputs
rand = random.randint(1000, 9999)
date_str = datetime.now().strftime("%Y%m%d")

csv_name = f"tickers_dividend_snapshot_{date_str}_{rand}.csv"
xlsx_name = f"tickers_dividend_snapshot_{date_str}_{rand}.xlsx"

# Save outputs
df.to_csv(csv_name, index=False)
df.to_excel(xlsx_name, index=False)

print(df.head(15))
print("\nSaved: tickers_dividend_snapshot.csv and tickers_dividend_snapshot.xlsx")
