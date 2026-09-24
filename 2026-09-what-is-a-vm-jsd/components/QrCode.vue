<template>
  <a v-if="isLink" :href="props.value" target="_blank"><qrcode-vue
    :value="props.value"
    :level="'L'"
    :size="props.size ?? 100"
    :render-as="'svg'"
    :background="'#ffffff'"
    :foreground="'#000000'"
  /></a>
  <qrcode-vue v-else
    :value="props.value"
    :level="'L'"
    :size="props.size ?? 100"
    :render-as="'svg'"
    :background="'#ffffff'"
    :foreground="'#000000'"
  />
</template>
<script setup lang="ts">
import QrcodeVue from 'qrcode.vue'
import {computed} from "vue";

const props = defineProps<{
  value: string
  size?: number
}>()

const isLink = computed<boolean>(() => {
  return props.value.startsWith("http://") || props.value.startsWith("https://")
})
</script>
