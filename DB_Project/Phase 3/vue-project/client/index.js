import { app } from './app'
import 'bootstrap/dist/css/bootstrap.css'

// enable progressive web app support (with offline-plugin)
if (process.env.NODE_ENV === 'production') {
  require('./pwa')
}

app.$mount('#app')

if (module.hot) {
  module.hot.accept()
}
