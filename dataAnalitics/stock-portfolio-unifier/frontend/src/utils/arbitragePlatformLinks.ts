/**
 * Maps arbitrage rate `source` ids to human-facing exchange pages (P2P / spot).
 * CriptoYa sources use prefix `criptoya_<exchange_key>` where keys come from their API.
 */

export function parseArbitragePair(pair: string): { base: string; quote: string } | null {
  const parts = pair.split('/').map(s => s.trim().toUpperCase())
  if (parts.length !== 2 || !parts[0] || !parts[1]) return null
  return { base: parts[0], quote: parts[1] }
}

type LinkBuilder = (crypto: string, fiat: string) => string

const CRIPTOYA_SLUG_BUILDERS: Record<string, LinkBuilder> = {
  binancep2p: (c, f) =>
    `https://p2p.binance.com/trade/buy/${c}?fiat=${f}`,
  okexp2p: (c, f) =>
    `https://www.okx.com/p2p/market?crypto=${c.toLowerCase()}&fiat=${f.toLowerCase()}&side=sell`,
  kucoinp2p: (c, f) =>
    `https://www.kucoin.com/otc/buy/${c}-${f}`,
  bybitp2p: (c, f) =>
    `https://www.bybit.com/fiat/trade/otc?token=${c}&fiat=${f}&actionType=0`,
  bitgetp2p: (c, f) =>
    `https://www.bitget.com/p2p-trade/${c.toLowerCase()}_${f.toLowerCase()}`,
  bingxp2p: (c, f) =>
    `https://bingx.com/en/p2p/${c}/${f}`,
  mexcp2p: (c, f) =>
    `https://www.mexc.com/p2p/${c}_${f}`,
  bitsoalpha: () => `https://bitso.com/`,
  ripio: () => `https://web.ripio.com/`,
  buda: (c, f) => `https://www.buda.com/${f.toLowerCase()}/${c.toLowerCase()}`,
  lemoncash: () => `https://www.lemon.me/`,
  vitawallet: () => `https://vitawallet.io/`,
  eldoradop2p: () => `https://eldorado.io/`,
  paydecep2p: () => `https://paydece.io/`,
  cryptomktpro: () => `https://www.cryptomkt.com/`,
  saldo: () => `https://saldo.com.ar/`,
}

/** Static URLs for non-CriptoYa sources */
const DIRECT_SOURCE_URLS: Record<string, string> = {
  binance: 'https://www.binance.com/en/trade',
  binance_24h: 'https://www.binance.com/en/trade',
  kraken: 'https://www.kraken.com/prices',
  coinbase: 'https://www.coinbase.com/price',
  coingecko: 'https://www.coingecko.com/',
  bitso: 'https://bitso.com/',
  blockchain_info: 'https://www.blockchain.com/explorer',
  exchangerate_api: 'https://www.exchangerate-api.com/',
}

function criptoyaSlug(source: string): string | null {
  const p = 'criptoya_'
  if (!source.toLowerCase().startsWith(p)) return null
  return source.slice(p.length).toLowerCase()
}

/**
 * Returns an HTTPS URL to open the exchange / P2P book for this source and pair, or null.
 */
export function arbitrageSourceTradeUrl(source: string, pair: string): string | null {
  const parsed = parseArbitragePair(pair)
  if (!parsed) return null
  const { base, quote } = parsed

  const slug = criptoyaSlug(source)
  if (slug) {
    const builder = CRIPTOYA_SLUG_BUILDERS[slug]
    if (builder) return builder(base, quote)
    return 'https://criptoya.com/'
  }

  return DIRECT_SOURCE_URLS[source] ?? null
}

/** Short label for UI (e.g. tooltip). */
export function arbitrageSourcePlatformLabel(source: string): string {
  const slug = criptoyaSlug(source)
  if (slug) {
    const pretty = slug
      .replace(/p2p$/i, ' P2P')
      .replace(/_/g, ' ')
      .replace(/\b\w/g, c => c.toUpperCase())
    return pretty.trim() || source
  }
  const direct: Record<string, string> = {
    binance: 'Binance',
    binance_24h: 'Binance',
    kraken: 'Kraken',
    coinbase: 'Coinbase',
    coingecko: 'CoinGecko',
    bitso: 'Bitso',
    blockchain_info: 'Blockchain.info',
    exchangerate_api: 'ExchangeRate-API',
  }
  return direct[source] ?? source
}
