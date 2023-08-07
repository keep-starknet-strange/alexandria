use alexandria::math::armstrong_number::is_armstrong_number;

#[test]
#[available_gas(200000)]
fn one_digit_armstrong_number_test() {
    assert(is_armstrong_number(1), 'invalid result');
}

#[test]
#[available_gas(200000)]
fn two_digit_numbers_are_not_armstrong_numbers_test() {
    assert(!is_armstrong_number(15), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn three_digit_armstrong_number_test() {
    assert(is_armstrong_number(153), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn three_digit_non_armstrong_number_test() {
    assert(!is_armstrong_number(105), 'invalid result');
}
