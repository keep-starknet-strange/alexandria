# keccak_u128s_be

Computes the keccak256 of multiple uint128 values. The values are interpreted as big-endian. https://github.com/starkware-libs/cairo/blob/main/corelib/src/keccak.cairo

Fully qualified path: `alexandria_bytes::utils::keccak_u128s_be`

```rust
pub fn keccak_u128s_be(input: Span<u128>, n_bytes: usize) -> u256
```

