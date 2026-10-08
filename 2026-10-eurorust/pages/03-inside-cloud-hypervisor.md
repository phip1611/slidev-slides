---
layout: chapter
chapter: Inside Cloud Hypervisor
---

# 3. Inside Cloud Hypervisor

From KVM to a Running VM

---
layout: default
---

# 3.1 My Engagement

<v-clicks>

- Frequent contributor and active in the community
- Honored to work with some incredible and talented folks
- I am primarily working on live migration and maintain that code \
  (Unfortunately, no time for that today but feel free to reach out)
- Active in most parts of the code
- Let's look into a running VM - from my view as a developer

</v-clicks>

---
layout: default
---

# 3.2 Live Demo

<v-clicks>

- Explore Cloud Hypervisor CLI
- Spawn a VM
- Use a bash shell inside a console
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

# 3.3 Recording: Networking into the Guest

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

# 3.4 Recording: Live Migration

<SlidevVideo controls autoplay="once" autoreset="slide" muted class="demo-video">
  <source src="/videos/recording-ch-livemig.webm" type="video/webm">
</SlidevVideo>
