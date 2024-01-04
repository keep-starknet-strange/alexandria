use alexandria_math::signed_integers::i129;
use alexandria_math::signed_integers::i129_div_rem;

#[test]
fn i129_test_add() {
    // Test addition of two positive integers
    let a = i129 { inner: 42_u128, sign: false };
    let b = i129 { inner: 13_u128, sign: false };
    let result = a + b;
    assert(result.inner == 55_u128, '42 + 13 = 55');
    assert(result.sign == false, '42 + 13 -> positive');

    // Test addition of two negative integers
    let a = i129 { inner: 42_u128, sign: true };
    let b = i129 { inner: 13_u128, sign: true };
    let result = a + b;
    assert(result.inner == 55_u128, '-42 - 13 = -55');
    assert(result.sign == true, '-42 - 13 -> negative');

    // Test addition of a positive integer and a negative integer with the same magnitude
    let a = i129 { inner: 42_u128, sign: false };
    let b = i129 { inner: 42_u128, sign: true };
    let result = a + b;
    assert(result.inner == 0_u128, '42 - 42 = 0');
    assert(result.sign == false, '42 - 42 -> positive');

    // Test addition of a positive integer and a negative integer with different magnitudes
    let a = i129 { inner: 42_u128, sign: false };
    let b = i129 { inner: 13_u128, sign: true };
    let result = a + b;
    assert(result.inner == 29_u128, '42 - 13 = 29');
    assert(result.sign == false, '42 - 13 -> positive');

    // Test addition of a negative integer and a positive integer with different magnitudes
    let a = i129 { inner: 42_u128, sign: true };
    let b = i129 { inner: 13_u128, sign: false };
    let result = a + b;
    assert(result.inner == 29_u128, '-42 + 13 = -29');
    assert(result.sign == true, '-42 + 13 -> negative');
}

#[test]
fn i129_test_sub() {
    // Test subtraction of two positive integers with larger first
    let a = i129 { inner: 42_u128, sign: false };
    let b = i129 { inner: 13_u128, sign: false };
    let result = a - b;
    assert(result.inner == 29_u128, '42 - 13 = 29');
    assert(result.sign == false, '42 - 13 -> positive');

    // Test subtraction of two positive integers with larger second
    let a = i129 { inner: 13_u128, sign: false };
    let b = i129 { inner: 42_u128, sign: false };
    let result = a - b;
    assert(result.inner == 29_u128, '13 - 42 = -29');
    assert(result.sign == true, '13 - 42 -> negative');

    // Test subtraction of two negative integers with larger first
    let a = i129 { inner: 42_u128, sign: true };
    let b = i129 { inner: 13_u128, sign: true };
    let result = a - b;
    assert(result.inner == 29_u128, '-42 - -13 = 29');
    assert(result.sign == true, '-42 - -13 -> negative');

    // Test subtraction of two negative integers with larger second
    let a = i129 { inner: 13_u128, sign: true };
    let b = i129 { inner: 42_u128, sign: true };
    let result = a - b;
    assert(result.inner == 29_u128, '-13 - -42 = 29');
    assert(result.sign == false, '-13 - -42 -> positive');

    // Test subtraction of a positive integer and a negative integer with the same magnitude
    let a = i129 { inner: 42_u128, sign: false };
    let b = i129 { inner: 42_u128, sign: true };
    let result = a - b;
    assert(result.inner == 84_u128, '42 - -42 = 84');
    assert(result.sign == false, '42 - -42 -> postive');

    // Test subtraction of a negative integer and a positive integer with the same magnitude
    let a = i129 { inner: 42_u128, sign: true };
    let b = i129 { inner: 42_u128, sign: false };
    let result = a - b;
    assert(result.inner == 84_u128, '-42 - 42 = -84');
    assert(result.sign == true, '-42 - 42 -> negative');

    // Test subtraction of a positive integer and a negative integer with different magnitudes
    let a = i129 { inner: 100_u128, sign: false };
    let b = i129 { inner: 42_u128, sign: true };
    let result = a - b;
    assert(result.inner == 142_u128, '100 - - 42 = 142');
    assert(result.sign == false, '100 - - 42 -> postive');

    // Test subtraction of a negative integer and a positive integer with different magnitudes
    let a = i129 { inner: 42_u128, sign: true };
    let b = i129 { inner: 100_u128, sign: false };
    let result = a - b;
    assert(result.inner == 142_u128, '-42 - 100 = -142');
    assert(result.sign == true, '-42 - 100 -> negative');

    // Test subtraction resulting in zero
    let a = i129 { inner: 42_u128, sign: false };
    let b = i129 { inner: 42_u128, sign: false };
    let result = a - b;
    assert(result.inner == 0_u128, '42 - 42 = 0');
    assert(result.sign == false, '42 - 42 -> positive');
}


