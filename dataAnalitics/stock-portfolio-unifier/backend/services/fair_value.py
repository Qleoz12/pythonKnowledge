"""Merge OHLCV closes with stepped fair value revisions (daily / weekly / monthly + annual stats)."""
from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass
from datetime import date
from typing import Iterable, List, Optional, Sequence, Tuple


@dataclass
class RevisionPoint:
    effective_date: date
    fair_value: float
    uncertainty: Optional[str] = None


def _active_revision(
    d: date, revs: Sequence[RevisionPoint]
) -> Tuple[Optional[float], Optional[str]]:
    """Last revision with effective_date <= d."""
    fve: Optional[float] = None
    unc: Optional[str] = None
    for r in revs:
        if r.effective_date <= d:
            fve = r.fair_value
            unc = r.uncertainty
        else:
            break
    return fve, unc


def build_daily_series(
    dates: Sequence[date],
    closes: Sequence[float],
    revisions: Sequence[RevisionPoint],
) -> Tuple[
    List[str],
    List[float],
    List[Optional[float]],
    List[Optional[str]],
    List[Optional[float]],
    List[bool],
]:
    """
    Returns parallel arrays: date iso, close, fve (None before first revision),
    uncertainty for active revision, price_to_fve, undervalued (close < fve when both set).
    """
    revs = sorted(revisions, key=lambda r: r.effective_date)
    out_dates: List[str] = []
    out_close: List[float] = []
    out_fve: List[Optional[float]] = []
    out_unc: List[Optional[str]] = []
    out_ratio: List[Optional[float]] = []
    out_under: List[bool] = []
    for d, c in zip(dates, closes):
        fve, unc = _active_revision(d, revs)
        out_dates.append(d.isoformat())
        out_close.append(float(c))
        out_fve.append(float(fve) if fve is not None else None)
        out_unc.append(unc)
        if fve is not None and fve > 0:
            ratio = float(c) / float(fve)
            out_ratio.append(round(ratio, 6))
            out_under.append(float(c) < float(fve))
        else:
            out_ratio.append(None)
            out_under.append(False)
    return out_dates, out_close, out_fve, out_unc, out_ratio, out_under


def downsample_weekly(
    dates: Sequence[date],
    closes: Sequence[float],
    fves: Sequence[Optional[float]],
    uncs: Sequence[Optional[str]],
    ratios: Sequence[Optional[float]],
    unders: Sequence[bool],
) -> Tuple[List[str], List[float], List[Optional[float]], List[Optional[str]], List[Optional[float]], List[bool]]:
    """One point per ISO calendar week: last trading row in that week."""
    buckets: dict[Tuple[int, int], List[int]] = defaultdict(list)
    for i, d in enumerate(dates):
        y, w, _ = d.isocalendar()
        buckets[(y, w)].append(i)
    keys = sorted(buckets.keys())
    idxs = [buckets[k][-1] for k in keys]
    return (
        [dates[i].isoformat() for i in idxs],
        [closes[i] for i in idxs],
        [fves[i] for i in idxs],
        [uncs[i] for i in idxs],
        [ratios[i] for i in idxs],
        [unders[i] for i in idxs],
    )


def downsample_monthly(
    dates: Sequence[date],
    closes: Sequence[float],
    fves: Sequence[Optional[float]],
    uncs: Sequence[Optional[str]],
    ratios: Sequence[Optional[float]],
    unders: Sequence[bool],
) -> Tuple[List[str], List[float], List[Optional[float]], List[Optional[str]], List[Optional[float]], List[bool]]:
    """One point per calendar month: last trading row in that month."""
    buckets: dict[Tuple[int, int], List[int]] = defaultdict(list)
    for i, d in enumerate(dates):
        buckets[(d.year, d.month)].append(i)
    keys = sorted(buckets.keys())
    idxs = [buckets[k][-1] for k in keys]
    return (
        [dates[i].isoformat() for i in idxs],
        [closes[i] for i in idxs],
        [fves[i] for i in idxs],
        [uncs[i] for i in idxs],
        [ratios[i] for i in idxs],
        [unders[i] for i in idxs],
    )


def _year_end_closes(dates: Sequence[date], closes: Sequence[float]) -> dict[int, Tuple[date, float]]:
    """Last trading session per calendar year."""
    by_year: dict[int, Tuple[date, float]] = {}
    for d, c in zip(dates, closes):
        y = d.year
        cur = by_year.get(y)
        if cur is None or d > cur[0]:
            by_year[y] = (d, float(c))
    return by_year


def build_annual_table(
    dates: Sequence[date],
    closes: Sequence[float],
    revisions: Sequence[RevisionPoint],
    year_from: int,
    year_to: int,
    *,
    annual_fve_basis: str = "constant_latest",
) -> List[dict]:
    """
    Per calendar year: price_to_fve at last session of year.

    - annual_fve_basis ``strict``: ratio only if stepped FVE exists on last_date (historical FVE path).
    - ``constant_latest`` (default): use stepped FVE when available; otherwise divide year-end close
      by the **latest** revision's fair value (same FVE for all missing years — "how did price look
      vs my current FVE?"). Not a substitute for true time-varying analyst FVE.
    """
    revs = sorted(revisions, key=lambda r: r.effective_date)
    latest_fve = revs[-1].fair_value if revs and revs[-1].fair_value > 0 else None
    by_year = _year_end_closes(dates, closes)
    rows: List[dict] = []
    for year in range(year_from, year_to + 1):
        last = by_year.get(year)
        if not last:
            continue
        d_last, c_last = last
        fve_step, _ = _active_revision(d_last, revs)
        basis: Optional[str] = None
        fve_use: Optional[float] = None
        if fve_step and fve_step > 0:
            fve_use = float(fve_step)
            basis = "step"
        elif annual_fve_basis == "constant_latest" and latest_fve:
            fve_use = float(latest_fve)
            basis = "constant_latest"
        price_fve = (c_last / fve_use) if fve_use else None
        ret_pct: Optional[float] = None
        prev = by_year.get(year - 1)
        if prev is not None and prev[1] > 0:
            ret_pct = round((c_last / prev[1] - 1.0) * 100.0, 4)
        rows.append({
            "year": year,
            "last_date": d_last.isoformat(),
            "price_to_fve": round(price_fve, 4) if price_fve is not None else None,
            "price_to_fve_basis": basis,
            "total_return_pct": ret_pct,
        })
    return rows


def revisions_from_rows(
    rows: Iterable[Tuple[date, float, Optional[str]]],
) -> List[RevisionPoint]:
    return [RevisionPoint(effective_date=a, fair_value=b, uncertainty=c) for a, b, c in rows]
