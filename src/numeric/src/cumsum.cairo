use core::array::SpanTrait;
use core::option::OptionTrait;
//! The cumulative sum of the elements.

/// Compute the cumulative sum of a sequence.
/// # Arguments
/// * `sequence` - The sequence to operate.
/// # Returns
/// * `Array<T>` - The cumulative sum of sequence.
fn cumsum<T, +Add<T>, +Copy<T>, +Drop<T>,>(mut sequence: Span<T>) -> Array<T> {
    // [Check] Inputs
    assert(sequence.len() >= 1, 'Array must have at least 1 elt');

    // [Compute] Interpolation
    let mut prev_value = *sequence.pop_front().unwrap();
    let mut array = array![prev_value];
    while !sequence
        .is_empty() {
            let current_value = *sequence.pop_front().unwrap();
            let sum = current_value + prev_value;
            array.append(sum);
            prev_value = sum;
        };
    array
}
