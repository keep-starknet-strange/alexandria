# WordOperations

Trait defining bitwise operations for word types used in cryptographic algorithms.

Fully qualified path: `alexandria_math::sha512::WordOperations`

```rust
pub trait WordOperations<T>
```

## Trait functions

### shr

Performs logical right shift operation.

#### Arguments

- `self` - The value to shift
- `n` - Number of positions to shift right

#### Returns

- `T` - The shifted value

Fully qualified path: `alexandria_math::sha512::WordOperations::shr`

```rust
fn shr(self: T, n: u64) -> T
```

### shl

Performs logical left shift operation.

#### Arguments

- `self` - The value to shift
- `n` - Number of positions to shift left

#### Returns

- `T` - The shifted value

Fully qualified path: `alexandria_math::sha512::WordOperations::shl`

```rust
fn shl(self: T, n: u64) -> T
```

### rotr

Performs rotate right operation.

#### Arguments

- `self` - The value to rotate
- `n` - Number of positions to rotate right

#### Returns

- `T` - The rotated value

Fully qualified path: `alexandria_math::sha512::WordOperations::rotr`

```rust
fn rotr(self: T, n: u64) -> T
```

### rotr_precomputed

Performs rotate right with precomputed power values for efficiency.

#### Arguments

- `self` - The value to rotate
- `two_pow_n` - Precomputed value of 2^n
- `two_pow_64_n` - Precomputed value of 2^(64-n)

#### Returns

- `T` - The rotated value

Fully qualified path: `alexandria_math::sha512::WordOperations::rotr_precomputed`

```rust
fn rotr_precomputed(self: T, two_pow_n: u64, two_pow_64_n: u64) -> T
```

### rotl

Performs rotate left operation.

#### Arguments

- `self` - The value to rotate
- `n` - Number of positions to rotate left

#### Returns

- `T` - The rotated value

Fully qualified path: `alexandria_math::sha512::WordOperations::rotl`

```rust
fn rotl(self: T, n: u64) -> T
```
