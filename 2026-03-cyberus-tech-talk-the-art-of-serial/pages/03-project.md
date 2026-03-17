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
- Run everything on real hardware: ⚡ 💣
- I've written a new rust library for interfacing UART 16550 devices
  - Complete rewrite of the popular `uart_16550` crate
  - Implemented `EFI_SERIAL_IO_PROTOCOL` backed by my driver
  - Bought more hardware ...

</v-clicks>

<SlideIndicator />


---
layout: default
---

# Quick Demo (Recording: Running in VM)

<SlidevVideo v-click autoplay controls>
  <!-- Anything that can go in an HTML video element. -->
  <source src="/videos/screencast_demo.webm" type="video/webm" />
</SlidevVideo>


---
layout: default
---

# Software Challenges

<v-clicks depth="3">

- Handling text in terminal handling was surprisingly challenging
  - Control characters: Newlines
    - UEFI console input: `\r`
    - Terminal input: backspace key: `\r`
    - Default newline character in UNIX, Linux, Rust strings: `\n`
  - Control Characters: Backspace (Revert Last Keystroke):
    - UEFI console input: backspace key: `0x8 / <BS>`
    - Terminal input: backspace key: `0x7f / <DEL>`

</v-clicks>

<SlideIndicator />


---
layout: default
---

# Software Challenges

<v-clicks>

- To "draw" deleted characters on the terminal (connected via serial), \
  I have to transform a `<DEL>` character:
- In short: move cursor left, overwrite with `<SPACE>`, move cursor left

</v-clicks>

<v-click>

````md magic-move
```rust {0|1}{lines:true}
fn normalize_backspaces(&self, string: String) -> String {}
```
```rust {0|4|5-6|8|9}{lines:true}
const BACKSPACE: char = '\x08';
const DELETE: char = '\x7f';

fn normalize_backspaces(&self, string: String) -> String {
    // move cursor left, overwrite with `<SPACE>`, move cursor left
    let bs_sequence = format!("{BACKSPACE} {BACKSPACE}");
    string
        .replace(DELETE, BACKSPACE)
        .replace(BACKSPACE, &bs_sequence)
}
```
````

</v-click>

<v-clicks>

- For the UEFI console, I can simply print a single `<BS>` character

</v-clicks>

<SlideIndicator />


---
layout: default
---

# Software Challenges

<v-clicks>

- UEFIs Console and the Serial Device: \
  UEFI Driver owns multiple input sources (USB keyboards, serial device)
- Whenever I wanted to read from the serial device, someone else drained it ...

</v-clicks>

<v-click>

```rust {0|1|8,10|9|2|4|5|6-7}{lines:true}
let serial_handles: Vec<Handle> = find_serial_handles()?;
// Disconnect any serial handle from the console device:
//
// - UEFI console won't read its input from that device
// - UEFI console won't write to the screen AND the serial device
// - We have exclusive device control, which we need to install our own
//   protocol implementation
for handle in &serial_handles {
    boot::disconnect_controller(*handle, None, None)?;
}
```

</v-click>

<SlideIndicator />


---
layout: default
---

# Software Challenges

<v-clicks>

- UEFI reported no serial handle when I booted this on my desktop PC: \
  Its UEFI firmware doesn't install any handle with `EFI_SERIAL_IO_PROTOCOL`*
- I had to implement and install my own UEFI protocol implementation
- I needed a working UART 16550 driver
- `uart_16550`, well-established library of the ecosystem, didn't work

</v-clicks>


<!-- footnote -->
<div v-click="1" position="absolute" left="2ch" bottom="2ch" text="sm">
* A UEFI protocols are optional units of functionality that can be there (optional)
</div>


<SlideIndicator />


---
layout: default
transition: undefined
---

# Hardware

- I thought I had all the hardware I need



<SlideIndicator />


---
layout: none
transition: undefined
---

<img src="/images/cover_blur1.png" />

---
layout: none
transition: undefined
---

<img src="/images/cover_blur2.png" />

---
layout: none
transition: slide-up
---

<img src="/images/cover_blur3.png" />


---
layout: none
---

<img src="/images/hardware-adapters-close-up.png" />

<Arrow v-click :x1="100" :y1="100" :x2="250" :y2="185" color="red" />
<Arrow v-click :x1="400" :y1="230" :x2="250" :y2="300" color="red" />
<Arrow v-click :x1="400" :y1="100" :x2="550" :y2="230" color="red" />


---
layout: default
---

# Recap

<v-clicks depth="2">

- Fun project and I've learned a lot
- Many side-quests along the way
- Learning about the UART 16550 internals + writing a driver was the most fun
- Implementing a serial driver for UEFI and using that on my desktop PC was quite fun as well
- Figuring out how to handle strings and special control chars with terminals
  was the least pleasant thing
  - when to preserve which control character in
    the string
  - when to replace it, ...

</v-clicks>


---
layout: default
---

# Recap

<v-clicks>

- Rewrite of `uart_16550` crate: \
  <https://github.com/rust-osdev/uart_16550/pull/41>
- UEFI Serial Chat project:
  - Incomplete and a few subtle bugs
  - Not the best code - but it works!
  - https://github.com/phip1611/uefi-serial-chat


</v-clicks>



<SlideIndicator />
