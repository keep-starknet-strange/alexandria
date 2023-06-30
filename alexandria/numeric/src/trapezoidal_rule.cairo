//! Integrate using the composite trapezoidal rule
use array::ArrayTrait;

/// Integrate y(x).
/// # Arguments
/// * `xs` - The sorted abscissa sequence of len L.
/// * `ys` - The ordinate sequence of len L.
/// # Returns
/// * `usize` - The approximate integral.
fn trapezoidal_rule(mut xs: Array<usize>, mut ys: Array<usize>) -> usize {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');
    assert(xs.len() >= 2_usize, 'Array must have at least 2 elts');

    // [Compute] Trapezoidal rule
    let mut index = 0_usize;
    let mut value = 0_usize;
    loop {
        if index + 1_usize == xs.len() {
            break ();
        }
        assert(*xs[index + 1_usize] > *xs[index], 'Abscissa must be sorted');
        value += (*xs[index + 1_usize] - *xs[index]) * (*ys[index] + *ys[index + 1_usize]);
        index += 1_usize;
    };
    value / 2_usize
}
