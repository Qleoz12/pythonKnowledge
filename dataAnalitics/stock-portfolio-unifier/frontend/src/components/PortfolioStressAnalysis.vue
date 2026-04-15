<script setup lang="ts">
import {
  portfolioLStressPositions,
  portfolioLStressTotals,
  portfolioLEquitySummary,
} from '../data/portfolioLStress'

function fmtMoney(n: number, signed = false): string {
  const s = n < 0 && signed ? '−' : ''
  const abs = Math.abs(n)
  return s + '$' + abs.toLocaleString('en-US', { maximumFractionDigits: 0 })
}

function fmtPx(n: number): string {
  return '$' + n.toLocaleString('en-US', { minimumFractionDigits: n % 1 ? 2 : 0, maximumFractionDigits: 2 })
}
</script>

<template>
  <div class="space-y-6 mb-8">
    <div>
      <h2 class="text-lg font-semibold text-white mb-1">Análisis de estrés (referencia)</h2>
      <p class="text-sm text-gray-500">
        Escenario de precios de estrés y reducción de posiciones según tu plan; totales alineados con el resumen de equity.
      </p>
    </div>

    <div class="card overflow-hidden p-0">
      <div class="px-6 py-4 border-b border-gray-800">
        <h3 class="text-sm font-medium text-gray-300">Por posición</h3>
      </div>
      <div class="overflow-x-auto">
        <table class="w-full text-sm min-w-[900px]">
          <thead>
            <tr class="border-b border-gray-800 text-gray-400 text-left">
              <th class="px-4 py-3 font-medium">Ticker</th>
              <th class="px-4 py-3 text-right font-medium">Shares</th>
              <th class="px-4 py-3 text-right font-medium">Px actual</th>
              <th class="px-4 py-3 text-right font-medium">Px estrés</th>
              <th class="px-4 py-3 text-right font-medium">Valor actual</th>
              <th class="px-4 py-3 text-right font-medium">Valor estrés</th>
              <th class="px-4 py-3 text-right font-medium">Pérdida estrés</th>
              <th class="px-4 py-3 text-right font-medium">Vender</th>
              <th class="px-4 py-3 text-right font-medium">Shares finales</th>
              <th class="px-4 py-3 text-right font-medium">Flujo /mes</th>
              <th class="px-4 py-3 text-right font-medium">Flujo post.</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="r in portfolioLStressPositions"
              :key="r.ticker"
              class="border-b border-gray-800/50 hover:bg-gray-800/40"
            >
              <td class="px-4 py-3 font-mono font-medium text-white">{{ r.ticker }}</td>
              <td class="px-4 py-3 text-right text-gray-200 font-mono">{{ r.shares.toLocaleString('en-US') }}</td>
              <td class="px-4 py-3 text-right text-gray-300 font-mono">{{ fmtPx(r.pxActual) }}</td>
              <td class="px-4 py-3 text-right text-amber-200/90 font-mono">{{ fmtPx(r.pxStress) }}</td>
              <td class="px-4 py-3 text-right text-white font-mono">{{ fmtMoney(r.valorActual) }}</td>
              <td class="px-4 py-3 text-right text-gray-300 font-mono">{{ fmtMoney(r.valorStress) }}</td>
              <td class="px-4 py-3 text-right text-red-400 font-mono">{{ r.perdidaStress.toLocaleString('en-US') }}</td>
              <td class="px-4 py-3 text-right font-mono text-amber-300 font-semibold">{{ r.vender.toLocaleString('en-US') }}</td>
              <td class="px-4 py-3 text-right text-gray-200 font-mono">{{ r.sharesFinales.toLocaleString('en-US') }}</td>
              <td class="px-4 py-3 text-right text-green-400/90 font-mono">{{ fmtMoney(r.flujoActual) }}</td>
              <td class="px-4 py-3 text-right text-green-300/80 font-mono">{{ fmtMoney(r.flujoPosterior) }}</td>
            </tr>
            <tr class="bg-gray-800/60 font-medium border-t border-gray-700">
              <td class="px-4 py-3 text-gray-300">TOTAL</td>
              <td class="px-4 py-3 text-right text-gray-500">—</td>
              <td class="px-4 py-3 text-right text-gray-500">—</td>
              <td class="px-4 py-3 text-right text-gray-500">—</td>
              <td class="px-4 py-3 text-right text-white font-mono">{{ fmtMoney(portfolioLStressTotals.valorActual) }}</td>
              <td class="px-4 py-3 text-right text-gray-200 font-mono">{{ fmtMoney(portfolioLStressTotals.valorStress) }}</td>
              <td class="px-4 py-3 text-right text-red-400 font-mono">{{ portfolioLStressTotals.perdidaStress.toLocaleString('en-US') }}</td>
              <td class="px-4 py-3 text-right text-amber-300 font-mono">{{ portfolioLStressTotals.vender.toLocaleString('en-US') }}</td>
              <td class="px-4 py-3 text-right text-gray-200 font-mono">{{ portfolioLStressTotals.sharesFinales.toLocaleString('en-US') }}</td>
              <td class="px-4 py-3 text-right text-green-400 font-mono">{{ fmtMoney(portfolioLStressTotals.flujoActualMes) }}/mes</td>
              <td class="px-4 py-3 text-right text-green-300 font-mono">{{ fmtMoney(portfolioLStressTotals.flujoPosteriorMes) }}/mes</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="card overflow-hidden p-0">
      <div class="px-6 py-4 border-b border-gray-800">
        <h3 class="text-sm font-medium text-gray-300">Resumen equity y apalancamiento</h3>
      </div>
      <table class="w-full text-sm">
        <tbody>
          <tr
            v-for="row in portfolioLEquitySummary"
            :key="row.concepto"
            class="border-b border-gray-800/50 last:border-0"
          >
            <td class="px-6 py-3 text-gray-400 w-[45%] md:w-2/5">{{ row.concepto }}</td>
            <td
              class="px-6 py-3 text-right font-medium"
              :class="{
                'text-white': row.variant === 'default' || !row.variant,
                'text-red-400': row.variant === 'danger',
                'text-amber-400': row.variant === 'warning',
              }"
            >
              {{ row.valor }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
