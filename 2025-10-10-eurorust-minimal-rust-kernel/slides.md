---
# https://sli.dev/custom/
# Meta
author: Philipp Schuster <phip1611@gmail.com>
info: |
  context: My talk at EuroRust 2025 in Paris
title: A Minimal Rust Kernel - Printing to QEMU with <code>core::fmt</code>

# Generic Settings
addons:
aspectRatio: 16/9
background:
canvasWidth: 780
colorSchema: light
drawings:
  persist: false
fonts:
  provider: google
  sans: Roboto
  # This way, we can import the font from Google and use it later for the h tags
  serif: Amatic SC
  mono: Roboto Mono
mdc: true
selectable: true
theme: default

# For next slide
class: text-center
layout: cover
transition: slide-left
---

<style>
h1, h2, h3, h4, h5, h6 {
  font-family: 'Amatic SC', sans-serif
}

a,a:active,a:visited {
  color: #d61515;
}
</style>

<h1 style="font-size: 5rem !important">A Minimal <span v-mark="{at: 5, type: 'circle', color: '#d61515'}">Rust</span> <span v-mark="{at: 4, type: 'circle', color: '#d61515'}">Kernel</span></h1>

## Printing to <span v-mark="{at: 1, type: 'circle', color: '#d61515'}">QEMU</span> with <code><span v-mark="{at: 2, type: 'circle', color: '#d61515'}">core</span>::<span v-mark="{at: 3, type: 'circle', color: '#d61515'}">fmt</span></code>

<div class="abs-br m-6 text-xl">
  Philipp Schuster, Paris, 2025-10-10
</div>

<div style="position: absolute; top: 0.2rem; right: 0.3em;">
  <code>#EuroRust</code>
</div>

<div v-click="5" position="absolute" top="1ch" left="1ch">
  <img src="./images/rustacean-orig-noshadow.png" alt="Ferris (Rust Mascotte)"
  style="width: 200px; max-width: 20vw; height: auto; transform: rotate(-20deg)"
  />
</div>

<div v-if="$slidev.nav.clicks > 0"
  class="absolute bottom-10 left-10 bg-white p-4 rounded shadow" style="--un-shadow-color: #d61515;">
  <div v-if="$slidev.nav.clicks === 1">Thing that runs our kernel in a VM</div>
  <div v-else-if="$slidev.nav.clicks === 2">platform-agnostic part of Rust <code>std</code></div>
  <div v-else-if="$slidev.nav.clicks === 3">Formatting API of <code>core</code></div>
  <div v-else-if="$slidev.nav.clicks === 4">Core software component of a OS</div>
  <div v-else-if="$slidev.nav.clicks === 5">Cool new language + ecosystem</div>
</div>

