# SolAbiEncodeAsU256

Encode as from int types Integers are encoded as `byteSize` bytes, which are right-aligned/left-padded Big-endian.

Fully qualified path: `alexandria_encoding::sol_abi::encode_as::SolAbiEncodeAsU256`

```rust
pub impl SolAbiEncodeAsU256 of SolAbiEncodeAsTrait<u256>
```

## Impl functions

### encode_as

Fully qualified path: `alexandria_encoding::sol_abi::encode_as::SolAbiEncodeAsU256::encode_as`

```rust
fn encode_as(mut self: Bytes, byteSize: usize, mut x: u256) -> Bytes
```

