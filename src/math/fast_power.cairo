//! # Fast power algorithm

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;
use core::traits::Into;

// Internal imports.
use quaireaux::utils;

// Calculate the (base^power)mod modulus using the fast powering algorithm
// # Arguments
// * `base` - The base of the exponentiation
// * `power` - The power of the exponentiation
// * `modulus` - The modulus used in the calculation
// # Returns
// * `felt252` - The result of (base^power)mod modulus
fn fast_power(base: felt252, power: felt252, modulus: felt252) -> felt252 {
    // Return invalid input error
    if base.into() < utils::as_u256(1_u128, 0_u128) {
        let mut data = array_new::<felt252>();
        array_append::<felt252>(ref data, 'II');
        panic(data);
    }
    _fast_power(base, power, modulus, 1)
}

// Internal function for recursive loop
// # Arguments
// * `base` - The base of the exponentiation
// * `power` - The power of the exponentiation
// * `modulus` - The modulus used in the calculation
// * `result` - The result of the exponentiation
// # Returns
// * `felt252` - The result of (base^power)mod modulus
fn _fast_power(base: felt252, power: felt252, modulus: felt252, result: felt252) -> felt252 {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = array_new::<felt252>();
            array_append::<felt252>(ref data, 'OOG');
            panic(data);
        },
    }
    match power {
        0 => result,
        _ => {
            let (q, r) = utils::unsafe_euclidean_div(power, 2);
            let (_, b) = utils::unsafe_euclidean_div(base * base, modulus);
            match r {
                0 => {
                    _fast_power(b, q, modulus, result)
                },
                _ => {
                    let (_, r) = utils::unsafe_euclidean_div(result * base, modulus);
                    _fast_power(b, q, modulus, r)
                }
            }
        }
    }
}
