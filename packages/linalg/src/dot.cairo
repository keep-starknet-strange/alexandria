use core::num::traits::Zero;
use core::ops::AddAssign;
//! Dot product of two arrays

/// Compute the dot product for 2 given arrays.
/// # Arguments
/// * `xs` - The first sequence of len L.
/// * `ys` - The second sequence of len L.
/// # Returns
/// * `sum` - The dot product.
pub fn dot<T, +Mul<T>, +AddAssign<T, T>, +Zero<T>, +Copy<T>, +Drop<T>>(
    mut xs: Span<T>, mut ys: Span<T>,
) -> T {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');

    // [Compute] Dot product in a loop
    let mut sum = Zero::zero();
    while !xs.is_empty() {
        let x = *xs.pop_front().unwrap();
        let y = *ys.pop_front().unwrap();
        sum += x * y;
    }
    sum
}
