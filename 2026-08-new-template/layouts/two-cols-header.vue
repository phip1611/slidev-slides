<!-- Equal-width content columns with a generous built-in gutter. -->
<template>
  <div class="slidev-layout two-cols-header">
    <div class="col-header">
      <slot />
    </div>
    <div class="col-left">
      <slot name="left" />
    </div>
    <div class="col-right">
      <slot name="right" />
    </div>
  </div>
</template>

<style scoped>
.two-cols-header {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  grid-template-rows: auto minmax(0, 1fr);
}

.col-header {
  grid-column: 1 / -1;
}
</style>
