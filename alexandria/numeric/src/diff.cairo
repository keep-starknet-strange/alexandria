// The discrete difference of the elements.
use array::ArrayTrait;

// Compute the discrete difference of a sorted sequence.
// # Arguments
// * `sequence` - The sorted sequence to operate.
// # Returns
// * `Array<usize>` - The discrete difference of sorted sequence.
fn diff(mut sequence: @Array<usize>) -> Array<usize> {
    // [Check] Inputs
    assert(sequence.len() >= 1_usize, 'Array must have at least 1 elt');

    // [Compute] Interpolation
    let mut index = 0_usize;
    let mut array = ArrayTrait::new();
    loop {
        if index == sequence.len() {
            break ();
        }
        if index == 0_usize {
            array.append(0_usize);
        } else {
            assert(*sequence.at(index) >= *sequence.at(index - 1_usize), 'Sequence must be sorted');
            array.append(*sequence.at(index) - *sequence.at(index - 1_usize));
        }
        index += 1_usize;
    };
    array
}