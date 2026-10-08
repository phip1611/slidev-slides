<!-- The VM seen from inside: a plain computer. Parts reveal on clicks 1-4. -->
<template>
  <svg class="figure" viewBox="0 0 480 296" xmlns="http://www.w3.org/2000/svg">
    <defs>
      <marker id="guest-view-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto">
        <path d="M0,0 L10,5 L0,10 z" fill="#2f9e5b" />
      </marker>
    </defs>

    <g v-click="1">
      <rect class="hw" x="1" y="1" width="478" height="292" rx="10" />
      <text class="h" x="16" y="25">Computer (x86_64)</text>
      <g v-for="i in 4" :key="i">
        <rect class="cpu" :x="16 + (i - 1) * 115" y="116" width="103" height="40" rx="6" />
        <text class="t" :x="16 + (i - 1) * 115 + 51.5" y="141" text-anchor="middle">CPU {{ i - 1 }}</text>
      </g>
    </g>

    <g v-click="2">
      <rect class="os" x="16" y="36" width="448" height="48" rx="8" />
      <text class="h" x="32" y="66">Guest OS</text>
      <text class="sub" x="126" y="66">unmodified: Linux, Windows, ...</text>
    </g>

    <g v-click="3">
      <line class="own" x1="120" y1="87" x2="120" y2="112" />
      <line class="own" x1="360" y1="87" x2="360" y2="112" />
      <text class="own-t" x="240" y="105" text-anchor="middle">owns all of it</text>
    </g>

    <g v-click="4">
      <rect class="dev" x="16" y="168" width="448" height="36" rx="6" />
      <text class="t" x="32" y="191">RAM: 4 GiB</text>
      <line class="bus" x1="16" y1="224" x2="464" y2="224" />
      <text class="sub" x="464" y="218" text-anchor="end">PCIe</text>
      <line class="bus" x1="120" y1="224" x2="120" y2="236" />
      <line class="bus" x1="360" y1="224" x2="360" y2="236" />
      <rect class="dev" x="16" y="236" width="208" height="40" rx="6" />
      <text class="t" x="120" y="261" text-anchor="middle">disk</text>
      <rect class="dev" x="256" y="236" width="208" height="40" rx="6" />
      <text class="t" x="360" y="261" text-anchor="middle">network card</text>
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
.own-t { fill: #1f7a44; font-size: 14px; font-weight: 600; }

.hw { fill: #f9fafb; stroke: #9ca3af; stroke-width: 1.5; }
.cpu { fill: #fff1d6; stroke: #d98a00; stroke-width: 1.5; }
.dev { fill: #ffffff; stroke: #9ca3af; stroke-width: 1.5; }
.os { fill: #e9f7ef; stroke: #2f9e5b; stroke-width: 2; }
.bus { stroke: #9ca3af; stroke-width: 2; }
.own { marker-end: url(#guest-view-arrow); stroke: #2f9e5b; stroke-width: 2.5; }
</style>
