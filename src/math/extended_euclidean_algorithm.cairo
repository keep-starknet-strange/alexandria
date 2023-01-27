//! # Extended Euclidean Algorithm.

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;
// Internal imports.
use quaireaux::utils;

/// Extended Euclidean Algorithm.
/// # Arguments
/// * `a` - First number.
/// * `b` - Second number.
/// # Returns
/// * `gcd` - Greatest common divisor.
/// * `x` - First Bezout coefficient.
/// * `y` - Second Bezout coefficient.
fn extended_euclidean_algorithm(a: felt, b: felt) -> (felt, felt, felt) {
    // Initialize variables.
    let mut old_r = a;
    let mut rem = b;
    let mut old_s = 1;
    let mut coeff_s = 0;
    let mut old_t = 0;
    let mut coeff_t = 1;

    // Loop until remainder is 0.
    loop(ref old_r, ref rem, ref old_s, ref coeff_s, ref old_t, ref coeff_t);
    (old_r, old_s, old_t)
}


fn loop(
    ref old_r: felt,
    ref rem: felt,
    ref old_s: felt,
    ref coeff_s: felt,
    ref old_t: felt,
    ref coeff_t: felt
) {
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
    // Break if remainder is 0.
    if rem == 0 {
        return ();
    }

    let quotient = utils::unsafe_euclidean_div_no_remainder(old_r, rem);

    update_step(ref rem, ref old_r, quotient);
    update_step(ref coeff_s, ref old_s, quotient);
    update_step(ref coeff_t, ref old_t, quotient);

    // Loop again.
    loop(ref old_r, ref rem, ref old_s, ref coeff_s, ref old_t, ref coeff_t);
}

/// Update the step of the extended Euclidean algorithm.
fn update_step(ref a: felt, ref old_a: felt, quotient: felt) {
    let temp = a;
    a = old_a - quotient * temp;
    old_a = temp;
}
