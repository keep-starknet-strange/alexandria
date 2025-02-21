use alexandria_math::i257::{i257, I257Impl, i257_div_rem, i257_assert_no_negative_zero};
use core::num::traits::Zero;

#[test]
fn i257_test_add() {
    // Test addition of two positive integers
    let a = I257Impl::new(42, false);
    let b = I257Impl::new(13, false);
    let result = a + b;
    assert_eq!(result.abs(), 55);
    assert!(!result.is_negative(), "42 + 13 -> positive");

    // Test addition of two negative integers
    let a = I257Impl::new(42, true);
    let b = I257Impl::new(13, true);
    let result = a + b;
    assert_eq!(result.abs(), 55);
    assert!(result.is_negative(), "-42 - 13 -> negative");

    // Test addition of a positive integer and a negative integer with the same magnitude
    let a = I257Impl::new(42, false);
    let b = I257Impl::new(42, true);
    let result = a + b;
    assert_eq!(result.abs(), 0);
    assert!(!result.is_negative(), "42 - 42 -> positive");

    // Test addition of a positive integer and a negative integer with different magnitudes
    let a = I257Impl::new(42, false);
    let b = I257Impl::new(13, true);
    let result = a + b;
    assert_eq!(result.abs(), 29);
    assert!(!result.is_negative(), "42 - 13 -> positive");

    // Test addition of a negative integer and a positive integer with different magnitudes
    let a = I257Impl::new(42, true);
    let b = I257Impl::new(13, false);
    let result = a + b;
    assert_eq!(result.abs(), 29);
    assert!(result.is_negative(), "-42 + 13 -> negative");
}

#[test]
fn i257_test_sub() {
    // Test subtraction of two positive integers with larger first
    let a = I257Impl::new(42, false);
    let b = I257Impl::new(13, false);
    let result = a - b;
    assert_eq!(result.abs(), 29);
    assert!(!result.is_negative(), "42 - 13 -> positive");

    // Test subtraction of two positive integers with larger second
    let a = I257Impl::new(13, false);
    let b = I257Impl::new(42, false);
    let result = a - b;
    assert_eq!(result.abs(), 29);
    assert!(result.is_negative(), "13 - 42 -> negative");

    // Test subtraction of two negative integers with larger first
    let a = I257Impl::new(42, true);
    let b = I257Impl::new(13, true);
    let result = a - b;
    assert_eq!(result.abs(), 29);
    assert!(result.is_negative(), "-42 - -13 -> negative");

    // Test subtraction of two negative integers with larger second
    let a = I257Impl::new(13, true);
    let b = I257Impl::new(42, true);
    let result = a - b;
    assert_eq!(result.abs(), 29);
    assert!(!result.is_negative(), "-13 - -42 -> positive");

    // Test subtraction of a positive integer and a negative integer with the same magnitude
    let a = I257Impl::new(42, false);
    let b = I257Impl::new(42, true);
    let result = a - b;
    assert_eq!(result.abs(), 84);
    assert!(!result.is_negative(), "42 - -42 -> postive");

    // Test subtraction of a negative integer and a positive integer with the same magnitude
    let a = I257Impl::new(42, true);
    let b = I257Impl::new(42, false);
    let result = a - b;
    assert_eq!(result.abs(), 84);
    assert!(result.is_negative(), "-42 - 42 -> negative");

    // Test subtraction of a positive integer and a negative integer with different magnitudes
    let a = I257Impl::new(100, false);
    let b = I257Impl::new(42, true);
    let result = a - b;
    assert_eq!(result.abs(), 142);
    assert!(!result.is_negative(), "100 - - 42 -> postive");

    // Test subtraction of a negative integer and a positive integer with different magnitudes
    let a = I257Impl::new(42, true);
    let b = I257Impl::new(100, false);
    let result = a - b;
    assert_eq!(result.abs(), 142);
    assert!(result.is_negative(), "-42 - 100 -> negative");

    // Test subtraction resulting in zero
    let a = I257Impl::new(42, false);
    let b = I257Impl::new(42, false);
    let result = a - b;
    assert_eq!(result.abs(), 0);
    assert!(!result.is_negative(), "42 - 42 -> positive");
}


