//! # GCD for N numbers

// Calculate the greatest common divisor for n numbers
// # Arguments
// * `n` - The array of numbers to calculate the gcd for
// # Returns
// * `felt252` - The gcd of input numbers
pub fn gcd(mut n: Span<u128>) -> u128 {
    // Return empty input error
    assert!(!n.is_empty(), "gcd-empty");

    let mut a = *n.pop_front().unwrap();
    for b in n {
        a = gcd_two_numbers(a, *b);
    }
    a
}

// Internal function to calculate the gcd between two numbers
// # Arguments
// * `a` - The first number for which to calculate the gcd
// * `b` - The first number for which to calculate the gcd
// # Returns
// * `felt252` - The gcd of a and b
pub fn gcd_two_numbers(mut a: u128, mut b: u128) -> u128 {
    while b != 0 {
        let r = a % b;
        a = b;
        b = r;
    }
    a
}
