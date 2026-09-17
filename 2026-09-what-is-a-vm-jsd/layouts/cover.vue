<!-- Full-slide cover layout for opening and closing slides. -->
<template>
  <div class="cover-layout no-chrome slidev-layout">
    <div class="cover-content">
      <slot />
    </div>
    <footer v-if="$slots['bottom-left'] || $slots['bottom-right']" class="cover-meta">
      <div>
        <slot name="bottom-left" />
      </div>
      <div class="cover-meta-right">
        <slot name="bottom-right" />
      </div>
    </footer>
  </div>
</template>
