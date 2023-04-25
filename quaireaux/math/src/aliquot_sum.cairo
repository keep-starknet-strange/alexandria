//! # Aliquot Sum
use quaireaux_utils::check_gas;

/// Calculates the aliquot sum of a given number.
/// # Arguments
/// * `number` - The number to calculate the aliquot sum for.
/// # Returns
/// * `felt252` - The aliquot sum of the input number.
fn aliquot_sum(number: u128) -> u128 {
    if number == 0 {
        return 0;
    }
    if number == 1 {
        return 0;
    }

    let limit = (number / 2);
    _aliquot_sum(number, limit + 1, 1, 0)
}

/// Recursive helper function for aliquot_sum.
/// # Arguments
/// * `number` - The number to calculate the aliquot sum for.
/// * `limit` - The maximum divisor to consider.
/// * `index` - The current divisor being evaluated in the recursive loop.
/// * `sum` - The sum of divisors found so far.
/// # Returns
/// * `felt252` - The final aliquot sum for the given number.
fn _aliquot_sum(number: u128, limit: u128, index: u128, sum: u128) -> u128 {
    check_gas();

    if index == limit {
        return 0;
    }

    let r = number % index;
    if r == 0 {
        index + _aliquot_sum(number, limit, index + 1, sum)
    } else {
        _aliquot_sum(number, limit, index + 1, sum)
    }
}
