use alexandria_math::i257::{i257, i257_div_rem, i257_assert_no_negative_zero};

#[test]
fn i257_test_add() {
    // Test addition of two positive integers
    let a = i257 { abs: 42, is_negative: false };
    let b = i257 { abs: 13, is_negative: false };
    let result = a + b;
    assert_eq!(result.abs, 55, "42 + 13 = 55");
    assert!(!result.is_negative, "42 + 13 -> positive");

    // Test addition of two negative integers
    let a = i257 { abs: 42, is_negative: true };
    let b = i257 { abs: 13, is_negative: true };
    let result = a + b;
    assert_eq!(result.abs, 55, "-42 - 13 = -55");
    assert!(result.is_negative, "-42 - 13 -> negative");

    // Test addition of a positive integer and a negative integer with the same magnitude
    let a = i257 { abs: 42, is_negative: false };
    let b = i257 { abs: 42, is_negative: true };
    let result = a + b;
    assert_eq!(result.abs, 0, "42 - 42 = 0");
    assert!(!result.is_negative, "42 - 42 -> positive");

    // Test addition of a positive integer and a negative integer with different magnitudes
    let a = i257 { abs: 42, is_negative: false };
    let b = i257 { abs: 13, is_negative: true };
    let result = a + b;
    assert_eq!(result.abs, 29, "42 - 13 = 29");
    assert!(!result.is_negative, "42 - 13 -> positive");

    // Test addition of a negative integer and a positive integer with different magnitudes
    let a = i257 { abs: 42, is_negative: true };
    let b = i257 { abs: 13, is_negative: false };
    let result = a + b;
    assert_eq!(result.abs, 29, "-42 + 13 = -29");
    assert!(result.is_negative, "-42 + 13 -> negative");
}

#[test]
fn i257_test_sub() {
    // Test subtraction of two positive integers with larger first
    let a = i257 { abs: 42, is_negative: false };
    let b = i257 { abs: 13, is_negative: false };
    let result = a - b;
    assert_eq!(result.abs, 29, "42 - 13 = 29");
    assert!(!result.is_negative, "42 - 13 -> positive");

    // Test subtraction of two positive integers with larger second
    let a = i257 { abs: 13, is_negative: false };
    let b = i257 { abs: 42, is_negative: false };
    let result = a - b;
    assert_eq!(result.abs, 29, "13 - 42 = -29");
    assert!(result.is_negative, "13 - 42 -> negative");

    // Test subtraction of two negative integers with larger first
    let a = i257 { abs: 42, is_negative: true };
    let b = i257 { abs: 13, is_negative: true };
    let result = a - b;
    assert_eq!(result.abs, 29, "-42 - -13 = 29");
    assert!(result.is_negative, "-42 - -13 -> negative");

    // Test subtraction of two negative integers with larger second
    let a = i257 { abs: 13, is_negative: true };
    let b = i257 { abs: 42, is_negative: true };
    let result = a - b;
    assert_eq!(result.abs, 29, "-13 - -42 = 29");
    assert!(!result.is_negative, "-13 - -42 -> positive");

    // Test subtraction of a positive integer and a negative integer with the same magnitude
    let a = i257 { abs: 42, is_negative: false };
    let b = i257 { abs: 42, is_negative: true };
    let result = a - b;
    assert_eq!(result.abs, 84, "42 - -42 = 84");
    assert!(!result.is_negative, "42 - -42 -> postive");

    // Test subtraction of a negative integer and a positive integer with the same magnitude
    let a = i257 { abs: 42, is_negative: true };
    let b = i257 { abs: 42, is_negative: false };
    let result = a - b;
    assert_eq!(result.abs, 84, "-42 - 42 = -84");
    assert!(result.is_negative, "-42 - 42 -> negative");

    // Test subtraction of a positive integer and a negative integer with different magnitudes
    let a = i257 { abs: 100, is_negative: false };
    let b = i257 { abs: 42, is_negative: true };
    let result = a - b;
    assert_eq!(result.abs, 142, "100 - - 42 = 142");
    assert!(!result.is_negative, "100 - - 42 -> postive");

    // Test subtraction of a negative integer and a positive integer with different magnitudes
    let a = i257 { abs: 42, is_negative: true };
    let b = i257 { abs: 100, is_negative: false };
    let result = a - b;
    assert_eq!(result.abs, 142, "-42 - 100 = -142");
    assert!(result.is_negative, "-42 - 100 -> negative");

    // Test subtraction resulting in zero
    let a = i257 { abs: 42, is_negative: false };
    let b = i257 { abs: 42, is_negative: false };
    let result = a - b;
    assert_eq!(result.abs, 0, "42 - 42 = 0");
    assert!(!result.is_negative, "42 - 42 -> positive");
}


