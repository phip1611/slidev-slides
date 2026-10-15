---
layout: chapter
chapter: Background
---

# 2. Background

About Cloud Hypervisor, Virtualization, and Bits & Bytes.

<!--

-->

---
layout: default
---

# 2.1 Some Relevant Terminology

Hypa, hypa, hypervisor? Naming things is hard.

<v-clicks>

- **Hypervisor**: Privileged software component running in kernel-space \
  (e.g., KVM<sup>1</sup> or vboxdrv)
- **Virtual Machine Monitor (VMM)**: Unprivileged software component \
  (like a regular user-space application, e.g., QEMU, VirtualBox<sup>2</sup>, Cloud Hypervisor)
- **Cloud Hypervisor (CH)**: A VMM written in Rust, supporting KVM as hypervisor \
  (Naming things is hard! 🫨)
- **Virtualization Stack**: Hypervisor + VMM \[+ Management Software\]
- **vCPU**: Abstraction of a physical CPU: hardware state + management state
- **Guest**: Software running in a VM (OS + user applications), e.g., Windows or Debian

</v-clicks>

<Footnotes>
  <Footnote n="1" v-click="1">
    Linux <b>K</b>ernel-based <b>V</b>irtual <b>M</b>achine.
  </Footnote>
  <Footnote n="2" v-click="2">
    By default using vboxdrv as hypervisor, but a KVM backend exists.
  </Footnote>
</Footnotes>

---
layout: default
---

# 2.2 About Cloud Hypervisor (CH)

<v-clicks>

- Open source VMM<sup>1</sup> written in Rust
- Started in 2019, now has ~12 regular contributors
- Main organizations: Cyberus Technology, Meta, Crusoe, Microsoft, SAP, ...
- Roughly 100,000 SLOC without tests and documentation
- Focus on modern<sup>2</sup> cloud workloads (`x86_64`, `aarch64`)
- Runs on Linux exclusively (independent of the supported guests<sup>3</sup>)
- Run a (strongly) isolated system with a modern and secure Rust code base
- Safer alternative to QEMU, VirtualBox, VMware \
  (only if you do not need a display - CH is for headless guests)

</v-clicks>

<Footnotes>
  <Footnote n="1" v-click="1">
    <b>V</b>irtual <b>M</b>achine <b>M</b>onitor: the software running and
    managing your VM (lifecycle, virtual devices, memory, and CPUs)
  </Footnote>
  <Footnote n="2" v-click="5">
    Only few legacy devices. For example, no Windows XP.
  </Footnote>
  <Footnote n="3" v-click="6">
    Guest: the software running inside a VM. Ubuntu, NixOS, Windows Server, ...
  </Footnote>
</Footnotes>

---
layout: two-cols-header
---

# 2.3 What Is a (Cloud Hypervisor) VM

From a technical perspective: **View from inside the VM**

::left::

<v-clicks>

- A normal computer \
  (e.g., `x86_64` on a `x86_64` host)
- Needs no knowledge it runs virtualized
- OS takes ownership of hardware
- Discovers RAM and devices \
  (PCIe: disks, network)

</v-clicks>

::right::

<GuestViewFigure />

---
layout: two-cols-header
---

# 2.4 What Is a (Cloud Hypervisor) VM

From a technical perspective: **View from host**

::left::

<v-clicks>

- A process running on your system \
  (akin to Firefox, Chrome, rustc)
- vCPUs<sup>1</sup> are threads of that process
- Guest RAM is memory of that process
- Disks, network, etc. are backed by host resources
- Multiple VMs → multiple CH processes

</v-clicks>

::right::

<HostViewFigure />

<Footnotes>
  <Footnote n="1" v-click="2">
    <b>vCPU</b>: virtual CPU - abstraction of a physical CPU: 1 vCPU → 1 CPU in
    the guest
  </Footnote>
</Footnotes>

---
layout: default
---

# 2.5 What Is a Running Cloud Hypervisor Instance

And its responsibilities

<v-clicks depth="2">

- A running instance of Cloud Hypervisor manages at most one VM: \
  Either boot directly or wait for incoming API request
- Handle VM lifecycle
  - External events: boot VM from config, reboot, destroy VM, ...
  - Guest induced events: shutdown, reboot/reset
- Manages vCPUs (virtual CPUs)
  - **Abstraction** of a physical CPU in the guest: 1 vCPU → 1 CPU in guest
  - Hardware registers (real hardware state) + management state
  - Uses KVM to run the guest code on hardware
  - Handles vCPUs trapping: for example to emulate hardware access
  - 1 vCPU → needs one thread ("vCPU thread")

