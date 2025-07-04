# Decoder

Generic trait for decoding data from Base64 formatThis trait provides a common interface for decoding Base64 encoded data back to its original binary representation.  # Type Parameters * `T` - The input data type to be decoded (typically Base64 encoded bytes)

Fully qualified path: `alexandria_encoding::base64::Decoder`

```rust
pub trait Decoder<T>
```

## Trait functions

### decode

Decodes Base64 encoded data back to raw bytes 

#### Arguments

- `data` - The Base64 encoded data to decode 

#### Returns

- `Array<u8>` - Raw bytes decoded from Base64 format

Fully qualified path: `alexandria_encoding::base64::Decoder::decode`

```rust
fn decode(data: T) -> Array<u8>
```

