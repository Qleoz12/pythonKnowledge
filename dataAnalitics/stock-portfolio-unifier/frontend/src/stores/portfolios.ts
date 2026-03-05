import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { Portfolio, PortfolioDetail } from '../types'
import {
  fetchPortfolios, fetchPortfolio, createPortfolio,
  updatePortfolio, deletePortfolio, addHolding, removeHolding, createSnapshot,
} from '../services/api'

export const usePortfoliosStore = defineStore('portfolios', () => {
  const portfolios = ref<Portfolio[]>([])
  const currentPortfolio = ref<PortfolioDetail | null>(null)
  const loading = ref(false)

  async function loadPortfolios() {
    loading.value = true
    try {
      portfolios.value = await fetchPortfolios()
    } finally {
      loading.value = false
    }
  }

  async function loadPortfolio(id: number) {
    loading.value = true
    try {
      currentPortfolio.value = await fetchPortfolio(id)
    } finally {
      loading.value = false
    }
  }

  async function create(name: string, broker: string = '', description: string = '') {
    const p = await createPortfolio({ name, broker, description })
    portfolios.value.unshift(p)
    return p
  }

  async function update(id: number, payload: Record<string, any>) {
    await updatePortfolio(id, payload)
    await loadPortfolios()
  }

  async function remove(id: number) {
    await deletePortfolio(id)
    portfolios.value = portfolios.value.filter(p => p.id !== id)
  }

  async function addStock(portfolioId: number, stockId: number, shares: number, avgPrice: number) {
    await addHolding(portfolioId, { stock_id: stockId, shares, avg_price: avgPrice })
    await loadPortfolio(portfolioId)
  }

  async function removeStock(portfolioId: number, holdingId: number) {
    await removeHolding(portfolioId, holdingId)
    await loadPortfolio(portfolioId)
  }

  async function saveSnapshot(portfolioId: number, month: number, year: number, value: number, divs: number, notes: string = '') {
    await createSnapshot(portfolioId, { month, year, total_value: value, total_dividends: divs, notes })
    await loadPortfolio(portfolioId)
  }

  return {
    portfolios, currentPortfolio, loading,
    loadPortfolios, loadPortfolio, create, update, remove,
    addStock, removeStock, saveSnapshot,
  }
})
