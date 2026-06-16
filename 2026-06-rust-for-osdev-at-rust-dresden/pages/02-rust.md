---
layout: default
---

# 2.1 Rust and OS Development

Rust and low-level (`no_std`) development

<v-clicks depth="2">

- `#![no_std]` and the fun begins: \
  Embarrassingly simple toolchain setup to opt out of the standard library
- The standard library would normally link against glibc or musl (Linux),
  libSystem (macOS), or win32 (Windows)
- `no_std` gives you `core` \[+ `alloc`\]: the platform-agnostic base of `std` 🎉
  - `str` with UTF-8 handling
  - slices and miscellaneous helpers
  - `alloc` (`Box<T>`, `Vec<T>`) if you provide a `#[global_allocator]`

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.2 Unsafe Adventures & Mental Model

<v-clicks depth="2">

- `unsafe` operations to dereference pointers
- You need to uphold safety constraints and invariants \
  (e.g., check that a pointer is non-null and aligned)
- Risk for Undefined Behavior (UB)
- Miri can execute code with `unsafe` blocks and find undefined behavior (UB):
  Communication with the external world (I/O, hardware) must be mocked
- Reason about Rust's abstract machine (AM), not only the CPU: \
  Compiler optimizations rely on Rust's rules before code reaches x86_64

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.3 Giving Overview

In the following ...

<v-clicks depth="2">


- Brief overview of some low-level crates
- **No** in-depth analysis: just a few pointers to start the discussion

</v-clicks>

<SlideIndicator />


---
layout: default
---


# 2.4 Case Studies

<v-clicks depth="2">

- [github.com/rust-osdev](https://github.com/rust-osdev)
  - [`multiboot2`](https://crates.io/crates/multiboot2): \
    Bindings and helpers for the Multiboot2 bootloader protocol
  - [`uefi-rs`](https://crates.io/crates/uefi): \
    Bindings and helpers to UEFI firmware functionality
  - [`uart_16550`](https://crates.io/crates/uart_16550): \
    Simple yet highly configurable driver for 16550 UART devices
- I've used all of these crates on real hardware
- Started working with them in 2021 and gradually took over maintainership

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.5 Case Study: `uart_16550`

<v-clicks depth="2">

- Hardware found across many old and modern x86_64 systems
- Basic device to write data (e.g., the bytes of UTF-8 text) to the outer world: \
  Developers love it for debugging!

</v-clicks>

<img v-click="1" :src="'/images/com1_port_mainboard.jpg'" width="420"  />

<Arrow v-click="1" :x1="530" :y1="390" :x2="280" :y2="370" color="red" />

<SlideIndicator />

---
layout: default
transition: slide-up
---

# 2.6 Some Code: `uart_16550`

````md magic-move
```rust {0|1-3,9|6|8|4,5,7|*}{lines: true}
// Code from a minimal test kernel
// (excerpt from the crate's integration test)
fn main() -> anyhow::Result<()> {
    // SAFETY: we have exclusive access and the I/O port is valid
    let mut uart = unsafe {
        Uart16550Tty::new_port(0x3f8, Config::default())?
    };
    uart.write_str("hello world")?;
}
```
```rust {0|1,13|6,7|8}{lines: true}
pub unsafe fn new_port(
  base_port: u16,
  config: Config,
) -> Result<Self, Uart16550TtyError<PortIoAddress>> {
  // SAFETY: The address is valid and we have exclusive access.
  let mut inner =
    unsafe { Uart16550::new_port(base_port).map_err(Uart16550TtyError::AddressError)? };
  inner.init(config).map_err(Uart16550TtyError::InitError)?;
  inner
    .test_loopback()
    .map_err(Uart16550TtyError::TestError)?;
  Ok(Self(inner))
}
```
```rust {0|2,13|5,8}{lines: true}
impl<B: Backend> Uart16550<B> {
    pub fn init(&mut self, config: Config) -> Result<(), InitError> {
        // ...

        // Disable all interrupts (for now).
        // SAFETY: We operate on valid register addresses.
        unsafe {
            self.backend.write(offsets::IER as u8, 0);
        }
        // ...
    }
}
```
```rust {0|1,16|5,15|7,14|8-13|9}{lines: true}
impl Backend for PioBackend {
    type Address = PortIoAddress;

    #[inline(always)]
    unsafe fn _write_register(&mut self, port: PortIoAddress, value: u8) {
        // SAFETY: The caller ensured that the I/O port is safe to use.
        unsafe {
            asm!(
                "outb %al, %dx", // `outb` is an x86 instruction (see Intel SDM)
                in("al") value, // Name of the lowest 8-bit of the rax register
                in("dx") port.0, // Name of the lowest 16-bit of the rdx register
                options(att_syntax, nostack, preserves_flags)
            );
        }
    }
}
```
```rust {0|1,13|5,12|11}{lines: true}
impl Backend for MmioBackend {
    type Address = MmioAddress;

    #[inline(always)]
    unsafe fn _write_register(&mut self, address: MmioAddress, value: u8) {
        let upper_bound_incl = (NUM_REGISTERS - 1) * usize::from(u8::from(self.stride));
        // Address is in the device's address range
        debug_assert!(address.0.as_ptr() <= self.base().0.as_ptr().wrapping_add(upper_bound_incl));

        // SAFETY: The caller ensured that the MMIO address is safe to use.
        unsafe { arch::mmio_write_register(address, value) }
    }
}
```
```rust {0|1,9|5,8|7}{lines: true}
mod arch {
    /// Wrapper around [`ptr::write_volatile`].
    #[cfg(not(target_arch = "aarch64"))]
    #[inline(always)]
    pub unsafe fn mmio_write_register(address: MmioAddress, value: u8) {
        // SAFETY: Caller ensures the address is valid MMIO memory.
        unsafe { ptr::write_volatile(address.0.as_ptr(), value) }
    }
}
```
````

<SlideIndicator />
