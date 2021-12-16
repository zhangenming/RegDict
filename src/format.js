<script setup>
import RegDict from './components/RegDict.vue'
import T from './components/T.vue'
import { reactive, ref, effect, watchEffect } from 'vue'

const arr2 = ref([]) // ref(reactive([]))
// const arr4 = ref(reactive([]))
const arr3 = reactive([])
const arr4 = reactive(ref([])) //reactive(ref(reactive([])))
function handle1() {
  arr.push(Math.random())
}

console.log(23)
</script>

<template>
  <button @click="handle1">button</button>
  {{ arr }}
</template>

<style></style>

