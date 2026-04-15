from datetime import date

from dateutil.relativedelta import relativedelta

from services.dividend_forward_refresh import prior_year_window


def test_prior_year_window():
    s, e = date(2026, 4, 1), date(2026, 6, 30)
    ps, pe = prior_year_window(s, e)
    assert ps == date(2025, 4, 1)
    assert pe == date(2025, 6, 30)


def test_prior_year_window_leap_neighbor():
    s = date(2025, 2, 28)
    ps, _ = prior_year_window(s, s)
    assert ps == date(2024, 2, 28)
    assert ps + relativedelta(years=1) == date(2025, 2, 28)
