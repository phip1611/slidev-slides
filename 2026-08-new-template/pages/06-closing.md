---
layout: chapter
---

# 6. Leave a clear edge

---
layout: default
---

# 6.1 A template is a starting point

<v-clicks depth="2">

- Keep the rhythm
- Change the story
- Let the important thing be the most visible thing

</v-clicks>

---
layout: default
---

# 6.2 Links people can take home

<v-clicks depth="2">

- Put the links where the talk ends
- One QR code per destination, with a caption
- `<QrCode value="..." :size="110" />`, wrapped in `.qr-codes`

</v-clicks>

<div v-click class="qr-codes">
  <figure>
    <QrCode value="https://sli.dev/" :size="110" />
    <figcaption><a href="https://sli.dev/">Slidev</a></figcaption>
  </figure>
  <figure>
    <QrCode value="https://phip1611.de" :size="110" />
    <figcaption><a href="https://phip1611.de">phip1611.de</a></figcaption>
  </figure>
</div>

---
layout: cover
---

# Make room for the idea.

Start with a heading. Then choose one thing to show.
