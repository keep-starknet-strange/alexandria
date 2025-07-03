# point_mult_double_and_add

Function that performs point multiplication for an Elliptic Curve point using the double and add method.

## Arguments

- `scalar` - Scalar such that scalar \* P = P + P + P + ... + P.
- `P` - Elliptic Curve point
- `prime_nz` - Field prime in NonZero form.

## Returns

- `u256` - Resulting point

Fully qualified path: `alexandria_math::ed25519::point_mult_double_and_add`

```rust
pub fn point_mult_double_and_add(mut scalar: u256, mut P: Point, prime_nz: NonZero<u256>) -> Point
```
