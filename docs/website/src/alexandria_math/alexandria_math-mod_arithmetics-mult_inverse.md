# mult_inverse

Function that return the modular multiplicative inverse. Disclaimer: this function should only be used with a prime modulo.

## Arguments

- `b` - Number of which to find the multiplicative inverse of.
- `modulo` - modulo.

## Returns

- `u256` - modular multiplicative inverse

Fully qualified path: `alexandria_math::mod_arithmetics::mult_inverse`

```rust
pub fn mult_inverse(b: u256, mod_non_zero: NonZero<u256>) -> u256
```
