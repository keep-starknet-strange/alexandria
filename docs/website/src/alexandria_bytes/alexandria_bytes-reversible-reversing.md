# reversing

Fully qualified path: `alexandria_bytes::reversible::reversing`

```rust
pub fn reversing<
    T,
    +Copy<T>,
    +Zero<T>,
    +TryInto<T, NonZero<T>>,
    +DivRem<T>,
    +Drop<T>,
    +MulAssign<T, T>,
    +Rem<T>,
    +AddAssign<T, T>,
>(
    word: T, size: usize, step: T,
) -> (T, T)
```

