use core::fmt::{Display, Formatter, Error};
use core::num::traits::Zero;
use core::ops::{AddAssign, SubAssign, MulAssign, DivAssign, RemAssign};

// ====================== INT 257 ======================

// i257 represents a 129-bit integer.
// The abs field holds the absolute value of the integer.
// The is_negative field is true for negative integers, and false for non-negative integers.
#[derive(Serde, Copy, Drop, Hash)]
pub struct i257 {
    abs: u256,
    is_negative: bool,
}

#[generate_trait]
pub impl I257Impl of I257Trait {
    #[inline(always)]
    fn new(abs: u256, is_negative: bool) -> i257 {
        if abs == 0 {
            i257 { abs, is_negative: false }
        } else {
            i257 { abs, is_negative }
        }
    }

    fn is_negative(self: i257) -> bool {
        self.is_negative
    }

    fn abs(self: i257) -> u256 {
        self.abs
    }
}

impl I128Default of Default<i257> {
    fn default() -> i257 {
        Zero::zero()
    }
}

// Implements the Add trait for i257.
impl i257Add of Add<i257> {
    fn add(lhs: i257, rhs: i257) -> i257 {
        i257_assert_no_negative_zero(lhs);
        i257_assert_no_negative_zero(rhs);
        // If both integers have the same sign,
        // the sum of their absolute values can be returned.
        if lhs.is_negative == rhs.is_negative {
            let sum = lhs.abs + rhs.abs;
            I257Impl::new(sum, lhs.is_negative)
        } else {
            // If the integers have different signs,
            // the larger absolute value is subtracted from the smaller one.
            let (larger, smaller) = if lhs.abs >= rhs.abs {
                (lhs, rhs)
            } else {
                (rhs, lhs)
            };
            let difference = larger.abs - smaller.abs;
            I257Impl::new(difference, larger.is_negative)
        }
    }
}

// Implements the AddEq trait for i257.
impl i257AddEq of AddAssign<i257, i257> {
    #[inline(always)]
    fn add_assign(ref self: i257, rhs: i257) {
        self = Add::add(self, rhs);
    }
}

// Implements the Sub trait for i257.
impl i257Sub of Sub<i257> {
    fn sub(lhs: i257, rhs: i257) -> i257 {
        i257_assert_no_negative_zero(lhs);
        i257_assert_no_negative_zero(rhs);

        if rhs.abs == 0 {
            return lhs;
        }

        // The subtraction of `lhs` to `rhs` is achieved by negating `rhs` sign and adding it to
        // `lhs`.
        let neg_b = I257Impl::new(rhs.abs, !rhs.is_negative);
        lhs + neg_b
    }
}

// Implements the SubEq trait for i257.
impl i257SubEq of SubAssign<i257, i257> {
    #[inline(always)]
    fn sub_assign(ref self: i257, rhs: i257) {
        self = Sub::sub(self, rhs);
    }
}

// Implements the Mul trait for i257.
impl i257Mul of Mul<i257> {
    fn mul(lhs: i257, rhs: i257) -> i257 {
        i257_assert_no_negative_zero(lhs);
        i257_assert_no_negative_zero(rhs);

        // The sign of the product is the XOR of the signs of the operands.
        let is_negative = lhs.is_negative ^ rhs.is_negative;
        // The product is the product of the absolute values of the operands.
        let abs = lhs.abs * rhs.abs;
        I257Impl::new(abs, is_negative)
    }
}

// Implements the MulEq trait for i257.
impl i257MulEq of MulAssign<i257, i257> {
    #[inline(always)]
    fn mul_assign(ref self: i257, rhs: i257) {
        self = Mul::mul(self, rhs);
    }
}

