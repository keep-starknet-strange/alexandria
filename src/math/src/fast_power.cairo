//! # Fast power algorithm
use array::ArrayTrait;
use option::OptionTrait;
use traits::{Into, TryInto};

// Calculate the ( base ^ power ) mod modulus
// using the fast powering algorithm # Arguments
// * ` base ` - The base of the exponentiation 
// * ` power ` - The power of the exponentiation 
// * ` modulus ` - The modulus used in the calculation # Returns
// * ` u128 ` - The result of ( base ^ power ) mod modulus

fn fast_power(base: u128, mut power: u128, modulus: u128) -> u128 {
    // Return invalid input error
    if base == 0 {
        panic_with_felt252('II')
    }

    if modulus == 1 {
        return 0;
    }

    let mut base: u256 = base.into();
    let modulus: u256 = modulus.into();
    let mut result: u256 = 1;

    let res = loop {
        if power == 0 {
            break result;
        }

        if power % 2 != 0 {
            result = (result * base) % modulus;
        }

        base = (base * base) % modulus;
        power = power / 2;
    };

    res.try_into().expect('value cant be larger than u128')
}
