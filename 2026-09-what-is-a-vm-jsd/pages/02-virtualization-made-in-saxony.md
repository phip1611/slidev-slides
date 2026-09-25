---
layout: chapter
chapter: Made in Saxony
---

# 2. Virtualization Made in Saxony

Crafted with love and passion by Cyberus Technology in Dresden.

<!--
- Signpost: who builds this, and why in Dresden
-->
---
layout: default
---

# 2.1 Cyberus Technology

<v-clicks depth="2">

- Founded in 2017 by six founders in Dresden (today ≈35)
- Independent, profitable
- Best-in-class expertise in x86 and virtualization
- Focus in reproducible, trustworthy, and solid engineering and software
- In Dresden, Germany (not silicon valley, not USA)
- You might have heard of us ...
  - Leading role in discovery of CPU vulnerabilities Meltdown & Spectre (2018)
  - We developed the KVM-backend for VirtualBox
  - Major contributor to Cloud Hypervisor (next to Meta and Microsoft)

</v-clicks>

<img src="/images/cyberus-logo.svg"
  alt="Cyberus Technology logo"
  class="corner-logo"/>

<!--
- [CLICK] 2017, six founders
- [CLICK] Independent, profitable
- [CLICK] x86 expertise
- [CLICK] Reproducible engineering
- [CLICK] Dresden, not Silicon Valley
- [CLICK] Heard of us?
- [CLICK] Meltdown & Spectre
- [CLICK] VirtualBox KVM backend
- [CLICK] Cloud Hypervisor contributor

Beyond the slide:
- ~35 people today; no VC money, no exit pressure - we think in decades
- Reproducible builds, Nix, everything auditable
- Name the fresh BSI accreditation here too, details follow on 2.3
- Dresden as a silicon location: Infineon, GlobalFoundries, TU Dresden
-->
---
layout: quote
---

# 2.2 Our Mission

_... is to build **open-source digital infrastructure** that stands the
test of time. We engineer modular, transparent and **reproducible software**
that "just works," empowering organisations to run critical systems safely for
decades._

Our goal is digital sovereignty in Germany and Europe (while building cool stuff)!

<!--
- Read the mission, do not recite it word by word
- Key words: open source, stands the test of time, reproducible

Beyond the slide:
- "Decades" is literal - customers run critical systems 10+ years
- Sovereignty is the goal, but we also simply enjoy building this
-->
---
layout: default
---

# 2.3 Our Offerings & Value Proposition

Selected items and one unique selling point.

<v-clicks depth="2">

- Virtualization based on Linux/KVM is main focus
- **Cyberus Hypervisor** <small>(<span v-mark="{at: 5, type: 'underline', color: '#d61515'}">Cloud Hypervisor</span> + <span v-mark="{at: 5, type: 'underline', color: '#d61515'}">Linux/KVM</span> + Service & Expertise)</small>
  - For cloud and embedded use cases
  - **BSI-accredited ("Zulassung") for _VS-NfD_<sup>1</sup> and _NATO Restricted_** 🎉 \
    <small>(Since September 15th 2026 - [BSI Website](https://www.bsi.bund.de/DE/Themen/Oeffentliche-Verwaltung/Zulassung/Liste-zugelassener-Produkte/liste-zugelassener-produkte_node.html))</small>
  - The **only** virtualization stack in Germany
- Enabling European solutions for sovereign clouds
- We deliver components to integrators
- We are building an open-source based cloud platform with SAP ([Apeiro / CobaltCore](https://apeirora.eu/content/projects/))

</v-clicks>

<div v-click="4" position="absolute" left="7ch" bottom="4ch" text="sm">
  <sup>1</sup> <em>VS-NfD</em>: "Verschlusssache - Nur für den Dienstgebrauch",
  the German classification entry level for classified information
</div>

<!--
- [CLICK] Focus: Linux/KVM
- [CLICK] Cyberus Hypervisor
- [CLICK] Cloud and embedded
- [CLICK] BSI accredited
- [CLICK] Only one in Germany
- [CLICK] Sovereign clouds
- [CLICK] Components, not products
- [CLICK] SAP: Apeiro

Beyond the slide:
- Cyberus Hypervisor = Cloud Hypervisor + Linux/KVM + service; both names carry
  the rest of the talk
- VS-NfD = "Verschlusssache - Nur für den Dienstgebrauch", lowest German level
- Accredited since 15 September 2026 - days old
- An accreditation is years of engineering discipline, not just paperwork
- Be precise about what the "only" claim covers
-->
