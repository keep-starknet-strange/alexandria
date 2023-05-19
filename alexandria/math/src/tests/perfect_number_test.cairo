// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;

use alexandria_math::perfect_number::{is_perfect_number, perfect_numbers};

// is_perfect_number
#[test]
#[available_gas(2000000)]
fn perfect_small_number_test() {
    assert(is_perfect_number(6) == true, 'invalid result');
    assert(is_perfect_number(28) == true, 'invalid result');
}

#[test]
#[available_gas(20000000)]
fn perfect_big_number_test() {
    assert(is_perfect_number(496) == true, 'invalid result');
}

#[test]
#[available_gas(20000000)]
fn not_perfect_small_number_test() {
    assert(is_perfect_number(5) == false, 'invalid result');
    assert(is_perfect_number(86) == false, 'invalid result');
}

#[test]
#[available_gas(20000000)]
fn not_perfect_big_number_test() {
    assert(is_perfect_number(497) == false, 'invalid result');
}

// perfect_numbers
#[test]
#[available_gas(2000000)]
fn perfect_numbers_test() {
    let mut res = perfect_numbers(10);
    assert(res.len() == 1, 'invalid result');
}
