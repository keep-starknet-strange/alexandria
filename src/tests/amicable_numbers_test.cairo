// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;

use quaireaux::math::amicable_numbers;

#[test]
#[available_gas(2000000000)]
fn amicable_numbers_test() {
    let mut result = amicable_numbers::amicable_pairs_under_n(220);
    assert(result.len() == 1_usize , 'invalid result');
}