//! # Fast power algorithm

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;
// Internal imports.
use quaireaux::utils;

// Calculate the (base^power)mod modulus using the fast powering algorithm
// # Arguments
// * `base` - The base of the exponentiation
// * `power` - The power of the exponentiation
// * `modulus` - The modulus used in the calculation
// # Returns
// * `felt` - The result of (base^power)mod modulus
fn fast_power(base: felt, power: felt, modulus: felt) -> felt {
    // Return invalid input error
    if base < 1 {
        let mut data = array_new::<felt>();
        array_append::<felt>(ref data, 'II');
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
// * `felt` - The result of (base^power)mod modulus
fn _fast_power(base: felt, power: felt, modulus: felt, result: felt) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = array_new::<felt>();
            array_append::<felt>(ref data, 'OOG');
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
