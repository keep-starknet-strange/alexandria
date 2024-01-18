//! # Carmichael Number Algorithm.
use super::fast_power::fast_power;
use super::gcd_of_n_numbers::gcd_two_numbers;


/// Carmichael Number Algorithm.
/// # Arguments
/// * `num` - The number to be evaluated.
/// # Returns
/// * `bool` - A boolean value indicating is Carmichael Number.
fn is_carmichael_number(mut num: u128) -> bool {
    if num == 0 {
        return false;
    }
    
    let mut ans: bool = true;
    let mut b: u128 = 2;

    loop {
        if b == num {
            break;
        }

        if gcd_two_numbers(b, num) != 1{
            b += 1;
            continue;
        }

        if fast_power(b, num - 1, num) != 1 {
            ans = false;
            break;
        }


        b += 1;
    };

    ans
}
