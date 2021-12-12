<script setup>
import { computed, ref } from 'vue'
const r = ref([])
</script>

<template>
  {{ Math.random() }}
  {{ r.length }}
  <button @click="() => r.push('')">T</button>
</template>
