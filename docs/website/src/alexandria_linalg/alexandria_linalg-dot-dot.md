# dot

Compute the dot product for 2 given arrays.

## Arguments

- `xs` - The first sequence of len L.
- `ys` - The second sequence of len L.

## Returns

- `sum` - The dot product.

Fully qualified path: `alexandria_linalg::dot::dot`

```rust
pub fn dot<T, +Mul<T>, +AddAssign<T, T>, +Zero<T>, +Copy<T>, +Drop<T>>(
    mut xs: Span<T>, mut ys: Span<T>,
) -> T
```
