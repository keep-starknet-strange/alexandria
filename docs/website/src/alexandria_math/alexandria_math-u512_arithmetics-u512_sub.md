# u512_sub

Subtracts two u512 values with overflow panic

#### Arguments

- `lhs` - Left operand (u512)
- `rhs` - Right operand (u512)

#### Returns

- `u512` - Difference of lhs and rhs

#### Panics

- Panics if the subtraction would underflow (result < 0)

Fully qualified path: `alexandria_math::u512_arithmetics::u512_sub`

```rust
pub fn u512_sub(lhs: u512, rhs: u512) -> u512
```
