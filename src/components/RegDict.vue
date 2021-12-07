<script setup>
import { ref, watch } from 'vue'
import Item from './Item.vue'

function generate(arr, key) {
  outMax.value = arr
    .map(e => e.word.length)
    .sort((l, r) => l - r)
    .pop()

  outCount.value = arr.length

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
        if (now.word.startsWith(key)) reduce.start.push(now)
        else if (now.word.endsWith(key)) reduce.end.push(now)
        else reduce.else.push(now)
        return reduce
      },
      { start: [], end: [], else: [] }
    )
  // .filter(e => !out.value.find(ee => ee.word.word === e.word))

  // .filter(
  //   (e, i, arr) => arr.findIndex(ee => ee.definition === e.definition) === i
  // )
  function decodeUnicode(str) {
    return str.replace(/\\u[\dA-Fa-f]{4}/g, function (match) {
      return String.fromCharCode(parseInt(match.replace(/\\u/, ''), 16))
    })
  }
}

const m = ref(0) //idx
const n = ref(500) //页数
const isMore = ref(true)

const int = ref('key')
const out = ref([])
const outMax = ref(0)
const outCount = ref(0)

function begin() {
  const key = int.value.trim().toLowerCase()
  const keyPro = (() => {
    if (['.', '?'].includes(key)) return key
    if (key === '') return '*'
    return `*${key}*`
  })()

  fetch(`https://regdict.com/regdict/?key=${keyPro}&m=${m.value}&n=${n.value}`)
    .then(r => r.json())
    .then(({ words, more }) => {
      out.value = generate(words, key)
      isMore.value = more
    })
}

let clear
watch(
  () => int.value.trim().toLowerCase(),
  () => {
    clearTimeout(clear)
    clear = setTimeout(begin, 1000)
  }
  // { immediate: true }
)

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
  <Item
    :all="[out.start, out.end, out.else]"
    :outMax="outMax * 7 + 20 + 'px'"
  />

  <!-- {{ ''.llt }} -->
</template>

<style scoped>
input {
  color: #0088de;
}
</style>
