pub mod aliquot_sum;
pub mod armstrong_number;
pub mod bip340;
pub mod bitmap;
pub mod collatz_sequence;
pub mod const_pow;
pub mod ed25519;
pub mod extended_euclidean_algorithm;
pub mod fast_power;
pub mod fast_root;
pub mod fibonacci;
pub mod gcd_of_n_numbers;
pub mod i257;
pub mod is_power_of_two;
pub mod is_prime;
pub mod karatsuba;
pub mod keccak256;
pub mod lcm_of_n_numbers;
pub mod mod_arithmetics;
pub mod perfect_number;
pub mod sha256;
pub mod sha512;

#[cfg(test)]
mod tests;
pub mod trigonometry;
pub mod u512_arithmetics;
pub mod wad_ray_math;
pub mod zellers_congruence;
use core::num::traits::{Bounded, OverflowingMul, WideMul, WrappingAdd, WrappingMul, WrappingSub};

/// Raise a number to a power.
/// O(log n) time complexity.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `T` - The result of base raised to the power of exp.
pub fn pow<T, +Sub<T>, +Mul<T>, +Div<T>, +Rem<T>, +PartialEq<T>, +Into<u8, T>, +Drop<T>, +Copy<T>>(
    base: T, exp: T,
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
/// * `u32` - The number of digits in num of base
fn count_digits_of_base(mut num: u128, base: u128) -> u32 {
    let mut res = 0;
    while (num != 0) {
        num = num / base;
        res += 1;
    }
    res
}

pub trait BitShift<
    T, +Sub<T>, +Mul<T>, +Div<T>, +Rem<T>, +PartialEq<T>, +Into<u8, T>, +Drop<T>, +Copy<T>,
> {
    // Cannot make SHL generic as u256 doesn't support everything required
    fn shl(x: T, n: T) -> T;
    fn shr(x: T, n: T) -> T {
        x / pow(2_u8.into(), n)
    }
}

pub impl U8BitShift of BitShift<u8> {
    fn shl(x: u8, n: u8) -> u8 {
        (WideMul::wide_mul(x, pow(2, n)) & Bounded::<u8>::MAX.into()).try_into().unwrap()
    }
}

pub impl U16BitShift of BitShift<u16> {
    fn shl(x: u16, n: u16) -> u16 {
        (WideMul::wide_mul(x, pow(2, n)) & Bounded::<u16>::MAX.into()).try_into().unwrap()
    }
}

pub impl U32BitShift of BitShift<u32> {
    fn shl(x: u32, n: u32) -> u32 {
        (WideMul::wide_mul(x, pow(2, n)) & Bounded::<u32>::MAX.into()).try_into().unwrap()
    }
}

pub impl U64BitShift of BitShift<u64> {
    fn shl(x: u64, n: u64) -> u64 {
        (WideMul::wide_mul(x, pow(2, n)) & Bounded::<u64>::MAX.into()).try_into().unwrap()
    }
}

pub impl U128BitShift of BitShift<u128> {
    fn shl(x: u128, n: u128) -> u128 {
        WideMul::wide_mul(x, pow(2, n)).low
    }
}

pub impl U256BitShift of BitShift<u256> {
    fn shl(x: u256, n: u256) -> u256 {
        let (r, _) = x.overflowing_mul(pow(2, n));
        r
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

pub impl U8BitRotate of BitRotate<u8> {
    fn rotate_left(x: u8, n: u8) -> u8 {
        let word = WideMul::wide_mul(x, pow(2, n));
        let (quotient, remainder) = DivRem::div_rem(word, 0x100_u16.try_into().unwrap());
        (quotient + remainder).try_into().unwrap()
    }

    fn rotate_right(x: u8, n: u8) -> u8 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 8 - n) + quotient
    }
}

pub impl U16BitRotate of BitRotate<u16> {
    fn rotate_left(x: u16, n: u16) -> u16 {
        let word = WideMul::wide_mul(x, pow(2, n));
        let (quotient, remainder) = DivRem::div_rem(word, 0x10000_u32.try_into().unwrap());
        (quotient + remainder).try_into().unwrap()
    }

    fn rotate_right(x: u16, n: u16) -> u16 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 16 - n) + quotient
    }
}

pub impl U32BitRotate of BitRotate<u32> {
    fn rotate_left(x: u32, n: u32) -> u32 {
        let word = WideMul::wide_mul(x, pow(2, n));
        let (quotient, remainder) = DivRem::div_rem(word, 0x100000000_u64.try_into().unwrap());
        (quotient + remainder).try_into().unwrap()
    }

    fn rotate_right(x: u32, n: u32) -> u32 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 32 - n) + quotient
    }
}

pub impl U64BitRotate of BitRotate<u64> {
    fn rotate_left(x: u64, n: u64) -> u64 {
        let word = WideMul::wide_mul(x, pow(2, n));
        let (quotient, remainder) = DivRem::div_rem(
            word, 0x10000000000000000_u128.try_into().unwrap(),
        );
        (quotient + remainder).try_into().unwrap()
    }

    fn rotate_right(x: u64, n: u64) -> u64 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 64 - n) + quotient
    }
}

pub impl U128BitRotate of BitRotate<u128> {
    fn rotate_left(x: u128, n: u128) -> u128 {
        let word = WideMul::wide_mul(x, pow(2, n));
        let (quotient, remainder) = DivRem::div_rem(
            word, u256 { low: 0, high: 1 }.try_into().unwrap(),
        );
        (quotient + remainder).try_into().unwrap()
    }

    fn rotate_right(x: u128, n: u128) -> u128 {
        let step = pow(2, n);
        let (quotient, remainder) = DivRem::div_rem(x, step.try_into().unwrap());
        remainder * pow(2, 128 - n) + quotient
    }
}

pub impl U256BitRotate of BitRotate<u256> {
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

trait WrappingMath<T> {
    fn wrapping_add(self: T, rhs: T) -> T;
    fn wrapping_sub(self: T, rhs: T) -> T;
    fn wrapping_mul(self: T, rhs: T) -> T;
}

pub impl WrappingMathImpl<T, +WrappingAdd<T>, +WrappingSub<T>, +WrappingMul<T>> of WrappingMath<T> {
    #[inline(always)]
    fn wrapping_add(self: T, rhs: T) -> T {
        WrappingAdd::wrapping_add(self, rhs)
    }

    #[inline(always)]
    fn wrapping_sub(self: T, rhs: T) -> T {
        WrappingSub::wrapping_sub(self, rhs)
    }

    #[inline(always)]
    fn wrapping_mul(self: T, rhs: T) -> T {
        WrappingMul::wrapping_mul(self, rhs)
    }
}
