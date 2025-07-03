# BitArrayTrait

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait`

```rust
pub trait BitArrayTrait
```

## Trait functions

### new

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::new`

```rust
fn new(data: Array<bytes31>, current: felt252, read_pos: usize, write_pos: usize) -> BitArray
```

### current

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::current`

```rust
fn current(self: @BitArray) -> felt252
```

### data

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::data`

```rust
fn data(self: BitArray) -> Array<bytes31>
```

### append_bit

Appends a single bit to the BitArray

#### Arguments

- `bit` - either true or false, representing a single bit to be appended

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::append_bit`

```rust
fn append_bit(ref self: BitArray, bit: bool)
```

### at

Reads a single bit from the array

#### Arguments

- `index` - the index into the array to read

#### Returns

- `Option<bool>` - if the index is found, the stored bool is returned

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::at`

```rust
fn at(self: @BitArray, index: usize) -> Option<bool>
```

### len

The current length of the BitArray

#### Returns

- `usize` - length in bits of the BitArray

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::len`

```rust
fn len(self: @BitArray) -> usize
```

### pop_front

Returns and removes the first element of the BitArray

#### Returns

- `Option<bool>` - If the array is non-empty, a `bool` is removed from the front and returned

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::pop_front`

```rust
fn pop_front(ref self: BitArray) -> Option<bool>
```

### read_word_be

Reads a single word of the specified length up to 248 bits in big endian bit representation

#### Arguments

- `length` - The bit length of the word to read, max 248

#### Returns

- `Option<felt252>` - If there are `length` bits remaining, the word is returned as felt252

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::read_word_be`

```rust
fn read_word_be(ref self: BitArray, length: usize) -> Option<felt252>
```

### read_word_be_u256

Reads a single word of the specified length up to 256 bits in big endian representation. For words shorter than (or equal to) 248 bits use `read_word_be(...)` instead.

#### Arguments

`length` - The bit length of the word to read, max 256

#### Returns `Option<u256>`

- If there are `length` bits remaining, the word is returned as u256

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::read_word_be_u256`

```rust
fn read_word_be_u256(ref self: BitArray, length: usize) -> Option<u256>
```

### read_word_be_u512

Reads a single word of the specified length up to 512 bits in big endian representation. For words shorter than (or equal to) 256 bits consider the other read calls instead.

#### Arguments

`length` - The bit length of the word to read, max 512

#### Returns

`Option<u512>` - If there are `length` bits remaining, the word is returned as u512

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::read_word_be_u512`

```rust
fn read_word_be_u512(ref self: BitArray, length: usize) -> Option<u512>
```

### write_word_be

Writes the bits of the specified length from `word` onto the BitArray in big endian representation

#### Arguments

`word` - The value to store onto the bit array of type `felt252`
`length` - The length of the word in bits, maximum 248

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::write_word_be`

```rust
fn write_word_be(ref self: BitArray, word: felt252, length: usize)
```

### write_word_be_u256

Writes the bits of the specified length from `word` onto the BitArray in big endian representation

#### Arguments

`word` - The value to store onto the bit array of type `u256`
`length` - The length of the word in bits, maximum 256

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::write_word_be_u256`

```rust
fn write_word_be_u256(ref self: BitArray, word: u256, length: usize)
```

### write_word_be_u512

Writes the bits of the specified length from `word` onto the BitArray in big endian representation

#### Arguments

`word` - The value to store onto the bit array of type `u512`
`length` - The length of the word in bits, maximum 512

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::write_word_be_u512`

```rust
fn write_word_be_u512(ref self: BitArray, word: u512, length: usize)
```

### read_word_le

Reads a single word of the specified length up to 248 bits in little endian bit representation

#### Arguments

`length` - The bit length of the word to read, max 248

#### Returns

`Option<felt252>` - If there are `length` bits remaining, the word is returned as felt252

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::read_word_le`

```rust
fn read_word_le(ref self: BitArray, length: usize) -> Option<felt252>
```

### read_word_le_u256

Reads a single word of the specified length up to 256 bits in little endian representation. For words shorter than (or equal to) 248 bits use `read_word_be(...)` instead.

#### Arguments

`length` - The bit length of the word to read, max 256

#### Returns

`Option<u256>` - If there are `length` bits remaining, the word is returned as u256

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::read_word_le_u256`

```rust
fn read_word_le_u256(ref self: BitArray, length: usize) -> Option<u256>
```

### read_word_le_u512

Reads a single word of the specified length up to 512 bits in little endian representation. For words shorter than (or equal to) 256 bits consider the other read calls instead.

#### Arguments

`length` - The bit length of the word to read, max 512

#### Returns

`Option<u512>` - If there are `length` bits remaining, the word is returned as u512

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::read_word_le_u512`

```rust
fn read_word_le_u512(ref self: BitArray, length: usize) -> Option<u512>
```

### write_word_le

Writes the bits of the specified length from `word` onto the BitArray in little endian representation

#### Arguments

`word` - The value to store onto the bit array of type `felt252`
`length` - The length of the word in bits, maximum 248

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::write_word_le`

```rust
fn write_word_le(ref self: BitArray, word: felt252, length: usize)
```

### write_word_le_u256

Writes the bits of the specified length from `word` onto the BitArray in little endian representation

#### Arguments

`word` - The value to store onto the bit array of type `u256`
`length` - The length of the word in bits, maximum 256

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::write_word_le_u256`

```rust
fn write_word_le_u256(ref self: BitArray, word: u256, length: usize)
```

### write_word_le_u512

Writes the bits of the specified length from `word` onto the BitArray in little endian representation

#### Arguments

`word` - The value to store onto the bit array of type `u512`
`length` - The length of the word in bits, maximum 512

Fully qualified path: `alexandria_data_structures::bit_array::BitArrayTrait::write_word_le_u512`

```rust
fn write_word_le_u512(ref self: BitArray, word: u512, length: usize)
```
