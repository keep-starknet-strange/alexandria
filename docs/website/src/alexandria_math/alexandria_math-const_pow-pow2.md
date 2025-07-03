# pow2

Calculate 2 raised to the power of the given exponent using a pre-computed lookup table

#### Arguments

- `exponent` - The exponent to raise 2 to

#### Returns

- `u128` - The result of 2^exponent

#### Panics

- If `exponent` is greater than 127 (out of the supported range)

Fully qualified path: `alexandria_math::const_pow::pow2`

```rust
pub fn pow2(exponent: u32) -> u128
```

