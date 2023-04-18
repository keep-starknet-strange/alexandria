//! # Fast power algorithm
use array::ArrayTrait;

use quaireaux_utils::check_gas;

use quaireaux_math::unsafe_euclidean_div;

// Calculate the (base^power)mod modulus using the fast powering algorithm
// # Arguments
// * `base` - The base of the exponentiation
// * `power` - The power of the exponentiation
// * `modulus` - The modulus used in the calculation
// # Returns
// * `felt252` - The result of (base^power)mod modulus
fn fast_power(mut base: felt252, mut power: felt252, modulus: felt252) -> felt252 {
    // Return invalid input error
    if base == 0 {
        panic_with_felt252('II')
    }
    let mut result = 1;
    loop {
        check_gas();

        if power == 0 {
            break ();
        }

        let (q, r) = unsafe_euclidean_div(power, 2);
        let (_, b) = unsafe_euclidean_div(base * base, modulus);

        if r != 0 {
            let (_, r) = unsafe_euclidean_div(result * base, modulus);
            result = r;
        }
        base = b;
        power = q;
    };
    result
}
