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

# 5.1 How to Use Our Virtualization Stack

For production deployments with service: Cyberus Hypervisor. Else: Open Source

<v-clicks depth="2">

- Use stock Linux with `CONFIG_KVM=y` (default on almost all distros)
- Use upstream Cloud Hypervisor<sup>1</sup> or check out our development version<sup>2</sup>
- You get: start VMs + API socket: pause, resume, hotplug, migrate, ...
- You bring: Broader VM management (storage, networking, lifecycle, customer → VM)
- We provide `libvirt`<sup>3</sup> integration
- With trivial patches to OpenStack, you can "just use it" via libvirt backend
- For VS-NfD / NATO Restricted: commercial Cyberus Hypervisor package

</v-clicks>


<div v-click="2" position="absolute" left="7ch" bottom="8ch" text="sm"><sup>1</sup> <a href="https://github.com/cloud-hypervisor/cloud-hypervisor">GitHub: cloud-hypervisor/cloud-hypervisor</a></div>
<div v-click="2" position="absolute" left="7ch" bottom="6ch" text="sm"><sup>2</sup> <a href="https://github.com/cyberus-technology/cloud-hypervisor">GitHub: cyberus-technology/cloud-hypervisor</a></div>
<div v-click="5" position="absolute" left="7ch" bottom="4ch" text="sm"><sup>3</sup> <a href="https://github.com/cyberus-technology/libvirt?ref=gardenlinux">GitHub: cyberus-technology/libvirt.git</a></div>


---
layout: default
---

# 5.2 Virtualization Made in Saxony

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
