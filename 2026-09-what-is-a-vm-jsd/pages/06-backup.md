---
layout: chapter
chapter: Backup
---

# Backup

Slides for questions and for when the live demo misbehaves.

---
layout: default
---

# Linux KVM - The `ioctl` Interface

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

# Live Demo - Networking

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

# Live Demo - Spawning a VM

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
