use core::array::SpanTrait;
//! Kronecker product of two arrays

#[derive(Drop, Copy, PartialEq)]
enum KronError {
    UnequalLength,
}

/// Compute the Kronecker product for 2 given arrays.
/// # Arguments
/// * `xs` - The first sequence of len L.
/// * `ys` - The second sequence of len L.
/// # Returns
/// * `Result<Array<T>, KronError>` - The Kronecker product.
fn kron<T, +Mul<T>, +AddEq<T>, +Zeroable<T>, +Copy<T>, +Drop<T>,>(
    mut xs: Span<T>, mut ys: Span<T>
) -> Result<Array<T>, KronError> {
    // [Check] Inputs
    if xs.len() != ys.len() {
        return Result::Err(KronError::UnequalLength);
    }

    // [Compute] Kronecker product in a loop
    let mut array = array![];

    while let Option::Some(x_value) = xs
        .pop_front() {
            let mut ys_clone = ys;
            while let Option::Some(y_value) = ys_clone
                .pop_front() {
                    array.append(*x_value * *y_value);
                }
        };

    Result::Ok(array)
}
