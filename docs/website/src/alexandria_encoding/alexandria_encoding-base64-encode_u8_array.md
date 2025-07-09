# encode_u8_array

Encodes an array of u8 bytes into Base64 format. This function takes an array of bytes and converts them to Base64 encoding using the provided character set. It processes the input in groups of 3 bytes, converting them to 4 Base64 characters, and handles padding when necessary.

## Arguments

- `bytes` - A mutable array of u8 bytes to be encoded
- `base64_chars` - A span containing the Base64 character set for encoding

## Returns

- `Array<u8>` - The Base64 encoded result as an array of bytes

## Algorithm

1. Groups input bytes into chunks of 3
2. Converts each 3-byte chunk into a 24-bit number
3. Splits the 24-bit number into four 6-bit values
4. Maps each 6-bit value to a Base64 character
5. Adds padding ('=') characters when input length is not divisible by 3

Fully qualified path: `alexandria_encoding::base64::encode_u8_array`

```rust
pub fn encode_u8_array(mut bytes: Array<u8>, base64_chars: Span<u8>) -> Array<u8>
```
