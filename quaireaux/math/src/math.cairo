use option::OptionTrait;
use traits::Into;
use traits::TryInto;

use quaireaux_utils::check_gas;

// Raise a number to a power.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `felt252` - The result of base raised to the power of exp.
fn pow(base: felt252, exp: felt252) -> felt252 {
    check_gas();

    match exp {
        0 => 1,
        _ => base * pow(base, exp - 1),
    }
}

// Function to count the number of digits in a number.
/// # Arguments
/// * `num` - The number to count the digits of.
/// * `base` - Base in which to count the digits.
/// # Returns
/// * `felt252` - The number of digits in num of base
fn count_digits_of_base(num: felt252, base: felt252) -> felt252 {
    check_gas();
    
    if num == 0 {
        num
    } else {
        let quotient = unsafe_euclidean_div_no_remainder(num, base);
        count_digits_of_base(quotient, base) + 1
    }
}

/// Perform euclidean division on `felt252` types.
fn unsafe_euclidean_div_no_remainder(a: felt252, b: felt252) -> felt252 {
    let a_u128 = unsafe_felt252_to_u128(a);
    let b_u128 = unsafe_felt252_to_u128(b);
    (a_u128 / b_u128).into()
}

fn unsafe_euclidean_div(a: felt252, b: felt252) -> (felt252, felt252) {
    let a_u128 = unsafe_felt252_to_u128(a);
    let b_u128 = unsafe_felt252_to_u128(b);
    ((a_u128 / b_u128).into(), (a_u128 % b_u128).into())
}

/// Force conversion from `felt252` to `u128`.
fn unsafe_felt252_to_u128(a: felt252) -> u128 {
    a.try_into().unwrap()
}
