# RLPItemByteArray

Fully qualified path: `alexandria_encoding::rlp_byte_array::RLPItemByteArray`

```rust
#[derive(Drop, PartialEq)]
pub enum RLPItemByteArray {
    String: ByteArray,
    List: Span<RLPItemByteArray>,
}
```

## Variants

### String

Fully qualified path: `alexandria_encoding::rlp_byte_array::RLPItemByteArray::String`

```rust
String : ByteArray
```

### List

Fully qualified path: `alexandria_encoding::rlp_byte_array::RLPItemByteArray::List`

```rust
List : Span < RLPItemByteArray >
```

