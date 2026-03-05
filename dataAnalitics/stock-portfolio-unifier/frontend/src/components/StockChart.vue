<script setup lang="ts">
import { ref, onMounted, watch, computed, shallowRef, nextTick } from 'vue'
import * as echarts from 'echarts/core'
import { CandlestickChart, LineChart, BarChart } from 'echarts/charts'
import {
  TitleComponent, TooltipComponent, GridComponent,
  DataZoomComponent, MarkLineComponent, LegendComponent,
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import { fetchOHLCV, fetchDrawings, createDrawing, deleteDrawing, updateDrawing } from '../services/api'

echarts.use([
  CandlestickChart, LineChart, BarChart, CanvasRenderer,
  TitleComponent, TooltipComponent, GridComponent,
  DataZoomComponent, MarkLineComponent, LegendComponent,
])

const props = defineProps<{ stockId: number; tickerYf: string }>()

const chartRef = ref<HTMLDivElement>()
const chart = shallowRef<echarts.ECharts>()
const loading = ref(true)
const error = ref('')
const period = ref('1y')
const drawMode = ref<'none' | 'hline' | 'trendline' | 'delete'>('none')
const trendStart = ref<{ date: string; price: number } | null>(null)
const dragging = ref<{ id: number; startY: number; origPrice: number } | null>(null)
const drawings = ref<Array<{
  id: number; drawing_type: string; price1: number; price2: number | null
  date1: string | null; date2: string | null; color: string; label: string
}>>([])
const ohlcvData = ref<Array<{ date: string; open: number; high: number; low: number; close: number; volume: number }>>([])

const periods = ['1m', '3m', '6m', '1y', '2y', '5y']

function calcEMA(data: number[], span: number): (number | null)[] {
  const k = 2 / (span + 1)
  const result: (number | null)[] = []
  let prev: number | null = null
  for (let i = 0; i < data.length; i++) {
    if (data[i] === null || data[i] === undefined) {
      result.push(prev)
      continue
    }
    if (prev === null) {
      prev = data[i]
    } else {
      prev = data[i] * k + prev * (1 - k)
    }
    result.push(i < span - 1 ? null : Math.round(prev * 100) / 100)
  }
  return result
}

function buildMarkLines() {
  const lines: any[] = []
  for (const d of drawings.value) {
    if (d.drawing_type === 'hline') {
      lines.push({
        yAxis: d.price1,
        name: d.label || `${d.price1}`,
        lineStyle: { color: d.color, width: 1.5, type: 'dashed' },
        label: {
          formatter: d.label || `{c}`,
          position: 'insideEndTop',
          color: d.color,
          fontSize: 10,
        },
        _drawingId: d.id,
      })
    } else if (d.drawing_type === 'trendline' && d.date1 && d.date2) {
      lines.push([
        {
          xAxis: d.date1, yAxis: d.price1,
          lineStyle: { color: d.color, width: 1.5 },
          label: { show: false },
          _drawingId: d.id,
        },
        {
          xAxis: d.date2, yAxis: d.price2,
          label: {
            formatter: d.label || '',
            position: 'end',
            color: d.color,
            fontSize: 10,
          },
        },
      ])
    }
  }
  return lines
}

function buildOption() {
  const dates = ohlcvData.value.map(d => d.date)
  const ohlc = ohlcvData.value.map(d => [d.open, d.close, d.low, d.high])
  const volumes = ohlcvData.value.map(d => d.volume)
  const closes = ohlcvData.value.map(d => d.close)

  const ema20 = calcEMA(closes, 20)
  const ema52 = calcEMA(closes, 52)
  const ema200 = calcEMA(closes, 200)

  return {
    animation: false,
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'cross' },
      backgroundColor: 'rgba(17,24,39,0.95)',
      borderColor: '#374151',
      textStyle: { color: '#d1d5db', fontSize: 11 },
    },
    legend: {
      data: ['EMA 20', 'EMA 52', 'EMA 200'],
      top: 0,
      textStyle: { color: '#9ca3af', fontSize: 11 },
      inactiveColor: '#4b5563',
    },
    grid: [
      { left: 60, right: 20, top: 35, height: '60%' },
      { left: 60, right: 20, top: '78%', height: '15%' },
    ],
    xAxis: [
      {
        type: 'category',
        data: dates,
        gridIndex: 0,
        axisLine: { lineStyle: { color: '#374151' } },
        axisLabel: { color: '#9ca3af', fontSize: 10 },
        splitLine: { show: false },
      },
      {
        type: 'category',
        data: dates,
        gridIndex: 1,
        axisLine: { lineStyle: { color: '#374151' } },
        axisLabel: { show: false },
        splitLine: { show: false },
      },
    ],
    yAxis: [
      {
        type: 'value',
        scale: true,
        gridIndex: 0,
        axisLine: { lineStyle: { color: '#374151' } },
        axisLabel: { color: '#9ca3af', fontSize: 10 },
        splitLine: { lineStyle: { color: '#1f2937' } },
      },
      {
        type: 'value',
        scale: true,
        gridIndex: 1,
        axisLine: { show: false },
        axisLabel: { show: false },
        splitLine: { show: false },
      },
    ],
    dataZoom: [
      { type: 'inside', xAxisIndex: [0, 1], start: 60, end: 100 },
      {
        type: 'slider',
        xAxisIndex: [0, 1],
        bottom: 5, height: 20,
        borderColor: '#374151',
        backgroundColor: '#111827',
        fillerColor: 'rgba(59,130,246,0.15)',
        handleStyle: { color: '#6b7280' },
        textStyle: { color: '#9ca3af' },
      },
    ],
    series: [
      {
        name: props.tickerYf,
        type: 'candlestick',
        data: ohlc,
        xAxisIndex: 0,
        yAxisIndex: 0,
        itemStyle: {
          color: '#22c55e',
          color0: '#ef4444',
          borderColor: '#22c55e',
          borderColor0: '#ef4444',
        },
        markLine: {
          symbol: 'none',
          data: buildMarkLines(),
          silent: false,
        },
      },
      {
        name: 'EMA 20',
        type: 'line',
        data: ema20,
        xAxisIndex: 0,
        yAxisIndex: 0,
        smooth: true,
        showSymbol: false,
        lineStyle: { color: '#3b82f6', width: 1 },
        itemStyle: { color: '#3b82f6' },
      },
      {
        name: 'EMA 52',
        type: 'line',
        data: ema52,
        xAxisIndex: 0,
        yAxisIndex: 0,
        smooth: true,
        showSymbol: false,
        lineStyle: { color: '#eab308', width: 1 },
        itemStyle: { color: '#eab308' },
      },
      {
        name: 'EMA 200',
        type: 'line',
        data: ema200,
        xAxisIndex: 0,
        yAxisIndex: 0,
        smooth: true,
        showSymbol: false,
        lineStyle: { color: '#ef4444', width: 1 },
        itemStyle: { color: '#ef4444' },
      },
      {
        name: 'Volume',
        type: 'bar',
        data: volumes,
        xAxisIndex: 1,
        yAxisIndex: 1,
        itemStyle: { color: 'rgba(59,130,246,0.3)' },
        large: true,
      },
    ],
  }
}

