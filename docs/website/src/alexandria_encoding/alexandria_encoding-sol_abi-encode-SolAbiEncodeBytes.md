# SolAbiEncodeBytes

Encode byte types Bytes are encoded as 32 bytes long, which are left-aligned/right-padded. Packed encodings are not padded and only append the bytes up to the length of the value.

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeBytes`

```rust
pub impl SolAbiEncodeBytes of SolAbiEncodeTrait<Bytes>
```

## Impl functions

### encode

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeBytes::encode`

```rust
fn encode(mut self: Bytes, mut x: Bytes) -> Bytes
```

### encode_packed

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeBytes::encode_packed`

```rust
fn encode_packed(mut self: Bytes, x: Bytes) -> Bytes
```

