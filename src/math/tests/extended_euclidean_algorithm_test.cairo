use alexandria::math::extended_euclidean_algorithm::{
    extended_euclidean_algorithm, u128_wrapping_sub
};

// Define a test case function to avoid code duplication.
fn test_case(a: u128, b: u128, expected: (u128, u128, u128)) {
    let (gcd, x, y) = extended_euclidean_algorithm(a, b);
    let (expected_gcd, expected_x, expected_y) = expected;
    assert(gcd == expected_gcd, 'gcd is incorrect');

    assert(x == expected_x, 'x is incorrect');
    assert(y == expected_y, 'y is incorrect');
}

#[test]
#[available_gas(2000000)]
fn extended_euclidean_algorithm_test() {
    // TODO This needs to be update
    test_case(101, 13, (1, 4, u128_wrapping_sub(0, 31)));
    test_case(123, 19, (1, u128_wrapping_sub(0, 2), 13));
    test_case(25, 36, (1, 13, u128_wrapping_sub(0, 9)));
    test_case(69, 54, (3, u128_wrapping_sub(0, 7), 9));
    test_case(55, 79, (1, 23, u128_wrapping_sub(0, 16)));
    test_case(33, 44, (11, u128_wrapping_sub(0, 1), 1));
    test_case(50, 70, (10, 3, u128_wrapping_sub(0, 2)));
}

