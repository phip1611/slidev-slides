---
class: text-center
layout: cover
background: /images/cover.png
---

# Rust and OS Development

## An Overview

<div position="absolute" left="2ch" bottom="2ch" text="sm">
  Rust Dresden Meetup, 2026-06-18
</div>
<div position="absolute" right="2ch" bottom="2ch" text="sm">
  Philipp Schuster, Cyberus Technology
</div>

---
layout: default
---

# 1.1 About this Talk

<v-clicks depth="2">

- Rust is well-suited for OS development from early on
- Many popular projects adopted Rust \
  (kernels, firmware, critical user-space software)
- Rich ecosystem with many crates: [github.com/rust-osdev](https://github.com/rust-osdev)
- Provide an overview of low-level and OS development
- Selected code examples

</v-clicks>

<SlideIndicator />

---
layout: two-cols-header
---

# 1.2 About Me

::left::

<v-clicks depth="2">

- Philipp Schuster, Dresden 🇩🇪🇪🇺
- Working at Cyberus Technology as Software Engineer
- Nix and NixOS enthusiast
- Enjoy conferences and meetups
- Organizing the [Systems Meetup](https://ukvly.org/) in Dresden

</v-clicks>

::right::

<v-clicks depth="2">

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
layout: default
---

# 1.3 My Rust Experience

Working with Rust since 2019.

<v-clicks depth="2">

- Main focus: x86 virtualization
  - Virtual Machine Monitor (VMM) called _Cloud Hypervisor_
  - Linux/KVM in kernel-space
  - Akin to VirtualBox which most of you probably know
- Developing and maintaining core digital infrastructure
  - Firmware interaction
  - Kernels
  - (Core) user-space components

</v-clicks>

<SlideIndicator />


---
layout: two-cols-header
---

# 1.4 My Rust Experience: Some Crates

::left::

<h3 v-click class="my-2 font-bold">
  Hobby Projects
</h3>

<v-clicks depth="2">

- [github.com/rust-osdev](https://github.com/rust-osdev)
  - `multiboot2`
  - `uefi`
  - `uart_16550`
- Author of various smaller crates
  - `tar_no_std`

</v-clicks>

::right::

<h3 v-click class="my-2 font-bold">
  Work Projects
</h3>

<v-clicks depth="2">

- [Cloud Hypervisor](https://github.com/cloud-hypervisor/cloud-hypervisor)
- `rust-vmm` ecosystem
  - `kvm-bindings`
  - `kvm-ioctls`

</v-clicks>


<SlideIndicator />
