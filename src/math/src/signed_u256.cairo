// ====================== INT 129 ======================

// i129 represents a 129-bit integer.
// The inner field holds the absolute value of the integer.
// The sign field is true for negative integers, and false for non-negative integers.
#[derive(Copy, Drop)]
struct i129 {
    inner: u128,
    sign: bool,
}

// Checks if the given i129 integer is zero and has the correct sign.
// # Arguments
// * `x` - The i129 integer to check.
// # Panics
// Panics if `x` is zero and has a sign that is not false.
fn i129_check_sign_zero(x: i129) {
    if x.inner == 0 {
        assert(x.sign == false, 'sign of 0 must be false');
    }
}

// Adds two i129 integers.
// # Arguments
// * `lhs` - The first i129 to add.
// * `rhs` - The second i129 to add.
// # Returns
// * `i129` - The sum of `lhs` and `rhs`.
fn i129_add(lhs: i129, rhs: i129) -> i129 {
    i129_check_sign_zero(lhs);
    i129_check_sign_zero(rhs);
    // If both integers have the same sign, 
    // the sum of their absolute values can be returned.
    if lhs.sign == rhs.sign {
        let sum = lhs.inner + rhs.inner;
        return i129 { inner: sum, sign: lhs.sign };
    } else {
        // If the integers have different signs, 
        // the larger absolute value is subtracted from the smaller one.
        let (larger, smaller) = if lhs.inner >= rhs.inner {
            (lhs, rhs)
        } else {
            (rhs, lhs)
        };
        let difference = larger.inner - smaller.inner;

        return i129 { inner: difference, sign: larger.sign };
    }
}

// Implements the Add trait for i129.
impl i129Add of Add<i129> {
    fn add(lhs: i129, rhs: i129) -> i129 {
        i129_add(lhs, rhs)
    }
}

// Implements the AddEq trait for i129.
impl i129AddEq of AddEq<i129> {
    #[inline(always)]
    fn add_eq(ref self: i129, other: i129) {
        self = Add::add(self, other);
    }
}

// Subtracts two i129 integers.
// # Arguments
// * `lhs` - The first i129 to subtract.
// * `rhs` - The second i129 to subtract.
// # Returns
// * `i129` - The difference of `lhs` and `rhs`.
fn i129_sub(lhs: i129, rhs: i129) -> i129 {
    i129_check_sign_zero(lhs);
    i129_check_sign_zero(rhs);

    if (rhs.inner == 0) {
        return lhs;
    }

    // The subtraction of `lhs` to `rhs` is achieved by negating `rhs` sign and adding it to `lhs`.
    let neg_b = i129 { inner: rhs.inner, sign: !rhs.sign };
    return lhs + neg_b;
}

// Implements the Sub trait for i129.
impl i129Sub of Sub<i129> {
    fn sub(lhs: i129, rhs: i129) -> i129 {
        i129_sub(lhs, rhs)
    }
}

// Implements the SubEq trait for i129.
impl i129SubEq of SubEq<i129> {
    #[inline(always)]
    fn sub_eq(ref self: i129, other: i129) {
        self = Sub::sub(self, other);
    }
}

// Multiplies two i129 integers.
// 
// # Arguments
//
// * `lhs` - The first i129 to multiply.
// * `rhs` - The second i129 to multiply.
//
// # Returns
//
// * `i129` - The product of `lhs` and `rhs`.
fn i129_mul(lhs: i129, rhs: i129) -> i129 {
    i129_check_sign_zero(lhs);
    i129_check_sign_zero(rhs);

    // The sign of the product is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;
    // The product is the product of the absolute values of the operands.
    let inner = lhs.inner * rhs.inner;
    return i129 { inner, sign };
}

// Implements the Mul trait for i129.
impl i129Mul of Mul<i129> {
    fn mul(lhs: i129, rhs: i129) -> i129 {
        i129_mul(lhs, rhs)
    }
}

// Implements the MulEq trait for i129.
impl i129MulEq of MulEq<i129> {
    #[inline(always)]
    fn mul_eq(ref self: i129, other: i129) {
        self = Mul::mul(self, other);
    }
}

