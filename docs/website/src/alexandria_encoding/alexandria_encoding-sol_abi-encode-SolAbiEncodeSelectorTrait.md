# SolAbiEncodeSelectorTrait

Encode selector trait meant to provide an interface similar to Solidity's abi.encodeWithSelector function. It is meant to be the first call in an encode chain, adding the function selector to the encoded data. Value encoded is only 4 bytes long representing the function selector. Use like this: BytesTrait::new_empty().encode_selector(selector).encode(arg1).encode(arg2)...

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeSelectorTrait`

```rust
pub trait SolAbiEncodeSelectorTrait
```

## Trait functions

### encode_selector

Encodes a function selector as 4 bytes at the beginning of the data

#### Arguments

- `self` - The Bytes object to append the selector to
- `selector` - The 4-byte function selector (u32)

#### Returns

- `Bytes` - The original Bytes object with the selector appended

Fully qualified path: `alexandria_encoding::sol_abi::encode::SolAbiEncodeSelectorTrait::encode_selector`

```rust
fn encode_selector(self: Bytes, selector: u32) -> Bytes
```
