# fast_power

Calculate the base ^ power using the fast powering algorithm

#### Arguments

- `base` - The base of the exponentiation
- `power` - The power of the exponentiation

#### Returns

- `T` - The result of base ^ power

#### Panics

- `base` is 0

Fully qualified path: `alexandria_math::fast_power::fast_power`

```rust
pub fn fast_power<
    T,
    +Div<T>,
    +DivAssign<T, T>,
    +Rem<T>,
    +Into<u8, T>,
    +Into<T, u256>,
    +TryInto<u256, T>,
    +PartialEq<T>,
    +Copy<T>,
    +Drop<T>,
>(
    base: T, mut power: T,
) -> T
```
