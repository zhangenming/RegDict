<script setup>
import { computed, onUpdated, ref, toRefs } from 'vue'
defineProps({
  data: Array,
})

const { data } = toRefs(__props)

const c = computed(() => data.value[0] * 2)

// const selected = ref(selected)
//
// watch(selected, (selection, prevSelection) => {
//    /* ... */
// })
</script>

<template>
  <!--  {{ data[0].ll }}&#45;&#45;{{ c.ll }}&#45;&#45;{{-->
  <!--    (() => {-->
  <!--      // c.ll-->
  <!--      debugger-->
  <!--    })()-->
  <!--  }}-->
</template>
