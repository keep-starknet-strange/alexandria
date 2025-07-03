# ByteReader

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader`

```rust
pub trait ByteReader<T>
```

## Trait functions

### reader

Wraps the array of bytes in a ByteReader for sequential consumption of integers and/or bytes

#### Returns

- `ByteReader` - The reader struct wrapping a read-only snapshot of this ByteArray

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::reader`

```rust
fn reader(self: @T) -> ByteReaderState<T>
```

### remaining

Checks that there are enough remaining bytes available

#### Arguments

- `at` - the start index position of the byte data
- `count` - the number of bytes required

#### Returns

- `bool` - `true` when there are `count` bytes remaining, `false` otherwise.

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::remaining`

```rust
fn remaining(self: @T, at: usize, count: usize) -> bool
```

### word_u16

Reads consecutive bytes from a specified offset as an unsigned integer in big endian

#### Arguments

- `offset` - the start location of the consecutive bytes to read

#### Returns

- `Option<u16>` - Returns an integer if there are enough consecutive bytes available in the ByteArray

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::word_u16`

```rust
fn word_u16(self: @T, offset: usize) -> Option<u16>
```

### word_u16_le

Reads consecutive bytes from a specified offset as an unsigned integer in little endian

#### Arguments

- `offset` - the start location of the consecutive bytes to read

#### Returns

- `Option<u16>` - Returns an integer if there are enough consecutive bytes available in the ByteArray

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::word_u16_le`

```rust
fn word_u16_le(self: @T, offset: usize) -> Option<u16>
```

### word_u32

Reads consecutive bytes from a specified offset as an unsigned integer in big endian

#### Arguments

- `offset` - the start location of the consecutive bytes to read

#### Returns

- `Option<u32>` - Returns an integer if there are enough consecutive bytes available in the ByteArray

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::word_u32`

```rust
fn word_u32(self: @T, offset: usize) -> Option<u32>
```

### word_u32_le

Reads consecutive bytes from a specified offset as an unsigned integer in little endian

#### Arguments

- `offset` - the start location of the consecutive bytes to read

#### Returns

- `Option<u32>` - Returns an integer if there are enough consecutive bytes available in the ByteArray

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::word_u32_le`

```rust
fn word_u32_le(self: @T, offset: usize) -> Option<u32>
```

### word_u64

Reads consecutive bytes from a specified offset as an unsigned integer in big endian

#### Arguments

- `offset` - the start location of the consecutive bytes to read

#### Returns

- `Option<u64>` - Returns an integer if there are enough consecutive bytes available in the ByteArray

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::word_u64`

```rust
fn word_u64(self: @T, offset: usize) -> Option<u64>
```

### word_u64_le

Reads consecutive bytes from a specified offset as an unsigned integer in little endian

#### Arguments

- `offset` - the start location of the consecutive bytes to read

#### Returns

- `Option<u64>` - Returns an integer if there are enough consecutive bytes available in the ByteArray

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::word_u64_le`

```rust
fn word_u64_le(self: @T, offset: usize) -> Option<u64>
```

### word_u128

Reads consecutive bytes from a specified offset as an unsigned integer in big endian

#### Arguments

- `offset` - the start location of the consecutive bytes to read

#### Returns

- `Option<u128>` - Returns an integer if there are enough consecutive bytes available in the ByteArray

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::word_u128`

```rust
fn word_u128(self: @T, offset: usize) -> Option<u128>
```

### word_u128_le

Reads consecutive bytes from a specified offset as an unsigned integer in little endian

#### Arguments

- `offset` - the start location of the consecutive bytes to read

#### Returns

