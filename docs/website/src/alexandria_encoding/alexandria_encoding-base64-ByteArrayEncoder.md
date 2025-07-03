# ByteArrayEncoder

Trait for encoding ByteArray data into Base64 formatThis trait is specialized for ByteArray types, providing efficient encoding operations while maintaining the ByteArray type for both input and output.

Fully qualified path: `alexandria_encoding::base64::ByteArrayEncoder`

```rust
pub trait ByteArrayEncoder
```

## Trait functions

### encode

Encodes a ByteArray into Base64 format 

#### Arguments

- `data` - The ByteArray to encode 

#### Returns

- `ByteArray` - Base64 encoded representation as ByteArray

Fully qualified path: `alexandria_encoding::base64::ByteArrayEncoder::encode`

```rust
fn encode(data: ByteArray) -> ByteArray
```

