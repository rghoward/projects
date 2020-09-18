import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld.vue'
import MainMenu from '@/components/MainMenu.vue'

Vue.use(Router)

export default new Router({
    routes: [
        {
        path: '/',
        name: 'helloworld',
        component: HelloWorld
        },
        {path: '/main',
        name: 'main',
        component: MainMenu
        },
    ],
     mode: 'history',
}
)
