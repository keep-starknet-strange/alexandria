mod aliquot_sum;
mod armstrong_number;
mod collatz_sequence;
mod ed25519;
mod extended_euclidean_algorithm;
mod fast_power;
mod fibonacci;
mod gcd_of_n_numbers;
mod karatsuba;
mod keccak256;
mod mod_arithmetics;
mod perfect_number;
mod sha256;
mod sha512;
mod signed_u256;

#[cfg(test)]
mod tests;
mod wad_ray_math;
mod zellers_congruence;
use integer::{
    u8_wide_mul, u16_wide_mul, u32_wide_mul, u64_wide_mul, u128_wide_mul, u256_overflow_mul,
    BoundedInt
};

/// Raise a number to a power.
/// O(log n) time complexity.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `T` - The result of base raised to the power of exp.
fn pow<T, +Sub<T>, +Mul<T>, +Div<T>, +Rem<T>, +PartialEq<T>, +Into<u8, T>, +Drop<T>, +Copy<T>>(
    base: T, exp: T
) -> T {
    if exp == 0_u8.into() {
        1_u8.into()
    } else if exp == 1_u8.into() {
        base
    } else if exp % 2_u8.into() == 0_u8.into() {
        pow(base * base, exp / 2_u8.into())
    } else {
        base * pow(base * base, exp / 2_u8.into())
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
    fn shl(x: T, n: T) -> T;
    fn shr(x: T, n: T) -> T;
}

impl U8BitShift of BitShift<u8> {
    fn shl(x: u8, n: u8) -> u8 {
        (u8_wide_mul(x, pow(2, n)) & BoundedInt::<u8>::max().into()).try_into().unwrap()
    }

    fn shr(x: u8, n: u8) -> u8 {
        x / pow(2, n)
    }
}

impl U16BitShift of BitShift<u16> {
    fn shl(x: u16, n: u16) -> u16 {
        (u16_wide_mul(x, pow(2, n)) & BoundedInt::<u16>::max().into()).try_into().unwrap()
    }

    fn shr(x: u16, n: u16) -> u16 {
        x / pow(2, n)
    }
}

impl U32BitShift of BitShift<u32> {
    fn shl(x: u32, n: u32) -> u32 {
        (u32_wide_mul(x, pow(2, n)) & BoundedInt::<u32>::max().into()).try_into().unwrap()
    }

    fn shr(x: u32, n: u32) -> u32 {
        x / pow(2, n)
    }
}

impl U64BitShift of BitShift<u64> {
    fn shl(x: u64, n: u64) -> u64 {
        (u64_wide_mul(x, pow(2, n)) & BoundedInt::<u64>::max().into()).try_into().unwrap()
    }

    fn shr(x: u64, n: u64) -> u64 {
        x / pow(2, n)
    }
}

impl U128BitShift of BitShift<u128> {
    fn shl(x: u128, n: u128) -> u128 {
        let (_, bottom_word) = u128_wide_mul(x, pow(2, n));
        bottom_word
    }

    fn shr(x: u128, n: u128) -> u128 {
        x / pow(2, n)
    }
}

impl U256BitShift of BitShift<u256> {
    fn shl(x: u256, n: u256) -> u256 {
        let (r, _) = u256_overflow_mul(x, pow(2, n));
        r
    }

    fn shr(x: u256, n: u256) -> u256 {
        x / pow(2, n)
    }
}

/// Rotate the bits of an unsigned integer of type T
trait BitRotate<T> {
    /// Take the bits of an unsigned integer and rotate in the left direction
    /// # Arguments
    /// * `x` - rotate its bit representation in the leftward direction
    /// * `n` - number of steps to rotate
    /// # Returns
    /// * `T` - the result of rotating the bits of number `x` left, `n` number of steps
    fn rotate_left(x: T, n: T) -> T;
    /// Take the bits of an unsigned integer and rotate in the right direction
    /// # Arguments
    /// * `x` - rotate its bit representation in the rightward direction
    /// * `n` - number of steps to rotate
    /// # Returns
    /// * `T` - the result of rotating the bits of number `x` right, `n` number of steps
    fn rotate_right(x: T, n: T) -> T;
}

impl U8BitRotate of BitRotate<u8> {
    fn rotate_left(x: u8, n: u8) -> u8 {
        let word = u8_wide_mul(x, pow(2, n));
        let (quotient, remainder) = DivRem::div_rem(word, 0x100_u16.try_into().unwrap());
        (quotient + remainder).try_into().unwrap()
    }

    fn rotate_right(x: u8, n: u8) -> u8 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 8 - n) + quotient
    }
}

impl U16BitRotate of BitRotate<u16> {
    fn rotate_left(x: u16, n: u16) -> u16 {
        let word = u16_wide_mul(x, pow(2, n));
        let (quotient, remainder) = DivRem::div_rem(word, 0x10000_u32.try_into().unwrap());
        (quotient + remainder).try_into().unwrap()
    }

    fn rotate_right(x: u16, n: u16) -> u16 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 16 - n) + quotient
    }
}

impl U32BitRotate of BitRotate<u32> {
    fn rotate_left(x: u32, n: u32) -> u32 {
        let word = u32_wide_mul(x, pow(2, n));
        let (quotient, remainder) = DivRem::div_rem(word, 0x100000000_u64.try_into().unwrap());
        (quotient + remainder).try_into().unwrap()
    }

    fn rotate_right(x: u32, n: u32) -> u32 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 32 - n) + quotient
    }
}

impl U64BitRotate of BitRotate<u64> {
    fn rotate_left(x: u64, n: u64) -> u64 {
        let word = u64_wide_mul(x, pow(2, n));
        let (quotient, remainder) = DivRem::div_rem(
            word, 0x10000000000000000_u128.try_into().unwrap()
        );
        (quotient + remainder).try_into().unwrap()
    }

    fn rotate_right(x: u64, n: u64) -> u64 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 64 - n) + quotient
    }
}

impl U128BitRotate of BitRotate<u128> {
    fn rotate_left(x: u128, n: u128) -> u128 {
        let (high, low) = u128_wide_mul(x, pow(2, n));
        let word = u256 { low, high };
        let (quotient, remainder) = DivRem::div_rem(
            word, u256 { low: 0, high: 1 }.try_into().unwrap()
        );
        (quotient + remainder).try_into().unwrap()
    }

    fn rotate_right(x: u128, n: u128) -> u128 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 128 - n) + quotient
    }
}

impl U256BitRotate of BitRotate<u256> {
    fn rotate_left(x: u256, n: u256) -> u256 {
        // Alternative solution since we cannot divide u512 yet
        BitShift::shl(x, n) + BitShift::shr(x, 256 - n)
    }

    fn rotate_right(x: u256, n: u256) -> u256 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 256 - n) + quotient
    }
}
