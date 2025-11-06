---
layout: default
---

# 2. Background

<SlideIndicator />


---
layout: default
---

# 2.1 How does a Computer Boot?

<Arrow :x1="725" :y1="400" :x2="725" :y2="115" />

<div p="4" text="center">
  <div bg="red-200" p="4">
    <span v-click="5">Runtime Environment (Ubuntu, Windows)</span>
  </div>
  <div bg="red-100" p="4">
    <span v-click="4">Kernel (Linux, Windows)</span>
  </div>
  <div bg="red-200" height="22px" p="4">
    <span v-click="3"><span v-mark="{at: 6, type: 'underline', color: '#d61515'}">Bootloader / OS-Loader</span></span>
  </div>
  <div bg="red-100" p="4">
    <span v-click="2">Firmware (e.g., UEFI)</span>
  </div>
  <div bg="red-200" p="4">
    <span v-click="1">Hardware</span>
  </div>
</div>


<SlideIndicator />

---
layout: default
---

# 2.2 CPU Terminology (x86)

<v-clicks depth="2">

- **CPU**: Central Processing Unit, computing resource:\
  Everyday language: refers to whole package or computing resource
- **Package/Socket/Processor***: The thing mounted onto the mainboard
- <span class="text-gray-400">**Die**: Holds cores, caches, and additional logic (I/O, L3 cache)</span>
- **Core**: Independent execution engine (L1, L2 caches)
- **(Logical) CPU**:
  - Software-visible computing resource within a core
  - Implements the instruction set ("API of the CPU")
- Often fluid transitions and overlaps (architecture, manufacturer, platform)

</v-clicks>

<div v-click="2" position="absolute" left="2ch" bottom="2ch" text="sm">
* Inconsistencies even in Intel Manual (grown historically)
</div>

<SlideIndicator />

---
layout: default
---

# 2.3 The many modes of an x86 CPU

<v-clicks depth="2">

- 16-bit ("real mode")
- 32-bit protected mode, without paging
- 32-bit protected mode, with paging
- 64-bit with 32-bit opcodes ("compatibility IA-32e mode") \
  → Allows 32-bit software in an 64-bit operating system
- **64-bit mode** ("64-bit IA-32e mode"<sub>Intel</sub>, "long mode"<sub>AMD</sub>)

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.4 Overview of an x86 Computer

<v-clicks depth="2">

- Platform/SoC: Processor + Chipset
- Mainboard: Processor + Chipset + additional stuff (ports, power units)
- Chipset
  - Necessary logical functionality for CPU to work
  - Built into your mainboard
  - Managing data flow between processor and memory & peripherals
- PCIe
  - Main interface/bus to orchestrate hardware and connect with chipset
  - Controller typically integrated into processor
  - Chipset has PCIe lanes

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.4 Processor, Chipset, Hardware

<v-clicks depth="2">

- Platform Controller Hub (PCH)
  - Intel's name for a chipset family
  - Before 2009: "Northbridge" + "Southbridge"
  - Connects socket (processor) with memory, PCI lanes, power, ...
  - Example: USB controller and NVME controller appear as PCIe device
- Trivia: Mainboard manufacturer buys chipset IC(s) from Intel (e.g. Z390)
  and wires PCI lanes, memory bus, device slots. etc. as needed by the corresponding PCH
  spec + additional custom things

</v-clicks>

<div v-click="6" position="absolute" left="2ch" bottom="2ch" text="sm">IC: Integrated Circuit</div>

<SlideIndicator />


---
layout: "two-cols-header"
---

# 2.5 Accessing Hardware

::left::

<div p="1">

<h3 v-click class="my-2 font-bold">
  Memory-Mapped I/O <small>(MMIO)</small>
</h3>

<v-clicks depth="2">

- Physical memory addresses map to
  - RAM cells
  - Device registers
  - GPIO pin, ...
- `mov src, dst` instructions

</v-clicks>

</div>

::right::

<div p="1">

<h3 v-click class="my-2 font-bold">
  Port I/O <small>(PIO)</small>
</h3>

<v-clicks depth="2">

- X86 has a Port I/O address space
- “Write byte A to Port B”
- Port may map to a device register
- `in/out` instructions

</v-clicks>

</div>

<SlideIndicator />


---
layout: fact
---

That was a lot 😲 hardware is complex

<span v-click v-mark.underline.red>Understanding the interfaces is key</span>

<SlideIndicator />


---
layout: default
---

# 2.6 Firmware

<v-clicks depth="2">

- You need software to load software
- Software that is not installable in the classic way
- On-board in a simple chip with simple interface (just raw bytes)
- Technically "just normal" software
- Examples:
  - Interfaces: Legacy BIOS ("IBM PC"), UEFI
  - Implementation: SeaBIOS, Coreboot, EDK2
- From CPU perspective: doesn't know firmware variant

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.6 Firmware

<v-clicks depth="2">

- Bootstraps the platform ("Platform initialization")
- Brings platform and CPU into **defined state**
- Determines **interface for bootloader**
  - Executable format
  - Environment

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.6 Trivia: Intel SDM: Initialization

<v-clicks depth="2">

- Keyword: "Hardware Reset"
- 10\. Processor Management and Initialization
  - 10.1 INITIALIZATION OVERVIEW
    - 10.1.4 First Instruction Executed \
      → Hardware software co-design

</v-clicks>


---
layout: quote
---

