mod array_ext;

mod bit_array;
mod byte_appender;
mod byte_array_ext;
mod byte_reader;

mod queue;
mod span_ext;
mod stack;
mod vec;

// Utilities

#[inline(always)]
fn get_felt252_array() -> Array<felt252> {
    array![21, 42, 84]
}

#[inline(always)]
fn get_u128_array() -> Array<u128> {
    array![21_u128, 42_u128, 84_u128]
}
