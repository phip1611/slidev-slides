---
layout: default
---

# 3. The Project


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
    - Read data from serial device
  - `REMOTE`: My laptop connected via USB serial (running normal NixOS)
    - Just sends text input
    - Output controlled my `REMOTE` (master)
    - Displays only what `LOCAL` instructs it to display

</v-clicks>

---
layout: none
---

<img src="/images/demo_setup.png" />


<Arrow v-click :x1="550" :y1="280" :x2="610" :y2="180" color="red" />
<Arrow v-click="1" :x1="550" :y1="280" :x2="540" :y2="100" color="red" />

<Arrow v-click :x1="500" :y1="280" :x2="410" :y2="345" color="red" />

<Arrow v-click :x1="480" :y1="265" :x2="280" :y2="125" color="red" />

<Arrow v-click :x1="350" :y1="280" :x2="180" :y2="240" color="red" />
<Arrow v-click="4" :x1="350" :y1="280" :x2="280" :y2="430" color="red" />


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

# Rough Timeline

<v-clicks depth="2">

- I've created my own mini operating system as UEFI application
- Started by running that in a VM
- Run everything on real hardware: ⚡ 💣
- Bought more hardware ...
- I've written a new rust library for interfacing UART 16550 devices
  - Complete rewrite of the popular `uart_16550` crate
- Implemented `EFI_SERIAL_IO_PROTOCOL` backed by my UART 16550 driver
  - Necessary UEFI glue code

</v-clicks>

<SlideIndicator />

---
layout: default
---

# Software Challenges

<v-clicks depth="3">

- Handling text in terminal was surprisingly challenging
  - Control characters: Newlines
    - UEFI console input: enter key: `\r`
    - Terminal input: enter key: `\r`
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
fn normalize_backspaces(string: String) -> String {}
```
```rust {0|4|5-6|8|9}{lines:true}
const BACKSPACE: char = '\x08';
const DELETE: char = '\x7f';

fn normalize_backspaces(string: String) -> String {
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
// Disconnect any serial handle from the UEFI console controller:
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



---
layout: default
---

# The Chat Loop


````md magic-move
```rust {0|1|7|15}{lines: true}
pub fn start_chat(handles: &[Handle]) -> anyhow::Result<()> {
    let mut console_backend = ConsoleBackend::new()?;
    let handle = actions::select_serial_handle(&mut console_backend, handles)?;

    let mut serial_backend = SerialBackend::new(handle)?;

    /* Welcome Message */

    /* user name selection */

    let mut message_queue = VecDeque::new();
    let mut need_redraw_message_history = true;

    // Actual chat
    loop { }

    Ok(())
}
```
```rust {0|4-8}{lines: true}
pub fn start_chat(handles: &[Handle]) -> anyhow::Result<()> {
    /* ... */
    // Welcome message
    {
        actions::broadcast(
            "Welcome to UEFI Serial Chat\n",
            &mut [&mut console_backend, &mut serial_backend],
        )?;
    }
    /* ... */

    Ok(())
}
```
```rust {0|4-7|9-11}{lines: true}
pub fn start_chat(handles: &[Handle]) -> anyhow::Result<()> {
    /* ... */
    loop {
        if need_redraw_message_history {
            console_backend.clear_screen()?;
            serial_backend.clear_screen()?;
        }

        while message_queue.len() > 10 {
            message_queue.pop_front();
        }
    }
    Ok(())
}
```
```rust {0|5,13|6-12|15-17}{lines: true}
pub fn start_chat(handles: &[Handle]) -> anyhow::Result<()> {
    /* ... */
    loop {
        /* ... */
        if need_redraw_message_history {
            for (participant, msg) in &message_queue {
                /* ... */
                actions::broadcast(
                    &format!("[{username}]: {msg}\n"),
                    &mut [&mut console_backend, &mut serial_backend],
                )?;
            }
        }

        if need_redraw_message_history {
            need_redraw_message_history = false;
        }
        /* ... */
    }
    Ok(())
}
```
```rust {0|5|7}{lines: true}
pub fn start_chat(handles: &[Handle]) -> anyhow::Result<()> {
    /* ... */
    loop {
        /* ... */
        let input = console_backend.poll()?.to_string();
        /* ... */
        let input = serial_backend.poll()?.to_string();
        /* ... */

        /* ... */
    }
    Ok(())
}
```
```rust {0|5-8|10-13}{lines: true}
pub fn start_chat(handles: &[Handle]) -> anyhow::Result<()> {
    /* ... */
    loop {
        /* ... */
        if let Some(line) = console_backend.read_line() {
            message_queue.push_back((ChatParticipant::Local, line));
            need_redraw_message_history = true;
        }

        if let Some(line) = serial_backend.read_line() {
            message_queue.push_back((ChatParticipant::Remote, line));
            need_redraw_message_history = true;
        }
    }
    Ok(())
}
```
````

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