#[test]
fn i257_test_mul() {
    // Test multiplication of positive integers
    let a = i257 { abs: 10, is_negative: false };
    let b = i257 { abs: 5, is_negative: false };
    let result = a * b;
    assert_eq!(result.abs, 50, "10 * 5 = 50");
    assert!(!result.is_negative, "10 * 5 -> positive");

    // Test multiplication of negative integers
    let a = i257 { abs: 10, is_negative: true };
    let b = i257 { abs: 5, is_negative: true };
    let result = a * b;
    assert_eq!(result.abs, 50, "-10 * -5 = 50");
    assert!(!result.is_negative, "-10 * -5 -> positive");

    // Test multiplication of positive and negative integers
    let a = i257 { abs: 10, is_negative: false };
    let b = i257 { abs: 5, is_negative: true };
    let result = a * b;
    assert_eq!(result.abs, 50, "10 * -5 = -50");
    assert!(result.is_negative, "10 * -5 -> negative");

    // Test multiplication by zero
    let a = i257 { abs: 10, is_negative: false };
    let b = i257 { abs: 0, is_negative: false };
    let result = a * b;
    assert_eq!(result.abs, 0, "10 * 0 = 0");
    assert!(!result.is_negative, "10 * 0 -> positive");
}

#[test]
fn i257_test_is_zero() {
    let a = i257 { abs: 0, is_negative: false };
    assert!(a.is_zero(), "should be true");
}

#[test]
#[should_panic(expected: ('no negative zero',))]
fn i257_test_is_zero_panic() {
    let a = i257 { abs: 0, is_negative: true };
    let _x = a.is_zero();
}

#[test]
fn i257_test_div_no_rem() {
    // Test division of positive integers
    let a = i257 { abs: 10, is_negative: false };
    let b = i257 { abs: 5, is_negative: false };
    let result = a / b;
    assert_eq!(result.abs, 2, "10 // 5 = 2");
    assert!(!result.is_negative, "10 // 5 -> positive");

    // Test division of negative integers
    let a = i257 { abs: 10, is_negative: true };
    let b = i257 { abs: 5, is_negative: true };
    let result = a / b;
    assert_eq!(result.abs, 2, "-10 // -5 = 2");
    assert!(!result.is_negative, "-10 // -5 -> positive");

    // Test division of positive and negative integers
    let a = i257 { abs: 10, is_negative: false };
    let b = i257 { abs: 5, is_negative: true };
    let result = a / b;
    assert_eq!(result.abs, 2, "10 // -5 = -2");
    assert!(result.is_negative, "10 // -5 -> negative");

    // Test division with a = zero
    let a = i257 { abs: 0, is_negative: false };
    let b = i257 { abs: 10, is_negative: false };
    let result = a / b;
    assert_eq!(result.abs, 0, "0 // 10 = 0");
    assert!(!result.is_negative, "0 // 10 -> positive");

    // Test division with a = zero
    let a = i257 { abs: 0, is_negative: false };
    let b = i257 { abs: 10, is_negative: false };
    let result = a / b;
    assert_eq!(result.abs, 0, "0 // 10 = 0");
    assert!(!result.is_negative, "0 // 10 -> positive");
}

#[test]
fn i257_test_div_rem() {
    // Test division and remainder of positive integers
    let a = i257 { abs: 13, is_negative: false };
    let b = i257 { abs: 5, is_negative: false };
    let (q, r) = i257_div_rem(a, b);
    assert!(q.abs == 2 && r.abs == 3, "13 // 5 = 2 r 3");
    assert!(!q.is_negative && !r.is_negative, "13 // 5 -> positive");

    // Test division and remainder of negative integers
    let a = i257 { abs: 13, is_negative: true };
    let b = i257 { abs: 5, is_negative: true };
    let (q, r) = i257_div_rem(a, b);
    assert!(q.abs == 2 && r.abs == 3, "-13 // -5 = 2 r -3");
    assert!(!q.is_negative && r.is_negative, "-13 // -5 -> positive");

    // Test division and remainder of positive and negative integers
    let a = i257 { abs: 13, is_negative: false };
    let b = i257 { abs: 5, is_negative: true };
    let (q, r) = i257_div_rem(a, b);
    assert!(q.abs == 3 && r.abs == 2, "13 // -5 = -3 r -2");
    assert!(q.is_negative && r.is_negative, "13 // -5 -> negative");

    // Test division with a = zero
    let a = i257 { abs: 0, is_negative: false };
    let b = i257 { abs: 10, is_negative: false };
    let (q, r) = i257_div_rem(a, b);
    assert!(q.abs == 0 && r.abs == 0, "0 // 10 = 0 r 0");
    assert!(!q.is_negative && !r.is_negative, "0 // 10 -> positive");

    // Test division and remainder with a negative dividend and positive divisor
    let a = i257 { abs: 13, is_negative: true };
    let b = i257 { abs: 5, is_negative: false };
    let (q, r) = i257_div_rem(a, b);
    assert!(q.abs == 3 && r.abs == 2, "-13 // 5 = -3 r 2");
    assert!(q.is_negative && !r.is_negative, "-13 // 5 -> negative");
}

