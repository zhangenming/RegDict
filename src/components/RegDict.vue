<script setup>
import { reactive, ref, watch } from 'vue'
import Item from './Item.vue'
import T from './T.vue'
// const refresh = ref([])

async function sleep(n) {
  return new Promise(q => setTimeout(q, n))
}
function decodeUnicode(str) {
  return str.replace(/\\u[\dA-Fa-f]{4}/g, function (match) {
    return String.fromCharCode(parseInt(match.replace(/\\u/, ''), 16))
  })
}

const m = ref(0) //idx
const n = ref(500) //页数
const isMore = ref(true)

const int = ref('z*')
const out = ref('nodata')
function begin() {
  const key = int.value.trim().toLowerCase()
  const keyPro = (() => {
    if (['.', '*'].some(k => key.includes(k))) return key
    if (key === '') return '*'
    return `*${key}*`
  })()

  fetch(`https://regdict.com/regdict/?key=${keyPro}&m=${m.value}&n=${n.value}`)
    .then(_ => _.json())
    .then(({ words, more }) => {
      out.value = words
      isMore.value = more
    })
}

let clear
watch(
  () => int.value.toLowerCase(),
  () => {
    clearTimeout(clear)
    clear = setTimeout(begin, 1000)
  }
  // { immediate: true }
)

const ARR = []
const n_ = 550 //per
let m_ = -n_ //now
async function gets() {
  m_ += n_
  const tmp = await fetch(`https://regdict.com/regdict/?key=z*&m=${m_}&n=${n_}`)
  return await tmp.json()
}
async function sets(data) {
  ARR.push(
    ...data.map(({ word, definition }) => ({
      word,
      definition: decodeUnicode(definition),
    }))
  )
}
async function main() {
  const { words, more } = await gets()
  sets(words)
  if (more) {
    await sleep(500)
    main()
  } else {
    localStorage.setItem(
      `z${n_}`,
      JSON.stringify(
        ARR.sort((q, w) => q.word.localeCompare(w.word))
        // .sort((l, r) => (l.word > r.word ? 1 : -1))
      )
    )
    console.log(
      '99',
      localStorage.getItem('x') === localStorage.getItem(`z${n_}`)
    )
  }
}

const allData = Object.entries(localStorage).sort((q, w) =>
  q[0].localeCompare(w[0])
)
</script>

<template>
  <!-- refresh: {{ refresh.push('') }} -->
  <!-- <button @click="() => refresh.push('')">refresh</button> -->
  <!-- {{ refresh.length }} -->
  <!-- {{ refresh }} -->
  <button @click="main">main</button>
  <button @click="begin">begin</button>
  <!-- {{ ''.llt }} -->

  <p>
    <input v-model="int" type="text" />
  </p>

  <div class="content">
    <!-- <Item v-if="out !== 'nodata'" :data="out" :int="int" /> -->
    <div v-for="[name, data] of allData">
      <Item :name="name" :data="data" :int="int" />
    </div>
  </div>
  <!-- {{ ''.llt }} -->
  <!-- Array(26).fill().map((_,i)=>String.fromCharCode(97+i)) -->
</template>

<style scoped>
input {
  color: #0088de;
}
.content {
  display: flex;
}
.item {
  display: flex;
  flex-direction: column;
}
</style>
