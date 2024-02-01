//! Integrate using the composite trapezoidal rule

/// Integrate y(x).
/// # Arguments
/// * `xs` - The sorted abscissa sequence of len L.
/// * `ys` - The ordinate sequence of len L.
/// # Returns
/// * `T` - The approximate integral.
fn trapezoidal_rule<
    T,
    +PartialOrd<T>,
    +NumericLiteral<T>,
    +Add<T>,
    +AddEq<T>,
    +Sub<T>,
    +Mul<T>,
    +Div<T>,
    +Copy<T>,
    +Drop<T>,
    +Zeroable<T>,
    +Into<u8, T>,
>(
    xs: Span<T>, ys: Span<T>
) -> T {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');
    assert(xs.len() >= 2, 'Array must have at least 2 elts');

    // [Compute] Trapezoidal rule
    let mut index = 0;
    let mut value = Zeroable::zero();
    while index
        + 1 != xs
            .len() {
                assert(*xs[index + 1] > *xs[index], 'Abscissa must be sorted');
                value += (*xs[index + 1] - *xs[index]) * (*ys[index] + *ys[index + 1]);
                index += 1;
            };
    value / Into::into(2_u8)
}
