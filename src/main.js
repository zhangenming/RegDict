import { createApp } from 'vue'
import App from './App.vue'
// import T from './components/T.vue'
import './debug'

const app = createApp(App)
app.config.globalProperties.console = console
app.mount('#app')
