use alexandria_math::is_power_of_two::is_power_of_two;

#[test]
#[available_gas(200000)]
fn is_power_of_two_test_1() {
    assert!(is_power_of_two(1), "invalid result");
}

#[test]
#[available_gas(200000)]
fn is_power_of_two_test_2() {
    assert!(is_power_of_two(2), "invalid result");
}

#[test]
#[available_gas(200000)]
fn is_power_of_two_test_3() {
    assert!(!is_power_of_two(3), "invalid result");
}

#[test]
#[available_gas(200000)]
fn is_power_of_two_test_4() {
    assert!(is_power_of_two(128), "invalid result");
}

#[test]
#[available_gas(200000)]
fn is_power_of_two_test_5() {
    assert_eq!(is_power_of_two(0), false);
}
