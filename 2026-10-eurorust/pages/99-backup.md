---
layout: chapter
chapter: Backup
---

# B. Backup

Additional material for questions

---
layout: image
image: /images/guest-driver-and-device-model.svg
---

# B.1 Guest Drivers and Their Device Models

Every driver in the guest has a counterpart in Cloud Hypervisor

<!--
- Each driver in the guest has its counterpart in the VMM: the device model
- Same device interface on both sides, e.g., virtio-blk driver and virtio-blk
  device in Cloud Hypervisor
- [1] The driver touches a device register
- [2] That traps: VM exit into KVM
- [3] KVM_RUN returns, Cloud Hypervisor's block device model takes over
- [4] Plain Rust code does the I/O on disk.img
- [5] Next KVM_RUN: VM entry, the guest continues
-->

---
layout: image
image: /images/guest-device-access-sequence.svg
---

# B.2 The VMM Emulates Device Access

Example: the guest's disk driver submits a write request<sup>2</sup>

<Footnotes>
  <Footnote n="1">
    MMIO: memory-mapped I/O - device registers at addresses without RAM;
    accessing them causes a VM exit
  </Footnote>
  <Footnote n="2">
    Real virtio devices batch many requests per VM exit and signal completion
    via an interrupt
  </Footnote>
</Footnotes>

---
layout: image
image: /images/virtualization-stacks-side-by-side.svg
---

# B.3 Always the Same Shape

A VMM in user space, a hypervisor in the kernel - only the parts differ

<!--
- VMware and VirtualBox ship both halves: their own VMM and their own kernel
  module
- With KVM the hypervisor is already part of the kernel - Cloud Hypervisor,
  QEMU, and even VirtualBox (KVM backend) are just programs on top of it
- One hypervisor, many VMMs - the VMM is exchangeable
-->
