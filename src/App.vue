<script setup>
debugger
import RegDict from './components/RegDict.vue'
import T from './components/T.vue'
import { reactive, ref, effect, watchEffect, watch } from 'vue'

const v1 = reactive(ref([3, 4, 5]))
console.log(1, v1)
const v2 = v1.ll
console.log(2, v2)

const r = ref(0)
reactive(r)
reactive({ r })

const arr = ref([0, { x: 1 }])
let arr2 = reactive([0])
function handle1() {
  // arr.value.push(1)
  // arr.value[0]++
  arr.value[1].x++
  // arr.value = []
}
function handle2() {
  // arr2.push(1)
  // arr2[0]++
  // arr2 = []
}

//被动收集依赖
effect(() => {
  'effect2'.ll
  JSON.stringify(arr)
})

//主动收集依赖
watch(
  arr,
  () => {
    'watch'.ll
    JSON.stringify(arr)
  },
  { immediate: true, deep: true }
)
</script>

<template>
  {{ arr }}
  <button @click="handle1">button</button>
  <button @click="handle2">button</button>
  <!--  <T :data="arr" />-->
  <!--  <RegDict />-->
</template>

<style></style>
