# trapezoidal_rule

Integrate y(x).

## Arguments

- `xs` - The sorted abscissa sequence of len L.
- `ys` - The ordinate sequence of len L.

## Returns

- `T` - The approximate integral.

Fully qualified path: `alexandria_numeric::trapezoidal_rule::trapezoidal_rule`

```rust
pub fn trapezoidal_rule<
    T,
    +PartialOrd<T>,
    +Add<T>,
    +AddAssign<T, T>,
    +Sub<T>,
    +Mul<T>,
    +Div<T>,
    +Copy<T>,
    +Drop<T>,
    +Zero<T>,
    +Into<u8, T>,
>(
    mut xs: Span<T>, mut ys: Span<T>,
) -> T
```
