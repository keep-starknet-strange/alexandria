# SolAbiDecodeBytes

Decode byte types Bytes are decoded by reading 32 bytes from the `offset` `Bytes` encoding is left-aligned/right-paddded

Fully qualified path: `alexandria_encoding::sol_abi::decode::SolAbiDecodeBytes`

```rust
pub impl SolAbiDecodeBytes of SolAbiDecodeTrait<Bytes>
```

## Impl functions

### decode

Fully qualified path: `alexandria_encoding::sol_abi::decode::SolAbiDecodeBytes::decode`

```rust
fn decode(self: @Bytes, ref offset: usize) -> Bytes
```

