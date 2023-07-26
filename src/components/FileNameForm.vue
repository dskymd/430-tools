<script setup lang="ts">
import { computed, ref } from 'vue'
import { renderToWebStream } from 'vue/server-renderer';

// defineProps<{ msg: string }>()
const emit = defineEmits(['update:code'])

type Item = {
  id: string
  files: string[]
}
const year = new Date().getFullYear().toString()
const yy = year.substring(2, 4)
const mm = (new Date().getMonth() + 1).toString().padStart(2, '0')

const inputSeasonCode = ref(`FTY-${yy}-`)
const inputFilePath = ref(
  `https://t430.com/_cms/wp-content/uploads/${year}/${mm}/`,
)
const inputFileName = ref(`
23_153__N_3B_DOWN_JACKET_BLK_1_cover.jpg
23_153_N_3B_DOWN_JACKET_BLK_1.jpg
23_153_N_3B_DOWN_JACKET_BLK_2.jpg
23_153_N_3B_DOWN_JACKET_CYT_1.jpg
23_153_N_3B_DOWN_JACKET_CYT_2.jpg
23_153_N_3B_DOWN_JACKET_RED_1.jpg
23_153_N_3B_DOWN_JACKET_RED_2.jpg
23_153_N_3B_DOWN_JACKET_SAGE_1.jpg
23_153_N_3B_DOWN_JACKET_SAGE_2.jpg
23_154__3LT_DOWN_JACKET_CYT_1_cover.jpg
23_154_3LT_DOWN_JACKET_BLK_1.jpg
23_154_3LT_DOWN_JACKET_BLK_2.jpg
23_154_3LT_DOWN_JACKET_CYT_1.jpg
23_154_3LT_DOWN_JACKET_CYT_2.jpg
23_154_3LT_DOWN_JACKET_CYT_10.jpg
23_154_3LT_DOWN_JACKET_CYT_11.jpg
23_154_3LT_DOWN_JACKET_NVY_1.jpg
23_154_3LT_DOWN_JACKET_NVY_2.jpg
`.trim())

const fileNameArray = computed(() => inputFileName.value.trim().split('\n'))

const items = computed<Item[]>(() => {
  const result: Item[] = []

  let tmpId = ''
  let files: string[] = []

  for (let i in fileNameArray.value) {
    const id = fileNameArray.value[i].slice(3, 6) // 23-001_XXXXXX.jpg -> 001

    if (id === tmpId) {
      // 前回と同じIDのファイル

      files.push(`${inputFilePath.value}${fileNameArray.value[i]}`.trim())
    } else {
      // 新しいIDのファイル

      // 前のitemをresultに追加しておく
      if (files.length > 0) result.push({ id: tmpId, files })

      // 新しくIDを設定、初期化
      tmpId = id
      files = []

      files.push(`${inputFilePath.value}${fileNameArray.value[i]}`.trim())
    }
  }
  if (files.length > 0) result.push({ id: tmpId, files })

  // console.log(result)
  return result
})

const idListText = computed(() => {
  const ids = items.value.map(({ id }) => `${inputSeasonCode.value}${id}`)
  return ids.join('\n')
})

const idListTextLower = computed(() => idListText.value.toLocaleLowerCase())

const fileListText = computed(() => {

  const itemsWithComma = items.value.map(({ files }) => files.join(','))
  const itemsWithQuots = itemsWithComma.map((row: string) => `"${row}"`)// 各要素に "" 追加
  return itemsWithQuots.join('\n') // 各要素に改行コードで文字列に
})

const updateCode = (val: Event) => {
  // console.log(val)
  emit('update:code', (val.target as HTMLInputElement).value)
}
</script>

<template>
  <section class="p-8 mb-8 bg-slate-100">
    <h2 class="text-lg font-bold text-left mb-6">Input</h2>
    <div class="grid grid-cols-2 gap-12 mb-12">
      <div>
        <input type="text" v-model="inputSeasonCode" @change="updateCode" class="border-2 p-2 w-full" />
      </div>
      <div>
        <input type="text" v-model="inputFilePath" class="border-2 p-2 w-full" />
      </div>
    </div>

    <div class="grid grid-cols-1 gap-12 mb-12">
      <div>
        <textarea v-model="inputFileName" class="border-2 p-2 w-full h-96"></textarea>
      </div>
    </div>
  </section>

  <section class="p-8 mb-8 bg-slate-100">

    <h2 class="text-lg font-bold text-left mb-6">Result</h2>

    <div class="grid grid-cols-1 gap-12 mb-12">
      <textarea readonly class="border-2 p-2 h-96 text-xs" v-model="fileListText"></textarea>
    </div>

    <h3 class="text-md font-bold text-left mb-4">ID</h3>
    <div class="grid grid-cols-2 gap-12 mb-12">
      <textarea readonly class="border-2 p-2 h-48" v-model="idListText"></textarea>
      <textarea readonly class="border-2 p-2 h-48" v-model="idListTextLower"></textarea>
    </div>
  </section>
</template>

<style scoped></style>
