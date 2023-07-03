use option::OptionTrait;
use traits::{Into, TryInto};
use integer::u512;

/// Function that performs modular addition.
/// # Arguments
/// * `a` - Left hand side of addition.
/// * `b` - Right hand side of addition.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular addition
fn add_mod(a: u256, b: u256, modulo: u256) -> u256 {
    let mod_non_zero: NonZero<u256> = integer::u256_try_as_non_zero(modulo).unwrap();
    let low: u256 = a.low.into() + b.low.into();
    let high: u256 = a.high.into() + b.high.into();
    let carry: u256 = low.high.into() + high.low.into();
    let add_u512: u512 = u512 {
        limb0: low.low, limb1: carry.low, limb2: carry.high + high.high, limb3: 0
    };
    let (_, res) = integer::u512_safe_div_rem_by_u256(add_u512, mod_non_zero);
    res
}

/// Function that return the modular multiplicative inverse. Disclaimer: this function should only be used with a prime modulo.
/// # Arguments
/// * `b` - Number of which to find the multiplicative inverse of. 
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - modular multiplicative inverse
fn mult_inverse(b: u256, modulo: u256) -> u256 {
    // From Fermat's little theorem, a ^ (p - 1) = 1 when p is prime and a != 0. Since a ^ (p - 1) = a · a ^ (p - 2) we have that 
    // a ^ (p - 2) is the multiplicative inverse of a modulo p.
    pow_mod(b, modulo - 2, modulo)
}

/// Function that return the modular additive inverse.
/// # Arguments
/// * `b` - Number of which to find the additive inverse of.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - modular additive inverse
fn add_inverse_mod(b: u256, modulo: u256) -> u256 {
    modulo - b
}

/// Function that performs modular substraction.
/// # Arguments
/// * `a` - Left hand side of substraction.
/// * `b` - Right hand side of substraction.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular substraction
fn sub_mod(mut a: u256, mut b: u256, modulo: u256) -> u256 {
    // reduce values
    a = a % modulo;
    b = b % modulo;
    if (a >= b) {
        return (a - b) % modulo;
    }
    (a + add_inverse_mod(b, modulo)) % modulo
}

/// Function that performs modular multiplication.
/// # Arguments
/// * `a` - Left hand side of multiplication.
/// * `b` - Right hand side of multiplication.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular multiplication
fn mult_mod(a: u256, b: u256, modulo: u256) -> u256 {
    let mult: u512 = integer::u256_wide_mul(a, b);
    let mod_non_zero: NonZero<u256> = integer::u256_try_as_non_zero(modulo).unwrap();
    let (_, rem_u256, _, _, _, _, _) = integer::u512_safe_divmod_by_u256(mult, mod_non_zero);
    rem_u256
}

/// Function that performs modular division.
/// # Arguments
/// * `a` - Left hand side of division.
/// * `b` - Right hand side of division.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular division
fn div_mod(a: u256, b: u256, modulo: u256) -> u256 {
    mult_mod(a, mult_inverse(b, modulo), modulo)
}

/// Function that performs modular exponentiation.
/// # Arguments
/// * `base` - Base of exponentiation.
/// * `pow` - Power of exponentiation.
/// * `modulo` - modulo.
/// # Returns
/// * `u256` - result of modular exponentiation
fn pow_mod(mut base: u256, mut pow: u256, modulo: u256) -> u256 {
    let mut result: u256 = 1;
    let mod_non_zero: NonZero<u256> = integer::u256_try_as_non_zero(modulo).unwrap();
    let mut mult: u512 = u512 { limb0: 0_u128, limb1: 0_u128, limb2: 0_u128, limb3: 0_u128 };

    loop {
        if (pow <= 0) {
            break base;
        }
        if ((pow & 1) > 0) {
            mult = integer::u256_wide_mul(result, base);
            let (_, res_u256, _, _, _, _, _) = integer::u512_safe_divmod_by_u256(
                mult, mod_non_zero
            );
            result = res_u256;
        }

        pow = pow / 2;

        mult = integer::u256_wide_mul(base, base);
        let (_, base_u256, _, _, _, _, _) = integer::u512_safe_divmod_by_u256(mult, mod_non_zero);
        base = base_u256;
    };

    result
}
