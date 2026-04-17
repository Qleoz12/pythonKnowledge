import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Dashboard',
    component: () => import('./views/DashboardView.vue'),
  },
  {
    path: '/stocks',
    name: 'StockExplorer',
    component: () => import('./views/StockExplorer.vue'),
  },
  {
    path: '/stocks/score-trend',
    name: 'ScoreTrend',
    component: () => import('./views/ScoreTrendView.vue'),
  },
  {
    path: '/stocks/:id(\\d+)',
    name: 'StockDetail',
    component: () => import('./views/StockDetail.vue'),
    props: true,
  },
  {
    path: '/dividends',
    name: 'DividendCalendar',
    component: () => import('./views/DividendCalendar.vue'),
  },
  {
    path: '/portfolios',
    name: 'PortfolioManager',
    component: () => import('./views/PortfolioManager.vue'),
  },
  {
    path: '/portfolios/:id',
    name: 'PortfolioDetail',
    component: () => import('./views/PortfolioDetail.vue'),
    props: true,
  },
  {
    path: '/analytics',
    name: 'Analytics',
    component: () => import('./views/AnalyticsView.vue'),
  },
  {
    path: '/correlations',
    name: 'Correlations',
    component: () => import('./views/CorrelationsView.vue'),
  },
  {
    path: '/goals',
    name: 'FinancialGoals',
    component: () => import('./views/FinancialGoals.vue'),
  },
  {
    path: '/score',
    name: 'ScoreMethodology',
    component: () => import('./views/ScoreMethodology.vue'),
  },
  {
    path: '/arbitrage',
    name: 'ArbitrageDashboard',
    component: () => import('./views/ArbitrageDashboard.vue'),
  },
  {
    path: '/p2p',
    name: 'P2PBook',
    component: () => import('./views/P2PBook.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
