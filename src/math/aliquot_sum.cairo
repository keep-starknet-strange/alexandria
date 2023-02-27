//! # Aliquot Sum

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;
// Internal imports.
use quaireaux::utils;

/// Calculates the aliquot sum of a given number.
/// # Arguments
/// * `number` - The number to calculate the aliquot sum for.
/// # Returns
/// * `felt` - The aliquot sum of the input number.
fn aliquot_sum(number: felt) -> felt {
    if number == 1 | number == 0 {
        return 0;
    }

    let limit = utils::unsafe_euclidean_div_no_remainder(number, 2);
    _aliquot_sum(number, limit + 1, 1, 0)
}

/// Recursive helper function for aliquot_sum.
/// # Arguments
/// * `number` - The number to calculate the aliquot sum for.
/// * `limit` - The maximum divisor to consider.
/// * `index` - The current divisor being evaluated in the recursive loop.
/// * `sum` - The sum of divisors found so far.
/// # Returns
/// * `felt` - The final aliquot sum for the given number.
fn _aliquot_sum(number: felt, limit: felt, index: felt, sum: felt) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match try_fetch_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = array_new::<felt>();
            array_append::<felt>(ref data, 'OOG');
            panic(data);
        },
    }
    if index == limit {
        return 0;
    }
    let (_, r) = utils::unsafe_euclidean_div(number, index);
    if r == 0 {
        return index + _aliquot_sum(number, limit, index + 1, sum);
    } else {
        return _aliquot_sum(number, limit, index + 1, sum);
    }
}
