# pow10

Calculate 10 raised to the power of the given exponent using a pre-computed lookup table

#### Arguments

- `exponent` - The exponent to raise 10 to

#### Returns

- `u128` - The result of 10^exponent

#### Panics

- If `exponent` is greater than 38 (out of the supported range)

Fully qualified path: `alexandria_math::const_pow::pow10`

```rust
pub fn pow10(exponent: u32) -> u128
```

