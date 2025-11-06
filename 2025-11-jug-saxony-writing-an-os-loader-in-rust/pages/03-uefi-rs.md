---
layout: default
---

# 3. uefi-rs

Mastering UEFI with Rust

<v-clicks depth="2">

- [github.com/rust-osdev/uefi-rs](https://github.com/rust-osdev/uefi-rs) (`uefi` library on crates.io)
- _Makes it easy to develop Rust software that leverages safe, convenient, and performant abstractions for UEFI functionality._
- High-level wrappers for interfacing UEFI (not an UEFI implementation!)
- Maintaining since August 2022 together with Nicholas Bishop (Google)
- So far, I've touched every part of the code
- Code powers ChromeOS Flex notebooks and also runs in Amazon AWS

</v-clicks>

<SlideIndicator />


---
layout: default
---

# 3. uefi-rs

<v-clicks depth="2">

- `rustc` can compile EFI applications →  compiler target `x86_64-unknown-uefi`
- Library helps writing EFI applications
- Helps loading a kernel
- Selected highlights
  - File system abstraction <small>(proudly crafted by me 😃)</small>
  - Handling device paths with ease
  - Integration of UEFI's allocator into Rust's global allocator

</v-clicks>

<div v-click="6" position="absolute" left="2ch" bottom="2ch" style="max-width: 90%" text="sm">
The device path protocol, also called a <em>device path</em>, is a flexible and
structured sequence of binary nodes that describes a route from the UEFI root to
a particular device, controller, or file.
</div>

<SlideIndicator />


---
layout: default
---

# 3. uefi-rs: Code Example: Hello World

Creating a `no_std` binary (executable)

````md magic-move
```rust {0|1|2}{lines: true}
#![no_main]
#![no_std]
```
```rust {0|4|6|7-9|6}{lines: true}
#![no_main]
#![no_std]

use uefi::prelude::*;

#[entry]
fn main() -> Status {
    Status::SUCCESS
}
```
```rust {*|1|2,5|3-4|6-9}{lines: true}
#[unsafe(export_name = "efi_main")]
extern "efiapi" fn main(
    internal_image_handle: ::uefi::Handle,
    internal_system_table: *const ::core::ffi::c_void,
) -> uefi::Status {
    unsafe {
        ::uefi::boot::set_image_handle(internal_image_handle);
        ::uefi::table::set_system_table(internal_system_table.cast());
    }
    Status::SUCCESS
}
```
```rust {6}{lines: true}
#![no_main]
#![no_std]

use uefi::prelude::*;

#[entry]
fn main() -> Status {
    Status::SUCCESS
}
```
```rust {8-13}{lines: true}
#![no_main]
#![no_std]

use log::info;
use uefi::prelude::*;

#[entry]
fn main() -> Status {
    uefi::helpers::init().unwrap();
    info!("Hello world!");
    Status::SUCCESS
}
```
```rust {4,12}{lines: true}
#![no_main]
#![no_std]

use core::time::Duration;
use log::info;
use uefi::prelude::*;

#[entry]
fn main() -> Status {
    uefi::helpers::init().unwrap();
    info!("Hello world!");
    boot::stall(Duration::from_secs(10));
    Status::SUCCESS
}
```
````

<SlideIndicator />

---
layout: default
---

# 3. uefi-rs: Code Example: Reading File

````md magic-move
```rust {*}{lines: true}
#[entry]
fn main() -> Status {
    Status::SUCCESS
}
```
```rust {3}{lines: true}
#[entry]
fn main() -> Status {
    helpers::init().unwrap(); // enable `log`-crate
    Status::SUCCESS
}
```
```rust {4}{lines: true}
#[entry]
fn main() -> Status {
    helpers::init().unwrap(); // enable `log`-crate
    let sfs_proto = boot::get_image_file_system(boot::image_handle()).unwrap();
    Status::SUCCESS
}
```
```rust {5}{lines: true}
#[entry]
fn main() -> Status {
    helpers::init().unwrap(); // enable `log`-crate
    let sfs_proto = boot::get_image_file_system(boot::image_handle()).unwrap();
    let mut fs = FileSystem::new(sfs_proto); // Abstraction similar to `std::fs`
    Status::SUCCESS
}
```
```rust {6,7}{lines: true}
#[entry]
fn main() -> Status {
    helpers::init().unwrap(); // enable `log`-crate
    let sfs_proto = boot::get_image_file_system(boot::image_handle()).unwrap();
    let mut fs = FileSystem::new(sfs_proto); // Abstraction similar to `std::fs`
    for entry in fs.read_dir(cstr16!("EFI\\BOOT")).unwrap() {
    }
    Status::SUCCESS
}
```
```rust {6,10|7|8|9}{lines: true}
#[entry]
fn main() -> Status {
    helpers::init().unwrap(); // enable `log`-crate
    let sfs_proto = boot::get_image_file_system(boot::image_handle()).unwrap();
    let mut fs = FileSystem::new(sfs_proto); // Abstraction similar to `std::fs`
    for entry in fs.read_dir(cstr16!("EFI\\BOOT")).unwrap() {
        let entry = entry.unwrap();
        let kind = if entry.is_directory() { "dir" } else { "file" };
        info!("Found: {kind} {}", entry.file_name());
    }
    Status::SUCCESS
}
```
````

<div v-click="8">

```
[ INFO]:  src/main.rs@165: Found: dir .
[ INFO]:  src/main.rs@165: Found: dir ..
[ INFO]:  src/main.rs@165: Found: file BOOTX64.EFI
```

</div>

<SlideIndicator />

---
layout: default
---

# 3. uefi-rs: Code Example: Device Paths

````md magic-move
```rust {0|1|2,3}{lines: true}
let handles = boot::find_handles::<DevicePath>().unwrap();
for handle in handles.iter() {
}
```
```rust {3,10|4,5,9|11,12}{lines: true}
let handles = boot::find_handles::<DevicePath>().unwrap();
for handle in handles.iter() {
    let maybe_dvp = unsafe {
        boot::open_protocol::<DevicePath>(
            OpenProtocolParams { handle: *handle,
              agent: boot::image_handle(),
              controller: None, },
            OpenProtocolAttributes::GetProtocol,
        )
    };
    // Pattern matching: Unwrap happy path or continue
    let Ok(dvp) = maybe_dvp else { continue };
    let string = dvp.to_string(DisplayOnly(true), AllowShortcuts(false)).unwrap();
    info!("Device path: {}", string);
}
```
```rust {4|5}{lines: true}
let handles = boot::find_handles::<DevicePath>().unwrap();
for handle in handles.iter() {
    let dvp = /* .. */;
    let string = dvp.to_string(DisplayOnly(true), AllowShortcuts(false)).unwrap();
    info!("Device path: {}", string);
}
```
````

<div v-click="7">

```text {*}{lines: true, maxHeight: '150px'}
[ INFO]:  src/main.rs@178: Device path: Fv(7CB8BDC9-F8EB-4F34-AAEA-3EE4AF6516A1)
[ INFO]:  src/main.rs@178: Device path: MemoryMapped(0xB,0x1FEDC000,0x1FF5FFFF)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)
[ INFO]:  src/main.rs@178: Device path: VenHw(EBF8ED7C-0DD1-4787-84F1-F48D537DCACF)
[ INFO]:  src/main.rs@178: Device path: VenHw(28A03FF4-12B3-4305-A417-BB1A4F94081E)
[ INFO]:  src/main.rs@178: Device path: VenHw(2A46715F-3581-4A55-8E73-2B769AAA30C5)
[ INFO]:  src/main.rs@178: Device path: VenHw(D9DCC5DF-4007-435E-9098-8970935504B2)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x0,0x0)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x1,0x0)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x1F,0x0)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x1F,0x2)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x1F,0x3)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x1,0x0)/AcpiAdr(0x80010100)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x1F,0x0)/Serial(0x0)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x1F,0x0)/Serial(0x1)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x1F,0x0)/Acpi(PNP0303,0x0)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x1F,0x2)/Sata(0x0,0xFFFF,0x0)
[ INFO]:  src/main.rs@178: Device path: PciRoot(0x0)/Pci(0x1F,0x2)/Sata(0x0,0xFFFF,0x0)/HD(1,MBR,0xBE1AFDFA)
```

</div>

<SlideIndicator />


---
layout: default
---

# 3. uefi-rs: How to Test? How to Run?

<v-clicks depth="2">

- On real hardware, i.e., developer laptop
- In a VM
  - e.g., QEMU or Cloud Hypervisor with OVMF firmware
  - OVMF is an EDK2 build for Virtual Machines

</v-clicks>

<SlideIndicator />
