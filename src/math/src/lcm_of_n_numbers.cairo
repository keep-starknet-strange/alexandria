//! # LCM for N numbers

// Calculate the lowest common multiple for n numbers
// # Arguments
// * `n` - The array of numbers to calculate the lcm for
// # Returns
// * `u128` - The lcm of input numbers
use alexandria_math::gcd_of_n_numbers::gcd_two_numbers;

fn lcm(mut n: Span<u128>) -> u128 {
    // Return empty input error
    if n.is_empty() {
        panic_with_felt252('EI')
    }
    let mut a = *n.pop_front().unwrap();
    loop {
        match n.pop_front() {
            Option::Some(b) => { a = (a * *b) / gcd_two_numbers(a, *b); },
            Option::None => { break a; },
        };
    }
}
