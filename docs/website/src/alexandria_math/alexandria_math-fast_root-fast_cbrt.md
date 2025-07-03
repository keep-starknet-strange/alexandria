# fast_cbrt

Calculate the cubic root of x

## Arguments

- `x` - The number to calculate the cubic root of
- `iter` - The number of iterations to run the algorithm

## Returns

- `u128` - The cubic root of x with rounding (e.g., cbrt(4) = 1.59 -> 2, cbrt(5) = 1.71 -> 2)

Fully qualified path: `alexandria_math::fast_root::fast_cbrt`

```rust
pub fn fast_cbrt(x: u128, iter: usize) -> u128
```