function updateChart() {
  if (!chart.value) return
  chart.value.setOption(buildOption(), { notMerge: true })
}

async function loadData() {
  loading.value = true
  error.value = ''
  try {
    const [ohlcvResult, drawingsResult] = await Promise.all([
      fetchOHLCV(props.stockId, period.value),
      fetchDrawings(props.stockId),
    ])
    ohlcvData.value = ohlcvResult.data
    drawings.value = drawingsResult
    updateChart()
  } catch (e: any) {
    error.value = e.message || 'Failed to load chart data'
  } finally {
    loading.value = false
  }
}

function handleChartClick(params: any) {
  if (drawMode.value !== 'hline' && drawMode.value !== 'trendline') return
  if (!chart.value || ohlcvData.value.length === 0) return

  const pointInPixel = [params.offsetX, params.offsetY]
  const pointInGrid = chart.value.convertFromPixel({ gridIndex: 0 }, pointInPixel)
  if (!pointInGrid) return

  const dateIdx = Math.round(pointInGrid[0])
  const price = Math.round(pointInGrid[1] * 100) / 100
  const dateStr = ohlcvData.value[dateIdx]?.date
  if (!dateStr || price <= 0) return

  if (drawMode.value === 'hline') {
    createDrawing(props.stockId, {
      drawing_type: 'hline',
      price1: price,
      color: '#facc15',
      label: `${price}`,
    }).then(d => {
      drawings.value.push(d)
      updateChart()
    })
    drawMode.value = 'none'
  } else if (drawMode.value === 'trendline') {
    if (!trendStart.value) {
      trendStart.value = { date: dateStr, price }
    } else {
      createDrawing(props.stockId, {
        drawing_type: 'trendline',
        price1: trendStart.value.price,
        price2: price,
        date1: trendStart.value.date,
        date2: dateStr,
        color: '#38bdf8',
      }).then(d => {
        drawings.value.push(d)
        updateChart()
      })
      trendStart.value = null
      drawMode.value = 'none'
    }
  }
}

function handleMarkLineClick(params: any) {
  if (params.componentType !== 'markLine') return
  const drawingId = params.data?._drawingId
  if (!drawingId) return

  if (drawMode.value === 'delete') {
    deleteDrawing(props.stockId, drawingId).then(() => {
      drawings.value = drawings.value.filter(d => d.id !== drawingId)
      updateChart()
    })
  }
}

function handleMarkLineMouseDown(params: any) {
  if (params.componentType !== 'markLine') return
  if (drawMode.value !== 'none') return
  const drawingId = params.data?._drawingId
  if (!drawingId) return
  const drawing = drawings.value.find(d => d.id === drawingId)
  if (!drawing || drawing.drawing_type !== 'hline') return

  params.event?.event?.preventDefault?.()
  dragging.value = { id: drawingId, startY: params.event?.event?.clientY ?? params.event?.offsetY ?? 0, origPrice: drawing.price1 }
}

