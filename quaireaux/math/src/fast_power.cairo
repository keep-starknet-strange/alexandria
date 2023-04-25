//! # Fast power algorithm
use array::ArrayTrait;

use quaireaux_utils::check_gas;

// Calculate the (base^power)mod modulus using the fast powering algorithm
// # Arguments
// * `base` - The base of the exponentiation
// * `power` - The power of the exponentiation
// * `modulus` - The modulus used in the calculation
// # Returns
// * `felt252` - The result of (base^power)mod modulus
fn fast_power(mut base: u128, mut power: u128, modulus: u128) -> u128 {
    // Return invalid input error
    if base == 0 {
        panic_with_felt252('II')
    }
    let mut result = 1;
    loop {
        check_gas();

        if power == 0 {
            break result;
        }

        let q = power / 2;
        let r = power % 2;
        let b = (base * base) % modulus;

        if r != 0 {
            result = (result * base) % modulus;
        }
        base = b;
        power = q;
    }
}
