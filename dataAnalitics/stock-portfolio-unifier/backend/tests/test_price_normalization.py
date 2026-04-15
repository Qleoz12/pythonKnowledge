import unittest

import pandas as pd

from services.price_normalization import (
    clamp,
    dividend_score,
    ttm_from_quarterly,
    compute_div_growth_5y_cagr,
    _parse_yield_decimal,
    _parse_payout_decimal,
)


class TestPriceNormalization(unittest.TestCase):
    def test_clamp(self):
        self.assertEqual(clamp(1.5, 0, 1), 1.0)
        self.assertIsNone(clamp(None, 0, 1))

    def test_dividend_score_basic(self):
        s = dividend_score(0.04, 0.50, 0.05, 0.20, 1.0)
        self.assertIsNotNone(s)
        self.assertGreater(s, 40)
        self.assertLessEqual(s, 100)

    def test_ttm_from_quarterly(self):
        idx = ["Net Income"]
        cols = pd.date_range("2024-01-01", periods=4, freq="QE")
        qf = pd.DataFrame([[1, 2, 3, 4]], index=idx, columns=cols)
        self.assertAlmostEqual(ttm_from_quarterly(qf, ["Net Income"]), 10.0)

    def test_parse_yield_percent_vs_decimal(self):
        self.assertAlmostEqual(_parse_yield_decimal(4.15), 0.0415)
        self.assertAlmostEqual(_parse_yield_decimal(0.0415), 0.0415)

    def test_parse_payout_percent(self):
        self.assertAlmostEqual(_parse_payout_decimal(55.21), 0.5521)
        self.assertAlmostEqual(_parse_payout_decimal(0.5521), 0.5521)

    def test_div_cagr(self):
        idx = pd.date_range("2018-01-31", periods=84, freq="ME")
        amounts = [0.2] * 60 + [0.4] * 24
        s = pd.Series(amounts, index=idx)
        cagr = compute_div_growth_5y_cagr(s)
        self.assertIsNotNone(cagr)
        self.assertGreater(cagr, 0)


if __name__ == "__main__":
    unittest.main()
