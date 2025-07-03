# SolAbiDecodeU8

Decode int types Integers are decoded by reading 32 bytes from the `offset` `Bytes` encoding is right-aligned/left-paddded Big-endian.

Fully qualified path: `alexandria_encoding::sol_abi::decode::SolAbiDecodeU8`

```rust
pub impl SolAbiDecodeU8 of SolAbiDecodeTrait<u8>
```

## Impl functions

### decode

Fully qualified path: `alexandria_encoding::sol_abi::decode::SolAbiDecodeU8::decode`

```rust
fn decode(self: @Bytes, ref offset: usize) -> u8
```

