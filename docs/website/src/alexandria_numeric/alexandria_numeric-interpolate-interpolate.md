# interpolate

Interpolate y(x) at x.

## Arguments

- `x` - The position at which to interpolate.
- `xs` - The sorted abscissa sequence of len L.
- `ys` - The ordinate sequence of len L.
- `interpolation` - The interpolation method to use.
- `extrapolation` - The extrapolation method to use.

## Returns

- `T` - The interpolated y at x.

Fully qualified path: `alexandria_numeric::interpolate::interpolate`

```rust
pub fn interpolate<
    T, +PartialOrd<T>, +Add<T>, +Sub<T>, +Mul<T>, +Div<T>, +Zero<T>, +Copy<T>, +Drop<T>,
>(
    x: T, xs: Span<T>, ys: Span<T>, interpolation: Interpolation, extrapolation: Extrapolation,
) -> T
```
