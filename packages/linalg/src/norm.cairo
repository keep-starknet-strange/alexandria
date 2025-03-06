//! Norm of an T array.
use alexandria_math::fast_root::fast_nr_optimize;
use alexandria_math::pow;
use core::num::traits::Zero;

/// Compute the norm for an T array.
/// # Arguments
/// * `array` - The inputted array.
/// * `ord` - The order of the norm.
/// * `iter` - The number of iterations to run the algorithm
/// # Returns
/// * `u128` - The norm for the array.
pub fn norm<T, +Into<T, u128>, +Zero<T>, +Copy<T>, +Drop<T>>(
    mut xs: Span<T>, ord: u128, iter: usize,
) -> u128 {
    let mut norm: u128 = 0;
    for x_value in xs {
        if ord == 0 {
            if (*x_value).is_non_zero() {
                norm += 1;
            }
        } else {
            norm += pow((*x_value).into(), ord);
        };
    }

    if ord == 0 {
        return norm;
    }

    fast_nr_optimize(norm, ord, iter)
}
