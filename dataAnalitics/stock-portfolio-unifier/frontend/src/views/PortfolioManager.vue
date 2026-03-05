<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { usePortfoliosStore } from '../stores/portfolios'

const store = usePortfoliosStore()
const router = useRouter()

const showCreate = ref(false)
const newName = ref('')
const newBroker = ref('')
const newDescription = ref('')

onMounted(() => store.loadPortfolios())

async function createPortfolio() {
  if (!newName.value.trim()) return
  const p = await store.create(newName.value.trim(), newBroker.value, newDescription.value)
  showCreate.value = false
  newName.value = ''
  newBroker.value = ''
  newDescription.value = ''
  router.push(`/portfolios/${p.id}`)
}

async function deletePortfolio(id: number, name: string) {
  if (confirm(`Delete portfolio "${name}"?`)) {
    await store.remove(id)
  }
}

function fmt(n: number | null | undefined, decimals = 2): string {
  if (n === null || n === undefined) return '—'
  return n.toLocaleString('en-US', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })
}
</script>

<template>
  <div>
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-3xl font-bold text-white">Portfolios</h1>
      <button @click="showCreate = !showCreate" class="btn-primary">
        {{ showCreate ? 'Cancel' : '+ New Portfolio' }}
      </button>
    </div>

    <!-- Create form -->
    <div v-if="showCreate" class="card mb-6">
      <h2 class="text-lg font-semibold text-white mb-4">Create Portfolio</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
        <div>
          <label class="text-xs text-gray-400">Name *</label>
          <input v-model="newName" type="text" placeholder="My Dividend Portfolio" class="input-field mt-1" />
        </div>
        <div>
          <label class="text-xs text-gray-400">Broker</label>
          <select v-model="newBroker" class="input-field mt-1">
            <option value="">Select broker</option>
            <option value="Quanfury">Quanfury</option>
            <option value="XTB">XTB</option>
            <option value="Interactive Brokers">Interactive Brokers</option>
            <option value="TD Ameritrade">TD Ameritrade</option>
            <option value="Other">Other</option>
          </select>
        </div>
        <div>
          <label class="text-xs text-gray-400">Description</label>
          <input v-model="newDescription" type="text" placeholder="Optional description" class="input-field mt-1" />
        </div>
      </div>
      <button @click="createPortfolio" :disabled="!newName.trim()" class="btn-primary">Create</button>
    </div>

    <!-- Portfolio list -->
    <div v-if="store.loading" class="text-gray-400 py-12 text-center">Loading...</div>

    <div v-else-if="store.portfolios.length === 0" class="card text-center py-12">
      <p class="text-gray-400 mb-4">No portfolios yet. Create one to start tracking your investments.</p>
    </div>

    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <div v-for="p in store.portfolios" :key="p.id"
        class="card hover:border-gray-700 transition-colors cursor-pointer group relative"
        @click="router.push(`/portfolios/${p.id}`)">

        <div class="flex items-start justify-between mb-4">
          <div>
            <h3 class="text-lg font-semibold text-white group-hover:text-primary-400 transition-colors">{{ p.name }}</h3>
            <div class="flex items-center gap-2 mt-1">
              <span v-if="p.broker" class="badge-blue">{{ p.broker }}</span>
              <span class="text-xs text-gray-500">{{ p.holdings_count }} holdings</span>
            </div>
          </div>
          <button @click.stop="deletePortfolio(p.id, p.name)"
            class="opacity-0 group-hover:opacity-100 text-gray-500 hover:text-red-400 transition-all p-1">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div>
            <p class="text-xs text-gray-400">Total Value</p>
            <p class="text-lg font-bold text-white">{{ p.total_value ? '$' + fmt(p.total_value) : '—' }}</p>
          </div>
          <div>
            <p class="text-xs text-gray-400">Gain/Loss</p>
            <p class="text-lg font-bold" :class="(p.total_gain_pct ?? 0) >= 0 ? 'text-green-400' : 'text-red-400'">
              {{ p.total_gain_pct !== null ? fmt(p.total_gain_pct, 1) + '%' : '—' }}
            </p>
          </div>
          <div>
            <p class="text-xs text-gray-400">Est. Annual Dividends</p>
            <p class="text-sm font-medium text-green-300">{{ p.estimated_annual_dividends ? '$' + fmt(p.estimated_annual_dividends) : '—' }}</p>
          </div>
          <div>
            <p class="text-xs text-gray-400">Avg Yield</p>
            <p class="text-sm font-medium text-green-300">{{ p.avg_yield ? fmt(p.avg_yield) + '%' : '—' }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
