<script setup lang="ts">
import { ref, computed } from 'vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { BarChart } from 'echarts/charts'
import {
  TitleComponent, TooltipComponent, GridComponent,
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'

use([BarChart, TitleComponent, TooltipComponent, GridComponent, CanvasRenderer])

const weights = [
  { name: 'Net Income Margin', weight: 25, color: '#3b82f6' },
  { name: 'Return on Assets', weight: 20, color: '#8b5cf6' },
  { name: 'Free Cash Flow Yield', weight: 25, color: '#10b981' },
  { name: 'Debt / Equity', weight: 15, color: '#f59e0b' },
  { name: 'EMA Position', weight: 15, color: '#ef4444' },
]

const chartOption = computed(() => ({
  tooltip: { trigger: 'axis' as const, axisPointer: { type: 'shadow' as const } },
  grid: { left: 140, right: 30, top: 20, bottom: 30 },
  xAxis: {
    type: 'value' as const,
    max: 30,
    axisLabel: { color: '#9ca3af', formatter: '{value}%' },
    splitLine: { lineStyle: { color: '#374151' } },
  },
  yAxis: {
    type: 'category' as const,
    data: weights.map(w => w.name).reverse(),
    axisLabel: { color: '#d1d5db', fontSize: 11 },
    axisLine: { show: false },
    axisTick: { show: false },
  },
  series: [{
    type: 'bar',
    data: weights.map(w => ({
      value: w.weight,
      itemStyle: { color: w.color, borderRadius: [0, 4, 4, 0] },
    })).reverse(),
    barWidth: 24,
    label: { show: true, position: 'right' as const, color: '#9ca3af', formatter: '{c}%' },
  }],
}))

const sections = [
  {
    id: 'income',
    title: '1. Net Income Margin (25 pts)',
    source: 'Income Statement',
    formula: 'Net Income / Total Revenue × 100',
    icon: 'M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z',
    desc: 'Measures what percentage of revenue becomes actual profit. Higher margins mean the company keeps more of every dollar it earns. Apple ~25%, Samsung ~15%, Xiaomi ~0.3%.',
    scoring: [
      { range: '> 20%', pts: 25, label: 'Excellent' },
      { range: '10-20%', pts: 20, label: 'Great' },
      { range: '5-10%', pts: 15, label: 'Good' },
      { range: '0-5%', pts: 8, label: 'OK' },
      { range: '< 0%', pts: 0, label: 'Losing money' },
    ],
  },
  {
    id: 'roa',
    title: '2. Return on Assets (20 pts)',
    source: 'Income Statement + Balance Sheet',
    formula: 'Net Income / Total Assets × 100',
    icon: 'M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4',
    desc: 'Shows how efficiently the company uses its assets to generate profit. Apple ROA 28% vs Samsung 10% — Apple squeezes more profit from every dollar of assets.',
    scoring: [
      { range: '> 15%', pts: 20, label: 'Excellent' },
      { range: '8-15%', pts: 16, label: 'Great' },
      { range: '3-8%', pts: 10, label: 'Good' },
      { range: '0-3%', pts: 5, label: 'OK' },
      { range: '< 0%', pts: 0, label: 'Inefficient' },
    ],
  },
  {
    id: 'fcf',
    title: '3. Free Cash Flow Yield (25 pts)',
    source: 'Cash Flow Statement',
    formula: '(Operating Cash Flow − CapEx) / Market Cap × 100',
    icon: 'M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z',
    desc: 'The real cash a business generates relative to its market value. Warren Buffett\'s favorite indicator. If you owned the entire company, this is the cash it would put in your pocket. Apple FCF: $114B.',
    scoring: [
      { range: '> 8%', pts: 25, label: 'Excellent' },
      { range: '5-8%', pts: 20, label: 'Great' },
      { range: '2-5%', pts: 15, label: 'Good' },
      { range: '0-2%', pts: 8, label: 'OK' },
      { range: '< 0%', pts: 0, label: 'Burning cash' },
    ],
  },
  {
    id: 'debt',
    title: '4. Debt / Equity (15 pts)',
    source: 'Balance Sheet',
    formula: 'Total Debt / Shareholder Equity × 100',
    icon: 'M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3',
    desc: 'Measures how much debt the company carries relative to shareholder equity. Lower is better. A very high ratio means the company is heavily leveraged — risky like personal debt.',
    scoring: [
      { range: '< 30%', pts: 15, label: 'Conservative' },
      { range: '30-60%', pts: 12, label: 'Moderate' },
      { range: '60-100%', pts: 8, label: 'Leveraged' },
      { range: '100-200%', pts: 4, label: 'High risk' },
      { range: '> 200%', pts: 0, label: 'Dangerous' },
    ],
  },
  {
    id: 'ema',
    title: '5. EMA Position (15 pts)',
    source: 'Technical Analysis',
    formula: 'Count of EMAs (20, 52, 200) above current price',
    icon: 'M13 17h8m0 0V9m0 8l-8-8-4 4-6-6',
    desc: 'When the price is below its moving averages, it may signal a value opportunity — the stock could be trading at a discount. More EMAs above price = stronger discount signal.',
    scoring: [
      { range: 'Below 3/3', pts: 15, label: 'Deep value' },
      { range: 'Below 2/3', pts: 10, label: 'Discount zone' },
      { range: 'Below 1/3', pts: 5, label: 'Slight dip' },
      { range: 'Above all', pts: 0, label: 'Full price' },
    ],
  },
]
</script>

<template>
  <div class="max-w-4xl mx-auto">
    <div class="mb-8">
      <router-link to="/" class="text-sm text-gray-400 hover:text-white transition-colors">
        &lt; Back
      </router-link>
    </div>

    <h1 class="text-3xl font-bold text-white mb-2">Health Score Methodology</h1>
    <p class="text-gray-400 mb-2">
      How we calculate the financial health score for each stock (0-100).
    </p>
    <p class="text-sm text-gray-500 mb-8">
      Based on Warren Buffett's approach to reading financial statements:
      Income Statement, Balance Sheet, and Cash Flow Statement.
    </p>

    <!-- Weight chart -->
    <div class="card mb-8">
      <h2 class="text-lg font-semibold text-white mb-1">Score Weight Distribution</h2>
      <p class="text-sm text-gray-400 mb-4">Each indicator contributes a weighted portion to the total 100-point score</p>
      <v-chart :option="chartOption" style="height: 220px" autoresize />
    </div>

    <!-- Score ranges -->
    <div class="card mb-8">
      <h2 class="text-lg font-semibold text-white mb-4">Score Interpretation</h2>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
        <div class="p-3 rounded-lg bg-green-900/20 border border-green-800/40 text-center">
          <p class="text-2xl font-bold text-green-400 font-mono">70-100</p>
          <p class="text-xs text-green-400/80 font-medium">Strong</p>
          <p class="text-[10px] text-gray-500 mt-1">Healthy financials, good cash flow</p>
        </div>
        <div class="p-3 rounded-lg bg-yellow-900/20 border border-yellow-800/40 text-center">
          <p class="text-2xl font-bold text-yellow-400 font-mono">45-69</p>
          <p class="text-xs text-yellow-400/80 font-medium">Moderate</p>
          <p class="text-[10px] text-gray-500 mt-1">Mixed signals, do more research</p>
        </div>
        <div class="p-3 rounded-lg bg-orange-900/20 border border-orange-800/40 text-center">
          <p class="text-2xl font-bold text-orange-400 font-mono">25-44</p>
          <p class="text-xs text-orange-400/80 font-medium">Weak</p>
          <p class="text-[10px] text-gray-500 mt-1">Some red flags present</p>
        </div>
        <div class="p-3 rounded-lg bg-red-900/20 border border-red-800/40 text-center">
          <p class="text-2xl font-bold text-red-400 font-mono">0-24</p>
          <p class="text-xs text-red-400/80 font-medium">Poor</p>
          <p class="text-[10px] text-gray-500 mt-1">Losing money or high debt</p>
        </div>
      </div>
    </div>

    <!-- Detailed indicator sections -->
    <div class="space-y-6 mb-8">
      <div v-for="sec in sections" :key="sec.id" class="card">
        <div class="flex items-start gap-3 mb-4">
          <div class="w-10 h-10 rounded-lg bg-primary-900/30 border border-primary-800/40 flex items-center justify-center flex-shrink-0">
            <svg class="w-5 h-5 text-primary-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" :d="sec.icon" />
            </svg>
          </div>
          <div>
            <h3 class="text-base font-semibold text-white">{{ sec.title }}</h3>
            <p class="text-xs text-gray-500">Source: {{ sec.source }}</p>
          </div>
        </div>

        <div class="mb-4 p-3 bg-gray-800/50 rounded-lg font-mono text-sm text-primary-300">
          {{ sec.formula }}
        </div>

        <p class="text-sm text-gray-300 mb-4">{{ sec.desc }}</p>

        <div class="border-t border-gray-800 pt-3">
          <p class="text-xs text-gray-500 mb-2">Scoring table:</p>
          <div class="grid grid-cols-5 gap-2">
            <div v-for="(s, i) in sec.scoring" :key="i" class="text-center p-2 rounded-lg bg-gray-800/50">
              <p class="text-xs font-mono font-bold" :class="s.pts > 15 ? 'text-green-400' : s.pts > 8 ? 'text-yellow-400' : s.pts > 0 ? 'text-orange-400' : 'text-red-400'">
                {{ s.pts }} pts
              </p>
              <p class="text-[10px] text-gray-400 mt-0.5">{{ s.range }}</p>
              <p class="text-[10px] text-gray-600">{{ s.label }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- The three financial statements overview -->
    <div class="card mb-8">
      <h2 class="text-lg font-semibold text-white mb-4">The Three Financial Statements</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="p-4 rounded-lg bg-blue-900/10 border border-blue-800/30">
          <h3 class="text-sm font-semibold text-blue-400 mb-2">Income Statement</h3>
          <p class="text-xs text-gray-400 mb-2">Revenue − Costs − Expenses = Net Income</p>
          <p class="text-[10px] text-gray-500">Shows profitability. Used for Net Income Margin and ROA calculations.</p>
        </div>
        <div class="p-4 rounded-lg bg-purple-900/10 border border-purple-800/30">
          <h3 class="text-sm font-semibold text-purple-400 mb-2">Balance Sheet</h3>
          <p class="text-xs text-gray-400 mb-2">Assets = Liabilities + Equity</p>
          <p class="text-[10px] text-gray-500">Shows financial position. Used for ROA and Debt/Equity ratio.</p>
        </div>
        <div class="p-4 rounded-lg bg-green-900/10 border border-green-800/30">
          <h3 class="text-sm font-semibold text-green-400 mb-2">Cash Flow Statement</h3>
          <p class="text-xs text-gray-400 mb-2">Operating CF − CapEx = Free Cash Flow</p>
          <p class="text-[10px] text-gray-500">Shows real cash generation. Used for FCF and FCF Yield calculations.</p>
        </div>
      </div>
    </div>

    <!-- Data source note -->
    <div class="card mb-8 !bg-gray-900/50 border-gray-800">
      <p class="text-xs text-gray-500">
        <span class="text-gray-400 font-medium">Data source:</span> Financial data is fetched from Yahoo Finance via yfinance.
        The score updates automatically when you refresh a stock's data.
        All indicators are trailing twelve months (TTM). Compare scores within the same sector for best results.
      </p>
    </div>
  </div>
</template>
