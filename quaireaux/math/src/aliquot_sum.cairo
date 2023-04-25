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

    let limit = (number / 2) + 1;
    let mut index = 1;
    let mut res = 0;
    loop {
        check_gas();

        if index == limit {
            break res;
        }

        let r = number % index;
        if r == 0 {
            res = res + index;
        }
        index = index + 1;
    }
}
