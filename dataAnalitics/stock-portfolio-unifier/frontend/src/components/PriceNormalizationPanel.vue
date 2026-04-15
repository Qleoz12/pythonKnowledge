<script setup lang="ts">
import { ref, reactive, computed, watch } from 'vue'
import { fetchPriceNormalization } from '../services/api'
import type { PriceNormalization } from '../types'
import { dividendScore, parsePercentToDecimal, parseNumber } from '../utils/dividendScore'

const props = defineProps<{ stockId: number }>()

const loading = ref(false)
const err = ref('')
const data = ref<PriceNormalization | null>(null)

/** Manual overrides: percents as user-facing % (4.15 = 4.15%); beta plain number; big fields plain number */
const man = reactive({
  yield: '',
  payout: '',
  growth: '',
  vol: '',
  beta: '',
  netIncome: '',
  ebitda: '',
  netDebt: '',
})

function clearManual() {
  man.yield = ''
  man.payout = ''
  man.growth = ''
  man.vol = ''
  man.beta = ''
  man.netIncome = ''
  man.ebitda = ''
  man.netDebt = ''
}

watch(
  () => props.stockId,
  () => {
    data.value = null
    clearManual()
    err.value = ''
  },
)

async function load() {
  loading.value = true
  err.value = ''
  try {
    data.value = await fetchPriceNormalization(props.stockId)
    clearManual()
  } catch (e: any) {
    const d = e.response?.data?.detail
    const raw = Array.isArray(d) ? d.map((x: any) => x.msg ?? x).join('; ') : d
    if (e.response?.status === 404 && (raw === 'Not Found' || raw === undefined)) {
      err.value =
        '404: el servidor no expone esta ruta (¿backend sin reiniciar tras el deploy?). Reiniciá uvicorn y probá de nuevo.'
    } else {
      err.value = raw || e.message || 'Error'
    }
    data.value = null
  } finally {
    loading.value = false
  }
}

defineExpose({ load })

const effYield = computed(() => {
  const m = parsePercentToDecimal(man.yield)
  if (m != null) return m
  return data.value?.dividend_yield ?? null
})

const effPayout = computed(() => {
  const m = parsePercentToDecimal(man.payout)
  if (m != null) return m
  return data.value?.payout_ratio ?? null
})

const effGrowth = computed(() => {
  const m = parsePercentToDecimal(man.growth)
  if (m != null) return m
  return data.value?.div_growth_5y_cagr ?? null
})

const effVol = computed(() => {
  const m = parsePercentToDecimal(man.vol)
  if (m != null) return m
  return data.value?.volatility_1y ?? null
})

const effBeta = computed(() => {
  const m = parseNumber(man.beta)
  if (m != null) return m
  return data.value?.beta ?? null
})

const effNetIncome = computed(() => {
  const m = parseNumber(man.netIncome)
  if (m != null) return m
  return data.value?.net_income_ttm ?? null
})

const effEbitda = computed(() => {
  const m = parseNumber(man.ebitda)
  if (m != null) return m
  return data.value?.ebitda_ttm ?? null
})

const effNetDebt = computed(() => {
  const m = parseNumber(man.netDebt)
  if (m != null) return m
  return data.value?.net_debt ?? null
})

const recalculatedScore = computed(() =>
  dividendScore(
    effYield.value,
    effPayout.value,
    effGrowth.value,
    effVol.value,
    effBeta.value,
  ),
)

const hasScoreOverride = computed(
  () =>
    man.yield.trim() !== ''
    || man.payout.trim() !== ''
    || man.growth.trim() !== ''
    || man.vol.trim() !== ''
    || man.beta.trim() !== '',
)

const hasDisplayOverride = computed(
  () =>
    man.netIncome.trim() !== ''
    || man.ebitda.trim() !== ''
    || man.netDebt.trim() !== '',
)

function fmt(n: number | null | undefined, d = 2): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: d, maximumFractionDigits: d })
}

function fmtPctDec(n: number | null | undefined, d = 2): string {
  if (n === null || n === undefined) return '—'
  return (n * 100).toLocaleString('en-US', { minimumFractionDigits: d, maximumFractionDigits: d }) + '%'
}

function fmtBig(n: number | null | undefined): string {
  if (n === null || n === undefined) return '—'
  const abs = Math.abs(n)
  const sign = n < 0 ? '-' : ''
  if (abs >= 1e12) return sign + (abs / 1e12).toFixed(2) + 'T'
  if (abs >= 1e9) return sign + (abs / 1e9).toFixed(2) + 'B'
  if (abs >= 1e6) return sign + (abs / 1e6).toFixed(2) + 'M'
  return sign + abs.toLocaleString('en-US', { maximumFractionDigits: 0 })
}
</script>

