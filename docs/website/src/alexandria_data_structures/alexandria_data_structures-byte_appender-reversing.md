# reversing

Fully qualified path: `alexandria_data_structures::byte_appender::reversing`

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

