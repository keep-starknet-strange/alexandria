use alexandria::math::aliquot_sum::aliquot_sum;

#[test]
#[available_gas(200000)]
fn zero_test() {
    assert(aliquot_sum(0) == 0, 'invalid result');
}

#[test]
#[available_gas(200000)]
fn one_test() {
    assert(aliquot_sum(1) == 0, 'invalid result');
}
#[test]
#[available_gas(200000)]
fn one_digit_number_test() {
    assert(aliquot_sum(6) == 6, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn two_digit_number_test() {
    assert(aliquot_sum(15) == 9, 'invalid result');
}

#[test]
#[available_gas(20000000)]
fn three_digit_number_test() {
    assert(aliquot_sum(343) == 57, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn two_digit_prime_number_test() {
    assert(aliquot_sum(17) == 1, 'invalid result');
}
