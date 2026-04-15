<script setup lang="ts">
import { ref, computed } from 'vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { LineChart } from 'echarts/charts'
import {
  TitleComponent, TooltipComponent, LegendComponent,
  GridComponent, MarkLineComponent,
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'

use([LineChart, TitleComponent, TooltipComponent, LegendComponent, GridComponent, MarkLineComponent, CanvasRenderer])

const currentAge = 32
const startYear = 2026
const endYear = 2035

interface YearRow {
  year: number
  age: number
  capital: number
  divAnnual: number
  divMonthly: number
}

const initialCapital = 55_000

function buildProjection(
  initial: number,
  cagr: number,
  annualContribution: number,
  divYield: number,
): YearRow[] {
  const rows: YearRow[] = []
  let capital = initial
  for (let y = startYear; y <= endYear; y++) {
    const divAnnual = Math.round(capital * divYield)
    rows.push({
      year: y,
      age: currentAge + (y - startYear),
      capital: Math.round(capital),
      divAnnual,
      divMonthly: Math.round(divAnnual / 12),
    })
    capital = capital * (1 + cagr) + annualContribution
  }
  return rows
}

const scenarios = computed(() => [
  {
    key: 'base',
    name: 'Conservative',
    subtitle: '10% CAGR · $3k/yr contribution · 8% div yield',
    color: '#3b82f6',
    badgeClass: 'badge-blue',
    bgClass: 'border-blue-800/50 bg-blue-950/20',
    iconBg: 'bg-blue-900/50',
    iconColor: 'text-blue-400',
    rows: buildProjection(initialCapital, 0.10, 3_000, 0.08),
  },
  {
    key: 'optimistic',
    name: 'Optimistic',
    subtitle: '13% CAGR · $5k/yr contribution · 9% div yield',
    color: '#22c55e',
    badgeClass: 'badge-green',
    bgClass: 'border-emerald-800/50 bg-emerald-950/20',
    iconBg: 'bg-emerald-900/50',
    iconColor: 'text-emerald-400',
    rows: buildProjection(initialCapital, 0.13, 5_000, 0.09),
  },
  {
    key: 'aggressive',
    name: 'Aggressive',
    subtitle: '20%+ CAGR · aggressive reinvestment · 9% div yield',
    color: '#f59e0b',
    badgeClass: 'badge-yellow',
    bgClass: 'border-amber-800/50 bg-amber-950/20',
    iconBg: 'bg-amber-900/50',
    iconColor: 'text-amber-400',
    rows: buildProjection(initialCapital, 0.25, 15_000, 0.09),
  },
])

const activeTab = ref('base')
const activeScenario = computed(() => scenarios.value.find(s => s.key === activeTab.value)!)

const chartOption = computed(() => ({
  backgroundColor: 'transparent',
  tooltip: {
    trigger: 'axis',
    backgroundColor: '#1f2937',
    borderColor: '#374151',
    textStyle: { color: '#e5e7eb', fontSize: 12 },
    formatter(params: any[]) {
      const year = params[0].axisValue
      const age = currentAge + (year - startYear)
      let html = `<div style="font-weight:600;margin-bottom:4px">${year} · Age ${age}</div>`
      for (const p of params) {
        html += `<div style="display:flex;align-items:center;gap:6px;margin-top:2px">
          <span style="width:8px;height:8px;border-radius:50%;background:${p.color};display:inline-block"></span>
          <span>${p.seriesName}:</span>
          <span style="font-weight:600">$${(p.value as number).toLocaleString()}</span>
        </div>`
      }
      return html
    },
  },
  legend: {
    data: scenarios.value.map(s => s.name),
    textStyle: { color: '#9ca3af' },
    top: 0,
  },
  grid: { top: 40, right: 20, bottom: 30, left: 60 },
  xAxis: {
    type: 'category',
    data: scenarios.value[0].rows.map(r => r.year),
    axisLabel: { color: '#9ca3af' },
    axisLine: { lineStyle: { color: '#374151' } },
  },
  yAxis: {
    type: 'value',
    axisLabel: {
      color: '#9ca3af',
      formatter: (v: number) => v >= 1_000_000 ? `$${(v / 1_000_000).toFixed(1)}M` : `$${(v / 1_000).toFixed(0)}k`,
    },
    splitLine: { lineStyle: { color: '#1f2937' } },
  },
  series: scenarios.value.map(s => ({
    name: s.name,
    type: 'line',
    data: s.rows.map(r => r.capital),
    smooth: true,
    symbol: 'circle',
    symbolSize: 6,
    lineStyle: { width: 3, color: s.color },
    itemStyle: { color: s.color },
    areaStyle: { color: { type: 'linear', x: 0, y: 0, x2: 0, y2: 1, colorStops: [{ offset: 0, color: s.color + '25' }, { offset: 1, color: s.color + '05' }] } },
  })),
}))

const divChartOption = computed(() => ({
  backgroundColor: 'transparent',
  tooltip: {
    trigger: 'axis',
    backgroundColor: '#1f2937',
    borderColor: '#374151',
    textStyle: { color: '#e5e7eb', fontSize: 12 },
    formatter(params: any[]) {
      const year = params[0].axisValue
      const age = currentAge + (year - startYear)
      let html = `<div style="font-weight:600;margin-bottom:4px">${year} · Age ${age}</div>`
      for (const p of params) {
        html += `<div style="display:flex;align-items:center;gap:6px;margin-top:2px">
          <span style="width:8px;height:8px;border-radius:50%;background:${p.color};display:inline-block"></span>
          <span>${p.seriesName}:</span>
          <span style="font-weight:600">$${(p.value as number).toLocaleString()}/mo</span>
        </div>`
      }
      return html
    },
  },
  legend: {
    data: scenarios.value.map(s => s.name),
    textStyle: { color: '#9ca3af' },
    top: 0,
  },
  grid: { top: 40, right: 20, bottom: 30, left: 60 },
  xAxis: {
    type: 'category',
    data: scenarios.value[0].rows.map(r => r.year),
    axisLabel: { color: '#9ca3af' },
    axisLine: { lineStyle: { color: '#374151' } },
  },
  yAxis: {
    type: 'value',
    axisLabel: { color: '#9ca3af', formatter: (v: number) => `$${v.toLocaleString()}` },
    splitLine: { lineStyle: { color: '#1f2937' } },
  },
  series: scenarios.value.map(s => ({
    name: s.name,
    type: 'line',
    data: s.rows.map(r => r.divMonthly),
    smooth: true,
    symbol: 'circle',
    symbolSize: 6,
    lineStyle: { width: 2, color: s.color, type: 'dashed' },
    itemStyle: { color: s.color },
  })),
}))

function fmtMoney(n: number): string {
  if (n >= 1_000_000) return `$${(n / 1_000_000).toFixed(2)}M`
  if (n >= 1_000) return `$${(n / 1_000).toFixed(0)}k`
  return `$${n}`
}
</script>

<template>
  <div>
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-white">Financial Goals</h1>
      <p class="text-gray-400 mt-1">Portfolio growth projection 2026 – 2035 · Age 32 → 41</p>
    </div>

    <!-- Summary cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
      <div v-for="s in scenarios" :key="s.key" class="card cursor-pointer transition-all"
        :class="[s.bgClass, activeTab === s.key ? 'ring-2 ring-offset-2 ring-offset-gray-950' : 'opacity-80 hover:opacity-100']"
        :style="activeTab === s.key ? `--tw-ring-color: ${s.color}` : ''"
        @click="activeTab = s.key"
      >
        <div class="flex items-center gap-3 mb-3">
          <div class="w-10 h-10 rounded-lg flex items-center justify-center" :class="s.iconBg">
            <svg class="w-5 h-5" :class="s.iconColor" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
            </svg>
          </div>
          <div>
            <h3 class="text-sm font-semibold text-white">{{ s.name }}</h3>
            <p class="text-xs text-gray-400">{{ s.subtitle }}</p>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <p class="text-xs text-gray-500">Capital 2035</p>
            <p class="text-xl font-bold text-white">{{ fmtMoney(s.rows[s.rows.length - 1].capital) }}</p>
          </div>
          <div>
            <p class="text-xs text-gray-500">Div/month 2035</p>
            <p class="text-xl font-bold" :style="{ color: s.color }">
              ${{ s.rows[s.rows.length - 1].divMonthly.toLocaleString() }}
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Capital growth chart -->
    <div class="card mb-6">
      <h2 class="text-lg font-semibold text-white mb-1">Capital Growth</h2>
      <p class="text-sm text-gray-400 mb-4">Estimated portfolio value over time</p>
      <v-chart :option="chartOption" autoresize style="height: 340px; width: 100%" />
    </div>

    <!-- Monthly dividends chart -->
    <div class="card mb-6">
      <h2 class="text-lg font-semibold text-white mb-1">Monthly Dividend Income</h2>
      <p class="text-sm text-gray-400 mb-4">Estimated passive income per month</p>
      <v-chart :option="divChartOption" autoresize style="height: 280px; width: 100%" />
    </div>

    <!-- Detailed table for active scenario -->
    <div class="card">
      <div class="flex items-center gap-3 mb-4">
        <div class="flex gap-1">
          <button
            v-for="s in scenarios" :key="s.key"
            @click="activeTab = s.key"
            class="px-3 py-1.5 rounded-lg text-sm font-medium transition-colors"
            :class="activeTab === s.key
              ? 'text-white'
              : 'bg-gray-800 text-gray-400 hover:text-gray-200'"
            :style="activeTab === s.key ? `background: ${s.color}22; color: ${s.color}` : ''"
          >
            {{ s.name }}
          </button>
        </div>
      </div>

      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead>
            <tr class="border-b border-gray-800">
              <th class="text-left py-3 px-4 text-gray-400 font-medium">Year</th>
              <th class="text-left py-3 px-4 text-gray-400 font-medium">Age</th>
              <th class="text-right py-3 px-4 text-gray-400 font-medium">Capital</th>
              <th class="text-right py-3 px-4 text-gray-400 font-medium">Div / year</th>
              <th class="text-right py-3 px-4 text-gray-400 font-medium">Div / month</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="row in activeScenario.rows" :key="row.year"
              class="border-b border-gray-800/50 hover:bg-gray-800/30 transition-colors"
            >
              <td class="py-2.5 px-4 text-white font-medium">{{ row.year }}</td>
              <td class="py-2.5 px-4 text-gray-300">{{ row.age }}</td>
              <td class="py-2.5 px-4 text-right text-white font-semibold">{{ fmtMoney(row.capital) }}</td>
              <td class="py-2.5 px-4 text-right" :style="{ color: activeScenario.color }">
                ${{ row.divAnnual.toLocaleString() }}
              </td>
              <td class="py-2.5 px-4 text-right" :style="{ color: activeScenario.color }">
                ${{ row.divMonthly.toLocaleString() }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="mt-4 p-4 bg-gray-800/50 rounded-lg">
        <p class="text-xs text-gray-500 leading-relaxed">
          These projections are estimates based on compound growth assumptions and do not account for taxes,
          inflation, market downturns, or changes in dividend policies. Past performance does not guarantee
          future results. Use as a directional guide for setting financial milestones.
        </p>
      </div>
    </div>
  </div>
</template>
