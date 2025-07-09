# BytesTrait

Fully qualified path: `alexandria_bytes::bytes::BytesTrait`

```rust
pub trait BytesTrait
```

## Trait functions

### new

Create a Bytes from an array of u128

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::new`

```rust
fn new(size: usize, data: Array<u128>) -> Bytes
```

### new_empty

Create an empty Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::new_empty`

```rust
fn new_empty() -> Bytes
```

### zero

Create a Bytes with size bytes 0

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::zero`

```rust
fn zero(size: usize) -> Bytes
```

### locate

Locate offset in Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::locate`

```rust
fn locate(offset: usize) -> (usize, usize)
```

### size

Get Bytes size

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::size`

```rust
fn size(self: @Bytes) -> usize
```

### data

Get data

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::data`

```rust
fn data(self: Bytes) -> Array<u128>
```

### update_at

update specific value (1 bytes) at specific offset

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::update_at`

```rust
fn update_at(ref self: Bytes, offset: usize, value: u8)
```

### read_u128_packed

Read value with size bytes from Bytes, and packed into u128

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_u128_packed`

```rust
fn read_u128_packed(self: @Bytes, offset: usize, size: usize) -> (usize, u128)
```

### read_u128_array_packed

Read value with element_size bytes from Bytes, and packed into u128 array

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_u128_array_packed`

```rust
fn read_u128_array_packed(
    self: @Bytes, offset: usize, array_length: usize, element_size: usize,
) -> (usize, Array<u128>)
```

### read_felt252_packed

Read value with size bytes from Bytes, and packed into felt252

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_felt252_packed`

```rust
fn read_felt252_packed(self: @Bytes, offset: usize, size: usize) -> (usize, felt252)
```

### read_u8

Read a u8 from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_u8`

```rust
fn read_u8(self: @Bytes, offset: usize) -> (usize, u8)
```

### read_u16

Read a u16 from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_u16`

```rust
fn read_u16(self: @Bytes, offset: usize) -> (usize, u16)
```

### read_u32

Read a u32 from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_u32`

```rust
fn read_u32(self: @Bytes, offset: usize) -> (usize, u32)
```

### read_usize

Read a usize from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_usize`

```rust
fn read_usize(self: @Bytes, offset: usize) -> (usize, usize)
```

### read_u64

Read a u64 from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_u64`

```rust
fn read_u64(self: @Bytes, offset: usize) -> (usize, u64)
```

### read_u128

Read a u128 from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_u128`

```rust
fn read_u128(self: @Bytes, offset: usize) -> (usize, u128)
```

### read_u256

Read a u256 from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_u256`

```rust
fn read_u256(self: @Bytes, offset: usize) -> (usize, u256)
```

### read_u256_array

Read a u256 array from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_u256_array`

```rust
fn read_u256_array(self: @Bytes, offset: usize, array_length: usize) -> (usize, Array<u256>)
```

### read_bytes

Read sub Bytes with size bytes from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_bytes`

```rust
fn read_bytes(self: @Bytes, offset: usize, size: usize) -> (usize, Bytes)
```

### read_felt252

Read felt252 from Bytes, which stored as u256

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_felt252`

```rust
fn read_felt252(self: @Bytes, offset: usize) -> (usize, felt252)
```

### read_bytes31

Read bytes31 from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_bytes31`

```rust
fn read_bytes31(self: @Bytes, offset: usize) -> (usize, bytes31)
```

### read_address

Read a ContractAddress from Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::read_address`

```rust
fn read_address(self: @Bytes, offset: usize) -> (usize, ContractAddress)
```

### append_u128_packed

Write value with size bytes into Bytes, value is packed into u128

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_u128_packed`

```rust
fn append_u128_packed(ref self: Bytes, value: u128, size: usize)
```

### append_u8

Write u8 into Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_u8`

```rust
fn append_u8(ref self: Bytes, value: u8)
```

### append_u16

Write u16 into Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_u16`

```rust
fn append_u16(ref self: Bytes, value: u16)
```

### append_u32

Write u32 into Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_u32`

```rust
fn append_u32(ref self: Bytes, value: u32)
```

### append_usize

Write usize into Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_usize`

```rust
fn append_usize(ref self: Bytes, value: usize)
```

### append_u64

Write u64 into Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_u64`

```rust
fn append_u64(ref self: Bytes, value: u64)
```

### append_u128

Write u128 into Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_u128`

```rust
fn append_u128(ref self: Bytes, value: u128)
```

### append_u256

Write u256 into Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_u256`

```rust
fn append_u256(ref self: Bytes, value: u256)
```

### append_felt252

Write felt252 into Bytes, which stored as u256

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_felt252`

```rust
fn append_felt252(ref self: Bytes, value: felt252)
```

### append_bytes31

Write bytes31 into Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_bytes31`

```rust
fn append_bytes31(ref self: Bytes, value: bytes31)
```

### append_address

Write address into Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::append_address`

```rust
fn append_address(ref self: Bytes, value: ContractAddress)
```

### concat

concat with other Bytes

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::concat`

```rust
fn concat(ref self: Bytes, other: @Bytes)
```

### keccak

keccak hash

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::keccak`

```rust
fn keccak(self: @Bytes) -> u256
```

### sha256

sha256 hash

Fully qualified path: `alexandria_bytes::bytes::BytesTrait::sha256`

```rust
fn sha256(self: @Bytes) -> u256
```

