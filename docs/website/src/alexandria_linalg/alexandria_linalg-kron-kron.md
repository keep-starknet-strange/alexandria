# kron

Compute the Kronecker product for 2 given arrays.

## Arguments

- `xs` - The first sequence of len L.
- `ys` - The second sequence of len L.

## Returns

- `Result<Array<T>, KronError>` - The Kronecker product.

Fully qualified path: `alexandria_linalg::kron::kron`

```rust
pub fn kron<T, +Mul<T>, +Copy<T>, +Drop<T>>(
    mut xs: Span<T>, mut ys: Span<T>,
) -> Result<Array<T>, KronError>
```
