# SolAbiDecodeBool

Decode other primitives Primitives are decoded by reading 32 bytes from the `offset` `Bytes` encoding is right-aligned/left-paddded Big-endian.

Fully qualified path: `alexandria_encoding::sol_abi::decode::SolAbiDecodeBool`

```rust
pub impl SolAbiDecodeBool of SolAbiDecodeTrait<bool>
```

## Impl functions

### decode

Fully qualified path: `alexandria_encoding::sol_abi::decode::SolAbiDecodeBool::decode`

```rust
fn decode(self: @Bytes, ref offset: usize) -> bool
```

