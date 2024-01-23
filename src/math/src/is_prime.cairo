// Check if the given number is prime
// # Arguments
// * `n` - The given number
// * `iter` - The number of iterations to run when sqrting the number
// # Returns
// * `bool` - if the given number is prime
use alexandria_math::fast_root::fast_sqrt;

fn is_prime(n: u128, iter: usize) -> bool {
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
    let mut current_dividier = 3;
    let mut ans = true;

    loop {
        if current_dividier > divider_limit {
            break;
        }

        if n % current_dividier == 0 {
            ans = false;
            break;
        }

        current_dividier += 2;
    };

    ans
}
