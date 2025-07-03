# binary_search

Performs binary search on a sorted span to find the exact position of a target value.

Time complexity: O(log n) Space complexity: O(log n) due to recursion

## Arguments

- `span` - A sorted span of elements to search in
- `val` - The target value to search for

## Returns

- `Option<u32>` - Some(index) if value is found, None if not found

## Requirements

- The input span must be sorted in ascending order
- Type T must implement Copy, Drop, PartialEq, and PartialOrd traits

Fully qualified path: `alexandria_searching::binary_search::binary_search`

```rust
pub fn binary_search<T, +Copy<T>, +Drop<T>, +PartialEq<T>, +PartialOrd<T>>(
    span: Span<T>, val: T,
) -> Option<u32>
```
