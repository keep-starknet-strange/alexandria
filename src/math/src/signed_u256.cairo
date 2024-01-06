use core::traits::Into;
// ====================== INT 257 ======================

// i257 represents a 129-bit integer.
// The inner field holds the absolute value of the integer.
// The sign field is true for negative integers, and false for non-negative integers.
#[derive(Copy, Drop)]
struct i257 {
    sign: bool,
    inner: u256,
}


// Checks if the given i257 integer is zero and has the correct sign.
// # Arguments
// * `x` - The i257 integer to check.
// # Panics
// Panics if `x` is zero and has a sign that is not false.
fn i257_check_sign_zero(x: i257) {
    if x.inner == 0 {
        assert(x.sign == false, 'sign of 0 must be false');
    }
}

// Implements the Add trait for i257.
impl i257Add of Add<i257> {
    fn add(lhs: i257, rhs: i257) -> i257 {
        i257_check_sign_zero(lhs);
        i257_check_sign_zero(rhs);
        // If both integers have the same sign, 
        // the sum of their absolute values can be returned.
        if lhs.sign == rhs.sign {
            let sum = lhs.inner + rhs.inner;
            i257 { inner: sum, sign: lhs.sign }
        } else {
            // If the integers have different signs, 
            // the larger absolute value is subtracted from the smaller one.
            let (larger, smaller) = if lhs.inner >= rhs.inner {
                (lhs, rhs)
            } else {
                (rhs, lhs)
            };
            let difference = larger.inner - smaller.inner;

            i257 { inner: difference, sign: larger.sign }
        }
    }
}

// Implements the AddEq trait for i257.
impl i257AddEq of AddEq<i257> {
    #[inline(always)]
    fn add_eq(ref self: i257, other: i257) {
        self = Add::add(self, other);
    }
}

// Implements the Sub trait for i257.
impl i257Sub of Sub<i257> {
    fn sub(lhs: i257, rhs: i257) -> i257 {
        i257_check_sign_zero(lhs);
        i257_check_sign_zero(rhs);

        if (rhs.inner == 0) {
            return lhs;
        }

        // The subtraction of `lhs` to `rhs` is achieved by negating `rhs` sign and adding it to `lhs`.
        let neg_b = i257 { inner: rhs.inner, sign: !rhs.sign };
        lhs + neg_b
    }
}

// Implements the SubEq trait for i257.
impl i257SubEq of SubEq<i257> {
    #[inline(always)]
    fn sub_eq(ref self: i257, other: i257) {
        self = Sub::sub(self, other);
    }
}

// Implements the Mul trait for i257.
impl i257Mul of Mul<i257> {
    fn mul(lhs: i257, rhs: i257) -> i257 {
        i257_check_sign_zero(lhs);
        i257_check_sign_zero(rhs);

        // The sign of the product is the XOR of the signs of the operands.
        let sign = lhs.sign ^ rhs.sign;
        // The product is the product of the absolute values of the operands.
        let inner = lhs.inner * rhs.inner;
        i257 { inner, sign }
    }
}

// Implements the MulEq trait for i257.
impl i257MulEq of MulEq<i257> {
    #[inline(always)]
    fn mul_eq(ref self: i257, other: i257) {
        self = Mul::mul(self, other);
    }
}

