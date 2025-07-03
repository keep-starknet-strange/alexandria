# add_mod

Function that performs modular addition. Will panick if result is > u256 max

#### Arguments

- `a` - Left hand side of addition.
- `b` - Right hand side of addition.
- `modulo` - modulo.

#### Returns

- `u256` - result of modular addition

Fully qualified path: `alexandria_math::mod_arithmetics::add_mod`

```rust
pub fn add_mod(a: u256, b: u256, modulo: u256) -> u256
```