// Divides the first i129 by the second i129.
// # Arguments
// * `lhs` - The i129 dividend.
// * `rhs` - The i129 divisor.
// # Returns
// * `i129` - The quotient of `lhs` and `rhs`.
fn i129_div(lhs: i129, rhs: i129) -> i129 {
    i129_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    // The sign of the quotient is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;

    if (sign == false) {
        // If the operands are positive, the quotient is simply their absolute value quotient.
        return i129 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the operands have different signs, rounding is necessary.
    // First, check if the quotient is an integer.
    if (lhs.inner % rhs.inner == 0) {
        return i129 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the quotient is not an integer, multiply the dividend by 10 to move the decimal point over.
    let quotient = (lhs.inner * 10) / rhs.inner;
    let last_digit = quotient % 10;

    // Check the last digit to determine rounding direction.
    if (last_digit <= 5) {
        return i129 { inner: quotient / 10, sign: sign };
    } else {
        return i129 { inner: (quotient / 10) + 1, sign: sign };
    }
}

// Implements the Div trait for i129.
impl i129Div of Div<i129> {
    fn div(lhs: i129, rhs: i129) -> i129 {
        i129_div(lhs, rhs)
    }
}

// Implements the DivEq trait for i129.
impl i129DivEq of DivEq<i129> {
    #[inline(always)]
    fn div_eq(ref self: i129, other: i129) {
        self = Div::div(self, other);
    }
}

// Calculates the remainder of the division of a first i129 by a second i129.
// # Arguments
// * `lhs` - The i129 dividend.
// * `rhs` - The i129 divisor.
// # Returns
// * `i129` - The remainder of dividing `lhs` by `rhs`.
fn i129_rem(lhs: i129, rhs: i129) -> i129 {
    i129_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    return lhs - (rhs * (lhs / rhs));
}

// Implements the Rem trait for i129.
impl i129Rem of Rem<i129> {
    fn rem(lhs: i129, rhs: i129) -> i129 {
        i129_rem(lhs, rhs)
    }
}

// Implements the RemEq trait for i129.
impl i129RemEq of RemEq<i129> {
    #[inline(always)]
    fn rem_eq(ref self: i129, other: i129) {
        self = Rem::rem(self, other);
    }
}

// Calculates both the quotient and the remainder of the division of a first i129 by a second i129.
// # Arguments
// * `lhs` - The i129 dividend.
// * `rhs` - The i129 divisor.
// # Returns
// * `(i129, i129)` - A tuple containing the quotient and the remainder of dividing `lhs` by `rhs`.
fn i129_div_rem(lhs: i129, rhs: i129) -> (i129, i129) {
    let quotient = i129_div(lhs, rhs);
    let remainder = i129_rem(lhs, rhs);

    return (quotient, remainder);
}

// Compares two i129 integers for equality.
// # Arguments
// * `lhs` - The first i129 integer to compare.
// * `rhs` - The second i129 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are equal, `false` otherwise.
fn i129_eq(lhs: i129, rhs: i129) -> bool {
    // Check if the two integers have the same sign and the same absolute value.
    if lhs.sign == rhs.sign & lhs.inner == rhs.inner {
        return true;
    }

    return false;
}

// Compares two i129 integers for inequality.
// # Arguments
// * `lhs` - The first i129 integer to compare.
// * `rhs` - The second i129 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are not equal, `false` otherwise.
fn i129_ne(lhs: i129, rhs: i129) -> bool {
    // The result is the inverse of the equal function.
    return !i129_eq(lhs, rhs);
}

// Implements the PartialEq trait for i129.
impl i129PartialEq of PartialEq<i129> {
    fn eq(lhs: i129, rhs: i129) -> bool {
        i129_eq(lhs, rhs)
    }

    fn ne(lhs: i129, rhs: i129) -> bool {
        i129_ne(lhs, rhs)
    }
}

// Compares two i129 integers for greater than.
// # Arguments
// * `lhs` - The first i129 integer to compare.
// * `rhs` - The second i129 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than `rhs`, `false` otherwise.
fn i129_gt(lhs: i129, rhs: i129) -> bool {
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

// Determines whether the first i129 is less than the second i129.
// # Arguments
// * `lhs` - The i129 to compare against the second i129.
// * `rhs` - The i129 to compare against the first i129.
// # Returns
// * `bool` - `true` if `lhs` is less than `rhs`, `false` otherwise.
fn i129_lt(lhs: i129, rhs: i129) -> bool {
    // The result is the inverse of the greater than function.
    return !i129_gt(lhs, rhs);
}

// Checks if the first i129 integer is less than or equal to the second.
// # Arguments
// * `lhs` - The first i129 integer to compare.
// * `rhs` - The second i129 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is less than or equal to `rhs`, `false` otherwise.
fn i129_le(lhs: i129, rhs: i129) -> bool {
    if (lhs == rhs | i129_lt(lhs, rhs) == true) {
        return true;
    } else {
        return false;
    }
}

// Checks if the first i129 integer is greater than or equal to the second.
// # Arguments
// * `lhs` - The first i129 integer to compare.
// * `rhs` - The second i129 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
fn i129_ge(lhs: i129, rhs: i129) -> bool {
    if (lhs == rhs | i129_gt(lhs, rhs) == true) {
        return true;
    } else {
        return false;
    }
}

// Implements the PartialOrd trait for i129.
impl i129PartialOrd of PartialOrd<i129> {
    fn le(lhs: i129, rhs: i129) -> bool {
        i129_le(lhs, rhs)
    }
    fn ge(lhs: i129, rhs: i129) -> bool {
        i129_ge(lhs, rhs)
    }

    fn lt(lhs: i129, rhs: i129) -> bool {
        i129_lt(lhs, rhs)
    }
    fn gt(lhs: i129, rhs: i129) -> bool {
        i129_gt(lhs, rhs)
    }
}

// Negates the given i129 integer.
// # Arguments
// * `x` - The i129 integer to negate.
// # Returns
// * `i129` - The negation of `x`.
fn i129_neg(x: i129) -> i129 {
    // The negation of an integer is obtained by flipping its sign.
    return i129 { inner: x.inner, sign: !x.sign };
}

// Implements the Neg trait for i129.
impl i129Neg of Neg<i129> {
    fn neg(a: i129) -> i129 {
        i129_neg(a)
    }
}

// Computes the absolute value of the given i129 integer.
// # Arguments
// * `x` - The i129 integer to compute the absolute value of.
// # Returns
// * `i129` - The absolute value of `x`.
fn i129_abs(x: i129) -> i129 {
    return i129 { inner: x.inner, sign: false };
}

// Computes the maximum between two i129 integers.
// # Arguments
// * `lhs` - The first i129 integer to compare.
// * `rhs` - The second i129 integer to compare.
// # Returns
// * `i129` - The maximum between `lhs` and `rhs`.
fn i129_max(lhs: i129, rhs: i129) -> i129 {
    if (lhs > rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

// Computes the minimum between two i129 integers.
// # Arguments
// * `lhs` - The first i129 integer to compare.
// * `rhs` - The second i129 integer to compare.
// # Returns
// * `i129` - The minimum between `lhs` and `rhs`.
fn i129_min(lhs: i129, rhs: i129) -> i129 {
    if (lhs < rhs) {
        return lhs;
    } else {
        return rhs;
    }
}
