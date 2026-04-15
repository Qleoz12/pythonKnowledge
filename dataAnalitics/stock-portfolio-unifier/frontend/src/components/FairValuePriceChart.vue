<script setup lang="ts">
/**
 * Gráfico dedicado precio vs FVE (ECharts propio). Separado de StockChart.vue para no mezclar registros ni ciclo de vida.
 */
import { ref, shallowRef, watch, onMounted, onUnmounted, nextTick } from 'vue'
import * as echarts from 'echarts/core'
import { LineChart, CustomChart } from 'echarts/charts'
import {
  TooltipComponent, GridComponent, DataZoomComponent, LegendComponent,
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import type { FairValueSeries } from '../types'

echarts.use([
  LineChart, CustomChart, CanvasRenderer,
  TooltipComponent, GridComponent, DataZoomComponent, LegendComponent,
])

const props = defineProps<{
  series: FairValueSeries | null
}>()

const rootRef = ref<HTMLDivElement>()
const chart = shallowRef<echarts.ECharts>()

function segmentFillColor(c0: number, c1: number, f0: number, f1: number): string {
  const m0 = c0 - f0
  const m1 = c1 - f1
  if (m0 <= 0 && m1 <= 0) return 'rgba(59, 130, 246, 0.22)'
  if (m0 >= 0 && m1 >= 0) return 'rgba(249, 115, 22, 0.22)'
  return m0 + m1 < 0 ? 'rgba(59, 130, 246, 0.16)' : 'rgba(249, 115, 22, 0.16)'
}

function applyOption() {
  const ser = props.series
  if (!rootRef.value || !ser?.dates?.length || !ser.has_fair_value) {
    chart.value?.dispose()
    chart.value = undefined
    return
  }

  const dates = ser.dates
  const closes = ser.close
  const fves = ser.fve.map(v => (v == null ? NaN : v))

  if (!chart.value) {
    chart.value = echarts.init(rootRef.value, undefined, { renderer: 'canvas' })
  }

  const segData: number[][] = []
  for (let i = 0; i < dates.length - 1; i++) {
    const f0 = fves[i]
    const f1 = fves[i + 1]
    if (!Number.isFinite(f0) || !Number.isFinite(f1)) continue
    segData.push([i, i + 1])
  }

  const option = {
    animation: false,
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'cross' },
      formatter(params: any[]) {
        const p0 = params.find((p: any) => p.seriesName === 'Cierre')
        if (!p0) return ''
        const idx = p0.dataIndex
        const f = ser.fve[idx]
        const r = ser.price_to_fve[idx]
        const u = ser.undervalued[idx]
        const lines = [
          `<div class="font-mono text-xs">${dates[idx]}</div>`,
          `<div>Cierre: <b>${closes[idx]?.toFixed(2)}</b></div>`,
        ]
        if (f != null) lines.push(`<div>FVE: <b>${f.toFixed(2)}</b></div>`)
        if (r != null) lines.push(`<div>Price/FVE: <b>${r.toFixed(3)}</b></div>`)
        if (f != null) {
          lines.push(
            `<div class="mt-1">${u ? '<span style="color:#93c5fd">Subvalorizado</span> (precio &lt; FVE)' : '<span style="color:#fdba74">Sobrevalorizado</span> (precio &gt; FVE)'}</div>`,
          )
        }
        return lines.join('')
      },
    },
    legend: {
      data: ['Cierre', 'FVE', 'Banda valoración'],
      textStyle: { color: '#9ca3af', fontSize: 11 },
      top: 0,
    },
    grid: { left: 48, right: 24, top: 40, bottom: 56 },
    dataZoom: [{ type: 'inside', xAxisIndex: 0 }, { type: 'slider', xAxisIndex: 0, height: 18, bottom: 8 }],
    xAxis: {
      type: 'category',
      data: dates,
      axisLabel: { color: '#6b7280', fontSize: 10, rotate: 35 },
    },
    yAxis: {
      type: 'value',
      scale: true,
      splitLine: { lineStyle: { color: '#374151' } },
      axisLabel: { color: '#9ca3af', fontSize: 10 },
    },
    series: [
      {
        type: 'custom',
        name: 'Banda valoración',
        coordinateSystem: 'cartesian2d',
        z: 1,
        data: segData,
        renderItem(params: any, api: any) {
          const pair = params.data as number[]
          const i0 = pair[0]
          const i1 = pair[1]
          const c0 = closes[i0]
          const c1 = closes[i1]
          const f0 = fves[i0]
          const f1 = fves[i1]
          if (!Number.isFinite(f0) || !Number.isFinite(f1)) return
          const pC0 = api.coord([dates[i0], c0])
          const pC1 = api.coord([dates[i1], c1])
          const pF0 = api.coord([dates[i0], f0])
          const pF1 = api.coord([dates[i1], f1])
          const color = segmentFillColor(c0, c1, f0, f1)
          return {
            type: 'polygon',
            shape: { points: [pC0, pC1, pF1, pF0] },
            style: { fill: color, stroke: null },
          }
        },
      },
      {
        type: 'line',
        name: 'Cierre',
        z: 2,
        data: closes,
        showSymbol: false,
        lineStyle: { width: 1.5, color: '#e5e7eb' },
      },
      {
        type: 'line',
        name: 'FVE',
        z: 3,
        step: 'end',
        data: fves.map(v => (Number.isFinite(v) ? v : null)),
        showSymbol: false,
        connectNulls: false,
        lineStyle: { width: 2, color: '#38bdf8', type: 'dashed' },
      },
    ],
  }
  chart.value.setOption(option, true)
  chart.value.resize()
}

function onResize() {
  chart.value?.resize()
}

watch(
  () => props.series,
  () => {
    nextTick(() => applyOption())
  },
  { deep: true },
)

onMounted(() => {
  window.addEventListener('resize', onResize)
  nextTick(() => applyOption())
})

onUnmounted(() => {
  window.removeEventListener('resize', onResize)
  chart.value?.dispose()
  chart.value = undefined
})
</script>

<template>
  <div
    id="fair-value-price-chart-root"
    ref="rootRef"
    class="w-full h-80 rounded-lg border border-violet-900/40 bg-gray-950/60"
    role="img"
    aria-label="Gráfico precio versus valor razonable estimado"
  />
</template>
