//! # Perfect Number.
use array::ArrayTrait;

use quaireaux_utils::check_gas;

/// Algorithm to determine if a number is a perfect number
/// # Arguments
/// * `num` - The number to be checked.
/// # Returns
/// * `bool` - True if num is a perfect number, false otherwise.
fn is_perfect_number(num: u128) -> bool {
    if num == 0 {
        return false;
    }
    if num == 1 {
        return false;
    }

    let mut index = 1;
    let mut sum = 0;
    loop {
        check_gas();

        if index == num - 1 {
            break num == sum;
        }
        let r = num % index;
        if r == 0 {
            sum = sum + index;
        }
        index = index + 1;
    }
}

/// Algorithm to determine all the perfect numbers up to a maximum value
/// # Arguments
/// * `max` - The maximum value to check for perfect numbers.
/// # Returns
/// * `Array` - An array of perfect numbers up to the max value.
fn perfect_numbers(max: u128) -> Array<u128> {
    let mut res = ArrayTrait::new();
    let mut index = 1;

    loop {
        check_gas();

        if index == max {
            break ();
        }
        if is_perfect_number(index) {
            res.append(index);
        }
        index = index + 1;
    };
    res
}
