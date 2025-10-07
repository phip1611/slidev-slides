---
# https://sli.dev/custom/
# Meta
author: Philipp Schuster <phip1611@gmail.com>
info: |
  My talk at EuroRust 2025 in Paris
title: A Minimal Rust Kernel - Printing to QEMU with core::fmt

# Generic Settings
addons:
aspectRatio: 16/9
background:
canvasWidth: 780
colorSchema: light
drawings:
  persist: false
fonts:
  provider: none
  sans: Roboto
  mono: Roboto Mono
  local: Amatic SC
mdc: true
selectable: true
theme: default

# For next slide (cover slide)
class: text-center
layout: cover
transition: undefined
---

<h1 style="font-size: 5rem !important">A Minimal <span v-mark="{at: 5, type: 'circle', color: '#d61515'}">Rust</span> <span v-mark="{at: 4, type: 'circle', color: '#d61515'}">Kernel</span></h1>

## Printing to <span v-mark="{at: 1, type: 'circle', color: '#d61515'}">QEMU</span> with <code><span v-mark="{at: 2, type: 'circle', color: '#d61515'}">core</span>::<span v-mark="{at: 3, type: 'circle', color: '#d61515'}">fmt</span></code>

<div class="abs-br m-6 text-xl">
  Philipp Schuster, Cyberus Technology
</div>

<div style="position: absolute; top: 0.2rem; right: 0.3em;">
  <code>#EuroRust</code>
</div>

<div style="position: absolute; top: 0.2rem; left: 0.3em;">
  <code>Paris, 2025-10-10</code>
</div>

<div v-click="5" position="absolute" top="1ch" left="1ch">
  <div v-motion :initial="{ x: -80 }" :enter="{ x: 0, y: 0 }"
  :click-5="{ x: 0, y: 20 }"
  :leave="{ y: 0, x: 20 }">
  <img src="/images/rustacean-orig-noshadow.webp" alt="Ferris (Rust Mascotte)"
  style="width: 200px; max-width: 20vw; height: auto; transform: rotate(-20deg)"
  />
  </div>
</div>

<div v-if="$slidev.nav.clicks > 0"
  class="absolute bottom-10 left-10 bg-white p-4 rounded shadow" style="--un-shadow-color: #d61515;">
  <div v-if="$slidev.nav.clicks === 1">Thing that runs our kernel in a VM</div>
  <div v-else-if="$slidev.nav.clicks === 2">Platform-agnostic part of Rust <code>std</code></div>
  <div v-else-if="$slidev.nav.clicks === 3">Formatting API of <code>core</code></div>
  <div v-else-if="$slidev.nav.clicks === 4">Core software component of a OS</div>
  <div v-else-if="$slidev.nav.clicks === 5">Cool new language + ecosystem</div>
</div>

---
layout: "two-cols-header"
title: "$ whoami"
---

# {{ $frontmatter.title }}

::left::

<v-clicks depth="2">

- Philipp Schuster, Dresden 🇩🇪🇪🇺
- Working at Cyberus Technology as Software Engineer
  - Virtualization, Linux/KVM, x86
  - Rust, Assembly, C/C++, Nix/NixOS
- Nix and NixOS enthusiast
- Enjoy conferences and meetups
- Organizer of Dresden Systems Meetup

</v-clicks>

::right::

<ul v-click>
  <li>
    <div style="display: inline-block; width: 7ch">GitHub</div>
    <a href="https://github.com/phip1611">@phip1611</a>
  </li>
  <li>
    <div style="display: inline-block; width: 7ch">Reddit</div>
    <a href="https://reddit.com/u/phip1611">@phip1611</a>
  </li>
  <li>
    <div style="display: inline-block; width: 7ch">Blog</div>
    <a href="https://phip1611.de">phip1611.de</a>
  </li>
</ul>

<SlideIndicator />


---
layout: "two-cols-header"
title: "$ whoami: Rust Experience"
---

