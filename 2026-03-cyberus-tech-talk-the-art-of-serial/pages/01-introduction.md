---
class: text-center
layout: cover
background: ./images/cover.png
---

# The (U)Art of Serial -  <br/>&nbsp;<br/>&nbsp; <br/>&nbsp; A 16550 Deep Dive

<div position="absolute" left="2ch" bottom="2ch" text="sm">
  Cyberus Tech Talk Series, 2026-03-18
</div>
<div position="absolute" right="2ch" bottom="2ch" text="sm">
  Philipp Schuster
</div>

---
layout: default
---

# 1. Introduction


<SlideIndicator />

---
layout: default
transition: undefined
---

# How Did We Get Here?

- Christmas 2025, my nephews got a new PC (updated mainboard)
- That mainboard has a COM1 / serial port
- I always wanted to get some hands-on experience with a physical serial port

TODO photo com1 port


<SlideIndicator />

---
layout: default
transition: slide-up
---

# How Did We Get Here?

- Might be a cool demo to show my nephews what cool low-level stuff we at work
  can do
- I had a project "Zwischen den Jahren" \
  The time between Christmas and New Year's Eve)


<SlideIndicator />

---
layout: default
---

# What I had At Home

- A x86 desktop PC with a COM1 port on its mainboard
- A COM1 pin-out to RS-232 cable
- A USB serial cable to RS-232
- An Idea!

<SlideIndicator />

---
layout: image
image: ./images/cover_blur1.png
---

---
layout: default
---

# The Idea

<v-clicks depth="2">

- A chat application
- Computer is primary chat participant (`LOCAL`)
- Remote connected via serial is remote chat participant (`REMOTE`)
- Let's bring some more OS development into the game
  - Don't use Windows or an existing Linux distribution on the PC
  - Write my own mini OS using `uefi-rs`* and Rust

</v-clicks>

<div v-click="6" position="absolute" left="2ch" bottom="2ch" text="sm">
*High-level from a low-level perspective. Not Python- or Java-like high-level.
</div>

<SlideIndicator />

---
layout: default
---

# The Struggles

_(Accumulated During My Work on This)_

<v-clicks depth="2">

- I had two male RS-232 cables --> didn't match
- UEFI console took control over `serial` device from me
- `uart_16550` crate didn't work on real hardware
- Handling line breaks, clearing the terminal, redrawing the screen, ...
- ...

</v-clicks>

<SlideIndicator />