- `Option<u128>` - Returns an integer if there are enough consecutive bytes available in the ByteArray

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::word_u128_le`

```rust
fn word_u128_le(self: @T, offset: usize) -> Option<u128>
```

### read_u8

Reads a u8 unsigned integer

#### Returns

- `Option<u8>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u8`

```rust
fn read_u8(ref self: ByteReaderState<T>) -> Option<u8>
```

### read_u16

Reads a u16 unsigned integer in big endian byte order

#### Returns

- `Option<u16>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u16`

```rust
fn read_u16(ref self: ByteReaderState<T>) -> Option<u16>
```

### read_u16_le

Reads a u16 unsigned integer in little endian byte order

#### Returns

- `Option<u16>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u16_le`

```rust
fn read_u16_le(ref self: ByteReaderState<T>) -> Option<u16>
```

### read_u32

Reads a u32 unsigned integer in big endian byte order

#### Returns

- `Option<u32>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u32`

```rust
fn read_u32(ref self: ByteReaderState<T>) -> Option<u32>
```

### read_u32_le

Reads a u32 unsigned integer in little endian byte order

#### Returns

- `Option<u32>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u32_le`

```rust
fn read_u32_le(ref self: ByteReaderState<T>) -> Option<u32>
```

### read_u64

Reads a u64 unsigned integer in big endian byte order

#### Returns

- `Option<u64>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u64`

```rust
fn read_u64(ref self: ByteReaderState<T>) -> Option<u64>
```

### read_u64_le

Reads a u64 unsigned integer in little endian byte order

#### Returns

- `Option<u64>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u64_le`

```rust
fn read_u64_le(ref self: ByteReaderState<T>) -> Option<u64>
```

### read_u128

Reads a u128 unsigned integer in big endian byte order

#### Returns

- `Option<u128>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u128`

```rust
fn read_u128(ref self: ByteReaderState<T>) -> Option<u128>
```

### read_u128_le

Reads a u128 unsigned integer in little endian byte order

#### Returns

- `Option<u128>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u128_le`

```rust
fn read_u128_le(ref self: ByteReaderState<T>) -> Option<u128>
```

### read_u256

Reads a u256 unsigned integer in big endian byte order

#### Returns

- `Option<u256>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u256`

```rust
fn read_u256(ref self: ByteReaderState<T>) -> Option<u256>
```

### read_u256_le

Reads a u256 unsigned integer in little endian byte order

#### Returns

- `Option<u256>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u256_le`

```rust
fn read_u256_le(ref self: ByteReaderState<T>) -> Option<u256>
```

### read_u512

Reads a u512 unsigned integer in big endian byte order

#### Returns

- `Option<u512>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u512`

```rust
fn read_u512(ref self: ByteReaderState<T>) -> Option<u512>
```

### read_u512_le

Reads a u512 unsigned integer in little endian byte order

#### Returns

- `Option<u512>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_u512_le`

```rust
fn read_u512_le(ref self: ByteReaderState<T>) -> Option<u512>
```

### read_i8

Reads an i8 signed integer in two's complement encoding from the ByteArray

#### Returns

- `Option<i8>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_i8`

```rust
fn read_i8(ref self: ByteReaderState<T>) -> Option<i8>
```

### read_i16

Reads an i16 signed integer in two's complement encoding from the ByteArray in big endian byte order

#### Returns

- `Option<i16>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_i16`

```rust
fn read_i16(ref self: ByteReaderState<T>) -> Option<i16>
```

### read_i16_le

Reads an i16 signed integer in two's complement encoding from the ByteArray in little endian byte order

#### Returns

- `Option<i16>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_i16_le`

```rust
fn read_i16_le(ref self: ByteReaderState<T>) -> Option<i16>
```

### read_i32

Reads an i32 signed integer in two's complement encoding from the ByteArray in big endian byte order

#### Returns

- `Option<i32>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_i32`

```rust
fn read_i32(ref self: ByteReaderState<T>) -> Option<i32>
```

### read_i32_le

Reads an i32 signed integer in two's complement encoding from the ByteArray in little endian byte order

#### Returns

- `Option<i32>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_i32_le`

```rust
fn read_i32_le(ref self: ByteReaderState<T>) -> Option<i32>
```

### read_i64

Reads an i64 signed integer in two's complement encoding from the ByteArray in big endian byte order

#### Returns

- `Option<i64>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_i64`

```rust
fn read_i64(ref self: ByteReaderState<T>) -> Option<i64>
```

### read_i64_le

Reads an i64 signed integer in two's complement encoding from the ByteArray in little endian byte order

#### Returns

- `Option<i64>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_i64_le`

```rust
fn read_i64_le(ref self: ByteReaderState<T>) -> Option<i64>
```

### read_i128

Reads an i128 signed integer in two's complement encoding from the ByteArray in big endian byte order

#### Returns

- `Option<i128>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_i128`

```rust
fn read_i128(ref self: ByteReaderState<T>) -> Option<i128>
```

### read_i128_le

Reads an i128 signed integer in two's complement encoding from the ByteArray in little endian byte order

#### Returns

- `Option<i128>` - If there are enough bytes remaining an optional integer is returned

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::read_i128_le`

```rust
fn read_i128_le(ref self: ByteReaderState<T>) -> Option<i128>
```

### len

Remaining length count relative to what has already been consume/read

#### Returns

- `usize` - count number of bytes remaining

Fully qualified path: `alexandria_data_structures::byte_reader::ByteReader::len`

```rust
fn len(self: @ByteReaderState<T>) -> usize
```
