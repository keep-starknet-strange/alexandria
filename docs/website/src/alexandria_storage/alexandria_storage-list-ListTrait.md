# ListTrait

Fully qualified path: `alexandria_storage::list::ListTrait`

```rust
pub trait ListTrait<T>
```

## Trait functions

### new

Instantiates a new List with the given base address.

#### Arguments

- `address_domain` - The domain of the address. Only address_domain 0 is currently supported, in the future it will enable access to address spaces with different data availability
- `base` - The base address of the List. This corresponds to the location in storage of the List's first element.

#### Returns

A new List.

Fully qualified path: `alexandria_storage::list::ListTrait::new`

```rust
fn new(address_domain: u32, base: StorageBaseAddress) -> List<T>
```

### fetch

Fetches an existing List stored at the given base address. Returns an error if the storage read fails.

#### Arguments

- `address_domain` - The domain of the address. Only address_domain 0 is currently supported, in the future it will enable access to address spaces with different data availability
- `base` - The base address of the List. This corresponds to the location in storage of the List's first element.

#### Returns

An instance of the List fetched from storage, or an error in `SyscallResult`.

Fully qualified path: `alexandria_storage::list::ListTrait::fetch`

```rust
fn fetch(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<List<T>>
```

### append_span

Appends an existing Span to a List. Returns an error if the span cannot be appended to the a list due to storage errors.

#### Arguments

- `self` - The List to add the span to.
- `span` - A Span to append to the List.

#### Returns

A List constructed from the span or an error in `SyscallResult`.

Fully qualified path: `alexandria_storage::list::ListTrait::append_span`

```rust
fn append_span(ref self: List<T>, span: Span<T>) -> SyscallResult<()>
```

### len

Gets the length of the List.

#### Returns

The number of elements in the List.

Fully qualified path: `alexandria_storage::list::ListTrait::len`

```rust
fn len(self: @List<T>) -> u32
```

### is_empty

Checks if the List is empty.

#### Returns

`true` if the List is empty, `false` otherwise.

Fully qualified path: `alexandria_storage::list::ListTrait::is_empty`

```rust
fn is_empty(self: @List<T>) -> bool
```

### append

Appends a value to the end of the List. Returns an error if the append operation fails due to reasons such as storage issues.

#### Arguments

- `value` - The value to append.

#### Returns

The index at which the value was appended or an error in `SyscallResult`.

Fully qualified path: `alexandria_storage::list::ListTrait::append`

```rust
fn append(ref self: List<T>, value: T) -> SyscallResult<u32>
```

### get

Retrieves an element by index from the List. Returns an error if there is a retrieval issue.

#### Arguments

- `index` - The index of the element to retrieve.

#### Returns

An `Option<T>` which is `None` if the list is empty, or `Some(value)` if an element was found, encapsulated in `SyscallResult`.

Fully qualified path: `alexandria_storage::list::ListTrait::get`

```rust
fn get(self: @List<T>, index: u32) -> SyscallResult<Option<T>>
```

### set

Sets the value of an element at a given index.

#### Arguments

- `index` - The index of the element to modify.
- `value` - The value to set at the given index.

#### Returns

A result indicating success or encapsulating the error in `SyscallResult`.

#### PanicsPanics if the index is out of bounds.

Fully qualified path: `alexandria_storage::list::ListTrait::set`

```rust
fn set(ref self: List<T>, index: u32, value: T) -> SyscallResult<()>
```

### clean

Clears the List by setting its length to 0.The storage is not actually cleared, only the length is set to 0. The values can still be accessible using low-level syscalls, but cannot be accessed through the list interface.

Fully qualified path: `alexandria_storage::list::ListTrait::clean`

```rust
fn clean(ref self: List<T>)
```

### pop_front

Removes and returns the first element of the List.The storage is not actually cleared, only the length is decreased by one. The value popped can still be accessible using low-level syscalls, but cannot be accessed through the list interface.

#### Returns

An `Option<T>` which is `None` if the index is out of bounds, or `Some(value)` if an element was found at the given index, encapsulated in `SyscallResult`.

Fully qualified path: `alexandria_storage::list::ListTrait::pop_front`

```rust
fn pop_front(ref self: List<T>) -> SyscallResult<Option<T>>
```

### array

Converts the List into an Array. If the list cannot be converted to an array due storage errors, an error is returned.

#### Returns

An `Array<T>` containing all the elements of the List, encapsulated in `SyscallResult`.

Fully qualified path: `alexandria_storage::list::ListTrait::array`

```rust
fn array(self: @List<T>) -> SyscallResult<Array<T>>
```

### storage_size

Fully qualified path: `alexandria_storage::list::ListTrait::storage_size`

```rust
fn storage_size(self: @List<T>) -> u8
```
