import { createRouter, createWebHistory } from 'vue-router'
import EquipmentView from '../views/EquipmentView.vue'
import MaintenanceView from '../views/MaintenanceView.vue'
import KnowledgeView from '../views/KnowledgeView.vue'
import AIQueryView from '../views/AIQueryView.vue'

const routes = [
  {
    path: '/',
    redirect: '/equipment'
  },
  {
    path: '/equipment',
    name: 'Equipment',
    component: EquipmentView
  },
  {
    path: '/maintenance',
    name: 'Maintenance',
    component: MaintenanceView
  },
  {
    path: '/knowledge',
    name: 'Knowledge',
    component: KnowledgeView
  },
  {
    path: '/ai-query',
    name: 'AIQuery',
    component: AIQueryView
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router