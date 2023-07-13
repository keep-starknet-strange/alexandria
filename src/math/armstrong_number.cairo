//! # Armstrong Number Algorithm.
use alexandria::math::{count_digits_of_base, pow};

/// Armstrong Number Algorithm.
/// # Arguments
/// * `num` - The number to be evaluated.
/// # Returns
/// * `bool` - A boolean value indicating is Armstrong Number.
fn is_armstrong_number(mut num: u128) -> bool {
    let mut original_num = num;
    let mut digits = count_digits_of_base(num, 10);
    loop {
        if num == 0 {
            break original_num == 0;
        }

        let lastDigit = num % 10;
        let sum = pow(lastDigit, digits);
        num = num / 10;
        if sum > original_num {
            break false;
        }
        original_num = original_num - sum;
    }
}
