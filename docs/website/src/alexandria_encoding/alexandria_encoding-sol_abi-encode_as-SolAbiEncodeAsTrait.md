# SolAbiEncodeAsTrait

Encode trait for arbitrarily sized encodings, meant to allow easy bytesX type encodings. Encode the value `x` as `Bytes` with a specific `byteSize`. Allows chaining of encode/encode_as calls to build up a `Bytes` object. Use like : `let encoded: Bytes = Bytes::new_empty().encode_as(32, x).encode_as(13, y)...`

Fully qualified path: `alexandria_encoding::sol_abi::encode_as::SolAbiEncodeAsTrait`

```rust
pub trait SolAbiEncodeAsTrait<T>
```

## Trait functions

### encode_as

Encodes a value of type T into bytes with specified byte size

#### Arguments

- `self` - The Bytes object to append encoded data to
- `byteSize` - The number of bytes to use for encoding (must be <= 32)
- `x` - The value to encode

#### Returns

- `Bytes` - The original Bytes object with the encoded value appended

Fully qualified path: `alexandria_encoding::sol_abi::encode_as::SolAbiEncodeAsTrait::encode_as`

```rust
fn encode_as(self: Bytes, byteSize: usize, x: T) -> Bytes
```
