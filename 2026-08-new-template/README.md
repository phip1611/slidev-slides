# New Slidev Template Playground

This deck is a living, Markdown-first pattern catalog for the local Slidev
template. Copy it when starting a new talk; it is not a finished talk itself.

```sh
pnpm install
pnpm run dev
```

Normal slides use a numbered H1 (`# 2.1 A focused idea`). The first heading in
each chapter uses a whole number (`# 2. Code as a visual`). The footer derives
the current chapter from this convention and shows the chapter, progress, and
current slide number.

Use `default` for headings, text, lists, code fences, and images. Use
`two-cols-header` only when needed, with Slidev's `::left::` and `::right::`
slots. The `cover` and `chapter` layouts are reserved for opening and divider
slides. Keep each slide focused on one idea.
