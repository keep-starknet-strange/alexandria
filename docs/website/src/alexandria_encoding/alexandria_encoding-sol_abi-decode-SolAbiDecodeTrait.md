# SolAbiDecodeTrait

Decode trait meant to provide an interface similar to Solidity's abi.decode function. It is meant to be used in a chain where the passed in `offset` is updated after each decode operation. Values are expected to be 32 bytes long, and will be interpreted as if they were encoded using the `abi.encode` function in Solidity.

Fully qualified path: `alexandria_encoding::sol_abi::decode::SolAbiDecodeTrait`

```rust
pub trait SolAbiDecodeTrait<T>
```

## Trait functions

### decode

Decodes a value of type T from bytes starting at the given offset

#### Arguments

- `self` - Reference to the Bytes containing encoded data
- `offset` - Mutable reference to the current offset position (updated after decode)

#### Returns

- `T` - The decoded value of type T

Fully qualified path: `alexandria_encoding::sol_abi::decode::SolAbiDecodeTrait::decode`

```rust
fn decode(self: @Bytes, ref offset: usize) -> T
```
