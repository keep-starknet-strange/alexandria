//! # Fast power algorithm
use array::ArrayTrait;

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
        if power == 0 {
            break result;
        }

        if power % 2 != 0 {
            result = (result * base) % modulus;
        }
        base = (base * base) % modulus;
        power = power / 2;
    }
}
