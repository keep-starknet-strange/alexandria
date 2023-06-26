// Dot product of two arrays
use array::ArrayTrait;

// Compute the dot product for 2 given arrays.
// # Arguments
// * `xs` - The first sequence of len L.
// * `ys` - The second sequence of len L.
// # Returns
// * `u128` - The dot product.
fn dot(mut xs: Array<usize>, mut ys: Array<usize>) -> usize {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');

    // [Compute] Dot product in a loop
    let mut index = 0_usize;
    let mut value = 0_usize;
    loop {
        if index == xs.len() {
            break ();
        }
        value += *xs.at(index) * *ys.at(index);
        index += 1_usize;
    };
    value
}
