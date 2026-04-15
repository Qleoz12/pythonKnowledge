<script setup lang="ts">
import { ref, watch, onMounted, computed } from 'vue'
import {
  fetchFairValueSummary,
  fetchFairValueSeries,
  fetchFairValueAnnualTable,
  fetchFairValueRevisions,
  upsertFairValueRevisions,
  deleteFairValueRevision,
} from '../services/api'
import type { FairValueSummary, FairValueSeries, FairValueAnnualRow, FairValueRevision } from '../types'
import FairValuePriceChart from './FairValuePriceChart.vue'

const props = defineProps<{ stockId: number; tickerYf: string }>()

const loading = ref(true)
const err = ref('')
const summary = ref<FairValueSummary | null>(null)
const series = ref<FairValueSeries | null>(null)
const annualRows = ref<FairValueAnnualRow[]>([])
const annualFveBasis = ref<'strict' | 'constant_latest'>('constant_latest')
const revisions = ref<FairValueRevision[]>([])

const granularity = ref<'daily' | 'weekly' | 'monthly'>('weekly')
const period = ref('5y')

const formDate = ref('')
const formFve = ref<number | null>(null)
const formUncertainty = ref('')
const saving = ref(false)
const formMsg = ref('')

const periods = ['1m', '3m', '6m', '1y', '2y', '5y']

const yearTo = new Date().getFullYear()
const yearFrom = yearTo - 6

const firstRangeDate = computed(() => {
  const d = series.value?.dates?.[0]
  return d && d.length >= 10 ? d.slice(0, 10) : ''
})

const currentYearAnnual = computed(() => annualRows.value.find(r => r.year === yearTo) ?? null)

const granularityLabelEs = computed(() => {
  if (granularity.value === 'weekly') return 'semanas'
  if (granularity.value === 'monthly') return 'meses'
  return 'días'
})

/** Últimas filas de la serie activa para revisar cierre vs FVE sin reingresar nada. */
const seriesTailRows = computed(() => {
  const s = series.value
  if (!s?.dates?.length) return []
  const take = 24
  const n = s.dates.length
  const from = Math.max(0, n - take)
  const out: {
    date: string
    close: number
    fve: number | null
    ratio: number | null
    undervalued: boolean
  }[] = []
  for (let i = from; i < n; i++) {
    out.push({
      date: s.dates[i],
      close: s.close[i],
      fve: s.fve[i] ?? null,
      ratio: s.price_to_fve[i] ?? null,
      undervalued: s.undervalued[i],
    })
  }
  return out
})

function ratioHintEs(ratio: number | null | undefined): string {
  if (ratio === null || ratio === undefined) return 'Cargá un FVE y guardá para ver el ratio.'
  if (ratio < 0.92) return 'Por debajo de tu FVE → respecto a tu número, el precio va más barato.'
  if (ratio > 1.08) return 'Por encima de tu FVE → respecto a tu número, el precio va más caro.'
  return 'Cerca de 1 → alineado con tu FVE (ni muy caro ni muy barato).'
}

function applyEffectiveDateToRangeStart() {
  const d = firstRangeDate.value
  if (!d) {
    formMsg.value = 'Esperá a que carguen los precios o ampliá el rango'
    return
  }
  formDate.value = d
  formMsg.value = `Fecha efectiva = ${d} (primer día del gráfico). Revisá el FVE y tocá Guardar.`
}

watch(revisions, (rev) => {
  if (!rev.length) return
  const sorted = [...rev].sort((a, b) => a.effective_date.localeCompare(b.effective_date))
  const last = sorted[sorted.length - 1]
  if (last && (formFve.value === null || formFve.value === 0)) {
    formFve.value = last.fair_value
  }
})

function defaultEffectiveDate(): string {
  const t = new Date()
  t.setFullYear(t.getFullYear() - 1)
  return `${t.getFullYear()}-${String(t.getMonth() + 1).padStart(2, '0')}-${String(t.getDate()).padStart(2, '0')}`
}

