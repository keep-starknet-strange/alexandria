# SolAbiEncodeStarknetAddress

Encode address types Addresses are encoded as 32 bytes long, which are right-aligned/left-padded Big-endian. Packed encodings are not padded and only append the bytes of the value based on type.

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeStarknetAddress`

```rust
pub impl SolAbiEncodeStarknetAddress of SolAbiEncodeTrait<ContractAddress>
```

## Impl functions

### encode

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeStarknetAddress::encode`

```rust
fn encode(mut self: Bytes, x: ContractAddress) -> Bytes
```

### encode_packed

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeStarknetAddress::encode_packed`

```rust
fn encode_packed(mut self: Bytes, x: ContractAddress) -> Bytes
```

