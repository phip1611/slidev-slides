<!--
  A single footnote; use inside <Footnotes>. Works with `v-click`.
  `invisible` keeps its space, so build-up slides can reserve later footnotes
  and the earlier ones do not move.
-->
<script setup lang="ts">
defineProps<{ n: string | number, invisible?: boolean }>()
</script>

<template>
  <div class="footnote" :class="{ 'footnote-invisible': invisible }">
    <sup>{{ n }}</sup> <slot />
  </div>
</template>

<style>
.footnote-invisible {
  visibility: hidden;
}
</style>
