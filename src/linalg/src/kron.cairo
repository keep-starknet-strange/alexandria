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
    while !xs
        .is_empty() {
            let x = *xs.pop_front().unwrap();
            let mut ys_copy = ys;
            while !ys_copy
                .is_empty() {
                    let y = *ys_copy.pop_front().unwrap();
                    array.append(x * y);
                };
        };

    Result::Ok(array)
}
