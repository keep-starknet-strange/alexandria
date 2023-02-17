// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;

use quaireaux::math::collatz_sequence;

#[test]
#[available_gas(2000000)]
fn collatz_sequence_10_test() {
    let mut number = 10;
    let mut res = collatz_sequence::sequence(ref number);
    assert(res.len() == 7_usize, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn collatz_sequence_15_test() {
    let mut number = 15;
    let mut res = collatz_sequence::sequence(ref number);
    assert(res.len() == 18_usize, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn collatz_sequence_empty_test() {
    let mut number = 0;
    let mut res = collatz_sequence::sequence(ref number);
    assert(res.len() == 0_usize, 'invalid result');
}
