---
layout: default
---

# 2. Background

<v-clicks>

- Give you a comprehensive overview of the hardware
- Lots of technical details
- You do not have to remember all of them

</v-clicks>

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
- Exposed as serial "port"; also called COM ports (COM1, COM2, ...)
- Typically `COM1` port at x86 I/O port `0x3f8`

</v-clicks>

<SlideIndicator />


---
layout: default
---

# Technical Details

<v-clicks depth="2">

- From CPU and Operating System perspective:
  - Configure
  - Send single bytes
  - Receive single bytes
- From mainboard/chipset perspective:
  - Microcontroller
  - Wired to x86 I/O ports

</v-clicks>

<SlideIndicator />

---
layout: default
---

# Technical Details

<v-clicks depth="2">

- Implemented via a `UART`* microcontroller (typically a _16550_): \
  Sends and receives data bit-by-bit over/from the wire (_serial transmission_)
- UART microcontroller is built into the mainboard (the chipset)
- Using RS-232** for transmission\
  (DE-9 connector, simple wire with one lane per PIN in connector)
- Common case: `8-N-1` transmission with 115200 Baud \
  (8 data bits, no parity bit, 1 stop bit)

</v-clicks>

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
- There is no feature negotiation

</v-clicks>

<SlideIndicator />


---
layout: default
---

# Transmission from Sender to Receiver (Simplified)

<v-clicks depth="2">

- Sender: OS: Writes data to `UART`'s data<sub>in</sub> register
- Sender: UART: Reads byte from data<sub>in</sub> register
- Sender: UART: Translates that into analog electrical signals following RS-232
- Receiver: UART: Recreates bytes from received bits
- Receiver: UART: Puts byte into data<sub>out</sub> register
- Receiver: OS: Read byte from data<sub>out</sub> register

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

<SlideIndicator />


---
layout: two-cols-header
transition: undefined
---

# DE-9 (RS-232 Connector Pinout)

<div class="flex flex-col items-center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/RS-232_DE-9_Connector_Pinouts.png/960px-RS-232_DE-9_Connector_Pinouts.png"
       width="450px" />
</div>

::left::

#### Sender

<v-clicks>

- **Data Terminal Ready (DTR)**: \
  We are powered on and ready
- **Ready to Send (RTS)**: \
  Ready to receive from remote

</v-clicks>

::right::

#### Receiver

<v-clicks>

- **Data Set Ready (DSR)**: \
  Remote is powered on and ready
- **Clear To Send (CTS)**: \
  Remote is ready to receive

</v-clicks>

<SlideIndicator />


---
layout: default
transition: slide-up
---

# DE-9 (RS-232 Connector Pinout)

<div class="flex flex-col items-center mb-2">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/RS-232_DE-9_Connector_Pinouts.png/960px-RS-232_DE-9_Connector_Pinouts.png"
       width="450px" />
</div>

<v-clicks depth="2">

- One receive and one send line: RX, TX
  - RX
  - TX
- <strong>Null-modem mode</strong> (direct point to point): RX↔TX, TX↔RX

</v-clicks>

<Arrow v-click="[2,3]" :x1="350" :y1="265" :x2="250" :y2="185" color="red" />
<Arrow v-click="3" :x1="380" :y1="265" :x2="280" :y2="185" color="red" />

<Arrow v-click="[2,3]" :x1="350" :y1="265" :x2="505" :y2="185" color="blue" />
<Arrow v-click="3" :x1="380" :y1="265" :x2="535" :y2="185" color="blue" />

<SlideIndicator />


---
layout: default
transition: slide-up
---

# Typical Use Case

<v-clicks depth="3">

- Terminal connected to a machine <strong>via serial device</strong>
  - Text-based user interface (TUI) to see output and to enter commands
  - Special character sequences* (non-informative text) have special meaning
    - Bold
    - Move Cursor
    - Set Background
- Null-modem mode: point-to-point connection

</v-clicks>

<!-- footnote -->
<div v-click="3" position="absolute" left="2ch" bottom="2ch" text="sm">
* ANSI escape sequences; typically following VT-102 standard
</div>

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

<v-clicks depth="2">

- Very simple to use
- No complex device discovery (PCIe, USB)
- No network packet handling (no TCP/IP)
- A few instructions for minimal setup (driver in a few lines of code)
- Easy to debug firmware, kernel, bootloaders: \
  When you don't have a screen (yet)

</v-clicks>


<SlideIndicator />



---
layout: default
---

# 2. Background: Summary

<v-clicks depth="3">

- Very simple to use for developers
  - Easy to write a device driver
  - Easy to connect a terminal
    - To a VM driven by Cloud Hypervisor or QEMU
    - On real hardware via a USB serial cable
- Effectively limited to point-to-point connections (Null-modem mode)
- Nothing for consumers these days, but for developers

</v-clicks>

<SlideIndicator />