#[test]
fn i129_test_mul() {
    // Test multiplication of positive integers
    let a = i129 { inner: 10_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: false };
    let result = a * b;
    assert(result.inner == 50_u128, '10 * 5 = 50');
    assert(result.sign == false, '10 * 5 -> positive');

    // Test multiplication of negative integers
    let a = i129 { inner: 10_u128, sign: true };
    let b = i129 { inner: 5_u128, sign: true };
    let result = a * b;
    assert(result.inner == 50_u128, '-10 * -5 = 50');
    assert(result.sign == false, '-10 * -5 -> positive');

    // Test multiplication of positive and negative integers
    let a = i129 { inner: 10_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: true };
    let result = a * b;
    assert(result.inner == 50_u128, '10 * -5 = -50');
    assert(result.sign == true, '10 * -5 -> negative');

    // Test multiplication by zero
    let a = i129 { inner: 10_u128, sign: false };
    let b = i129 { inner: 0_u128, sign: false };
    let expected = i129 { inner: 0_u128, sign: false };
    let result = a * b;
    assert(result.inner == 0_u128, '10 * 0 = 0');
    assert(result.sign == false, '10 * 0 -> positive');
}

#[test]
fn i129_test_div_no_rem() {
    // Test division of positive integers
    let a = i129 { inner: 10_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: false };
    let result = a / b;
    assert(result.inner == 2_u128, '10 // 5 = 2');
    assert(result.sign == false, '10 // 5 -> positive');

    // Test division of negative integers
    let a = i129 { inner: 10_u128, sign: true };
    let b = i129 { inner: 5_u128, sign: true };
    let result = a / b;
    assert(result.inner == 2_u128, '-10 // -5 = 2');
    assert(result.sign == false, '-10 // -5 -> positive');

    // Test division of positive and negative integers
    let a = i129 { inner: 10_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: true };
    let result = a / b;
    assert(result.inner == 2_u128, '10 // -5 = -2');
    assert(result.sign == true, '10 // -5 -> negative');

    // Test division with a = zero
    let a = i129 { inner: 0_u128, sign: false };
    let b = i129 { inner: 10_u128, sign: false };
    let result = a / b;
    assert(result.inner == 0_u128, '0 // 10 = 0');
    assert(result.sign == false, '0 // 10 -> positive');

    // Test division with a = zero
    let a = i129 { inner: 0_u128, sign: false };
    let b = i129 { inner: 10_u128, sign: false };
    let result = a / b;
    assert(result.inner == 0_u128, '0 // 10 = 0');
    assert(result.sign == false, '0 // 10 -> positive');
}

#[test]
fn i129_test_div_rem() {
    // Test division and remainder of positive integers
    let a = i129 { inner: 13_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: false };
    let (q, r) = i129_div_rem(a, b);
    assert(q.inner == 2_u128 & r.inner == 3_u128, '13 // 5 = 2 r 3');
    assert(q.sign == false & r.sign == false, '13 // 5 -> positive');

    // Test division and remainder of negative integers
    let a = i129 { inner: 13_u128, sign: true };
    let b = i129 { inner: 5_u128, sign: true };
    let (q, r) = i129_div_rem(a, b);
    assert(q.inner == 2_u128 & r.inner == 3_u128, '-13 // -5 = 2 r -3');
    assert(q.sign == false & r.sign == true, '-13 // -5 -> positive');

    // Test division and remainder of positive and negative integers
    let a = i129 { inner: 13_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: true };
    let (q, r) = i129_div_rem(a, b);
    assert(q.inner == 3_u128 & r.inner == 2_u128, '13 // -5 = -3 r -2');
    assert(q.sign == true & r.sign == true, '13 // -5 -> negative');

    // Test division with a = zero
    let a = i129 { inner: 0_u128, sign: false };
    let b = i129 { inner: 10_u128, sign: false };
    let (q, r) = i129_div_rem(a, b);
    assert(q.inner == 0_u128 & r.inner == 0_u128, '0 // 10 = 0 r 0');
    assert(q.sign == false & r.sign == false, '0 // 10 -> positive');

    // Test division and remainder with a negative dividend and positive divisor
    let a = i129 { inner: 13_u128, sign: true };
    let b = i129 { inner: 5_u128, sign: false };
    let (q, r) = i129_div_rem(a, b);
    assert(q.inner == 3_u128 & r.inner == 2_u128, '-13 // 5 = -3 r 2');
    assert(q.sign == true & r.sign == false, '-13 // 5 -> negative');
}

