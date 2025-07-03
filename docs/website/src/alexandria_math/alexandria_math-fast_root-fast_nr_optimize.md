# fast_nr_optimize

Newton-Raphson optimization to solve the equation a^r = x. The optimization has a quadratic convergence rate.

## Arguments

- `x` - The number to calculate the root of
- `r` - The root to calculate
- `iter` - The number of iterations to run the algorithm

## Returns

- `u128` - The root of x with rounding. (e.g., sqrt(5) = 2.24 -> 2, sqrt(7) = 2.65 -> 3)

Fully qualified path: `alexandria_math::fast_root::fast_nr_optimize`

```rust
pub fn fast_nr_optimize(x: u128, r: u128, iter: usize) -> u128
```
