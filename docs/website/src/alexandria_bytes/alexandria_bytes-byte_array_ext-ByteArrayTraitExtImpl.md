# ByteArrayTraitExtImpl

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl`

```rust
pub impl ByteArrayTraitExtImpl of ByteArrayTraitExt
```

## Impl functions

### new

Create a ByteArray from an array of u128

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::new`

```rust
fn new(size: usize, mut data: Array<u128>) -> ByteArray
```

### new_empty

instantiate a new ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::new_empty`

```rust
fn new_empty() -> ByteArray
```

### size

get size. Same as len()

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::size`

```rust
fn size(self: @ByteArray) -> usize
```

### read_u8

Read a u_ from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_u8`

```rust
fn read_u8(self: @ByteArray, offset: usize) -> (usize, u8)
```

### read_u16

Read a u16 from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_u16`

```rust
fn read_u16(self: @ByteArray, offset: usize) -> (usize, u16)
```

### read_u32

Read a u32 from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_u32`

```rust
fn read_u32(self: @ByteArray, offset: usize) -> (usize, u32)
```

### read_usize

Read a usize from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_usize`

```rust
fn read_usize(self: @ByteArray, offset: usize) -> (usize, usize)
```

### read_u64

Read a u64 from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_u64`

```rust
fn read_u64(self: @ByteArray, offset: usize) -> (usize, u64)
```

### read_u128

Read a u128 from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_u128`

```rust
fn read_u128(self: @ByteArray, offset: usize) -> (usize, u128)
```

### read_u128_packed

Read value with size bytes from ByteArray, and packed into u128 Arguments: - offset: the offset in Bytes - size: the number of bytes to read Returns: - new_offset: next value offset in Bytes - value: the value packed into u128

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_u128_packed`

```rust
fn read_u128_packed(self: @ByteArray, offset: usize, size: usize) -> (usize, u128)
```

### read_u256

Read a u256 from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_u256`

```rust
fn read_u256(self: @ByteArray, offset: usize) -> (usize, u256)
```

### read_felt252_packed

Read value with size bytes from ByteArray, and packed into felt252 Arguments: - offset: the offset in Bytes - size: the number of bytes to read Returns: - new_offset: next value offset in Bytes - value: the value packed into felt252

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_felt252_packed`

```rust
fn read_felt252_packed(self: @ByteArray, offset: usize, size: usize) -> (usize, felt252)
```

### read_felt252

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_felt252`

```rust
fn read_felt252(self: @ByteArray, offset: usize) -> (usize, felt252)
```

### read_bytes31

Read a bytes31 from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_bytes31`

```rust
fn read_bytes31(self: @ByteArray, offset: usize) -> (usize, bytes31)
```

### read_address

Read Contract Address from Bytes

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_address`

```rust
fn read_address(self: @ByteArray, offset: usize) -> (usize, ContractAddress)
```

### read_bytes

Read bytes from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_bytes`

```rust
fn read_bytes(self: @ByteArray, offset: usize, size: usize) -> (usize, ByteArray)
```

### read_u128_array_packed

Read an array of u128 values from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_u128_array_packed`

```rust
fn read_u128_array_packed(
    self: @ByteArray, offset: usize, array_length: usize, element_size: usize,
) -> (usize, Array<u128>)
```

### read_u256_array

Read an array of u256 values from ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_u256_array`

```rust
fn read_u256_array(self: @ByteArray, offset: usize, array_length: usize) -> (usize, Array<u256>)
```

### read_uint_within_size

Reads an unsigned integer of type T from the ByteArray starting at a given offset, with a specified size.Inputs: - self: A reference to the ByteArray from which to read. - offset: The starting position in the ByteArray to begin reading. - size: The number of bytes to read.Outputs: - A tuple containing: - The new offset after reading the specified number of bytes. - The value of type T read from the ByteArray.

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::read_uint_within_size`

```rust
fn read_uint_within_size<
    T, +Add<T>, +Mul<T>, +Zero<T>, +TryInto<felt252, T>, +Drop<T>, +Into<u8, T>,
>(
    self: @ByteArray, offset: usize, size: usize,
) -> (usize, T)
```

### append_u8

Append a u8 to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_u8`

```rust
fn append_u8(ref self: ByteArray, value: u8)
```

### append_u16

Append a u16 to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_u16`

```rust
fn append_u16(ref self: ByteArray, value: u16)
```

### append_u32

Append a u32 to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_u32`

```rust
fn append_u32(ref self: ByteArray, value: u32)
```

### append_usize

Append a usize to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_usize`

```rust
fn append_usize(ref self: ByteArray, value: usize)
```

### append_u64

Append a u64 to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_u64`

```rust
fn append_u64(ref self: ByteArray, value: u64)
```

### append_u128

Append a u128 to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_u128`

```rust
fn append_u128(ref self: ByteArray, value: u128)
```

### append_u256

Append a u256 to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_u256`

```rust
fn append_u256(ref self: ByteArray, value: u256)
```

### append_u512

Append a u512 to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_u512`

```rust
fn append_u512(ref self: ByteArray, value: u512)
```

### append_felt252

Append a felt252 to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_felt252`

```rust
fn append_felt252(ref self: ByteArray, value: felt252)
```

### append_address

Append a ContractAddress to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_address`

```rust
fn append_address(ref self: ByteArray, value: ContractAddress)
```

### append_bytes31

Append a bytes31 to ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::append_bytes31`

```rust
fn append_bytes31(ref self: ByteArray, value: bytes31)
```

### update_at

Update a byte at a specific offset in ByteArray

Fully qualified path: `alexandria_bytes::byte_array_ext::ByteArrayTraitExtImpl::update_at`

```rust
fn update_at(ref self: ByteArray, offset: usize, value: u8)
```