#[test]
fn i257_test_partial_ord() {
    // Test two postive integers
    let a = i257 { abs: 13, is_negative: false };
    let b = i257 { abs: 5, is_negative: false };
    assert!(a > b, "13 > 5");
    assert!(a >= b, "13 >= 5");
    assert!(b < a, "5 < 13");
    assert!(b <= a, "5 <= 13");

    // Test `a` postive and `b` negative
    let a = i257 { abs: 13, is_negative: false };
    let b = i257 { abs: 5, is_negative: true };
    assert!(a > b, "13 > -5");
    assert!(a >= b, "13 >= -5");
    assert!(b < a, "-5 < 13");
    assert!(b <= a, "-5 <= 13");

    // Test `a` negative and `b` postive
    let a = i257 { abs: 13, is_negative: true };
    let b = i257 { abs: 5, is_negative: false };
    assert!(b > a, "5 > -13");
    assert!(b >= a, "5 >= -13");
    assert!(a < b, "-13 < 5");
    assert!(a <= b, "5 <= -13");

    // Test `a` negative and `b` negative
    let a = i257 { abs: 13, is_negative: true };
    let b = i257 { abs: 5, is_negative: true };
    assert!(b > a, "-5 > -13");
    assert!(b >= a, "-13 >= -5");
    assert!(a < b, "-13 < -5");
    assert!(a <= b, "-13 <= -5");
}

#[test]
fn i257_test_eq_not_eq() {
    // Test two postive integers
    let a = i257 { abs: 13, is_negative: false };
    let b = i257 { abs: 5, is_negative: false };
    assert!(a != b, "13 != 5");

    // Test `a` postive and `b` negative
    let a = i257 { abs: 13, is_negative: false };
    let b = i257 { abs: 5, is_negative: true };
    assert!(a != b, "13 != -5");

    // Test `a` negative and `b` postive
    let a = i257 { abs: 13, is_negative: true };
    let b = i257 { abs: 5, is_negative: false };
    assert!(a != b, "-13 != 5");

    // Test `a` negative and `b` negative
    let a = i257 { abs: 13, is_negative: true };
    let b = i257 { abs: 5, is_negative: true };
    assert!(a != b, "-13 != -5");
}

#[test]
fn i257_test_equality() {
    // Test equal with two positive integers
    let a = i257 { abs: 13, is_negative: false };
    let b = i257 { abs: 13, is_negative: false };
    assert!(a == b, "13 == 13");

    // Test equal with two negative integers
    let a = i257 { abs: 13, is_negative: true };
    let b = i257 { abs: 13, is_negative: true };
    assert!(a == b, "-13 == -13");

    // Test not equal with two postive integers
    let a = i257 { abs: 13, is_negative: false };
    let b = i257 { abs: 5, is_negative: false };
    assert!(a != b, "13 != 5");

    // Test not equal with `a` postive and `b` negative
    let a = i257 { abs: 13, is_negative: false };
    let b = i257 { abs: 5, is_negative: true };
    assert!(a != b, "13 != -5");

    // Test not equal with `a` negative and `b` postive
    let a = i257 { abs: 13, is_negative: true };
    let b = i257 { abs: 5, is_negative: false };
    assert!(a != b, "-13 != 5");

    // Test not equal with `a` negative and `b` negative
    let a = i257 { abs: 13, is_negative: true };
    let b = i257 { abs: 5, is_negative: true };
    assert!(a != b, "-13 != -5");
}

#[test]
#[should_panic]
fn i257_test_check_sign_zero() {
    let x = i257 { abs: 0, is_negative: true };
    i257_assert_no_negative_zero(x);
}

#[test]
fn i257_test_div_sign_zero() {
    let x = i257 { abs: 0, is_negative: false } / i257 { abs: 3, is_negative: true };
    assert_eq!(x.abs, 0, "incorrect abs");
    assert!(!x.is_negative, "incorrect sign");
}

#[test]
fn i257_test_into() {
    let x: i257 = 35.into();
    assert_eq!(x.abs, 35, "incorrect into value");
    assert!(!x.is_negative, "incorrect into sign");

    let y: i257 = 258973.into();
    assert_eq!(y.abs, 258973, "incorrect into value");
    assert!(!y.is_negative, "incorrect into sign");
}
