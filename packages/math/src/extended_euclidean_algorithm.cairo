//! # Extended Euclidean Algorithm.
use core::num::traits::{OverflowingMul, OverflowingSub};

/// Extended Euclidean Algorithm.
/// # Arguments
/// * `a` - First number.
/// * `b` - Second number.
/// # Returns
/// * `gcd` - Greatest common divisor.
/// * `x` - First Bezout coefficient.
/// * `y` - Second Bezout coefficient.
pub fn extended_euclidean_algorithm(a: u128, b: u128) -> (u128, u128, u128) {
    // Initialize variables.
    let mut old_r = a;
    let mut rem = b;
    let mut old_s = 1;
    let mut coeff_s = 0;
    let mut old_t = 0;
    let mut coeff_t = 1;

    while (rem != 0) {
        let quotient = old_r / rem;

        update_step(ref rem, ref old_r, quotient);
        update_step(ref coeff_s, ref old_s, quotient);
        update_step(ref coeff_t, ref old_t, quotient);
    }
    (old_r, old_s, old_t)
}

/// Update the step of the extended Euclidean algorithm.
fn update_step(ref a: u128, ref old_a: u128, quotient: u128) {
    let temp = a;
    let (bottom, _) = quotient.overflowing_mul(temp);
    let (a_tmp, _) = old_a.overflowing_sub(bottom);
    a = a_tmp;
    old_a = temp;
}

