# read_sub_u128

Read sub value from u128 just like substr in other language.

## Arguments

- `value` - Data of u128
- `value_size` - The size of data in bytes
- `offset` - The offset of sub value
- `size` - The size of sub value in bytes

## Returns

- `sub_value` - The sub value of origin u128

## Examples

- u128_sub_value(0x000001020304, 6, 1, 3) -> 0x000102

Fully qualified path: `alexandria_bytes::utils::read_sub_u128`

```rust
pub fn read_sub_u128(value: u128, value_size: usize, offset: usize, size: usize) -> u128
```
