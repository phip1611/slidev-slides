---
layout: default
---

# 5. Summary & Conclusion

<SlideIndicator />


---
layout: default
---

# 5. Summary

<v-clicks depth="2">

- UEFI simplifies and unifies some things
- The domain is complex, and so is UEFI
- systemd boot, GRUB, the Windows bootloader → EFI applications
- To get started: `uefi` crate; example project; run in VM
  - [github.com/rust-osdev/uefi-rs](https://github.com/rust-osdev/uefi-rs)
  - [crates.io/crates/uefi](https://crates.io/crates/uefi)
  - [docs.rs/uefi](https://docs.rs/uefi)

</v-clicks>

<SlideIndicator />


---
layout: default
---

# 5. UEFI Criticism

<v-clicks depth="2">

- Spec sometimes not specific enough
- Implementations are often buggy (derived from EDK2)
- Overly complex and inconsistent
- Most vendors add closed-source additions
- Tries to be a modern OS-like environment but sticks to decade old concepts
  - A single global address space for everything
  - No real multitasking
  - Limited error handling and debugging

</v-clicks>

<SlideIndicator />


---
layout: statement
---

# Thank you for your attention!
