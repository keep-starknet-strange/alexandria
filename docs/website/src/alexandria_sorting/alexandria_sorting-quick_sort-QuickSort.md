# QuickSort

Implementation of QuickSort algorithm for Felt252Vec

Fully qualified path: `alexandria_sorting::quick_sort::QuickSort`

```rust
pub impl QuickSort of SortableVec
```

## Impl functions

### sort

Sorts a Felt252Vec using the QuickSort algorithm. Time complexity: O(n log n) average case, O(n²) worst case. Space complexity: O(log n) due to recursion.

## Arguments

- `Felt252Vec<T>` - Array to sort

## Returns

- `Felt252Vec<T>` - Sorted array

Fully qualified path: `alexandria_sorting::quick_sort::QuickSort::sort`

```rust
fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +Felt252DictValue<T>>(
    mut array: Felt252Vec<T>,
) -> Felt252Vec<T>
```
