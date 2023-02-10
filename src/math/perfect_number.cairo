//! # Perfect Number.

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;

// Internal imports.
use quaireaux::utils;

/// Algorithm to determine if a number is a perfect number
/// # Arguments
/// * num - The number to be checked.
/// # Returns
/// * bool - True if num is a perfect number, false otherwise.
fn is_perfect_number(num: felt) -> bool {
    _is_perfect_number(num, 1, 0)
}

/// Recursive helper function for is_perfect_number.
/// # Arguments
/// * num - The number to be evaluated as a perfect number.
/// * current - The current value being evaluated in the recursive loop.
/// * sum - The running sum of the divisors of num.
/// # Returns
/// * bool - A boolean value indicating whether num is a perfect number.
fn _is_perfect_number(num: felt, current: felt, sum: felt) -> bool {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if num <= 1 {
        return bool::False(());
    }
    if current == num - 1 {
        return num == sum;
    } 
    
    let (_, r) = utils::unsafe_euclidean_div(num, current);
    if r == 0 {
        return _is_perfect_number(num, current + 1, sum + current);
    } 
    return _is_perfect_number(num, current + 1, sum);
}

/// Algorithm to determine all the perfect numbers up to a maximum value
/// # Arguments
/// * max - The maximum value to check for perfect numbers.
/// # Returns
/// * Array<felt> - An array of perfect numbers up to the max value.
fn perfect_numbers(ref max: felt) -> Array::<felt> {
    let mut res = ArrayTrait::new();
    let mut current = 1;
    _perfect_numbers(ref max, ref current, ref res);
    res
}

/// Recursive helper function for perfect_numbers.
/// # Arguments
/// * max - The maximum value to check for perfect numbers.
/// * current - The current value being evaluated in the recursive loop.
/// * arr - An array to store the perfect numbers that have been found.
/// # Returns
/// * Array - A list of perfect numbers up to the maximum value provided.
fn _perfect_numbers(ref max: felt, ref current: felt, ref arr: Array::<felt>) {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if current == max {
        return ();
    }
    if is_perfect_number(current) {
        arr.append(current);
    }
    update_step(ref current);
    // loop
    _perfect_numbers(ref max, ref current, ref arr);
}

/// Update the step of the function _perfect_numbers.
fn update_step(ref current: felt) {
    current = current + 1;
}
