<script setup>
  import { computed, ref } from 'vue'
  const r = ref(0)
  const r2 = ref(0)
  const c = computed(() => {
    r2.value++
    return r.value
  })
</script>

<template>r2 = {{ r2 }}</template>
