# cumsum

Compute the cumulative sum of a sequence.

## Arguments

- `sequence` - The sequence to operate.

## Returns

- `Array<T>` - The cumulative sum of sequence.

Fully qualified path: `alexandria_numeric::cumsum::cumsum`

```rust
pub fn cumsum<T, +Add<T>, +Copy<T>, +Drop<T>>(mut sequence: Span<T>) -> Array<T>
```

