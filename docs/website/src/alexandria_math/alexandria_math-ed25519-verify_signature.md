# verify_signature

Experimental feature: use with caution. Not recommended for production. Verifies an Ed25519 signature against a message and public key.

## Arguments

- `msg` - The message that was signed as a span of bytes
- `signature` - The signature as a span of two u256 values [R, S](R, S)
- `pub_key` - The public key as a u256 value

## Returns

- `bool` - true if the signature is valid, false otherwise

Fully qualified path: `alexandria_math::ed25519::verify_signature`

```rust
pub fn verify_signature(msg: Span<u8>, signature: Span<u256>, pub_key: u256) -> bool
```
