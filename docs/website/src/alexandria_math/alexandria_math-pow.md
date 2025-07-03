# pow

Raise a number to a power. O(log n) time complexity. * `base` - The number to raise. * `exp` - The exponent.

#### Returns

- `T` - The result of base raised to the power of exp.

Fully qualified path: `alexandria_math::pow`

```rust
pub fn pow<T, +Sub<T>, +Mul<T>, +Div<T>, +Rem<T>, +PartialEq<T>, +Into<u8, T>, +Drop<T>, +Copy<T>>(
    base: T, exp: T,
) -> T
```

