# SolAbiEncodeAsBytes

Encode as from bytes types Bytes are encoded as `byteSize` bytes, which are left-aligned/right-padded.

Fully qualified path: `alexandria_encoding::sol_abi::encode_as::SolAbiEncodeAsBytes`

```rust
pub impl SolAbiEncodeAsBytes of SolAbiEncodeAsTrait<Bytes>
```

## Impl functions

### encode_as

Fully qualified path: `alexandria_encoding::sol_abi::encode_as::SolAbiEncodeAsBytes::encode_as`

```rust
fn encode_as(mut self: Bytes, byteSize: usize, x: Bytes) -> Bytes
```

