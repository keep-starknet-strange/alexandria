use alexandria_math::aliquot_sum::aliquot_sum;

#[test]
#[available_gas(200000)]
fn zero_test() {
    assert_eq!(aliquot_sum(0), 0);
}

#[test]
#[available_gas(200000)]
fn one_test() {
    assert_eq!(aliquot_sum(1), 0);
}

#[test]
#[available_gas(200000)]
fn two_test() {
    assert_eq!(aliquot_sum(2), 1);
}

#[test]
#[available_gas(200000)]
fn one_digit_number_test() {
    assert_eq!(aliquot_sum(6), 6);
}

#[test]
#[available_gas(2000000)]
fn two_digit_number_test() {
    assert_eq!(aliquot_sum(15), 9);
}

#[test]
#[available_gas(20000000)]
fn three_digit_number_test() {
    assert_eq!(aliquot_sum(343), 57);
}

#[test]
#[available_gas(2000000)]
fn two_digit_prime_number_test() {
    assert_eq!(aliquot_sum(17), 1);
}
