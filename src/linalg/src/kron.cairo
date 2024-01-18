//! Kronecker product of two arrays

/// Compute the Kronecker product for 2 given arrays.
/// # Arguments
/// * `xs` - The first sequence of len L.
/// * `ys` - The second sequence of len L.
/// # Returns
/// * `Array<T>` - The Kronecker product.
fn kron<T, +Mul<T>, +AddEq<T>, +Zeroable<T>, +Copy<T>, +Drop<T>,>(
    mut xs: Span<T>, mut ys: Span<T>
) -> Array<T> {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');

    // [Compute] Kronecker product in a loop
    let mut array = array![];
    loop {
        match xs.pop_front() {
            Option::Some(x_value) => {
                let mut ys_clone = ys.clone();
                loop {
                    match ys_clone.pop_front() {
                        Option::Some(y_value) => {
                            array.append(*x_value * *y_value);
                        },
                        Option::None => { break; },
                    };
                };
            },
            Option::None => { break; },
        };
    };

    array
}
