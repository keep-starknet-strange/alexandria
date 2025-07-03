# fast_power_mod

Calculate the ( base ^ power ) mod modulus using the fast powering algorithm

## Arguments

- `base` - The base of the exponentiation
- `power` - The power of the exponentiation
- `modulus` - The modulus used in the calculation

## Returns

- `T` - The result of ( base ^ power ) mod modulus

## Panics

- `base` is 0

Fully qualified path: `alexandria_math::fast_power::fast_power_mod`

```rust
pub fn fast_power_mod<
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
    base: T, mut power: T, modulus: T,
) -> T
```
