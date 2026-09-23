---
layout: chapter
chapter: Digital Sovereignty
---

# 5. Digital Sovereignty for Core Digital Infrastructure

Virtualization made in Saxony by Cyberus Technology

---
layout: default
---

# 5.1 Virtualization Made in Saxony

<v-clicks depth="2">

- No need for need Microsoft, Amazon, Oracle
- We build core digital infrastructure here in Dresden
- **BSI-accredited ("Zulassung") for _VS-NfD_ and _NATO Restricted_** 🎉 \
  <small>(Since September 15th 2026 - [BSI Website](https://www.bsi.bund.de/DE/Themen/Oeffentliche-Verwaltung/Zulassung/Liste-zugelassener-Produkte/liste-zugelassener-produkte_node.html))</small>
- The only virtualization stack in Germany
- We love the technology, and we love doing something for Germany's & Europe's
  souvereignty
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
</div>

<img src="/images/cyberus-logo.svg"
alt="Cyberus Technology logo"
class="corner-logo"/>

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
sudo ip addr add dev eth0 192.168.200.2/24
sudo ip link set dev eth0 up
```

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
Review comments & TODOs:

- [ ] Ich bin oft auf Cyberus zurück gekommen, evtl weniger
- [ ] Bei allen großen Figures: schritt-für-schritt?
- [ ] Auf Folien weniger Text
- [ ] Why you should care: detail slides weg, nur sprechen
- [ ] 1.2 My way into the low level world: folie nicht zeigen, einfach reden
- [ ] 3.10: overview figure: ganz schön overkill, habe schon so oft darüber gesprochen.
  Grafik entweder woanders nutzen (am Anfang) oder ganz weglassen
- [ ] 4.2 passt nicht ganz zusammen. mische cyberus und meine rolle und ich mixe das
  to be more readable:  cloud-hypervisor --kernel /etc/bootitems/linux/kernel_minimal/stable.bzImage --memory size=2048M,prefault=on --initramfs /etc/bootitems/linux/initrd_minimal/default --cmdline "console=ttyS0" --serial tty --console file=/tmp/foo --api-socket path=/tmp/chv1.sock --event-monitor path=/tmp/events_ch.txt --net tap=tap0 --cpus boot=4
- [ ] Demo: backup video machen!
- [x] meine QR code komponente nutzen und auf der letzten folie zwei QR codes für die links platzieren
-->
