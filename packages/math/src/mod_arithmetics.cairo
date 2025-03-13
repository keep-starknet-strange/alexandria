use core::integer::{u512, u512_safe_div_rem_by_u256};
use core::num::traits::{OverflowingAdd, OverflowingSub, WideMul, WrappingAdd};

/// Function that performs modular addition. Will panick if result is > u256 max
/// # Arguments
/// * `a` - Left hand side of addition.
/// * `b` - Right hand side of addition.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular addition
#[inline(always)]
pub fn add_mod(a: u256, b: u256, modulo: u256) -> u256 {
    (a + b) % modulo
}

/// Function that return the modular multiplicative inverse. Disclaimer: this function should only
/// be used with a prime modulo.
/// # Arguments
/// * `b` - Number of which to find the multiplicative inverse of.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - modular multiplicative inverse
#[inline(always)]
pub fn mult_inverse(b: u256, mod_non_zero: NonZero<u256>) -> u256 {
    math::u256_inv_mod(b, mod_non_zero).expect('inverse non zero').into()
}

/// Function that return the modular additive inverse.
/// # Arguments
/// * `b` - Number of which to find the additive inverse of.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - modular additive inverse
#[inline(always)]
pub fn add_inverse_mod(b: u256, modulo: u256) -> u256 {
    modulo - b
}

/// Function that performs modular subtraction.
/// # Arguments
/// * `a` - Left hand side of subtraction.
/// * `b` - Right hand side of subtraction.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular subtraction
#[inline(always)]
pub fn sub_mod(mut a: u256, mut b: u256, modulo: u256) -> u256 {
    // reduce values
    a = a % modulo;
    b = b % modulo;
    let (diff, overflow) = a.overflowing_sub(b);
    if overflow {
        // Overflow back with add modulo
        let (diff, _) = diff.overflowing_add(modulo);
        diff
    } else {
        diff
    }
}

/// Function that performs modular multiplication.
/// # Arguments
/// * `a` - Left hand side of multiplication.
/// * `b` - Right hand side of multiplication.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular multiplication
#[inline(always)]
pub fn mult_mod(a: u256, b: u256, mod_non_zero: NonZero<u256>) -> u256 {
    let mult: u512 = WideMul::wide_mul(a, b);
    let (_, rem_u256) = u512_safe_div_rem_by_u256(mult, mod_non_zero);
    rem_u256
}

#[inline(always)]
// core::integer::u128_add_with_carry
fn u128_add_with_carry(a: u128, b: u128) -> (u128, u128) {
    let (v, did_overflow) = a.overflowing_add(b);
    if did_overflow {
        (v, 1)
    } else {
        (v, 0)
    }
}

pub fn u256_wide_sqr(a: u256) -> u512 {
    let u256 { high: limb1, low: limb0 } = WideMul::wide_mul(a.low, a.low);
    let u256 { high: limb2, low: limb1_part } = WideMul::wide_mul(a.low, a.high);
    let (limb1, limb1_overflow0) = u128_add_with_carry(limb1, limb1_part);
    let (limb1, limb1_overflow1) = u128_add_with_carry(limb1, limb1_part);
    let (limb2, limb2_overflow) = u128_add_with_carry(limb2, limb2);
    let u256 { high: limb3, low: limb2_part } = WideMul::wide_mul(a.high, a.high);
    // No overflow since no limb4.
    let limb3 = limb3.wrapping_add(limb2_overflow);
    let (limb2, limb2_overflow) = u128_add_with_carry(limb2, limb2_part);
    // No overflow since no limb4.
    let limb3 = limb3.wrapping_add(limb2_overflow);
    // No overflow possible in this addition since both operands are 0/1.
    let limb1_overflow = limb1_overflow0.wrapping_add(limb1_overflow1);
    let (limb2, limb2_overflow) = u128_add_with_carry(limb2, limb1_overflow);
    // No overflow since no limb4.
    let limb3 = limb3.wrapping_add(limb2_overflow);
    u512 { limb0, limb1, limb2, limb3 }
}

/// Function that performs modular multiplication.
/// # Arguments
/// * `a` - Left hand side of multiplication.
/// * `b` - Right hand side of multiplication.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular multiplication
#[inline(always)]
pub fn sqr_mod(a: u256, mod_non_zero: NonZero<u256>) -> u256 {
    let mult: u512 = u256_wide_sqr(a);
    let (_, rem_u256) = u512_safe_div_rem_by_u256(mult, mod_non_zero);
    rem_u256
}

/// Function that performs modular division.
/// # Arguments
/// * `a` - Left hand side of division.
/// * `b` - Right hand side of division.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular division
#[inline(always)]
pub fn div_mod(a: u256, b: u256, mod_non_zero: NonZero<u256>) -> u256 {
    let inv = math::u256_inv_mod(b, mod_non_zero).unwrap().into();
    math::u256_mul_mod_n(a, inv, mod_non_zero)
}

/// Function that performs modular exponentiation.
/// # Arguments
/// * `base` - Base of exponentiation.
/// * `pow` - Power of exponentiation.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular exponentiation
pub fn pow_mod(mut base: u256, mut pow: u256, mod_non_zero: NonZero<u256>) -> u256 {
    let mut result: u256 = 1;
    while (pow != 0) {
        let (q, r) = DivRem::div_rem(pow, 2);
        if r == 1 {
            result = mult_mod(result, base, mod_non_zero);
        }
        pow = q;
        base = sqr_mod(base, mod_non_zero);
    }

    result
}

pub fn equality_mod(a: u256, b: u256, modulo: u256) -> bool {
    let (_, a_rem) = DivRem::div_rem(a, modulo.try_into().unwrap());
    let (_, b_rem) = DivRem::div_rem(b, modulo.try_into().unwrap());
    a_rem == b_rem
}
