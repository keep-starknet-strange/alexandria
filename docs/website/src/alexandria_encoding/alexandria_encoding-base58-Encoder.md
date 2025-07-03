# Encoder

Fully qualified path: `alexandria_encoding::base58::Encoder`

```rust
pub trait Encoder<T>
```

## Trait functions

### encode

Encodes data into Base58 format 

#### Arguments

- `data` - The data to encode 

#### Returns

- `Array<u8>` - Base58 encoded representation as bytes

Fully qualified path: `alexandria_encoding::base58::Encoder::encode`

```rust
fn encode(data: T) -> Array<u8>
```

