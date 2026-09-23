---
layout: chapter
chapter: Cloud Hypervisor
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
    64-bit only, virtio-based devices<sup>1</sup>
  - No display/graphics model, only basic virtual hardware
  - Live migration
- ~150.000 SLOC (including tests, scripts, etc.)
- Started 2019 in Intel, now mainly driven by Microsoft, Meta, Crusoe, Cyberus
  Technology

</v-clicks>

<div v-click="3" position="absolute" left="7ch" bottom="4ch" text="sm">
  <sup>1</sup> <em>virtio</em> = specification for (virtual) devices: guest
  knows that it is virtualized and uses drivers made for that
</div>

---
layout: default
---

# 4.2 A VMM in Rust?

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

# 4.3 Involvement of Cyberus Technology

<v-clicks depth="2">

- We are building major parts of our business around is open-source project
- "Upstream first" policy: our work goes into the public project first, \
  no private forks
- We are among the top contributors for the past 18 months

</v-clicks>

---
layout: default
---

# 4.4 What We Are Working On

Fields the whole company is involved in.

<v-clicks depth="2">

- Live migration<sup>1</sup>
- VM and vCPU lifecycle management
- Performance improvements
- Testing

</v-clicks>

<div v-click>

**My role**: upstream maintainer of live migration

</div>

<div v-click="1" position="absolute" left="7ch" bottom="4ch" text="sm">
  <sup>1</sup> Process of migrating a VM from host A to B while it keeps running
</div>


---
layout: default
---

# 4.5 Hands-on Cloud Hypervisor

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

# 4.6 My Development Flow

<v-clicks depth="2">

- Unit tests
- Live VM testing with direct kernel boot
  - I have tooling to build minimal Linux kernel and minimal initrd \
    (My own tiny Linux distribution)
  - Sufficient for 99% of my testing cases
- We have more mature integration test suites as well

</v-clicks>

