<script setup>
import { ref } from 'vue'

const { data, int } = defineProps({
  name: String,
  data: Array,
  int: String,
  selects: Array,
  refresh: Array,
})
const outLength = ref(0)
const outLength2 = ref(0)

const words_ = []

function generate(arr, key) {
  outLength.value = arr.length
  outLength2.value = [...new Set(arr.map(e => e.word))].length

  return arr
    .map?.(old => {
      const idx = old.word.indexOf(key)
      return {
        //new
        l: old.word.slice(0, idx),
        m: key,
        r: old.word.slice(idx + key.length),
        //old
        ...old,
      }
    })
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
}
let alls = generate(data, int.replaceAll('.', '').replaceAll('*', ''))
</script>

<template>
  <div class="item">
    <span>{{ refresh }}</span>
    <button
      @click="$emit('select', name)"
      :class="{ selected: selects.includes(name) }"
    >
      select
    </button>
    <button @click="$emit('del', name)">del</button>
    {{ name }}: {{ outLength }}({{ outLength2 }})
    <ul v-for="(words, type) of alls">
      <li>{{ type }}</li>
      <li v-for="{ l, m, r, definition, word } of words">
        {{
          (() => {
            words_.push(word)
          })()
        }}
        <span>
          <span>{{ l }}</span>
          <span>{{ m }}</span>
          <span>{{ r }}</span>
        </span>
        <!-- <span>{{ definition }}</span> -->
      </li>
    </ul>
  </div>
</template>

<style scoped>
ul {
  padding: 10px 0;
  margin: 0;
  border-bottom: 5px solid #aaa;
}
ul:last-child {
  border-bottom: none;
}
li {
  list-style: none;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 10px;

  width: 100px;
}
li:nth-child(even) {
  background: #eee;
}
li > span:nth-child(1) {
  width: v-bind(outMax);
  font-family: monospace;
}
li > span:nth-child(2) {
  flex: 1;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  font-size: 12px;
}
li span span:nth-child(2) {
  color: #0088de;
}
.selected {
  background: #eae;
}
</style>
