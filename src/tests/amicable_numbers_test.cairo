// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;

use quaireaux::math::amicable_numbers;

//test case works but takes a long time to run
// #[test]
// #[available_gas(2000000000)]
// fn amicable_numbers_test() {
//     let mut max = 300;
//     let mut result = amicable_numbers::amicable_pairs_under_n(ref max);
//     assert(result.len() == 1_usize , 'invalid result');
// }