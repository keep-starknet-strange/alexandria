//! The discrete difference of the elements.
use array::ArrayTrait;
use zeroable::Zeroable;

/// Compute the discrete difference of a sorted sequence.
/// # Arguments
/// * `sequence` - The sorted sequence to operate.
/// # Returns
/// * `Array<T>` - The discrete difference of sorted sequence.
fn diff<
    T,
    impl TPartialOrd:PartialOrd<T>,
    impl TSub:Sub<T>,
    impl TCopy:Copy<T>,
    impl TDrop:Drop<T>,
    impl TZeroable:Zeroable<T>,
>(
    mut sequence: @Array<T>
) -> Array<T> {
    // [Check] Inputs
    assert(sequence.len() >= 1, 'Array must have at least 1 elt');

    // [Compute] Interpolation
    let mut index = 0;
    let mut array = ArrayTrait::<T>::new();
    loop {
        if index == sequence.len() {
            break ();
        }
        if index == 0 {
            array.append(Zeroable::zero());
        } else {
            assert(*sequence[index] >= *sequence[index - 1], 'Sequence must be sorted');
            array.append(*sequence[index] - *sequence[index - 1]);
        }
        index += 1;
    };
    array
}
