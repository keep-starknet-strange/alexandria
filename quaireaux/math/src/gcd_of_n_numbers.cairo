//! # GCD for N numbers
use array::ArrayTrait;
use option::OptionTrait;

use quaireaux_utils::check_gas;

use quaireaux_math::unsafe_euclidean_div;

// Calculate the greatest common dividor for n numbers
// # Arguments
// * `n` - The array of numbers to calculate the gcd for
// # Returns
// * `felt252` - The gcd of input numbers
fn gcd(ref n: Array<felt252>) -> felt252 {
    // Return empty input error
    if n.len() == 0_usize {
        panic_with_felt252('EI')
    }
    _gcd(ref n)
}

// Internal function loop through all elements from the array
// # Arguments
// * `n` - The array of numbers to calculate the gcd for
// # Returns
// * `felt252` - The gcd of input numbers
fn _gcd(ref n: Array<felt252>) -> felt252 {
    check_gas();
    if n.len() == 1_usize {
        return n.pop_front().unwrap();
    }
    let a = n.pop_front().unwrap();
    let b = _gcd(ref n);
    gcd_two_numbers(a, b)
}

// Internal function to calculate the gcd between two numbers
// # Arguments
// * `a` - The first number for which to calculate the gcd
// * `b` - The first number for which to calculate the gcd
// # Returns
// * `felt252` - The gcd of a and b
fn gcd_two_numbers(a: felt252, b: felt252) -> felt252 {
    check_gas();

    match b {
        0 => a,
        _ => {
            let (_, r) = unsafe_euclidean_div(a, b);
            gcd_two_numbers(b, r)
        },
    }
}