#[test]
fn i257_test_mul() {
    // Test multiplication of positive integers
    let a = I257Impl::new(10, false);
    let b = I257Impl::new(5, false);
    let result = a * b;
    assert_eq!(result.abs(), 50);
    assert!(!result.is_negative(), "10 * 5 -> positive");

    // Test multiplication of negative integers
    let a = I257Impl::new(10, true);
    let b = I257Impl::new(5, true);
    let result = a * b;
    assert_eq!(result.abs(), 50);
    assert!(!result.is_negative(), "-10 * -5 -> positive");

    // Test multiplication of positive and negative integers
    let a = I257Impl::new(10, false);
    let b = I257Impl::new(5, true);
    let result = a * b;
    assert_eq!(result.abs(), 50);
    assert!(result.is_negative(), "10 * -5 -> negative");

    // Test multiplication by zero
    let a = I257Impl::new(10, false);
    let b = I257Impl::new(0, false);
    let result = a * b;
    assert_eq!(result.abs(), 0);
    assert!(!result.is_negative(), "10 * 0 -> positive");
}

#[test]
fn i257_test_is_zero() {
    let a = I257Impl::new(0, false);
    assert!(a.is_zero(), "should be true");
}

#[test]
fn i257_test_div_no_rem() {
    // Test division of positive integers
    let a = I257Impl::new(10, false);
    let b = I257Impl::new(5, false);
    let result = a / b;
    assert_eq!(result.abs(), 2);
    assert!(!result.is_negative(), "10 // 5 -> positive");

    // Test division of negative integers
    let a = I257Impl::new(10, true);
    let b = I257Impl::new(5, true);
    let result = a / b;
    assert_eq!(result.abs(), 2);
    assert!(!result.is_negative(), "-10 // -5 -> positive");

    // Test division of positive and negative integers
    let a = I257Impl::new(10, false);
    let b = I257Impl::new(5, true);
    let result = a / b;
    assert_eq!(result.abs(), 2);
    assert!(result.is_negative(), "10 // -5 -> negative");

    // Test division with a = zero
    let a = I257Impl::new(0, false);
    let b = I257Impl::new(10, false);
    let result = a / b;
    assert_eq!(result.abs(), 0);
    assert!(!result.is_negative(), "0 // 10 -> positive");

    // Test division with a = zero
    let a = I257Impl::new(0, false);
    let b = I257Impl::new(10, false);
    let result = a / b;
    assert_eq!(result.abs(), 0);
    assert!(!result.is_negative(), "0 // 10 -> positive");
}

#[test]
fn i257_test_div_rem() {
    // Test division and remainder of positive integers
    let a = I257Impl::new(13, false);
    let b = I257Impl::new(5, false);
    let (q, r) = i257_div_rem(a, b);
    assert!(q.abs() == 2 && r.abs() == 3, "13 // 5 = 2 r 3");
    assert!(!q.is_negative() && !r.is_negative(), "13 // 5 -> positive");

    // Test division and remainder of negative integers
    let a = I257Impl::new(13, true);
    let b = I257Impl::new(5, true);
    let (q, r) = i257_div_rem(a, b);
    assert!(q.abs() == 2 && r.abs() == 3, "-13 // -5 = 2 r -3");
    assert!(!q.is_negative() && r.is_negative(), "-13 // -5 -> positive");

    // Test division and remainder of positive and negative integers
    let a = I257Impl::new(13, false);
    let b = I257Impl::new(5, true);
    let (q, r) = i257_div_rem(a, b);
    assert!(q.abs() == 3 && r.abs() == 2, "13 // -5 = -3 r -2");
    assert!(q.is_negative() && r.is_negative(), "13 // -5 -> negative");

    // Test division with a = zero
    let a = I257Impl::new(0, false);
    let b = I257Impl::new(10, false);
    let (q, r) = i257_div_rem(a, b);
    assert!(q.abs() == 0 && r.abs() == 0, "0 // 10 = 0 r 0");
    assert!(!q.is_negative() && !r.is_negative(), "0 // 10 -> positive");

    // Test division and remainder with a negative dividend and positive divisor
    let a = I257Impl::new(13, true);
    let b = I257Impl::new(5, false);
    let (q, r) = i257_div_rem(a, b);
    assert!(q.abs() == 3 && r.abs() == 2, "-13 // 5 = -3 r 2");
    assert!(q.is_negative() && !r.is_negative(), "-13 // 5 -> negative");
}

