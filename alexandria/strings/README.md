# Strings

## [Ascii interger](./src/ascii/interger.cairo)

The ASCII Integer Library serves as a practical tool for converting Cairo's integer types (`u8`, `u16`, `u32`, `u64`, `u128`) into their ASCII representations as `felt252`. It is designed to facilitate seamless interaction between numerical values and their ASCII representations in Cairo programming.

The library centers around the `IntergerToAsciiTrait` trait, which defines three core methods: `to_ascii_array`, `to_inverse_ascii_array`, and `to_ascii`.

-   The `to_ascii_array` method translates an integer into its ASCII equivalent, breaking down each ASCII numeral into separate elements within an array. This function enables programmers to manipulate individual digits of an integer in their ASCII format conveniently.

-   The `to_inverse_ascii_array` method functions identically to `to_ascii_array`, but with a twist - it reverses the order of elements in the integer's ASCII array. This added flexibility accommodates diverse programming needs that might require reverse-digit manipulation.

-   The `to_ascii` method is a more compact option that consolidates the integer's ASCII array into a singular `felt252` value. This value essentially mirrors the integer as a string. For example, applying `2114_u64.to_ascii()` would yield `"2114"`. It's worth noting that the method behaves slightly differently when working with `u128` values. Given that a `u128` ASCII representation could potentially exceed the maximum `felt252` size, the `to_ascii` method splits the `u128` ASCII value into an array if it crosses the size threshold.
