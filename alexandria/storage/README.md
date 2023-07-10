# Storage

## List

An ordered sequence of values that can be used in Starknet storage:

```rust
#[storage]
stuct Storage {
    amounts: List<u128>
}
```

### Interface

```rust
trait ListTrait<T> {
    fn len(self: @List<T>) -> u32;
    fn is_empty(self: @List<T>) -> bool;
    fn append(ref self: List<T>, value: T) -> u32;
    fn get(self: @List<T>, index: u32) -> Option<T>;
    fn set(ref self: List<T>, index: u32, value: T);
    fn pop_front(ref self: List<T>) -> Option<T>;
    fn array(self: @List<T>) -> Array<T>;
}
```

`List` also implements `IndexView` so you can use the familiar bracket notation to access its members:

```rust
let second = self.amounts.read()[1];
```

Note that unlike `get`, using this bracket notation panics when accessing an out of bounds index.

### Support for custom types

`List` supports most of the corelib types out of the box. However if you have a custom type that you'd like to store in a `List`, you will have to implement the `StorageSize` trait. It's a simple trait, just one function `storage_size` returning the number of storage slots necessary for your type.

Let's look at an example:

```rust
use alexandria::storage::StorageSize;

#[derive(starknet::StorageAccess)]
struct Dimensions {
    width: u128,
    height: u128,
    depth: u128
}

impl DimensionsStorageSize of StorageSize<Dimensions> {
    fn storage_size() -> u8 {
        3
    }
}
```

To save the `Dimensions` struct into storage, we need 3 storage slots for each of its members, as returned from the `storage_size` function.

Note that for obvious reasons, any type you want to store in a `List` also has to implement the `StorageAccess` trait, hence the `#[derive(starknet::StorageAccess)]
` above.

### Caveats

There are two idiosyncacies you should be aware of when using `List`
1. The `append` operation costs 2 storage writes - one for the value itself and another one for updating the List's length
2. Due to a compiler limitation, it is not possible to use mutating operations with a single inline statement. For example, `self.amounts.read().append(42);` will not work. You have to do it in 2 steps:

```rust
let mut amounts = self.amounts.read();
amounts.append(42);
```
