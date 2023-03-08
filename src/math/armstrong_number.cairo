//! # Armstrong Number Algorithm.

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;
// Internal imports.
use quaireaux::utils;

/// Armstrong Number Algorithm.
/// # Arguments
/// * `num` - The number to be evaluated.
/// # Returns
/// * `bool` - A boolean value indicating is Armstrong Number.
fn is_armstrong_number(num: felt) -> bool {
    _is_armstrong_number(num, num, utils::count_digits_of_base(num, 10))
}

/// Recursive helper function for 'is_armstrong_number'.
/// # Arguments
/// * `num` - The current value being evaluated in the recursive loop.
/// * `original_num` - The original number .
/// * `digits` - The number of digits.
/// # Returns
/// * `bool` - A boolean value indicating is Armstrong Number.
fn _is_armstrong_number(num: felt, original_num: felt, digits: felt) -> bool {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if num == 0 {
        return original_num == 0;
    } else {
        let (new_num, lastDigit) = utils::unsafe_euclidean_div(num, 10);
        let sum = utils::pow(lastDigit, digits);
        return _is_armstrong_number(new_num, original_num - sum, digits);
    }
}
