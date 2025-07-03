# verify

Verifies a signature according to the BIP-340.This function checks if the signature `(rx, s)` is valid for a message `m` with respect to the public key `px`.

## Arguments

- `px`: `u256` - The x-coordinate of the public key.
- `rx`: `u256` - The x-coordinate of the R point from the signature.
- `s`: `u256` - The scalar component of the signature.
- `m`: `ByteArray` - The message for which the signature is being verified.

## Returns

- `bool` - `true` if the signature is verified for the message and public key, `false` otherwise.

Fully qualified path: `alexandria_math::bip340::verify`

```rust
pub fn verify(px: u256, rx: u256, s: u256, m: ByteArray) -> bool
```
