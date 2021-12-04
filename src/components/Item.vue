<script setup>
  defineProps({
    words: Array,
  })
</script>

<template>
  <ul>
    <li v-for="{ word, definition } of words">
      <span>
        <span>{{ word.l }}</span>
        <span>{{ word.m }}</span>
        <span>{{ word.r }}</span>
      </span>
      <span>{{ definition }}</span>
    </li>
  </ul>
</template>

<style scoped>
  ul {
    padding: 0;
  }
  li {
    list-style: none;
    display: flex;
    justify-content: space-between;
    align-items: baseline;
  }
  li span:nth-child(1) {
    width: 130px;
  }
  li span:nth-child(2) {
    flex: 1;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }
  li span span:nth-child(2) {
    color: #0088de;
  }
</style>
