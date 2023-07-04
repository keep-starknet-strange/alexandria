//! The cumulative sum of the elements.
use array::ArrayTrait;

/// Compute the cumulative sum of a sequence.
/// # Arguments
/// * `sequence` - The sequence to operate.
/// # Returns
/// * `Array<usize>` - The cumulative sum of sequence.
fn cumsum(mut sequence: @Array<usize>) -> Array<usize> {
    // [Check] Inputs
    assert(sequence.len() >= 1_u32, 'Array must have at least 1 elt');

    // [Compute] Interpolation
    let mut index = 0_u32;
    let mut array = ArrayTrait::new();
    loop {
        if index == sequence.len() {
            break ();
        }
        if index == 0_u32 {
            array.append(*sequence[index]);
        } else {
            array.append(*sequence[index] + *array[index - 1_u32]);
        }
        index += 1_u32;
    };
    array
}
