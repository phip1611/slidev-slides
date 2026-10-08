<!--
  The VM seen from the host: the computer of GuestViewFigure mapped onto one
  cloud-hypervisor process. Parts reveal on clicks 1-4.
-->
<template>
  <svg class="figure" viewBox="0 0 480 320" xmlns="http://www.w3.org/2000/svg">
    <defs>
      <marker id="host-view-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto">
        <path d="M0,0 L10,5 L0,10 z" fill="#706b6d" />
      </marker>
    </defs>

    <g v-click="1">
      <rect class="app" x="1" y="1" width="110" height="40" rx="6" />
      <text class="mono" x="56" y="26" text-anchor="middle">firefox</text>
      <rect class="app" x="1" y="53" width="110" height="40" rx="6" />
      <text class="mono" x="56" y="78" text-anchor="middle">rustc</text>

      <rect class="ch" x="126" y="1" width="353" height="266" rx="10" />
      <text class="h" x="142" y="26" fill="#2a56b8">cloud-hypervisor</text>
      <text class="sub" x="142" y="46">one process per VM</text>
      <rect class="vm" x="138" y="54" width="136" height="204" rx="8" />
      <text class="vm-h" x="146" y="73">Guest VM</text>

      <rect class="kernel" x="1" y="281" width="478" height="38" rx="6" />
      <text class="t" x="16" y="305">Linux kernel</text>
      <rect class="kvm" x="379" y="287" width="88" height="26" rx="5" />
      <text class="t" x="423" y="305" text-anchor="middle">KVM</text>
    </g>

    <g v-click="2">
      <rect class="cpu" x="146" y="82" width="120" height="34" rx="6" />
      <text class="t" x="206" y="104" text-anchor="middle">CPU 0-3</text>
      <line class="map" x1="278" y1="99" x2="304" y2="99" />
      <text class="mono" x="312" y="104">4 threads</text>
    </g>

    <g v-click="3">
      <rect class="dev" x="146" y="126" width="120" height="34" rx="6" />
      <text class="t" x="206" y="148" text-anchor="middle">RAM</text>
      <line class="map" x1="278" y1="143" x2="304" y2="143" />
      <text class="mono" x="312" y="148">process memory</text>
    </g>

    <g v-click="4">
      <rect class="dev" x="146" y="170" width="120" height="34" rx="6" />
      <text class="t" x="206" y="192" text-anchor="middle">disk</text>
      <line class="map" x1="278" y1="187" x2="304" y2="187" />
      <text class="mono" x="312" y="192">disk.img</text>
      <rect class="dev" x="146" y="214" width="120" height="34" rx="6" />
      <text class="t" x="206" y="236" text-anchor="middle">network</text>
      <line class="map" x1="278" y1="231" x2="304" y2="231" />
      <text class="mono" x="312" y="236">tap device</text>
    </g>
  </svg>
</template>

<style scoped>
.figure {
  display: block;
  font-family: 'IBM Plex Sans', sans-serif;
  height: auto;
  width: 100%;
}

.h { fill: #242126; font-size: 17px; font-weight: 600; }
.t { fill: #242126; font-size: 15px; }
.sub { fill: #706b6d; font-size: 14px; }
.mono { fill: #242126; font-family: 'Source Code Pro', monospace; font-size: 15px; }

.app { fill: #f9fafb; stroke: #9ca3af; stroke-width: 1.5; }
.vm { fill: #e9f7ef; stroke: #2f9e5b; stroke-width: 1.5; }
.vm-h { fill: #1f7a44; font-size: 14px; font-weight: 600; }
.ch { fill: #eaf1ff; stroke: #3b6fd8; stroke-width: 2; }
.kernel { fill: #f9fafb; stroke: #9ca3af; stroke-width: 1.5; }
.kvm { fill: #f3ebff; stroke: #7c4dcc; stroke-width: 1.5; }
.cpu { fill: #fff1d6; stroke: #d98a00; stroke-width: 1.5; }
.dev { fill: #ffffff; stroke: #9ca3af; stroke-width: 1.5; }
.map { marker-end: url(#host-view-arrow); stroke: #706b6d; stroke-width: 2; }
</style>
