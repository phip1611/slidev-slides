# New Slidev Template Playground

This deck is a living, Markdown-first pattern catalog for the local Slidev
template. Copy it when starting a new talk; it is not a finished talk itself.

```sh
pnpm install
pnpm run dev
```

Normal slides use a numbered H1 (`# 2.1 A focused idea`). The first heading in
each chapter uses a whole number (`# 2. Code as a visual`). The footer shows
the chapter, progress, and current slide number.

The footer resolves the chapter by walking back to the nearest `layout:
chapter` slide, so full-size figures and other slides without a heading keep
their chapter label. A chapter slide may name itself; otherwise the number of
its heading is used ("Chapter 02"):

```yaml
---
layout: chapter
chapter: Visual grammar
---
```

A slide with `class: no-chrome` hides the footer entirely.

Use `default` for headings, text, lists, code fences, and images. Use
`two-cols-header` only when needed, with Slidev's `::left::` and `::right::`
slots. The `cover` and `chapter` layouts are reserved for opening and divider
slides. Keep each slide focused on one idea.

Two helpers are available on every slide: `<QrCode value="https://..."
:size="110" />` renders a QR code (wrap several of them in a `.qr-codes`
container, see `pages/06-closing.md`), and `class="corner-logo"` on an `<img>`
pins a logo to the top right corner.
