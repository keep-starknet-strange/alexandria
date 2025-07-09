# ByteAppenderSupportTrait

Generic support trait for appending signed and unsigned integers onto byte storage. There are two functions, one for each of big and little endian byte order due to performance considerations. The byte reversal could be used in the naïve case when only one implementation is worthwhile.

Fully qualified path: `alexandria_bytes::byte_appender::ByteAppenderSupportTrait`

```rust
pub trait ByteAppenderSupportTrait<T>
```

## Trait functions

### append_bytes_be

Appends `bytes` data of size `count` ordered in big endian

#### Arguments

- `bytes` - Big endian ordered bytes to append 
- `count` - Number of bytes from input to append

Fully qualified path: `alexandria_bytes::byte_appender::ByteAppenderSupportTrait::append_bytes_be`

```rust
fn append_bytes_be(ref self: T, bytes: felt252, count: usize)
```

### append_bytes_le

Appends `bytes` data of size `count` ordered in little endian

#### Arguments

- `bytes` - Little endian ordered bytes to append 
- `count` - Number of bytes from input to append

Fully qualified path: `alexandria_bytes::byte_appender::ByteAppenderSupportTrait::append_bytes_le`

```rust
fn append_bytes_le(ref self: T, bytes: felt252, count: usize)
```

