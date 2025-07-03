# pad_left_data

Pads each `u128` value in the given array with zeros on the left if its byte size is smaller than `bytes_per_element`.

## Arguments

- `data` - An array of `u128` values that may require padding.
- `bytes_per_element` - The target byte size for each element in the array.

## Returns

- A new `Array<u128>` where each element is either unchanged (if already `bytes_per_element` bytes) or padded with zeros.

## Padding Strategy

If the byte size of `value` is less than `bytes_per_element`, zeros are added to the left using `u128_join`.

Fully qualified path: `alexandria_bytes::utils::pad_left_data`

```rust
pub fn pad_left_data(data: Array<u128>, bytes_per_element: usize) -> Array<u128>
```