// Divides the first i257 by the second i128.
// # Arguments
// * `lhs` - The i257 dividend.
// * `rhs` - The i257 divisor.
// # Returns
// * `i257` - The quotient of `lhs` and `rhs`.
fn i257_div(lhs: i257, rhs: i257) -> i257 {
    i257_assert_no_negative_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.abs != 0, 'b can not be 0');

    // The sign of the quotient is the XOR of the signs of the operands.
    let is_negative = lhs.is_negative ^ rhs.is_negative;

    if !is_negative {
        // If the operands are positive, the quotient is simply their absolute value quotient.
        return I257Impl::new(lhs.abs / rhs.abs, is_negative);
    }

    // If the operands have different signs, rounding is necessary.
    // First, check if the quotient is an integer.
    if lhs.abs % rhs.abs == 0 {
        return I257Impl::new(lhs.abs / rhs.abs, is_negative);
    }

    // If the quotient is not an integer, multiply the dividend by 10 to move the decimal point
    // over.
    let quotient = (lhs.abs * 10) / rhs.abs;
    let last_digit = quotient % 10;

    // Check the last digit to determine rounding direction.
    if last_digit <= 5 {
        I257Impl::new(quotient / 10, is_negative)
    } else {
        I257Impl::new((quotient / 10) + 1, is_negative)
    }
}

// Implements the Div trait for i257.
impl i257Div of Div<i257> {
    fn div(lhs: i257, rhs: i257) -> i257 {
        i257_div(lhs, rhs)
    }
}

// Implements the DivEq trait for i257.
impl i257DivEq of DivAssign<i257, i257> {
    #[inline(always)]
    fn div_assign(ref self: i257, rhs: i257) {
        self = Div::div(self, rhs);
    }
}

// Calculates the remainder of the division of a first i257 by a second i257.
// # Arguments
// * `lhs` - The i257 dividend.
// * `rhs` - The i257 divisor.
// # Returns
// * `i257` - The remainder of dividing `lhs` by `rhs`.
fn i257_rem(lhs: i257, rhs: i257) -> i257 {
    i257_assert_no_negative_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.abs != 0, 'b can not be 0');
    lhs - (rhs * (lhs / rhs))
}

// Implements the Rem trait for i257.
impl i257Rem of Rem<i257> {
    fn rem(lhs: i257, rhs: i257) -> i257 {
        i257_rem(lhs, rhs)
    }
}

// Implements the RemEq trait for i257.
impl i257RemEq of RemAssign<i257, i257> {
    #[inline(always)]
    fn rem_assign(ref self: i257, rhs: i257) {
        self = Rem::rem(self, rhs);
    }
}

// Calculates both the quotient and the remainder of the division of a first i257 by a second i257.
// # Arguments
// * `lhs` - The i257 dividend.
// * `rhs` - The i257 divisor.
// # Returns
// * `(i257, i257)` - A tuple containing the quotient and the remainder of dividing `lhs` by `rhs`.
pub fn i257_div_rem(lhs: i257, rhs: i257) -> (i257, i257) {
    let quotient = i257_div(lhs, rhs);
    let remainder = i257_rem(lhs, rhs);
    (quotient, remainder)
}

// Implements the PartialEq trait for i257.
// WARNING: If either `lhs` or `rhs` is negative zero, functions will revert.
// Ensure that neither `lhs` nor `rhs` is negative zero before calling.
impl i257PartialEq of PartialEq<i257> {
    fn eq(lhs: @i257, rhs: @i257) -> bool {
        i257_assert_no_negative_zero(*lhs);
        i257_assert_no_negative_zero(*rhs);
        lhs.is_negative == rhs.is_negative && lhs.abs == rhs.abs
    }

    fn ne(lhs: @i257, rhs: @i257) -> bool {
        !Self::eq(lhs, rhs)
    }
}

// Implements the PartialOrd trait for i257.
// WARNING: If either `lhs` or `rhs` is negative zero, functions will revert.
// Ensure that neither `lhs` nor `rhs` is negative zero before calling.
impl i257PartialOrd of PartialOrd<i257> {
    fn le(lhs: i257, rhs: i257) -> bool {
        !Self::gt(lhs, rhs)
    }
    fn ge(lhs: i257, rhs: i257) -> bool {
        Self::gt(lhs, rhs) || lhs == rhs
    }

