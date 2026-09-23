---
layout: chapter
---

# 5. Digital Sovereignty for Core Digital Infrastructure

Virtualization made in Saxony by Cyberus Technology

---
layout: default
---

# 5.1 Virtualization Made in Saxony

TODO mehr abstand zum Logo

<v-clicks depth="2">

- No need for need Microsoft, Amazon, Oracle
- We build core digital infrastructure here in Dresden
- **BSI-accredited ("Zulassung") for _VS-NfD_ and _NATO Restricted_** 🎉 \
  <small>(Since September 15th 2026 - [BSI Website](https://www.bsi.bund.de/DE/Themen/Oeffentliche-Verwaltung/Zulassung/Liste-zugelassener-Produkte/liste-zugelassener-produkte_node.html))</small>
- The only virtualization stack in Germany
- We love the technology, and we love doing something for Germany's & Europe's
  souvereignty
- More info: TODO Niklas QR Codes
  - [Cloud Hypervisor](https://www.cyberus-technology.de/)
  - [Cyberus Technology](https://www.cyberus-technology.de/)
- Thank you!

</v-clicks>

<img src="/images/cyberus-logo.svg"
alt="Cyberus Technology logo"
class="corner-logo"/>


<!--
Review comments:

- Ich bin oft auf Cyberus zurück gekommen, evtl weniger
- Statt "Chapter 00" -> "Introduction"
- Bei allen Figures: Fußzeile
- Bei allen großen Figures: schritt-für-schritt?
- Auf Folien weniger Text
- Figure "The VMM provides the virtual hardware - the guest uses it": simplify, less details (remove PCI info, NVME); disk 1, disk2
- 3.7 Entschlacken "EPT Violation" zu detailreich
- Paravirtualizierung, virtio
- Why you should care: detail slides weg, nur sprechen
- 1.2 My way into the low level world: folie nicht zeigen, einfach reden
- figures in einleitung raus nehmen -> wenig mehrwert
- 2.1 Cyberus Technology claims to faim: BSI Hypervisor hier nennen
- Whoami: nennen dass ich schon Talks gehalten habe und halten werde
- "Our Offerings & Value Proposition": VS-NfD fußnote was es ausgeschrieben ist
- Figure "Containers vs. VMs: who enforces isolation?"
  --> strong isolation stärker visuell zeigen
  --> mehr sagen dass bei beiden Linux läuft
  --> angriffsfläche sehen
  - "Customer takes care of this" --> "Customer responsibility"
- "container runtime, one container per service" ist irgendwie weird -> nur "container runtime"
- In der Grafik auch besser optisch klarmachen was ein Container und was eine VM ist (Legende, bessere optische Darstellung?)
- 3.6. vCPU wird random eingeführt ohne erklärt zu werden, footnote vllt?
- 3.6 "how does hardware access work? side effects? eigener unterpunkt,
  außerdem detour nicht derail :D
- 3.8 "useless on its own" klingt zu negativ
- "VT-x / AMD-V" --> vmx und svm benutzen (technische begriffe, nicht marketing begriffe)
- 3.10: overview figure: ganz schön overkill, habe schon so oft darüber gesprochen.
  Grafik entweder woanders nutzen (am Anfang) oder ganz weglassen
- 4.2 passt nicht ganz zusammen. mische cyberus und meine rolle und ich mixe das
- "Upstream first" bedeutung nicht erklärt
- Befehle der Live Demo am Ende als Backup slide und CH invocation multi line
  to be more readable:  cloud-hypervisor --kernel /etc/bootitems/linux/kernel_minimal/stable.bzImage --memory size=2048M,prefault=on --initramfs /etc/bootitems/linux/initrd_minimal/default --cmdline "console=ttyS0" --serial tty --console file=/tmp/foo --api-socket path=/tmp/chv1.sock --event-monitor path=/tmp/events_ch.txt --net tap=tap0 --cpus boot=4
- Demo: backup video machen!
-->
