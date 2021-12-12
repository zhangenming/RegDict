<script setup>
import { reactive, ref, watch } from 'vue'
import Item from './Item.vue'
import T from './T.vue'
const refresh = ref([])

async function sleep(n) {
  return new Promise(q => setTimeout(q, n))
}
function solo(arr) {
  return [...new Set(arr)]
}
function decodeUnicode(str) {
  return str.replace(/\\u[\dA-Fa-f]{4}/g, function (match) {
    return String.fromCharCode(parseInt(match.replace(/\\u/, ''), 16))
  })
}

const int = ref('z*')
const m = ref(0) // now
const n = ref(200) // per

const ARR = []

async function gets() {
  const keyPro = (() => {
    const key = int.value.trim().toLowerCase()
    if (['.', '*'].some(k => key.includes(k))) return key
    if (key === '') return '*'
    return `*${key}*`
  })()

  m.value += n.value
  const tmp = await fetch(
    'https://regdict.com/regdict/' +
      `?key=${keyPro}&m=${m.value - n.value}&n=${n.value}`
  )
  return await tmp.json()
}

async function main() {
  await sleep(500)

  const { words, more } = await gets()
  ARR.push(...words)

  if (more) {
    main()
  } else {
    console.log('done')
    localStorage.setItem(n.value, JSON.stringify(ARR))
  }
}

const allData = Object.entries(localStorage)
  .sort(([l], [r]) => l - r)
  .map(([name, data]) => [
    name,
    JSON.parse(data)
      .map(({ word, definition }) => ({
        word,
        definition: decodeUnicode(definition),
      }))
      .sort((q, w) => q.word.localeCompare(w.word)),
    // .sort((l, r) => (l.word > r.word ? 1 : -1))
  ])

const selects = ref(reactive([]))
function selectHandle(name) {
  selects.value.unshift(name)
  if (selects.value.length < 2) return
  let [l, r] = selects.value.sort((q, w) => q - w)

  l = JSON.parse(localStorage[l]).map(e => e.word)
  r = JSON.parse(localStorage[r] || '[]').map(e => e.word)

  console.clear()
  const L = solo(l.filter(e => !r.includes(e))).ll
  // const M = solo(l.filter(e => r.includes(e)))
  const R = solo(r.filter(e => !l.includes(e))).ll
}
function delHandle(name) {
  localStorage.removeItem(name)
  refresh.value.push('')
}
</script>

<template>
  <!-- refresh: {{ refresh.push('') }} -->
  <!-- <button @click="() => refresh.push('')">refresh</button> -->
  <!-- {{ refresh.length }} -->
  <span>{{ refresh }}</span>
  <!-- {{ ''.llt }} -->

  <p>
    查询
    <input v-model="int" type="text" />
    数目
    <input v-model.number="n" type="text" />
    <button @click="main">main</button>
  </p>

  <div class="content">
    <!-- <Item v-if="out !== 'nodata'" :data="out" :int="int" /> -->
    <div v-for="[name, data] of allData">
      <Item
        @select="selectHandle"
        @del="delHandle"
        v-bind="{
          name,
          data,
          int,
          selects: selects.slice(0, 2),
          refresh,
        }"
      />
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
input {
  width: 70px;
}
</style>