<!--
The last comment block of each slide will be treated as slide notes. It will be visible and editable in Presenter Mode along with the slide. [Read more in the docs](https://sli.dev/guide/syntax.html#notes)
-->

---
layout: "two-cols-header"
title: "$ whoami"
---

# {{ $frontmatter.title }}

::left::

<ul>
  <li>Philipp Schuster, Dresden 🇩🇪🇪🇺</li>
  <li>Software Engineer at Cyberus Technology
    <ul>
      <li>Virtualization, Linux/KVM, x86</li>
      <li>Rust, Assembly, C/C++, Nix/NixOS</li>
    </ul>
  </li>
  <li>Nix and NixOS enthusiast</li>
  <li>Enjoy conferences and meetups</li>
  <li>Organizer of Dresden Systems Meetup</li>
</ul>

::right::

<ul>
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

---
layout: "two-cols-header"
title: "$ whoami"
---

# {{ $frontmatter.title }}

::left::

<h3 class="my-2 font-bold">
  Hobby Projects
</h3>
<ul>
  <li><a href="https://github.com/rust-osdev">github.com/rust-osdev</a>
    <br>
    → <code>uefi</code>,<code>multiboot2</code>
  </li>
  <li>Author of various smaller crates
    <br>
    → <code>tar-no-std</code>,<code>ttfb</code>,<code>spectrum-analyzer</code>
  </li>
</ul>

::right::

<h3 class="my-2 font-bold">
  Work Projects
</h3>
<ul>
  <li>Cloud Hypervisor</li>
  <li><code>rust-vmm</code> ecosystem</li>
  <li>Linux/KVM</li>
  <li>NixOS/<code>nixpkgs</code></li>
</ul>

---
title: "Agenda"
---

# {{ $frontmatter.title }}

<ol start=0>
  <li><pre>$ whoami</pre></li>
  <li>What (Not) To Expect</li>
  <li>Background
    <ol>
      <li>What is a kernel?</li>
      <li>Early boot environment</li>
      <li>Accessing (virtual) hardware</li>
      <li>QEMU + Debugcon Device</li>
    </ol>
  </li>
  <li>A <pre style="display: inline">#![no_std]</pre> Rust binary</li>
  <li>Code, Demos, Examples</li>
  <li>Findings</li>
</ol>

---
title: "1. What (Not) To Expect"
layout: "two-cols-header"
---

# {{ $frontmatter.title }}

::left::


<h3 class="my-2 font-bold">
  NAY 😞 (limited time)
</h3>
<ul>
  <li>Processes / Threads</li>
  <li>File system, network</li>
  <li>Not even remotely a functional kernel (e.g., UNIX-like)</li>
</ul>


::right::

<h3 class="my-2 font-bold">
YAY 🥳
</h3>
<ul>
  <li>What it takes to get there</li>
  <li>Productive setup &amp; best practices</li>
  <li>Build basic kernel binary<br>→ "Hello World" in VM</li>
  <li><code>let arch = Arch::X86;</code></li>
</ul>


---
title: "2. Background"
layout: "default"
---

# {{ $frontmatter.title }}


---
title: "2.1 Background: What is a kernel?"
layout: "image-left"
image: ./images/what-is-kernel.png
backgroundSize: 15em
---

# {{ $frontmatter.title }}

<span>
<span v-click>Firmware (legacy BIOS* or UEFI)<br/></span>
<span v-click="3">↓<br/>
Bootloader<br/></span>
<span v-click="4">↓<br/>
Kernel<br/></span>
<span v-click="5">↓<br/>
Runtime Environment<br/></span>
</span>
<br/>

<span  v-click="2">&ast; used in my demo</span>

---
title: "2.2 Background: Environment for Kernel"
layout: "default"
---

# {{ $frontmatter.title }}

- Some callable firmware function
- Single-threaded
  - Code executes only on Bootstrap Processor (BSP)
  - Application Processors (AP) sleep
- Memory map (from firmware) and well-known locations

---
layout: "two-cols-header"
title: "2.3 Background: Accessing Hardware"
---

# {{ $frontmatter.title }}

::left::

<h3 class="my-2 font-bold">
  Memory-Mapped I/O (MMIO)
</h3>


<div v-click="1" color="orange" class="mt-2">No time for that today ... 😞</div>

<div v-click="1" class="opacity-40" style="filter: blur(1px)">

- Physical memory addresses map
  - to RAM cells
  - to device registers
  - to any GPIO pin or whatnot ...
- Memory Map + Well-known locations
  identify certain hardware
- <code>mov src, dst</code> instructions

</div>

::right::

<h3 class="my-2 font-bold">
  Port I/O (PIO) <small>(Only on x86)</small>
</h3>

<div v-click="2">

- X86 has a Port I/O address space
- “Write byte A to Port B”
- Port may map to a device register
- Well-known locations + lookup structures
- <code>in/out</code> instructions

</div>

---
layout: "two-cols-header"
title: "2.4 Background: QEMU + Debugcon Device"
---

# {{ $frontmatter.title }}

::left::

<h3 class="my-2 font-bold">
  QEMU Command Line
</h3>

```bash {1|1,2,4}{lines:true}
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

::right::

<h3 class="my-2 font-bold">
  Debugcon Device
</h3>

- Device on I/O Port <code>0xe9</code>
- Every byte written to it is printed to the
  specified location

---
title: "3. #![no_std] Kernel binary in rust (\"freestanding\")"
layout: "default"
---

# {{ $frontmatter.title }}

- We have to build a binary/executable (ELF) → Freestanding
- Crate attributes: <code>#![no_std]</code> and <code>#![no_main]</code>
- Custom compiler target for 32-bit x86 code ("i686")
- There is no libstd impl, just libcore *

&ast; cross-compiled

---
title: "3. #![no_std] Kernel binary in rust (\"freestanding\")"
layout: "default"
---

# {{ $frontmatter.title }}

- No <code>std::fs</code>, <code>std::net</code>, no <code>File::new()</code>
- There is no surrounding runtime, no Linux you can utilize
- Your kernel IS your runtime
- Function calls require a stack, but we don’t have one
- Our binary needs to start with a small assembly routine \
  → Set-up stack \
  → Jump to Rust code

---
title: "4. Code, Code, Code"
layout: "two-cols-header"
---

# {{ $frontmatter.title }}

::left::

<br>
<br>

<a href="http://github.com/phip1611/eurorust-2025-talk">github.com/phip1611/eurorust-2025-talk</a>

::right::

<div style="position:absolute; right: 5ch">
  <QrCode
  value="http://github.com/phip1611/eurorust-2025-talk" size="300"></QrCode>
</div>

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

---
title: "5. Learnings: Connect core::fmt with Debugcon device"
layout: two-cols-header
zoom: 0.9
---

# {{ $frontmatter.title }}

::left::

<div class="pr-1">
````md magic-move
```rust {all|1|5}{lines:true}
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
```rust {8-11,14|7,15}{lines:true}
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

<div v-click="6" class="pl-1">
````md magic-move
```rust {all|all|1,9|2,5}{lines:true}
impl core::fmt::Write for Debugcon {
    fn write_str(&mut self, s: &str)
    -> fmt::Result {
        Ok(())
    }
}
```
```rust {4-6}{lines:true}
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

---
title: "5. Learnings: Kernel binary / Freestanding binary"
layout: "default"
---

# {{ $frontmatter.title }}

- <code>#![no_std]</code> for binary + all dependencies
- Stack required to call Rust functions
- Initially single-threaded
- To just get started: 32-bit kernel playground is sufficient
  <br>→ See my demo!
- **Rust make things much easier than C! <code>libcore</code> just works!**

<div position="absolute" bottom="4ch" right="1ch">
  <img src="./images/rustacean-orig-noshadow.png" alt="Ferris (Rust Mascotte)"
  style="width: 200px; max-width: 20vw; height: auto; transform: rotate(-20deg)"
  />
</div>

---
title: "5. Best Practises & My Experience"
layout: "two-cols-header"
zoom: 0.9
---

# {{ $frontmatter.title }}

::left::

<div class="pr-1">
  <h3 class="my-2 font-bold">
    ⚠️ Cargo-native configuration (Caveats!)
  </h3>

→ <code>cargo test</code> **doesn't** just work

```toml {all|3,7,11}{lines: true}
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

</div>

::right::

<div class="pl-1">
  <h3 class="my-2 font-bold">
✅ Wrap Cargo Invocation (more flexible!)
  </h3>

→ <code>cargo test</code> **just works**

```bash {all|2-4}{lines: true}
cargo build --release \
    --target ./x86-unknown-none.json \
    -Z build-std=core,alloc,compiler_builtins \
    -Z build-std-features=compiler-builtins-mem
```
</div>

---
title: "5. Outlook: Towards a "Real" Kernel"
layout: "default"
---

# {{ $frontmatter.title }}

- kernel in 64-bit "long mode"
- virtual memory: load kernel to <code>0xffff_ffff_8820_0000</code>
- Boot Application Processors, bring them into 64-bit “long-mode”


- Check out my project **PhipsOS**, also on my GitHub: <QrCode value="https://github.com/phip1611/phips-os/tree/6efe6e5aee6dd7203a65a1b6e1fff78ed49e4ad8/ws"/>


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

<div class="grid grid-cols-2 gap-4 p-0">
  <div class="px-4">
    <h3 class="mb-2 font-bold">
      Code
    </h3>
    <QrCode value="https://github.com/phip1611/eurorust-2025-talk" size="140"></QrCode>
  </div>
  <div class="px-4">
    <h3 class="mb-2 font-bold">
      Slides
    </h3>
    <QrCode value="https://github.com/phip1611/slidev-slides" size="140"></QrCode>
  </div>
</div>
