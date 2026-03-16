---
layout: default
---

# 2. Background

<SlideIndicator />


---
layout: default
---

# About the Serial Device

<v-clicks depth="2">

- Referring to _**the**_ serial device is a simplification
- _Using a serial device_ is conceptually like saying _Using a network device_
- Typically one serial device connected to one endpoint: \
  Point-to-Point model (e.g., keyboard, printer, a terminal)
- Exposed as serial port; also called COM ports (COM1, COM2, ...)
- Typically a single `COM1` port at x86 I/O port `0x3f8`
- From CPU perspective: configure, send single bytes, receive single bytes

</v-clicks>

<SlideIndicator />

---
layout: default
---

# Technical Details

<v-clicks depth="2">

- Implemented via a `UART`* microcontroller (typically a _16550_): \
  Sends and receives bytes bit-by-bit over/from the wire (_serial transmission_)
- UART microcontroller is built into the mainboard (the chipset)
- Using RS-232** for transmission\
  (DE-9 connector, simple wire with one lane per PIN in connector)
- `8-N-1` transmission with 115200 Baud \
  (8 data bits, no parity bit, 1 stop bit)

</v-clicks>

TODO showing photo again

<!-- footnote -->
<div v-click="1" position="absolute" left="2ch" bottom="7ch" text="sm">
* <b>U</b>niversal <b>a</b>synchronous <b>r</b>eceiver-<b>t</b>ransmitter: In short: byte transmission as individual bits
</div>
<div v-click="3" position="absolute" left="2ch" bottom="2ch" text="sm">
** RS-232 defines the electrical voltage levels, DE-9 is the connector<br/>
&nbsp;&nbsp;&nbsp;(akin to USB 2.0 (transmission) and USB Type C (connector))
</div>


<SlideIndicator />

---
layout: default
---

# Connection Requirements

<v-clicks depth="2">

- Receiver UART microcontroller must be compatible with RS-232 signals
- Sender and receiver must agree on
  - Transmission settings, e.g., `8-N-1`
  - Baud rate
- There is no live negation

</v-clicks>

<SlideIndicator />

---
layout: default
---

# Transmission from Sender to Receiver (Simplified)

<v-clicks depth="2">

- Sender: OS: Writes data to `UART`'s data register
- Sender: UART: Translates that into analog electrical signals following RS-232
- Receiver: UART: Recreates bytes from received bits
- Receiver: OS: Read byte from data register

</v-clicks>

<SlideIndicator />

---
layout: default
---

# UART Implementation Freedom

<v-clicks depth="2">

- Buffering / Queues
- Interrupts
- Configuration

</v-clicks>


<!-- footnote -->
<div v-click="3" position="absolute" left="2ch" bottom="2ch" text="sm">
* RS-232 defines the electrical voltage levels, DE-9 is the connector<br/>
&nbsp;&nbsp;&nbsp;(akin to USB 2.0 (transmission) and USB Type C (connector))
</div>

<SlideIndicator />


---
layout: two-cols-header
transition: undefined
---

# DE-9 (RS-232 connector pinout)

<div class="flex flex-col items-center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/RS-232_DE-9_Connector_Pinouts.png/960px-RS-232_DE-9_Connector_Pinouts.png"
       width="450px" />
</div>

::left::

#### Sender

- **Data Terminal Ready (DTR)**: \
  Up and configured
- **Ready to Send (RTS)**: \
  Ready for remote to send data

::right::

#### Receiver


- **Data Set Ready (DSR)**: \
  Sender is up and configured
- **Clear To Send (CSR)**: \
  Remote is ready to receive data

<SlideIndicator />


---
layout: default
transition: slide-up
---

# DE-9 (RS-232 connector pinout)

<div class="flex flex-col items-center mb-2">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/RS-232_DE-9_Connector_Pinouts.png/960px-RS-232_DE-9_Connector_Pinouts.png"
       width="450px" />
</div>

- One receive and one send lane (RX, TX)
- In Null-modem mode (direct point to point) crossed

<SlideIndicator />

---
layout: default
transition: slide-up
---

# Typical Use Case

- Terminal connected to a machine via serial
  - Text-based user interface (TUI) to see output and to enter commands
  - Special character sequences (non-informative text) have special meaning
    - Bold
    - Move Cursor
    - Set Background

<SlideIndicator />

---
layout: image
image: ./images/tui_example_bottom.png
---

<!-- Example of a TUI tool -->



---
layout: default
---

# Why Use Serial Devices (as Developer)?

- Very simpel to use
- No complex device discovers (PCIe, USB)
- No network packet handling (no TCP/IP)
- A few instructions for minimal setup (driver in a few lines of code)
- Easy to debug firmware, kernel, bootloaders: \
  When you don't have a screen (yet)



---
layout: default
---

# 2. Background: Summary

- Very simpel to use for developers
  - Easy to write a driver
  - Easy to connect a terminal (in a VMM such as Cloud Hypervisor) or on
    real hardware via a USB serial cable
- Effectively limited to point-to-point connections
- Nothing for consumers these days, but for developers

<SlideIndicator />
