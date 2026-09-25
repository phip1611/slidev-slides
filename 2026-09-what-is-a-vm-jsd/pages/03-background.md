---
layout: chapter
chapter: Background
---

# 3. Background

<!--
- Technical from here on - terminology first
- If one term stays unclear, everything after it stays unclear
-->
---
layout: default
---

# 3.0 Terminology: Hypa Hypa Hypervisor?

Many different wordings out there. I prefer these fine-grained definitions:

<v-clicks depth="2">

- **Hypervisor**: Privileged software component running in kernel-space \
  (e.g. Linux/KVM)
- **Virtual Machine Monitor (VMM)**: Unprivileged software component \
  (like a regular user-space application)
- **Cloud Hypervisor (CH)**: A VMM written in Rust, using Linux/KVM \
  (Naming things is hard! 🫨)
- **Virtualization Stack**: Hypervisor + VMM \[+ Management Software\]
- **Guest**: Software running in a VM (OS + user applications), e.g. Windows or Debian

</v-clicks>

<!--
- [CLICK] Hypervisor: kernel space
- [CLICK] VMM: user space
- [CLICK] Cloud Hypervisor: a VMM
- [CLICK] Stack: both together
- [CLICK] Guest: Windows, Debian

Beyond the slide:
- The industry mixes these words; many say "hypervisor" for the whole stack
- If they remember two: hypervisor in the kernel, VMM in user space
-->
---
layout: fact
---

## 3.1 What is Virtualization?

<v-clicks depth="2">

Virtualization is the abstraction of a physical (or otherwise underlying)
resources into (multiple) virtual instances so that they can act independently.

</v-clicks>

<!--
- [CLICK] The definition

Beyond the slide:
- Not only CPUs: virtual memory, virtual networks, even the JVM fit
- "Independently" is the word that carries isolation
-->
---
layout: default
---

# 3.2 What is a VM?

<v-clicks depth="2">

- Java Virtual Machine? 🤔
  - Virtual in the sense that it defines an abstract machine (the Java bytecode)
  - A Java Runtime (JRE) implements the Java Virtual Machine + runtime libraries
- Virtual Machine (this talk):
  - Environment like the host but encapsulated
  - Abstracting the host hardware to create multiple execution environments
  - Behave like the normal host computing platform for the guest<sup>1</sup>
- **Hardware-assisted virtualization** (<span v-mark="{at: 9, type: 'underline', color: '#d61515'}">Hardware-accelerated VM</span>)
  - Hardware (CPU) offers features to run guests directly on the CPU \
    (Alternative would be emulation → slow)
  - For example: Intel VMX, AMD SVM

</v-clicks>

<div v-click="7" position="absolute" left="7ch" bottom="4ch" text="sm"><sup>1</sup> the software (operating system) running in the VM</div>

<!--
- [CLICK] Java Virtual Machine
- [CLICK] Abstract machine: bytecode
- [CLICK] JRE implements it
- [CLICK] Our VM: different
- [CLICK] Like the host, encapsulated
- [CLICK] Many environments, one host
- [CLICK] Looks like real hardware
- [CLICK] Hardware-assisted
- [CLICK] Otherwise emulation, slow
- [CLICK] Intel VMX, AMD SVM

Beyond the slide:
- The JVM is the bridge: it abstracts bytecode, we abstract hardware
- Emulation (QEMU TCG) is orders of magnitude slower
- VMX/SVM sit in every consumer CPU since ~2006 - that changed everything
-->
---
layout: image
image: /images/terminology-who-is-who.svg
---

<!--
- Who is who: guest, VMM, hypervisor, hardware
- Point at the user-space / kernel-space boundary
- The sentence: the hypervisor enforces, the VMM implements
-->
---
layout: default
---

# 3.3 Isolation of Workloads: Containers vs. VMs

Why VMs when we have Containers?!

<v-clicks depth="2">

- Container (e.g., Docker / OCI): \
  Isolation boundary is enforced by the trusted shared host kernel
- VM: \
  Stronger isolation boundary enforced by hypervisor with hardware support

</v-clicks>

<!--
- [CLICK] Container: kernel enforces
- [CLICK] VM: hypervisor enforces

Beyond the slide:
- Say it clearly: Linux runs in both cases - a container is just processes with
  namespaces and cgroups
- Attack surface: the whole syscall interface vs. a handful of KVM exits
- One kernel bug can cross between customers
-->
---
layout: image
image: /images/containers-vs-vms-isolation-security-boundary.svg
---

<!--
- Dashed amber = kernel-enforced, thick green = hypervisor-enforced
- Box height = weight: a VM carries its own kernel
- Blue = what the customer takes care of
-->
---
layout: default
---

# 3.4 Containers and VMs in a Typical Cloud Setup

When to use what?

Let's have a look at the following figure:

