import Vue from 'vue'
import Router from 'vue-router'
import Ping from '@/components/Ping'
import Books from '@/components/Books'
import MainMenu from '@/components/MainMenu'
import Report from '@/components/Report'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/ping',
      name: 'Ping',
      component: Ping
    },
    { path: '/',
      name: 'Books',
      component: Books
    },
    { path: '/main',
      name: 'main',
      component: MainMenu
    },
    { path: '/report',
      name: 'report',
      component: Report
    }
  ],
  mode: 'history'
})
