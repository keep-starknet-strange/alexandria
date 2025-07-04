# RLPTrait

Fully qualified path: `alexandria_encoding::rlp::RLPTrait`

```rust
pub trait RLPTrait
```

## Trait functions

### decode_type

Returns RLPType from the leading byte with its offset in the array as well as its size.

#### Arguments

- `input` - Array of byte to decode

#### Returns

- `(RLPType, offset, size)` - A tuple containing the RLPType the offset and the size of the RLPItem to decode # Errors _ empty input - if the input is empty _ input too short - if the input is too short for a given

Fully qualified path: `alexandria_encoding::rlp::RLPTrait::decode_type`

```rust
fn decode_type(input: Span<u8>) -> Result<(RLPType, u32, u32), RLPError>
```

### encode

Recursively encodes multiple a list of RLPItems

#### Arguments

- `input` - Span of RLPItem to encode

#### Returns

- `Span - RLP encoded items as a span of bytes # Errors \* empty input - if the input is empty

Fully qualified path: `alexandria_encoding::rlp::RLPTrait::encode`

```rust
fn encode(input: Span<RLPItem>) -> Result<Span<u8>, RLPError>
```

### encode_string

RLP encodes a Array of bytes representing a RLP String.

#### Arguments

- `input` - Array of bytes representing a RLP String to encode

#### Returns

- `Span - RLP encoded items as a span of bytes

Fully qualified path: `alexandria_encoding::rlp::RLPTrait::encode_string`

```rust
fn encode_string(input: Span<u8>) -> Result<Span<u8>, RLPError>
```

### decode

Recursively decodes a rlp encoded byte array as described in https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/

#### Arguments

- `input` - Array of bytes to decode

#### Returns

- `Span<RLPItem>` - Span of RLPItem # Errors \* input too short - if the input is too short for a given

Fully qualified path: `alexandria_encoding::rlp::RLPTrait::decode`

```rust
fn decode(input: Span<u8>) -> Result<Span<RLPItem>, RLPError>
```