<!--
- Transition: ask the question, let the figures answer it
- Ask the room: who deploys containers? who rents VMs?
-->
---
layout: image
image: /images/cloud-vms-vs-containers-what-customers-buy-1.svg
transition: undefined
---

<!--
- What each customer orders: A a VM, B and C containers
- A gets an empty machine and brings their own stack

Beyond the slide:
- This is the mental model most developers have - and it is incomplete
-->
---
layout: image
image: /images/cloud-vms-vs-containers-what-customers-buy-2.svg
transition: undefined
---

<!--
- Reality: one physical host, one VM per customer
- Never two customers in one VM

Beyond the slide:
- Typical setup, not a law of nature
- The container platform is itself just a tenant of the provider
-->
---
layout: image
image: /images/cloud-vms-vs-containers-what-customers-buy-3.svg
transition: slide-up
---

<!--
- Inside: A owns the kernel, B and C get runtime + their own kernel
- The VM boundary separates the customers, not the container

Beyond the slide:
- Container customers pay for a VM - they just never see it
- That is why hypervisors matter even if you never touch one
-->
---
layout: default
---

# 3.5 Why VMs?

<v-clicks depth="2">

- For infrastructure providers
  - Run workloads with strict isolation on shared hardware (multi tenancy)
  - Utilize host hardware (€ / $)
- For developers
  - Bring your own OS (and kernel/drivers)
  - An environment that can be easily deployed
  - Or messed up and redeployed

</v-clicks>

<!--
- [CLICK] Providers
- [CLICK] Isolation, multi-tenancy
- [CLICK] Utilize hardware
- [CLICK] Developers
- [CLICK] Easy to deploy
- [CLICK] Easy to redo
- [CLICK] Own OS and kernel

Beyond the slide:
- Idle cores cost money - multi-tenancy is the provider's whole business
- Snapshots, live migration and overcommit only work because it is a VM
- For us the isolation argument is the one that sells
-->
---
layout: default
---

# 3.6 What Is a VM (Technically)?

From the perspective of the host platform (hypervisor).

<v-clicks depth="2">

- One VM ←→ One VMM<sup>1</sup> process
- One thread per vCPU<sup>2</sup>
- Multiple VMs → multiple VMM processes → all sharing same hypervisor

</v-clicks>

<div v-click="1" position="absolute" left="7ch" bottom="6ch" text="sm"><sup>1</sup> one instance of Cloud Hypervisor (or QEMU, VirtualBox, ...)</div>
<div v-click="2" position="absolute" left="7ch" bottom="4ch" text="sm"><sup>2</sup> <em>virtual CPU</em>: a CPU of the VM - for the guest it looks and behaves like a real one</div>

<!--
- [CLICK] One VM, one process
- [CLICK] One thread per vCPU
- [CLICK] Many VMs, one hypervisor

Beyond the slide:
- Visible in htop; you can SIGKILL, strace and gdb it - that demystifies it
- The Linux scheduler treats vCPU threads like any other thread
- Footnotes: VMM instance = CH/QEMU/VirtualBox; a vCPU looks real to the guest
-->
---
layout: image
image: /images/from-host-vmm-process-to-vm-guest.svg
---

<!--
- Follow the path: host process → vCPU thread → guest code on a real CPU
- Point at the thread entering the VM and coming back on an exit
-->
---
layout: default
---

# 3.7 Detour: How Does Hardware Access Work?

Software talks to a device - on real hardware and in a VM alike.

<v-clicks depth="2">

- Read/write access to/from physical memory addresses (MMIO<sup>1</sup>) or I/O ports<sup>2</sup>
- These are accesses with **side effects**: they talk to a device

</v-clicks>

<div v-click="1" position="absolute" left="7ch" bottom="6ch" text="sm"><sup>1</sup> <em>Memory-Mapped I/O</em>: device registers mapped into the physical address space</div>
<div v-click="1" position="absolute" left="7ch" bottom="4ch" text="sm"><sup>2</sup> <em>I/O ports</em>: a separate x86 address space, accessed with the <code>in</code> and <code>out</code> instructions</div>

<!--
- [CLICK] MMIO and I/O ports
- [CLICK] Accesses with side effects

Beyond the slide:
- A RAM write lands in memory, an MMIO write makes a device act
- Exactly these accesses can be trapped - that is the hook for virtualization
- Keep it short, it is a detour, but the next slides need it
-->
---
layout: default
---

# 3.8 What Is a VM (Technically)?

From the perspective of the guest (code running on CPU inside VM).

<v-clicks depth="2">

- Normal x86 platform
- Normal boot flow to initialize the system
- Accesses hardware as it would in a baremetal system

</v-clicks>

<!--
- [CLICK] Normal x86 platform
- [CLICK] Normal boot flow
- [CLICK] Like bare metal

