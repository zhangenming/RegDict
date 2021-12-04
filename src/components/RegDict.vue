<script setup>
  import { computed, reactive, ref } from 'vue'
  function decodeUnicode(arr) {
    return arr.map(e => ({
      word: e.word,
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
    isMore.value = false
    m.value = 0
    out.value = []
    return `*${int.value}*`
  })

  const out = ref([])
  const OUT = computed(() => {
    return out.value
      .sort((l, r) => (l.word > r.word ? 1 : -1))
      .reduce(
        (all, now) => {
          if (now.word.startsWith(int.value)) all.start.push(now)
          else if (now.word.endsWith(int.value)) all.end.push(now)
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
        out.value.push(...decodeUnicode(words))
        isMore.value = more
        m.value += n.value
      })
  }
</script>

<template>
  {{ out.length }}
  <button @click="start">start {{ isMore ? 'more' : '' }}</button>
  <input type="text" v-model="int" />
  <ul>
    <li v-for="word of OUT.start">{{ word.word }}{{ word.definition }}</li>
    ---
    <li v-for="word of OUT.end">{{ word.word }}{{ word.definition }}</li>
    ---
    <li v-for="word of OUT.else">{{ word.word }}{{ word.definition }}</li>
  </ul>
</template>

<style scoped>
  li {
    list-style: none;
  }
</style>
