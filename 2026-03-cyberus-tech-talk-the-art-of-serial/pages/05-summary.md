---
layout: default
---

# 5. Summary

<v-clicks depth="2">

- Fun project and I've learned a lot
- Many side-quests along the way
- Learning about the UART 16550 internals + writing a driver was the most fun
- Using that from my own `EFI_SERIAL_IO_PROTOCOL` implementation
  using that on my desktop PC was quite fun as well
- Figuring out how to handle strings and special control chars with terminals
  was the least pleasant thing
  - when to preserve which control character in
    the string
  - when to replace it, ...

</v-clicks>


---
layout: default
---

# 5. Summary

<v-clicks>

- Rewrite of `uart_16550` crate: \
  <https://github.com/rust-osdev/uart_16550/pull/41>
- UEFI Serial Chat project:
  - Incomplete and a few subtle bugs
  - Not the best code - but it works!
  - https://github.com/phip1611/uefi-serial-chat

</v-clicks>


<SlideIndicator />
