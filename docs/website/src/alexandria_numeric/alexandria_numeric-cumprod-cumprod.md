# cumprod

Compute the cumulative product of a sequence.

## Arguments

- `sequence` - The sequence to operate.

## Returns

- `Array<T>` - The cumulative product of sequence.

Fully qualified path: `alexandria_numeric::cumprod::cumprod`

```rust
pub fn cumprod<T, +Mul<T>, +Copy<T>, +Drop<T>>(mut sequence: Span<T>) -> Array<T>
```

