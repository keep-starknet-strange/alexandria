# encode_byte_array

Encodes a ByteArray into a Base64 encoded ByteArray.This function processes the input binary data in chunks of 3 bytes, converts them into their corresponding 6-bit values, and combines them into 24-bit numbers. It then maps these values to Base64 characters and handles any necessary padding.

## Arguments

- `self` - A mutable ByteArray containing the binary data to be encoded. 
- `base64_chars` - A Span containing the Base64 character set used for encoding.

## Returns

 * A ByteArray containing the Base64 encoded data.

Fully qualified path: `alexandria_encoding::base64::encode_byte_array`

```rust
pub fn encode_byte_array(mut self: ByteArray, base64_chars: Span<u8>) -> ByteArray
```

