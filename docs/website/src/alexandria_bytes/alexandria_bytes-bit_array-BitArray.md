# BitArray

Fully qualified path: `alexandria_bytes::bit_array::BitArray`

```rust
#[derive(Clone, Drop)]
pub struct BitArray {
    data: Array<bytes31>,
    current: felt252,
    read_pos: usize,
    write_pos: usize,
}
```

