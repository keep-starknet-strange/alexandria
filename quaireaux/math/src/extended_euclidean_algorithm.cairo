//! # Extended Euclidean Algorithm.
use quaireaux_utils::check_gas;

/// Extended Euclidean Algorithm.
/// # Arguments
/// * `a` - First number.
/// * `b` - Second number.
/// # Returns
/// * `gcd` - Greatest common divisor.
/// * `x` - First Bezout coefficient.
/// * `y` - Second Bezout coefficient.
fn extended_euclidean_algorithm(a: u128, b: u128) -> (u128, u128, u128) {
    // Initialize variables.
    let mut old_r = a;
    let mut rem = b;
    let mut old_s = 1;
    let mut coeff_s = 0;
    let mut old_t = 0;
    let mut coeff_t = 1;

    // Loop until remainder is 0.
    loop_euclidian(ref old_r, ref rem, ref old_s, ref coeff_s, ref old_t, ref coeff_t);
    (old_r, old_s, old_t)
}


fn loop_euclidian(
    ref old_r: u128,
    ref rem: u128,
    ref old_s: u128,
    ref coeff_s: u128,
    ref old_t: u128,
    ref coeff_t: u128
) {
    check_gas();

    // Break if remainder is 0.
    if rem == 0 {
        return ();
    }

    let quotient = old_r / rem;

    update_step(ref rem, ref old_r, quotient);
    update_step(ref coeff_s, ref old_s, quotient);
    update_step(ref coeff_t, ref old_t, quotient);

    // Loop again.
    loop_euclidian(ref old_r, ref rem, ref old_s, ref coeff_s, ref old_t, ref coeff_t);
}

/// Update the step of the extended Euclidean algorithm.
fn update_step(ref a: u128, ref old_a: u128, quotient: u128) {
    let temp = a;
    a = old_a - quotient * temp;
    old_a = temp;
}
