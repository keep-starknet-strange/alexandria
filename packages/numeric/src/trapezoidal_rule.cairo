use core::array::SpanTrait;
use core::num::traits::Zero;
use core::ops::AddAssign;
//! Integrate using the composite trapezoidal rule

/// Integrate y(x).
/// # Arguments
/// * `xs` - The sorted abscissa sequence of len L.
/// * `ys` - The ordinate sequence of len L.
/// # Returns
/// * `T` - The approximate integral.
pub fn trapezoidal_rule<
    T,
    +PartialOrd<T>,
    +Add<T>,
    +AddAssign<T, T>,
    +Sub<T>,
    +Mul<T>,
    +Div<T>,
    +Copy<T>,
    +Drop<T>,
    +Zero<T>,
    +Into<u8, T>,
>(
    mut xs: Span<T>, mut ys: Span<T>,
) -> T {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');
    assert(xs.len() >= 2, 'Array must have at least 2 elts');

    // [Compute] Trapezoidal rule
    let mut prev_x = *xs.pop_front().unwrap();
    let mut prev_y = *ys.pop_front().unwrap();
    let mut value = Zero::zero();
    for next_x in xs {
        assert(*next_x > prev_x, 'Abscissa must be sorted');
        let next_y = *ys.pop_front().unwrap();
        value += (*next_x - prev_x) * (prev_y + next_y);
        prev_x = *next_x;
        prev_y = next_y;
    }
    value / Into::into(2_u8)
}
