<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { RouterView, RouterLink, useRoute } from 'vue-router'
import { healthCheck } from './services/api'

const route = useRoute()
const mobileMenuOpen = ref(false)
const apiStatus = ref<string>('checking...')

const navItems = [
  { path: '/', label: 'Dashboard', icon: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6' },
  { path: '/stocks', label: 'Stocks', icon: 'M13 7h8m0 0v8m0-8l-8 8-4-4-6 6' },
  { path: '/dividends', label: 'Dividends', icon: 'M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z' },
  { path: '/portfolios', label: 'Portfolios', icon: 'M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10' },
  { path: '/analytics', label: 'Analytics', icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z' },
]

onMounted(async () => {
  try {
    const h = await healthCheck()
    apiStatus.value = `${h.stocks_count} stocks`
  } catch {
    apiStatus.value = 'offline'
  }
})

function isActive(path: string) {
  if (path === '/') return route.path === '/'
  return route.path.startsWith(path)
}
</script>

<template>
  <div class="min-h-screen bg-gray-950">
    <!-- Sidebar -->
    <aside class="fixed inset-y-0 left-0 z-50 w-64 bg-gray-900 border-r border-gray-800 hidden lg:block">
      <div class="flex items-center gap-3 px-6 py-5 border-b border-gray-800">
        <div class="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center">
          <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
          </svg>
        </div>
        <div>
          <h1 class="text-lg font-bold text-white">StockUnifier</h1>
          <p class="text-xs text-gray-500">{{ apiStatus }}</p>
        </div>
      </div>

      <nav class="px-3 py-4 space-y-1">
        <RouterLink
          v-for="item in navItems"
          :key="item.path"
          :to="item.path"
          :class="[
            'flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors',
            isActive(item.path)
              ? 'bg-primary-600/20 text-primary-400'
              : 'text-gray-400 hover:text-gray-200 hover:bg-gray-800',
          ]"
        >
          <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" :d="item.icon" />
          </svg>
          {{ item.label }}
        </RouterLink>
      </nav>
    </aside>

    <!-- Mobile header -->
    <header class="lg:hidden sticky top-0 z-40 bg-gray-900/80 backdrop-blur border-b border-gray-800">
      <div class="flex items-center justify-between px-4 py-3">
        <h1 class="text-lg font-bold text-white">StockUnifier</h1>
        <button @click="mobileMenuOpen = !mobileMenuOpen" class="text-gray-400 hover:text-white">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
        </button>
      </div>
      <nav v-if="mobileMenuOpen" class="px-4 pb-3 flex gap-2 flex-wrap">
        <RouterLink
          v-for="item in navItems"
          :key="item.path"
          :to="item.path"
          @click="mobileMenuOpen = false"
          :class="[
            'px-3 py-1.5 rounded-lg text-sm font-medium',
            isActive(item.path) ? 'bg-primary-600 text-white' : 'bg-gray-800 text-gray-300',
          ]"
        >
          {{ item.label }}
        </RouterLink>
      </nav>
    </header>

    <!-- Main content -->
    <main class="lg:ml-64">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <RouterView />
      </div>
    </main>
  </div>
</template>