# {{ $frontmatter.title }}

::left::

<h3 v-click class="my-2 font-bold">
  Hobby Projects
</h3>

<v-clicks depth="1">

- [github.com/rust-osdev](https://github.com/rust-osdev)
  - `multiboot2`
  - `uefi`
- Author of various smaller crates
  - `tar-no-std`
  - `ttfb`
  - `spectrum-analyzer`

</v-clicks>

::right::

<h3 v-click class="my-2 font-bold">
  Work Projects
</h3>

<v-clicks>

- Cloud Hypervisor
- `rust-vmm` ecosystem

</v-clicks>

<SlideIndicator />


---
title: "Agenda"
---

# {{ $frontmatter.title }}

<v-clicks>

<ol start=0>
  <li><pre>$ whoami</pre></li>
  <li>What (Not) To Expect</li>
  <li>Background</li>
  <li>Kernel Binary in Rust</li>
  <li>Code, Demos, Examples</li>
  <li>Findings</li>
  <li>Best Practises & Outlook</li>
</ol>

</v-clicks>

<SlideIndicator />

---
title: "1. What (Not) To Expect"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks>

- One possible way to write a minimal kernel (for 32-bit x86)
- Essential knowledge (as good as one can do that in 30 minutes)
- Minimal setup but sufficient for a playground
- Best practices for your own project

</v-clicks>


<SlideIndicator />

---
title: "1. What (Not) To Expect"
layout: "two-cols-header"
---

# {{ $frontmatter.title }}

::left::

<h3 v-click class="my-2 font-bold">
  NAY 😞 (limited time)
</h3>

<v-clicks>

- Processes / Threads
- File system, network
- Not even remotely a functional kernel (e.g., UNIX-like)

</v-clicks>

::right::

<h3 v-click class="my-2 font-bold">
YAY 🥳
</h3>

<v-clicks>

- What it takes to get there
- Productive setup &amp; best practices
- Build basic kernel binary
- "Hello World" in VM
- `log::info!("works {}", "too")`
- Print discovered PCI devices

</v-clicks>

<SlideIndicator />


---
title: "2. Background"
layout: "default"
---

# {{ $frontmatter.title }}

<SlideIndicator />


---
title: "2.1 What is a kernel?"
layout: "default"
---

# {{ $frontmatter.title }}

<div grid="~ sm:cols-[1fr_2fr] cols-1 gap-4 min-h-screen">
  <div class="p-4">
    <img src="/images/what-is-kernel.webp"/>
  </div>
  <div class="p-4" text="center">
    <Arrow v-click="1" x1="280" y1="400" x2="280" y2="120" />
    <div bg="gray-200" p="4">
      <span v-click="5">Runtime Environment</span>
    </div>
    <div bg="gray-300" p="4">
      <span v-click="4"><span v-mark="{at: 6, type: 'circle', color: '#d61515'}">Kernel</span></span>
    </div>
    <div bg="gray-200" height="22px" p="4">
      <span v-click="3">Bootloader</span>
    </div>
    <div bg="gray-300" p="4">
      <span v-click="2">Firmware</span>
    </div>
    <div bg="gray-200" p="4">
      <span v-click="1">Hardware</span>
    </div>
  </div>
</div>

<span  v-click="2">&ast; used in my demo</span>

<SlideIndicator />


---
title: "2.2 Environment for Kernel"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks depth="2">

- Single-threaded
  - Code executes only on Bootstrap Processor (BSP)
  - Other cores are asleep ("Application Processors" (AP))
- Some callable firmware functions
- More info in memory map and well-known locations
</v-clicks>

<SlideIndicator />


---
layout: "two-cols-header"
title: "2.3 Accessing Hardware"
---

# {{ $frontmatter.title }}

::left::

<h3 v-click class="my-2 font-bold">
  Memory-Mapped I/O (MMIO)
</h3>


<div v-click color="orange" class="mt-2">No time for that today ... 😞</div>

<div v-click class="opacity-40" style="filter: blur(1px)">

- Physical memory addresses map
  - to RAM cells
  - to device registers
  - to any GPIO pin or whatnot ...
- Memory Map + Well-known locations
  identify certain hardware
- `mov src, dst` instructions

</div>

::right::

<h3 v-click class="my-2 font-bold">
  Port I/O (PIO) <small>(Only on x86)</small>
</h3>

<v-clicks>

- X86 has a Port I/O address space
- “Write byte A to Port B”
- Port may map to a device register
- Well-known locations + lookup structures
- `in/out` instructions

</v-clicks>

<SlideIndicator />


---
layout: "default"
title: "2.4 QEMU: Running kernel in a VM"
---

# {{ $frontmatter.title }}

<v-clicks>

- QEMU will run our kernel in a VM
- Provides virtual hardware, similar to real hardware
- Easy to capture output
- Easy debugging
- Our kernel is too basic for real hardware

</v-clicks>

<SlideIndicator />


---
layout: "two-cols-header"
title: "2.4 QEMU + Debugcon Device"
---

# {{ $frontmatter.title }}

::left::

<div class="pr-1">

<h3 class="my-2 font-bold">
  QEMU Command Line
</h3>

```bash {0|1|4|2}{lines:true}
qemu-system-i386 \
    -debugcon stdio \
    -display none \
    -kernel ./kernel \
    -m 64M \
    -machine q35,accel=tcg \
    -monitor none \
    -no-reboot \
    -nodefaults
```

</div>

::right::

<div class="pl-1">

<h3 v-click class="my-2 font-bold">
  Debugcon Device
</h3>

<v-clicks>

- Device on I/O Port `0xe9`
- Device model in QEMU reacts to writes
- Technically used like a real device but only part of virtual QEMU hardware
- 🤫 <span v-after class="text-gray">Device also exists in Cloud Hypervisor since I added device model</span>

</v-clicks>

<Arrow v-click="6" x1="413" y1="186" x2="245" y2="178" />

</div>

<SlideIndicator />

---
layout: "default"
title: "2.5 Writing to the Debugcon Device"
---

# {{ $frontmatter.title }}

```asm {1-2|3-4|6-7|8-9|7,9,11,12,14,15|1}{lines: true}
# Code that prints "hi\n" to the debugcon device
start:
  # Write QEMU debugcon port '0xe9' to register 'dx'
  mov  $0xe9, %dx

  # Write character 'h' to register 'al'
  mov  $'h', %al
  # Write value in register 'al' to port in register 'dx'
  out  %al, %dx

  mov  $'i', %al
  out  %al, %dx

  mov  $'\n', %al
  out  %al,  %dx
```

<small>You are seeing GNU Assembler Syntax (GAS) with the AT&T Syntax Flavor.</small>

<SlideIndicator />

---
title: "2. Summary"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks>

- QEMU runs kernel in a virtual machine
- Kernel writes bytes (ASCII) to debugcon device
  - I/O port `0xe9`

</v-clicks>

<SlideIndicator />

---
title: "3. Kernel Binary in Rust"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks>

- `#![no_std]` aka. "freestanding" binary (executable)
  - File format: Executable and Linkable Format (ELF)
- Crate attributes: `#![no_std]` and `#![no_main]`
- There is no `std`, just `core`
- **For our example**: Custom compiler target for 32-bit x86 code ("i686")

</v-clicks>

<SlideIndicator />

---
title: "3. Kernel: Limitations & Caveats"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks depth="2">

- Having no `std` means <strong>no</strong>
  - `std::fs` & `File::new()`
  - `std::net`
  - `std::sync::Mutex`
- There is no surrounding runtime
  - No Linux you can utilize
- Your kernel <strong>is</strong> your runtime

</v-clicks>

<SlideIndicator />

<!--
Say: `std` is supposed to run in userspace utilizing a kernel + runtime
-->

---
title: "3. Kernel: Limitations & Caveats (Our Example)"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks depth="2">

- Function calls require a stack
- Our kernel needs a small assembly routine
  - Set-up stack
  - Jump to Rust code

</v-clicks>

<SlideIndicator />

---
title: "3. Summary"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks>

- No `std`, just `core`
- Custom compiler target: 32-bit x86 code
- Kernel starts with assembly, then jumps to Rust code

</v-clicks>

<SlideIndicator />


---
title: "4. Code, Code, Code"
layout: "two-cols-header"
---

# {{ $frontmatter.title }}

::left::

<br>
<br>

<a href="http://github.com/phip1611/eurorust-2025-code">github.com/phip1611/eurorust-2025-talk</a>

::right::

<div style="position:absolute; right: 5ch">
  <QrCode
  value="http://github.com/phip1611/eurorust-2025-code" size="300"></QrCode>
</div>

<SlideIndicator />


---
title: "5. Learnings"
layout: default
---

# {{ $frontmatter.title }}

<br>
<br>
<br>

<div class="flex justify-center items-center text-4xl">
💡<br>🤓
</div>

<SlideIndicator />


---
title: "5. Connect core::fmt with Debugcon device"
layout: two-cols-header
zoom: 0.9
---

# {{ $frontmatter.title }}

::left::

<div class="pr-1">
````md magic-move
```rust {0|1|5}{lines:true}
struct Debugcon;

impl Debugcon {
    /// I/O port of QEMUs debugcon device
    const IO_PORT: u16 = 0xe9;
}
```
```rust {7}{lines:true}
struct Debugcon;

impl Debugcon {
    /// I/O port of QEMUs debugcon device
    const IO_PORT: u16 = 0xe9;

    fn write_byte(byte: u8) {}
}
```
```rust {8}{lines:true}
struct Debugcon;

impl Debugcon {
    /// I/O port of QEMUs debugcon device
    const IO_PORT: u16 = 0xe9;

    fn write_byte(byte: u8) { unsafe {
        core::arch::asm!()
    }}
}
```
```rust {8|8-11,14|7,15}{lines:true}
struct Debugcon;

impl Debugcon {
    /// I/O port of QEMUs debugcon device
    const IO_PORT: u16 = 0xe9;

    fn write_byte(byte: u8) { unsafe {
        core::arch::asm!(
            "out %al, %dx",
            ("al") byte,
            ("dx") Self::IO_PORT,
            options(att_syntax, nomem, nostack,
            preserves_flags)
        )
    }}
}
```
````
</div>

::right::

<div v-click="7" class="pl-1">
````md magic-move
```rust {0|1,9|2,5}{lines:true}
impl core::fmt::Write for Debugcon {
    fn write_str(&mut self, s: &str)
    -> fmt::Result {
        Ok(())
    }
}
```
```rust {2|4,6|4-6}{lines:true}
impl core::fmt::Write for Debugcon {
    fn write_str(&mut self, s: &str)
    -> fmt::Result {
        for &byte in s.as_bytes() {
            Debugcon::write_byte(byte);
        }
        Ok(())
    }
}
```
````
</div>

<SlideIndicator />


---
title: "5. Kernel binary / Freestanding binary"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks>

- `#![no_std]` for binary & all dependencies
- Stack required to call Rust functions
- Initially single-threaded
- To just get started: 32-bit kernel playground is sufficient \
  → See my demo!
- **Rust makes things much easier than C! `core` just works!**

</v-clicks>

<div v-click="5" position="absolute" bottom="4ch" right="1ch">
  <img src="/images/rustacean-orig-noshadow.webp" alt="Ferris (Rust Mascotte)"
  style="width: 200px; max-width: 20vw; height: auto; transform: rotate(-20deg)"
  />
</div>

<SlideIndicator />


---
title: "5. Summary"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks depth="2">

- Single-threade kernel, just `core`, 32-bit x86 code
- Abstraction for debugcon device
  - Glued together with `core::fmt`
- Once stack is set up, we can call any Rust function

</v-clicks>

<SlideIndicator />

---
title: "6. Best Practises & Outlook"
layout: "default"
---

# {{ $frontmatter.title }}

<SlideIndicator />


---
title: "6. Cargo Workspaces"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks depth="2">

- You can have a single Cargo workspace
- `default-members` should <span v-mark="{at: 2, type: 'underline', color: '#d61515'}">excludes all workspace</span> members which
  - Pull in Rust runtime items
    - `#[global_allocator]`
    - `#[panic_handler]`
  - Build non-host binaries (OS-specific bootloader, kernel)
- This way `cargo test` works

</v-clicks>

<SlideIndicator />


---
title: "6. Cargo/rustc Compiler Flags & Special Configuration"
layout: "two-cols-header"
zoom: 0.9
---

# {{ $frontmatter.title }}

::left::

<div class="pr-1">
  <h3 class="my-2 font-bold">
    ⚠️ Cargo-native configuration (Caveats!)
  </h3>

<span v-click="4">

→ `cargo test` **doesn't** just work

</span>

<v-click step="1">

```toml {0|1|3,7,11|0}{lines: true}
# file: .cargo/config.toml
[unstable]
build-std = [
  "core", "compiler_builtins",
  "alloc"
]
build-std-features = [
  "compiler-builtins-mem"
]
[build]
target = "x86-unknown-none.json"
rustflags = []
```

</v-click>
</div>

::right::

<div class="pl-1">
  <h3 v-click="5" class="my-2 font-bold">
✅ Wrap Cargo Invocation (more flexible!)
  </h3>

<span v-click="9">

→ `cargo test` **just works**

</span>

<div v-click="5">

```bash {all|1|2|3-4|all}{lines: true}
cargo build --release \
    --target ./x86-unknown-none.json \
    -Z build-std=core,alloc,compiler_builtins \
    -Z build-std-features=compiler-builtins-mem
```

</div>

<span v-click="9">

→ Recommendation: Wrap in Makefile/shell script

</span>
</div>

<SlideIndicator />

---
title: "6. Outlook: Towards a \"Real\" Kernel"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks>

- Kernel in 64-bit "long mode"
- Virtual memory: load kernel to `0xffff_ffff_8820_0000`
- Wake up other cores
- Check out my project **PhipsOS**, also on my GitHub:

</v-clicks>

<div v-click="4" flex justify-end mr-5>
  <QrCode size="180" value="https://github.com/phip1611/phips-os/tree/6efe6e5aee6dd7203a65a1b6e1fff78ed49e4ad8/ws"/>
</div>

<SlideIndicator />

---
title: "6. Summary"
layout: "default"
---

# {{ $frontmatter.title }}

<v-clicks depth="2">

- Enabling `cargo test` in a workspace requires attention

</v-clicks>

<SlideIndicator />

---
title: "Thanks for Your Attention"
layout: "two-cols-header"
---

# {{ $frontmatter.title }}

::left::

<ul>
  <li>Philipp Schuster - Dresden 🇩🇪🇪🇺</li>
  <li>
    <div style="display: inline-block; width: 7ch">GitHub</div>
    <a href="https://github.com/phip1611">@phip1611</a>
  </li>
  <li>
    <div style="display: inline-block; width: 7ch">Reddit</div>
    <a href="https://reddit.com/u/phip1611">@phip1611</a>
  </li>
  <li>
    <div style="display: inline-block; width: 7ch">Blog</div>
    <a href="https://phip1611.de">phip1611.de</a>
  </li>
</ul>

::right::

<h3 class="mb-2 font-bold">
  Code and Slides
</h3>
<QrCode value="https://github.com/phip1611/eurorust-2025-code" size="180"></QrCode>
<br>

[GitHub: phip1611/eurorust-2025-code](https://github.com/phip1611/eurorust-2025-code)

<SlideIndicator />
