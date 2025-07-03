# MergeSort

Fully qualified path: `alexandria_sorting::merge_sort::MergeSort`

```rust
pub impl MergeSort of Sortable
```

## Impl functions

### sort

Sorts an array using the merge sort algorithm.

## Arguments

- `arr` - Array to sort

## Returns

- `Array<T>` - Sorted array

Fully qualified path: `alexandria_sorting::merge_sort::MergeSort::sort`

```rust
fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(mut array: Span<T>) -> Array<T>
```
