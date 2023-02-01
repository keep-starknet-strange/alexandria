use quaireaux::math::armstrong_number;

#[test]
#[available_gas(200000)]
fn armstrong_number_test() {
    assert(armstrong_number::is_armstrong_number(0) == bool::True(()), 'invalid result');
    assert(armstrong_number::is_armstrong_number(9) == bool::True(()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn big_armstrong_number_test() {
    assert(armstrong_number::is_armstrong_number(153) == bool::True(()), 'invalid result');
}

#[test]
#[available_gas(200000)]
fn no_armstrong_number_test() {
    assert(armstrong_number::is_armstrong_number(25) == bool::False(()), 'invalid result');
}