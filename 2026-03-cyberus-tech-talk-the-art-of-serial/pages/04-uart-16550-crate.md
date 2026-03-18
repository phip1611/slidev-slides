---
layout: default
---

# 4. A new `uart_16550` crate

<v-clicks>

- Original crate didn't work on real hardware at first
- Figured out: It hardcoded the baud rate to `38400`
- I found the code to be not that pleasant to extend
- Created my own version
- Reached out to upstream to replace the original crate with my rewrite
- They were really happy about this

</v-clicks>

<SlideIndicator />


---
layout: default
---

# 3. Using a UART 16550 from Rust

````md magic-move
```rust {0|1|5,7|6|9|10|5}{lines: true}
use uart_16550::{Config, Uart16550Tty};
use core::fmt::Write;
// SAFETY: The address is valid and we have exclusive access.
let mut uart = unsafe {
    Uart16550Tty::new_port(
        0x3f8 as *mut _, Config::default()
    )?
};
uart.check_connected()?;
uart.write_str("hello world\nhow's it going?")?;
```
```rust {1|6,7|8|9-11|8}{lines: true}
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
```rust {0}{lines: true}
pub fn init(&mut self, config: Config) -> Result<(), InitError> {
}
```
```rust {0}{lines: true}
pub fn init(&mut self, config: Config) -> Result<(), InitError> {
    /* ... */
    unsafe {
    }
    /* ... */
}
```
```rust {0|7-12|8|9,11|10,12}{lines: true}
pub fn init(&mut self, config: Config) -> Result<(), InitError> {
    /* ... */
    unsafe {
        // Set Divisor Latch Access Bit (DLAB) to access DLL and DLM next
        self.backend.write(offsets::LCR as u8, LCR::DLAB.bits());

        // Calculate divisor for given baud rate
        let divisor = calc_divisor(/* ... */).map_err(InitError::InvalidBaudRate)?;
        let low = (divisor & 0xff) as u8;
        let high = ((divisor >> 8) & 0xff) as u8;
        self.backend.write(offsets::DLL as u8, low);
        self.backend.write(offsets::DLM as u8, high);

        // Clear DLAB
        self.backend.write(offsets::LCR as u8, 0);
    }
    /* ... */
}
```
```rust {0|1|6-8|9-11|15}{lines: true}
pub fn init(&mut self, config: Config) -> Result<(), InitError> {
    /* ... */
    // Set modem control register.
    unsafe {
        let mut mcr = MCR::from_bits_retain(0);
        // signal that we are powered on and configured
        // (assert MSR::DSR on remote)
        mcr |= MCR::DTR;
        // signal that we are ready to receive data
        // (assert MSR::CTS on remote)
        mcr |= MCR::RTS;
        // enable interrupt routing to the interrupt controller
        // (so far individual interrupts are still disabled in IER)
        mcr |= MCR::OUT_2_INT_ENABLE;
        self.backend.write(offsets::MCR as u8, mcr.bits());
    }
    /* ... */
}
```
```c {0|5|6|7|8|9|10|11|12}{lines: true}
#define PORT 0x3f8       // COM1

// Without nice abstractions, stripped-down C version
static int init_serial() {
   outb(PORT + 1, 0x00); // Disable all interrupts
   outb(PORT + 3, 0x80); // Enable DLAB (set baud rate divisor)
   outb(PORT + 0, 0x03); // Set divisor to 3 (lo byte) 38400 baud
   outb(PORT + 1, 0x00); //                  (hi byte)
   outb(PORT + 3, 0x03); // 8 bits, no parity, one stop bit
   outb(PORT + 2, 0xC7); // Enable FIFO, clear them, with 14-byte threshold
   outb(PORT + 4, 0x0F); // IRQs enabled, RTS/DSR set, no loopback
   outb(PORT + 0,  'a'); // Send letter 'a'
   return 0;
}
```
````
