// Signed integers : i9, i17, i33, i65, i129

// ====================== INT 9 ======================

// i9 represents a 9-bit integer.
// The inner field holds the absolute value of the integer.
// The sign field is true for negative integers, and false for non-negative integers.
#[derive(Copy, Drop)]
struct i9 {
    inner: u8,
    sign: bool,
}

// Checks if the given i9 integer is zero and has the correct sign.
// # Arguments
// * `x` - The i9 integer to check.
// # Panics
// Panics if `x` is zero and has a sign that is not false.
fn i9_check_sign_zero(x: i9) {
    if x.inner == 0 {
        assert(!x.sign, 'sign of 0 must be false');
    }
}

// Adds two i9 integers.
// # Arguments
// * `lhs` - The first i9 to add.
// * `rhs` - The second i9 to add.
// # Returns
// * `i9` - The sum of `lhs` and `rhs`.
fn i9_add(lhs: i9, rhs: i9) -> i9 {
    i9_check_sign_zero(lhs);
    i9_check_sign_zero(rhs);
    // If both integers have the same sign, 
    // the sum of their absolute values can be returned.
    if lhs.sign == rhs.sign {
        let sum = lhs.inner + rhs.inner;
        return i9 { inner: sum, sign: lhs.sign };
    } else {
        // If the integers have different signs, 
        // the larger absolute value is subtracted from the smaller one.
        let (larger, smaller) = if lhs.inner >= rhs.inner {
            (lhs, rhs)
        } else {
            (rhs, lhs)
        };
        let difference = larger.inner - smaller.inner;

        return i9 { inner: difference, sign: larger.sign };
    }
}

// Implements the Add trait for i9.
impl i9Add of Add<i9> {
    fn add(lhs: i9, rhs: i9) -> i9 {
        i9_add(lhs, rhs)
    }
}

// Implements the AddEq trait for i9.
impl i9AddEq of AddEq<i9> {
    #[inline(always)]
    fn add_eq(ref self: i9, other: i9) {
        self = Add::add(self, other);
    }
}

// Subtracts two i9 integers.
// # Arguments
// * `lhs` - The first i9 to subtract.
// * `rhs` - The second i9 to subtract.
// # Returns
// * `i9` - The difference of `lhs` and `rhs`.
fn i9_sub(lhs: i9, rhs: i9) -> i9 {
    i9_check_sign_zero(lhs);
    i9_check_sign_zero(rhs);

    if (rhs.inner == 0) {
        return lhs;
    }

    // The subtraction of `lhs` to `rhs` is achieved by negating `rhs` sign and adding it to `lhs`.
    let neg_b = i9 { inner: rhs.inner, sign: !rhs.sign };
    return lhs + neg_b;
}

// Implements the Sub trait for i9.
impl i9Sub of Sub<i9> {
    fn sub(lhs: i9, rhs: i9) -> i9 {
        i9_sub(lhs, rhs)
    }
}

// Implements the SubEq trait for i9.
impl i9SubEq of SubEq<i9> {
    #[inline(always)]
    fn sub_eq(ref self: i9, other: i9) {
        self = Sub::sub(self, other);
    }
}

// Multiplies two i9 integers.
// 
// # Arguments
//
// * `lhs` - The first i9 to multiply.
// * `rhs` - The second i9 to multiply.
//
// # Returns
//
// * `i9` - The product of `lhs` and `rhs`.
fn i9_mul(lhs: i9, rhs: i9) -> i9 {
    i9_check_sign_zero(lhs);
    i9_check_sign_zero(rhs);

    // The sign of the product is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;
    // The product is the product of the absolute values of the operands.
    let inner = lhs.inner * rhs.inner;
    return i9 { inner, sign };
}

// Implements the Mul trait for i9.
impl i9Mul of Mul<i9> {
    fn mul(lhs: i9, rhs: i9) -> i9 {
        i9_mul(lhs, rhs)
    }
}

// Implements the MulEq trait for i9.
impl i9MulEq of MulEq<i9> {
    #[inline(always)]
    fn mul_eq(ref self: i9, other: i9) {
        self = Mul::mul(self, other);
    }
}

