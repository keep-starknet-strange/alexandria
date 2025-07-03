# SolAbiDecodeStarknetAddress

Decode address types Addresses are decoded by reading 32 bytes from the `offset` `Bytes` encoding is right-aligned/left-paddded Big-endian.

Fully qualified path: `alexandria_encoding::sol_abi::decode::SolAbiDecodeStarknetAddress`

```rust
pub impl SolAbiDecodeStarknetAddress of SolAbiDecodeTrait<ContractAddress>
```

## Impl functions

### decode

Fully qualified path: `alexandria_encoding::sol_abi::decode::SolAbiDecodeStarknetAddress::decode`

```rust
fn decode(self: @Bytes, ref offset: usize) -> ContractAddress
```

