// One-dimensional linear interpolation for monotonically increasing sample points.
use array::ArrayTrait;

#[derive(Serde, Copy, Drop, PartialEq)]
enum Interpolation {
    Linear: (),
    Nearest: (),
    ConstantLeft: (),
    ConstantRight: (),
}

#[derive(Serde, Copy, Drop, PartialEq)]
enum Extrapolation {
    Null: (),
    Constant: (),
}

// Interpolate y(x) at x.
// # Arguments
// * `x` - The position at which to interpolate.
// * `xs` - The sorted abscissa sequence of len L.
// * `ys` - The ordinate sequence of len L.
// * `interpolation` - The interpolation method to use.
// * `extrapolation` - The extrapolation method to use.
// # Returns
// * `usize` - The interpolated y at x.
fn interp(x: usize, xs: @Array<usize>, ys: @Array<usize>, interpolation: Interpolation, extrapolation: Extrapolation) -> usize {
    // [Check] Inputs
    assert(xs.len() == ys.len(), 'Arrays must have the same len');
    assert(xs.len() >= 2_usize, 'Array must have at least 2 elts');

    // [Check] Extrapolation
    if x < *xs.at(0) {
        let y = match extrapolation {
            Extrapolation::Null(()) => 0_usize,
            Extrapolation::Constant(()) => *ys.at(0_usize),
        };
        return y;
    }
    if x > *xs.at(xs.len() - 1_usize) {
        let y = match extrapolation {
            Extrapolation::Null(()) => 0_usize,
            Extrapolation::Constant(()) => *ys.at(xs.len() - 1_usize),
        };
        return y;
    }

    // [Compute] Interpolation
    let mut index = 0_usize;
    loop {
        if index + 1_usize == xs.len() {
            assert(0 != 1, 'Unexpected error');
        }
        assert(*xs.at(index + 1_usize) > *xs.at(index), 'Abscissa must be sorted');

        if x < *xs.at(index + 1_usize) {
            break match interpolation {
                Interpolation::Linear(()) => {
                    // y = [(xb - x) * ya + (x - xa) * yb] / (xb - xa)
                    // y = [alpha * ya + beta * yb] / den
                    let den = *xs.at(index + 1_usize) - *xs.at(index);
                    let alpha = *xs.at(index + 1_usize) - x;
                    let beta = x - *xs.at(index);
                    (alpha * *ys.at(index) + beta * *ys.at(index + 1_usize)) / den
                },
                Interpolation::Nearest(()) => {
                    // y = ya or yb
                    let alpha = *xs.at(index + 1_usize) - x;
                    let beta = x - *xs.at(index);
                    if alpha >= beta {
                        *ys.at(index)
                    } else {
                        *ys.at(index + 1_usize)
                    }
                },
                Interpolation::ConstantLeft(()) => *ys.at(index + 1_usize),
                Interpolation::ConstantRight(()) => *ys.at(index),
            };
        }
        
        index += 1_usize;
    }
}