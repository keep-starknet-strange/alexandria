# ArrayTraitExt

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt`

```rust
pub trait ArrayTraitExt<T, +Clone<T>, +Drop<T>>
```

## Trait functions

### append_all

Moves all the elements of `other` into `self`, leaving `other` empty.

#### Arguments

- `self` - The array to append elements to
- `other` - The array to move elements from

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::append_all`

```rust
fn append_all(ref self: Array<T>, ref other: Array<T>)
```

### extend_from_span

Clones and appends all the elements of `other` into `self`.

#### Arguments

- `self` - The array to extend
- `other` - The span containing elements to clone and append

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::extend_from_span`

```rust
fn extend_from_span(ref self: Array<T>, other: Span<T>)
```

### pop_front_n

Removes up to `n` elements from the front of `self` and returns them in a new array.

#### Arguments

- `self` - The array to remove elements from
- `n` - The maximum number of elements to remove

#### Returns

- `Array<T>` - New array containing the removed elements

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::pop_front_n`

```rust
fn pop_front_n(ref self: Array<T>, n: usize) -> Array<T>
```

### remove_front_n

Removes up to `n` elements from the front of `self`.

#### Arguments

- `self` - The array to remove elements from
- `n` - The maximum number of elements to remove

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::remove_front_n`

```rust
fn remove_front_n(ref self: Array<T>, n: usize)
```

### concat

Clones and appends all the elements of `self` and then `other` in a single new array.

#### Arguments

- `self` - The first array to concatenate
- `other` - The second array to concatenate

#### Returns

- `Array<T>` - New array containing elements from both arrays

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::concat`

```rust
fn concat(self: @Array<T>, other: @Array<T>) -> Array<T>
```

### reversed

Return a new array containing the elements of `self` in a reversed order.

#### Arguments

- `self` - The array to reverse

#### Returns

- `Array<T>` - New array with elements in reverse order

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::reversed`

```rust
fn reversed(self: @Array<T>) -> Array<T>
```

### contains

Returns `true` if the array contains an element with the given value.

#### Arguments

- `self` - The array to search
- `item` - The item to search for

#### Returns

- `bool` - True if the item is found, false otherwise

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::contains`

```rust
fn contains<+PartialEq<T>>(self: @Array<T>, item: @T) -> bool
```

### position

Searches for an element in the array, returning its index.

#### Arguments

- `self` - The array to search
- `item` - The item to find the position of

#### Returns

- `Option<usize>` - Some(index) if found, None otherwise

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::position`

```rust
fn position<+PartialEq<T>>(self: @Array<T>, item: @T) -> Option<usize>
```

### occurrences

Returns the number of elements in the array with the given value.

#### Arguments

- `self` - The array to search
- `item` - The item to count occurrences of

#### Returns

- `usize` - The number of times the item appears

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::occurrences`

```rust
fn occurrences<+PartialEq<T>>(self: @Array<T>, item: @T) -> usize
```

### min

Returns the minimum element of an array.

#### Arguments

- `self` - The array to find the minimum in

#### Returns

- `Option<T>` - Some(min_element) if array is not empty, None otherwise

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::min`

```rust
fn min<+PartialOrd<@T>>(self: @Array<T>) -> Option<T>
```

### min_position

Returns the position of the minimum element of an array.

#### Arguments

- `self` - The array to find the minimum position in

#### Returns

- `Option<usize>` - Some(index) of minimum element, None if array is empty

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::min_position`

```rust
fn min_position<+PartialOrd<@T>>(self: @Array<T>) -> Option<usize>
```

### max

Returns the maximum element of an array.

#### Arguments

- `self` - The array to find the maximum in

#### Returns

- `Option<T>` - Some(max_element) if array is not empty, None otherwise

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::max`

```rust
fn max<+PartialOrd<@T>>(self: @Array<T>) -> Option<T>
```

### max_position

Returns the position of the maximum element of an array.

#### Arguments

- `self` - The array to find the maximum position in

#### Returns

- `Option<usize>` - Some(index) of maximum element, None if array is empty

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::max_position`

```rust
fn max_position<+PartialOrd<@T>>(self: @Array<T>) -> Option<usize>
```

### dedup

Returns a new array, cloned from `self` but removes consecutive repeated elements. If the array is sorted, this removes all duplicates.

#### Arguments

- `self` - The array to deduplicate

#### Returns

- `Array<T>` - New array with consecutive duplicates removed

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::dedup`

```rust
fn dedup<+PartialEq<T>>(self: @Array<T>) -> Array<T>
```

### unique

Returns a new array, cloned from `self` but without any duplicate.

#### Arguments

- `self` - The array to remove duplicates from

#### Returns

- `Array<T>` - New array with all duplicates removed

Fully qualified path: `alexandria_data_structures::array_ext::ArrayTraitExt::unique`

```rust
fn unique<+PartialEq<T>>(self: @Array<T>) -> Array<T>
```
