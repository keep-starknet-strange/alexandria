// Internam imports

use alexandria_math::fast_power::fast_power as pow;
use core::ops::DivAssign;

#[generate_trait]
pub impl Bitmap<
    T,
    +Add<T>,
    +Sub<T>,
    +Mul<T>,
    +Div<T>,
    +DivAssign<T, T>,
    +Rem<T>,
    +BitAnd<T>,
    +BitOr<T>,
    +BitNot<T>,
    +PartialEq<T>,
    +PartialOrd<T>,
    +Into<u8, T>,
    +Into<T, u256>,
    +TryInto<u256, T>,
    +Drop<T>,
    +Copy<T>,
> of BitmapTrait<T> {
    /// The bit value at the provided index of a number.
    /// # Arguments
    /// * `x` - The value for which to extract the bit value.
    /// * `i` - The index.
    /// # Returns
    /// * The value at index.
    #[inline(always)]
    fn get_bit_at(x: T, i: u8) -> bool {
        let mask: T = pow(2_u8.into(), i.into());
        x & mask == mask
    }

    /// Set the bit to value at the provided index of a number.
    /// # Arguments
    /// * `x` - The value for which to extract the bit value.
    /// * `i` - The index.
    /// * `value` - The value to set the bit to.
    /// # Returns
    /// * The value with the bit set to value.
    #[inline(always)]
    fn set_bit_at(x: T, i: u8, value: bool) -> T {
        let mask: T = pow(2_u8.into(), i.into());
        if value {
            x | mask
        } else {
            x & ~mask
        }
    }

    /// The index of the most significant bit of the number,
    /// where the least significant bit is at index 0 and the most significant bit is at index 255
    /// # Arguments
    /// * `x` - The value for which to compute the most significant bit, must be greater than 0.
    /// # Returns
    /// * The index of the most significant bit
    #[inline(always)]
    fn most_significant_bit(x: T) -> Option<u8> {
        let mut x: u256 = x.into();
        if x == 0_u8.into() {
            return Option::None;
        }
        let mut r: u8 = 0;

        if x >= 0x100000000000000000000000000000000 {
            x /= 0x100000000000000000000000000000000;
            r += 128;
        }
        if x >= 0x10000000000000000 {
            x /= 0x10000000000000000;
            r += 64;
        }
        if x >= 0x100000000 {
            x /= 0x100000000;
            r += 32;
        }
        if x >= 0x10000 {
            x /= 0x10000;
            r += 16;
        }
        if x >= 0x100 {
            x /= 0x100;
            r += 8;
        }
        if x >= 0x10 {
            x /= 0x10;
            r += 4;
        }
        if x >= 0x4 {
            x /= 0x4;
            r += 2;
        }
        if x >= 0x2 {
            r += 1;
        }
        Option::Some(r)
    }

    /// The index of the least significant bit of the number,
    /// where the least significant bit is at index 0 and the most significant bit is at index 255
    /// # Arguments
    /// * `x` - The value for which to compute the least significant bit, must be greater than 0.
    /// # Returns
    /// * The index of the least significant bit
    #[inline(always)]
    fn least_significant_bit(x: T) -> Option<u8> {
        let mut x: u256 = x.into();
        if x == 0 {
            return Option::None;
        }
        let mut r: u8 = 255;

        if (x & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) > 0 {
            r -= 128;
        } else {
            x /= 0x100000000000000000000000000000000;
        }
        if (x & 0xFFFFFFFFFFFFFFFF) > 0 {
            r -= 64;
        } else {
            x /= 0x10000000000000000;
        }
        if (x & 0xFFFFFFFF) > 0 {
            r -= 32;
        } else {
            x /= 0x100000000;
        }
        if (x & 0xFFFF) > 0 {
            r -= 16;
        } else {
            x /= 0x10000;
        }
        if (x & 0xFF) > 0 {
            r -= 8;
        } else {
            x /= 0x100;
        }
        if (x & 0xF) > 0 {
            r -= 4;
        } else {
            x /= 0x10;
        }
        if (x & 0x3) > 0 {
            r -= 2;
        } else {
            x /= 0x4;
        }
        if (x & 0x1) > 0 {
            r -= 1;
        }
        Option::Some(r)
    }

    /// The index of the nearest left significant bit to the index of a number.
    /// # Arguments
    /// * `x` - The value for which to compute the most significant bit.
    /// * `i` - The index for which to start the search.
    /// # Returns
    /// * The index of the nearest left significant bit, None is returned if no significant bit is
    /// found.
    #[inline(always)]
    fn nearest_left_significant_bit(x: T, i: u8) -> Option<u8> {
        let mask = ~(pow(2_u8.into(), i.into()) - 1_u8.into());
        Self::least_significant_bit(x & mask)
    }

    /// The index of the nearest right significant bit to the index of a number.
    /// # Arguments
    /// * `x` - The value for which to compute the most significant bit.
    /// * `i` - The index for which to start the search.
    /// # Returns
    /// * The index of the nearest right significant bit, None is returned if no significant bit is
    /// found.
    #[inline(always)]
    fn nearest_right_significant_bit(x: T, i: u8) -> Option<u8> {
        let mask = pow(2_u8.into(), (i + 1).into()) - 1_u8.into();
        Self::most_significant_bit(x & mask)
    }

    /// The index of the nearest significant bit to the index of a number,
    /// where the least significant bit is at index 0 and the most significant bit is at index 255
    /// # Arguments
    /// * `x` - The value for which to compute the most significant bit, must be greater than 0.
    /// * `i` - The index for which to start the search.
    /// * `priority` - if priority is set to true then right is prioritized over left, left over
    /// right otherwise.
    /// # Returns
    /// * The index of the nearest significant bit, None is returned if no significant bit is found.
    #[inline(always)]
    fn nearest_significant_bit(x: T, i: u8, priority: bool) -> Option<u8> {
        let nlsb = Self::nearest_left_significant_bit(x, i);
        let nrsb = Self::nearest_right_significant_bit(x, i);
        match (nlsb, nrsb) {
            (
                Option::Some(lhs), Option::Some(rhs),
            ) => {
                if i - rhs < lhs - i || (priority && (i - rhs == lhs - i)) {
                    Option::Some(rhs)
                } else {
                    Option::Some(lhs)
                }
            },
            (Option::Some(lhs), Option::None) => Option::Some(lhs),
            (Option::None, Option::Some(rhs)) => Option::Some(rhs),
            (Option::None, Option::None) => Option::None,
        }
    }
}