// Divides the first i9 by the second i9.
// # Arguments
// * `lhs` - The i9 dividend.
// * `rhs` - The i9 divisor.
// # Returns
// * `i9` - The quotient of `lhs` and `rhs`.
fn i9_div(lhs: i9, rhs: i9) -> i9 {
    i9_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    // The sign of the quotient is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;

    if (!sign) {
        // If the operands are positive, the quotient is simply their absolute value quotient.
        return i9 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the operands have different signs, rounding is necessary.
    // First, check if the quotient is an integer.
    if (lhs.inner % rhs.inner == 0) {
        return i9 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the quotient is not an integer, multiply the dividend by 10 to move the decimal point over.
    let quotient = (lhs.inner * 10) / rhs.inner;
    let last_digit = quotient % 10;

    // Check the last digit to determine rounding direction.
    if (last_digit <= 5) {
        return i9 { inner: quotient / 10, sign: sign };
    } else {
        return i9 { inner: (quotient / 10) + 1, sign: sign };
    }
}

// Implements the Div trait for i9.
impl i9Div of Div<i9> {
    fn div(lhs: i9, rhs: i9) -> i9 {
        i9_div(lhs, rhs)
    }
}

// Implements the DivEq trait for i9.
impl i9DivEq of DivEq<i9> {
    #[inline(always)]
    fn div_eq(ref self: i9, other: i9) {
        self = Div::div(self, other);
    }
}

// Calculates the remainder of the division of a first i9 by a second i9.
// # Arguments
// * `lhs` - The i9 dividend.
// * `rhs` - The i9 divisor.
// # Returns
// * `i9` - The remainder of dividing `lhs` by `rhs`.
fn i9_rem(lhs: i9, rhs: i9) -> i9 {
    i9_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    return lhs - (rhs * (lhs / rhs));
}

// Implements the Rem trait for i9.
impl i9Rem of Rem<i9> {
    fn rem(lhs: i9, rhs: i9) -> i9 {
        i9_rem(lhs, rhs)
    }
}

// Implements the RemEq trait for i9.
impl i9RemEq of RemEq<i9> {
    #[inline(always)]
    fn rem_eq(ref self: i9, other: i9) {
        self = Rem::rem(self, other);
    }
}

// Calculates both the quotient and the remainder of the division of a first i9 by a second i9.
// # Arguments
// * `lhs` - The i9 dividend.
// * `rhs` - The i9 divisor.
// # Returns
// * `(i9, i9)` - A tuple containing the quotient and the remainder of dividing `lhs` by `rhs`.
fn i9_div_rem(lhs: i9, rhs: i9) -> (i9, i9) {
    let quotient = i9_div(lhs, rhs);
    let remainder = i9_rem(lhs, rhs);

    return (quotient, remainder);
}

// Compares two i9 integers for equality.
// # Arguments
// * `lhs` - The first i9 integer to compare.
// * `rhs` - The second i9 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are equal, `false` otherwise.
fn i9_eq(lhs: @i9, rhs: @i9) -> bool {
    // Check if the two integers have the same sign and the same absolute value.
    *lhs.sign == *rhs.sign && *lhs.inner == *rhs.inner
}

// Compares two i9 integers for inequality.
// # Arguments
// * `lhs` - The first i9 integer to compare.
// * `rhs` - The second i9 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are not equal, `false` otherwise.
fn i9_ne(lhs: @i9, rhs: @i9) -> bool {
    // The result is the inverse of the equal function.
    return !i9_eq(lhs, rhs);
}

// Implements the PartialEq trait for i9.
impl i9PartialEq of PartialEq<i9> {
    fn eq(lhs: @i9, rhs: @i9) -> bool {
        i9_eq(lhs, rhs)
    }

    fn ne(lhs: @i9, rhs: @i9) -> bool {
        i9_ne(lhs, rhs)
    }
}

// Compares two i9 integers for greater than.
// # Arguments
// * `lhs` - The first i9 integer to compare.
// * `rhs` - The second i9 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than `rhs`, `false` otherwise.
fn i9_gt(lhs: i9, rhs: i9) -> bool {
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

// Determines whether the first i9 is less than the second i9.
// # Arguments
// * `lhs` - The i9 to compare against the second i9.
// * `rhs` - The i9 to compare against the first i9.
// # Returns
// * `bool` - `true` if `lhs` is less than `rhs`, `false` otherwise.
fn i9_lt(lhs: i9, rhs: i9) -> bool {
    // The result is the inverse of the greater than function.
    return !i9_gt(lhs, rhs);
}

// Checks if the first i9 integer is less than or equal to the second.
// # Arguments
// * `lhs` - The first i9 integer to compare.
// * `rhs` - The second i9 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is less than or equal to `rhs`, `false` otherwise.
fn i9_le(lhs: i9, rhs: i9) -> bool {
    lhs == rhs || i9_lt(lhs, rhs)
}

// Checks if the first i9 integer is greater than or equal to the second.
// # Arguments
// * `lhs` - The first i9 integer to compare.
// * `rhs` - The second i9 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
fn i9_ge(lhs: i9, rhs: i9) -> bool {
    lhs == rhs || i9_gt(lhs, rhs)
}

// Implements the PartialOrd trait for i9.
impl i9PartialOrd of PartialOrd<i9> {
    fn le(lhs: i9, rhs: i9) -> bool {
        i9_le(lhs, rhs)
    }
    fn ge(lhs: i9, rhs: i9) -> bool {
        i9_ge(lhs, rhs)
    }

    fn lt(lhs: i9, rhs: i9) -> bool {
        i9_lt(lhs, rhs)
    }
    fn gt(lhs: i9, rhs: i9) -> bool {
        i9_gt(lhs, rhs)
    }
}

// Negates the given i9 integer.
// # Arguments
// * `x` - The i9 integer to negate.
// # Returns
// * `i9` - The negation of `x`.
fn i9_neg(x: i9) -> i9 {
    // The negation of an integer is obtained by flipping its sign.
    return i9 { inner: x.inner, sign: !x.sign };
}

// Implements the Neg trait for i9.
impl i9Neg of Neg<i9> {
    fn neg(a: i9) -> i9 {
        i9_neg(a)
    }
}

// Computes the absolute value of the given i9 integer.
// # Arguments
// * `x` - The i9 integer to compute the absolute value of.
// # Returns
// * `i9` - The absolute value of `x`.
fn i9_abs(x: i9) -> i9 {
    return i9 { inner: x.inner, sign: false };
}

// Computes the maximum between two i9 integers.
// # Arguments
// * `lhs` - The first i9 integer to compare.
// * `rhs` - The second i9 integer to compare.
// # Returns
// * `i9` - The maximum between `lhs` and `rhs`.
fn i9_max(lhs: i9, rhs: i9) -> i9 {
    if (lhs > rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

// Computes the minimum between two i9 integers.
// # Arguments
// * `lhs` - The first i9 integer to compare.
// * `rhs` - The second i9 integer to compare.
// # Returns
// * `i9` - The minimum between `lhs` and `rhs`.
fn i9_min(lhs: i9, rhs: i9) -> i9 {
    if (lhs < rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

// ====================== INT 17 ======================

// i17 represents a 17-bit integer.
// The inner field holds the absolute value of the integer.
// The sign field is true for negative integers, and false for non-negative integers.
#[derive(Copy, Drop)]
struct i17 {
    inner: u16,
    sign: bool,
}

// Checks if the given i17 integer is zero and has the correct sign.
// # Arguments
// * `x` - The i17 integer to check.
// # Panics
// Panics if `x` is zero and has a sign that is not false.
fn i17_check_sign_zero(x: i17) {
    if x.inner == 0 {
        assert(!x.sign, 'sign of 0 must be false');
    }
}

// Adds two i17 integers.
// # Arguments
// * `lhs` - The first i17 to add.
// * `rhs` - The second i17 to add.
// # Returns
// * `i17` - The sum of `lhs` and `rhs`.
fn i17_add(lhs: i17, rhs: i17) -> i17 {
    i17_check_sign_zero(lhs);
    i17_check_sign_zero(rhs);
    // If both integers have the same sign, 
    // the sum of their absolute values can be returned.
    if lhs.sign == rhs.sign {
        let sum = lhs.inner + rhs.inner;
        return i17 { inner: sum, sign: lhs.sign };
    } else {
        // If the integers have different signs, 
        // the larger absolute value is subtracted from the smaller one.
        let (larger, smaller) = if lhs.inner >= rhs.inner {
            (lhs, rhs)
        } else {
            (rhs, lhs)
        };
        let difference = larger.inner - smaller.inner;

        return i17 { inner: difference, sign: larger.sign };
    }
}

// Implements the Add trait for i17.
impl i17Add of Add<i17> {
    fn add(lhs: i17, rhs: i17) -> i17 {
        i17_add(lhs, rhs)
    }
}

// Implements the AddEq trait for i17.
impl i17AddEq of AddEq<i17> {
    #[inline(always)]
    fn add_eq(ref self: i17, other: i17) {
        self = Add::add(self, other);
    }
}

// Subtracts two i17 integers.
// # Arguments
// * `lhs` - The first i17 to subtract.
// * `rhs` - The second i17 to subtract.
// # Returns
// * `i17` - The difference of `lhs` and `rhs`.
fn i17_sub(lhs: i17, rhs: i17) -> i17 {
    i17_check_sign_zero(lhs);
    i17_check_sign_zero(rhs);

    if (rhs.inner == 0) {
        return lhs;
    }

    // The subtraction of `lhs` to `rhs` is achieved by negating `rhs` sign and adding it to `lhs`.
    let neg_b = i17 { inner: rhs.inner, sign: !rhs.sign };
    return lhs + neg_b;
}

// Implements the Sub trait for i17.
impl i17Sub of Sub<i17> {
    fn sub(lhs: i17, rhs: i17) -> i17 {
        i17_sub(lhs, rhs)
    }
}

// Implements the SubEq trait for i17.
impl i17SubEq of SubEq<i17> {
    #[inline(always)]
    fn sub_eq(ref self: i17, other: i17) {
        self = Sub::sub(self, other);
    }
}

// Multiplies two i17 integers.
// 
// # Arguments
//
// * `lhs` - The first i17 to multiply.
// * `rhs` - The second i17 to multiply.
//
// # Returns
//
// * `i17` - The product of `lhs` and `rhs`.
fn i17_mul(lhs: i17, rhs: i17) -> i17 {
    i17_check_sign_zero(lhs);
    i17_check_sign_zero(rhs);

    // The sign of the product is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;
    // The product is the product of the absolute values of the operands.
    let inner = lhs.inner * rhs.inner;
    return i17 { inner, sign };
}

// Implements the Mul trait for i17.
impl i17Mul of Mul<i17> {
    fn mul(lhs: i17, rhs: i17) -> i17 {
        i17_mul(lhs, rhs)
    }
}

// Implements the MulEq trait for i17.
impl i17MulEq of MulEq<i17> {
    #[inline(always)]
    fn mul_eq(ref self: i17, other: i17) {
        self = Mul::mul(self, other);
    }
}

// Divides the first i17 by the second i17.
// # Arguments
// * `lhs` - The i17 dividend.
// * `rhs` - The i17 divisor.
// # Returns
// * `i17` - The quotient of `lhs` and `rhs`.
fn i17_div(lhs: i17, rhs: i17) -> i17 {
    i17_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    // The sign of the quotient is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;

    if (!sign) {
        // If the operands are positive, the quotient is simply their absolute value quotient.
        return i17 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the operands have different signs, rounding is necessary.
    // First, check if the quotient is an integer.
    if (lhs.inner % rhs.inner == 0) {
        return i17 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the quotient is not an integer, multiply the dividend by 10 to move the decimal point over.
    let quotient = (lhs.inner * 10) / rhs.inner;
    let last_digit = quotient % 10;

    // Check the last digit to determine rounding direction.
    if (last_digit <= 5) {
        return i17 { inner: quotient / 10, sign: sign };
    } else {
        return i17 { inner: (quotient / 10) + 1, sign: sign };
    }
}

// Implements the Div trait for i17.
impl i17Div of Div<i17> {
    fn div(lhs: i17, rhs: i17) -> i17 {
        i17_div(lhs, rhs)
    }
}

// Implements the DivEq trait for i17.
impl i17DivEq of DivEq<i17> {
    #[inline(always)]
    fn div_eq(ref self: i17, other: i17) {
        self = Div::div(self, other);
    }
}

// Calculates the remainder of the division of a first i17 by a second i17.
// # Arguments
// * `lhs` - The i17 dividend.
// * `rhs` - The i17 divisor.
// # Returns
// * `i17` - The remainder of dividing `lhs` by `rhs`.
fn i17_rem(lhs: i17, rhs: i17) -> i17 {
    i17_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    return lhs - (rhs * (lhs / rhs));
}

// Implements the Rem trait for i17.
impl i17Rem of Rem<i17> {
    fn rem(lhs: i17, rhs: i17) -> i17 {
        i17_rem(lhs, rhs)
    }
}

// Implements the RemEq trait for i17.
impl i17RemEq of RemEq<i17> {
    #[inline(always)]
    fn rem_eq(ref self: i17, other: i17) {
        self = Rem::rem(self, other);
    }
}

// Calculates both the quotient and the remainder of the division of a first i17 by a second i17.
// # Arguments
// * `lhs` - The i17 dividend.
// * `rhs` - The i17 divisor.
// # Returns
// * `(i17, i17)` - A tuple containing the quotient and the remainder of dividing `lhs` by `rhs`.
fn i17_div_rem(lhs: i17, rhs: i17) -> (i17, i17) {
    let quotient = i17_div(lhs, rhs);
    let remainder = i17_rem(lhs, rhs);

    return (quotient, remainder);
}

// Compares two i17 integers for equality.
// # Arguments
// * `lhs` - The first i17 integer to compare.
// * `rhs` - The second i17 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are equal, `false` otherwise.
fn i17_eq(lhs: @i17, rhs: @i17) -> bool {
    // Check if the two integers have the same sign and the same absolute value.
    *lhs.sign == *rhs.sign && *lhs.inner == *rhs.inner
}

// Compares two i17 integers for inequality.
// # Arguments
// * `lhs` - The first i17 integer to compare.
// * `rhs` - The second i17 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are not equal, `false` otherwise.
fn i17_ne(lhs: @i17, rhs: @i17) -> bool {
    // The result is the inverse of the equal function.
    return !i17_eq(lhs, rhs);
}

// Implements the PartialEq trait for i17.
impl i17PartialEq of PartialEq<i17> {
    fn eq(lhs: @i17, rhs: @i17) -> bool {
        i17_eq(lhs, rhs)
    }

    fn ne(lhs: @i17, rhs: @i17) -> bool {
        i17_ne(lhs, rhs)
    }
}

// Compares two i17 integers for greater than.
// # Arguments
// * `lhs` - The first i17 integer to compare.
// * `rhs` - The second i17 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than `rhs`, `false` otherwise.
fn i17_gt(lhs: i17, rhs: i17) -> bool {
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

// Determines whether the first i17 is less than the second i17.
// # Arguments
// * `lhs` - The i17 to compare against the second i17.
// * `rhs` - The i17 to compare against the first i17.
// # Returns
// * `bool` - `true` if `lhs` is less than `rhs`, `false` otherwise.
fn i17_lt(lhs: i17, rhs: i17) -> bool {
    // The result is the inverse of the greater than function.
    return !i17_gt(lhs, rhs);
}

// Checks if the first i17 integer is less than or equal to the second.
// # Arguments
// * `lhs` - The first i17 integer to compare.
// * `rhs` - The second i17 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is less than or equal to `rhs`, `false` otherwise.
fn i17_le(lhs: i17, rhs: i17) -> bool {
    lhs == rhs || i17_lt(lhs, rhs)
}

// Checks if the first i17 integer is greater than or equal to the second.
// # Arguments
// * `lhs` - The first i17 integer to compare.
// * `rhs` - The second i17 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
fn i17_ge(lhs: i17, rhs: i17) -> bool {
    lhs == rhs || i17_gt(lhs, rhs)
}

// Implements the PartialOrd trait for i17.
impl i17PartialOrd of PartialOrd<i17> {
    fn le(lhs: i17, rhs: i17) -> bool {
        i17_le(lhs, rhs)
    }
    fn ge(lhs: i17, rhs: i17) -> bool {
        i17_ge(lhs, rhs)
    }

    fn lt(lhs: i17, rhs: i17) -> bool {
        i17_lt(lhs, rhs)
    }
    fn gt(lhs: i17, rhs: i17) -> bool {
        i17_gt(lhs, rhs)
    }
}

// Negates the given i17 integer.
// # Arguments
// * `x` - The i17 integer to negate.
// # Returns
// * `i17` - The negation of `x`.
fn i17_neg(x: i17) -> i17 {
    // The negation of an integer is obtained by flipping its sign.
    return i17 { inner: x.inner, sign: !x.sign };
}

// Implements the Neg trait for i17.
impl i17Neg of Neg<i17> {
    fn neg(a: i17) -> i17 {
        i17_neg(a)
    }
}

// Computes the absolute value of the given i17 integer.
// # Arguments
// * `x` - The i17 integer to compute the absolute value of.
// # Returns
// * `i17` - The absolute value of `x`.
fn i17_abs(x: i17) -> i17 {
    return i17 { inner: x.inner, sign: false };
}

// Computes the maximum between two i17 integers.
// # Arguments
// * `lhs` - The first i17 integer to compare.
// * `rhs` - The second i17 integer to compare.
// # Returns
// * `i17` - The maximum between `lhs` and `rhs`.
fn i17_max(lhs: i17, rhs: i17) -> i17 {
    if (lhs > rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

// Computes the minimum between two i17 integers.
// # Arguments
// * `lhs` - The first i17 integer to compare.
// * `rhs` - The second i17 integer to compare.
// # Returns
// * `i17` - The minimum between `lhs` and `rhs`.
fn i17_min(lhs: i17, rhs: i17) -> i17 {
    if (lhs < rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

// ====================== INT 33 ======================

// i33 represents a 33-bit integer.
// The inner field holds the absolute value of the integer.
// The sign field is true for negative integers, and false for non-negative integers.
#[derive(Copy, Drop)]
struct i33 {
    inner: u32,
    sign: bool,
}

// Checks if the given i33 integer is zero and has the correct sign.
// # Arguments
// * `x` - The i33 integer to check.
// # Panics
// Panics if `x` is zero and has a sign that is not false.
fn i33_check_sign_zero(x: i33) {
    if x.inner == 0 {
        assert(!x.sign, 'sign of 0 must be false');
    }
}

// Adds two i33 integers.
// # Arguments
// * `lhs` - The first i33 to add.
// * `rhs` - The second i33 to add.
// # Returns
// * `i33` - The sum of `lhs` and `rhs`.
fn i33_add(lhs: i33, rhs: i33) -> i33 {
    i33_check_sign_zero(lhs);
    i33_check_sign_zero(rhs);
    // If both integers have the same sign, 
    // the sum of their absolute values can be returned.
    if lhs.sign == rhs.sign {
        let sum = lhs.inner + rhs.inner;
        return i33 { inner: sum, sign: lhs.sign };
    } else {
        // If the integers have different signs, 
        // the larger absolute value is subtracted from the smaller one.
        let (larger, smaller) = if lhs.inner >= rhs.inner {
            (lhs, rhs)
        } else {
            (rhs, lhs)
        };
        let difference = larger.inner - smaller.inner;

        return i33 { inner: difference, sign: larger.sign };
    }
}

// Implements the Add trait for i33.
impl i33Add of Add<i33> {
    fn add(lhs: i33, rhs: i33) -> i33 {
        i33_add(lhs, rhs)
    }
}

// Implements the AddEq trait for i33.
impl i33AddEq of AddEq<i33> {
    #[inline(always)]
    fn add_eq(ref self: i33, other: i33) {
        self = Add::add(self, other);
    }
}

// Subtracts two i33 integers.
// # Arguments
// * `lhs` - The first i33 to subtract.
// * `rhs` - The second i33 to subtract.
// # Returns
// * `i33` - The difference of `lhs` and `rhs`.
fn i33_sub(lhs: i33, rhs: i33) -> i33 {
    i33_check_sign_zero(lhs);
    i33_check_sign_zero(rhs);

    if (rhs.inner == 0) {
        return lhs;
    }

    // The subtraction of `lhs` to `rhs` is achieved by negating `rhs` sign and adding it to `lhs`.
    let neg_b = i33 { inner: rhs.inner, sign: !rhs.sign };
    return lhs + neg_b;
}

// Implements the Sub trait for i33.
impl i33Sub of Sub<i33> {
    fn sub(lhs: i33, rhs: i33) -> i33 {
        i33_sub(lhs, rhs)
    }
}

// Implements the SubEq trait for i33.
impl i33SubEq of SubEq<i33> {
    #[inline(always)]
    fn sub_eq(ref self: i33, other: i33) {
        self = Sub::sub(self, other);
    }
}

// Multiplies two i33 integers.
// 
// # Arguments
//
// * `lhs` - The first i33 to multiply.
// * `rhs` - The second i33 to multiply.
//
// # Returns
//
// * `i33` - The product of `lhs` and `rhs`.
fn i33_mul(lhs: i33, rhs: i33) -> i33 {
    i33_check_sign_zero(lhs);
    i33_check_sign_zero(rhs);

    // The sign of the product is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;
    // The product is the product of the absolute values of the operands.
    let inner = lhs.inner * rhs.inner;
    return i33 { inner, sign };
}

// Implements the Mul trait for i33.
impl i33Mul of Mul<i33> {
    fn mul(lhs: i33, rhs: i33) -> i33 {
        i33_mul(lhs, rhs)
    }
}

// Implements the MulEq trait for i33.
impl i33MulEq of MulEq<i33> {
    #[inline(always)]
    fn mul_eq(ref self: i33, other: i33) {
        self = Mul::mul(self, other);
    }
}

// Divides the first i33 by the second i33.
// # Arguments
// * `lhs` - The i33 dividend.
// * `rhs` - The i33 divisor.
// # Returns
// * `i33` - The quotient of `lhs` and `rhs`.
fn i33_div(lhs: i33, rhs: i33) -> i33 {
    i33_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    // The sign of the quotient is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;

    if (!sign) {
        // If the operands are positive, the quotient is simply their absolute value quotient.
        return i33 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the operands have different signs, rounding is necessary.
    // First, check if the quotient is an integer.
    if (lhs.inner % rhs.inner == 0) {
        return i33 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the quotient is not an integer, multiply the dividend by 10 to move the decimal point over.
    let quotient = (lhs.inner * 10) / rhs.inner;
    let last_digit = quotient % 10;

    // Check the last digit to determine rounding direction.
    if (last_digit <= 5) {
        return i33 { inner: quotient / 10, sign: sign };
    } else {
        return i33 { inner: (quotient / 10) + 1, sign: sign };
    }
}

// Implements the Div trait for i33.
impl i33Div of Div<i33> {
    fn div(lhs: i33, rhs: i33) -> i33 {
        i33_div(lhs, rhs)
    }
}

// Implements the DivEq trait for i33.
impl i33DivEq of DivEq<i33> {
    #[inline(always)]
    fn div_eq(ref self: i33, other: i33) {
        self = Div::div(self, other);
    }
}

// Calculates the remainder of the division of a first i33 by a second i33.
// # Arguments
// * `lhs` - The i33 dividend.
// * `rhs` - The i33 divisor.
// # Returns
// * `i33` - The remainder of dividing `lhs` by `rhs`.
fn i33_rem(lhs: i33, rhs: i33) -> i33 {
    i33_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    return lhs - (rhs * (lhs / rhs));
}

// Implements the Rem trait for i33.
impl i33Rem of Rem<i33> {
    fn rem(lhs: i33, rhs: i33) -> i33 {
        i33_rem(lhs, rhs)
    }
}

// Implements the RemEq trait for i33.
impl i33RemEq of RemEq<i33> {
    #[inline(always)]
    fn rem_eq(ref self: i33, other: i33) {
        self = Rem::rem(self, other);
    }
}

// Calculates both the quotient and the remainder of the division of a first i33 by a second i33.
// # Arguments
// * `lhs` - The i33 dividend.
// * `rhs` - The i33 divisor.
// # Returns
// * `(i33, i33)` - A tuple containing the quotient and the remainder of dividing `lhs` by `rhs`.
fn i33_div_rem(lhs: i33, rhs: i33) -> (i33, i33) {
    let quotient = i33_div(lhs, rhs);
    let remainder = i33_rem(lhs, rhs);

    return (quotient, remainder);
}

// Compares two i33 integers for equality.
// # Arguments
// * `lhs` - The first i33 integer to compare.
// * `rhs` - The second i33 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are equal, `false` otherwise.
fn i33_eq(lhs: @i33, rhs: @i33) -> bool {
    // Check if the two integers have the same sign and the same absolute value.
    *lhs.sign == *rhs.sign && *lhs.inner == *rhs.inner
}

// Compares two i33 integers for inequality.
// # Arguments
// * `lhs` - The first i33 integer to compare.
// * `rhs` - The second i33 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are not equal, `false` otherwise.
fn i33_ne(lhs: @i33, rhs: @i33) -> bool {
    // The result is the inverse of the equal function.
    return !i33_eq(lhs, rhs);
}

// Implements the PartialEq trait for i33.
impl i33PartialEq of PartialEq<i33> {
    fn eq(lhs: @i33, rhs: @i33) -> bool {
        i33_eq(lhs, rhs)
    }

    fn ne(lhs: @i33, rhs: @i33) -> bool {
        i33_ne(lhs, rhs)
    }
}

// Compares two i33 integers for greater than.
// # Arguments
// * `lhs` - The first i33 integer to compare.
// * `rhs` - The second i33 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than `rhs`, `false` otherwise.
fn i33_gt(lhs: i33, rhs: i33) -> bool {
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

// Determines whether the first i33 is less than the second i33.
// # Arguments
// * `lhs` - The i33 to compare against the second i33.
// * `rhs` - The i33 to compare against the first i33.
// # Returns
// * `bool` - `true` if `lhs` is less than `rhs`, `false` otherwise.
fn i33_lt(lhs: i33, rhs: i33) -> bool {
    // The result is the inverse of the greater than function.
    return !i33_gt(lhs, rhs);
}

// Checks if the first i33 integer is less than or equal to the second.
// # Arguments
// * `lhs` - The first i33 integer to compare.
// * `rhs` - The second i33 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is less than or equal to `rhs`, `false` otherwise.
fn i33_le(lhs: i33, rhs: i33) -> bool {
    lhs == rhs || i33_lt(lhs, rhs)
}

// Checks if the first i33 integer is greater than or equal to the second.
// # Arguments
// * `lhs` - The first i33 integer to compare.
// * `rhs` - The second i33 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
fn i33_ge(lhs: i33, rhs: i33) -> bool {
    lhs == rhs || i33_gt(lhs, rhs)
}

// Implements the PartialOrd trait for i33.
impl i33PartialOrd of PartialOrd<i33> {
    fn le(lhs: i33, rhs: i33) -> bool {
        i33_le(lhs, rhs)
    }
    fn ge(lhs: i33, rhs: i33) -> bool {
        i33_ge(lhs, rhs)
    }

    fn lt(lhs: i33, rhs: i33) -> bool {
        i33_lt(lhs, rhs)
    }
    fn gt(lhs: i33, rhs: i33) -> bool {
        i33_gt(lhs, rhs)
    }
}

// Negates the given i33 integer.
// # Arguments
// * `x` - The i33 integer to negate.
// # Returns
// * `i33` - The negation of `x`.
fn i33_neg(x: i33) -> i33 {
    // The negation of an integer is obtained by flipping its sign.
    return i33 { inner: x.inner, sign: !x.sign };
}

// Implements the Neg trait for i33.
impl i33Neg of Neg<i33> {
    fn neg(a: i33) -> i33 {
        i33_neg(a)
    }
}

// Computes the absolute value of the given i33 integer.
// # Arguments
// * `x` - The i33 integer to compute the absolute value of.
// # Returns
// * `i33` - The absolute value of `x`.
fn i33_abs(x: i33) -> i33 {
    return i33 { inner: x.inner, sign: false };
}

// Computes the maximum between two i33 integers.
// # Arguments
// * `lhs` - The first i33 integer to compare.
// * `rhs` - The second i33 integer to compare.
// # Returns
// * `i33` - The maximum between `lhs` and `rhs`.
fn i33_max(lhs: i33, rhs: i33) -> i33 {
    if (lhs > rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

// Computes the minimum between two i33 integers.
// # Arguments
// * `lhs` - The first i33 integer to compare.
// * `rhs` - The second i33 integer to compare.
// # Returns
// * `i33` - The minimum between `lhs` and `rhs`.
fn i33_min(lhs: i33, rhs: i33) -> i33 {
    if (lhs < rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

// ====================== INT 65 ======================

// i65 represents a 65-bit integer.
// The inner field holds the absolute value of the integer.
// The sign field is true for negative integers, and false for non-negative integers.
#[derive(Copy, Drop)]
struct i65 {
    inner: u64,
    sign: bool,
}

// Checks if the given i65 integer is zero and has the correct sign.
// # Arguments
// * `x` - The i65 integer to check.
// # Panics
// Panics if `x` is zero and has a sign that is not false.
fn i65_check_sign_zero(x: i65) {
    if x.inner == 0 {
        assert(!x.sign, 'sign of 0 must be false');
    }
}

// Adds two i65 integers.
// # Arguments
// * `lhs` - The first i65 to add.
// * `rhs` - The second i65 to add.
// # Returns
// * `i65` - The sum of `lhs` and `rhs`.
fn i65_add(lhs: i65, rhs: i65) -> i65 {
    i65_check_sign_zero(lhs);
    i65_check_sign_zero(rhs);
    // If both integers have the same sign, 
    // the sum of their absolute values can be returned.
    if lhs.sign == rhs.sign {
        let sum = lhs.inner + rhs.inner;
        return i65 { inner: sum, sign: lhs.sign };
    } else {
        // If the integers have different signs, 
        // the larger absolute value is subtracted from the smaller one.
        let (larger, smaller) = if lhs.inner >= rhs.inner {
            (lhs, rhs)
        } else {
            (rhs, lhs)
        };
        let difference = larger.inner - smaller.inner;

        return i65 { inner: difference, sign: larger.sign };
    }
}

// Implements the Add trait for i65.
impl i65Add of Add<i65> {
    fn add(lhs: i65, rhs: i65) -> i65 {
        i65_add(lhs, rhs)
    }
}

// Implements the AddEq trait for i65.
impl i65AddEq of AddEq<i65> {
    #[inline(always)]
    fn add_eq(ref self: i65, other: i65) {
        self = Add::add(self, other);
    }
}

// Subtracts two i65 integers.
// # Arguments
// * `lhs` - The first i65 to subtract.
// * `rhs` - The second i65 to subtract.
// # Returns
// * `i65` - The difference of `lhs` and `rhs`.
fn i65_sub(lhs: i65, rhs: i65) -> i65 {
    i65_check_sign_zero(lhs);
    i65_check_sign_zero(rhs);

    if (rhs.inner == 0) {
        return lhs;
    }

    // The subtraction of `lhs` to `rhs` is achieved by negating `rhs` sign and adding it to `lhs`.
    let neg_b = i65 { inner: rhs.inner, sign: !rhs.sign };
    return lhs + neg_b;
}

// Implements the Sub trait for i65.
impl i65Sub of Sub<i65> {
    fn sub(lhs: i65, rhs: i65) -> i65 {
        i65_sub(lhs, rhs)
    }
}

// Implements the SubEq trait for i65.
impl i65SubEq of SubEq<i65> {
    #[inline(always)]
    fn sub_eq(ref self: i65, other: i65) {
        self = Sub::sub(self, other);
    }
}

// Multiplies two i65 integers.
// 
// # Arguments
//
// * `lhs` - The first i65 to multiply.
// * `rhs` - The second i65 to multiply.
//
// # Returns
//
// * `i65` - The product of `lhs` and `rhs`.
fn i65_mul(lhs: i65, rhs: i65) -> i65 {
    i65_check_sign_zero(lhs);
    i65_check_sign_zero(rhs);

    // The sign of the product is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;
    // The product is the product of the absolute values of the operands.
    let inner = lhs.inner * rhs.inner;
    return i65 { inner, sign };
}

// Implements the Mul trait for i65.
impl i65Mul of Mul<i65> {
    fn mul(lhs: i65, rhs: i65) -> i65 {
        i65_mul(lhs, rhs)
    }
}

// Implements the MulEq trait for i65.
impl i65MulEq of MulEq<i65> {
    #[inline(always)]
    fn mul_eq(ref self: i65, other: i65) {
        self = Mul::mul(self, other);
    }
}

// Divides the first i65 by the second i65.
// # Arguments
// * `lhs` - The i65 dividend.
// * `rhs` - The i65 divisor.
// # Returns
// * `i65` - The quotient of `lhs` and `rhs`.
fn i65_div(lhs: i65, rhs: i65) -> i65 {
    i65_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    // The sign of the quotient is the XOR of the signs of the operands.
    let sign = lhs.sign ^ rhs.sign;

    if (!sign) {
        // If the operands are positive, the quotient is simply their absolute value quotient.
        return i65 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the operands have different signs, rounding is necessary.
    // First, check if the quotient is an integer.
    if (lhs.inner % rhs.inner == 0) {
        return i65 { inner: lhs.inner / rhs.inner, sign: sign };
    }

    // If the quotient is not an integer, multiply the dividend by 10 to move the decimal point over.
    let quotient = (lhs.inner * 10) / rhs.inner;
    let last_digit = quotient % 10;

    // Check the last digit to determine rounding direction.
    if (last_digit <= 5) {
        return i65 { inner: quotient / 10, sign: sign };
    } else {
        return i65 { inner: (quotient / 10) + 1, sign: sign };
    }
}

// Implements the Div trait for i65.
impl i65Div of Div<i65> {
    fn div(lhs: i65, rhs: i65) -> i65 {
        i65_div(lhs, rhs)
    }
}

// Implements the DivEq trait for i65.
impl i65DivEq of DivEq<i65> {
    #[inline(always)]
    fn div_eq(ref self: i65, other: i65) {
        self = Div::div(self, other);
    }
}

// Calculates the remainder of the division of a first i65 by a second i65.
// # Arguments
// * `lhs` - The i65 dividend.
// * `rhs` - The i65 divisor.
// # Returns
// * `i65` - The remainder of dividing `lhs` by `rhs`.
fn i65_rem(lhs: i65, rhs: i65) -> i65 {
    i65_check_sign_zero(lhs);
    // Check that the divisor is not zero.
    assert(rhs.inner != 0, 'b can not be 0');

    return lhs - (rhs * (lhs / rhs));
}

// Implements the Rem trait for i65.
impl i65Rem of Rem<i65> {
    fn rem(lhs: i65, rhs: i65) -> i65 {
        i65_rem(lhs, rhs)
    }
}

// Implements the RemEq trait for i65.
impl i65RemEq of RemEq<i65> {
    #[inline(always)]
    fn rem_eq(ref self: i65, other: i65) {
        self = Rem::rem(self, other);
    }
}

// Calculates both the quotient and the remainder of the division of a first i65 by a second i65.
// # Arguments
// * `lhs` - The i65 dividend.
// * `rhs` - The i65 divisor.
// # Returns
// * `(i65, i65)` - A tuple containing the quotient and the remainder of dividing `lhs` by `rhs`.
fn i65_div_rem(lhs: i65, rhs: i65) -> (i65, i65) {
    let quotient = i65_div(lhs, rhs);
    let remainder = i65_rem(lhs, rhs);

    return (quotient, remainder);
}

// Compares two i65 integers for equality.
// # Arguments
// * `lhs` - The first i65 integer to compare.
// * `rhs` - The second i65 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are equal, `false` otherwise.
fn i65_eq(lhs: @i65, rhs: @i65) -> bool {
    // Check if the two integers have the same sign and the same absolute value.
    *lhs.sign == *rhs.sign && *lhs.inner == *rhs.inner
}

// Compares two i65 integers for inequality.
// # Arguments
// * `lhs` - The first i65 integer to compare.
// * `rhs` - The second i65 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are not equal, `false` otherwise.
fn i65_ne(lhs: @i65, rhs: @i65) -> bool {
    // The result is the inverse of the equal function.
    return !i65_eq(lhs, rhs);
}

// Implements the PartialEq trait for i65.
impl i65PartialEq of PartialEq<i65> {
    fn eq(lhs: @i65, rhs: @i65) -> bool {
        i65_eq(lhs, rhs)
    }

    fn ne(lhs: @i65, rhs: @i65) -> bool {
        i65_ne(lhs, rhs)
    }
}

// Compares two i65 integers for greater than.
// # Arguments
// * `lhs` - The first i65 integer to compare.
// * `rhs` - The second i65 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than `rhs`, `false` otherwise.
fn i65_gt(lhs: i65, rhs: i65) -> bool {
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

// Determines whether the first i65 is less than the second i65.
// # Arguments
// * `lhs` - The i65 to compare against the second i65.
// * `rhs` - The i65 to compare against the first i65.
// # Returns
// * `bool` - `true` if `lhs` is less than `rhs`, `false` otherwise.
fn i65_lt(lhs: i65, rhs: i65) -> bool {
    // The result is the inverse of the greater than function.
    return !i65_gt(lhs, rhs);
}

// Checks if the first i65 integer is less than or equal to the second.
// # Arguments
// * `lhs` - The first i65 integer to compare.
// * `rhs` - The second i65 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is less than or equal to `rhs`, `false` otherwise.
fn i65_le(lhs: i65, rhs: i65) -> bool {
    lhs == rhs || i65_lt(lhs, rhs)
}

// Checks if the first i65 integer is greater than or equal to the second.
// # Arguments
// * `lhs` - The first i65 integer to compare.
// * `rhs` - The second i65 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
fn i65_ge(lhs: i65, rhs: i65) -> bool {
    lhs == rhs || i65_gt(lhs, rhs)
}

// Implements the PartialOrd trait for i65.
impl i65PartialOrd of PartialOrd<i65> {
    fn le(lhs: i65, rhs: i65) -> bool {
        i65_le(lhs, rhs)
    }
    fn ge(lhs: i65, rhs: i65) -> bool {
        i65_ge(lhs, rhs)
    }

    fn lt(lhs: i65, rhs: i65) -> bool {
        i65_lt(lhs, rhs)
    }
    fn gt(lhs: i65, rhs: i65) -> bool {
        i65_gt(lhs, rhs)
    }
}

// Negates the given i65 integer.
// # Arguments
// * `x` - The i65 integer to negate.
// # Returns
// * `i65` - The negation of `x`.
fn i65_neg(x: i65) -> i65 {
    // The negation of an integer is obtained by flipping its sign.
    return i65 { inner: x.inner, sign: !x.sign };
}

// Implements the Neg trait for i65.
impl i65Neg of Neg<i65> {
    fn neg(a: i65) -> i65 {
        i65_neg(a)
    }
}

// Computes the absolute value of the given i65 integer.
// # Arguments
// * `x` - The i65 integer to compute the absolute value of.
// # Returns
// * `i65` - The absolute value of `x`.
fn i65_abs(x: i65) -> i65 {
    return i65 { inner: x.inner, sign: false };
}

// Computes the maximum between two i65 integers.
// # Arguments
// * `lhs` - The first i65 integer to compare.
// * `rhs` - The second i65 integer to compare.
// # Returns
// * `i65` - The maximum between `lhs` and `rhs`.
fn i65_max(lhs: i65, rhs: i65) -> i65 {
    if (lhs > rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

// Computes the minimum between two i65 integers.
// # Arguments
// * `lhs` - The first i65 integer to compare.
// * `rhs` - The second i65 integer to compare.
// # Returns
// * `i65` - The minimum between `lhs` and `rhs`.
fn i65_min(lhs: i65, rhs: i65) -> i65 {
    if (lhs < rhs) {
        return lhs;
    } else {
        return rhs;
    }
}

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
        assert(!x.sign, 'sign of 0 must be false');
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

    if (!sign) {
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
fn i129_eq(lhs: @i129, rhs: @i129) -> bool {
    // Check if the two integers have the same sign and the same absolute value.
    *lhs.sign == *rhs.sign && *lhs.inner == *rhs.inner
}

// Compares two i129 integers for inequality.
// # Arguments
// * `lhs` - The first i129 integer to compare.
// * `rhs` - The second i129 integer to compare.
// # Returns
// * `bool` - `true` if the two integers are not equal, `false` otherwise.
fn i129_ne(lhs: @i129, rhs: @i129) -> bool {
    // The result is the inverse of the equal function.
    return !i129_eq(lhs, rhs);
}

// Implements the PartialEq trait for i129.
impl i129PartialEq of PartialEq<i129> {
    fn eq(lhs: @i129, rhs: @i129) -> bool {
        i129_eq(lhs, rhs)
    }

    fn ne(lhs: @i129, rhs: @i129) -> bool {
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
    lhs == rhs || i129_lt(lhs, rhs)
}

// Checks if the first i129 integer is greater than or equal to the second.
// # Arguments
// * `lhs` - The first i129 integer to compare.
// * `rhs` - The second i129 integer to compare.
// # Returns
// * `bool` - `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
fn i129_ge(lhs: i129, rhs: i129) -> bool {
    lhs == rhs || i129_gt(lhs, rhs)
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
