//! # GCD for N numbers

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;
// Internal imports.
use quaireaux::utils;

// Calculate the greatest common dividor for n numbers
// # Arguments
// * `n` - The array of numbers to calculate the gcd for
// # Returns
// * `felt` - The gcd of input numbers
fn gcd(ref n: Array::<felt>) -> felt {
    // Return empty input error
    if n.len() == 0_usize {
        let mut data = array_new::<felt>();
        array_append::<felt>(ref data, 'EI');
        panic(data);
    }
    _gcd(ref n)
}

// Internal function loop through all elements from the array
// # Arguments
// * `n` - The array of numbers to calculate the gcd for
// # Returns
// * `felt` - The gcd of input numbers
fn _gcd(ref n: Array::<felt>) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }
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
// * `felt` - The gcd of a and b
fn gcd_two_numbers(a: felt, b: felt) -> felt {
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
    match b {
        0 => a,
        _ => {
            let (_, r) = utils::unsafe_euclidean_div(a, b);
            gcd_two_numbers(b, r)
        },
    }
}
