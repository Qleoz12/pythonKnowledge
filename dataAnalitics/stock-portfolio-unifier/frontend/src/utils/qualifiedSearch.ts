/**
 * Parse "SYM:BOLSA" or "SYM@BOLSA" in the search/add box → símbolo para filtrar, bolsa, y ticker Yahoo Finance.
 * Ej: WING:NASDAQ → WING + NASDAQ + yahoo "WING"; WING:TSX → yahoo "WING.TO"
 */
const US_EXCHANGES = new Set([
  'NYSE',
  'NASDAQ',
  'NMS',
  'NYQ',
  'NCM',
  'NGM',
  'AMEX',
  'NYSEARCA',
  'BATS',
  'OTC',
  'PNK',
])

const EXCHANGE_TO_YAHOO_SUFFIX: Record<string, string> = {
  TSX: '.TO',
  TSXV: '.V',
  TSE: '.TO',
  TOR: '.TO',
  LSE: '.L',
  LON: '.L',
  ASX: '.AX',
  FRA: '.F',
  XETRA: '.DE',
  DE: '.DE',
}

function toYahooTicker(symbolPart: string, exchangeCode: string): string {
  const sym = symbolPart.trim().toUpperCase()
  const ex = exchangeCode.trim().toUpperCase()
  if (!sym) return ''

  const us = !ex || US_EXCHANGES.has(ex)
  if (us) {
    if (sym.includes('.')) return sym.replace(/\./g, '-')
    if (sym.includes('-') && sym.length <= 5) return sym
    return sym
  }

  const root = sym.split('.')[0].split('-')[0]
  const suf = EXCHANGE_TO_YAHOO_SUFFIX[ex]
  return suf ? `${root}${suf}` : sym
}

export function parseQualifiedEquityInput(raw: string): {
  displaySymbol: string
  exchange: string | null
  yahooTicker: string
} {
  const t = raw.trim()
  if (!t) return { displaySymbol: '', exchange: null, yahooTicker: '' }

  const m = /^(.+?)\s*[:@]\s*([A-Za-z][A-Za-z0-9.]*)$/i.exec(t)
  if (m) {
    const symRaw = m[1].trim().toUpperCase()
    const ex = m[2].trim().toUpperCase()
    const yahooTicker = toYahooTicker(symRaw, ex)
    const displaySymbol = symRaw.replace(/-/g, '.').split(/[.]/)[0] || symRaw
    return { displaySymbol, exchange: ex, yahooTicker }
  }

  const upper = t.toUpperCase()
  return {
    displaySymbol: upper,
    exchange: null,
    yahooTicker: upper,
  }
}
