# SortableVec

Trait for sorting algorithms that work with Felt252Vec

Fully qualified path: `alexandria_sorting::interface::SortableVec`

```rust
pub trait SortableVec
```

## Trait functions

### sort

Sorts a Felt252Vec and returns a new sorted Felt252Vec

Fully qualified path: `alexandria_sorting::interface::SortableVec::sort`

```rust
fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +Felt252DictValue<T>>(
    array: Felt252Vec<T>,
) -> Felt252Vec<T>
```

