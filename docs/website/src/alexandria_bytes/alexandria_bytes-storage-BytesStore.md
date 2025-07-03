# BytesStore

Store for a `Bytes` object.The layout of a `Bytes` object in storage is as follows: * Only the size in bytes is stored in the original address where the bytes object is stored. * The actual data is stored in chunks of 256 `u128` values in another location in storage determined by the hash of: - The address storing the size of the bytes object. - The chunk index. - The short string `Bytes`.

Fully qualified path: `alexandria_bytes::storage::BytesStore`

```rust
pub impl BytesStore of Store<Bytes>
```

## Impl functions

### read

Fully qualified path: `alexandria_bytes::storage::BytesStore::read`

```rust
fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<Bytes>
```

### write

Fully qualified path: `alexandria_bytes::storage::BytesStore::write`

```rust
fn write(address_domain: u32, base: StorageBaseAddress, value: Bytes) -> SyscallResult<()>
```

### read_at_offset

Fully qualified path: `alexandria_bytes::storage::BytesStore::read_at_offset`

```rust
fn read_at_offset(address_domain: u32, base: StorageBaseAddress, offset: u8) -> SyscallResult<Bytes>
```

### write_at_offset

Fully qualified path: `alexandria_bytes::storage::BytesStore::write_at_offset`

```rust
fn write_at_offset(
    address_domain: u32, base: StorageBaseAddress, offset: u8, value: Bytes,
) -> SyscallResult<()>
```

### size

Fully qualified path: `alexandria_bytes::storage::BytesStore::size`

```rust
fn size() -> u8
```

