# bm_search

Find `pattern` in `text` and return the index of every match.

## Arguments

- `text` - The text to search in.
- `pattern` - The pattern to search for.

## Returns

- `Array<usize>` - The index of every match.

Fully qualified path: `alexandria_searching::bm_search::bm_search`

```rust
pub fn bm_search(text: @ByteArray, pattern: @ByteArray) -> Array<usize>
```
