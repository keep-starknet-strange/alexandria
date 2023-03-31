//! # Fast power algorithm

// Core library imports.
use array::ArrayTrait;
use option::OptionTrait;
use utils::utils::check_gas;
use math::unsafe_euclidean_div;

// Calculate the (base^power)mod modulus using the fast powering algorithm
// # Arguments
// * `base` - The base of the exponentiation
// * `power` - The power of the exponentiation
// * `modulus` - The modulus used in the calculation
// # Returns
// * `felt252` - The result of (base^power)mod modulus
fn fast_power(base: felt252, power: felt252, modulus: felt252) -> felt252 {
    // Return invalid input error
    if base == 0 {
        let mut data = ArrayTrait::new();
        data.append('II');
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
    check_gas();

    match power {
        0 => result,
        _ => {
            let (q, r) = unsafe_euclidean_div(power, 2);
            let (_, b) = unsafe_euclidean_div(base * base, modulus);
            match r {
                0 => {
                    _fast_power(b, q, modulus, result)
                },
                _ => {
                    let (_, r) = unsafe_euclidean_div(result * base, modulus);
                    _fast_power(b, q, modulus, r)
                }
            }
        }
    }
}
