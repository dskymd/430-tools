<script setup lang="ts">
// import { ref } from 'vue'

import FileNameForm from './FileNameForm.vue'

// defineProps<{ msg: string }>()
// const count = ref(0)

const updateCode = (val: string) => {
  console.log(val)
}
</script>

<template>
  <p>ファイル一覧から商品IDごとに</p>
  <FileNameForm @update:code="updateCode" />
</template>

<style scoped></style>
