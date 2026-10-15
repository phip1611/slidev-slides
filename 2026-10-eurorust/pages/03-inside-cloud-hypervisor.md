---
layout: chapter
chapter: Inside Cloud Hypervisor
---

# 3. Inside Cloud Hypervisor

From KVM to a Running VM

---
layout: default
---

# 3.1 Rust and Virtualization? A Fantastic Fit!

<v-clicks>

- Modern language, modern toolchain, "it just works" \
  → Fearless contributions
- _rust-vmm_ crates as open source base (`vm-memory`, ...)
- Modeling complexity with convenient abstractions
- Handling of all possible errors
- Memory safety
- Compiler complains about a lot of mistakes!

</v-clicks>

---
layout: default
---

# 3.2 Live Demo

<v-clicks>

- Explore Cloud Hypervisor CLI
- Spawn a VM
- Use a bash shell in the VM
- Attach the debugger in my IDE
- Show where `KVM_RUN` can be found in code

</v-clicks>

<!--

This takes roughly 10min.

Interesting links:
- https://elixir.bootlin.com/linux/v7.2.6/source/virt/kvm/kvm_main.c#L4441
- https://elixir.bootlin.com/linux/v7.2.6/source/arch/x86/kvm/x86.c#L10970
- https://elixir.bootlin.com/linux/v7.2.6/source/arch/x86/kvm/vmx/vmx.c#L7481
- https://elixir.bootlin.com/linux/v7.2.6/source/arch/x86/kvm/vmx/vmenter.S#L106
-->

---
layout: default
---

# 3.3 Recording: Basic CLI Usage and Starting a VM

<SlidevVideo controls autoplay="once" autoreset="slide" muted class="demo-video">
  <source src="/videos/recording-ch-cli.webm" type="video/webm">
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

# 3.4 Recording: Booting in RustRover + Debugger

<SlidevVideo controls autoplay="once" autoreset="slide" muted class="demo-video">
  <source src="/videos/recording-ch-debugger-kvmrun.webm" type="video/webm">
</SlidevVideo>

---
layout: default
---

# 3.5 Recording: Networking into the Guest

<SlidevVideo controls autoplay="once" autoreset="slide" muted class="demo-video">
  <source src="/videos/recording-ch-networking.webm" type="video/webm">
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

# 3.6 Recording: Live Migration

<SlidevVideo controls autoplay="once" autoreset="slide" muted class="demo-video">
  <source src="/videos/recording-ch-livemig.webm" type="video/webm">
</SlidevVideo>