</v-clicks>

---
layout: image
image: /images/linux-thread-vs-vcpu-thread-1.svg
transition: none # build-up step
---

# 2.6 Normal Linux Thread vs. vCPU Thread + KVM

---
layout: image
image: /images/linux-thread-vs-vcpu-thread-2.svg
transition: none # build-up step
---

# 2.6 Normal Linux Thread vs. vCPU Thread + KVM

---
layout: image
image: /images/linux-thread-vs-vcpu-thread-3.svg
transition: none # build-up step
---

# 2.6 Normal Linux Thread vs. vCPU Thread + KVM

---
layout: image
image: /images/linux-thread-vs-vcpu-thread-4.svg
transition: none # build-up step
---

# 2.6 Normal Linux Thread vs. vCPU Thread + KVM

---
layout: image
image: /images/linux-thread-vs-vcpu-thread-5.svg
transition: none # build-up step
---

# 2.6 Normal Linux Thread vs. vCPU Thread + KVM

<Footnotes>
  <Footnote n="1">
    <code>vmx</code>: VM entry, e.g., the <code>vmresume</code> instruction on
    Intel CPUs with VMX
  </Footnote>
  <Footnote n="2" invisible>
    Guest mode: CPU mode for running VM code (Intel: VMX non-root mode)
  </Footnote>
  <Footnote n="3" invisible>
    VM exit: the CPU leaves guest mode, e.g., on sensitive instructions or
    device access, and returns control to KVM
  </Footnote>
</Footnotes>

---
layout: image
image: /images/linux-thread-vs-vcpu-thread-6.svg
transition: none # build-up step
---

# 2.6 Normal Linux Thread vs. vCPU Thread + KVM

<Footnotes>
  <Footnote n="1">
    <code>vmx</code>: VM entry, e.g., the <code>vmresume</code> instruction on
    Intel CPUs with VMX
  </Footnote>
  <Footnote n="2">
    Guest mode: CPU mode for running VM code (Intel: VMX non-root mode)
  </Footnote>
  <Footnote n="3" invisible>
    VM exit: the CPU leaves guest mode, e.g., on sensitive instructions or
    device access, and returns control to KVM
  </Footnote>
</Footnotes>

---
layout: image
image: /images/linux-thread-vs-vcpu-thread-7.svg
transition: none # build-up step
---

# 2.6 Normal Linux Thread vs. vCPU Thread + KVM

<Footnotes>
  <Footnote n="1">
    <code>vmx</code>: VM entry, e.g., the <code>vmresume</code> instruction on
    Intel CPUs with VMX
  </Footnote>
  <Footnote n="2">
    Guest mode: CPU mode for running VM code (Intel: VMX non-root mode)
  </Footnote>
  <Footnote n="3" invisible>
    VM exit: the CPU leaves guest mode, e.g., on sensitive instructions or
    device access, and returns control to KVM
  </Footnote>
</Footnotes>

---
layout: image
image: /images/linux-thread-vs-vcpu-thread-8.svg
transition: none # build-up step
---

# 2.6 Normal Linux Thread vs. vCPU Thread + KVM

<Footnotes>
  <Footnote n="1">
    <code>vmx</code>: VM entry, e.g., the <code>vmresume</code> instruction on
    Intel CPUs with VMX
  </Footnote>
  <Footnote n="2">
    Guest mode: CPU mode for running VM code (Intel: VMX non-root mode)
  </Footnote>
  <Footnote n="3">
    VM exit: the CPU leaves guest mode, e.g., on sensitive instructions or
    device access, and returns control to KVM
  </Footnote>
</Footnotes>

---
layout: image
image: /images/linux-thread-vs-vcpu-thread-9.svg
---

# 2.6 Normal Linux Thread vs. vCPU Thread + KVM

<Footnotes>
  <Footnote n="1">
    <code>vmx</code>: VM entry, e.g., the <code>vmresume</code> instruction on
    Intel CPUs with VMX
  </Footnote>
  <Footnote n="2">
    Guest mode: CPU mode for running VM code (Intel: VMX non-root mode)
  </Footnote>
  <Footnote n="3">
    VM exit: the CPU leaves guest mode, e.g., on sensitive instructions or
    device access, and returns control to KVM
  </Footnote>
</Footnotes>
