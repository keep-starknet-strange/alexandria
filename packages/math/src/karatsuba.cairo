//! # Karatsuba Multiplication.
use core::cmp::max;
use super::const_pow::pow10;
use super::count_digits_of_base;

/// Algorithm to multiply two numbers in O(n^1.6) running time
/// #### Arguments
/// * `x` - First number to multiply.
/// * `y` - Second number to multiply.
/// #### Returns
/// * `u128` - The product between x and y
pub fn multiply(x: u128, y: u128) -> u128 {
    if x < 10 {
        return x * y;
    }

    let max_digit_counts = max(count_digits_of_base(x, 10), count_digits_of_base(y, 10));
    // the digits amount has to
    let middle_idx = div_half_ceil(max_digit_counts);
    // free type conversion
    let (x1, x0) = split_number(x, middle_idx);
    let (y1, y0) = split_number(y, middle_idx);

    let z0 = multiply(x0, y0);
    let z1 = multiply(x1, y1);
    let z2 = multiply(x0 + x1, y0 + y1);

    return z0 + (z2 - z0 - z1) * pow10(middle_idx) + z1 * pow10(2 * middle_idx);
}

/// Helper function for 'multiply', divides an integer in half and rounds up strictly.
/// #### Arguments
/// * `num` - The current value to be divided.
/// #### Returns
/// * `u32` - Half (rounded up) of num.
fn div_half_ceil(num: u32) -> u32 {
    if num % 2 != 0 {
        (num + 1) % 2
    } else {
        num / 2
    }
}

/// Helper function for 'multiply',splits a number at the indicated index and returns it in a tuple.
/// #### Arguments
/// * `num` - The current value to be split.
/// * `split_idx` - Index at which the number will be split
/// #### Returns
/// * `(u128, u128)` -tuple representing the split number.
fn split_number(num: u128, split_idx: u32) -> (u128, u128) {
    let divisor = pow10(split_idx);
    (num / divisor, num % divisor)
}
