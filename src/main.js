import { createApp } from 'vue'
import App from './App.vue'
// import T from './components/T.vue'
import './debug'

const app = createApp(App)
app.mount('#app')
app.config.globalProperties.console = console
