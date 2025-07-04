# ByteArrayDecoder

Trait for decoding ByteArray data from Base64 formatThis trait is specialized for ByteArray types, providing efficient decoding operations while maintaining the ByteArray type for both input and output.

Fully qualified path: `alexandria_encoding::base64::ByteArrayDecoder`

```rust
pub trait ByteArrayDecoder
```

## Trait functions

### decode

Decodes a Base64 encoded ByteArray back to raw bytes 

#### Arguments

- `data` - The Base64 encoded ByteArray to decode 

#### Returns

- `ByteArray` - Raw bytes decoded from Base64 format as ByteArray

Fully qualified path: `alexandria_encoding::base64::ByteArrayDecoder::decode`

```rust
fn decode(data: ByteArray) -> ByteArray
```

