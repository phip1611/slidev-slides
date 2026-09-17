---
layout: chapter
---

# 4. Cloud Hypervisor

---
layout: default
---

# 4.1 What is Cloud Hypervisor?

<v-clicks depth="2">

- _Cloud Hypervisor is an open source **Virtual Machine Monitor (VMM)** that
  runs on top of the **KVM hypervisor**_ - Naming is complicated 🤷‍♀️
- Modern VMM written in Rust modern Cloud workloads
  - Almost no legacy devices,
    64-bit only, paravirtualized virtio-based devices
  - No display/graphics model, only basic virtual hardware (unlike QEMU or
    VirtualBox)
- ~150.000 SLOC (including tests, scripts, etc.)
- Still feature-rich
- Started 2019 in Intel, now mainly driven by Microsoft, Meta, Crusoe, Cyberus
  Technology

</v-clicks>

---
layout: default
---

# 4.2 Involvement of Cyberus Technology

And my role in the project.

<v-clicks depth="2">

- We are building major parts of our business around is open-source project
- "Upstream first" policy
- We are among the top contributors for the past 18 months
- I am maintaining live migration<sup>1</sup>

</v-clicks>


<div v-click="4" position="absolute" left="7ch" bottom="4ch" text="sm">
  <sup>1</sup> Process of migrating a VM from host A to B while it keeps running
</div>


---
layout: default
---

# 4.3 A VMM in Rust?

About developer productivity, safety, and robustness out of this world.

<v-clicks depth="2">

- Rust is a mature language: learnings from decades of pain with C++ as
  language and corresponding toolchains
- Fearless contributions via streamlined unit testing and high code quality
- Fantastic IDE support
- Easy onboarding of new engineers
- Easy to approach language for complex domain: encapsulate complexity with ease

</v-clicks>


---
layout: default
---

# 4.4 Hands-on Cloud Hypervisor

Spawning VMs and debugging!

<v-clicks depth="2">

- CLI and spawning a VM
- Networking into the guest
- Some Live Debugging & daily workflows
- Live Migration

</v-clicks>


---
layout: cover
---

DEMO TIME

<!--
host: sudo ip tuntap add dev tap0 mode tap; sudo ip addr add dev tap0 192.168.200.1/24; sudo ip link set dev tap0 up
guest: sudo ip addr add dev eth0 192.168.200.2/24; sudo ip link set dev eth0 up
-->

---
layout: default
---

# 4.5 My Development Flow

<v-clicks depth="2">

- Unit tests
- Live VM testing with direct kernel boot
  - I have tooling to build minimal Linux kernel and minimal initrd \
    (My own tiny Linux distribution)
  - Sufficient for 99% of my testing cases
- We have more mature integration test suites as well

</v-clicks>

