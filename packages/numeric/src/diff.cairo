use core::num::traits::Zero;
//! The discrete difference of the elements.

/// Compute the discrete difference of a sorted sequence.
/// # Arguments
/// * `sequence` - The sorted sequence to operate.
/// # Returns
/// * `Array<T>` - The discrete difference of sorted sequence.
pub fn diff<T, +PartialOrd<T>, +Sub<T>, +Copy<T>, +Drop<T>, +Zero<T>>(
    mut sequence: Span<T>,
) -> Array<T> {
    // [Check] Inputs
    assert(sequence.len() >= 1, 'Array must have at least 1 elt');

    // [Compute] Interpolation
    let mut prev_value = *sequence.pop_front().unwrap();
    let mut array = array![Zero::zero()];
    for current_value in sequence {
        assert(*current_value >= prev_value, 'Sequence must be sorted');
        array.append(*current_value - prev_value);
        prev_value = *current_value;
    }
    array
}
