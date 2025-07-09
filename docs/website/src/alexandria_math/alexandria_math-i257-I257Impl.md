# I257Impl

Fully qualified path: `alexandria_math::i257::I257Impl`

```rust
pub impl I257Impl of I257Trait
```

## Impl functions

### new

Creates a new i257 from an absolute value and sign. Ensures zero is always represented as positive.

#### Arguments

- `abs` - The absolute value as a u256
- `is_negative` - Whether the number is negative

#### Returns

- `i257` - The constructed signed integer

Fully qualified path: `alexandria_math::i257::I257Impl::new`

```rust
fn new(abs: u256, is_negative: bool) -> i257
```

### is_negative

Returns whether the i257 is negative.

#### Arguments

- `self` - The i257 to check

#### Returns

- `bool` - true if negative, false if positive or zero

Fully qualified path: `alexandria_math::i257::I257Impl::is_negative`

```rust
fn is_negative(self: i257) -> bool
```

### abs

Returns the absolute value of the i257.

#### Arguments

- `self` - The i257 to get absolute value from

#### Returns

- `u256` - The absolute value

Fully qualified path: `alexandria_math::i257::I257Impl::abs`

```rust
fn abs(self: i257) -> u256
```
