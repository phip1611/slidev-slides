<!-- Bottom-anchored stack of <Footnote> entries, so they need no manual offsets. -->
<template>
  <div class="footnotes">
    <slot />
  </div>
</template>

<style>
.footnotes {
  bottom: 4ch;
  /* `layout: image` sets white text for its background image */
  color: var(--ink);
  display: flex;
  flex-direction: column;
  font-size: 0.875rem;
  left: 7ch;
  line-height: 1.25rem;
  position: absolute;
  right: 7ch;
}
</style>
