# StackTrait

Fully qualified path: `alexandria_data_structures::stack::StackTrait`

```rust
pub trait StackTrait<S, T>
```

## Trait functions

### new

Creates a new Stack instance.

Fully qualified path: `alexandria_data_structures::stack::StackTrait::new`

```rust
fn new() -> S
```

### push

Pushes a new value onto the stack.

#### Arguments

- `self` - The stack to push the value onto
- `value` - The value to push onto the stack

Fully qualified path: `alexandria_data_structures::stack::StackTrait::push`

```rust
fn push(ref self: S, value: T)
```

### pop

Removes the last item from the stack and returns it, or None if the stack is empty.

#### Arguments

- `self` - The stack to pop the item from

Fully qualified path: `alexandria_data_structures::stack::StackTrait::pop`

```rust
fn pop(ref self: S) -> Option<T>
```

### peek

Returns the last item from the stack without removing it, or None if the stack is empty.

#### Arguments

- `self` - The stack to peek at

Fully qualified path: `alexandria_data_structures::stack::StackTrait::peek`

```rust
fn peek(ref self: S) -> Option<T>
```

### len

Returns the number of items in the stack.

#### Arguments

- `self` - The stack to get the length of

Fully qualified path: `alexandria_data_structures::stack::StackTrait::len`

```rust
fn len(self: @S) -> usize
```

### is_empty

Returns true if the stack is empty.

#### Arguments

- `self` - The stack to check if it is empty

Fully qualified path: `alexandria_data_structures::stack::StackTrait::is_empty`

```rust
fn is_empty(self: @S) -> bool
```
