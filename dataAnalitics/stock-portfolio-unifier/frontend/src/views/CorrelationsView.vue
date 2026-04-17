<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted, shallowRef, nextTick } from 'vue'
import * as echarts from 'echarts/core'
import { LineChart, ScatterChart } from 'echarts/charts'
import {
  TooltipComponent, GridComponent, LegendComponent, DataZoomComponent,
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import { fetchOHLCV, searchStockByTicker } from '../services/api'

echarts.use([
  LineChart, ScatterChart, CanvasRenderer,
  TooltipComponent, GridComponent, LegendComponent, DataZoomComponent,
])

type RelationKind = 'inverse' | 'direct' | 'context'

type MacroTheme = {
  id: string
  title: string
  summary: string
  bullets: string[]
  relation: RelationKind
  relationLabel: string
  tickerA: string
  tickerB: string
  labelA: string
  labelB: string
}

/** Temas macro + tickers Yahoo para gráficos (deben existir en tu API /stocks). */
const MACRO_THEMES: MacroTheme[] = [
  {
    id: 'oil-airlines',
    title: 'Petróleo vs aerolíneas',
    summary:
      'El combustible suele ser un costo relevante para las aerolíneas. Cuando el crudo o los refinados presionan al alza, los márgenes del sector aéreo a menudo sufren; cuando el petróleo relaja, hay más aire para resultados y valoraciones.',
    bullets: [
      'La relación no es mecánica: hedging, rutas, mix de ingresos y deuda cambian el impacto.',
      'En crisis de demanda pueden caer crudo y acciones aéreas a la vez (correlación “rota”).',
    ],
    relation: 'inverse',
    relationLabel: 'Suele observarse correlación negativa en periodos dominados por el costo del combustible',
    tickerA: 'USO',
    tickerB: 'JETS',
    labelA: 'USO (petróleo WTI)',
    labelB: 'JETS (aerolíneas US)',
  },
  {
    id: 'rates-reits-banks',
    title: 'Bonos largos, REITs y sensibilidad a tasas',
    summary:
      'Los REITs suelen comportarse como activos con componente de “duración”: cuando el mercado descuenta tasas altas por más tiempo o suben los rendimientos largos, los flujos descontados pesan. Las financieras pueden verse distinto: márgenes de interés y mix de negocio reaccionan a la forma de la curva y al crédito.',
    bullets: [
      'TLT sube cuando bajan los rendimientos de Treasury largos (precio del bono).',
      'VNQ refleja REITs US; no es el mismo trade que un banco individual (p. ej. SCHW).',
    ],
    relation: 'context',
    relationLabel: 'TLT vs VNQ ayuda a visualizar “riesgo de tasas”; banca vs REITs depende del ciclo',
    tickerA: 'TLT',
    tickerB: 'VNQ',
    labelA: 'TLT (Treasury 20+ años)',
    labelB: 'VNQ (REITs US)',
  },
  {
    id: 'reits-vs-banks',
    title: 'REITs vs banca regional (proxy sectorial)',
    summary:
      'Tu intuición “si no recortan tasas” mezcla dos fuerzas: costo del dinero para activos largos (duele a REITs) y entorno para márgenes bancarios (a veces ayuda si la curva y el crédito cooperan). VNQ frente a KRE muestra el contraste sectorial; SCHW es una sola empresa con fee income y sensibilidad propia.',
    bullets: [
      'KRE agrupa bancos regionales US; no sustituye un análisis de SCHW, BAC o JPM por separado.',
      'En crisis de crédito pueden caer REITs y bancos a la vez.',
    ],
    relation: 'context',
    relationLabel: 'A veces divergencia cuando el mercado premia NIM vs castiga duración',
    tickerA: 'VNQ',
    tickerB: 'KRE',
    labelA: 'VNQ (REITs)',
    labelB: 'KRE (bancos regionales)',
  },
  {
    id: 'dxy-gold',
    title: 'Dólar fuerte vs oro',
    summary:
      'El oro cotiza en dólares: un dólar más fuerte a veces presiona el metal, y a la inversa. Además entran tipos reales, riesgo geopolítico y flujos a refugio, por lo que la correlación se rompe con frecuencia.',
    bullets: [
      'UUP es un proxy ETF del índice dólar (DXY).',
      'GLD sigue el oro al contado; no incluye mineras (GDX es otro trade).',
    ],
    relation: 'inverse',
    relationLabel: 'A menudo correlación negativa entre dólar y oro, pero no siempre',
    tickerA: 'UUP',
    tickerB: 'GLD',
    labelA: 'UUP (dólar)',
    labelB: 'GLD (oro)',
  },
  {
    id: 'growth-value',
    title: 'Crecimiento vs valor (regímenes de mercado)',
    summary:
      'Cuando bajan los rendimientos o el mercado anticipa recortes, los flujos de crecimiento lejanos se revalorizan más; cuando suben tipos o hay aversión al riesgo, a veces rotan hacia valor y dividendos. IWF vs IWD es un espejo simple del estilo.',
    bullets: [
      'No confundir con “siempre gana valor”: depende del ciclo y del sector dentro del value.',
      'Útil para ver si tu cartera está expuesta a un solo factor de estilo.',
    ],
    relation: 'context',
    relationLabel: 'Rotación de factor; a veces directa, a veces divergente en shocks',
    tickerA: 'IWF',
    tickerB: 'IWD',
    labelA: 'IWF (growth)',
    labelB: 'IWD (value)',
  },
  {
    id: 'risk-off',
    title: 'Riesgo: acciones vs bonos refugio',
    summary:
      'En episodios de pánico o desaceleración, parte del capital busca calidad de balance en Treasury largos mientras las acciones corrigen. SPY vs TLT muestra ese “risk-off” clásico, aunque en inflación persistente pueden caer ambos.',
    bullets: [
      'En 2022 muchos bonos largos y acciones cayeron juntos (correlación positiva anómala).',
      'Sirve como recordatorio de que las etiquetas “siempre” en mercados son peligrosas.',
    ],
    relation: 'inverse',
    relationLabel: 'A menudo movimientos opuestos en stress; excepciones en shock de tasas',
    tickerA: 'SPY',
    tickerB: 'TLT',
    labelA: 'SPY (S&P 500)',
    labelB: 'TLT (Treasury largo)',
  },
]

/** Vista “cualquier par”; los tickers efectivos van en customTickerA/B tras “Comparar”. */
const CUSTOM_THEME_ID = '__custom__'

function pearson(xs: number[], ys: number[]): number | null {
  const n = Math.min(xs.length, ys.length)
  if (n < 5) return null
  let sx = 0
  let sy = 0
  for (let i = 0; i < n; i++) {
    sx += xs[i]
    sy += ys[i]
  }
  const mx = sx / n
  const my = sy / n
  let num = 0
  let dx = 0
  let dy = 0
  for (let i = 0; i < n; i++) {
    const vx = xs[i] - mx
    const vy = ys[i] - my
    num += vx * vy
    dx += vx * vx
    dy += vy * vy
  }
  const den = Math.sqrt(dx * dy)
  if (den === 0) return null
  return num / den
}

function logReturns(closes: number[]): number[] {
  const r: number[] = []
  for (let i = 1; i < closes.length; i++) {
    if (closes[i - 1] > 0 && closes[i] > 0) r.push(Math.log(closes[i] / closes[i - 1]))
  }
  return r
}

function alignByDate(
  a: Array<{ date: string; close: number }>,
  b: Array<{ date: string; close: number }>,
): Array<{ date: string; ca: number; cb: number }> {
  const bm = new Map(b.map(row => [row.date, row.close]))
  const out: Array<{ date: string; ca: number; cb: number }> = []
  for (const row of a) {
    const cb = bm.get(row.date)
    if (cb != null) out.push({ date: row.date, ca: row.close, cb })
  }
  return out.sort((x, y) => x.date.localeCompare(y.date))
}

const selectedId = ref(MACRO_THEMES[0].id)

/** Borradores en el formulario; al comparar se copian a customTickerA/B. */
const draftTickerA = ref('AGNC')
const draftTickerB = ref('SCHW')
/** Tickers usados para la última petición (modo personalizado). */
const customTickerA = ref('')
const customTickerB = ref('')

const isCustomPair = computed(() => selectedId.value === CUSTOM_THEME_ID)

const presetTheme = computed(() => MACRO_THEMES.find(t => t.id === selectedId.value) ?? MACRO_THEMES[0])

const theme = computed((): MacroTheme => {
  if (!isCustomPair.value) return presetTheme.value
  const a = customTickerA.value.trim().toUpperCase()
  const b = customTickerB.value.trim().toUpperCase()
  return {
    id: CUSTOM_THEME_ID,
    title: 'Par personalizado',
    summary:
      'Compará dos tickers cualesquiera que ya estén en tu base (los mismos símbolos que usás al buscar en Stocks). Los gráficos son los mismos que en los temas macro: precio normalizado y retornos diarios.',
    bullets: [
      'Para más de dos activos a la vez haría falta otro gráfico (varias líneas o matriz); aquí el foco es un par limpio A vs B.',
      'Si tu bolsa usa sufijo Yahoo (p. ej. .L), incluílo tal cual lo tenés cargado en la app.',
    ],
    relation: 'context',
    relationLabel: 'Solo datos del par: sin guión macro predefinido.',
    tickerA: a,
    tickerB: b,
    labelA: a || 'A',
    labelB: b || 'B',
  }
})

const period = ref('2y')
const loading = ref(false)
const err = ref('')
const dates = ref<string[]>([])
const seriesA = ref<number[]>([])
const seriesB = ref<number[]>([])
const normA = ref<number[]>([])
const normB = ref<number[]>([])
const scatterPairs = ref<[number, number][]>([])

const corrReturns = computed(() => {
  const ra = logReturns(seriesA.value)
  const rb = logReturns(seriesB.value)
  const n = Math.min(ra.length, rb.length)
  if (n < 10) return null
  return pearson(ra.slice(-n), rb.slice(-n))
})

const chartPriceRef = ref<HTMLDivElement>()
const chartScatterRef = ref<HTMLDivElement>()
const chartPrice = shallowRef<echarts.ECharts>()
const chartScatter = shallowRef<echarts.ECharts>()

function disposeCharts() {
  chartPrice.value?.dispose()
  chartScatter.value?.dispose()
  chartPrice.value = undefined
  chartScatter.value = undefined
}

function buildPriceOption() {
  return {
    backgroundColor: 'transparent',
    textStyle: { color: '#9ca3af' },
    legend: {
      data: [theme.value.labelA, theme.value.labelB],
      textStyle: { color: '#d1d5db' },
      top: 0,
    },
    tooltip: { trigger: 'axis' },
    grid: { left: 48, right: 24, top: 40, bottom: 72 },
    dataZoom: [{ type: 'inside' }, { type: 'slider', bottom: 8 }],
    xAxis: {
      type: 'category',
      data: dates.value,
      axisLabel: { color: '#6b7280', rotate: 35 },
    },
    yAxis: {
      type: 'value',
      name: 'Índice (100 = inicio ventana)',
      nameTextStyle: { color: '#9ca3af', fontSize: 11 },
      axisLabel: { color: '#6b7280' },
      splitLine: { lineStyle: { color: '#374151' } },
    },
    series: [
      {
        name: theme.value.labelA,
        type: 'line',
        showSymbol: false,
        data: normA.value,
        lineStyle: { width: 1.5, color: '#38bdf8' },
      },
      {
        name: theme.value.labelB,
        type: 'line',
        showSymbol: false,
        data: normB.value,
        lineStyle: { width: 1.5, color: '#f472b6' },
      },
    ],
  }
}

function buildScatterOption() {
  return {
    backgroundColor: 'transparent',
    textStyle: { color: '#9ca3af' },
    title: {
      text: `Retornos diarios log (${theme.value.labelA} vs ${theme.value.labelB})`,
      left: 'center',
      top: 4,
      textStyle: { color: '#d1d5db', fontSize: 12, fontWeight: 'normal' },
    },
    tooltip: {
      trigger: 'item',
      formatter: (p: unknown) => {
        const d = p as { value: [number, number] }
        const v = d.value
        return `${(v[0] * 100).toFixed(2)}% (${theme.value.labelA})<br/>${(v[1] * 100).toFixed(2)}% (${theme.value.labelB})`
      },
    },
    grid: { left: 52, right: 24, top: 36, bottom: 40 },
    xAxis: {
      type: 'value',
      name: theme.value.labelA,
      nameLocation: 'middle',
      nameGap: 28,
      axisLabel: {
        color: '#6b7280',
        formatter: (v: number) => `${(v * 100).toFixed(1)}%`,
      },
      splitLine: { lineStyle: { color: '#374151' } },
    },
    yAxis: {
      type: 'value',
      name: theme.value.labelB,
      axisLabel: {
        color: '#6b7280',
        formatter: (v: number) => `${(v * 100).toFixed(1)}%`,
      },
      splitLine: { lineStyle: { color: '#374151' } },
    },
    series: [
      {
        type: 'scatter',
        symbolSize: 5,
        itemStyle: { color: '#a78bfa', opacity: 0.65 },
        data: scatterPairs.value,
      },
    ],
  }
}

async function loadSeries() {
  loading.value = true
  err.value = ''
  dates.value = []
  seriesA.value = []
  seriesB.value = []
  normA.value = []
  normB.value = []
  scatterPairs.value = []
  disposeCharts()

  const t = theme.value
  if (isCustomPair.value && (!t.tickerA || !t.tickerB)) {
    loading.value = false
    await nextTick()
    return
  }

  try {
    const [idA, idB] = await Promise.all([
      searchStockByTicker(t.tickerA),
      searchStockByTicker(t.tickerB),
    ])
    if (idA == null || idB == null) {
      err.value =
        `No se encontró en la base uno de los tickers (${t.tickerA} / ${t.tickerB}). Agregá esos símbolos como stocks o usá tickers que ya existan en tu API.`
      return
    }
    const [rawA, rawB] = await Promise.all([
      fetchOHLCV(idA, period.value),
      fetchOHLCV(idB, period.value),
    ])
    const aligned = alignByDate(
      rawA.data.map(r => ({ date: r.date, close: r.close })),
      rawB.data.map(r => ({ date: r.date, close: r.close })),
    )
    if (aligned.length < 10) {
      err.value = 'Pocos datos alineados para este par y periodo.'
      return
    }
    const ca = aligned.map(x => x.ca)
    const cb = aligned.map(x => x.cb)
    const baseA = ca[0]
    const baseB = cb[0]
    dates.value = aligned.map(x => x.date)
    seriesA.value = ca
    seriesB.value = cb
    normA.value = ca.map(c => (c / baseA) * 100)
    normB.value = cb.map(c => (c / baseB) * 100)

    const ra = logReturns(ca)
    const rb = logReturns(cb)
    const pairs: [number, number][] = []
    for (let i = 0; i < ra.length; i++) {
      pairs.push([ra[i], rb[i]])
    }
    scatterPairs.value = pairs
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : String(e)
    err.value = msg || 'Error al cargar precios'
  } finally {
    loading.value = false
    await nextTick()
    initCharts()
  }
}

function initCharts() {
  if (!dates.value.length) return
  if (chartPriceRef.value) {
    chartPrice.value = echarts.init(chartPriceRef.value)
    chartPrice.value.setOption(buildPriceOption())
  }
  if (chartScatterRef.value && scatterPairs.value.length) {
    chartScatter.value = echarts.init(chartScatterRef.value)
    chartScatter.value.setOption(buildScatterOption())
  }
}

function applyCustomPair() {
  const a = draftTickerA.value.trim().toUpperCase()
  const b = draftTickerB.value.trim().toUpperCase()
  if (!a || !b) {
    err.value = 'Completá ambos tickers.'
    return
  }
  if (a === b) {
    err.value = 'Elegí dos símbolos distintos.'
    return
  }
  err.value = ''
  customTickerA.value = a
  customTickerB.value = b
  void loadSeries()
}

watch([selectedId, period], () => {
  if (isCustomPair.value) {
    if (customTickerA.value && customTickerB.value) void loadSeries()
    return
  }
  void loadSeries()
})

onMounted(() => {
  if (!isCustomPair.value) void loadSeries()
  window.addEventListener('resize', onResize)
})

function onResize() {
  chartPrice.value?.resize()
  chartScatter.value?.resize()
}

onUnmounted(() => {
  window.removeEventListener('resize', onResize)
  disposeCharts()
})

function relationBadgeClass(kind: RelationKind): string {
  if (kind === 'inverse') return 'bg-rose-500/15 text-rose-300 border border-rose-500/30'
  if (kind === 'direct') return 'bg-emerald-500/15 text-emerald-300 border border-emerald-500/30'
  return 'bg-amber-500/15 text-amber-200 border border-amber-500/30'
}

function fmtCorr(c: number | null): string {
  if (c == null) return '—'
  return c.toLocaleString('es-ES', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
}
</script>

<template>
  <div>
    <h1 class="text-3xl font-bold text-white mb-2">Correlaciones y regímenes</h1>
    <p class="text-gray-400 text-sm mb-6 max-w-3xl">
      Guía de relaciones que a menudo se comentan en mercados (petróleo y aerolíneas, tasas y REITs, etc.).
      También podés comparar <span class="text-gray-200">cualquier par de tickers</span> que tengas en la base (p. ej. AGNC vs SCHW).
      Los gráficos muestran precios normalizados a 100 al inicio de la ventana y una nube de retornos diarios.
      Esto no es asesoramiento: las correlaciones cambian con el tiempo y con el régimen macro.
    </p>

    <div class="flex flex-wrap gap-2 mb-6">
      <button
        type="button"
        class="px-3 py-1.5 rounded-lg text-sm font-medium border transition-colors"
        :class="
          isCustomPair
            ? 'bg-primary-600/30 border-primary-500 text-primary-200'
            : 'bg-gray-800/80 border-gray-700 text-gray-300 hover:border-gray-600'
        "
        @click="selectedId = CUSTOM_THEME_ID"
      >
        Par personalizado
      </button>
      <button
        v-for="m in MACRO_THEMES"
        :key="m.id"
        type="button"
        class="px-3 py-1.5 rounded-lg text-sm font-medium border transition-colors"
        :class="
          m.id === selectedId
            ? 'bg-primary-600/30 border-primary-500 text-primary-200'
            : 'bg-gray-800/80 border-gray-700 text-gray-300 hover:border-gray-600'
        "
        @click="selectedId = m.id"
      >
        {{ m.title }}
      </button>
    </div>

    <div class="grid lg:grid-cols-3 gap-6 mb-6">
      <div class="lg:col-span-2 card">
        <h2 class="text-lg font-semibold text-white mb-2">{{ theme.title }}</h2>
        <p class="text-gray-300 text-sm leading-relaxed mb-4">{{ theme.summary }}</p>
        <ul class="list-disc list-inside text-sm text-gray-400 space-y-1 mb-4">
          <li v-for="(b, i) in theme.bullets" :key="i">{{ b }}</li>
        </ul>
        <div class="flex flex-wrap gap-2 items-center">
          <span
            class="text-xs font-medium px-2 py-1 rounded-md"
            :class="relationBadgeClass(theme.relation)"
          >
            {{ theme.relation === 'inverse' ? 'Tendencia típica: inversa' : theme.relation === 'direct' ? 'Tendencia típica: misma dirección' : 'Contexto / mixto' }}
          </span>
          <span class="text-xs text-gray-500">{{ theme.relationLabel }}</span>
        </div>
      </div>

      <div class="card space-y-4">
        <div v-if="isCustomPair" class="rounded-lg border border-gray-700 bg-gray-900/50 p-3 space-y-3">
          <p class="text-xs text-gray-400 font-medium">Ticker A vs ticker B</p>
          <div class="grid grid-cols-2 gap-2">
            <div>
              <label class="text-xs text-gray-500">Primero</label>
              <input
                v-model="draftTickerA"
                type="text"
                autocomplete="off"
                placeholder="AGNC"
                class="input-field mt-1 w-full font-mono uppercase"
                @keydown.enter.prevent="applyCustomPair"
              >
            </div>
            <div>
              <label class="text-xs text-gray-500">Segundo</label>
              <input
                v-model="draftTickerB"
                type="text"
                autocomplete="off"
                placeholder="SCHW"
                class="input-field mt-1 w-full font-mono uppercase"
                @keydown.enter.prevent="applyCustomPair"
              >
            </div>
          </div>
          <button type="button" class="w-full py-2 rounded-lg bg-primary-600 hover:bg-primary-500 text-white text-sm font-medium" @click="applyCustomPair">
            Comparar
          </button>
          <p v-if="!customTickerA || !customTickerB" class="text-xs text-gray-500">
            Elegí dos símbolos y pulsá Comparar para cargar los gráficos.
          </p>
        </div>
        <div>
          <label class="text-xs text-gray-400">Periodo OHLCV</label>
          <select v-model="period" class="input-field mt-1 w-full">
            <option value="1y">1 año</option>
            <option value="2y">2 años</option>
            <option value="5y">5 años</option>
          </select>
        </div>
        <div class="rounded-lg bg-gray-900/80 border border-gray-800 p-3">
          <p class="text-xs text-gray-500 uppercase tracking-wide mb-2">Indicadores (ventana cargada)</p>
          <div class="space-y-2 text-sm">
            <div class="flex justify-between gap-2">
              <span class="text-gray-400">Par</span>
              <span class="text-gray-200 font-mono text-right">{{ theme.tickerA }} / {{ theme.tickerB }}</span>
            </div>
            <div class="flex justify-between gap-2">
              <span class="text-gray-400">Correlación Pearson (retornos log diarios)</span>
              <span class="text-primary-300 font-mono">{{ fmtCorr(corrReturns) }}</span>
            </div>
            <p class="text-xs text-gray-500 pt-1">
              Positiva: suelen moverse a la misma dirección en el día; negativa: opuestos. Valor absoluto alto = más lineal la nube.
            </p>
          </div>
        </div>
      </div>
    </div>

    <p v-if="err" class="text-amber-400 text-sm mb-4">{{ err }}</p>
    <p v-else-if="loading" class="text-gray-400 text-sm mb-4">Cargando series…</p>

    <div class="flex flex-col gap-6">
      <div class="card">
        <h3 class="text-sm font-medium text-gray-300 mb-2">Gráfico 1 — Precios normalizados (base 100)</h3>
        <p class="text-xs text-gray-500 mb-2">
          Comparás forma y timing sin mezclar escalas de precio distintas.
        </p>
        <div ref="chartPriceRef" class="w-full h-80" />
      </div>
      <div class="card">
        <h3 class="text-sm font-medium text-gray-300 mb-2">Gráfico 2 — Retornos diarios</h3>
        <p class="text-xs text-gray-500 mb-2">
          Cada punto es un día: eje A vs eje B. Patrón diagonal vs dispersión complementa el número de correlación.
        </p>
        <div ref="chartScatterRef" class="w-full h-80" />
      </div>
    </div>
  </div>
</template>
