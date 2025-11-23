#!/usr/bin/env python3
"""
JEPQ daily (last 3y) with horizontal scrolling:
- Calendar-day X-axis (equal spacing per day)
- Blue continuous Close line (weekends/holidays filled)
- Blue vertical line per trading day at the Close
- SMA(50/200)
- Annotate lowest closes by year (configurable)
- Slider to scroll horizontally + slider to change window size (days)

Install:
    pip install yfinance pandas matplotlib

Usage examples:
    python jepq_scroll.py
    python jepq_scroll.py --ticker JEPQ --period 3y --n_lows 5 --years 2022 2023 2024 --window_days 180
"""

import argparse
import os
from datetime import datetime
import pandas as pd
import yfinance as yf
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.widgets import Slider


def fetch_history(ticker: str, period: str = "5y", interval: str = "1d") -> pd.DataFrame:
    t = yf.Ticker(ticker)
    df = t.history(period=period, interval=interval, auto_adjust=False)
    df = df.dropna(how="all")
    if not isinstance(df.index, pd.DatetimeIndex):
        df.index = pd.to_datetime(df.index)
    return df


def annotate_year_lows(ax, df_trading: pd.DataFrame, year: int, n_lows: int = 5):
    """Annotate the n lowest closes for a given year (uses trading-day data)."""
    year_df = df_trading[df_trading.index.year == year]
    if year_df.empty:
        return
    lows = year_df.nsmallest(n_lows, "Close")
    for i, (date, row) in enumerate(lows.iterrows()):
        ax.scatter(date, row["Close"], zorder=6)
        y_offset = -28 - (i * 15)  # stack labels vertically
        ax.annotate(
            f"{row['Close']:.2f}\n{date:%Y-%m-%d}",
            xy=(date, row["Close"]),
            xytext=(0, y_offset),
            textcoords="offset points",
            ha="center",
            fontsize=8,
            arrowprops=dict(arrowstyle="->", lw=0.7)
        )
        ax.axvline(date, alpha=0.15, linewidth=0.8, zorder=1)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ticker", default="JEPQ", help="Ticker symbol")
    ap.add_argument("--period", default="5y", help="History period (e.g., 1y, 2y, 3y, max)")
    ap.add_argument("--interval", default="1d", help="Data interval (e.g., 1d, 1wk, 1mo)")
    ap.add_argument("--outfile", default=None, help="Path to save a PNG (optional)")
    ap.add_argument("--csv", default=None, help="Path to save raw trading-day CSV (optional)")
    ap.add_argument("--n_lows", type=int, default=5, help="How many lows to label per year")
    ap.add_argument("--years", nargs="*", type=int, default=[2022, 2023, 2024],
                    help="Years to annotate")
    ap.add_argument("--window_days", type=int, default=180,
                    help="Initial visible window size (in days) for the slider")
    ap.add_argument("--stems", type=int, default=1,
                    help="1=draw vertical blue stems per trading day, 0=off")
    args = ap.parse_args()

    # ---- Fetch ----
    df = fetch_history(args.ticker, args.period, args.interval)
    if df.empty:
        raise SystemExit(f"No data for {args.ticker} with period={args.period} interval={args.interval}")

    # ---- Indicators (trading days) ----
    df["Close_SMA50"] = df["Close"].rolling(50).mean()
    df["Close_SMA200"] = df["Close"].rolling(200).mean()

    # ---- Calendar-day index for equal spacing ----
    full_idx = pd.date_range(df.index.min().date(), df.index.max().date(), freq="D")
    df_cal = df.reindex(full_idx)
    df_cal_filled = df_cal.copy()
    df_cal_filled["Close"] = df_cal_filled["Close"].ffill().bfill()

    # ---- Plot (with space reserved for sliders) ----
    title = f"{args.ticker} — Daily Close (last {args.period}) • Updated {datetime.now().date()}"

    fig = plt.figure(figsize=(24, 8))
    # axes: left, bottom, width, height (in figure coords)
    ax = fig.add_axes([0.06, 0.20, 0.90, 0.72])   # main plot area

    # Blue stems per trading day (optional)
    if args.stems:
        baseline = df["Close"].min() * 0.98
        ax.vlines(df.index, ymin=baseline, ymax=df["Close"],
                  linewidth=0.4, alpha=0.5, color="blue", zorder=2)

    # Continuous close line (calendar days)
    line_close, = ax.plot(df_cal_filled.index, df_cal_filled["Close"],
                          linewidth=1.8, color="blue", label="Close", zorder=3)

    # SMAs (trading days)
    ax.plot(df.index, df["Close_SMA50"], label="SMA 50d", zorder=4)
    ax.plot(df.index, df["Close_SMA200"], label="SMA 200d", zorder=1)

    # Annotations (they’ll be visible when in view)
    for yr in args.years:
        annotate_year_lows(ax, df, yr, n_lows=args.n_lows)

    # X-axis formatting (calendar days)
    ax.xaxis.set_major_locator(mdates.MonthLocator(interval=2))
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y-%m"))
    ax.xaxis.set_minor_locator(mdates.WeekdayLocator(byweekday=mdates.MO))
    fig.autofmt_xdate()

    ax.grid(True, which="major", axis="y", alpha=0.25)
    ax.set_title(title)
    ax.set_xlabel("Date")
    ax.set_ylabel("Price (USD)")
    ax.legend(loc="upper left")

    # ---- Sliders for horizontal scrolling and window size ----
    # Slider axes
    ax_pos = fig.add_axes([0.06, 0.10, 0.70, 0.04])   # timeline position
    ax_win = fig.add_axes([0.80, 0.10, 0.16, 0.04])   # window size

    # Convert dates to ordinals for slider math
    start_ord = df_cal_filled.index.min().toordinal()
    end_ord = df_cal_filled.index.max().toordinal()
    full_days = end_ord - start_ord + 1

    # Initial window
    window_days = max(15, min(args.window_days, full_days))
    left_ord_init = end_ord - window_days
    right_ord_init = end_ord

    # Create sliders
    pos_slider = Slider(
        ax=ax_pos, label="Scroll", valmin=start_ord, valmax=end_ord - 1,
        valinit=left_ord_init, valstep=1
    )
    win_slider = Slider(
        ax=ax_win, label="Window (days)", valmin=15, valmax=min(800, full_days),
        valinit=window_days, valstep=1
    )

    # Set initial x-limits
    ax.set_xlim(datetime.fromordinal(left_ord_init), datetime.fromordinal(right_ord_init))

    # Update function
    def update(_):
        win = int(win_slider.val)
        left = int(pos_slider.val)
        # Clamp so right edge doesn't exceed end
        if left + win > end_ord:
            left = end_ord - win
            pos_slider.set_val(left)  # reflect clamp on UI
        right = left + win
        ax.set_xlim(datetime.fromordinal(left), datetime.fromordinal(right))
        fig.canvas.draw_idle()

    pos_slider.on_changed(update)
    win_slider.on_changed(update)

    # ---- Output / show ----
    if args.outfile:
        # Save full canvas (you can still use sliders after saving if showing)
        plt.savefig(args.outfile, dpi=150, bbox_inches="tight")
        print(f"Chart saved to: {args.outfile}")

    plt.show()

    # ---- CSV save/update logic ----
    name_file='jepq.csv'
    save_csv = True
    if os.path.exists(name_file):
        # Get last modified time
        mtime = datetime.fromtimestamp(os.path.getmtime(name_file))
        age_days = (datetime.now() - mtime).days
        if age_days < 90:
            print(f"CSV file '{name_file}' exists and is only {age_days} days old — keeping it.")
            save_csv = False
        else:
            print(f"CSV file '{name_file}' is {age_days} days old — regenerating.")
    else:
        print(f"CSV file '{name_file}' not found — creating it.")

    if save_csv:
        df[["Open", "High", "Low", "Close", "Volume"]].to_csv(name_file, index_label="Date")
        print(f"CSV saved to: {name_file}")


if __name__ == "__main__":
    main()
