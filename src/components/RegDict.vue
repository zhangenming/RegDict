<script setup>
import { ref, watch } from 'vue'
import Item from './Item.vue'
function decodeUnicode(str) {
  return str.replace(/\\u[\dA-Fa-f]{4}/g, function (match) {
    return String.fromCharCode(parseInt(match.replace(/\\u/, ''), 16))
  })
}
function generate(arr, key) {
  outCount.value = arr.length

  outMax.value = arr
    .map(e => e.word.length)
    .sort((l, r) => l - r)
    .pop()

  return arr
    .map(({ word, definition }) => {
      const idx = word.indexOf(key)
      return {
        //new
        l: word.slice(0, idx),
        m: key,
        r: word.slice(idx + key.length),
        //old
        definition: decodeUnicode(definition),
        word,
      }
    })
    .sort((l, r) => (l.word > r.word ? 1 : -1))
    .reduce(
      (reduce, now) => {
        if (now.word === key) reduce.self.push(now)
        else if (now.word.startsWith(key)) reduce.start.push(now)
        else if (now.word.endsWith(key)) reduce.end.push(now)
        else reduce.mid.push(now)
        return reduce
      },
      { self: [], start: [], end: [], mid: [] }
    )

  // .filter(e => !out.value.find(ee => ee.word.word === e.word))

  // .filter(
  //   (e, i, arr) => arr.findIndex(ee => ee.definition === e.definition) === i
  // )
}

const m = ref(0) //idx
const n = ref(100) //页数
const isMore = ref(true)

const int = ref('z*')
const out = ref('nodata')
const outMax = ref(0)
const outCount = ref(0)

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
      out.value = generate(words, key.replaceAll('.', '').replaceAll('*', ''))
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

let m_ = 0
let isMore_ = true
async function gets() {
  m_ += 100
  const tmp = await fetch(`https://regdict.com/regdict/?key=z*&m=${m_}&n=100`)
  const { words, more } = await tmp.json()
  isMore_ = more
  return words.map(({ word, definition }) => ({ word, definition }))
}

const ARR = []
document.onclick = async () => {
  if (!isMore_) return

  const data = await gets()
  ARR.push(
    ...data.map(({ word, definition }) => ({
      word,
      definition: decodeUnicode(definition),
    }))
  )

  localStorage.setItem('x', JSON.stringify(ARR))

  console.log(ARR, localStorage)
}
// const refresh = ref([])
</script>

<template>
  <!-- {{ ''.llt }} -->
  <!-- refresh: {{ refresh.push('') }} -->

  <p>
    <input v-model="int" type="text" />
  </p>

  {{ outMax }}
  {{ outCount }}
  <Item v-if="out !== 'nodata'" :all="out" :outMax="outMax * 8 + 'px'" />
  <!-- {{ ''.llt }} -->
</template>

<style scoped>
input {
  color: #0088de;
}
</style>
