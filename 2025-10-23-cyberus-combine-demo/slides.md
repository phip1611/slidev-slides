---
# https://sli.dev/custom/
# Meta
author: Philipp Schuster <phip1611@gmail.com>
info: |
  Slidev demo for Cyberus Combine.
title: Welcome to Slidev

# Generic Settings
addons:
aspectRatio: 16/9
background: https://cover.sli.dev
canvasWidth: 780
colorSchema: light
drawings:
  persist: false
mdc: true
selectable: true
theme: seriph

# For next slide (cover slide)
class: text-center
layout: cover
transition: slide-up
---

<h1 class="main-h1">Slidev Demo</h1>

A cool new way to generate slides.

## Cyberus Combine, 2025-10-23<br>A brief 60-Minute Introduction 😉

<!-- ^insider joke -->

<div @click="$slidev.nav.next" class="mt-12 py-1" hover:bg="white op-10">
  Press Space for next page <carbon:arrow-right />
</div>

<!--
The last comment block of each slide will be treated as slide notes. It will be visible and editable in Presenter Mode along with the slide. [Read more in the docs](https://sli.dev/guide/syntax.html#notes)
-->

---
title: Why am I showing you this?
---

# {{ $frontmatter.title }}

<v-clicks>

- Let's assume I want to show some code in a talk
- Ignore the specifics, just pretend this is <span v-mark.underline="3">groundbreaking</span> <span v-mark.circle="4">new stuff</span>:

</v-clicks>

<v-click>

````md magic-move
```rust {0|1|4}{lines:true}
struct Debugcon;
impl Debugcon {
    /// I/O port of QEMUs debugcon device
    const IO_PORT: u16 = 0xe9;
}
```
```rust {6}{lines:true}
struct Debugcon;
impl Debugcon {
    /// I/O port of QEMUs debugcon device
    const IO_PORT: u16 = 0xe9;

    fn write_byte(byte: u8) {}
}
```
```rust {6,8|7}{lines:true}
struct Debugcon;
impl Debugcon {
    /// I/O port of QEMUs debugcon device
    const IO_PORT: u16 = 0xe9;

    fn write_byte(byte: u8) { unsafe {
        core::arch::asm!()
    }}
}
```
```rust {7|7-10,13|6,14}{lines:true}
struct Debugcon;
impl Debugcon {
    /// I/O port of QEMUs debugcon device
    const IO_PORT: u16 = 0xe9;

    fn write_byte(byte: u8) { unsafe {
        core::arch::asm!(
            "out %al, %dx",
            ("al") byte,
            ("dx") Self::IO_PORT,
            options(att_syntax, nomem, nostack, preserves_flags)
        )
    }}
}
```
````

</v-click>

---
title: What is Slidev? Awesome tooling!
---

# {{ $frontmatter.title }}

Slidev is a slides maker and presenter designed <span v-mark.underline.red>for developers</span>, consist of the following features

<v-clicks>

- 📝 **Text-based** - focus on the content with Markdown, and then style them later
- 🎨 **Themable** - themes can be shared and re-used as npm packages
- 🧑‍💻 **Developer Friendly** - code highlighting, live coding with autocompletion
- 🤹 **Interactive** - embed Vue components to enhance your expressions
- 🎥 **Recording** - built-in recording and camera view
- 📤 **Portable** - export to PDF, PPTX, PNGs, or even a hostable Single Page Application/website
- 🛠 **Hackable** - virtually anything that's possible on a webpage is possible in Slidev

</v-clicks>

<!--
You can have `style` tag in markdown to override the style for the current page.
Learn more: https://sli.dev/features/slide-scope-style
-->

<!--
Here is another comment.
-->

---
title: What is Slidev? Awesome tooling!
---

# {{ $frontmatter.title }}

<v-clicks depth="2">

- Combines modern state-of-the-art web tooling to create slides
  - UnoCSS, Vite, NodeJS, Vue
- Suited for simple presentations ... but also
- Much more powerful than PowerPoint (interactive, live 3D rendering on GPU, ...)
  - [Showcase 1](https://kareimgazer.github.io/py-intro/)
  - [Showcase 2](https://talk-2025-09-23-prag-vue.vercel.app/4?clicks=4)

</v-clicks>

---
title: Why should We Care?
---

# {{ $frontmatter.title }}

<v-clicks depth="2">

- If we go to conferences and want to present code with stunning slides \
  -> Slidev might be a cool option
- Let's be honest: It is never just about the content, but also the way
  you present it
- You write cleartext (Markdown) -> Git versionable
  - Individual Slides are partially copy & pasteable
- Web developers (e.g. Luke and I) should be able to create a Cyberus theme/template
  in a 2-day workshop

</v-clicks>

---
title: Who Can/Could Use Slidev?
---

# {{ $frontmatter.title }}

Being able to create nice slides:

|                                                     | No Cyberus Template | With Cyberus Template |
|-----------------------------------------------------|---------------------|-----------------------|
| No Web Dev Experience<br/>(Management, Backoffice)  | ☹️                  | 🤔                    |
| Light/Medium Web Dev Experience                     | 🤔                  | 😊                    |
| Advanced Web Dev Experience                         | 😊                  | 🥳                    |


---
title: To get Started (From Scratch)
---

# {{ $frontmatter.title }}

<v-clicks depth="2">

- Basic HTML & CSS Knowledge
- Read Slidev documentation
  - Layouts, Components, Themes, Configuration
- Read UnoCSS documentation
- Basic Markdown skills
- Vue web components using

</v-clicks>


---
title: To get Started (With Future Cyberus Template)
---

# {{ $frontmatter.title }}

<v-clicks depth="2">

- Assuming Luke and I create a template in a Hackathon<br>(or whoever is familiar with Vue, UnoCSS, etc.)
- Documentation will be inside there and most things should be achievable
  using just Markdown while still looking fantastic

</v-clicks>

---
title: Try it Out / Look at the Slides
layout: two-cols-header
---

# {{ $frontmatter.title }}

::left::

<QrCode size="180" value="https://cyberus-combine-2025-10.slides.phip1611.dev"/>

<https://cyberus-combine-2025-10.slides.phip1611.de>

::right::

<QrCode size="180" value="https://eurorust-2025.slides.phip1611.dev"/>

<https://eurorust-2025.slides.phip1611.dev>
