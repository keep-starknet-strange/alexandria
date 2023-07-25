use array::SpanTrait;

// Check if two arrays are equal.
/// * `a` - The first array.
/// * `b` - The second array.
/// * `index` - The index used to loop through the arrays.
/// # Returns
/// * `bool` - True if the arrays are equal, false otherwise.
fn is_equal(a: Span<u32>, b: Span<u32>, index: u32) -> bool {
    let len = a.len();
    if len != b.len() {
        return false;
    }
    if index == len {
        return true;
    }

    if *a[index] != *b[index] {
        return false;
    }

    is_equal(a, b, index + 1)
}