// Divides the first i257 by the second i257.
// # Arguments
// * `lhs` - The i257 dividend.
// * `rhs` - The i257 divisor.
// # Returns
// * `i257` - The quotient of `lhs` and `rhs`.
fn i257_div(lhs: i257, rhs: i257) -> i257 {
    i257_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    // The sign of the quotient is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;

    if (sign == false) {
        // If the operands are positive, the quotient is simply their absolute value quotient.
        return i257 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the operands have different signs, rounding is necessary.
    // First, check if the quotient is an integer.
    if (lhs.inner % rhs.inner == 0) {
        return i257 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the quotient is not an integer, multiply the dividend by 10 to move the decimal point over.
    let quotient = (lhs.inner * 10) / rhs.inner;
    let last_digit = quotient % 10;

    // Check the last digit to determine rounding direction.
    if (last_digit <= 5) {
        return i257 { inner: quotient / 10, sign: sign };
    } else {
        return i257 { inner: (quotient / 10) + 1, sign: sign };
    }
}

// Implements the Div trait for i257.
impl i257Div of Div<i257> {
    fn div(lhs: i257, rhs: i257) -> i257 {
        i257_div(lhs, rhs)
    }
}

// Implements the DivEq trait for i257.
impl i257DivEq of DivEq<i257> {
    #[inline(always)]
    fn div_eq(ref self: i257, other: i257) {
        self = Div::div(self, other);
    }
}

// Calculates the remainder of the division of a first i257 by a second i257.
// # Arguments
// * `lhs` - The i257 dividend.
// * `rhs` - The i257 divisor.
// # Returns
// * `i257` - The remainder of dividing `lhs` by `rhs`.
fn i257_rem(lhs: i257, rhs: i257) -> i257 {
    i257_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    return lhs - (rhs * (lhs / rhs));
}

// Implements the Rem trait for i257.
impl i257Rem of Rem<i257> {
    fn rem(lhs: i257, rhs: i257) -> i257 {
        i257_rem(lhs, rhs)
    }
}

// Implements the RemEq trait for i257.
impl i257RemEq of RemEq<i257> {
    #[inline(always)]
    fn rem_eq(ref self: i257, other: i257) {
        self = Rem::rem(self, other);
    }
}

// Calculates both the quotient and the remainder of the division of a first i257 by a second i257.
// # Arguments
// * `lhs` - The i257 dividend.
// * `rhs` - The i257 divisor.
// # Returns
// * `(i257, i257)` - A tuple containing the quotient and the remainder of dividing `lhs` by `rhs`.
fn i257_div_rem(lhs: i257, rhs: i257) -> (i257, i257) {
    let quotient = i257_div(lhs, rhs);
    let remainder = i257_rem(lhs, rhs);

    return (quotient, remainder);
}

impl I257DivRem of DivRem<i257> {
    fn div_rem(lhs: i257, rhs: NonZero<i257>) -> (i257, i257) {
        i257_div_rem(lhs, rhs.into())
    }
}

// Implements the PartialEq trait for i257.
impl i257PartialEq of PartialEq<i257> {
    fn eq(lhs: @i257, rhs: @i257) -> bool {
        if lhs.sign == rhs.sign && lhs.inner == rhs.inner {
            return true;
        }

        return false;
    }

    fn ne(lhs: @i257, rhs: @i257) -> bool {
        !i257PartialEq::eq(lhs, rhs)
    }
}

// Implements the PartialOrd trait for i257.
impl i257PartialOrd of PartialOrd<i257> {
    fn le(lhs: i257, rhs: i257) -> bool {
        !i257PartialOrd::gt(lhs, rhs)
    }
    fn ge(lhs: i257, rhs: i257) -> bool {
        i257PartialOrd::gt(lhs, rhs) || lhs == rhs
    }

    fn lt(lhs: i257, rhs: i257) -> bool {
        !i257PartialOrd::gt(lhs, rhs) && lhs != rhs
    }

    fn gt(lhs: i257, rhs: i257) -> bool {
        // Check if `lhs` is negative and `rhs` is positive.
        if (lhs.sign & !rhs.sign) {
            return false;
        }
        // Check if `lhs` is positive and `rhs` is negative.
        if (!lhs.sign & rhs.sign) {
            return true;
        }
        // If `lhs` and `rhs` have the same sign, compare their absolute values.
        if (lhs.sign & rhs.sign) {
            return lhs.inner < rhs.inner;
        } else {
            return lhs.inner > rhs.inner;
        }
    }
}

// Implements the Neg trait for i257.
impl i257Neg of Neg<i257> {
    fn neg(a: i257) -> i257 {
        i257 { inner: a.inner, sign: !a.sign }
    }
}

// Computes the absolute value of the given i257 integer.
// # Arguments
// * `x` - The i257 integer to compute the absolute value of.
// # Returns
// * `i257` - The absolute value of `x`.
fn i257_abs(x: i257) -> i257 {
    return i257 { inner: x.inner, sign: false };
}

// Computes the maximum between two i257 integers.
// # Arguments
// * `lhs` - The first i257 integer to compare.
// * `rhs` - The second i257 integer to compare.
// # Returns
// * `i257` - The maximum between `lhs` and `rhs`.
fn i257_max(lhs: i257, rhs: i257) -> i257 {
    if (lhs > rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

// Computes the minimum between two i257 integers.
// # Arguments
// * `lhs` - The first i257 integer to compare.
// * `rhs` - The second i257 integer to compare.
// # Returns
// * `i257` - The minimum between `lhs` and `rhs`.
fn i257_min(lhs: i257, rhs: i257) -> i257 {
    if (lhs < rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

// Convert u256 to i257
impl U256IntoI257 of Into<u256, i257> {
    fn into(self: u256) -> i257 {
        i257 { inner: self, sign: false, }
    }
}

// Convert felt252 to i257
impl FeltIntoI257 of Into<felt252, i257> {
    fn into(self: felt252) -> i257 {
        i257 { inner: self.into(), sign: false, }
    }
}
