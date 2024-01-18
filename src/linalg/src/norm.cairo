//! Norm of an u128 array.

/// Compute the norm for an u128 array.
/// # Arguments
/// * `array` - The inputted array.
/// * `ord` - The order of the norm.
/// * `iter` - The number of iterations to run the algorithm
/// # Returns
/// * `u128` - The norm for the array.
use alexandria_math::fast_root::fast_nr_optimize;
use alexandria_math::pow;

use debug::PrintTrait;

fn norm(
    mut xs: Span<u128>, ord: u128, iter: usize
) -> u128 {
    let mut norm = 0;
    loop {
        match xs.pop_front() {
            Option::Some(x_value) => {
                if ord == 0 {
                    if *x_value != 0 {
                        norm += 1;
                    }
                } else {
                    norm += pow(*x_value, ord);
                }
            },
            Option::None => { break; },
        };
    };
    norm.print();
    
    if ord == 0 {
        return norm;
    }
    
    norm = fast_nr_optimize(norm, ord, iter);

    norm
}
