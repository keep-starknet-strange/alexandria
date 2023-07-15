//! # Extended Euclidean Algorithm.
use integer::{u128_overflowing_sub, u128_overflowing_mul};

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
    loop {
        if rem == 0 {
            break (old_r, old_s, old_t);
        }
        let quotient = old_r / rem;

        update_step(ref rem, ref old_r, quotient);
        update_step(ref coeff_s, ref old_s, quotient);
        update_step(ref coeff_t, ref old_t, quotient);
    }
}

/// Update the step of the extended Euclidean algorithm.
fn update_step(ref a: u128, ref old_a: u128, quotient: u128) {
    let temp = a;
    let (bottom, _) = u128_overflowing_mul(quotient, temp);
    a = u128_wrapping_sub(old_a, bottom);
    old_a = temp;
}

fn u128_wrapping_sub(a: u128, b: u128) -> u128 implicits(RangeCheck) nopanic {
    match u128_overflowing_sub(a, b) {
        Result::Ok(x) => x,
        Result::Err(x) => x,
    }
}