<template>
  <div class="card mb-8">
    <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-3 mb-4">
      <div>
        <h3 class="text-lg font-semibold text-white">Normalización de precio</h3>
        <p class="text-sm text-gray-400 max-w-3xl">
          Métricas en escala comparable (rendimiento, riesgo, reparto) y TTM desde estados trimestrales de Yahoo.
          No sustituye al <strong class="text-gray-300">Financial Health Score</strong> de arriba: ese usa datos cacheados al refrescar la acción;
          este bloque consulta Yahoo al momento y añade <strong class="text-gray-300">dividend score</strong>, volatilidad 1Y y P/B.
          Si Yahoo trae el yield en formato raro (ej. 4.15 en vez de 0.0415), el backend lo normaliza; igual podés corregir valores abajo y el score se recalcula en el navegador.
        </p>
      </div>
      <button
        type="button"
        class="btn-primary text-sm shrink-0 h-9 px-4"
        :disabled="loading"
        @click="load"
      >
        {{ loading ? 'Cargando…' : (data ? 'Actualizar' : 'Cargar desde Yahoo') }}
      </button>
    </div>

    <p v-if="err" class="text-sm text-red-400 mb-2">{{ err }}</p>

    <div v-if="data" class="space-y-4">
      <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3 text-sm">
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">Precio</p>
          <p class="font-mono text-white">{{ fmt(data.price) }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">Market cap</p>
          <p class="font-mono text-white">{{ fmtBig(data.market_cap) }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">Dividend yield</p>
          <p class="font-mono text-green-400">{{ fmtPctDec(effYield) }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">Payout ratio</p>
          <p class="font-mono text-white">{{ fmtPctDec(effPayout) }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">5Y div growth (CAGR)</p>
          <p class="font-mono text-white">{{ fmtPctDec(effGrowth) }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">Volatility (1Y ann.)</p>
          <p class="font-mono text-amber-200">{{ fmtPctDec(effVol) }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">Beta</p>
          <p class="font-mono text-white">{{ effBeta != null ? fmt(effBeta, 2) : '—' }}</p>
        </div>
        <div class="p-3 bg-sky-950/40 border border-sky-800/50 rounded-lg">
          <p class="text-xs text-sky-300/90">Dividend score</p>
          <p class="text-xl font-bold font-mono text-sky-200">
            {{ recalculatedScore != null ? fmt(recalculatedScore, 2) : '—' }}
          </p>
          <p class="text-[10px] text-gray-500">
            0–100
            <span v-if="data.dividend_score != null && hasScoreOverride" class="text-gray-600">
              · Yahoo {{ fmt(data.dividend_score, 2) }}
            </span>
          </p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">Forward P/E</p>
          <p class="font-mono text-white">{{ fmt(data.forward_pe, 2) }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">Net income (TTM)</p>
          <p class="font-mono text-white">{{ fmtBig(effNetIncome) }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">EBITDA (TTM)</p>
          <p class="font-mono text-white">{{ fmtBig(effEbitda) }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">Net debt</p>
          <p class="font-mono text-white">{{ fmtBig(effNetDebt) }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">Balance sheet date</p>
          <p class="font-mono text-gray-300">{{ data.balance_sheet_date || '—' }}</p>
        </div>
        <div class="p-3 bg-gray-800/50 rounded-lg">
          <p class="text-xs text-gray-500">P/B (price to book)</p>
          <p class="font-mono text-white">{{ fmt(data.price_to_book, 2) }}</p>
        </div>
      </div>

      <details class="rounded-lg border border-gray-700 bg-gray-900/40 text-sm">
        <summary class="cursor-pointer text-gray-300 hover:text-white px-3 py-2 select-none">
          Corregir valores y recalcular dividend score
          <span
            v-if="hasScoreOverride || hasDisplayOverride"
            class="ml-2 text-amber-400 text-xs"
          >· edición manual activa</span>
        </summary>
        <div class="px-3 pb-3 pt-1 space-y-3">
          <p class="text-xs text-gray-500">
            Dejá vacío para usar Yahoo. Para el score: yield, payout, crecimiento y volatilidad en <strong class="text-gray-400">%</strong> (ej. 4,15 o 15,39); beta en número (ej. 0,56).
            Net income / EBITDA / net debt: número en la misma unidad que Yahoo (ej. 2.23e10 o 22285000000).
          </p>
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2">
            <label class="text-xs text-gray-400 flex flex-col gap-0.5">
              Dividend yield (%)
              <input v-model="man.yield" type="text" class="input-field text-xs py-1 font-mono" placeholder="ej. 4.15" />
            </label>
            <label class="text-xs text-gray-400 flex flex-col gap-0.5">
              Payout ratio (%)
              <input v-model="man.payout" type="text" class="input-field text-xs py-1 font-mono" placeholder="ej. 55" />
            </label>
            <label class="text-xs text-gray-400 flex flex-col gap-0.5">
              5Y div growth CAGR (%)
              <input v-model="man.growth" type="text" class="input-field text-xs py-1 font-mono" placeholder="ej. 15.39" />
            </label>
            <label class="text-xs text-gray-400 flex flex-col gap-0.5">
              Volatility 1Y anualizada (%)
              <input v-model="man.vol" type="text" class="input-field text-xs py-1 font-mono" placeholder="ej. 28" />
            </label>
            <label class="text-xs text-gray-400 flex flex-col gap-0.5">
              Beta
              <input v-model="man.beta" type="text" class="input-field text-xs py-1 font-mono" placeholder="ej. 0.38" />
            </label>
            <label class="text-xs text-gray-400 flex flex-col gap-0.5">
              Net income TTM (opcional, solo muestra)
              <input v-model="man.netIncome" type="text" class="input-field text-xs py-1 font-mono" placeholder="—" />
            </label>
            <label class="text-xs text-gray-400 flex flex-col gap-0.5">
              EBITDA TTM (opcional, solo muestra)
              <input v-model="man.ebitda" type="text" class="input-field text-xs py-1 font-mono" placeholder="—" />
            </label>
            <label class="text-xs text-gray-400 flex flex-col gap-0.5">
              Net debt (opcional, solo muestra)
              <input v-model="man.netDebt" type="text" class="input-field text-xs py-1 font-mono" placeholder="—" />
            </label>
          </div>
          <button type="button" class="text-xs text-sky-400 hover:text-sky-300" @click="clearManual">
            Limpiar correcciones
          </button>
        </div>
      </details>
    </div>
  </div>
</template>
