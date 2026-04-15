/**
 * Mirrors backend/services/price_normalization.dividend_score (0–100).
 * All ratio inputs are decimals: yield 0.04 = 4%, vol 0.28 = 28%.
 */

function clamp(x: number | null | undefined, lo: number, hi: number): number | null {
  if (x == null || Number.isNaN(x)) return null
  return Math.max(lo, Math.min(hi, x))
}

export function dividendScore(
  dividendYield: number | null | undefined,
  payoutRatio: number | null | undefined,
  divGrowth5y: number | null | undefined,
  volatility: number | null | undefined,
  beta: number | null | undefined,
): number | null {
  if (
    dividendYield == null
    && payoutRatio == null
    && divGrowth5y == null
    && volatility == null
    && beta == null
  ) {
    return null
  }

  const y = clamp(dividendYield ?? null, 0, 0.10)
  const g = clamp(divGrowth5y ?? null, -0.10, 0.20)
  const p = clamp(payoutRatio ?? null, 0, 1.2)
  const v = clamp(volatility ?? null, 0.10, 0.60)
  const b = clamp(beta ?? null, 0.5, 2.0)

  const yieldS = y != null ? y / 0.10 : null
  const growthS = g != null ? (g + 0.10) / 0.30 : null
  let payoutS: number | null = null
  if (p != null) {
    payoutS = p <= 0.60 ? 1.0 : Math.max(0.0, 1.0 - (p - 0.60) / 0.60)
  }
  const volS = v != null ? 1.0 - (v - 0.10) / 0.50 : null
  const betaS = b != null ? 1.0 - (b - 0.5) / 1.5 : null

  const parts: number[] = []
  const weights: number[] = []
  function add(val: number | null, w: number) {
    if (val != null && !Number.isNaN(val)) {
      parts.push(val * w)
      weights.push(w)
    }
  }
  add(yieldS, 0.30)
  add(growthS, 0.25)
  add(payoutS, 0.20)
  add(volS, 0.15)
  add(betaS, 0.10)

  if (!weights.length) return null
  const score01 = parts.reduce((a, c) => a + c, 0) / weights.reduce((a, c) => a + c, 0)
  return Math.round(score01 * 100 * 100) / 100
}

/** User types percent e.g. "4.15" → 0.0415; empty → null */
export function parsePercentToDecimal(raw: string): number | null {
  const t = raw.trim()
  if (!t) return null
  const n = Number(t.replace(',', '.'))
  if (Number.isNaN(n)) return null
  return n / 100
}

export function parseNumber(raw: string): number | null {
  const t = raw.trim()
  if (!t) return null
  const n = Number(t.replace(',', '.'))
  return Number.isNaN(n) ? null : n
}
