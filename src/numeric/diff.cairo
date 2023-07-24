use core::option::OptionTrait;
//! The discrete difference of the elements.
use array::{ArrayTrait, SpanTrait};
use zeroable::Zeroable;

/// Compute the discrete difference of a sorted sequence.
/// # Arguments
/// * `sequence` - The sorted sequence to operate.
/// # Returns
/// * `Array<T>` - The discrete difference of sorted sequence.
fn diff<
    T,
    impl TPartialOrd: PartialOrd<T>,
    impl TSub: Sub<T>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>,
    impl TZeroable: Zeroable<T>,
>(
    mut sequence: Span<T>
) -> Array<T> {
    // [Check] Inputs
    assert(sequence.len() >= 1, 'Array must have at least 1 elt');

    // [Compute] Interpolation
    let mut array = ArrayTrait::<T>::new();
    array.append(Zeroable::zero());
    let mut prev_value = *sequence.pop_front().unwrap();
    loop {
        match sequence.pop_front() {
            Option::Some(current_value) => {
                assert(*current_value >= prev_value, 'Sequence must be sorted');
                array.append(*current_value - prev_value);
                prev_value = *current_value;
            },
            Option::None(_) => {
                break ();
            },
        };
    };
    array
}