#[test]
fn i129_test_partial_ord() {
    // Test two postive integers
    let a = i129 { inner: 13_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: false };
    assert(a > b, '13 > 5');
    assert(a >= b, '13 >= 5');
    assert(b < a, '5 < 13');
    assert(b <= a, '5 <= 13');

    // Test `a` postive and `b` negative
    let a = i129 { inner: 13_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: true };
    assert(a > b, '13 > -5');
    assert(a >= b, '13 >= -5');
    assert(b < a, '-5 < 13');
    assert(b <= a, '-5 <= 13');

    // Test `a` negative and `b` postive
    let a = i129 { inner: 13_u128, sign: true };
    let b = i129 { inner: 5_u128, sign: false };
    assert(b > a, '5 > -13');
    assert(b >= a, '5 >= -13');
    assert(a < b, '-13 < 5');
    assert(a <= b, '5 <= -13');

    // Test `a` negative and `b` negative
    let a = i129 { inner: 13_u128, sign: true };
    let b = i129 { inner: 5_u128, sign: true };
    assert(b > a, '-5 > -13');
    assert(b >= a, '-13 >= -5');
    assert(a < b, '-13 < -5');
    assert(a <= b, '-13 <= -5');
}

#[test]
fn i129_test_eq_not_eq() {
    // Test two postive integers
    let a = i129 { inner: 13_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: false };
    assert(a != b, '13 != 5');

    // Test `a` postive and `b` negative
    let a = i129 { inner: 13_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: true };
    assert(a != b, '13 != -5');

    // Test `a` negative and `b` postive
    let a = i129 { inner: 13_u128, sign: true };
    let b = i129 { inner: 5_u128, sign: false };
    assert(a != b, '-13 != 5');

    // Test `a` negative and `b` negative
    let a = i129 { inner: 13_u128, sign: true };
    let b = i129 { inner: 5_u128, sign: true };
    assert(a != b, '-13 != -5');
}

#[test]
fn i129_test_equality() {
    // Test equal with two positive integers
    let a = i129 { inner: 13_u128, sign: false };
    let b = i129 { inner: 13_u128, sign: false };
    assert(a == b, '13 == 13');

    // Test equal with two negative integers
    let a = i129 { inner: 13_u128, sign: true };
    let b = i129 { inner: 13_u128, sign: true };
    assert(a == b, '-13 == -13');

    // Test not equal with two postive integers
    let a = i129 { inner: 13_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: false };
    assert(a != b, '13 != 5');

    // Test not equal with `a` postive and `b` negative
    let a = i129 { inner: 13_u128, sign: false };
    let b = i129 { inner: 5_u128, sign: true };
    assert(a != b, '13 != -5');

    // Test not equal with `a` negative and `b` postive
    let a = i129 { inner: 13_u128, sign: true };
    let b = i129 { inner: 5_u128, sign: false };
    assert(a != b, '-13 != 5');

    // Test not equal with `a` negative and `b` negative
    let a = i129 { inner: 13_u128, sign: true };
    let b = i129 { inner: 5_u128, sign: true };
    assert(a != b, '-13 != -5');
}

#[test]
#[should_panic]
fn i129_test_check_sign_zero() {
    let x = i129 { inner: 0_u128, sign: true };
    signed_integers::i129_check_sign_zero(x);
}
