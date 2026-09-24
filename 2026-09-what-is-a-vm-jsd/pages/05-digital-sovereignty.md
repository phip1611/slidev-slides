---
layout: chapter
chapter: Digital Sovereignty
---

# 5. Digital Sovereignty for Core Digital Infrastructure

Virtualization made in Saxony by Cyberus Technology

<!--
- Back from the technology to why it matters
- Everything you just saw is built here, not imported
-->
---
layout: default
---

# 5.1 Virtualization Made in Saxony

<v-clicks depth="2">

- No need for big US-based companies
- We build core digital infrastructure here in Dresden
- **BSI-accredited ("Zulassung") for _VS-NfD_ and _NATO Restricted_** 🎉 \
  <small>(Since September 15th 2026 - [BSI Website](https://www.bsi.bund.de/DE/Themen/Oeffentliche-Verwaltung/Zulassung/Liste-zugelassener-Produkte/liste-zugelassener-produkte_node.html))</small>
- The only virtualization stack in Germany
- We love the technology, and we love doing something for Germany's & Europe's
  sovereignty
- Thank you!

</v-clicks>

<div v-click="6" class="qr-codes">
  <figure>
    <QrCode value="https://www.cloudhypervisor.org/" :size="110" />
    <figcaption><a href="https://www.cloudhypervisor.org/">Cloud Hypervisor</a></figcaption>
  </figure>
  <figure>
    <QrCode value="https://www.cyberus-technology.de/" :size="110" />
    <figcaption><a href="https://www.cyberus-technology.de/">Cyberus Technology</a></figcaption>
  </figure>
  <figure>
    <QrCode value="https://virtualization-saxony-jsd26.slides.phip1611.dev" :size="110" />
    <figcaption><a href="https://virtualization-saxony-jsd26.slides.phip1611.dev">Slides</a></figcaption>
  </figure>
</div>

<img src="/images/cyberus-logo.svg"
alt="Cyberus Technology logo"
class="corner-logo"/>

<!--
- [CLICK] No US hyperscalers needed
- [CLICK] Built in Dresden
- [CLICK] BSI accredited
- [CLICK] Only one in Germany
- [CLICK] Technology and sovereignty
- [CLICK] Thank you

Beyond the slide:
- Sovereignty is not autarky: open source with a global community, but the
  critical layer stays auditable and in European hands
- Invite them: contributions welcome, Dresden Systems Meetup is around the corner
- QR codes: Cloud Hypervisor, Cyberus, these slides - leave it up during Q&A
-->
---
layout: default
---

# Backup: Linux KVM - The `ioctl` Interface

_**K**ernel-based **V**irtual **M**achine_

- Entry point to KVM: `/dev/kvm`
  - `open("/dev/kvm")` → KVM system FD
  - `ioctl(kvm_fd, KVM_CREATE_VM, ...)` → VM FD
  - `ioctl(vm_fd, KVM_CREATE_VCPU, ...)` → vCPU FD
  - A vCPU thread calls `ioctl(vcpu_fd, KVM_RUN, 0)`
  - The physical CPU running that thread then executes guest code \
    (using hardware virtualization features)
- That's it :)

<!--
- Backup slide - the KVM interface in detail, if someone asks
- Everything else is ioctls on those three file descriptors
- A plain Unix API: file descriptors, ioctl, threads - nothing exotic
- People write toy VMMs in ~100 lines of C

Interesting links:
- https://elixir.bootlin.com/linux/v7.2.6/source/virt/kvm/kvm_main.c#L4441
- https://elixir.bootlin.com/linux/v7.2.6/source/arch/x86/kvm/x86.c#L10970
- https://elixir.bootlin.com/linux/v7.2.6/source/arch/x86/kvm/vmx/vmx.c#L7481
- https://elixir.bootlin.com/linux/v7.2.6/source/arch/x86/kvm/vmx/vmenter.S#L106
-->

---
layout: default
---

# Backup: Live Demo - Networking

```bash
# host
sudo ip tuntap add dev tap0 mode tap
sudo ip addr add dev tap0 192.168.200.1/24
sudo ip link set dev tap0 up

# guest
ip addr add dev eth0 192.168.200.2/24
ip link set dev eth0 up
```

<!--
- Backup slide - only if the demo networking breaks
- Host side creates the tap device, guest side configures eth0
-->
---
layout: default
---

# Backup: Live Demo - Spawning a VM

```bash
cloud-hypervisor \
  --kernel /etc/bootitems/linux/kernel_minimal/stable.bzImage \
  --initramfs /etc/bootitems/linux/initrd_minimal/default \
  --cmdline "console=ttyS0" \
  --memory size=2048M,prefault=on \
  --cpus boot=4 \
  --serial tty \
  --console file=/tmp/foo \
  --api-socket path=/tmp/chv1.sock \
  --event-monitor path=/tmp/events_ch.txt \
  --net tap=tap0
```

<!--
- Backup slide - the exact command line from the demo
- Walk the flags if asked: kernel, initramfs, memory, cpus, serial, api-socket

Review comments & TODOs:

- [ ] Demo: backup video machen!
-->
