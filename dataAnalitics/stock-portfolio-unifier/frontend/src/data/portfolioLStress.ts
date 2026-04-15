/** Datos de análisis de estrés y equity (portafolio L) — importados desde preview.html */
export interface StressPositionRow {
  ticker: string
  shares: number
  pxActual: number
  pxStress: number
  valorActual: number
  valorStress: number
  perdidaStress: number
  vender: number
  sharesFinales: number
  flujoActual: number
  flujoPosterior: number
}

export interface StressTotals {
  valorActual: number
  valorStress: number
  perdidaStress: number
  vender: number
  sharesFinales: number
  flujoActualMes: number
  flujoPosteriorMes: number
}

export interface EquitySummaryRow {
  concepto: string
  valor: string
  variant?: 'default' | 'danger' | 'warning'
}

export const portfolioLStressPositions: StressPositionRow[] = [
  { ticker: 'MAIN', shares: 621, pxActual: 51.53, pxStress: 35, valorActual: 32000, valorStress: 21735, perdidaStress: -10265, vender: 250, sharesFinales: 371, flujoActual: 161, flujoPosterior: 96 },
  { ticker: 'AGNC', shares: 2164, pxActual: 9.69, pxStress: 7, valorActual: 20969, valorStress: 15148, perdidaStress: -5821, vender: 900, sharesFinales: 1264, flujoActual: 259, flujoPosterior: 151 },
  { ticker: 'STWD', shares: 565, pxActual: 17.04, pxStress: 16, valorActual: 9627, valorStress: 9040, perdidaStress: -587, vender: 200, sharesFinales: 365, flujoActual: 90, flujoPosterior: 58 },
  { ticker: 'FSK', shares: 496, pxActual: 9.91, pxStress: 8.5, valorActual: 4915, valorStress: 4216, perdidaStress: -699, vender: 200, sharesFinales: 296, flujoActual: 79, flujoPosterior: 47 },
  { ticker: 'ARCC', shares: 259, pxActual: 20, pxStress: 16, valorActual: 5180, valorStress: 4144, perdidaStress: -1036, vender: 100, sharesFinales: 159, flujoActual: 41, flujoPosterior: 25 },
]

export const portfolioLStressTotals: StressTotals = {
  valorActual: 72691,
  valorStress: 54283,
  perdidaStress: -18408,
  vender: 1650,
  sharesFinales: 2455,
  flujoActualMes: 632,
  flujoPosteriorMes: 379,
}

export const portfolioLEquitySummary: EquitySummaryRow[] = [
  { concepto: 'Equity actual', valor: '$2,500' },
  { concepto: 'Exposición', valor: '$93,000' },
  { concepto: 'Pérdida actual', valor: '-7,566' },
  { concepto: 'Pérdida escenario estrés', valor: '-18,408' },
  { concepto: 'Caída portafolio', valor: '-23%' },
  { concepto: 'Impacto en equity (realista)', valor: '-70% a -75%' },
  { concepto: 'Equity final estimado', valor: '$625 – $750', variant: 'danger' },
  { concepto: 'Estado', valor: '⚠️ Zona crítica (pero sobrevives)', variant: 'warning' },
]