/** % of bars (with FVE) where close < FVE — matches Weekly/Daily selection. */
const undervaluedShare = computed(() => {
  const s = series.value
  if (!s?.has_fair_value || !s.fve.length) return null
  let n = 0
  let under = 0
  for (let i = 0; i < s.fve.length; i++) {
    if (s.fve[i] == null) continue
    n++
    if (s.undervalued[i]) under++
  }
  if (!n) return null
  return { pct: Math.round((under / n) * 1000) / 10, under, n }
})

const fveSanityWarning = computed(() => {
  const lp = summary.value?.last_price
  const fv = summary.value?.fair_value
  const r = summary.value?.price_to_fve
  if (lp == null || fv == null || fv <= 0 || r == null) return null
  if (r > 2.5 || r < 0.35) {
    return 'El FVE debería ser del mismo orden que el precio (ej. si el precio ~100, un FVE típico podría ser 80–120, no 0,70). Price/FVE = precio ÷ FVE.'
  }
  return null
})

const chartEmptyMessage = computed(() => {
  if (!series.value) return null
  if (!series.value.dates.length) {
    return {
      title: 'Sin historial de precios',
      body: 'Usá el botón Refresh en la cabecera de la acción para traer precios de Yahoo; después volvé a esta sección.',
    }
  }
  const hr = series.value.has_revisions ?? revisions.value.length > 0
  const hf = series.value.has_fair_value
  if (!hr) {
    return {
      title: 'Sin revisiones de FVE',
      body: 'Agregá al menos una fila: fecha efectiva + valor razonable. Sin eso no hay con qué comparar el precio.',
    }
  }
  if (!hf) {
    return {
      title: 'La fecha efectiva no cubre el gráfico',
      body: 'Tenés revisiones guardadas, pero la fecha efectiva es más reciente que los precios del gráfico (ej. solo 2026 en un rango de 5 años). Pone la fecha efectiva en el primer día en que aplica tu FVE (fecha del informe, o hace 1–3 años) y guardá de nuevo, o agregá más revisiones históricas.',
    }
  }
  return null
})

async function loadAll() {
  loading.value = true
  err.value = ''
  try {
    const [s, rev] = await Promise.all([
      fetchFairValueSummary(props.stockId, true),
      fetchFairValueRevisions(props.stockId),
    ])
    summary.value = s
    revisions.value = rev
    if (rev.length === 0) {
      formDate.value = defaultEffectiveDate()
    }
    await loadSeriesAndAnnual()
  } catch (e: any) {
    err.value = e.response?.data?.detail || e.message || 'Failed to load'
  } finally {
    loading.value = false
  }
}

function onAnnualBasisChange() {
  loadSeriesAndAnnual().catch(() => {})
}

async function loadSeriesAndAnnual() {
  const [ser, ann] = await Promise.all([
    fetchFairValueSeries(props.stockId, {
      granularity: granularity.value,
      period: period.value,
      ensureOhlcv: true,
    }),
    fetchFairValueAnnualTable(props.stockId, {
      yearFrom,
      yearTo,
      annualFveBasis: annualFveBasis.value,
    }),
  ])
  series.value = ser
  annualRows.value = ann.rows
}

async function submitRevision() {
  if (!formDate.value || formFve.value == null || formFve.value <= 0) {
    formMsg.value = 'Completá fecha y un FVE mayor a 0'
    return
  }
  saving.value = true
  formMsg.value = ''
  try {
    await upsertFairValueRevisions(props.stockId, {
      revisions: [
        {
          effective_date: formDate.value,
          fair_value: formFve.value,
          uncertainty: formUncertainty.value || undefined,
          source: 'manual',
        },
      ],
    })
    formMsg.value = 'Guardado'
    await loadAll()
  } catch (e: any) {
    formMsg.value = e.response?.data?.detail || e.message || 'Error al guardar'
  } finally {
    saving.value = false
  }
}

