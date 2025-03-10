//! Kronecker product of two arrays

#[derive(Drop, Copy, PartialEq)]
pub enum KronError {
    UnequalLength,
}

/// Compute the Kronecker product for 2 given arrays.
/// # Arguments
/// * `xs` - The first sequence of len L.
/// * `ys` - The second sequence of len L.
/// # Returns
/// * `Result<Array<T>, KronError>` - The Kronecker product.
pub fn kron<T, +Mul<T>, +Copy<T>, +Drop<T>>(
    mut xs: Span<T>, mut ys: Span<T>,
) -> Result<Array<T>, KronError> {
    // [Check] Inputs
    if xs.len() != ys.len() {
        return Result::Err(KronError::UnequalLength);
    }

    // [Compute] Kronecker product in a loop
    let mut array = array![];

    for x_value in xs {
        let ys_clone = ys;
        for y_value in ys_clone {
            array.append(*x_value * *y_value);
        }
    }

    Result::Ok(array)
}
