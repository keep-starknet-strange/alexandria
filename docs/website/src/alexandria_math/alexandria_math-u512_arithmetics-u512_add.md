# u512_add

Adds two u512 values with overflow panic

#### Arguments

- `lhs` - Left operand (u512)
- `rhs` - Right operand (u512)

#### Returns

- `u512` - Sum of lhs and rhs

#### Panics

- Panics if the addition would overflow u512 bounds

Fully qualified path: `alexandria_math::u512_arithmetics::u512_add`

```rust
pub fn u512_add(lhs: u512, rhs: u512) -> u512
```
