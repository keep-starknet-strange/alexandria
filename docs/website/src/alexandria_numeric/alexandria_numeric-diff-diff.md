# diff

Compute the discrete difference of a sorted sequence.

## Arguments

- `sequence` - The sorted sequence to operate.

## Returns

- `Array<T>` - The discrete difference of sorted sequence.

Fully qualified path: `alexandria_numeric::diff::diff`

```rust
pub fn diff<T, +PartialOrd<T>, +Sub<T>, +Copy<T>, +Drop<T>, +Zero<T>>(
    mut sequence: Span<T>,
) -> Array<T>
```

