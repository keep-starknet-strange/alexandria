# u128_split

Split a u128 into two parts, [0, left_size-1] and [left_size, end].

## Arguments

- `value` - Data of u128
- `value_size` - The size of `value` in bytes
- `left_size` - The size of left part in bytes

## Returns

- `left` - [0, left_size-1] of the origin u128
- `right` - [left_size, end] of the origin u128 which size is (value_size - left_size)

## Examples

- u128_split(0x01020304, 4, 0) -> (0, 0x01020304)
- u128_split(0x01020304, 4, 1) -> (0x01, 0x020304)
- u128_split(0x0001020304, 5, 1) -> (0x00, 0x01020304)

Fully qualified path: `alexandria_bytes::utils::u128_split`

```rust
pub fn u128_split(value: u128, value_size: usize, left_size: usize) -> (u128, u128)
```
