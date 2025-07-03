# Encoder

Generic trait for encoding data into Base64 formatThis trait provides a common interface for encoding various data types into Base64 representation, which is widely used for encoding binary data in text-based formats and data transmission.  # Type Parameters * `T` - The input data type to be encoded

Fully qualified path: `alexandria_encoding::base64::Encoder`

```rust
pub trait Encoder<T>
```

## Trait functions

### encode

Encodes data into Base64 format 

#### Arguments

- `data` - The data to encode 

#### Returns

- `Array<u8>` - Base64 encoded representation as bytes

Fully qualified path: `alexandria_encoding::base64::Encoder::encode`

```rust
fn encode(data: T) -> Array<u8>
```