#[test]
fn i257_test_partial_ord() {
    // Test two postive integers
    let a = I257Impl::new(13, false);
    let b = I257Impl::new(5, false);
    assert!(a > b, "13 > 5");
    assert!(a >= b, "13 >= 5");
    assert!(b < a, "5 < 13");
    assert!(b <= a, "5 <= 13");

    // Test `a` postive and `b` negative
    let a = I257Impl::new(13, false);
    let b = I257Impl::new(5, true);
    assert!(a > b, "13 > -5");
    assert!(a >= b, "13 >= -5");
    assert!(b < a, "-5 < 13");
    assert!(b <= a, "-5 <= 13");

    // Test `a` negative and `b` postive
    let a = I257Impl::new(13, true);
    let b = I257Impl::new(5, false);
    assert!(b > a, "5 > -13");
    assert!(b >= a, "5 >= -13");
    assert!(a < b, "-13 < 5");
    assert!(a <= b, "5 <= -13");

    // Test `a` negative and `b` negative
    let a = I257Impl::new(13, true);
    let b = I257Impl::new(5, true);
    assert!(b > a, "-5 > -13");
    assert!(b >= a, "-13 >= -5");
    assert!(a < b, "-13 < -5");
    assert!(a <= b, "-13 <= -5");
}

#[test]
fn i257_test_eq_not_eq() {
    // Test two postive integers
    let a = I257Impl::new(13, false);
    let b = I257Impl::new(5, false);
    assert!(a != b, "13 != 5");

    // Test `a` postive and `b` negative
    let a = I257Impl::new(13, false);
    let b = I257Impl::new(5, true);
    assert!(a != b, "13 != -5");

    // Test `a` negative and `b` postive
    let a = I257Impl::new(13, true);
    let b = I257Impl::new(5, false);
    assert!(a != b, "-13 != 5");

    // Test `a` negative and `b` negative
    let a = I257Impl::new(13, true);
    let b = I257Impl::new(5, true);
    assert!(a != b, "-13 != -5");
}

#[test]
fn i257_test_equality() {
    // Test equal with two positive integers
    let a = I257Impl::new(13, false);
    let b = I257Impl::new(13, false);
    assert!(a == b, "13 == 13");

    // Test equal with two negative integers
    let a = I257Impl::new(13, true);
    let b = I257Impl::new(13, true);
    assert!(a == b, "-13 == -13");

    // Test not equal with two postive integers
    let a = I257Impl::new(13, false);
    let b = I257Impl::new(5, false);
    assert!(a != b, "13 != 5");

    // Test not equal with `a` postive and `b` negative
    let a = I257Impl::new(13, false);
    let b = I257Impl::new(5, true);
    assert!(a != b, "13 != -5");

    // Test not equal with `a` negative and `b` postive
    let a = I257Impl::new(13, true);
    let b = I257Impl::new(5, false);
    assert!(a != b, "-13 != 5");

    // Test not equal with `a` negative and `b` negative
    let a = I257Impl::new(13, true);
    let b = I257Impl::new(5, true);
    assert!(a != b, "-13 != -5");
}

#[test]
fn i257_test_div_sign_zero() {
    let x = I257Impl::new(0, false) / I257Impl::new(3, true);
    assert_eq!(x.abs(), 0);
    assert!(!x.is_negative(), "incorrect sign");
}

#[test]
fn i257_test_into() {
    let x: i257 = 35.into();
    assert_eq!(x.abs(), 35);
    assert!(!x.is_negative(), "incorrect into sign");

    let y: i257 = 258973.into();
    assert_eq!(y.abs(), 258973);
    assert!(!y.is_negative(), "incorrect into sign");
}
