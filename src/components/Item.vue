<script setup>
import { computed, ref, toRefs } from 'vue'

const props = defineProps({
  name: String,
  data: Array,
  int: String,
  selects: Array,
})
const { data, int } = toRefs(props)

const outLength = data.value.length
const outLength2 = computed(
  () => [...new Set(data.value.map(e => e.word))].length
)
const alls = data.value
  .map(old => {
    const idx = old.word.indexOf(int.value)
    return {
      //new
      l: old.word.slice(0, idx),
      m: int.value,
      r: old.word.slice(idx + int.value.length),
      //old
      ...old,
    }
  })
  .reduce(
    (reduce, now) => {
      if (now.word === int) reduce.self.push(now)
      else if (now.word.startsWith(int)) reduce.start.push(now)
      else if (now.word.endsWith(int)) reduce.end.push(now)
      else reduce.mid.push(now)
      return reduce
    },
    { self: [], start: [], end: [], mid: [] }
  )

const words_ = []
</script>

<template>
  <div class="item">
    <button
      @click="$emit('select', name)"
      :class="{ selected: selects?.includes(name) }"
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
