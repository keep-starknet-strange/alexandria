//! The cumulative product of the elements.

/// Compute the cumulative product of a sequence.
/// # Arguments
/// * `sequence` - The sequence to operate.
/// # Returns
/// * `Array<T>` - The cumulative product of sequence.
pub fn cumprod<T, +Mul<T>, +Copy<T>, +Drop<T>>(mut sequence: Span<T>) -> Array<T> {
    // [Check] Inputs
    assert(sequence.len() >= 1, 'Array must have at least 1 elt');

    // [Compute] Interpolation
    let mut prev_value = *sequence.pop_front().unwrap();
    let mut array = array![prev_value];
    for current_value in sequence {
        let prod = *current_value * prev_value;
        array.append(prod);
        prev_value = prod;
    }
    array
}
