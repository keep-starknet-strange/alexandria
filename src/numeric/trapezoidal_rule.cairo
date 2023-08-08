//! Integrate using the composite trapezoidal rule
use array::SpanTrait;
use zeroable::Zeroable;
use traits::Into;

/// Integrate y(x).
/// # Arguments
/// * `xs` - The sorted abscissa sequence of len L.
/// * `ys` - The ordinate sequence of len L.
/// # Returns
/// * `T` - The approximate integral.
fn trapezoidal_rule<
    T,
    impl TPartialOrd: PartialOrd<T>,
    impl TNumericLiteral: NumericLiteral<T>,
    impl TAdd: Add<T>,
    impl TAddEq: AddEq<T>,
    impl TSub: Sub<T>,
    impl TMul: Mul<T>,
    impl TDiv: Div<T>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>,
    impl TZeroable: Zeroable<T>,
    impl TInto: Into<u8, T>,
>(
    xs: Span<T>, ys: Span<T>
) -> T {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');
    assert(xs.len() >= 2, 'Array must have at least 2 elts');

    // [Compute] Trapezoidal rule
    let mut index = 0;
    let mut value = Zeroable::zero();
    loop {
        if index + 1 == xs.len() {
            break ();
        }
        assert(*xs[index + 1] > *xs[index], 'Abscissa must be sorted');
        value += (*xs[index + 1] - *xs[index]) * (*ys[index] + *ys[index + 1]);
        index += 1;
    };
    value / TInto::into(2)
}
