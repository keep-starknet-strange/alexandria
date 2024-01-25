//! # LCM for N numbers
use alexandria_math::gcd_of_n_numbers::gcd_two_numbers;
use core::option::OptionTrait;
use core::traits::TryInto;

#[derive(Drop, Copy, PartialEq)]
enum LCMError {
    EmptyInput,
}

/// Calculate the lowest common multiple for n numbers
/// # Arguments
/// * `n` - The array of numbers to calculate the lcm for
/// # Returns
/// * `Result<T, LCMError>` - The lcm of input numbers
fn lcm<T, +TryInto<T, u128>, +TryInto<u128, T>, +Mul<T>, +Div<T>, +Copy<T>, +Drop<T>>(
    mut n: Span<T>
) -> Result<T, LCMError> {
    // Return empty input error
    if n.is_empty() {
        return Result::Err(LCMError::EmptyInput);
    }
    let mut a = *n.pop_front().unwrap();
    loop {
        match n.pop_front() {
            Option::Some(b) => {
                let gcd: T = gcd_two_numbers(a.try_into().unwrap(), (*b).try_into().unwrap())
                    .try_into()
                    .unwrap();
                a = (a * *b) / gcd;
            },
            Option::None => { break Result::Ok(a); },
        };
    }
}
