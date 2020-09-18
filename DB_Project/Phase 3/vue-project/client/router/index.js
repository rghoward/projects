import Vue from 'vue'
import Router from 'vue-router'
import Dashboard from 'views/Dashboard'
import Post from 'views/Post'
import About from 'views/About'
import Report1 from 'views/Reports/Report1'
import Report2 from 'views/Reports/Report2'
import Report3 from 'views/Reports/Report3'
import Report4 from 'views/Reports/Report4'
import Report5 from 'views/Reports/Report5'
import Report6 from 'views/Reports/Report6'
import Report1Drill from 'views/Reports/Report1Drill'
import UpdateCity from 'views/Admin/UpdateCity'
Vue.use(Router)

export const routes = [
  {
    path: '/',
    component: Dashboard,
    meta: {
      title: 'Main'
    }
  }, {
    path: '/post/:id',
    component: Post,
    meta: {
      title: 'Post'
    }
  }, {
    path: '/about',
    component: About,
    meta: {
      title: 'About'
    }
  },
  {
    path: '/report1/',
    name: 'Report1',
    component: Report1
  },
  {
    path: '/report1/:id',
    name: 'Report1Drill',
    component: Report1Drill
  },
  {
    path: '/report2',
    name: 'Report2',
    component: Report2
  },
  {
    path: '/report3',
    name: 'Report3',
    component: Report3
  },
  {
    path: '/report4',
    name: 'Report4',
    component: Report4
  },
  {
    path: '/report5',
    name: 'Report5',
    component: Report5
  },
  {
    path: '/city',
    name: 'UpdateCity',
    component: UpdateCity
  },

  {
    path: '/report6',
    name: 'Report6',
    component: Report6
  }
]
export const router = new Router({ mode: 'history', routes })
