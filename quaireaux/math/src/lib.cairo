mod math;
use math::pow;
use math::count_digits_of_base;
use math::unsafe_euclidean_div;
use math::unsafe_euclidean_div_no_remainder;

mod aliquot_sum;
mod armstrong_number;
mod collatz_sequence;
mod extended_euclidean_algorithm;
mod fast_power;
mod fibonacci;
mod gcd_of_n_numbers;
mod perfect_number;
mod sha256;
mod signed_integers;
mod zellers_congruence;
// mod karatsuba;

#[cfg(test)]
mod tests;
