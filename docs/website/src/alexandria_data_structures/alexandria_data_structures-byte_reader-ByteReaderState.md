# ByteReaderState

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReaderState`

```rust
#[derive(Clone, Drop)]
pub struct ByteReaderState<T> {
    pub(crate) data: @T,
    index: usize,
}
```

