---
layout: cover
---

# Inside Cloud Hypervisor

From KVM to a Running VM

::bottom-left::

EuroRust, Barcelona - 2026-10-15

::bottom-right::

Philipp Schuster, Software Engineer @ Cyberus Technology

---
layout: chapter
chapter: Introduction
---

# 1. Why You Should Care

And why I am presenting this

<!--

-->

---
layout: default
---

# 1.1 Virtual Machines (VMs) Are Everywhere

<v-clicks>

- Almost every website or app backend runs in some cloud environment
- Some of you likely deploy software into such clouds
- Even if backend is deployed as a container, it might still run in a VM<sup>1</sup>

</v-clicks>

<Footnotes>
  <Footnote n="1" v-click="3">
    Typical setup: One VM per customer for strong isolation, multiple
    containers in VM for easy deployment
  </Footnote>
</Footnotes>

---
layout: default
---

# 1.2 Why I Submitted This Talk

<v-clicks>

- It is quite fascinating how things work behind the scenes
- I planned to come here for a technical deep-dive ...
- ... time has passed and this is now also about a great **Rust success story**<sup>1</sup> 🦀🎉

</v-clicks>

<Footnotes>
  <Footnote n="1" v-click="3">
    More on that at the end of the talk
  </Footnote>
</Footnotes>


---
layout: default
---

# `1.3 $ whoami`

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
      <span>Software Engineer</span>
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
Actively working on various Rust projects:
<br>
      • <code>tar-no-std</code>(<a href="https://github.com/phip1611/tar-no-std/" target="_blank">GitHub</a>)<br>
      • <code>ttfb</code>(<a href="https://github.com/phip1611/ttfb/" target="_blank">GitHub</a>)<br>
      • <code>uefi-rs</code>(<a href="https://github.com/rust-osdev/uefi-rs/" target="_blank">GitHub</a>)<br>
      • <code>cloud-hypervisor</code> with focus on live migration (<a href="https://github.com/cloud-hypervisor/cloud-hypervisor/" target="_blank">GitHub</a>)<br>
      • Many more fun stuff (OS development, low-level)
      </p>
    </div>
    <div v-click class="about-me-item">
      <span>Community</span>
      <p>Organizer of the <a href="https://ukvly.org/" target="_blank">Dresden Systems Meetup</a></p>
    </div>
    <div v-click class="about-me-item">
      <span>Talks</span>
      <p>Regular speaker at meetups and conferences - and more to come</p>
    </div>
  </section>
</div>

