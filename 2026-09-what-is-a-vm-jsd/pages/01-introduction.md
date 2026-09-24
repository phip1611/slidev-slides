---
layout: cover
---

# Virtualization Made in Saxony <br/>- What Is a Virtual Machine?

From Java Code to the Hypervisor: A Look Behind the Scenes

::bottom-left::

JUG Saxony Day - 25. September 2026

::bottom-right::

Philipp Schuster, Software Engineer @ Cyberus Technology

<!--
- Welcome, thanks for having me
- From your Java code down to the hypervisor
- Hands up: who runs software in the cloud?

Beyond the slide:
- I have been visiting this conference for almost a decade
- Promise: no rocket science, the core fits on a few slides
-->
---
layout: chapter
chapter: Introduction
---

# 1. Why You Should Care and Why I am Here

<!--
- Signpost: why it matters, and why I am the one telling it
- Two sentences, then move on
-->
---
layout: default
---

# 1.1 Why You Should Care - and What to Expect

<v-clicks depth="2">

- You deploy software into VMs - core digital infrastructure
- We @ Cyberus Technology build it in Dresden: digital sovereignty for Germany and Europe
- My way: Angular & Spring → low-level \
  (virtualization is no rocket science)
- Today: terminology, what a VM really is, Cloud Hypervisor, live demos \
  (everything focuses on `x86_64`)

</v-clicks>

<!--
- [CLICK] Your app: in VMs
- [CLICK] Built in Dresden
- [CLICK] I came from Spring
- [CLICK] Agenda

Beyond the slide:
- Virtualization is no rocket science - the main message of the talk
- You work high-level, today we go into the (not so) dark arts
- Everything is x86_64; ARM is similar, the details differ
- Fasten your seatbelts
-->
---
layout: default
---

# `1.2 $ whoami`

<div class="about-me">
  <aside class="about-me-profile">
    <div class="about-me-portrait">
      <img
        src="/images/profile.jpeg"
        alt="Portrait of Philipp Schuster"
        class="about-me-photo"
      >
    </div>
    <div v-click class="about-me-caption">
      <strong>Philipp Schuster</strong>
      <span>Systems Software Engineer</span>
    </div>
    <div v-click class="about-me-links">
      <a href="https://github.com/phip1611">
        <carbon:logo-github />
        @phip1611
      </a>
      <a href="https://phip1611.de">
        <carbon:globe />
        phip1611.de
      </a>
    </div>
  </aside>

  <section class="about-me-details">
    <div v-click class="about-me-item">
      <span>Work</span>
      <p>Software Engineer at Cyberus Technology</p>
    </div>
    <div v-click class="about-me-item">
      <span>Focus</span>
      <p>Virtualization, Linux/KVM, x86, and Rust</p>
    </div>
    <div v-click class="about-me-item">
      <span>Open Source</span>

<p>
Maintainer of: <br>
      • <code>uefi-rs</code>(<a href="https://github.com/rust-osdev/uefi-rs/" target="_blank">GitHub</a>)<br>
      • <code>cloud-hypervisor</code> with focus on live migration (<a href="https://github.com/cloud-hypervisor/cloud-hypervisor/" target="_blank">GitHub</a>)<br>
      • Many more Rust crates (OS development, low-level)
      </p>
    </div>
    <div v-click class="about-me-item">
      <span>Community</span>
      <p>Organizer of the <a href="https://ukvly.org/" target="_blank">Dresden Systems Meetup</a></p>
    </div>
    <div v-click class="about-me-item">
      <span>Talks</span>
      <p>Regular speaker at meetups and conferences - and more to come (JUG Saxony Event Series & Day, EuroRust, local meetups)</p>
    </div>
  </section>
</div>

<!--
- [CLICK] Name, role
- [CLICK] GitHub, website
- [CLICK] Cyberus, Dresden
- [CLICK] Virtualization, KVM, Rust
- [CLICK] uefi-rs, cloud-hypervisor
- [CLICK] Dresden Systems Meetup
- [CLICK] Talks

Beyond the slide (the removed "My way into the low-level world" slide):
- 2015-2022 TU Dresden (Dipl.-Inf.), 2016-2021 Telekom MMS (Angular/Spring)
- 2018 started Rust, 2020 the low-level interest grew
- 2021 working student at Cyberus, 2022 full time
- I maintain live migration upstream; the meetup is open to everyone
- Tell it as a story, not as dates - this is the bridge to the audience
-->
