<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { fetchP2PBook } from '../services/api'
import type { P2PBook, P2PAdvertiser } from '../types'

// ─── Filters ─────────────────────────────────────────────────────────────────
const asset = ref('USDT')
const fiat = ref('COP')
const tradeType = ref<'SELL' | 'BUY'>('SELL')
const merchantOnly = ref(false)
const rows = ref(20)
const filterPayMethod = ref('')
const filterMinRate = ref(0)
const filterMaxPrice = ref<number | null>(null)
const filterMinAvail = ref(0)
const filterExchange = ref('')

// ─── State ────────────────────────────────────────────────────────────────────
const book = ref<P2PBook | null>(null)
const loading = ref(false)
const error = ref<string | null>(null)

// ─── Computed ─────────────────────────────────────────────────────────────────
const filtered = computed<P2PAdvertiser[]>(() => {
  if (!book.value) return []
  return book.value.advertisers.filter(a => {
    if (!a.is_tradable) return false
    if (filterExchange.value && a.exchange_id !== filterExchange.value) return false
    if (filterPayMethod.value && !a.pay_methods.some(m => m.toLowerCase().includes(filterPayMethod.value.toLowerCase()))) return false
    if (filterMinRate.value > 0 && a.month_finish_rate < filterMinRate.value) return false
    if (filterMaxPrice.value != null && a.price > filterMaxPrice.value) return false
    if (filterMinAvail.value > 0 && a.available_usdt < filterMinAvail.value) return false
    return true
  })
})

const allPayMethods = computed(() => {
  if (!book.value) return []
  const set = new Set<string>()
  for (const a of book.value.advertisers) for (const m of a.pay_methods) set.add(m)
  return Array.from(set).sort()
})

const countByExchange = computed(() => {
  if (!book.value) return {}
  const m: Record<string, number> = {}
  for (const a of book.value.advertisers) m[a.exchange_id] = (m[a.exchange_id] || 0) + 1
  return m
})

const bestPrice = computed(() => {
  if (!filtered.value.length) return null
  return tradeType.value === 'SELL'
    ? Math.min(...filtered.value.map(a => a.price))
    : Math.max(...filtered.value.map(a => a.price))
})

const hasErrors = computed(() => book.value && Object.keys(book.value.errors || {}).length > 0)