function handleMouseMove(e: MouseEvent) {
  if (!dragging.value || !chart.value) return
  const pixel = chart.value.convertFromPixel({ gridIndex: 0 }, [0, e.offsetY])
  if (!pixel) return
  const newPrice = Math.round(pixel[1] * 100) / 100
  if (newPrice <= 0) return

  const d = drawings.value.find(d => d.id === dragging.value!.id)
  if (d) {
    d.price1 = newPrice
    d.label = `${newPrice}`
    updateChart()
  }
}

function handleMouseUp() {
  if (!dragging.value) return
  const d = drawings.value.find(d => d.id === dragging.value!.id)
  const dragInfo = dragging.value
  dragging.value = null

  if (d && d.price1 !== dragInfo.origPrice) {
    updateDrawing(props.stockId, dragInfo.id, { price1: d.price1, label: `${d.price1}` })
  }
}

function toggleMode(mode: 'hline' | 'trendline' | 'delete') {
  trendStart.value = null
  drawMode.value = drawMode.value === mode ? 'none' : mode
}

onMounted(async () => {
  await nextTick()
  if (chartRef.value) {
    chart.value = echarts.init(chartRef.value, undefined, { renderer: 'canvas' })
    chart.value.getZr().on('click', handleChartClick)
    chart.value.on('click', handleMarkLineClick)
    chart.value.on('mousedown', handleMarkLineMouseDown)
    chartRef.value.addEventListener('mousemove', handleMouseMove)
    chartRef.value.addEventListener('mouseup', handleMouseUp)
    chartRef.value.addEventListener('mouseleave', handleMouseUp)

    const ro = new ResizeObserver(() => chart.value?.resize())
    ro.observe(chartRef.value)
  }
  await loadData()
})

watch(period, () => loadData())
watch(() => props.stockId, () => loadData())

const cursorClass = computed(() => {
  if (dragging.value) return 'cursor-grabbing'
  if (drawMode.value === 'hline' || drawMode.value === 'trendline') return 'cursor-crosshair'
  if (drawMode.value === 'delete') return 'cursor-pointer'
  return ''
})
</script>

<template>
  <div class="card">
    <!-- Toolbar -->
    <div class="flex items-center justify-between mb-3 flex-wrap gap-2">
      <div class="flex items-center gap-2">
        <span class="text-sm font-medium text-white mr-2">Chart</span>
        <button
          @click="toggleMode('hline')"
          :class="[
            'px-2.5 py-1 rounded text-xs font-medium transition-colors border',
            drawMode === 'hline'
              ? 'bg-yellow-900/40 text-yellow-300 border-yellow-700'
              : 'bg-gray-800 text-gray-400 border-gray-700 hover:border-gray-600'
          ]"
        >
          ─ H-Line
        </button>
        <button
          @click="toggleMode('trendline')"
          :class="[
            'px-2.5 py-1 rounded text-xs font-medium transition-colors border',
            drawMode === 'trendline'
              ? 'bg-sky-900/40 text-sky-300 border-sky-700'
              : 'bg-gray-800 text-gray-400 border-gray-700 hover:border-gray-600'
          ]"
        >
          ╱ Trend
        </button>
        <button
          @click="toggleMode('delete')"
          :class="[
            'px-2.5 py-1 rounded text-xs font-medium transition-colors border',
            drawMode === 'delete'
              ? 'bg-red-900/40 text-red-300 border-red-700'
              : 'bg-gray-800 text-gray-400 border-gray-700 hover:border-gray-600'
          ]"
        >
          &times; Delete
        </button>
        <span v-if="drawMode === 'hline'" class="text-xs text-yellow-400 ml-1">Click chart to place line</span>
        <span v-if="drawMode === 'trendline' && !trendStart" class="text-xs text-sky-400 ml-1">Click start point</span>
        <span v-if="drawMode === 'trendline' && trendStart" class="text-xs text-sky-400 ml-1">Click end point</span>
        <span v-if="drawMode === 'delete'" class="text-xs text-red-400 ml-1">Click a line to remove it</span>
        <span v-if="drawMode === 'none' && drawings.length > 0" class="text-xs text-gray-500 ml-2">{{ drawings.length }} line{{ drawings.length !== 1 ? 's' : '' }} · drag H-lines to move</span>
      </div>
      <div class="flex items-center gap-1">
        <button
          v-for="p in periods"
          :key="p"
          @click="period = p"
          :class="[
            'px-2 py-1 rounded text-xs font-mono font-medium transition-colors',
            period === p
              ? 'bg-primary-600 text-white'
              : 'bg-gray-800 text-gray-400 hover:bg-gray-700'
          ]"
        >{{ p.toUpperCase() }}</button>
      </div>
    </div>

    <!-- Chart -->
    <div v-if="error" class="text-red-400 text-sm py-8 text-center">{{ error }}</div>
    <div v-if="loading && ohlcvData.length === 0" class="text-gray-500 text-sm py-16 text-center">Loading chart data...</div>
    <div
      ref="chartRef"
      :class="['w-full', cursorClass]"
      style="height: 420px"
    ></div>
  </div>
</template>
