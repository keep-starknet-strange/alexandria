use alexandria_math::fast_root::fast_sqrt;

/// Check if the given number is prime
/// # Arguments
/// * `n` - The given number
/// * `iter` - The number of iterations to run when sqrting the number, the higher the more accurate
/// (usually 10 is enough)
/// # Returns
/// * `bool` - if the given number is prime
pub fn is_prime(n: u128, iter: usize) -> bool {
    if n <= 1 {
        return false;
    }

    if n <= 3 {
        return true;
    }

    if n % 2 == 0 {
        return false;
    }

    let divider_limit = fast_sqrt(n, iter);
    let mut current_divider = 3;

    loop {
        if current_divider > divider_limit {
            break true;
        }

        if n % current_divider == 0 {
            break false;
        }

        current_divider += 2;
    }
}
