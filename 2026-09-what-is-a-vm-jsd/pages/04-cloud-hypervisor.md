---
layout: chapter
chapter: Cloud Hypervisor
---

# 4. Cloud Hypervisor

<!--
- The concrete product now - everything from chapter 3 applies 1:1
-->
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

<!--
- [CLICK] Official definition
- [CLICK] Rust, cloud workloads
- [CLICK] No legacy, virtio
- [CLICK] No graphics
- [CLICK] Live migration
- [CLICK] ~150k lines
- [CLICK] Intel, now Microsoft/Meta

Beyond the slide:
- virtio = paravirtualization: the guest knows it is virtualized and uses
  drivers made for that - far fewer VM exits than emulating real hardware
- QEMU is ~1.5M lines and emulates floppy drives; CH deliberately does not
- A small code base is reviewable - which is what an accreditation needs
-->
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

<!--
- [CLICK] Mature language
- [CLICK] Fearless contributions
- [CLICK] IDE support
- [CLICK] Easy onboarding
- [CLICK] Complex domain, approachable

Beyond the slide:
- For this audience: memory safety without a GC and without a runtime
- A VMM bug breaks the isolation we sell - safety is a security property here
- unsafe code exists where we touch hardware: small, isolated, reviewed
- One toolchain (cargo, clippy, rustfmt) instead of five
-->
---
layout: default
---

# 4.3 Involvement of Cyberus Technology

<v-clicks depth="2">

- We are building major parts of our business around this open-source project
- "Upstream first" policy: our work goes into the public project first, \
  no private forks
- We are among the top contributors for the past 18 months

</v-clicks>

<!--
- [CLICK] Business builds on it
- [CLICK] Upstream first
- [CLICK] Top contributors

Beyond the slide:
- No private forks: no divergence, no rebase hell
- Customers can verify what they actually run
- A small company from Dresden shapes a project driven by Microsoft and Meta
-->
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

<!--
- [CLICK] Live migration
- [CLICK] Lifecycle management
- [CLICK] Performance
- [CLICK] Testing
- [CLICK] My role: maintainer

Beyond the slide:
- Live migration makes host maintenance invisible to the customer
- The hard part is memory: copy it while the guest keeps writing to it
- Maintaining means reviewing other people's patches more than writing my own
-->
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

<!--
- [CLICK] CLI, spawning a VM
- [CLICK] Networking
- [CLICK] Live debugging
- [CLICK] Live migration

- Keep it short - this is only the agenda for the demo
-->
---
layout: cover
---

DEMO TIME

<!--
- Switch to the terminal; boot a VM first, they should see how fast it is
- Then gdb on the running VMM: show the vCPU threads from chapter 3
- If something breaks: keep talking, the backup slides are at the end

host: sudo ip tuntap add dev tap0 mode tap; sudo ip addr add dev tap0 192.168.200.1/24; sudo ip link set dev tap0 up
guest: sudo ip addr add dev eth0 192.168.200.2/24; sudo ip link set dev eth0 up
-->

---
layout: default
---

# 4.6 Recording: Networking into the Guest

<SlidevVideo controls autoplay="once" autoreset="slide" muted class="demo-video">
  <source src="/videos/jug26-recording-ch-networking.webm" type="video/webm">
</SlidevVideo>

<!--
- The recorded version of the networking demo - also the fallback if the live
  one fails
- tap device on the host, one IP on each side, then ping and ssh into the guest
- Point out: from the guest's view this is a normal NIC (virtio-net)
-->

---
layout: default
---

# 4.7 Recording: Live Migration

<SlidevVideo controls autoplay="once" autoreset="slide" muted class="demo-video">
  <source src="/videos/jug26-recording-ch-livemig.webm" type="video/webm">
</SlidevVideo>

<!--
- The VM keeps running while it moves from host A to host B
- Watch the guest console: it does not notice the move
- The part I maintain upstream - memory is copied while the guest writes to it
-->

---
layout: default
---

# 4.8 My Development Flow

<v-clicks depth="2">

- Unit tests
- Live VM testing with direct kernel boot
  - I have tooling to build minimal Linux kernel and minimal initrd \
    (My own tiny Linux distribution)
  - Sufficient for 99% of my testing cases
- We have more mature integration test suites as well

</v-clicks>

<!--
- [CLICK] Unit tests
- [CLICK] Direct kernel boot
- [CLICK] Minimal kernel, initrd
- [CLICK] 99% of cases
- [CLICK] Integration suites

Beyond the slide:
- Direct kernel boot skips firmware and bootloader - sub-second boots
- The fast feedback loop is what makes low-level work bearable
- This is also how I reproduce and debug customer issues
-->
