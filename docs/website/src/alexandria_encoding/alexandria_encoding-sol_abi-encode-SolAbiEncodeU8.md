# SolAbiEncodeU8

Encode int types Integers are encoded as 32 bytes long, which are right-aligned/left-padded Big-endian. Packed encodings are not padded and only append the bytes of the value based on type.

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeU8`

```rust
pub impl SolAbiEncodeU8 of SolAbiEncodeTrait<u8>
```

## Impl functions

### encode

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeU8::encode`

```rust
fn encode(mut self: Bytes, x: u8) -> Bytes
```

### encode_packed

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeU8::encode_packed`

```rust
fn encode_packed(mut self: Bytes, x: u8) -> Bytes
```

