use option::OptionTrait;
use traits::{Into, TryInto};
use integer::u512;

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

fn mult_inverse(b: u256, modulo: u256) -> u256 {
    pow_mod(b, modulo - 2, modulo)
}

fn add_inverse_mod(b: u256, modulo: u256) -> u256 {
    modulo - b
}

fn sub_mod(mut a: u256, mut b: u256, modulo: u256) -> u256 {
    // reduce values
    a = a % modulo;
    b = b % modulo;
    if (a >= b) {
        return (a - b) % modulo;
    }
    (a + add_inverse_mod(b, modulo)) % modulo
}

fn mult_mod(a: u256, b: u256, modulo: u256) -> u256 {
    let mult: u512 = integer::u256_wide_mul(a, b);
    let mod_non_zero: NonZero<u256> = integer::u256_try_as_non_zero(modulo).unwrap();
    let (_, rem_u256, _, _, _, _, _) = integer::u512_safe_divmod_by_u256(mult, mod_non_zero);
    rem_u256
}

fn div_mod(a: u256, b: u256, modulo: u256) -> u256 {
    mult_mod(a, mult_inverse(b, modulo), modulo)
}

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
