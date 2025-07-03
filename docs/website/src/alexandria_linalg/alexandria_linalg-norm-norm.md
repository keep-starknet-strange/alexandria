# norm

Compute the norm for an T array.

## Arguments

- `array` - The inputted array.
- `ord` - The order of the norm.
- `iter` - The number of iterations to run the algorithm

## Returns

- `u128` - The norm for the array.

Fully qualified path: `alexandria_linalg::norm::norm`

```rust
pub fn norm<T, +Into<T, u128>, +Zero<T>, +Copy<T>, +Drop<T>>(
    mut xs: Span<T>, ord: u128, iter: usize,
) -> u128
```
