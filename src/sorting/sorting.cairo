use array::ArrayTrait;

// Check if two arrays are equal.
/// * `a` - The first array.
/// * `b` - The second array.
/// * `index` - The index used to loop through the arrays.
/// # Returns
/// * `bool` - True if the arrays are equal, false otherwise.
fn is_equal(ref a: Array<u32>, ref b: Array<u32>, index: u32) -> bool {
    let len = a.len();
    if len != b.len() {
        return false;
    }
    let mut i = 0_u32;
    if index == len {
        return true;
    }

    if *a[index] != *b[index] {
        return false;
    }

    is_equal(ref a, ref b, index + 1)
}
