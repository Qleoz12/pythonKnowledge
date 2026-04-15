<script setup lang="ts">
import { ref, onMounted, computed, watch, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import type { DividendCalendarItem, DividendCalendarNote } from '../types'
import {
  fetchDividendCalendar,
  fetchDividendStats,
  fetchCalendarNotes,
  createCalendarNote,
  deleteCalendarNote,
  refreshDividendForward,
  createManualCalendarDividend,
  deleteManualCalendarDividend,
  searchStockByTicker,
} from '../services/api'
import { parseQualifiedEquityInput } from '../utils/qualifiedSearch'

type CalCell = { date: string; day: number; inMonth: boolean; items: DividendCalendarItem[]; hasNotes: boolean }

const router = useRouter()
const items = ref<DividendCalendarItem[]>([])
const calendarNotes = ref<DividendCalendarNote[]>([])
const stats = ref<any>(null)
const loading = ref(true)
const loadError = ref('')
const navigating = ref<string | null>(null)
const filterExchange = ref('')
const filterSource = ref('')
const filterQuanfuryOnly = ref(false)
const viewMode = ref<'list' | 'calendar'>('calendar')
const refreshBusy = ref(false)
const refreshMsg = ref('')

/** Day detail modal (calendar view): click a cell to list every dividend that day. */
const dayModalOpen = ref(false)
/** YYYY-MM-DD for the open modal; list comes from `dayModalItems` so it stays in sync after reload. */
const dayModalDate = ref<string | null>(null)
const dayModalBackdropRef = ref<HTMLElement | null>(null)

const dayModalItems = computed(() => {
  const d = dayModalDate.value
  if (!d) return []
  return filteredItems.value.filter(i => i.date === d)
})

const dayModalNotes = computed(() => {
  const d = dayModalDate.value
  if (!d) return []
  return calendarNotes.value.filter(n => n.note_date === d)
})

const manualTickerInput = ref('')
const manualAmountInput = ref('')
const manualCompanyInput = ref('')
const manualNoteInput = ref('')
const manualBusy = ref(false)
const manualErr = ref('')

watch([dayModalOpen, dayModalDate], async () => {
  if (dayModalOpen.value && dayModalDate.value) {
    await nextTick()
    dayModalBackdropRef.value?.focus()
  }
})

function openDayModal(cell: CalCell) {
  dayModalDate.value = cell.date
  dayModalOpen.value = true
  manualErr.value = ''
  noteErr.value = ''
  modalNewNoteBody.value = ''
}

function closeDayModal() {
  dayModalOpen.value = false
  dayModalDate.value = null
  manualErr.value = ''
}

function tipranksDividendDayUrl(ymd: string) {
  return `https://www.tipranks.com/calendars/dividends/${ymd}`
}

function finvizDividendDayUrl(ymd: string) {
  return `https://finviz.com/calendar/dividends?dateFrom=${encodeURIComponent(ymd)}&sort=-yield&page=1`
}

const TRADINGVIEW_DIV_CAL = 'https://es.tradingview.com/dividend-calendar/'

async function submitManualDividend() {
  const d = dayModalDate.value
  if (!d || manualBusy.value) return
  manualErr.value = ''
  const pq = parseQualifiedEquityInput(manualTickerInput.value)
  const ticker_yf = (pq.yahooTicker || pq.displaySymbol || '').trim()
  if (!ticker_yf) {
    manualErr.value = 'Indica un ticker (ej. WB o WB : NASDAQ).'
    return
  }
  const amt = Number.parseFloat(String(manualAmountInput.value).replace(',', '.'))
  if (!Number.isFinite(amt) || amt <= 0) {
    manualErr.value = 'Importe del dividendo debe ser un número mayor que 0.'
    return
  }
  manualBusy.value = true
  try {
    await createManualCalendarDividend({
      div_date: d,
      ticker_yf,
      amount: amt,
      currency: 'USD',
      company_name: manualCompanyInput.value.trim() || undefined,
      note: manualNoteInput.value.trim() || undefined,
    })
    manualTickerInput.value = ''
    manualAmountInput.value = ''
    manualCompanyInput.value = ''
    manualNoteInput.value = ''
    await loadData()
    try {
      stats.value = await fetchDividendStats()
    } catch {
      /* ignore */
    }
  } catch (e: unknown) {
    manualErr.value = manualSaveErrorMessage(e)
  } finally {
    manualBusy.value = false
  }
}

async function removeManualEntry(item: DividendCalendarItem) {
  const id = item.manual_entry_id
  if (id == null || manualBusy.value) return
  if (!window.confirm(`Eliminar la fila manual ${item.ticker} del ${item.date}?`)) return
  manualBusy.value = true
  manualErr.value = ''
  try {
    await deleteManualCalendarDividend(id)
    await loadData()
    try {
      stats.value = await fetchDividendStats()
    } catch {
      /* ignore */
    }
  } catch (e: unknown) {
    manualErr.value = manualSaveErrorMessage(e)
  } finally {
    manualBusy.value = false
  }
}

function formatModalDate(ymd: string): string {
  const d = parseYMD(ymd)
  return d.toLocaleDateString(undefined, {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

function toLocalYMD(d: Date): string {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

/** Parse YYYY-MM-DD in local time (no UTC shift). */
function parseYMD(s: string): Date {
  const parts = s.split('-').map(Number)
  const y = parts[0]
  const m = parts[1]
  const day = parts[2] || 1
  if (!y || !m) return new Date()
  return new Date(y, m - 1, day)
}

function getMonthStart(): string {
  const d = new Date()
  return toLocalYMD(new Date(d.getFullYear(), d.getMonth(), 1))
}

/** Last day of the 3rd month in the window starting at the 1st of `start` month. */
function getThreeMonthWindowEndFromStart(startYmd: string): string {
  const base = parseYMD(startYmd)
  const y = base.getFullYear()
  const m0 = base.getMonth()
  const last = new Date(y, m0 + 3, 0)
  return toLocalYMD(last)
}

const startDate = ref(getMonthStart())
const endDate = ref(getThreeMonthWindowEndFromStart(startDate.value))

function fridayOnOrAfterTodayYmd(): string {
  const d = new Date()
  d.setHours(0, 0, 0, 0)
  const dow = d.getDay()
  const add = (5 - dow + 7) % 7
  d.setDate(d.getDate() + add)
  return toLocalYMD(d)
}

const quickNoteDate = ref(fridayOnOrAfterTodayYmd())
const quickNoteBody = ref('')
const modalNewNoteBody = ref('')
const noteBusy = ref(false)
const noteErr = ref('')

function apiErrorMessage(e: unknown): string {
  const err = e as { message?: string; response?: { status?: number; data?: { detail?: unknown } } }
  const d = err.response?.data?.detail
  if (typeof d === 'string') return d
  if (Array.isArray(d)) return d.map((x: { msg?: string }) => x.msg).filter(Boolean).join('; ') || 'Request failed'
  if (err.message === 'Network Error' || !err.response) {
    return 'Cannot reach API. Run the backend on port 8000 and use Vite dev proxy.'
  }
  return err.message || 'Failed to load'
}

/** Guardar manual: mensajes claros si el backend es viejo o la ruta no existe. */
function manualSaveErrorMessage(e: unknown): string {
  const err = e as { message?: string; response?: { status?: number; data?: { detail?: unknown } } }
  const st = err.response?.status
  const d = err.response?.data?.detail
  if (st === 404 || (typeof d === 'string' && d === 'Not Found')) {
    return '404: el servidor no tiene el endpoint de guardado manual (código antiguo o URL incorrecta). Cierra la ventana del backend, vuelve a ejecutar start.bat o `python main.py` en backend, y usa la app en http://localhost:5173 (proxy a :8000).'
  }
  if (st === 503 && typeof d === 'string') return d
  return apiErrorMessage(e)
}

onMounted(async () => {
  await loadData()
  try {
    stats.value = await fetchDividendStats()
  } catch {
    stats.value = null
  }
})

async function runForwardRefresh() {
  if (refreshBusy.value) return
  refreshBusy.value = true
  refreshMsg.value = ''
  loadError.value = ''
  try {
    const r = await refreshDividendForward({
      start_date: startDate.value,
      end_date: endDate.value,
      weeks_ahead: 5,
      max_stocks: 200,
    }) as Record<string, unknown>
    if (r.ok === false) {
      refreshMsg.value = typeof r.error === 'string' ? r.error : 'Refresh failed'
      return
    }
    const seasonal = typeof r.seasonal_rows_inserted === 'number' ? r.seasonal_rows_inserted : 0
    const yex = typeof r.yahoo_ex_rows_upserted === 'number' ? r.yahoo_ex_rows_upserted : 0
    const n = typeof r.universe_stock_count === 'number' ? r.universe_stock_count : 0
    refreshMsg.value = `Universe ${n} tickers (paid last year in this season) · seasonal rows ${seasonal} · Yahoo ex-date rows ${yex}`
    await loadData()
    try {
      stats.value = await fetchDividendStats()
    } catch {
      /* keep previous stats */
    }
  } catch (e: unknown) {
    loadError.value = apiErrorMessage(e)
  } finally {
    refreshBusy.value = false
  }
}

async function loadData() {
  loading.value = true
  loadError.value = ''
  try {
    const params: Record<string, unknown> = {
      start_date: startDate.value,
      end_date: endDate.value,
    }
    if (filterExchange.value) params.exchange = filterExchange.value
    if (filterQuanfuryOnly.value) params.quanfury_only = true
    const noteParams = { start_date: startDate.value, end_date: endDate.value }
    const [cal, notes] = await Promise.all([
      fetchDividendCalendar(params),
      fetchCalendarNotes(noteParams),
    ])
    items.value = cal
    calendarNotes.value = notes
  } catch (e: unknown) {
    loadError.value = apiErrorMessage(e)
    items.value = []
    calendarNotes.value = []
  } finally {
    loading.value = false
  }
}

async function refreshCalendarNotesOnly() {
  try {
    calendarNotes.value = await fetchCalendarNotes({
      start_date: startDate.value,
      end_date: endDate.value,
    })
  } catch {
    /* ignore */
  }
}

async function submitQuickCalendarNote() {
  const d = quickNoteDate.value
  const body = quickNoteBody.value.trim()
  if (!d || !body || noteBusy.value) return
  noteErr.value = ''
  noteBusy.value = true
  try {
    await createCalendarNote({ note_date: d, body })
    quickNoteBody.value = ''
    await refreshCalendarNotesOnly()
    try {
      stats.value = await fetchDividendStats()
    } catch {
      /* ignore */
    }
  } catch (e: unknown) {
    noteErr.value = apiErrorMessage(e)
  } finally {
    noteBusy.value = false
  }
}

async function submitModalCalendarNote() {
  const d = dayModalDate.value
  const body = modalNewNoteBody.value.trim()
  if (!d || !body || noteBusy.value) return
  noteBusy.value = true
  noteErr.value = ''
  try {
    await createCalendarNote({ note_date: d, body })
    modalNewNoteBody.value = ''
    await refreshCalendarNotesOnly()
    try {
      stats.value = await fetchDividendStats()
    } catch {
      /* ignore */
    }
  } catch (e: unknown) {
    noteErr.value = apiErrorMessage(e)
  } finally {
    noteBusy.value = false
  }
}

async function removeCalendarNoteRow(id: number) {
  if (noteBusy.value) return
  if (!window.confirm('¿Eliminar esta nota del calendario?')) return
  noteBusy.value = true
  noteErr.value = ''
  try {
    await deleteCalendarNote(id)
    await refreshCalendarNotesOnly()
    try {
      stats.value = await fetchDividendStats()
    } catch {
      /* ignore */
    }
  } catch (e: unknown) {
    noteErr.value = apiErrorMessage(e)
  } finally {
    noteBusy.value = false
  }
}

function calendarNotesForDate(ymd: string): DividendCalendarNote[] {
  return calendarNotes.value.filter(n => n.note_date === ymd)
}

async function goToStock(item: DividendCalendarItem) {
  if (navigating.value) return
  navigating.value = item.ticker

  try {
    if (item.stock_id) {
      router.push(`/stocks/${item.stock_id}`)
      return
    }
    const stockId = await searchStockByTicker(item.ticker)
    if (stockId) {
      router.push(`/stocks/${stockId}`)
    }
  } finally {
    navigating.value = null
  }
}

async function goToStockFromModal(item: DividendCalendarItem) {
  closeDayModal()
  await goToStock(item)
}

const filteredItems = computed(() => {
  let result = items.value
  if (filterSource.value) {
    result = result.filter(i => i.source === filterSource.value)
  }
  return result
})

const groupedByDate = computed(() => {
  const groups: Record<string, DividendCalendarItem[]> = {}
  for (const item of filteredItems.value) {
    if (!groups[item.date]) groups[item.date] = []
    groups[item.date].push(item)
  }
  return Object.entries(groups).sort(([a], [b]) => a.localeCompare(b))
})

function buildMonthCells(
  year: number,
  month0: number,
  itemMap: Record<string, DividendCalendarItem[]>,
  noteDates: Set<string>,
): CalCell[] {
  const first = new Date(year, month0, 1)
  const pad = first.getDay()
  const gridStart = new Date(year, month0, 1 - pad)
  const cells: CalCell[] = []
  for (let i = 0; i < 42; i++) {
    const d = new Date(gridStart)
    d.setDate(gridStart.getDate() + i)
    const dateStr = toLocalYMD(d)
    cells.push({
      date: dateStr,
      day: d.getDate(),
      inMonth: d.getMonth() === month0,
      items: itemMap[dateStr] || [],
      hasNotes: noteDates.has(dateStr),
    })
  }
  return cells
}

/** Three full-width month grids stacked vertically, anchored to the month of `startDate`. */
const calendarMonths = computed(() => {
  const itemMap: Record<string, DividendCalendarItem[]> = {}
  for (const item of filteredItems.value) {
    if (!itemMap[item.date]) itemMap[item.date] = []
    itemMap[item.date].push(item)
  }
  const noteDates = new Set(calendarNotes.value.map(n => n.note_date))
  const base = parseYMD(startDate.value)
  const anchor = new Date(base.getFullYear(), base.getMonth(), 1)
  const out: { label: string; cells: CalCell[] }[] = []
  for (let k = 0; k < 3; k++) {
    const d = new Date(anchor.getFullYear(), anchor.getMonth() + k, 1)
    out.push({
      label: d.toLocaleDateString(undefined, { month: 'long', year: 'numeric' }),
      cells: buildMonthCells(d.getFullYear(), d.getMonth(), itemMap, noteDates),
    })
  }
  return out
})

const totalEventsInRange = computed(() => filteredItems.value.length)
const uniqueTickersInRange = computed(() => new Set(filteredItems.value.map(i => i.ticker)).size)

function fmt(n: number | null | undefined, decimals = 4): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}

function fmtPrice(n: number | null | undefined): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
}

function fmtAmount(n: number | null | undefined): string {
  if (n === null || n === undefined || Number.isNaN(n)) return '—'
  return Number(n).toFixed(2)
}

function yieldColor(y: number | null | undefined): string {
  if (!y) return 'text-gray-500'
  if (y >= 8) return 'text-green-400'
  if (y >= 4) return 'text-green-300'
  if (y >= 2) return 'text-yellow-400'
  return 'text-gray-400'
}

/** Move the 3-month window by one month; keeps end aligned to three full grids. */
function shiftMonth(delta: number) {
  const d = parseYMD(startDate.value)
  d.setMonth(d.getMonth() + delta)
  startDate.value = toLocalYMD(new Date(d.getFullYear(), d.getMonth(), 1))
  endDate.value = getThreeMonthWindowEndFromStart(startDate.value)
  loadData()
}

function syncEndToThreeMonthWindow() {
  endDate.value = getThreeMonthWindowEndFromStart(startDate.value)
}
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-6">
      <div>
        <h1 class="text-3xl font-bold text-white">Dividend Calendar</h1>
        <p v-if="stats" class="text-sm text-gray-400 mt-1">
          {{ stats.total_dividend_events?.toLocaleString() }} historical events ·
          {{ stats.total_quanfury_dividends?.toLocaleString() }} Quanfury dividends ·
          {{ (stats.total_forward_dividend_rows ?? 0).toLocaleString() }} forward rows ·
          {{ (stats.total_manual_calendar_rows ?? 0).toLocaleString() }} manual calendar rows ·
          {{ (stats.total_calendar_notes ?? 0).toLocaleString() }} day notes ·
          {{ stats.stocks_paying_dividends }} stocks paying dividends
        </p>
        <p class="text-xs text-gray-500 mt-1 max-w-2xl">
          Default range is three calendar months (historical DB + Quanfury + optional Yahoo projections). Use “Refresh Yahoo” to project
          +1 year from last season’s DB payouts for tickers that paid in that window, then confirm near dates with Yahoo (next five weeks).
          Cross-check with
          <a href="https://www.tipranks.com/calendars/dividends" class="text-primary-400 hover:underline" target="_blank" rel="noopener">TipRanks</a>,
          <a href="https://finviz.com/calendar/dividends" class="text-primary-400 hover:underline" target="_blank" rel="noopener">Finviz</a>, or
          <a href="https://es.tradingview.com/dividend-calendar/" class="text-primary-400 hover:underline" target="_blank" rel="noopener">TradingView</a>
          if you need a second source (not auto-scraped here).
        </p>
      </div>
      <div class="flex items-center gap-2">
        <button @click="viewMode = 'list'" :class="viewMode === 'list' ? 'btn-primary' : 'btn-secondary'" class="text-sm !px-3 !py-1.5">List</button>
        <button @click="viewMode = 'calendar'" :class="viewMode === 'calendar' ? 'btn-primary' : 'btn-secondary'" class="text-sm !px-3 !py-1.5">Calendar</button>
      </div>
    </div>

    <!-- Filters -->
    <div class="card mb-6">
      <div class="flex items-end gap-4 flex-wrap">
        <div>
          <label class="block text-xs text-gray-400">Start Date</label>
          <input v-model="startDate" type="date" class="input-field mt-1" @change="syncEndToThreeMonthWindow" />
        </div>
        <div>
          <label class="block text-xs text-gray-400">End Date</label>
          <input v-model="endDate" type="date" class="input-field mt-1" />
        </div>
        <div>
          <label class="block text-xs text-gray-400">Exchange</label>
          <select v-model="filterExchange" class="input-field mt-1">
            <option value="">All</option>
            <option value="TSX">TSX</option>
            <option value="NYSE">NYSE</option>
            <option value="LSE">LSE</option>
          </select>
        </div>
        <div>
          <label class="block text-xs text-gray-400">Source</label>
          <select v-model="filterSource" class="input-field mt-1">
            <option value="">All</option>
            <option value="historical">Historical</option>
            <option value="quanfury">Quanfury</option>
            <option value="yahoo_forward">Yahoo / projected</option>
            <option value="manual">Manual</option>
          </select>
        </div>
        <label class="flex items-center gap-2 text-sm text-gray-300 cursor-pointer pb-2">
          <input type="checkbox" v-model="filterQuanfuryOnly" class="w-4 h-4 rounded bg-gray-700 border-gray-600 text-primary-600" @change="loadData" />
          Quanfury only
        </label>
        <button type="button" class="btn-primary" @click="loadData">Apply</button>
        <button
          type="button"
          class="btn-secondary"
          :disabled="refreshBusy"
          :title="'Rebuild forward rows for tickers that paid in the DB during the same months last year; Yahoo checks the next five weeks.'"
          @click="runForwardRefresh"
        >
          {{ refreshBusy ? 'Refreshing…' : 'Refresh Yahoo' }}
        </button>
      </div>
      <p v-if="refreshMsg" class="text-xs text-amber-400/90 mt-2">{{ refreshMsg }}</p>

      <div class="mt-4 pt-4 border-t border-gray-800 space-y-2">
        <p class="text-xs font-medium text-violet-300 uppercase tracking-wide">Nota / recordatorio para un día</p>
        <p class="text-[11px] text-gray-500">
          Elige la fecha (ej. el viernes) y el texto. Ese día se resalta en el calendario con color y al abrirlo ves la nota arriba.
        </p>
        <div class="flex flex-col sm:flex-row sm:items-end gap-3 flex-wrap">
          <div>
            <label class="block text-xs text-gray-400">Fecha del recordatorio</label>
            <input v-model="quickNoteDate" type="date" class="input-field mt-1" :disabled="noteBusy" />
          </div>
          <div class="flex-1 min-w-[200px]">
            <label class="block text-xs text-gray-400">Texto</label>
            <textarea
              v-model="quickNoteBody"
              rows="2"
              class="input-field mt-1 w-full resize-y min-h-[44px]"
              placeholder="Ej. revisar dividendos en cuentas / broker…"
              :disabled="noteBusy"
            />
          </div>
          <button type="button" class="btn-secondary text-sm shrink-0" :disabled="noteBusy || !quickNoteBody.trim()" @click="submitQuickCalendarNote">
            {{ noteBusy ? '…' : 'Guardar nota' }}
          </button>
        </div>
        <p v-if="noteErr" class="text-xs text-red-400">{{ noteErr }}</p>
      </div>

      <div class="flex items-center gap-4 mt-3 text-sm text-gray-400 flex-wrap">
        <span>{{ totalEventsInRange }} events in range</span>
        <span>·</span>
        <span>{{ uniqueTickersInRange }} unique tickers</span>
        <div class="flex-1 min-w-[8px]"></div>
        <button type="button" class="text-gray-400 hover:text-white transition-colors" @click="shiftMonth(-1)">← Prev month</button>
        <button type="button" class="text-gray-400 hover:text-white transition-colors" @click="shiftMonth(1)">Next month →</button>
      </div>
    </div>

    <div v-if="loadError" class="mb-6 p-4 rounded-xl border border-red-800 bg-red-950/40 text-red-200 text-sm">
      {{ loadError }}
      <button type="button" class="btn-primary text-sm ml-3 align-middle" @click="loadData">Retry</button>
    </div>

    <div v-if="loading" class="text-gray-400 py-12 text-center">Loading dividends...</div>

    <!-- List View -->
    <template v-else-if="viewMode === 'list'">
      <!-- Column header -->
      <div class="grid grid-cols-[1fr_auto_auto_auto_auto] items-center gap-x-4 px-6 py-2 text-xs text-gray-500 font-medium mb-2">
        <span>Stock</span>
        <span class="text-right min-w-[70px]">Price</span>
        <span class="text-right min-w-[55px]">Yield</span>
        <span class="text-right min-w-[80px]">Dividend</span>
        <span class="w-4"></span>
      </div>

      <div class="space-y-4">
        <div v-for="[date, dateItems] in groupedByDate" :key="date" class="card !p-4">
          <h3 class="text-sm font-medium text-primary-400 mb-2">
            {{ date }}
            <span class="text-gray-500 ml-2">({{ dateItems.length }} events)</span>
          </h3>
          <div
            v-for="cn in calendarNotesForDate(date)"
            :key="'n' + cn.id"
            class="mb-3 rounded-lg border border-violet-700/50 bg-violet-950/40 px-3 py-2 text-sm text-violet-100 whitespace-pre-wrap"
          >
            <span class="text-[10px] uppercase text-violet-400/90 mr-2">Nota</span>{{ cn.body }}
          </div>
          <div class="space-y-1.5">
            <button
              v-for="item in dateItems"
              :key="item.ticker + item.amount + item.source + (item.projection_source || '')"
              type="button"
              class="w-full grid grid-cols-[1fr_auto_auto_auto_auto] items-center gap-x-4 p-2.5 bg-gray-800 rounded-lg hover:bg-gray-700/80 transition-colors text-left group relative"
              @click="goToStock(item)"
            >
              <div class="flex items-center gap-3 min-w-0">
                <span class="font-mono font-medium text-white text-sm group-hover:text-primary-400 transition-colors">{{ item.ticker }}</span>
                <span class="text-xs text-gray-400 truncate max-w-[160px] hidden sm:inline">{{ item.company_name }}</span>
                <span v-if="item.exchange_code" class="badge-blue text-[10px]">{{ item.exchange_code }}</span>
                <span v-if="item.is_quanfury" class="badge-purple text-[10px]">QF</span>
                <span v-if="item.source === 'yahoo_forward'" class="badge-amber text-[10px]">{{ item.projection_source === 'yahoo_ex' ? 'Y!' : 'Y~' }}</span>
                <span v-if="item.source === 'manual'" class="badge-manual text-[10px]">M</span>
                <span v-if="item.in_portfolio" class="badge-green text-[10px]">IN PORTFOLIO</span>
              </div>
              <div class="text-right min-w-[70px]">
                <span class="font-mono text-white text-sm">{{ item.last_close ? fmtPrice(item.last_close) : '—' }}</span>
              </div>
              <div class="text-right min-w-[55px]">
                <span class="font-mono text-sm font-medium" :class="yieldColor(item.div_yield_ttm)">
                  {{ item.div_yield_ttm ? fmtPrice(item.div_yield_ttm) + '%' : '—' }}
                </span>
              </div>
              <div class="text-right min-w-[80px]">
                <span
                  class="font-mono text-sm"
                  :class="item.source === 'yahoo_forward' ? 'text-amber-300' : item.source === 'manual' ? 'text-sky-300' : 'text-green-400'"
                >{{ fmt(item.amount) }}</span>
                <span class="text-xs text-gray-500 ml-1">{{ item.currency }}</span>
              </div>
              <svg class="w-4 h-4 text-gray-600 group-hover:text-primary-400 transition-colors flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
              <span v-if="navigating === item.ticker" class="absolute inset-0 flex items-center justify-center bg-gray-800/80 rounded-lg">
                <span class="text-xs text-primary-400">Loading...</span>
              </span>
            </button>
          </div>
        </div>
        <p v-if="groupedByDate.length === 0" class="text-gray-500 text-center py-8">No dividend events in this range.</p>
      </div>
    </template>

    <!-- Calendar: 3 months stacked (full width each) -->
    <template v-else>
      <div class="flex flex-col gap-10 w-full">
        <div v-for="block in calendarMonths" :key="block.label" class="card !p-4 sm:!p-5 min-w-0 w-full">
          <h3 class="text-base sm:text-lg font-semibold text-white mb-3 text-center border-b border-gray-800 pb-3">
            {{ block.label }}
          </h3>
          <div class="grid grid-cols-7 gap-1 sm:gap-1.5">
            <div
              v-for="day in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']"
              :key="block.label + day"
              class="text-center text-xs sm:text-sm text-gray-500 font-medium py-2 truncate"
            >
              {{ day }}
            </div>
            <button
              v-for="cell in block.cells"
              :key="block.label + cell.date"
              type="button"
              :class="[
                'min-h-[104px] sm:min-h-[128px] p-1.5 sm:p-2 border rounded-lg text-left transition-colors',
                'hover:ring-2 hover:ring-primary-500/40 hover:border-primary-600/50 focus:outline-none focus-visible:ring-2 focus-visible:ring-primary-500',
                cell.inMonth ? 'bg-gray-900/90' : 'bg-gray-950/60',
                cell.hasNotes
                  ? 'ring-2 ring-violet-500/75 border-violet-600/70 bg-violet-950/25 shadow-[inset_0_0_0_1px_rgba(139,92,246,0.15)]'
                  : 'border-gray-800/80',
              ]"
              @click="openDayModal(cell)"
            >
              <p
                class="text-xs sm:text-sm font-semibold mb-1 flex items-center justify-between gap-1"
                :class="cell.inMonth ? 'text-gray-300' : 'text-gray-600'"
              >
                <span>{{ cell.day }}</span>
                <span v-if="cell.hasNotes" class="text-[10px] font-normal text-violet-300 shrink-0">📌</span>
              </p>
              <div class="flex flex-col gap-1 min-h-0">
                <span
                  v-for="item in cell.items.slice(0, 4)"
                  :key="item.ticker + item.source + item.date"
                  :class="[
                    'block w-full text-left text-[10px] sm:text-xs leading-snug px-1 py-0.5 sm:py-1 rounded truncate pointer-events-none',
                    item.source === 'quanfury'
                      ? 'bg-purple-900/50 text-purple-200'
                      : item.source === 'yahoo_forward'
                        ? 'bg-amber-900/45 text-amber-100'
                        : item.source === 'manual'
                          ? 'bg-sky-900/45 text-sky-100'
                          : 'bg-green-900/50 text-green-200',
                  ]"
                  :title="item.prior_year_div_date ? `${item.ticker} ${fmtAmount(item.amount)} (was ${item.prior_year_div_date})` : `${item.ticker} ${fmtAmount(item.amount)}`"
                >
                  {{ item.ticker }} {{ fmtAmount(item.amount) }}
                </span>
                <span v-if="cell.items.length > 4" class="text-[10px] sm:text-xs text-gray-500 px-0.5">
                  +{{ cell.items.length - 4 }} more — click day for full list
                </span>
              </div>
            </button>
          </div>
        </div>
      </div>
      <p v-if="filteredItems.length === 0 && !loading" class="text-gray-500 text-center py-6 text-sm">No dividend events in this range.</p>
    </template>

    <Teleport to="body">
      <div
        v-if="dayModalOpen && dayModalDate"
        ref="dayModalBackdropRef"
        tabindex="-1"
        class="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm outline-none"
        role="dialog"
        aria-modal="true"
        :aria-label="`Dividends on ${dayModalDate}`"
        @click.self="closeDayModal"
        @keydown.escape.prevent="closeDayModal"
      >
        <div
          class="w-full max-w-2xl max-h-[90vh] overflow-hidden flex flex-col rounded-2xl border border-gray-700 bg-gray-900 shadow-xl"
          @click.stop
        >
          <div class="flex items-start justify-between gap-3 px-5 py-4 border-b border-gray-800 shrink-0">
            <div>
              <h2 class="text-lg font-semibold text-white">{{ formatModalDate(dayModalDate) }}</h2>
              <p class="text-xs text-gray-500 mt-0.5 font-mono">{{ dayModalDate }}</p>
            </div>
            <button
              type="button"
              class="rounded-lg p-2 text-gray-400 hover:text-white hover:bg-gray-800 transition-colors"
              aria-label="Close"
              @click="closeDayModal"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <div class="overflow-y-auto flex-1 px-4 py-3 space-y-4">
            <div class="rounded-xl border border-violet-600/50 bg-violet-950/35 p-4 space-y-3 shadow-inner">
              <p class="text-xs font-semibold text-violet-200 uppercase tracking-wide">Notas para este día</p>
              <p v-if="!dayModalNotes.length" class="text-xs text-gray-500">Aún no hay notas; el día no se resalta en el calendario hasta que guardes una.</p>
              <div
                v-for="cn in dayModalNotes"
                :key="cn.id"
                class="flex gap-2 items-start rounded-lg bg-violet-900/35 px-3 py-2 border border-violet-800/40"
              >
                <p class="flex-1 text-sm text-violet-50 whitespace-pre-wrap">{{ cn.body }}</p>
                <button
                  type="button"
                  class="shrink-0 text-xs text-violet-400 hover:text-red-400 px-1"
                  :disabled="noteBusy"
                  title="Eliminar nota"
                  @click="removeCalendarNoteRow(cn.id)"
                >
                  ✕
                </button>
              </div>
              <div>
                <label class="block text-xs text-violet-300/80 mb-1">{{ dayModalNotes.length ? 'Añadir otra nota' : 'Texto de la nota' }}</label>
                <textarea
                  v-model="modalNewNoteBody"
                  rows="2"
                  class="input-field w-full resize-y text-sm"
                  placeholder="Ej. revisar dividendos de cuentas…"
                  :disabled="noteBusy"
                />
                <button type="button" class="btn-secondary text-xs mt-2" :disabled="noteBusy || !modalNewNoteBody.trim()" @click="submitModalCalendarNote">
                  Guardar nota
                </button>
              </div>
            </div>

            <template v-if="dayModalItems.length">
              <div class="space-y-2">
                <div
                  v-for="item in dayModalItems"
                  :key="item.ticker + item.source + item.date + (item.projection_source || '') + (item.manual_entry_id || '')"
                  class="relative flex gap-2 items-stretch"
                >
                  <button
                    v-if="item.manual_entry_id != null"
                    type="button"
                    class="shrink-0 self-center px-2 py-2 rounded-lg text-gray-500 hover:text-red-400 hover:bg-gray-800/80 text-sm"
                    title="Eliminar fila manual"
                    :disabled="manualBusy"
                    @click="removeManualEntry(item)"
                  >
                    ✕
                  </button>
                  <button
                    type="button"
                    class="relative flex-1 min-w-0 grid grid-cols-[1fr_auto_auto] sm:grid-cols-[1fr_auto_auto_auto] items-center gap-3 p-3 rounded-xl bg-gray-800/90 hover:bg-gray-700/90 border border-gray-700/80 text-left transition-colors"
                    @click="goToStockFromModal(item)"
                  >
                    <div class="min-w-0">
                      <div class="flex flex-wrap items-center gap-2">
                        <span class="font-mono font-medium text-white">{{ item.ticker }}</span>
                        <span v-if="item.exchange_code" class="badge-blue text-[10px]">{{ item.exchange_code }}</span>
                        <span v-if="item.is_quanfury" class="badge-purple text-[10px]">QF</span>
                        <span v-if="item.source === 'yahoo_forward'" class="badge-amber text-[10px]">
                          {{ item.projection_source === 'yahoo_ex' ? 'Y!' : 'Y~' }}
                        </span>
                        <span v-if="item.source === 'manual'" class="badge-manual text-[10px]">Manual</span>
                        <span v-if="item.in_portfolio" class="badge-green text-[10px]">Portfolio</span>
                      </div>
                      <p class="text-xs text-gray-400 truncate mt-0.5">{{ item.company_name }}</p>
                      <p v-if="item.prior_year_div_date" class="text-[11px] text-amber-200/80 mt-1">
                        Same season last year: {{ item.prior_year_div_date }}
                      </p>
                    </div>
                    <div class="text-right">
                      <span
                        class="font-mono text-sm font-medium"
                        :class="item.source === 'yahoo_forward' ? 'text-amber-300' : item.source === 'manual' ? 'text-sky-300' : 'text-green-400'"
                      >{{ fmtAmount(item.amount) }}</span>
                      <span class="text-xs text-gray-500 block">{{ item.currency || '—' }}</span>
                    </div>
                    <div class="hidden sm:block text-right text-xs text-gray-500">
                      <span v-if="item.div_yield_ttm != null" :class="yieldColor(item.div_yield_ttm)">{{ fmtPrice(item.div_yield_ttm) }}%</span>
                      <span v-else>—</span>
                    </div>
                    <span v-if="navigating === item.ticker" class="absolute inset-0 flex items-center justify-center bg-gray-900/70 rounded-xl text-xs text-primary-400">
                      Loading…
                    </span>
                  </button>
                </div>
              </div>
            </template>
            <p v-else class="text-center text-gray-500 py-6 text-sm">No hay dividendos en esta fecha (puedes añadir uno abajo).</p>

            <div class="rounded-xl border border-gray-800 bg-gray-950/50 p-4 space-y-2">
              <p class="text-xs font-medium text-gray-400 uppercase tracking-wide">Cotejar en la web (no automático)</p>
              <p class="text-[11px] text-gray-500 leading-relaxed">
                No enlazamos TipRanks / Finviz / TradingView por API (bloqueos y términos de uso). Abre estas pestañas, busca el ticker y confirma importe o fecha.
              </p>
              <div class="flex flex-wrap gap-2 pt-1">
                <a
                  :href="tipranksDividendDayUrl(dayModalDate)"
                  class="btn-secondary text-xs !py-1.5 !px-2"
                  target="_blank"
                  rel="noopener noreferrer"
                >TipRanks (día)</a>
                <a
                  :href="finvizDividendDayUrl(dayModalDate)"
                  class="btn-secondary text-xs !py-1.5 !px-2"
                  target="_blank"
                  rel="noopener noreferrer"
                >Finviz</a>
                <a
                  :href="TRADINGVIEW_DIV_CAL"
                  class="btn-secondary text-xs !py-1.5 !px-2"
                  target="_blank"
                  rel="noopener noreferrer"
                >TradingView calendario</a>
              </div>
            </div>

            <div class="rounded-xl border border-sky-900/40 bg-sky-950/20 p-4 space-y-3">
              <p class="text-sm font-medium text-sky-200">Añadir manualmente (guardado en tu BD)</p>
              <p class="text-[11px] text-gray-500">
                Útil si diste de alta Weibo (WB) en NASDAQ pero aún no hay histórico de dividendos en Yahoo/CSV. Mismo formato que en Explorer:
                <span class="font-mono text-gray-400">WB : NASDAQ</span>.
              </p>
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div class="sm:col-span-2">
                  <label class="block text-xs text-gray-500 mb-1">Ticker Yahoo / SYM : BOLSA</label>
                  <input v-model="manualTickerInput" type="text" class="input-field w-full" placeholder="WB o WB : NASDAQ" :disabled="manualBusy" />
                </div>
                <div>
                  <label class="block text-xs text-gray-500 mb-1">Importe por acción</label>
                  <input v-model="manualAmountInput" type="text" inputmode="decimal" class="input-field w-full" placeholder="0.25" :disabled="manualBusy" />
                </div>
                <div>
                  <label class="block text-xs text-gray-500 mb-1">Empresa (opcional)</label>
                  <input v-model="manualCompanyInput" type="text" class="input-field w-full" placeholder="Weibo Corporation" :disabled="manualBusy" />
                </div>
                <div class="sm:col-span-2">
                  <label class="block text-xs text-gray-500 mb-1">Nota (opcional)</label>
                  <input v-model="manualNoteInput" type="text" class="input-field w-full" placeholder="Ex-div según anuncio…" :disabled="manualBusy" />
                </div>
              </div>
              <p v-if="manualErr" class="text-xs text-red-400">{{ manualErr }}</p>
              <button type="button" class="btn-primary text-sm w-full sm:w-auto" :disabled="manualBusy" @click="submitManualDividend">
                {{ manualBusy ? 'Guardando…' : 'Guardar en calendario' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>
