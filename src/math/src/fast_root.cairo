//! # Fast root algorithm using the Newton-Raphson method

// Newton-Raphson optimization to solve the equation x^r = a
// # Arguments
// * ` x ` - The number to calculate the root of
// * ` r ` - The root to calculate
// * ` iter ` - The number of iterations to run the algorithm
// # Returns
// * ` u128 ` - The root of x
use super::pow;
fn fast_nr_optimize(x: u128, r: u128, iter: usize) -> u128 {
    if x == 0 {
        return 0;
    }

    if r == 1 {
        return x;
    }

    let mut x_optim = round_div(x, r);
    let mut n_iter = 0;

    loop {
        if n_iter == iter {
            break;
        }
        let x_r_m1 = pow(x_optim, r - 1);
        x_optim = round_div(((r - 1) * x_optim + round_div(x, x_r_m1)), r);
        n_iter += 1;
    };

    return x_optim;
}

// Calculate the sqrt(x)
// # Arguments
// * ` x ` - The number to calculate the sqrt of
// * ` iter ` - The number of iterations to run the algorithm
// # Returns
// * ` u128 ` - The sqrt of x
fn fast_sqrt(x: u128, iter: usize) -> u128 {
    return fast_nr_optimize(x, 2, iter);
}

// Calculate the cubic root of x
// # Arguments
// * ` x ` - The number to calculate the cubic root of
// * ` iter ` - The number of iterations to run the algorithm
// # Returns
// * ` u128 ` - The cubic root of x
fn fast_cbrt(x: u128, iter: usize) -> u128 {
    return fast_nr_optimize(x, 3, iter);
}

// Calculate the division of a by b rounded off
// # Arguments
// * ` a ` - The dividend
// * ` b ` - The divisor
// # Returns
// * ` u128 ` - The result of the division rounded off
fn round_div(a: u128, b: u128) -> u128 {
    let remained = a % b;
    if b - remained <= remained {
        return a / b + 1;
    }
    return a / b;
}
