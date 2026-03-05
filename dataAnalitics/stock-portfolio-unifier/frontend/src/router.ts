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
    path: '/stocks/:id',
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
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
