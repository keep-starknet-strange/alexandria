/// Check if the given number is power of 2
/// # Arguments
/// * `n` - The given number
/// # Returns
/// * `bool` - if the given number is power of 2
pub fn is_power_of_two(n: u128) -> bool {
    if n == 0 {
        return false;
    }

    n & (n - 1) == 0
}
