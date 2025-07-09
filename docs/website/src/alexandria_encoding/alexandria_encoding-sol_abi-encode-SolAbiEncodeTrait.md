# SolAbiEncodeTrait

Encode trait meant to provide an interface similar to Solidity's abi.encode function. It is meant to allow chaining of encode calls to build up a `Bytes` object. Values are encoded in 32 bytes chunks, and padding is added as necessary. Also provides a packed version of the encoding similar to Solidity's abi.encodePacked, which does not add padding. Use like this: BytesTrait::new_empty().encode(arg1).encode(arg2)... Or like this: BytesTrait::new_empty().encode_packed(arg1).encode_packed(arg2)...

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeTrait`

```rust
pub trait SolAbiEncodeTrait<T>
```

## Trait functions

### encode

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeTrait::encode`

```rust
fn encode(self: Bytes, x: T) -> Bytes
```

### encode_packed

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeTrait::encode_packed`

```rust
fn encode_packed(self: Bytes, x: T) -> Bytes
```

