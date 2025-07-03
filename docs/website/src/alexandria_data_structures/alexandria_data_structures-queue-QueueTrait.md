# QueueTrait

Fully qualified path: `alexandria_data_structures::queue::QueueTrait`

```rust
pub trait QueueTrait<T>
```

## Trait functions

### new

Creates a new empty queue

#### Returns

- `Queue<T>` - A new empty queue instance

Fully qualified path: `alexandria_data_structures::queue::QueueTrait::new`

```rust
fn new() -> Queue<T>
```

### enqueue

Adds an element to the back of the queue

#### Arguments

- `self` - The queue to add the element to
- `value` - The element to add

Fully qualified path: `alexandria_data_structures::queue::QueueTrait::enqueue`

```rust
fn enqueue(ref self: Queue<T>, value: T)
```

### dequeue

Removes and returns the front element from the queue

#### Arguments

- `self` - The queue to remove the element from

#### Returns

- `Option<T>` - Some(element) if queue is not empty, None otherwise

Fully qualified path: `alexandria_data_structures::queue::QueueTrait::dequeue`

```rust
fn dequeue(ref self: Queue<T>) -> Option<T>
```

### peek_front

Returns a reference to the front element without removing it

#### Arguments

- `self` - The queue to peek into

#### Returns

- `Option<Box<@T>>` - Some(reference) to front element if queue is not empty, None otherwise

Fully qualified path: `alexandria_data_structures::queue::QueueTrait::peek_front`

```rust
fn peek_front(self: @Queue<T>) -> Option<Box<@T>>
```

### len

Returns the number of elements in the queue

#### Arguments

- `self` - The queue to get the length of

#### Returns

- `usize` - The number of elements in the queue

Fully qualified path: `alexandria_data_structures::queue::QueueTrait::len`

```rust
fn len(self: @Queue<T>) -> usize
```

### is_empty

Checks if the queue is empty

#### Arguments

- `self` - The queue to check

#### Returns

- `bool` - True if the queue contains no elements, false otherwise

Fully qualified path: `alexandria_data_structures::queue::QueueTrait::is_empty`

```rust
fn is_empty(self: @Queue<T>) -> bool
```
