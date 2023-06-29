// Integrate using the composite trapezoidal rule
use array::ArrayTrait;

// Integrate y(x).
// # Arguments
// * `xs` - The sorted abscissa sequence of len L.
// * `ys` - The ordinate sequence of len L.
// # Returns
// * `usize` - The approximate integral.
fn trapz(mut xs: Array<usize>, mut ys: Array<usize>) -> usize {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');
    assert(xs.len() >= 2_usize, 'Array must have at least 2 elts');

    // [Compute] Trapz
    let mut index = 0_usize;
    let mut value = 0_usize;
    loop {
        if index + 1_usize == xs.len() {
            break ();
        }
        assert(*xs.at(index + 1_usize) > *xs.at(index), 'Abscissa must be sorted');
        value += (*xs.at(index + 1_usize) - *xs.at(index)) * (*ys.at(index) + *ys.at(index + 1_usize));
        index += 1_usize;
    };
    value / 2_usize
}
