use option::OptionTrait;
use traits::Into;

/// Raise a number to a power.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `u128` - The result of base raised to the power of exp.
fn pow(base: u128, mut exp: u128) -> u128 {
    if exp == 0 {
        1
    } else {
        base * pow(base, exp - 1)
    }
}

/// Function to count the number of digits in a number.
/// # Arguments
/// * `num` - The number to count the digits of.
/// * `base` - Base in which to count the digits.
/// # Returns
/// * `felt252` - The number of digits in num of base
fn count_digits_of_base(mut num: u128, base: u128) -> u128 {
    let mut res = 0;
    loop {
        if num == 0 {
            break res;
        } else {
            num = num / base;
        }
        res += 1;
    }
}

trait BitShift<T> {
    fn fpow(x: T, n: T) -> T;
    fn shl(x: T, n: T) -> T;
    fn shr(x: T, n: T) -> T;
}

impl U128BitShift of BitShift<u128> {
    fn fpow(x: u128, n: u128) -> u128 {
        if n == 0 {
            1
        } else if (n & 1) == 1 {
            x * BitShift::fpow(x * x, n / 2)
        } else {
            BitShift::fpow(x * x, n / 2)
        }
    }
    fn shl(x: u128, n: u128) -> u128 {
        x * BitShift::fpow(2, n)
    }

    fn shr(x: u128, n: u128) -> u128 {
        x / BitShift::fpow(2, n)
    }
}

impl U256BitShift of BitShift<u256> {
    fn fpow(x: u256, n: u256) -> u256 {
        if n == 0 {
            1
        } else if (n & 1) == 1 {
            x * BitShift::fpow(x * x, n / 2)
        } else {
            BitShift::fpow(x * x, n / 2)
        }
    }
    fn shl(x: u256, n: u256) -> u256 {
        x * BitShift::fpow(2, n)
    }

    fn shr(x: u256, n: u256) -> u256 {
        x / BitShift::fpow(2, n)
    }
}
