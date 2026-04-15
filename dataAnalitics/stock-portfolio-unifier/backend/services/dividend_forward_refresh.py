"""
Project and refresh forward-looking dividend dates for stocks already in the DB.

Universe: stocks that had at least one DividendEvent in the *prior-year*
equivalent of the calendar range (same seasonality window the user is viewing).

Sources:
- seasonal_1y: prior-year DB payment date + 1 calendar year (dateutil.relativedelta).
- yahoo_ex: Yahoo Finance `info.exDividendDate` when present in-range.

TipRanks / Finviz / TradingView calendars are not scraped here (fragile ToS/bot
defense); use them manually to cross-check rows marked seasonal_1y.
"""
from __future__ import annotations

import time
from datetime import date, datetime, timedelta, timezone
from typing import Any, Iterable

from dateutil.relativedelta import relativedelta
from sqlalchemy.orm import Session

from models import DividendEvent, DividendForwardEvent, Stock


def prior_year_window(start: date, end: date) -> tuple[date, date]:
    return start - relativedelta(years=1), end - relativedelta(years=1)


def _utc_ts_to_date(ts: Any) -> date | None:
    if ts is None:
        return None
    try:
        v = float(ts)
    except (TypeError, ValueError):
        return None
    if v > 1e12:
        v = v / 1000.0
    try:
        return datetime.fromtimestamp(v, tz=timezone.utc).date()
    except (OSError, ValueError, OverflowError):
        return None


def stock_ids_with_dividends_in_range(db: Session, start: date, end: date) -> list[int]:
    q = (
        db.query(DividendEvent.stock_id)
        .filter(DividendEvent.div_date.between(start, end))
        .distinct()
    )
    return [r[0] for r in q.all() if r[0] is not None]


def prior_events_in_window(
    db: Session, stock_id: int, start: date, end: date
) -> list[tuple[date, float]]:
    rows = (
        db.query(DividendEvent.div_date, DividendEvent.div_amount)
        .filter(
            DividendEvent.stock_id == stock_id,
            DividendEvent.div_date.between(start, end),
        )
        .order_by(DividendEvent.div_date)
        .all()
    )
    out: list[tuple[date, float]] = []
    for d, amt in rows:
        if d is None:
            continue
        try:
            a = float(amt)
        except (TypeError, ValueError):
            a = 0.0
        out.append((d, a))
    return out


def _yf_ex_and_last_amount(ticker_yf: str) -> tuple[date | None, float | None]:
    import yfinance as yf

    t = yf.Ticker(ticker_yf)
    info = t.info or {}
    ex = _utc_ts_to_date(info.get("exDividendDate"))
    last_amt: float | None = None
    try:
        divs = t.dividends
        if divs is not None and len(divs) > 0:
            last_amt = float(divs.iloc[-1])
    except Exception:
        pass
    if last_amt is not None and (last_amt != last_amt or last_amt == float("inf")):
        last_amt = None
    return ex, last_amt


def refresh_forward_dividends(
    db: Session,
    calendar_start: date,
    calendar_end: date,
    weeks_ahead: int = 5,
    max_stocks: int = 200,
    yahoo_delay_sec: float = 0.15,
) -> dict[str, Any]:
    """
    Rebuild DividendForwardEvent rows for [calendar_start, calendar_end] for the
    universe defined by prior-year DB dividends in the shifted window.

    Yahoo is consulted for tickers that have a seasonal projection falling within
    the next `weeks_ahead` weeks from today (for confirmation / ex-date).
    """
    today = date.today()
    prior_s, prior_e = prior_year_window(calendar_start, calendar_end)
    stock_ids = stock_ids_with_dividends_in_range(db, prior_s, prior_e)
    if max_stocks and len(stock_ids) > max_stocks:
        stock_ids = stock_ids[:max_stocks]

    horizon_end = today + timedelta(days=7 * max(1, weeks_ahead))

    # Remove previous forward rows in this output window for the universe we refresh
    if stock_ids:
        db.query(DividendForwardEvent).filter(
            DividendForwardEvent.stock_id.in_(stock_ids),
            DividendForwardEvent.div_date.between(calendar_start, calendar_end),
        ).delete(synchronize_session=False)
        db.commit()

    inserted_seasonal = 0
    yahoo_checked = 0
    yahoo_ex_rows = 0
    errors: list[str] = []

    id_batch: Iterable[int] = stock_ids
    for stock_id in id_batch:
        stock = db.query(Stock).filter(Stock.id == stock_id).first()
        if not stock or not stock.ticker_yf:
            continue
        ticker = stock.ticker_yf.strip()
        if not ticker:
            continue

        priors = prior_events_in_window(db, stock_id, prior_s, prior_e)
        seasonal_in_horizon = False
        seen_proj: set[date] = set()
        for prev_d, prev_amt in priors:
            proj = prev_d + relativedelta(years=1)
            if not (calendar_start <= proj <= calendar_end):
                continue
            if proj in seen_proj:
                continue
            seen_proj.add(proj)
            amt = float(prev_amt) if prev_amt == prev_amt else 0.0
            db.add(
                DividendForwardEvent(
                    stock_id=stock_id,
                    div_date=proj,
                    div_amount=amt,
                    projection_source="seasonal_1y",
                    prior_year_div_date=prev_d,
                )
            )
            inserted_seasonal += 1
            if today <= proj <= horizon_end:
                seasonal_in_horizon = True

        db.flush()

        if seasonal_in_horizon:
            try:
                time.sleep(yahoo_delay_sec)
                ex_d, last_amt = _yf_ex_and_last_amount(ticker)
                yahoo_checked += 1
                if ex_d and calendar_start <= ex_d <= calendar_end:
                    amt2 = last_amt if last_amt is not None else 0.0
                    existing = (
                        db.query(DividendForwardEvent)
                        .filter(
                            DividendForwardEvent.stock_id == stock_id,
                            DividendForwardEvent.div_date == ex_d,
                        )
                        .first()
                    )
                    if existing:
                        existing.projection_source = "yahoo_ex"
                        if amt2:
                            existing.div_amount = amt2
                    else:
                        db.add(
                            DividendForwardEvent(
                                stock_id=stock_id,
                                div_date=ex_d,
                                div_amount=amt2,
                                projection_source="yahoo_ex",
                                prior_year_div_date=None,
                            )
                        )
                        yahoo_ex_rows += 1
                    near = (
                        db.query(DividendForwardEvent)
                        .filter(
                            DividendForwardEvent.stock_id == stock_id,
                            DividendForwardEvent.projection_source == "seasonal_1y",
                            DividendForwardEvent.div_date.between(
                                ex_d - timedelta(days=4), ex_d + timedelta(days=4)
                            ),
                        )
                        .all()
                    )
                    for row in near:
                        if row.div_date != ex_d:
                            db.delete(row)
            except Exception as e:  # noqa: BLE001
                errors.append(f"{ticker}: {e}")

    db.commit()

    return {
        "calendar_start": str(calendar_start),
        "calendar_end": str(calendar_end),
        "prior_year_start": str(prior_s),
        "prior_year_end": str(prior_e),
        "universe_stock_count": len(stock_ids),
        "seasonal_rows_inserted": inserted_seasonal,
        "yahoo_ex_rows_upserted": yahoo_ex_rows,
        "yahoo_lookups": yahoo_checked,
        "errors_sample": errors[:15],
        "error_count": len(errors),
    }
