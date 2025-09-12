use alexandria_math::aliquot_sum::aliquot_sum;

#[test]
fn zero_test() {
    assert!(aliquot_sum(0) == 0);
}

#[test]
fn one_test() {
    assert!(aliquot_sum(1) == 0);
}

#[test]
fn two_test() {
    assert!(aliquot_sum(2) == 1);
}

#[test]
fn one_digit_number_test() {
    assert!(aliquot_sum(6) == 6);
}

#[test]
fn two_digit_number_test() {
    assert!(aliquot_sum(15) == 9);
}

#[test]
fn three_digit_number_test() {
    assert!(aliquot_sum(343) == 57);
}

#[test]
fn two_digit_prime_number_test() {
    assert!(aliquot_sum(17) == 1);
}
