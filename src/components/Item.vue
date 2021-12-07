<script setup>
   defineProps({
    all: Array,
    outMax: String,
  })
</script>

<template>
  <ul v-for="words of all" v-if="outMax !== '20px'">
    <li v-for="{ l, m, r, definition } of words">
      <span>
        <span>{{ l }}</span>
        <span>{{ m }}</span>
        <span>{{ r }}</span>
      </span>
      <span>{{ definition }}</span>
    </li>
  </ul>
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
</style>
