use array::ArrayTrait;

use quaireaux_utils::check_gas;

/// Returns the slice of an array.
/// * `arr` - The array to slice.
/// * `begin` - The index to start the slice at.
/// * `end` - The index to end the slice at (not included).
/// # Returns
/// * `Array<u256>` - The slice of the array.
fn array_slice(src: @Array<u256>, mut begin: usize, mut end: usize) -> Array<u256> {
    let mut slice = ArrayTrait::new();

    loop {
        check_gas();

        if end == 0_u32 {
            break ();
        }
        if begin >= src.len() {
            break ();
        }
        
        slice.append(*src[begin]);
        begin = begin + 1_usize;
        end = end - 1_usize;
    };
    slice
}


