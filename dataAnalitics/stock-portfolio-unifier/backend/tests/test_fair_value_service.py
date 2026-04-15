import unittest
from datetime import date

from services.fair_value import (
    RevisionPoint,
    build_daily_series,
    downsample_weekly,
    downsample_monthly,
    build_annual_table,
)


class TestFairValueService(unittest.TestCase):
    def test_step_fve_mid_series(self):
        revs = [
            RevisionPoint(date(2024, 6, 1), 100.0, "medium"),
            RevisionPoint(date(2024, 8, 1), 120.0, "high"),
        ]
        dates = [date(2024, 5, 1), date(2024, 7, 1), date(2024, 9, 1)]
        closes = [90.0, 95.0, 130.0]
        ds, dc, df, du, dr, under = build_daily_series(dates, closes, revs)
        self.assertEqual(ds[0], "2024-05-01")
        self.assertIsNone(df[0])
        self.assertEqual(df[1], 100.0)
        self.assertEqual(df[2], 120.0)
        self.assertTrue(under[1])
        self.assertFalse(under[2])

    def test_weekly_last_in_bucket(self):
        revs = [RevisionPoint(date(2020, 1, 1), 50.0, None)]
        dates = [
            date(2024, 1, 2),
            date(2024, 1, 3),
            date(2024, 1, 4),
        ]
        closes = [10.0, 11.0, 12.0]
        ds, dc, df, du, dr, under = build_daily_series(dates, closes, revs)
        d2, c2, f2, _, _, _ = downsample_weekly(
            [date.fromisoformat(x) for x in ds], dc, df, du, dr, under
        )
        self.assertEqual(len(c2), 1)
        self.assertEqual(c2[0], 12.0)

    def test_monthly_last_in_bucket(self):
        revs = [RevisionPoint(date(2020, 1, 1), 50.0, None)]
        dates = [
            date(2024, 1, 10),
            date(2024, 1, 20),
            date(2024, 2, 5),
        ]
        closes = [10.0, 11.0, 20.0]
        ds, dc, df, du, dr, under = build_daily_series(dates, closes, revs)
        d2, c2, f2, _, _, _ = downsample_monthly(
            [date.fromisoformat(x) for x in ds], dc, df, du, dr, under
        )
        self.assertEqual(len(c2), 2)
        self.assertEqual(c2[0], 11.0)
        self.assertEqual(c2[1], 20.0)

    def test_annual_total_return(self):
        revs = [RevisionPoint(date(2020, 1, 1), 100.0, None)]
        dates = [
            date(2023, 12, 29),
            date(2024, 12, 30),
            date(2025, 6, 1),
        ]
        closes = [100.0, 120.0, 110.0]
        rows = build_annual_table(dates, closes, revs, 2023, 2025)
        by_y = {r["year"]: r for r in rows}
        self.assertAlmostEqual(by_y[2024]["total_return_pct"], 20.0)
        self.assertIsNone(by_y[2023]["total_return_pct"])
        self.assertEqual(by_y[2023]["price_to_fve_basis"], "step")

    def test_annual_constant_latest_fills_when_no_step(self):
        revs = [RevisionPoint(date(2026, 1, 1), 200.0, None)]
        dates = [date(2022, 12, 30), date(2023, 12, 29), date(2024, 12, 27)]
        closes = [80.0, 100.0, 120.0]
        rows = build_annual_table(
            dates, closes, revs, 2022, 2024, annual_fve_basis="constant_latest"
        )
        by_y = {r["year"]: r for r in rows}
        self.assertEqual(by_y[2022]["price_to_fve_basis"], "constant_latest")
        self.assertAlmostEqual(by_y[2022]["price_to_fve"], 0.4)
        rows_strict = build_annual_table(
            dates, closes, revs, 2022, 2024, annual_fve_basis="strict"
        )
        self.assertIsNone({r["year"]: r for r in rows_strict}[2022]["price_to_fve"])


if __name__ == "__main__":
    unittest.main()
