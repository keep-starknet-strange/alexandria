# ByteArrayTraitExt

Extension trait for reading and writing different data types to `ByteArray`

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt`

```rust
pub trait ByteArrayTraitExt
```

## Trait functions

### new

Create a ByteArray from an array of u128

#### Arguments

- `size` - The size of the ByteArray
- `data` - Array of u128 values to create ByteArray from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::new`

```rust
fn new(size: usize, data: Array<u128>) -> ByteArray
```

### new_empty

Instantiate a new ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::new_empty`

```rust
fn new_empty() -> ByteArray
```

### size

Get the size of the ByteArray

#### Arguments

- `self` - The ByteArray to get the size of

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::size`

```rust
fn size(self: @ByteArray) -> usize
```

### read_u8

Reads a 8-bit unsigned integer from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u8`

```rust
fn read_u8(self: @ByteArray, offset: usize) -> (usize, u8)
```

### read_u16

Reads a 16-bit unsigned integer from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u16`

```rust
fn read_u16(self: @ByteArray, offset: usize) -> (usize, u16)
```

### read_u32

Reads a 32-bit unsigned integer from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u32`

```rust
fn read_u32(self: @ByteArray, offset: usize) -> (usize, u32)
```

### read_usize

Reads a `usize` from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_usize`

```rust
fn read_usize(self: @ByteArray, offset: usize) -> (usize, usize)
```

### read_u64

Reads a 64-bit unsigned integer from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u64`

```rust
fn read_u64(self: @ByteArray, offset: usize) -> (usize, u64)
```

### read_u128

Reads a 128-bit unsigned integer from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u128`

```rust
fn read_u128(self: @ByteArray, offset: usize) -> (usize, u128)
```

### read_u128_packed

Read value with size bytes from ByteArray, and packed into u128

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from
- `size` - The number of bytes to read

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u128_packed`

```rust
fn read_u128_packed(self: @ByteArray, offset: usize, size: usize) -> (usize, u128)
```

### read_u128_array_packed

Reads a packed array of `u128` values from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from
- `array_length` - The length of the array to read
- `element_size` - The size of each element in bytes

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u128_array_packed`

```rust
fn read_u128_array_packed(
    self: @ByteArray, offset: usize, array_length: usize, element_size: usize,
) -> (usize, Array<u128>)
```

### read_u256

Reads a 256-bit unsigned integer from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u256`

```rust
fn read_u256(self: @ByteArray, offset: usize) -> (usize, u256)
```

### read_u256_array

Reads an array of `u256` values from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from
- `array_length` - The length of the array to read

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u256_array`

```rust
fn read_u256_array(self: @ByteArray, offset: usize, array_length: usize) -> (usize, Array<u256>)
```

### read_felt252

Reads a `felt252` (Starknet field element) from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_felt252`

```rust
fn read_felt252(self: @ByteArray, offset: usize) -> (usize, felt252)
```

### read_felt252_packed

Read value with size bytes from Bytes, and packed into felt252

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from
- `size` - The number of bytes to read

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_felt252_packed`

```rust
fn read_felt252_packed(self: @ByteArray, offset: usize, size: usize) -> (usize, felt252)
```

### read_bytes31

Reads a `bytes31` value (31-byte sequence) from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_bytes31`

```rust
fn read_bytes31(self: @ByteArray, offset: usize) -> (usize, bytes31)
```

### read_address

Reads a Starknet contract address from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_address`

```rust
fn read_address(self: @ByteArray, offset: usize) -> (usize, ContractAddress)
```

### read_bytes

Reads a raw sequence of bytes of given `size` from the given offset.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from
- `size` - The number of bytes to read

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_bytes`

```rust
fn read_bytes(self: @ByteArray, offset: usize, size: usize) -> (usize, ByteArray)
```

### append_u8

Appends a 8-bit unsigned integer to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u8`

```rust
fn append_u8(ref self: ByteArray, value: u8)
```

### append_u16

Appends a 16-bit unsigned integer to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u16`

```rust
fn append_u16(ref self: ByteArray, value: u16)
```

### append_u32

Appends a 32-bit unsigned integer to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u32`

```rust
fn append_u32(ref self: ByteArray, value: u32)
```

### append_usize

Appends usize to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_usize`

```rust
fn append_usize(ref self: ByteArray, value: usize)
```

### append_u64

Appends a 64-bit unsigned integer to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u64`

```rust
fn append_u64(ref self: ByteArray, value: u64)
```

### append_u128

Appends a 128-bit unsigned integer to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u128`

```rust
fn append_u128(ref self: ByteArray, value: u128)
```

### append_u256

Appends a 256-bit unsigned integer to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u256`

```rust
fn append_u256(ref self: ByteArray, value: u256)
```

### append_u512

Appends a 512-bit unsigned integer to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u512`

```rust
fn append_u512(ref self: ByteArray, value: u512)
```

### append_felt252

Appends a `felt252` to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_felt252`

```rust
fn append_felt252(ref self: ByteArray, value: felt252)
```

### append_address

Appends a Starknet contract address to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_address`

```rust
fn append_address(ref self: ByteArray, value: ContractAddress)
```

### append_bytes31

Appends a `bytes31` value to the `ByteArray`.

#### Arguments

- `self` - The ByteArray to append to
- `value` - The value to append

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_bytes31`

```rust
fn append_bytes31(ref self: ByteArray, value: bytes31)
```

### update_at

Updates a byte at the given `offset` with a new value.

#### Arguments

- `self` - The ByteArray to update
- `offset` - The offset to update at
- `value` - The new value

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::update_at`

```rust
fn update_at(ref self: ByteArray, offset: usize, value: u8)
```

### read_uint_within_size

Reads an unsigned integer of type T from the ByteArray starting at a given offset, with a specified size.

#### Arguments

- `self` - The ByteArray to read from
- `offset` - The offset to read from
- `size` - The number of bytes to read

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_uint_within_size`

```rust
fn read_uint_within_size<
    T, +Add<T>, +Mul<T>, +Zero<T>, +TryInto<felt252, T>, +Drop<T>, +Into<u8, T>,
>(
    self: @ByteArray, offset: usize, size: usize,
) -> (usize, T)
```
