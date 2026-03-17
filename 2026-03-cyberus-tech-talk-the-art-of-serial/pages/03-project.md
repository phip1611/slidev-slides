---
layout: default
---

# 2. The Project


<SlideIndicator />


---
layout: default
---

# Idea and Final Product

<v-clicks depth="3">

- Simple chat with two participants
  - `LOCAL`: My computer (UEFI application executed by UEFI firmware)
    - UEFI console reads input from USB keyboard
    - UEFI console prints characters to my monitor
  - `REMOTE`: My laptop connected via serial (running normal NixOS)

</v-clicks>

---
layout: default
---

# Rough Timeline

<v-clicks depth="2">

- I've created my own mini operating system as UEFI application
- Started by running that in a VM
- UEFI Console:
  -
    - Fairly easy
- I've wrote a new rust library for interfacing UART 16550 devices
  - Complete rewrite of the popular `uart_16550` crate
  - Very close to replace the original crate
  - Was quite some work
  - Was necessary to work on real hardware + to satisfy my high coding standards

</v-clicks>

<SlideIndicator />

