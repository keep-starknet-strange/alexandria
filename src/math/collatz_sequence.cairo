//! # Collatz Sequence

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;
// Internal imports.
use quaireaux::utils;

/// Generates the Collatz sequence for a given number.
/// # Arguments
/// * `number` - The number to generate the Collatz sequence for.
/// # Returns
/// * `Array` - The Collatz sequence as an array of `felt` numbers.
fn sequence(ref number: felt) -> Array::<felt> {
    let mut res = ArrayTrait::new();
    if number == 0 {
        return res;
    }
    _sequence(ref number, ref res);
    res
}

/// Recursive helper function for sequence.
/// # Arguments
/// * `number` - The number to generate the Collatz sequence for.
/// * `arr` - An array to store the Collatz sequence that have been found.
/// # Returns
/// * `None` - This function does not return a value, it updates the arr argument in place.
fn _sequence(ref number: felt, ref arr: Array::<felt>) {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = array_new::<felt>();
            array_append::<felt>(ref data, 'OOG');
            panic(data);
        },
    }
    arr.append(number);
    if number == 1 {
        return();
    } else {
        calculate_sequence(ref number);
        _sequence(ref number, ref arr);
    }
}

/// Calculates the next number in the Collatz sequence.
fn calculate_sequence(ref number: felt) {
    let temp = number;
    let (q, r) = utils::unsafe_euclidean_div(number, 2);
    if r == 0 {
        number = q;
    } else {
        number = 3 * temp + 1;
    }
}
