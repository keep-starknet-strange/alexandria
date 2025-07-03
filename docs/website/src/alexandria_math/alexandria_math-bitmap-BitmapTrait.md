# BitmapTrait

Fully qualified path: `alexandria_math::bitmap::BitmapTrait`

```rust
pub trait BitmapTrait<
    T,
    +Add<T>,
    +Sub<T>,
    +Mul<T>,
    +Div<T>,
    +DivAssign<T, T>,
    +Rem<T>,
    +BitAnd<T>,
    +BitOr<T>,
    +BitNot<T>,
    +PartialEq<T>,
    +PartialOrd<T>,
    +Into<u8, T>,
    +Into<T, u256>,
    +TryInto<u256, T>,
    +Drop<T>,
    +Copy<T>,
>
```

## Trait functions

### get_bit_at

The bit value at the provided index of a number.

#### Arguments

- `x` - The value for which to extract the bit value.
- `i` - The index.

#### Returns

- The value at index.

Fully qualified path: `alexandria_math::bitmap::BitmapTrait::get_bit_at`

```rust
fn get_bit_at(x: T, i: u8) -> bool
```

### set_bit_at

Set the bit to value at the provided index of a number.

#### Arguments

- `x` - The value for which to extract the bit value.
- `i` - The index.
- `value` - The value to set the bit to.

#### Returns

- The value with the bit set to value.

Fully qualified path: `alexandria_math::bitmap::BitmapTrait::set_bit_at`

```rust
fn set_bit_at(x: T, i: u8, value: bool) -> T
```

### most_significant_bit

The index of the most significant bit of the number, where the least significant bit is at index 0 and the most significant bit is at index 255

#### Arguments

- `x` - The value for which to compute the most significant bit, must be greater than 0.

#### Returns

- The index of the most significant bit

Fully qualified path: `alexandria_math::bitmap::BitmapTrait::most_significant_bit`

```rust
fn most_significant_bit(x: T) -> Option<u8>
```

### least_significant_bit

The index of the least significant bit of the number, where the least significant bit is at index 0 and the most significant bit is at index 255

#### Arguments

- `x` - The value for which to compute the least significant bit, must be greater than 0.

#### Returns

- The index of the least significant bit

Fully qualified path: `alexandria_math::bitmap::BitmapTrait::least_significant_bit`

```rust
fn least_significant_bit(x: T) -> Option<u8>
```

### nearest_left_significant_bit

The index of the nearest left significant bit to the index of a number.

#### Arguments

- `x` - The value for which to compute the most significant bit.
- `i` - The index for which to start the search.

#### Returns

- The index of the nearest left significant bit, None is returned if no significant bit is found.

Fully qualified path: `alexandria_math::bitmap::BitmapTrait::nearest_left_significant_bit`

```rust
fn nearest_left_significant_bit(x: T, i: u8) -> Option<u8>
```

### nearest_right_significant_bit

The index of the nearest right significant bit to the index of a number.

#### Arguments

- `x` - The value for which to compute the most significant bit.
- `i` - The index for which to start the search.

#### Returns

- The index of the nearest right significant bit, None is returned if no significant bit is found.

Fully qualified path: `alexandria_math::bitmap::BitmapTrait::nearest_right_significant_bit`

```rust
fn nearest_right_significant_bit(x: T, i: u8) -> Option<u8>
```

### nearest_significant_bit

The index of the nearest significant bit to the index of a number, where the least significant bit is at index 0 and the most significant bit is at index 255

#### Arguments

- `x` - The value for which to compute the most significant bit, must be greater than 0.
- `i` - The index for which to start the search.
- `priority` - if priority is set to true then right is prioritized over left, left over right otherwise.

#### Returns

- The index of the nearest significant bit, None is returned if no significant bit is found.

Fully qualified path: `alexandria_math::bitmap::BitmapTrait::nearest_significant_bit`

```rust
fn nearest_significant_bit(x: T, i: u8, priority: bool) -> Option<u8>
```
