<template>
  <qrcode-vue
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

const props = defineProps<{
  value: string
  size?: number
}>()
</script>