// ─── Helpers ──────────────────────────────────────────────────────────────────
function fmt(val: number, decimals = 0): string {
  return val.toLocaleString('es-CO', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}

function rateColor(rate: number): string {
  if (rate >= 98) return 'text-emerald-400'
  if (rate >= 95) return 'text-yellow-400'
  return 'text-red-400'
}

function activeColor(secs: number | null): string {
  if (secs == null) return 'text-gray-500'
  if (secs < 300) return 'text-emerald-400'
  if (secs < 1800) return 'text-yellow-400'
  if (secs < 86400) return 'text-orange-400'
  return 'text-red-400'
}

function isBest(price: number): boolean {
  return bestPrice.value != null && price === bestPrice.value
}

function payMethodColor(method: string): string {
  const m = method.toLowerCase()
  if (m.includes('nequi')) return 'bg-pink-900/60 text-pink-300'
  if (m.includes('bancolombia')) return 'bg-yellow-900/60 text-yellow-300'
  if (m.includes('daviplata')) return 'bg-red-900/60 text-red-300'
  if (m.includes('bbva')) return 'bg-blue-900/60 text-blue-300'
  if (m.includes('bank') || m.includes('banco')) return 'bg-blue-900/40 text-blue-400'
  if (m.includes('paypal')) return 'bg-sky-900/60 text-sky-300'
  if (m.includes('payoneer')) return 'bg-orange-900/60 text-orange-300'
  if (m.includes('wise')) return 'bg-teal-900/60 text-teal-300'
  return 'bg-gray-800 text-gray-400'
}

function gradeLabel(grade: number): string {
  if (grade >= 3) return 'Pro'
  if (grade >= 2) return 'Verified'
  return 'Basic'
}

function gradeColor(grade: number): string {
  if (grade >= 3) return 'text-yellow-400'
  if (grade >= 2) return 'text-emerald-400'
  return 'text-gray-400'
}

function exchangeBadgeStyle(id: string): string {
  if (id === 'binance') return 'bg-yellow-900/70 text-yellow-300 border border-yellow-700/50'
  if (id === 'okx') return 'bg-blue-900/70 text-blue-300 border border-blue-700/50'
  if (id === 'kucoin') return 'bg-teal-900/70 text-teal-300 border border-teal-700/50'
  return 'bg-gray-800 text-gray-400'
}

function exchangeTabStyle(id: string, active: boolean): string {
  const base = 'px-4 py-2 rounded-lg text-sm font-semibold transition-all flex items-center gap-2'
  if (!active) return base + ' bg-gray-800/60 text-gray-400 hover:bg-gray-700 hover:text-gray-200'
  if (id === 'binance') return base + ' bg-yellow-800/60 text-yellow-200 ring-1 ring-yellow-600/50'
  if (id === 'okx') return base + ' bg-blue-800/60 text-blue-200 ring-1 ring-blue-600/50'
  if (id === 'kucoin') return base + ' bg-teal-800/60 text-teal-200 ring-1 ring-teal-600/50'
  return base + ' bg-primary-700/40 text-primary-200 ring-1 ring-primary-600/50'
}

// ─── Load ─────────────────────────────────────────────────────────────────────
async function load() {
  loading.value = true
  error.value = null
  try {
    book.value = await fetchP2PBook({
      asset: asset.value,
      fiat: fiat.value,
      trade_type: tradeType.value,
      rows: rows.value,
      merchant_only: merchantOnly.value,
    })
  } catch (e: any) {
    error.value = e?.response?.data?.detail || e?.message || 'Error fetching P2P book'
  } finally {
    loading.value = false
  }
}

onMounted(load)
</script>

<template>
  <div class="space-y-5">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-white flex items-center gap-2">
          <span class="text-xl">🏪</span>
          P2P Order Book
        </h1>
        <p class="text-sm text-gray-400 mt-1">
          Anunciantes activos en Binance P2P — precios, liquidez y métodos de pago reales
        </p>
      </div>
      <button
        @click="load"
        :disabled="loading"
        class="px-4 py-2 bg-primary-600 hover:bg-primary-500 disabled:opacity-50 text-white rounded-lg text-sm font-medium transition-colors flex items-center gap-2"
      >
        <svg v-if="loading" class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"/>
        </svg>
        <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
        </svg>
        Actualizar
      </button>
    </div>

    <!-- Query controls -->
    <div class="bg-gray-900 rounded-xl border border-gray-800 p-4">
      <h2 class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">Configurar consulta</h2>
      <div class="flex flex-wrap gap-3 items-end">
        <!-- Asset -->
        <div>
          <label class="text-xs text-gray-500 block mb-1">Cripto</label>
          <select v-model="asset" class="bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-3 py-1.5 focus:outline-none focus:border-primary-500">
            <option>USDT</option>
            <option>BTC</option>
            <option>ETH</option>
            <option>BNB</option>
            <option>USDC</option>
          </select>
        </div>
        <!-- Fiat -->
        <div>
          <label class="text-xs text-gray-500 block mb-1">Moneda fiat</label>
          <select v-model="fiat" class="bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-3 py-1.5 focus:outline-none focus:border-primary-500">
            <option>COP</option>
            <option>CAD</option>
            <option>USD</option>
            <option>ARS</option>
            <option>MXN</option>
            <option>BRL</option>
            <option>PEN</option>
            <option>CLP</option>
          </select>
        </div>
        <!-- Trade type -->
        <div>
          <label class="text-xs text-gray-500 block mb-1">Tipo operación</label>
          <div class="flex rounded-lg overflow-hidden border border-gray-700">
            <button
              @click="tradeType = 'SELL'"
              :class="['px-3 py-1.5 text-sm font-medium transition-colors', tradeType === 'SELL' ? 'bg-emerald-700 text-white' : 'bg-gray-800 text-gray-400 hover:bg-gray-700']"
            >
              SELL (quiero comprar)
            </button>
            <button
              @click="tradeType = 'BUY'"
              :class="['px-3 py-1.5 text-sm font-medium transition-colors', tradeType === 'BUY' ? 'bg-orange-700 text-white' : 'bg-gray-800 text-gray-400 hover:bg-gray-700']"
            >
              BUY (quiero vender)
            </button>
          </div>
        </div>
        <!-- Rows -->
        <div>
          <label class="text-xs text-gray-500 block mb-1">Resultados</label>
          <select v-model.number="rows" class="bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-3 py-1.5 focus:outline-none focus:border-primary-500">
            <option :value="10">10</option>
            <option :value="20">20</option>
          </select>
        </div>
        <!-- Merchant only -->
        <div class="flex items-center gap-2 pb-1.5">
          <input id="merchant" type="checkbox" v-model="merchantOnly" class="w-4 h-4 rounded accent-primary-500"/>
          <label for="merchant" class="text-sm text-gray-300 cursor-pointer">Solo merchants</label>
        </div>
        <button
          @click="load"
          class="px-4 py-1.5 bg-primary-600 hover:bg-primary-500 text-white text-sm rounded-lg font-medium transition-colors"
        >
          Buscar
        </button>
      </div>
    </div>

    <!-- Error -->
    <div v-if="error" class="bg-red-900/30 border border-red-700 rounded-xl p-4 text-red-300 text-sm">
      {{ error }}
    </div>

    <!-- Partial errors (some exchanges failed) -->
    <div v-if="hasErrors" class="bg-orange-900/20 border border-orange-700/50 rounded-xl p-3 flex flex-wrap gap-2 items-center">
      <span class="text-orange-400 text-xs font-medium">Algunos exchanges fallaron:</span>
      <span v-for="(msg, src) in book?.errors" :key="src"
        class="px-2 py-0.5 bg-orange-900/40 text-orange-300 text-xs rounded-full font-mono">
        {{ src }}: {{ msg.slice(0, 60) }}
      </span>
    </div>

    <!-- Exchange tabs -->
    <div v-if="book" class="flex flex-wrap gap-2">
      <button :class="exchangeTabStyle('all', filterExchange === '')" @click="filterExchange = ''">
        Todos
        <span class="px-1.5 py-0.5 bg-gray-700 text-gray-300 rounded-full text-xs">{{ book.count }}</span>
      </button>
      <button :class="exchangeTabStyle('binance', filterExchange === 'binance')" @click="filterExchange = filterExchange === 'binance' ? '' : 'binance'">
        <span class="font-bold">Binance P2P</span>
        <span class="px-1.5 py-0.5 bg-yellow-900/60 text-yellow-300 rounded-full text-xs">{{ countByExchange['binance'] || 0 }}</span>
      </button>
      <button :class="exchangeTabStyle('okx', filterExchange === 'okx')" @click="filterExchange = filterExchange === 'okx' ? '' : 'okx'">
        <span class="font-bold">OKX P2P</span>
        <span class="px-1.5 py-0.5 bg-blue-900/60 text-blue-300 rounded-full text-xs">{{ countByExchange['okx'] || 0 }}</span>
      </button>
      <button :class="exchangeTabStyle('kucoin', filterExchange === 'kucoin')" @click="filterExchange = filterExchange === 'kucoin' ? '' : 'kucoin'">
        <span class="font-bold">KuCoin P2P</span>
        <span class="px-1.5 py-0.5 bg-teal-900/60 text-teal-300 rounded-full text-xs">{{ countByExchange['kucoin'] || 0 }}</span>
      </button>
    </div>

    <!-- Summary bar -->
    <div v-if="book" class="grid grid-cols-2 sm:grid-cols-4 gap-3">
      <div class="bg-gray-900 rounded-xl p-4 border border-gray-800">
        <p class="text-xs text-gray-500">Anunciantes encontrados</p>
        <p class="text-2xl font-bold text-white">{{ filtered.length }}</p>
        <p class="text-xs text-gray-600 mt-0.5">de {{ book.count }} totales</p>
      </div>
      <div class="bg-gray-900 rounded-xl p-4 border border-gray-800">
        <p class="text-xs text-gray-500">{{ tradeType === 'SELL' ? 'Mejor precio (más bajo)' : 'Mejor precio (más alto)' }}</p>
        <p class="text-2xl font-bold text-emerald-400 font-mono">{{ bestPrice != null ? fmt(bestPrice) : '—' }}</p>
        <p class="text-xs text-gray-600 mt-0.5">{{ asset }}/{{ fiat }}</p>
      </div>
      <div class="bg-gray-900 rounded-xl p-4 border border-gray-800">
        <p class="text-xs text-gray-500">Métodos de pago disponibles</p>
        <p class="text-2xl font-bold text-white">{{ allPayMethods.length }}</p>
        <p class="text-xs text-gray-600 mt-0.5 truncate">{{ allPayMethods.slice(0, 3).join(', ') }}</p>
      </div>
      <div class="bg-gray-900 rounded-xl p-4 border border-gray-800">
        <p class="text-xs text-gray-500">Actualizado</p>
        <p class="text-sm font-medium text-white">{{ book.fetched_at.slice(11, 19) }} UTC</p>
        <p class="text-xs text-gray-600 mt-0.5">Binance P2P</p>
      </div>
    </div>

    <!-- Filters row -->
    <div v-if="book" class="bg-gray-900 rounded-xl border border-gray-800 p-4">
      <h2 class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">Filtrar resultados</h2>
      <div class="flex flex-wrap gap-3 items-end">
        <div>
          <label class="text-xs text-gray-500 block mb-1">Método de pago</label>
          <select v-model="filterPayMethod" class="bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-3 py-1.5 focus:outline-none focus:border-primary-500">
            <option value="">Todos</option>
            <option v-for="m in allPayMethods" :key="m" :value="m">{{ m }}</option>
          </select>
        </div>
        <div>
          <label class="text-xs text-gray-500 block mb-1">Tasa completitud mín %</label>
          <input v-model.number="filterMinRate" type="number" min="0" max="100" step="1" placeholder="ej: 95"
            class="w-32 bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-3 py-1.5 focus:outline-none focus:border-primary-500"/>
        </div>
        <div v-if="tradeType === 'SELL'">
          <label class="text-xs text-gray-500 block mb-1">Precio máx ({{ fiat }})</label>
          <input v-model.number="filterMaxPrice" type="number" min="0" step="10" :placeholder="`ej: ${bestPrice ? Math.ceil(bestPrice * 1.01) : ''}`"
            class="w-36 bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-3 py-1.5 focus:outline-none focus:border-primary-500"/>
        </div>
        <div>
          <label class="text-xs text-gray-500 block mb-1">Disponible mín ({{ asset }})</label>
          <input v-model.number="filterMinAvail" type="number" min="0" step="50" placeholder="ej: 100"
            class="w-32 bg-gray-800 border border-gray-700 text-gray-200 text-sm rounded-lg px-3 py-1.5 focus:outline-none focus:border-primary-500"/>
        </div>
        <button @click="filterPayMethod=''; filterMinRate=0; filterMaxPrice=null; filterMinAvail=0"
          class="px-3 py-1.5 bg-gray-700 hover:bg-gray-600 text-gray-300 text-sm rounded-lg font-medium transition-colors">
          Limpiar
        </button>
      </div>
    </div>

    <!-- Advertiser cards (loading skeleton) -->
    <div v-if="loading" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
      <div v-for="i in 6" :key="i" class="bg-gray-900 rounded-xl border border-gray-800 p-5 animate-pulse">
        <div class="h-4 bg-gray-800 rounded w-1/2 mb-3"/>
        <div class="h-8 bg-gray-800 rounded w-1/3 mb-3"/>
        <div class="h-3 bg-gray-800 rounded w-3/4 mb-2"/>
        <div class="h-3 bg-gray-800 rounded w-2/3"/>
      </div>
    </div>

    <!-- Advertiser cards -->
    <div v-else-if="filtered.length" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
      <div
        v-for="(ad, idx) in filtered"
        :key="ad.adv_no"
        :class="[
          'bg-gray-900 rounded-xl border p-5 flex flex-col gap-3 transition-all hover:border-gray-600',
          isBest(ad.price) ? 'border-emerald-600 ring-1 ring-emerald-600/30' : 'border-gray-800'
        ]"
      >
        <!-- Header row -->
        <div class="flex items-start justify-between gap-2">
          <div class="flex items-center gap-2 min-w-0">
            <div class="w-8 h-8 rounded-full bg-gray-800 flex items-center justify-center text-sm font-bold text-gray-300 flex-shrink-0">
              {{ idx + 1 }}
            </div>
            <div class="min-w-0">
              <div class="flex items-center gap-1.5 flex-wrap">
                <a :href="ad.link" target="_blank" rel="noopener"
                  class="text-sm font-semibold text-white hover:text-primary-400 transition-colors truncate max-w-[140px]">
                  {{ ad.seller_name }}
                </a>
                <span :class="['px-2 py-0.5 rounded-full text-xs font-bold', exchangeBadgeStyle(ad.exchange_id)]">
                  {{ ad.exchange }}
                </span>
                <span v-if="ad.is_merchant" class="px-1.5 py-0.5 bg-yellow-900/60 text-yellow-300 text-xs rounded-full font-medium flex-shrink-0">
                  Merchant
                </span>
              </div>
              <div class="flex items-center gap-1.5 mt-0.5">
                <span :class="['text-xs font-medium', activeColor(ad.active_secs)]">
                  ● {{ ad.active_label }}
                </span>
              </div>
            </div>
          </div>
          <!-- Best price badge -->
          <div v-if="isBest(ad.price)" class="px-2 py-1 bg-emerald-600/30 text-emerald-400 text-xs font-bold rounded-full flex-shrink-0">
            MEJOR
          </div>
        </div>

        <!-- Price -->
        <div class="flex items-end justify-between">
          <div>
            <p class="text-xs text-gray-500 mb-0.5">Precio</p>
            <p :class="['text-2xl font-bold font-mono', isBest(ad.price) ? 'text-emerald-400' : 'text-white']">
              {{ fmt(ad.price) }}
            </p>
            <p class="text-xs text-gray-500">{{ fiat }} por {{ asset }}</p>
          </div>
          <div class="text-right">
            <p class="text-xs text-gray-500 mb-0.5">Disponible</p>
            <p class="text-lg font-bold text-white font-mono">{{ fmt(ad.available_usdt) }}</p>
            <p class="text-xs text-gray-500">{{ asset }}</p>
          </div>
        </div>

        <!-- Limits -->
        <div class="bg-gray-800/60 rounded-lg p-3 grid grid-cols-2 gap-2 text-xs">
          <div>
            <p class="text-gray-500">Mínimo</p>
            <p class="text-white font-mono font-medium">{{ fmt(ad.min_fiat) }} {{ fiat }}</p>
            <p class="text-gray-500 mt-0.5">≈ {{ fmt(ad.min_usdt) }} {{ asset }}</p>
          </div>
          <div>
            <p class="text-gray-500">Máximo</p>
            <p class="text-white font-mono font-medium">{{ fmt(ad.max_fiat) }} {{ fiat }}</p>
            <p class="text-gray-500 mt-0.5">≈ {{ fmt(ad.max_usdt) }} {{ asset }}</p>
          </div>
        </div>

        <!-- Pay methods -->
        <div>
          <p class="text-xs text-gray-500 mb-1.5">Métodos de pago</p>
          <div class="flex flex-wrap gap-1.5">
            <span
              v-for="m in ad.pay_methods"
              :key="m"
              :class="['px-2 py-1 rounded-lg text-xs font-medium', payMethodColor(m)]"
            >
              {{ m }}
            </span>
            <span v-if="!ad.pay_methods.length" class="text-gray-600 text-xs">No especificado</span>
          </div>
        </div>

        <!-- Stats row -->
        <div class="flex items-center justify-between border-t border-gray-800 pt-3 text-xs">
          <div class="flex items-center gap-3">
            <div>
              <p class="text-gray-500">Órdenes/mes</p>
              <p class="text-white font-medium">{{ ad.month_orders }}</p>
            </div>
            <div>
              <p class="text-gray-500">Completitud</p>
              <p :class="['font-bold', rateColor(ad.month_finish_rate)]">{{ ad.month_finish_rate }}%</p>
            </div>
            <div>
              <p class="text-gray-500">Positivo</p>
              <p :class="['font-bold', rateColor(ad.positive_rate)]">{{ ad.positive_rate }}%</p>
            </div>
          </div>
          <div class="text-right">
            <p class="text-gray-500">Tiempo pago</p>
            <p class="text-white font-medium">{{ ad.pay_time_limit_min }} min</p>
          </div>
        </div>

        <!-- Remarks -->
        <p v-if="ad.remarks" class="text-xs text-gray-500 italic leading-relaxed line-clamp-2 border-t border-gray-800 pt-2">
          "{{ ad.remarks }}"
        </p>

        <!-- Action -->
        <a
          :href="ad.link"
          target="_blank"
          rel="noopener"
          :class="[
            'block text-center py-2 rounded-lg text-sm font-semibold transition-colors',
            tradeType === 'SELL'
              ? 'bg-emerald-700/40 hover:bg-emerald-700/70 text-emerald-300'
              : 'bg-orange-700/40 hover:bg-orange-700/70 text-orange-300'
          ]"
        >
          {{ tradeType === 'SELL' ? `Comprar en ${ad.exchange} →` : `Vender en ${ad.exchange} →` }}
        </a>
      </div>
    </div>

    <!-- Empty state -->
    <div v-else-if="!loading && book" class="bg-gray-900 rounded-xl border border-gray-800 p-12 text-center">
      <p class="text-4xl mb-3">🔍</p>
      <p class="text-gray-400 font-medium">No se encontraron anunciantes con los filtros actuales</p>
      <p class="text-gray-600 text-sm mt-1">Prueba con menos filtros o cambia el método de pago</p>
    </div>

    <div v-else-if="!loading && !book" class="bg-gray-900 rounded-xl border border-gray-800 p-12 text-center">
      <p class="text-4xl mb-3">📋</p>
      <p class="text-gray-400 font-medium">Configura los parámetros y haz clic en Buscar</p>
    </div>
  </div>
</template>
