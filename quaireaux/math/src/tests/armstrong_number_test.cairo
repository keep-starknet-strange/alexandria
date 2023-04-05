use quaireaux_math::armstrong_number;

#[test]
#[available_gas(200000)]
fn one_digit_armstrong_number_test() {
    assert(armstrong_number::is_armstrong_number(1) == bool::True(()), 'invalid result');
}

#[test]
#[available_gas(200000)]
fn two_digit_numbers_are_not_armstrong_numbers_test() {
    assert(armstrong_number::is_armstrong_number(15) == bool::False(()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn three_digit_armstrong_number_test() {
    assert(armstrong_number::is_armstrong_number(153) == bool::True(()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn three_digit_non_armstrong_number_test() {
    assert(armstrong_number::is_armstrong_number(105) == bool::False(()), 'invalid result');
}