    fn lt(lhs: i257, rhs: i257) -> bool {
        !Self::gt(lhs, rhs) && lhs != rhs
    }

    fn gt(lhs: i257, rhs: i257) -> bool {
        i257_assert_no_negative_zero(lhs);
        i257_assert_no_negative_zero(rhs);
        // Check if `lhs` is negative and `rhs` is positive.
        if lhs.is_negative & !rhs.is_negative {
            return false;
        }
        // Check if `lhs` is positive and `rhs` is negative.
        if !lhs.is_negative & rhs.is_negative {
            return true;
        }
        // If `lhs` and `rhs` have the same sign, compare their absolute values.
        if lhs.is_negative & rhs.is_negative {
            lhs.abs < rhs.abs
        } else {
            lhs.abs > rhs.abs
        }
    }
}


// Divides the first i257 by the second i257.

// Implements the Neg trait for i257.
impl i257Neg of Neg<i257> {
    fn neg(a: i257) -> i257 {
        i257_neg(a)
    }
}

pub impl i257Zeroable of Zero<i257> {
    fn zero() -> i257 {
        I257Impl::new(0, false)
    }
    fn is_zero(self: @i257) -> bool {
        if *self.abs == 0 {
            assert(!*self.is_negative, 'no negative zero');
            true
        } else {
            false
        }
    }
    fn is_non_zero(self: @i257) -> bool {
        !self.is_zero()
    }
}

// Checks if the given i257 integer is zero and has the correct sign.
// # Arguments
// * `x` - The i257 integer to check.
// # Panics
// Panics if `x` is zero and is negative
pub fn i257_assert_no_negative_zero(x: i257) {
    if x.abs == 0 {
        assert(!x.is_negative, 'negative zero');
    }
}

// Computes the absolute value of the given i257 integer.
// # Arguments
// * `x` - The i257 integer to compute the absolute value of.
// # Returns
// * `i257` - The absolute value of `x`.
fn i257_abs(x: i257) -> i257 {
    i257 { abs: x.abs, is_negative: false }
}

// Computes the maximum between two i257 integers.
// # Arguments
// * `lhs` - The first i257 integer to compare.
// * `rhs` - The second i257 integer to compare.
// # Returns
// * `i257` - The maximum between `lhs` and `rhs`.
fn i257_max(lhs: i257, rhs: i257) -> i257 {
    if lhs > rhs {
        lhs
    } else {
        rhs
    }
}

fn i257_neg(x: i257) -> i257 {
    // The negation of an integer is obtained by flipping its is_negative.
    I257Impl::new(x.abs, !x.is_negative)
}

// Computes the minimum between two i257 integers.
// # Arguments
// * `lhs` - The first i257 integer to compare.
// * `rhs` - The second i257 integer to compare.
// # Returns
// * `i257` - The minimum between `lhs` and `rhs`.
fn i257_min(lhs: i257, rhs: i257) -> i257 {
    if lhs < rhs {
        lhs
    } else {
        rhs
    }
}

// Convert u256 to i257
impl U256IntoI257 of Into<u256, i257> {
    fn into(self: u256) -> i257 {
        i257 { abs: self, is_negative: false }
    }
}

// Convert felt252 to i257
impl FeltIntoI257 of Into<felt252, i257> {
    fn into(self: felt252) -> i257 {
        i257 { abs: self.into(), is_negative: false }
    }
}

// Implements the Display trait for i257.
pub impl DisplayI257Impl of Display<i257> {
    fn fmt(self: @i257, ref f: Formatter) -> Result<(), Error> {
        if *self.is_negative {
            write!(f, "-")?;
        }
        self.abs.fmt(ref f)
    }
}

