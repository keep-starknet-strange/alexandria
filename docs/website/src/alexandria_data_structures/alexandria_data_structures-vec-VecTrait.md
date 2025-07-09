# VecTrait

Fully qualified path: `alexandria_data_structures::vec::VecTrait`

```rust
pub trait VecTrait<V, T>
```

## Trait functions

### new

Creates a new V instance. Returns * V The new vec instance.

Fully qualified path: `alexandria_data_structures::vec::VecTrait::new`

```rust
fn new() -> V
```

### get

Returns the item at the given index, or None if the index is out of bounds. Parameters * self The vec instance. * index The index of the item to get. Returns * Option The item at the given index, or None if the index is out of bounds.

Fully qualified path: `alexandria_data_structures::vec::VecTrait::get`

```rust
fn get(ref self: V, index: usize) -> Option<T>
```

### at

Returns the item at the given index, or panics if the index is out of bounds. Parameters * self The vec instance. * index The index of the item to get. Returns * T The item at the given index.

Fully qualified path: `alexandria_data_structures::vec::VecTrait::at`

```rust
fn at(ref self: V, index: usize) -> T
```

### push

Pushes a new item to the vec. Parameters * self The vec instance. * value The value to push onto the vec.

Fully qualified path: `alexandria_data_structures::vec::VecTrait::push`

```rust
fn push(ref self: V, value: T)
```

### set

Sets the item at the given index to the given value. Panics if the index is out of bounds. Parameters * self The vec instance. * index The index of the item to set. * value The value to set the item to.

Fully qualified path: `alexandria_data_structures::vec::VecTrait::set`

```rust
fn set(ref self: V, index: usize, value: T)
```

### len

Returns the length of the vec. Parameters * self The vec instance. Returns * usize The length of the vec.

Fully qualified path: `alexandria_data_structures::vec::VecTrait::len`

```rust
fn len(self: @V) -> usize
```

