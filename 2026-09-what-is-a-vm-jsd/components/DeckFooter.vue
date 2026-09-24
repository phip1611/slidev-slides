<!-- Persistent footer with chapter, progress, and slide-count navigation. -->
<script setup lang="ts">
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import { useNav } from '@slidev/client'

const { currentPage, total, slides } = useNav()
const chromeHidden = ref(false)
let observer: MutationObserver | undefined

const hidden = computed(() => chromeHidden.value)
const progress = computed(() => `${(currentPage.value / total.value) * 100}%`)

function updateChrome() {
  const current = document.querySelector(
    `[data-slidev-no="${currentPage.value}"]`,
  )
  chromeHidden.value = Boolean(
    current?.classList.contains('no-chrome') || current?.querySelector('.no-chrome'),
  )
}

/**
 * The chapter label of the current slide: walk the slides upwards to the
 * nearest `layout: chapter` slide, so every slide (figures included) shows the
 * chapter it belongs to.
 *
 * That chapter slide may name itself in its frontmatter:
 *
 *   ---
 *   layout: chapter
 *   chapter: Introduction
 *   ---
 *
 * Without such a name we fall back to the number of its heading ("Chapter 03").
 */
const chapter = computed(() => {
  const DEFAULT_CHAPTER: string = ''
  for (let i = currentPage.value - 1; i >= 0; i--) {
    const slide = slides.value[i]?.meta?.slide
    if (slide?.frontmatter?.layout !== 'chapter')
      continue
    if (slide.frontmatter.chapter)
      return String(slide.frontmatter.chapter)
    const number = String(slide.title ?? '').match(/^\s*(\d+)/)
    return number ? `Chapter ${number[1].padStart(2, '0')}` : DEFAULT_CHAPTER
  }
  return DEFAULT_CHAPTER
})

watch(currentPage, () => nextTick(updateChrome), { flush: 'post' })

onMounted(() => {
  updateChrome()
  observer = new MutationObserver(updateChrome)
  observer.observe(document.body, { childList: true, subtree: true })
})

onUnmounted(() => observer?.disconnect())
</script>

<template>
  <footer v-if="!hidden" class="deck-footer">
    <span class="chapter-label">{{ chapter }}</span>
    <span class="progress-track"><span :style="{ width: progress }" /></span>
    <span class="slide-number">{{ currentPage }} / {{ total }}</span>
  </footer>
</template>

<style>
.deck-footer {
  align-items: center;
  bottom: 0.45rem;
  color: var(--muted);
  display: flex;
  font-family: 'Source Code Pro', monospace;
  font-size: 0.55rem;
  gap: 0.7rem;
  left: 3.6rem;
  position: absolute;
  pointer-events: none;
  right: 3.6rem;
  text-transform: uppercase;
  z-index: 10;
}

.chapter-label {
  color: var(--red);
  font-weight: 600;
  letter-spacing: 0.08em;
  min-width: 7.5rem;
}

.progress-track {
  background: var(--line);
  display: block;
  flex: 1;
  height: 0.14rem;
}

.progress-track span {
  background: var(--red);
  display: block;
  height: 100%;
  transition: width 200ms ease;
}

.slide-number {
  min-width: 3.8rem;
  text-align: right;
}
</style>
