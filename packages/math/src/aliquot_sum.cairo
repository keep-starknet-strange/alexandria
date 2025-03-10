//! # Aliquot Sum

/// Calculates the aliquot sum of a given number.
/// # Arguments
/// * `number` - The number to calculate the aliquot sum for.
/// # Returns
/// * `felt252` - The aliquot sum of the input number.
pub fn aliquot_sum(number: u128) -> u128 {
    if number == 0 || number == 1 {
        return 0;
    }

    let limit = (number / 2) + 1;
    let mut index = 2;
    let mut res = 1;
    while (index < limit) {
        if number % index == 0 {
            res = res + index;
        }
        index += 1;
    }
    res
}
