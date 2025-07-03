# List

Fully qualified path: `alexandria_storage::list::List`

```rust
#[derive(Drop)]
pub struct List<T> {
    pub(crate) address_domain: u32,
    pub(crate) base: StorageBaseAddress,
    len: u32,
}
```

