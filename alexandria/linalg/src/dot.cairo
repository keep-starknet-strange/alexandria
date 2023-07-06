//! Dot product of two arrays
use array::ArrayTrait;

/// Compute the dot product for 2 given arrays.
/// # Arguments
/// * `xs` - The first sequence of len L.
/// * `ys` - The second sequence of len L.
/// # Returns
/// * `T` - The dot product.
fn dot<
    T,
    impl TMul:Mul<T>,
    impl TAddEq:AddEq<T>,
    impl TZeroable:Zeroable<T>,
    impl TCopy:Copy<T>,
    impl TDrop:Drop<T>,
>(
    mut xs: Array<T>,
    mut ys: Array<T>
) -> T {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');

    // [Compute] Dot product in a loop
    let mut index = 0;
    let mut value = Zeroable::zero();
    loop {
        if index == xs.len() {
            break ();
        }
        value += *xs[index] * *ys[index];
        index += 1;
    };
    value
}
