# Decoder

Fully qualified path: `alexandria_encoding::base58::Decoder`

```rust
pub trait Decoder<T>
```

## Trait functions

### decode

Decodes Base58 encoded data back to raw bytes

#### Arguments

- `data` - The Base58 encoded data to decode

#### Returns

- `Array<u8>` - Raw bytes decoded from Base58 format

Fully qualified path: `alexandria_encoding::base58::Decoder::decode`

```rust
fn decode(data: T) -> Array<u8>
```

