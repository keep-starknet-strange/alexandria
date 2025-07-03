# lcm

Calculate the lowest common multiple for n numbers

#### Arguments

- `n` - The array of numbers to calculate the lcm for

#### Returns

- `Result<T, LCMError>` - The lcm of input numbers

Fully qualified path: `alexandria_math::lcm_of_n_numbers::lcm`

```rust
pub fn lcm<T, +Into<T, u128>, +Into<u128, T>, +Mul<T>, +Div<T>, +Copy<T>, +Drop<T>>(
    mut n: Span<T>,
) -> Result<T, LCMError>
```

