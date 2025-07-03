# u128_array_slice

Returns the slice of an array.

## Arguments

- `arr` - The array to slice.
- `begin` - The index to start the slice at.
- `len` - The length of the slice.

## Returns

- `Array<u128>` - The slice of the array.

Fully qualified path: `alexandria_bytes::utils::u128_array_slice`

```rust
pub fn u128_array_slice(src: @Array<u128>, mut begin: usize, len: usize) -> Array<u128>
```
