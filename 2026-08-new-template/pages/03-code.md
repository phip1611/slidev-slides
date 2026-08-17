---
layout: chapter
---

# 3. Code is the picture

---
# 3.1 Keep the context visible

```rust {1-3|5-8|10-12}{lines: true}
pub fn boot(config: Config) -> Result<Kernel, BootError> {
    let memory = discover_memory(&config)?;
    let devices = enumerate_devices(&memory)?;

    let kernel = Kernel::new(memory, devices);
    kernel.initialize()?
}
```
Magic-move and line highlights are part of the visual language.

---
layout: two-cols-header
---

# 3.2 Explain the boundary beside the code

::left::

```rust
// SAFETY: the caller owns this device.
unsafe { device.write(value) };
```

::right::

The comment names the invariant. The code shows the mechanism.

---
layout: two-cols-header
---

# 3.3 Use two columns for a before-and-after

::left::

```rust
let result = read();
```

::right::

```rust
let result = read()
    .and_then(validate)
    .map_err(BootError::Invalid)?;
```
