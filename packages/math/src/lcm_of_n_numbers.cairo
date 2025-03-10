//! # LCM for N numbers
use alexandria_math::gcd_of_n_numbers::gcd_two_numbers;

#[derive(Drop, Copy, PartialEq)]
pub enum LCMError {
    EmptyInput,
}

/// Calculate the lowest common multiple for n numbers
/// # Arguments
/// * `n` - The array of numbers to calculate the lcm for
/// # Returns
/// * `Result<T, LCMError>` - The lcm of input numbers
pub fn lcm<T, +Into<T, u128>, +Into<u128, T>, +Mul<T>, +Div<T>, +Copy<T>, +Drop<T>>(
    mut n: Span<T>,
) -> Result<T, LCMError> {
    // Return empty input error
    if n.is_empty() {
        return Result::Err(LCMError::EmptyInput);
    }
    let mut a = *n.pop_front().unwrap();
    for b in n {
        let gcd: T = gcd_two_numbers(a.into(), (*b).into()).into();
        a = (a * *b) / gcd;
    }
    Result::Ok(a)
}
