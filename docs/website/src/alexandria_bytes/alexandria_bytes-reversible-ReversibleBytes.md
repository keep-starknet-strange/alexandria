# ReversibleBytes

Implies that there is an underlying byte order for type T that can be reversed

Fully qualified path: `alexandria_bytes::reversible::ReversibleBytes`

```rust
pub trait ReversibleBytes<T>
```

## Trait functions

### reverse_bytes

Reverses the byte order or endianness of `self`. For example, the word `0x1122_u16` is reversed into `0x2211_u16`.

#### Returns

- `T` - Returns the byte reversal of `self` into the same type T

Fully qualified path: `alexandria_bytes::reversible::ReversibleBytes::reverse_bytes`

```rust
fn reverse_bytes(self: @T) -> T
```
