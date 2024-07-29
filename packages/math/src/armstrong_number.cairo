//! # Armstrong Number Algorithm.
use super::{count_digits_of_base, pow};

/// Armstrong Number Algorithm.
/// # Arguments
/// * `num` - The number to be evaluated.
/// # Returns
/// * `bool` - A boolean value indicating is Armstrong Number.
pub fn is_armstrong_number(mut num: u128) -> bool {
    let mut remainder_num = num;
    let digits = count_digits_of_base(num, 10);
    loop {
        if num == 0 {
            break remainder_num == 0;
        }

        let lastDigit = num % 10;
        let cube = pow(lastDigit, digits);
        if cube > remainder_num {
            break false;
        }
        remainder_num = remainder_num - cube;
        num = num / 10;
    }
}
