# binary_search_closest

Performs binary search to find the position where a value would be inserted to maintain sorted order, or the closest position to the target value.

Time complexity: O(log n) Space complexity: O(log n) due to recursion

## Arguments

- `span` - A sorted span of elements to search in
- `val` - The target value to find the closest position for

## Returns

- `Option<u32>` - Some(index) of the closest position, None if span is empty or no valid position

## Requirements

- The input span must be sorted in ascending order
- Type T must implement Copy, Drop, and PartialOrd traits

## Behavior

- Returns the index where val would fit in the sorted order
- Useful for insertion points and range queries

Fully qualified path: `alexandria_searching::binary_search::binary_search_closest`

```rust
pub fn binary_search_closest<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(
    span: Span<T>, val: T,
) -> Option<u32>
```
