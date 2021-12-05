<script setup>
  import {
    computed,
    reactive,
    ref,
    watch,
    watchEffect,
    onBeforeMount,
    onMounted,
    onBeforeUpdate,
    onUpdated,
    onBeforeUnmount,
    onUnmounted,
    onActivated,
    onDeactivated,
    onErrorCaptured,
  } from 'vue'
  import Item from './Item.vue'
  import mock from '../mock'
  function decodeUnicode(arr, origin) {
    return arr
      .filter(e => !out.value.find(ee => ee.word.word === e.word))
      .map(e => ({
        word: word(e.word),
        definition: definition(e.definition),
      }))
    // .filter(
    //   (e, i, arr) => arr.findIndex(ee => ee.definition === e.definition) === i
    // )
    function word(word) {
      const idx = word.indexOf(origin)
      const l = word.slice(0, idx)
      const r = word.slice(idx + origin.length)
      return {
        word: word,
        l,
        m: origin,
        r,
      }
    }
    function definition(str) {
      return str.replace(/\\u[\dA-Fa-f]{4}/g, function (match) {
        return String.fromCharCode(parseInt(match.replace(/\\u/, ''), 16))
      })
    }
  }

  const m = ref(0) //idx
  const n = ref(50) //页数
  const isMore = ref(true)

  const int = ref('key')
  const INT = computed(() => {
    if (int.value.includes('?')) return int.value
    if (int.value === '') return '*'
    return `*${int.value}*`
  })

  watch(int, () => {
    console.log(1)
    isMore.value = true
    m.value = 0
    out.value = []
  })

  const out = ref([])
  const outMax = computed(() => {
    return (
      out.value
        .map(e => e.word.word.length)
        .sort()
        .pop() || 0
    )
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
      })
    m.value += n.value
  }

  const refresh = ref([])
</script>

<template>
  <!-- {{ ''.llt }} -->

  refresh: {{ refresh.push('') }}

  <p><input type="text" v-model="int" /></p>
  <button @click="() => isMore && start()">
    start {{ isMore ? 'more' : '' }}
  </button>
  {{ outMax }}
  {{ out.length }}

  <Item :all="[OUT.start, OUT.end, OUT.else]" />

  <!-- {{ ''.llt }} -->
</template>

<style scoped>
  input {
    color: #0088de;
  }
</style>
