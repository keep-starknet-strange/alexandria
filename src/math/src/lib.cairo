mod aliquot_sum;
mod armstrong_number;
mod collatz_sequence;
mod ed25519;
mod extended_euclidean_algorithm;
mod fast_power;
mod fast_root;
mod fibonacci;
mod gcd_of_n_numbers;
mod i257;
mod is_power_of_two;
mod is_prime;
mod karatsuba;
mod keccak256;
mod lcm_of_n_numbers;
mod mod_arithmetics;
mod perfect_number;
mod sha256;
mod sha512;

#[cfg(test)]
mod tests;
mod trigonometry;
mod wad_ray_math;
mod zellers_congruence;
use integer::{
    u8_wide_mul, u16_wide_mul, u32_wide_mul, u64_wide_mul, u128_wide_mul, u256_overflow_mul,
    u8_wrapping_add, u16_wrapping_add, u32_wrapping_add, u64_wrapping_add, u128_wrapping_add,
    u256_overflowing_add, u8_wrapping_sub, u16_wrapping_sub, u32_wrapping_sub, u64_wrapping_sub,
    u128_wrapping_sub, u256_overflow_sub, BoundedInt
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
    while (num != 0) {
        num = num / base;
        res += 1;
    };
    res
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

trait WrappingMath<T> {
    fn wrapping_add(self: T, rhs: T) -> T;
    fn wrapping_sub(self: T, rhs: T) -> T;
    fn wrapping_mul(self: T, rhs: T) -> T;
}

impl WrappingMathImpl<T, +WrappingAdd<T>, +WrappingSub<T>, +WrappingMul<T>> of WrappingMath<T> {
    #[inline(always)]
    fn wrapping_add(self: T, rhs: T) -> T {
        WrappingAdd::<T>::wrapping_add(self, rhs)
    }

    #[inline(always)]
    fn wrapping_sub(self: T, rhs: T) -> T {
        WrappingSub::<T>::wrapping_sub(self, rhs)
    }

    #[inline(always)]
    fn wrapping_mul(self: T, rhs: T) -> T {
        WrappingMul::<T>::wrapping_mul(self, rhs)
    }
}

trait WrappingAdd<T> {
    fn wrapping_add(self: T, rhs: T) -> T;
}

trait WrappingSub<T> {
    fn wrapping_sub(self: T, rhs: T) -> T;
}

trait WrappingMul<T> {
    fn wrapping_mul(self: T, rhs: T) -> T;
}

impl U8WrappingAdd of WrappingAdd<u8> {
    #[inline(always)]
    fn wrapping_add(self: u8, rhs: u8) -> u8 {
        u8_wrapping_add(self, rhs)
    }
}

impl U8WrappingSub of WrappingSub<u8> {
    #[inline(always)]
    fn wrapping_sub(self: u8, rhs: u8) -> u8 {
        u8_wrapping_sub(self, rhs)
    }
}

impl U8WrappingMul of WrappingMul<u8> {
    #[inline(always)]
    fn wrapping_mul(self: u8, rhs: u8) -> u8 {
        (u8_wide_mul(self, rhs) & BoundedInt::<u8>::max().into()).try_into().unwrap()
    }
}

impl U16WrappingAdd of WrappingAdd<u16> {
    #[inline(always)]
    fn wrapping_add(self: u16, rhs: u16) -> u16 {
        u16_wrapping_add(self, rhs)
    }
}

impl U16WrappingSub of WrappingSub<u16> {
    #[inline(always)]
    fn wrapping_sub(self: u16, rhs: u16) -> u16 {
        u16_wrapping_sub(self, rhs)
    }
}

impl U16WrappingMul of WrappingMul<u16> {
    #[inline(always)]
    fn wrapping_mul(self: u16, rhs: u16) -> u16 {
        (u16_wide_mul(self, rhs) & BoundedInt::<u16>::max().into()).try_into().unwrap()
    }
}

impl U32WrappingAdd of WrappingAdd<u32> {
    #[inline(always)]
    fn wrapping_add(self: u32, rhs: u32) -> u32 {
        u32_wrapping_add(self, rhs)
    }
}

impl U32WrappingSub of WrappingSub<u32> {
    #[inline(always)]
    fn wrapping_sub(self: u32, rhs: u32) -> u32 {
        u32_wrapping_sub(self, rhs)
    }
}

impl U32WrappingMul of WrappingMul<u32> {
    #[inline(always)]
    fn wrapping_mul(self: u32, rhs: u32) -> u32 {
        (u32_wide_mul(self, rhs) & BoundedInt::<u32>::max().into()).try_into().unwrap()
    }
}

impl U64WrappingAdd of WrappingAdd<u64> {
    #[inline(always)]
    fn wrapping_add(self: u64, rhs: u64) -> u64 {
        u64_wrapping_add(self, rhs)
    }
}

impl U64WrappingSub of WrappingSub<u64> {
    #[inline(always)]
    fn wrapping_sub(self: u64, rhs: u64) -> u64 {
        u64_wrapping_sub(self, rhs)
    }
}

impl U64WrappingMul of WrappingMul<u64> {
    #[inline(always)]
    fn wrapping_mul(self: u64, rhs: u64) -> u64 {
        (u64_wide_mul(self, rhs) & BoundedInt::<u64>::max().into()).try_into().unwrap()
    }
}

impl U128WrappingAdd of WrappingAdd<u128> {
    #[inline(always)]
    fn wrapping_add(self: u128, rhs: u128) -> u128 {
        u128_wrapping_add(self, rhs)
    }
}

impl U128WrappingSub of WrappingSub<u128> {
    #[inline(always)]
    fn wrapping_sub(self: u128, rhs: u128) -> u128 {
        u128_wrapping_sub(self, rhs)
    }
}

impl U128WrappingMul of WrappingMul<u128> {
    #[inline(always)]
    fn wrapping_mul(self: u128, rhs: u128) -> u128 {
        let (_, low) = u128_wide_mul(self, rhs);
        low
    }
}

impl U256WrappingAdd of WrappingAdd<u256> {
    #[inline(always)]
    fn wrapping_add(self: u256, rhs: u256) -> u256 {
        let (val, _) = u256_overflowing_add(self, rhs);
        val
    }
}

impl U256WrappingSub of WrappingSub<u256> {
    #[inline(always)]
    fn wrapping_sub(self: u256, rhs: u256) -> u256 {
        let (val, _) = u256_overflow_sub(self, rhs);
        val
    }
}

impl U256WrappingMul of WrappingMul<u256> {
    #[inline(always)]
    fn wrapping_mul(self: u256, rhs: u256) -> u256 {
        let (val, _) = u256_overflow_mul(self, rhs);
        val
    }
}
