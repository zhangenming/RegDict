<script setup>
  import { computed, reactive, ref, watchEffect } from 'vue'
  import Item from './Item.vue'
  import mock from '../mock'
  function decodeUnicode(arr, origin) {
    return arr.map(e => ({
      word: (() => {
        const idx = e.word.indexOf(origin)
        const l = e.word.slice(0, idx)
        const r = e.word.slice(idx + origin.length)
        return {
          word: e.word,
          l,
          m: origin,
          r,
        }
      })(),
      definition: _decodeUnicode(e.definition),
    }))
    function _decodeUnicode(str) {
      return str.replace(/\\u[\dA-Fa-f]{4}/g, function (match) {
        return String.fromCharCode(parseInt(match.replace(/\\u/, ''), 16))
      })
    }
  }

  const m = ref(0) //idx
  const n = ref(10) //页数
  const isMore = ref(false)

  const int = ref('react')
  const INT = computed(() => {
    // isMore.value = false
    // m.value = 0
    // out.value = []
    return `*${int.value}*`
  })
  const out = ref([])
  const outMax = computed(() => {
    return Math.max(...out.value.map(e => e.word.word.length))
  })
  const OUT = computed(() => {
    return [...out.value] // ?
      .sort((l, r) => (l.word.word > r.word.word ? 1 : -1))
      .reduce(
        (all, now) => {
          if (now.word.word.startsWith(int.value)) all.start.push(now)
          else if (now.word.word.endsWith(int.value)) all.end.push(now)
          else all.else.push(now)
          return all
        },
        { start: [], end: [], else: [] }
      )
  })

  const ajax = computed(
    () =>
      `https://regdict.com/regdict/?key=${INT.value}&m=${m.value}&n=${n.value}`
  )
  function start() {
    fetch(ajax.value)
      .then(r => {
        return r.json()
      })
      .then(res => {
        const { more, words } = res
        out.value.push(...decodeUnicode(words, int.value))
        isMore.value = more
        m.value += n.value
      })
  }

  ;(function mockData() {
    const { more, words } = mock
    out.value.push(...decodeUnicode(words, int.value))
    isMore.value = more
    m.value += n.value
  })()

  console.time()
  'tmp'.llt
  'tmp'.llt
  'tmp'.llt
  'tmp'.llt
  console.timeEnd()
  const _console = console
</script>

<template>
  {{ 'tmp'.llt }}
  {{ _console.time() }}
  <input type="text" v-model="int" />
  <button @click="start">start {{ isMore ? 'more' : '' }}</button>
  {{ outMax }}
  {{ out.length }}

  <Item :words="OUT.start" />
  <Item :words="OUT.end" />
  <Item :words="OUT.else" />
  {{ _console.timeEnd() }}
  {{ 'tmp'.llt }}
</template>

<style scoped>
  input {
    color: #0088de;
  }
</style>
