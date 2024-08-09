use alexandria_math::is_prime::is_prime;

#[test]
#[available_gas(200000)]
fn is_prime_test_1() {
    assert!(is_prime(2, 10));
}

#[test]
#[available_gas(200000)]
fn is_prime_test_2() {
    assert!(!is_prime(0, 10));
}

#[test]
#[available_gas(200000)]
fn is_prime_test_3() {
    assert!(!is_prime(1, 10));
}

#[test]
#[available_gas(2000000)]
fn is_prime_test_4() {
    assert!(is_prime(97, 10));
}
