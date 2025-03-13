use alexandria_math::extended_euclidean_algorithm::extended_euclidean_algorithm;
use core::num::traits::WrappingSub;

// Define a test case function to avoid code duplication.
fn test_case(a: u128, b: u128, expected: (u128, u128, u128)) {
    let (gcd, x, y) = extended_euclidean_algorithm(a, b);
    let (expected_gcd, expected_x, expected_y) = expected;
    assert_eq!(gcd, expected_gcd);

    assert_eq!(x, expected_x);
    assert_eq!(y, expected_y);
}

#[test]
#[available_gas(2000000)]
fn extended_euclidean_algorithm_test() {
    test_case(101, 13, (1, 4, 0.wrapping_sub(31)));
    test_case(123, 19, (1, 0.wrapping_sub(2), 13));
    test_case(25, 36, (1, 13, 0.wrapping_sub(9)));
    test_case(69, 54, (3, 0.wrapping_sub(7), 9));
    test_case(55, 79, (1, 23, 0.wrapping_sub(16)));
    test_case(33, 44, (11, 0.wrapping_sub(1), 1));
    test_case(50, 70, (10, 3, 0.wrapping_sub(2)));
}
