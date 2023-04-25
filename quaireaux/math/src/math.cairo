use option::OptionTrait;
use traits::Into;
use traits::TryInto;

use quaireaux_utils::check_gas;

// Raise a number to a power.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `felt252` - The result of base raised to the power of exp.
fn pow(base: u128, exp: u128) -> u128 {
    check_gas();

    if exp == 0 {
        1
    } else {
        base * pow(base, exp - 1)
    }
}

// Function to count the number of digits in a number.
/// # Arguments
/// * `num` - The number to count the digits of.
/// * `base` - Base in which to count the digits.
/// # Returns
/// * `felt252` - The number of digits in num of base
fn count_digits_of_base(num: u128, base: u128) -> u128 {
    check_gas();

    if num == 0 {
        num
    } else {
        let quotient = num / base;
        count_digits_of_base(quotient, base) + 1
    }
}
