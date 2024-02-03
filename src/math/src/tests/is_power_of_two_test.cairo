use alexandria_math::is_power_of_two::is_power_of_two;

#[test]
#[available_gas(200000)]
fn is_power_of_two_test_1() {
    assert!(is_power_of_two(1) == true, "invalid result");
}

#[test]
#[available_gas(200000)]
fn is_power_of_two_test_2() {
    assert!(is_power_of_two(2) == true, "invalid result");
}

#[test]
#[available_gas(200000)]
fn is_power_of_two_test_3() {
    assert!(is_power_of_two(3) == false, "invalid result");
}

#[test]
#[available_gas(200000)]
fn is_power_of_two_test_4() {
    assert!(is_power_of_two(128) == true, "invalid result");
}

#[test]
#[available_gas(200000)]
fn is_power_of_two_test_5() {
    assert!(is_power_of_two(0) == false, "invalid result");
}