Beyond the slide:
- The guest need not know it is virtualized - except virtio (chapter 4)
- That is why unmodified Windows or Debian images just run
-->
---
layout: default
---

# 3.9 What does a VMM need to create a VM?

The thing that runs your VM. Simplified.

<v-clicks depth="3">

- VMM: Manages virtual hardware and lifecycle of a VM
- Provide at least one vCPU
  - Abstraction of the VMM to handle CPU state in software
  - VMM uses KVM to put that state into the hardware on VM entry
- Configures each vCPUs registers as a real CPU would execute code \
  (The hardware will then set the registers accordingly and execute guest code)

</v-clicks>

<!--
- [CLICK] VMM: hardware, lifecycle
- [CLICK] At least one vCPU
- [CLICK] CPU state in software
- [CLICK] KVM loads it
- [CLICK] Hardware runs guest code

Beyond the slide:
- "Simplified" is honest: interrupt controllers, timers and CPUID are skipped
- In Cloud Hypervisor this is a few hundred lines of Rust, not magic
-->
---
layout: default
---

# 3.9 What does a VMM need to create a VM?

Simplified.

<v-clicks depth="3">

- Add (virtual) hardware, e.g. to the PCI bus
- Configures the guest physical memory space so that:
  - Accessing guest RAM just works
  - Accessing an MMIO<sup>1</sup> region (a virtual device) leaves the VM ("VM exit")
- On such a VM exit:
  - The hypervisor handles it if it can, otherwise the VMM does
  - Afterwards, the vCPU thread enters the VM again

</v-clicks>

<div v-click="4" position="absolute" left="7ch" bottom="4ch" text="sm"><sup>1</sup> <em>Memory-Mapped I/O</em>: device registers mapped into the physical address space</div>

<!--
- [CLICK] Virtual devices, PCI
- [CLICK] Guest physical memory
- [CLICK] RAM: full speed
- [CLICK] MMIO: VM exit
- [CLICK] On a VM exit
- [CLICK] Hypervisor, else VMM
- [CLICK] Re-enter the VM

Beyond the slide:
- Technically EPT violations, like a page fault for guest physical memory -
  deliberately not on the slide, mention it only if asked
- An exit costs thousands of cycles - that is why virtio exists
- Enter → exit → handle → enter is the heart of the whole thing
-->
---
layout: image
image: /images/vmm-provides-virtual-device.svg
---

<!--
- The VMM provides the device, the guest uses it like real hardware
- One access: MMIO write → exit → VMM emulates → re-enter
-->
---
layout: default
---

# 3.10 Linux KVM

_**K**ernel-based **V**irtual **M**achine_

<v-clicks depth="3">

- Part of Linux (since 2.6.20 in 2007)
- Hypervisor in Linux kernel
- Abstraction layer:
  - Hardware virtualization (Intel VMX, AMD SVM)
  - vCPU in VMM → Linux thread → physical CPU executing guest code

</v-clicks>

<!--
- [CLICK] In Linux since 2007
- [CLICK] Hypervisor in the kernel
- [CLICK] Abstraction layer
- [CLICK] Over VMX and SVM
- [CLICK] vCPU, thread, CPU

Beyond the slide:
- KVM provides mechanisms and enforces separation, but is useless on its own:
  without a VMM there is no VM
- Every Linux laptop in this room already has it - nothing to install
-->
---
layout: default
transition: undefined
---

# 3.11 CH vs. QEMU vs. VirtualBox vs. VMware

VMMs and Hypervisors in comparison.

<!--
- Ask what the difference between the four is - let them guess first
-->
---
layout: image
image: /images/virtualization-stacks-side-by-side.svg
transition: slide-up
---

<!--
- Left to right: same hardware, different split between VMM and hypervisor
- CH and QEMU use Linux/KVM; VirtualBox and VMware bring their own

Beyond the slide:
- QEMU is the swiss army knife (emulation, many architectures, legacy devices)
- Cloud Hypervisor is the focused modern one - the next chapter
-->
---
layout: default
---

# 3.12 Recap

<v-clicks depth="2">

- VM: isolated computing environment, behaving like the host platform
  - Easy to deploy software to (and mess-up and retry) compared to full real hardware
- VM: VMM + Hypervisor \
  Cloud Hypervisor + Linux/KVM
- 1 host thread → 1 vCPU → 1 CPU in VM
- Most implementation work happens inside the VMM
- We'll focus in Cloud Hypervisor (VMM) with Linux/KVM (hypervisor) in the following

</v-clicks>

<!--
- [CLICK] Isolated environment
- [CLICK] Easier than hardware
- [CLICK] VMM + hypervisor
- [CLICK] Thread, vCPU, CPU
- [CLICK] Work sits in VMM
- [CLICK] Next: CH and KVM

Beyond the slide:
- One sentence to remember: the hypervisor enforces, the VMM implements
- Good moment to breathe and take a question from the room
-->
