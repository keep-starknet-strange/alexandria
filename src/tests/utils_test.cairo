// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;
use traits::Into;
use quaireaux::utils;

// Test power function
#[test]
#[available_gas(2000000)]
fn count_digits_of_base_test() {
    assert(utils::count_digits_of_base(0, 10) == 0, 'invalid result');
    assert(utils::count_digits_of_base(2, 10) == 1, 'invalid result');
    assert(utils::count_digits_of_base(10, 10) == 2, 'invalid result');
    assert(utils::count_digits_of_base(100, 10) == 3, 'invalid result');
    assert(utils::count_digits_of_base(0x80, 16) == 2, 'invalid result');
    assert(utils::count_digits_of_base(0x800, 16) == 3, 'invalid result');
    assert(utils::count_digits_of_base(0x888888888888888888, 16) == 18, 'invalid result');
}

// Test for power function
#[test]
#[available_gas(2000000)]
fn pow_test() {
    assert(utils::pow(2, 0) == 1, 'invalid result');
    assert(utils::pow(2, 1) == 2, 'invalid result');
    assert(utils::pow(2, 12) == 4096, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn array_slice_test() {
    let mut arr = ArrayTrait::<u256>::new();
    arr.append(1.into());
    arr.append(2.into());
    arr.append(3.into());

    let slice = utils::array_slice(@arr, 0_usize, 2_usize);
    assert(slice.len() == 2_usize, 'invalid result');
    assert(*slice.at(0_usize) == 1.into(), 'invalid result');
    assert(*slice.at(1_usize) == 2.into(), 'invalid result');
}
