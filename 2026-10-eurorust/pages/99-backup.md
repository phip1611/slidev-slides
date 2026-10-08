---
layout: chapter
chapter: Backup
---

# B. Backup

Additional material for questions

---
layout: image
image: /images/guest-device-access-sequence.svg
---

<Footnotes>
  <Footnote n="1">
    MMIO: memory-mapped I/O - device registers at addresses without RAM;
    accessing them causes a VM exit
  </Footnote>
  <Footnote n="2">
    Real virtio devices batch many requests per VM exit and signal completion
    via an interrupt
  </Footnote>
</Footnotes>
