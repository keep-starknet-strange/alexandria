# RLPTrait

Fully qualified path: `alexandria_encoding::rlp_byte_array::RLPTrait`

```rust
pub trait RLPTrait
```

## Trait functions

### encode_byte_array

Encodes a Span of `RLPItemByteArray` (which can be either strings or lists) into a single RLP-encoded ByteArray. This function handles recursive encoding for nested lists.

#### Parameters

- `input`: A Span containing RLP items, where each item is either a string (ByteArray) or a nested list (Span).
- `prefix`: can be used for ex eip1559 is 0x2

#### Returns

- `Result<@ByteArray, RLPError>`: The RLP-encoded result or an error if input is empty.

Fully qualified path: `alexandria_encoding::rlp_byte_array::RLPTrait::encode_byte_array`

```rust
fn encode_byte_array(input: Span<RLPItemByteArray>, prefix: u8) -> Result<@ByteArray, RLPError>
```

### encode_byte_array_string

Encodes a ByteArray as an RLP string (not a list).

#### Parameters \* `input`: A reference to the ByteArray to encode.

#### Returns

- `Result<@ByteArray, RLPError>`: The RLP-encoded result or an error.

#### RLP Encoding Rules for Strings:

- For empty string, the encoding is 0x80.
- For single byte less than 0x80, it’s the byte itself (no prefix).
- For strings with length < 56, prefix is 0x80 + length.
- For strings with length >= 56, prefix is 0xb7 + length-of-length, followed by actual length and data.

Fully qualified path: `alexandria_encoding::rlp_byte_array::RLPTrait::encode_byte_array_string`

```rust
fn encode_byte_array_string(input: @ByteArray) -> Result<@ByteArray, RLPError>
```

### encode_byte_array_list

Encodes a list of RLP-encoded ByteArrays into a single RLP list item. Assumes all input elements are already RLP-encoded. Used for creating composite structures like transaction lists or EIP-1559 typed payloads.

#### Arguments

- `inputs` - Span of RLP-encoded `@ByteArray` items to be wrapped in a list.
- `prefix` - Optional prefix byte (e.g., 0x2 for EIP-1559), 0 if unused.

#### Returns

- `@ByteArray` - a new RLP-encoded ByteArray representing the list.

#### Behavior

- Uses short or long list prefix depending on total payload size.
- Adds prefix byte if `prefix > 0`.

Fully qualified path: `alexandria_encoding::rlp_byte_array::RLPTrait::encode_byte_array_list`

```rust
fn encode_byte_array_list(inputs: Span<@ByteArray>, prefix: u8) -> Result<@ByteArray, RLPError>
```

### decode_byte_array

Recursively decodes a rlp encoded byte array as described in https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/

#### Arguments

- `input` - ByteArray decode

#### Returns

- `Span<ByteArray>` - decoded ByteArray

#### Errors

- input too short - if the input is too short for a given
- empty input - if the input is len is 0

Fully qualified path: `alexandria_encoding::rlp_byte_array::RLPTrait::decode_byte_array`

```rust
fn decode_byte_array(input: @ByteArray) -> Result<Span<ByteArray>, RLPError>
```

### decode_byte_array_type

Decodes the RLP prefix of the input and determines the type (String or List), returning the decoded payload, the total bytes read, and the inferred RLP type.

#### Parameters

- `input`: Reference to a ByteArray that represents RLP-encoded data.

#### Returns

- `Ok((payload, total_bytes_read, RLPType))`: On success, returns the decoded payload, how many bytes were consumed from input, and whether it was a String or List.

- `Err(RLPError)`: If decoding fails due to invalid input length, or size issues.

Fully qualified path: `alexandria_encoding::rlp_byte_array::RLPTrait::decode_byte_array_type`

```rust
fn decode_byte_array_type(input: @ByteArray) -> Result<(ByteArray, u32, RLPType), RLPError>
```
