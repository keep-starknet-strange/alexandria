# Sortable

Trait for sorting algorithms that work with Array spans

Fully qualified path: `alexandria_sorting::interface::Sortable`

```rust
pub trait Sortable
```

## Trait functions

### sort

Sorts a span of elements and returns a new sorted array

Fully qualified path: `alexandria_sorting::interface::Sortable::sort`

```rust
fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(array: Span<T>) -> Array<T>
```

