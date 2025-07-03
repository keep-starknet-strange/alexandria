# SolAbiEncodeBool

Encode other primitives Primitives are encoded as 32 bytes long, which are right-aligned/left-padded Big-endian. Packed encodings are not padded and only append the bytes of the value based on type.

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeBool`

```rust
pub impl SolAbiEncodeBool of SolAbiEncodeTrait<bool>
```

## Impl functions

### encode

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeBool::encode`

```rust
fn encode(mut self: Bytes, x: bool) -> Bytes
```

### encode_packed

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeBool::encode_packed`

```rust
fn encode_packed(mut self: Bytes, x: bool) -> Bytes
```

