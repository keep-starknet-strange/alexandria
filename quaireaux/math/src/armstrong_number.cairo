//! # Armstrong Number Algorithm.
use quaireaux_utils::check_gas;

use quaireaux_math::count_digits_of_base;
use quaireaux_math::pow;
use quaireaux_math::unsafe_euclidean_div;

/// Armstrong Number Algorithm.
/// # Arguments
/// * `num` - The number to be evaluated.
/// # Returns
/// * `bool` - A boolean value indicating is Armstrong Number.
fn is_armstrong_number(mut num: felt252) -> bool {
    let mut original_num = num;
    let mut digits = count_digits_of_base(num, 10);
    loop {
        check_gas();

        if num == 0 {
            break ();
        } 
        let (new_num, lastDigit) = unsafe_euclidean_div(num, 10);
        let sum = pow(lastDigit, digits);
        num = new_num;
        original_num= original_num - sum;
    };
    original_num == 0
}
