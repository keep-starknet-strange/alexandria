use array::ArrayTrait;

/// Returns the slice of an array.
/// * `arr` - The array to slice.
/// * `begin` - The index to start the slice at.
/// * `end` - The index to end the slice at (not included).
/// # Returns
/// * `Array<u256>` - The slice of the array.
fn array_slice<T, impl TDrop: Drop<T>, impl TCopy: Copy<T>>(
    src: @Array<T>, mut begin: usize, end: usize
) -> Array<T> {
    let mut slice = ArrayTrait::<T>::new();
    let len = begin + end;
    loop {
        if begin >= len {
            break ();
        }
        if begin >= src.len() {
            break ();
        }

        slice.append(*src[begin]);
        begin += 1;
    };
    slice
}
