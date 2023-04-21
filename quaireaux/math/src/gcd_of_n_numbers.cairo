//! # GCD for N numbers
use array::SpanTrait;
use option::OptionTrait;

use quaireaux_utils::check_gas;

use quaireaux_math::unsafe_euclidean_div;

// Calculate the greatest common dividor for n numbers
// # Arguments
// * `n` - The array of numbers to calculate the gcd for
// # Returns
// * `felt252` - The gcd of input numbers
fn gcd(mut n: Span<felt252>) -> felt252 {
    // Return empty input error
    if n.is_empty() {
        panic_with_felt252('EI')
    }
    let mut a = *n.pop_front().unwrap();
    loop {
        check_gas();
        match n.pop_front() {
            Option::Some(b) => {
                a = gcd_two_numbers(a, *b);
            },
            Option::None(()) => {
                break a;
            },
        };
    }
}

// Internal function to calculate the gcd between two numbers
// # Arguments
// * `a` - The first number for which to calculate the gcd
// * `b` - The first number for which to calculate the gcd
// # Returns
// * `felt252` - The gcd of a and b
fn gcd_two_numbers(mut a: felt252, mut b: felt252) -> felt252 {
    loop {
        check_gas();
        if b == 0 {
            break a;
        }
        let (_, r) = unsafe_euclidean_div(a, b);
        a = b;
        b = r;
    }
}
