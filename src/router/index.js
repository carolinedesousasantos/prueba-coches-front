import Vue from 'vue'
import VueRouter from 'vue-router'
import TableCochesView from '../views/TableCochesView.vue'
import FormView from '../views/FormView.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'TableCochesView',
    component: TableCochesView
  },
  {
    path: '/form/:id',
    name: 'FormCochesView',
    component: FormView
  },

]

const router = new VueRouter({
  routes
})

export default router
