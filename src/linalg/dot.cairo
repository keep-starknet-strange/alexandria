use core::option::OptionTrait;
//! Dot product of two arrays
use array::SpanTrait;

/// Compute the dot product for 2 given arrays.
/// # Arguments
/// * `xs` - The first sequence of len L.
/// * `ys` - The second sequence of len L.
/// # Returns
/// * `T` - The dot product.
fn dot<
    T,
    impl TMul: Mul<T>,
    impl TAddEq: AddEq<T>,
    impl TZeroable: Zeroable<T>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>,
>(
    mut xs: Span<T>, mut ys: Span<T>
) -> T {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');

    // [Compute] Dot product in a loop
    let mut index = 0;
    let mut value = Zeroable::zero();
    loop {
        match xs.pop_front() {
            Option::Some(x_value) => {
                let y_value = ys.pop_front().unwrap();
                value += *x_value * *y_value;
            },
            Option::None(_) => {
                break value;
            },
        };
    }
}