async function removeRevision(id: number) {
  if (!window.confirm('¿Eliminar esta revisión de FVE?')) return
  try {
    await deleteFairValueRevision(props.stockId, id)
    await loadAll()
  } catch (e: any) {
    formMsg.value = e.response?.data?.detail || e.message
  }
}

function fmt(n: number | null | undefined, d = 2): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: d, maximumFractionDigits: d })
}

const headerSubtitle = computed(() => {
  if (!summary.value?.has_fair_value) {
    return 'Cargá tu FVE abajo. El gráfico solo aparece si la fecha efectiva entra en el rango de precios.'
  }
  return `FVE vigente desde ${summary.value.fair_value_as_of || '—'}`
})

watch(() => props.stockId, () => {
  formFve.value = null
  loadAll()
})
watch([granularity, period], () => {
  loadSeriesAndAnnual().catch(() => {})
})

onMounted(() => {
  formDate.value = defaultEffectiveDate()
  loadAll()
})

</script>

<template>
  <div class="card mb-8">
      <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-4 mb-4">
      <div>
        <h3 class="text-lg font-semibold text-white">Precio vs. valor razonable (FVE)</h3>
        <p class="text-sm text-gray-400">{{ headerSubtitle }}</p>
        <p class="text-xs text-gray-500 mt-1">
          El FVE no se calcula acá: es el número del informe (ej. Morningstar) en la misma moneda que el ticker.
          Solo cargás <strong class="text-gray-400">fecha del informe</strong> + <strong class="text-gray-400">FVE</strong>; precio cierre, Price/FVE y el gráfico por semana/mes/día salen solos con Yahoo.
        </p>
      </div>
      <div v-if="summary" class="flex flex-wrap gap-3 text-sm">
        <div class="px-3 py-2 rounded-lg bg-gray-800/80 border border-gray-700">
          <span class="text-gray-500">Último</span>
          <span class="ml-2 font-mono text-white">{{ fmt(summary.last_price) }}</span>
        </div>
        <div class="px-3 py-2 rounded-lg bg-gray-800/80 border border-gray-700">
          <span class="text-gray-500">FVE</span>
          <span class="ml-2 font-mono text-sky-300">{{ fmt(summary.fair_value) }}</span>
        </div>
        <div class="px-3 py-2 rounded-lg bg-gray-800/80 border border-gray-700">
          <span class="text-gray-500">Price/FVE</span>
          <span class="ml-2 font-mono text-white">{{ fmt(summary.price_to_fve, 3) }}</span>
        </div>
        <div class="px-3 py-2 rounded-lg bg-gray-800/80 border border-gray-700">
          <span class="text-gray-500">Incertidumbre</span>
          <span class="ml-2 text-amber-200">{{ summary.uncertainty || '—' }}</span>
        </div>
      </div>
    </div>

    <div
      v-if="fveSanityWarning && summary"
      class="mb-4 text-sm text-amber-100 bg-amber-950/40 border border-amber-800 rounded-lg px-3 py-2"
    >
      {{ fveSanityWarning }}
    </div>

    <div v-if="loading" class="text-gray-400 text-sm py-8 text-center">Cargando…</div>
    <div v-else-if="err" class="text-red-400 text-sm py-4">{{ err }}</div>
    <template v-else>
      <p class="text-xs text-violet-200/90 mb-3">
        <strong>Segundo gráfico</strong> (precio vs FVE). El de velas quedó solo arriba.
      </p>

      <div class="flex flex-wrap items-center gap-3 mb-3">
        <label class="text-xs text-gray-500">Vista</label>
        <select v-model="granularity" class="input-field text-sm py-1 w-36">
          <option value="weekly">Semanal</option>
          <option value="monthly">Mensual</option>
          <option value="daily">Diaria</option>
        </select>
        <label class="text-xs text-gray-500">Rango</label>
        <select v-model="period" class="input-field text-sm py-1 w-24">
          <option v-for="p in periods" :key="p" :value="p">{{ p }}</option>
        </select>
        <span class="text-xs text-gray-500">{{ tickerYf }}</span>
      </div>

      <div class="rounded-lg border border-gray-700 bg-gray-900/50 p-3 mb-4">
        <h4 class="text-xs font-medium text-gray-300 mb-2">Una vez: fecha del informe + FVE (guardar)</h4>
        <div class="flex flex-wrap gap-3 items-end">
          <div>
            <label class="text-xs text-gray-500">Fecha efectiva</label>
            <input v-model="formDate" type="date" class="input-field mt-1 block w-40" />
          </div>
          <div>
            <label class="text-xs text-gray-500">Valor razonable (FVE)</label>
            <input v-model.number="formFve" type="number" min="0.01" step="0.01" class="input-field mt-1 w-32" placeholder="ej. 105" />
          </div>
          <button type="button" class="btn-primary text-sm h-9 px-4" :disabled="saving" @click="submitRevision">
            {{ saving ? '…' : 'Guardar' }}
          </button>
          <details class="text-xs border border-gray-600 rounded-lg px-2 py-1 bg-gray-800/50">
            <summary class="cursor-pointer text-gray-400 select-none py-1">Opcional</summary>
            <div class="pt-2 pb-1 space-y-2 min-w-[12rem]">
              <div>
                <label class="text-gray-500 block mb-0.5">Incertidumbre</label>
                <select v-model="formUncertainty" class="input-field w-full text-xs py-1">
                  <option value="">—</option>
                  <option value="low">Baja</option>
                  <option value="medium">Media</option>
                  <option value="high">Alta</option>
                </select>
              </div>
              <button
                type="button"
                class="text-sky-400 hover:text-sky-300 disabled:text-gray-600 text-left w-full"
                :disabled="!firstRangeDate"
                @click="applyEffectiveDateToRangeStart"
              >
                Fecha = inicio del rango ({{ firstRangeDate || '…' }})
              </button>
            </div>
          </details>
        </div>
        <p v-if="formMsg" class="text-xs mt-2" :class="formMsg.includes('Error') || formMsg.includes('Completá') ? 'text-red-400' : 'text-green-400'">
          {{ formMsg }}
        </p>
      </div>

      <div v-if="series?.has_fair_value && series.dates.length" class="mb-4">
        <FairValuePriceChart
          :key="`fve-${stockId}-${granularity}-${period}`"
          :series="series"
        />
        <details class="mt-3 text-xs border border-gray-700 rounded-lg bg-gray-900/40">
          <summary class="cursor-pointer text-gray-400 hover:text-gray-300 select-none px-3 py-2">
            Tabla: últimas {{ seriesTailRows.length }} barras (cierre, FVE, Price/FVE)
          </summary>
          <div class="overflow-x-auto max-h-56 overflow-y-auto px-2 pb-2">
            <table class="w-full text-left text-[11px]">
              <thead class="text-gray-500 sticky top-0 bg-gray-900">
                <tr>
                  <th class="p-1.5">Fecha</th>
                  <th class="p-1.5">Cierre</th>
                  <th class="p-1.5">FVE</th>
                  <th class="p-1.5">P/FVE</th>
                  <th class="p-1.5">vs FVE</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="(row, idx) in seriesTailRows"
                  :key="`${row.date}-${idx}`"
                  class="border-t border-gray-800"
                >
                  <td class="p-1.5 font-mono text-gray-300">{{ row.date.slice(0, 10) }}</td>
                  <td class="p-1.5 font-mono">{{ fmt(row.close, 2) }}</td>
                  <td class="p-1.5 font-mono text-sky-300/90">{{ row.fve != null ? fmt(row.fve, 2) : '—' }}</td>
                  <td class="p-1.5 font-mono">{{ row.ratio != null ? fmt(row.ratio, 3) : '—' }}</td>
                  <td class="p-1.5">
                    <span v-if="row.fve == null" class="text-gray-600">—</span>
                    <span v-else-if="row.undervalued" class="text-sky-400/90">Debajo</span>
                    <span v-else class="text-orange-300/90">Encima</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </details>
      </div>
      <div
        v-else-if="chartEmptyMessage"
        class="text-sm text-amber-200/90 bg-amber-950/30 border border-amber-900 rounded-lg p-4 mb-4 space-y-2"
      >
        <p class="font-medium text-amber-100">{{ chartEmptyMessage.title }}</p>
        <p class="text-amber-200/85 leading-relaxed">{{ chartEmptyMessage.body }}</p>
      </div>

      <details class="mb-4 text-xs text-gray-300 border border-emerald-900/40 rounded-lg px-3 py-2 bg-emerald-950/15">
        <summary class="cursor-pointer text-emerald-300/90 select-none">Guía: este año vs años anteriores</summary>
        <ol class="mt-2 list-decimal pl-4 space-y-1.5 text-gray-400">
          <li><strong class="text-gray-300">Este año:</strong> tarjeta verde más abajo.</li>
          <li><strong class="text-gray-300">Años viejos:</strong> tabla anual en <strong class="text-gray-200">Auto (último FVE)</strong>.</li>
          <li><strong class="text-gray-300">Sin gráfico naranja:</strong> usá «Opcional → Fecha = inicio del rango» y un FVE parecido al precio.</li>
        </ol>
      </details>

      <div
        v-if="annualRows.length"
        class="mb-4 rounded-lg border border-green-800/50 bg-green-950/25 px-4 py-3 text-sm"
      >
        <p class="text-xs font-medium uppercase tracking-wide text-green-300/90 mb-2">Año en curso ({{ yearTo }})</p>
        <div class="flex flex-wrap gap-x-6 gap-y-2 items-baseline">
          <div>
            <span class="text-gray-500 text-xs">Última sesión en datos</span>
            <p class="font-mono text-white">{{ currentYearAnnual?.last_date ?? '—' }}</p>
          </div>
          <div>
            <span class="text-gray-500 text-xs">Price/FVE</span>
            <p class="font-mono text-lg text-white">
              {{
                currentYearAnnual?.price_to_fve != null
                  ? fmt(currentYearAnnual.price_to_fve, 3)
                  : (summary?.price_to_fve != null ? fmt(summary.price_to_fve, 3) : '—')
              }}
            </p>
          </div>
          <div class="max-w-md">
            <span class="text-gray-500 text-xs">Lectura rápida</span>
            <p class="text-green-100/90 leading-snug">
              {{
                ratioHintEs(
                  currentYearAnnual?.price_to_fve ?? summary?.price_to_fve ?? undefined,
                )
              }}
            </p>
          </div>
        </div>
        <p v-if="annualFveBasis === 'constant_latest'" class="text-[11px] text-gray-500 mt-2">
          Años pasados: misma lógica en la tabla (columna Base «FVE actual» cuando no tenías otra revisión en esa fecha).
        </p>
      </div>

      <details class="mb-4 text-sm text-gray-300 border border-gray-700 rounded-lg px-3 py-2 bg-gray-900/50">
        <summary class="cursor-pointer text-sky-300/90 select-none">Definiciones (fecha, FVE, incertidumbre)</summary>
        <ul class="mt-2 space-y-2 text-xs text-gray-400 list-disc pl-4">
          <li><strong class="text-gray-300">Fecha efectiva:</strong> desde cuándo vale ese FVE hasta la próxima revisión.</li>
          <li><strong class="text-gray-300">FVE:</strong> mismo orden que el precio (USD, etc.).</li>
          <li><strong class="text-gray-300">Price/FVE:</strong> &lt;1 más barato que tu FVE; &gt;1 más caro.</li>
          <li><strong class="text-gray-300">Incertidumbre:</strong> solo etiqueta; no cambia el dibujo.</li>
        </ul>
      </details>

      <p v-if="undervaluedShare && series?.has_fair_value" class="text-xs text-gray-400 mb-4">
        En este rango ({{ granularityLabelEs }} con FVE):
        <strong class="text-sky-300">{{ undervaluedShare.pct }}%</strong> subvalorizado,
        <strong class="text-orange-300">{{ (100 - undervaluedShare.pct).toFixed(1) }}%</strong> sobrevalorizado ({{ undervaluedShare.n }} barras).
      </p>

      <div class="mb-6">
        <h4 class="text-sm font-medium text-gray-300 mb-2">Revisiones guardadas</h4>
        <div class="max-h-40 overflow-y-auto text-xs border border-gray-700 rounded-lg">
          <table class="w-full text-left">
            <thead class="bg-gray-800 sticky top-0 text-gray-400">
              <tr>
                <th class="p-2">Fecha</th>
                <th class="p-2">FVE</th>
                <th class="p-2">Inc.</th>
                <th class="p-2 w-16"></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="r in revisions" :key="r.id" class="border-t border-gray-800">
                <td class="p-2 font-mono text-gray-300">{{ r.effective_date }}</td>
                <td class="p-2 font-mono">{{ fmt(r.fair_value) }}</td>
                <td class="p-2 text-gray-400">{{ r.uncertainty || '—' }}</td>
                <td class="p-2">
                  <button type="button" class="text-red-400 hover:text-red-300" @click="removeRevision(r.id)">×</button>
                </td>
              </tr>
              <tr v-if="!revisions.length">
                <td colspan="4" class="p-3 text-gray-500">Ninguna</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div v-if="annualRows.length" class="mt-6">
        <div class="flex flex-wrap items-center justify-between gap-2 mb-2">
          <h4 class="text-sm font-medium text-gray-300">Anual: Price/FVE y retorno</h4>
          <div class="flex items-center gap-2 text-xs">
            <span class="text-gray-500">Price/FVE</span>
            <select
              v-model="annualFveBasis"
              class="input-field py-1 w-52 text-xs"
              @change="onAnnualBasisChange"
            >
              <option value="constant_latest">Auto (último FVE)</option>
              <option value="strict">Solo FVE histórico</option>
            </select>
          </div>
        </div>
        <p class="text-xs text-gray-500 mb-2">
          <strong class="text-gray-400">Auto:</strong> rellena años sin FVE en esa fecha usando tu última revisión como denominador (precio del año ÷ tu FVE actual). Sirve para ver caro/barato vs tu opinión hoy; no reemplaza un historial real de FVE por año.
          <strong class="text-gray-400 ml-1">Estricto:</strong> solo ratio si ya había FVE vigente al cierre (si no, “—”).
        </p>
        <div class="overflow-x-auto border border-gray-700 rounded-lg text-xs">
          <table class="w-full text-left">
            <thead class="bg-gray-800 text-gray-400">
              <tr>
                <th class="p-2">Year</th>
                <th class="p-2">Last session</th>
                <th class="p-2">Price/FVE</th>
                <th class="p-2">Base</th>
                <th class="p-2">Total return %</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in annualRows" :key="row.year" class="border-t border-gray-800">
                <td class="p-2 font-mono">{{ row.year }}</td>
                <td class="p-2 text-gray-400">{{ row.last_date }}</td>
                <td class="p-2 font-mono">{{ row.price_to_fve != null ? fmt(row.price_to_fve, 3) : '—' }}</td>
                <td class="p-2 text-gray-500">
                  <span v-if="row.price_to_fve_basis === 'step'" class="text-sky-400/90">Escalón</span>
                  <span v-else-if="row.price_to_fve_basis === 'constant_latest'" class="text-amber-200/90">FVE actual</span>
                  <span v-else>—</span>
                </td>
                <td class="p-2 font-mono" :class="row.total_return_pct != null && row.total_return_pct < 0 ? 'text-red-400' : 'text-green-400'">
                  {{ row.total_return_pct != null ? fmt(row.total_return_pct, 2) + '%' : '—' }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </template>
  </div>
</template>
