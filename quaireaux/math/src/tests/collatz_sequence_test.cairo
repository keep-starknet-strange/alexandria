// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;

use quaireaux_math::collatz_sequence;

#[test]
#[available_gas(2000000)]
fn collatz_sequence_10_test() {
    let mut res = collatz_sequence::sequence(10);
    assert(res.len() == 7, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn collatz_sequence_15_test() {
    let mut res = collatz_sequence::sequence(15);
    assert(res.len() == 18, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn collatz_sequence_empty_test() {
    let mut res = collatz_sequence::sequence(0);
    assert(res.len() == 0, 'invalid result');
}
