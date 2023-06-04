//! # Fast power algorithm
use array::ArrayTrait;
use integer::{u128_wide_mul};
use core::option::OptionTrait;
use core::traits::TryInto;

// Calculate the ( base ^ power ) mod modulus
// using the fast powering algorithm # Arguments
// * ` base ` - The base of the exponentiation * ` power ` - The power of the exponentiation * ` modulus ` - The modulus used in the calculation # Returns
// * ` u128 ` - The result of ( base ^ power ) mod modulus

fn fast_power(mut base: u128, mut power: u128, modulus: u128) -> u128 {
    // Return invalid input error
    if base == 0 {
        panic_with_felt252('II')
    }

    if modulus == 1 {
        return 0;
    }

    // TODO: Simplify thise conversions after https://github.com/starkware-libs/cairo/pull/3293 is merged and released.
    let mut base: u256 = u256 { low: base, high: 0 };
    let modulus: u256 = u256 { low: modulus, high: 0 };
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

    let u256{low: low, high: high } = res;

    if high != 0 {
        panic_with_felt252('value cant be larger than u128')
    }
    
    return low;
}
