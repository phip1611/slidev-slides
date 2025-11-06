---
class: text-center
layout: cover
background: ./images/cover.png
---

# Writing an OS-Loader in Rust with uefi-rs

<div position="absolute" left="2ch" bottom="2ch" text="sm">JUG Saxony e.V. Event Series @ TU Dresden, APB &mdash; 2025-11-06</div>
<div position="absolute" right="2ch" bottom="2ch" text="sm">Philipp Schuster, Cyberus Technology</div>

---
layout: default
---

# 1. Introduction


<SlideIndicator />

---

# 1.0 Outlook

<v-clicks depth="2">

- UEFI is a firmware interface making things easier
  - Hardware manufacturers
  - Firmware developers
  - Software developers
- `uefi-rs` is a convenient library for UEFI in Rust
- Convenient high-level* abstractions for OS-loaders / bootloaders

</v-clicks>

<div v-click="6" position="absolute" left="2ch" bottom="2ch" text="sm">
*High-level from a low-level perspective. Not Python- or Java-like high-level.
</div>

<SlideIndicator />


---
layout: "two-cols-header"
---

# 1.1 About Me

::left::

<v-clicks depth="2">

- Philipp Schuster, Dresden 🇩🇪🇪🇺
- Working at Cyberus Technology as Software Engineer
- Nix and NixOS enthusiast
- Enjoy conferences and meetups
- Organizing Systems Meetup

</v-clicks>

::right::

<v-clicks>

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

</v-clicks>

<SlideIndicator />

---
layout: two-cols-header
---

# 1.2 My Rust Experience

Working with Rust since 2019.

::left::

<h3 v-click class="my-2 font-bold">
  Hobby Projects
</h3>

<v-clicks depth="2">

- [github.com/rust-osdev](https://github.com/rust-osdev)
  - `multiboot2`
  - <code v-mark.circle.red="4">uefi</code>
- Author of various smaller crates

</v-clicks>

::right::

<h3 v-click class="my-2 font-bold">
  Work Projects
</h3>

<v-clicks depth="2">

- [Cloud Hypervisor](https://github.com/cloud-hypervisor/cloud-hypervisor)
- `rust-vmm` ecosystem

</v-clicks>


<SlideIndicator />

---
layout: default
---

# 1.3 My Relation to JUG Saxony e.V.

<v-clicks depth="2">

- Started studying computer science in October 2015
- Started student software engineer ("Werkstudent") position at Telekom MMS \
  (T-Systems Multimedia Solutions GmbH)
- JUG Saxony Day
  - 2018
  - 2022 (Speaker)
  - 2025
- Personally met Falk Hartmann at EuroRust 2024 in Vienna

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 1.4 About Cyberus Technology

<v-clicks depth="2">

- Founded 2017 by 6 founders in Dresden (today ≈30)
- Independent, profitable
- World-class expertise in x86 and virtualization
- Main products
  - Cyberus Hypervisor <small>(Cloud Hypervisor + Linux/KVM + Service & Expertise)</small>
  - CTRL-OS <small>(NixOS LTS + Embedded System Building Blocks)</small>

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 1.4 About Cyberus Technology

<v-clicks depth="2">

- Cloud department
  - Public European cloud developed with SAP ("Apeiro") \
    Cyberus is responsible for virtualization layer <span text-gray>← My work</span>
  - Soon BSI*-accredited virtualization stack with open-source software
    - Cloud Hypervisor/KVM will be accredited


</v-clicks>

<div v-click="3" position="absolute" left="2ch" bottom="2ch" text="sm">* BSI: Bundesamt für Sicherheit in der Informationstechnik</div>

<SlideIndicator />

---
layout: default
---

# 1.4 My Role at Cyberus Technology

<v-clicks depth="2">

- 2021-05 -- 2022-05: Student software engineer \
  Diplomarbeit (Master's Thesis)
- 2022-06 -- present: Full time software engineer
- Everything "low in the stack"
  - Rust, C/C++, Assembly, ...
  - libvirt, Linux kernel, GRUB, UEFI/edk2...
- Nix, NixOS, and nixpkgs
- Conferences, Networking, Meetups \
  Organizing _Dresden Systems Meetup_

</v-clicks>

<SlideIndicator />

---
layout: default
---

# 1.4 My Role at Cyberus Technology

<v-clicks depth="2">

- Main contributor to Cloud Hypervisor
  - Virtual Machine Monitor (VMM) utilizing Linux/KVM
  - Akin to VirtualBox or QEMU
  - Tailored to cloud usecase
- **Virtualization requires understanding every concept of the platform and
  typical software stack.**

</v-clicks>

<SlideIndicator />


---
layout: default
---

# 1.5 What (Not) To Expect

<v-clicks depth="2">

- We have time (60 min) → no rush
- Overview of how an x86 computer works \
  → Give you a good understanding of the x86 platform.
- What is Firmware?
- UEFI: Context + Concepts
- Rust library ("crate") `uefi-rs`
- Code & Demo: Example UEFI OS-loader

</v-clicks>

<div v-click="6" position="absolute" left="2ch" bottom="2ch" text="sm">* Same thing, different name: OS-loader, OS-specific loader, bootloader</div>

<SlideIndicator />

---
layout: default
---

# 1.6 Goal of an OS Project

Why does one need to understand the firmware?

<v-clicks depth="2">

- Fully bootstrapped system (Desktop environment, sound, ...)
- Kernel running in 64-bit mode
- Firmware (UEFI) eventually leads to our kernel being loaded \
  → We need to understand UEFI

</v-clicks>

<SlideIndicator />
