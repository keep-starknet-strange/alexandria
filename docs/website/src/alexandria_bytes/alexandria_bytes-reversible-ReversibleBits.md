# ReversibleBits

Implies that there is an underlying bit order for type T that can be reversed

Fully qualified path: `alexandria_bytes::reversible::ReversibleBits`

```rust
pub trait ReversibleBits<T>
```

## Trait functions

### reverse_bits

Reverses the underlying ordering of the bit representation of `self`. For example, the word `0b10111010_u8` is reversed into `0b01011101`.

#### Returns

- `T` - the bit-representation of `self` reversed into the same type T

Fully qualified path: `alexandria_bytes::reversible::ReversibleBits::reverse_bits`

```rust
fn reverse_bits(self: @T) -> T
```

