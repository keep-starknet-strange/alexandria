//! The cumulative sum of the elements.
use array::ArrayTrait;

/// Compute the cumulative sum of a sequence.
/// # Arguments
/// * `sequence` - The sequence to operate.
/// # Returns
/// * `Array<T>` - The cumulative sum of sequence.
fn cumsum<
    T,
    impl TAdd:Add<T>,
    impl TCopy:Copy<T>,
    impl TDrop:Drop<T>,
>(
    mut sequence: @Array<T>
) -> Array<T> {
    // [Check] Inputs
    assert(sequence.len() >= 1, 'Array must have at least 1 elt');

    // [Compute] Interpolation
    let mut index = 0;
    let mut array = ArrayTrait::new();
    loop {
        if index == sequence.len() {
            break ();
        }
        if index == 0 {
            array.append(*sequence[index]);
        } else {
            array.append(*sequence[index] + *array[index - 1]);
        }
        index += 1;
    };
    array
}