# 2.7 UEFI

Towards a unified firmware.

<v-click>

_This Unified Extensible Firmware Interface (UEFI) Specification describes an
interface between the operating system (OS) and the platform firmware._

</v-click>
<v-click>

_\[...\]_

_The interface is in the form of data tables that contain platform-related
information, and boot and runtime service calls that are available to the OS
loader and the OS. Together, these provide a standard environment for booting
an OS._

</v-click>

<SlideIndicator />


---
layout: default
---

# 2.7 UEFI

<v-clicks depth="2">

- **U**nified **E**xtensible **F**irmware **I**nterface
- Developed by Tianocore community
- "EDK2"
  - Build system
  - Reference implementation written in C, C++, and Assembly
  - Open source on GitHub
- Other implementations exists

</v-clicks>

<SlideIndicator />


---
layout: default
---

# 2.7 UEFI

<v-clicks depth="2">

- Gives us a defined machine state
- 64-bit mode, yay!
- Only one CPU <small>("Bootstrap Processor" (BSP))</small>
- Others are ready to be woken up <small>("Application Processors" (APs))</small>
- Can load EFI images (binaries, executables)
  - Similar to starting an `.exe` on Windows
  - Stack is provided
  - UEFI functionality is callable from EFI image

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.7 UEFI

<v-clicks depth="3">

- Fixed set of functionality ("services") + variable part ("protocols")
  - Services are callable functions
  - Protocols are somewhat like interfaces in Java or traits in Rust
- Two phases
  - **Boot-Services**
    - UEFI has full control over hardware (like an OS)
    - Provide feature-rich and high(er)-level interface to hardware
    - Must be exited before OS can take over control
  - Runtime-Services
    - Tiny fraction of remaining functionality: System time, UEFI variables

</v-clicks>

<SlideIndicator />


---
layout: default
---

# 2.7 UEFI

<v-clicks depth="2">

- Identifies resources and abstracts device access with `EFI_HANDLE`s
- Handles know their associated protocols
- Technically, a protocol is a `C` struct holding functions and/or data,\
  with an associated GUID

</v-clicks>

<div v-click="3">

```c {0|1,5|2|3-4|*}{lines: true}
typedef struct _EFI_SIMPLE_FILE_SYSTEM_PROTOCOL {
 UINT64                                         Revision;
 // This is a function pointer
 EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_OPEN_VOLUME    OpenVolume;
} EFI_SIMPLE_FILE_SYSTEM_PROTOCOL;
```

</div>

<SlideIndicator />

---
layout: default
---

# 2.7 UEFI

<v-clicks depth="2">

- Boot service examples
  - `OpenProtocol()`: Tries opening a protocol on a given handle
  - `LocateHandle()`: Finds handles supporting a given protocol
- Protocol examples
  - `EFI_GRAPHICS_OUTPUT_PROTOCOL`: \
    Draw to framebuffer
  - `EFI_SIMPLE_FILE_SYSTEM_PROTOCOL`: \
    Access files

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.7 UEFI: Extensible?

By 3rd Party Hardware

<v-clicks depth="2">

- PCIe devices can advertise additional UEFI drivers ("Option ROM")
- Examples
  - An NVIDIA GPU may install the `EFI_GRAPHICS_OUTPUT_PROTOCOL` on its
    corresponding handle
  - A network card may install the `EFI_PXE_BASE_CODE_PROTOCOL` on its
    corresponding handle
- UEFI firmware may also have built-in drivers for common hardware
- We as software developers can use them

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.7 UEFI: Extensible?

By software developers

<v-clicks depth="2">

- In our OS loader, we can install protocols or use protocols on any handle
- We may chainload another bootloader (systemd boot, Windows bootloader)
- A lot of options!

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 2.8 Utilizing UEFI

<v-clicks depth="2">

- Writing your own (portable) OS-loader is easy
- Defined executable file format 🎉 (somewhat similar to `.exe`)
  - Subset of PE32+ file format (Windows' `.exe` format)
  - By default, loaded from `<drive>\EFI\BOOT\BOOTX64.EFI` (FAT partition)
- We can use extended functionality with UEFI protocols
  - `EFI_GRAPHICS_OUTPUT_PROTOCOL`: No extra GPU driver needed
  - `EFI_PXE_BASE_CODE_PROTOCOL`: No extra TCP + PXE driver needed
  - `EFI_SIMPLE_FILE_SYSTEM_PROTOCOL`: No extra NVMe or FAT driver needed
- OS-loader typically exits boot services
- Kernel has its own drivers (PCIe, NVMe)

</v-clicks>

---
layout: default
---

# 2.8 Utilizing UEFI: In a Nutshell

From Developer Perspective

<v-clicks depth="2">

- We have an OS-like environment
- Higher-level abstractions to
  - Load files
  - Access network
  - Draw to the screen
  - Get user input
- No need to fiddle with own PCIe, network drivers, or GPU drivers
- Makes loading your kernel just easy

</v-clicks>


---
layout: default
---

# 2.9 Summary

<v-clicks depth="2">

- Hardware is complex
- UEFI is de-facto standard firmware interface making things easier
  - Hardware manufacturers
  - Firmware developers
  - Software developers
- EDK2 is default UEFI implementation
- UEFI provides higher level abstractions to access e.g. files
- OS-loaders / bootloaders are EFI applications

</v-clicks>

<SlideIndicator />
