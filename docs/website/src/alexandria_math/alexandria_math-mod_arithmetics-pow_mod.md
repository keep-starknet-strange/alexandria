# pow_mod

Function that performs modular exponentiation.

#### Arguments

- `base` - Base of exponentiation.
- `pow` - Power of exponentiation.
- `modulo` - modulo.

#### Returns

- `u256` - result of modular exponentiation

Fully qualified path: `alexandria_math::mod_arithmetics::pow_mod`

```rust
pub fn pow_mod(mut base: u256, mut pow: u256, mod_non_zero: NonZero<u256>) -> u256
```
