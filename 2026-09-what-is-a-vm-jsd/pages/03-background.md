---
layout: chapter
chapter: Background
---

# 3. Background

---
layout: default
---

# 3.0 Terminology: Hypa Hypa Hypervisor?

Many different wordings out there. I prefer these fine-grained definitions:

<v-clicks depth="2">

- **Hypervisor**: Privileged software component running in kernel-space \
  (e.g. Linux/KVM)
- **Virtual Machine Monitor (VMM)**: Unprivileged software component \
  (like a regular user-space application, e.g. _Cloud Hypervisor_)
- **Virtualization Stack**: Hypervisor + VMM \[+ Management Software\]
- **Guest**: Software running in a VM (OS + user applications), e.g. Windows or Debian

</v-clicks>

---
layout: fact
---

## 3.1 What is Virtualization?

<v-clicks depth="2">

Virtualization is the abstraction of a physical (or otherwise underlying)
resources into (multiple) virtual instances so that they can act independently.

</v-clicks>

---
layout: default
---

# 3.2 What is a VM?

<v-clicks depth="2">

- Java Virtual Machine?
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

---
layout: image
image: /images/terminology-who-is-who.svg
---

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


---
layout: image
image: /images/containers-vs-vms-isolation-security-boundary.svg
---

---
layout: default
---

# 3.4 Containers and VMs in a Typical Cloud Setup

When to use what?

---
layout: image
image: /images/cloud-vms-vs-containers-what-customers-buy.svg
transition: undefined
---

---
layout: image
image: /images/cloud-vms-vs-containers-what-customers-buy--blurred.svg
transition: slide-up
---

---
layout: default
---

# 3.5 Why VMs?

<v-clicks depth="2">

- For infrastructure providers
  - Run workloads with strict isolation on shared hardware (multi tenancy)
  - Utilize host hardware (€ / $)
- For developers
  - An environment that can be easily deployed
  - Or messed up and redeployed
  - Bring your own OS (and kernel/drivers)

</v-clicks>

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

---
layout: image
image: /images/from-host-vmm-process-to-vm-guest.svg
---

---
layout: default
---

# 3.7 Detour: How Does Hardware Access Work?

Software talks to a device - on real hardware and in a VM alike.

<v-clicks depth="2">

- Read/write access to/from physical memory addresses ("MMIO regions") \
  or I/O ports
- These are accesses with **side effects**: they talk to a device

</v-clicks>

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

---
layout: default
---

# 3.9 What does a VMM need to create a VM?

Simplified.

<v-clicks depth="3">

- Add (virtual) hardware, e.g. to the PCI bus
- Configures the guest physical memory space so that:
  - Accessing guest RAM just works
  - Accessing an MMIO region (a virtual device) leaves the VM ("VM exit")
- On such a VM exit:
  - The hypervisor handles it if it can, otherwise the VMM does
  - Afterwards, the vCPU thread enters the VM again

</v-clicks>

---
layout: image
image: /images/vmm-provides-virtual-device.svg
---


---
layout: default
transition: undefined
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

---
layout: default
transition: slide-up
---

# 3.10 Linux KVM

_**K**ernel-based **V**irtual **M**achine_

<v-clicks depth="3">

- Entry point to KVM: `/dev/kvm`
  - `open("/dev/kvm")` → KVM system FD
  - `ioctl(kvm_fd, KVM_CREATE_VM, ...)` → VM FD
  - `ioctl(vm_fd, KVM_CREATE_VCPU, ...)` → vCPU FD
  - A vCPU thread calls `ioctl(vcpu_fd, KVM_RUN, 0)`
  - The physical CPU running that thread then executes guest code \
    (using hardware virtualization features)
- That's it :)

</v-clicks>

<!--
Interesting links:
- https://elixir.bootlin.com/linux/v7.2.6/source/virt/kvm/kvm_main.c#L4441
- https://elixir.bootlin.com/linux/v7.2.6/source/arch/x86/kvm/x86.c#L10970
- https://elixir.bootlin.com/linux/v7.2.6/source/arch/x86/kvm/vmx/vmx.c#L7481
- https://elixir.bootlin.com/linux/v7.2.6/source/arch/x86/kvm/vmx/vmenter.S#L106
-->

---
layout: default
transition: undefined
---

# 3.11 CH vs. QEMU vs. VirtualBox vs. VMware

VMMs and Hypervisors in comparision.

---
layout: image
image: /images/virtualization-stacks-side-by-side.svg
transition: slide-up
---

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
- Overview figure:

</v-clicks>
