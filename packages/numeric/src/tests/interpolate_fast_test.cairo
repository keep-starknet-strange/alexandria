use alexandria_numeric::interpolate::{
    Extrapolation, Interpolation, interpolate_fast as interpolate,
};

#[test]
#[available_gas(2000000)]
fn interp_extrapolation_test() {
    let xs: Array<u64> = array![3, 5, 7];
    let ys = array![11, 13, 17];
    assert_eq!(
        interpolate(0, xs.span(), ys.span(), Interpolation::Linear, Extrapolation::Constant), 11,
    );
    assert_eq!(
        interpolate(9, xs.span(), ys.span(), Interpolation::Linear, Extrapolation::Constant), 17,
    );
    assert_eq!(interpolate(0, xs.span(), ys.span(), Interpolation::Linear, Extrapolation::Null), 0);
    assert_eq!(interpolate(9, xs.span(), ys.span(), Interpolation::Linear, Extrapolation::Null), 0);
}

#[test]
#[available_gas(2000000)]
fn interp_linear_test() {
    let xs: Array<u64> = array![3, 5, 7];
    let ys = array![11, 13, 17];
    assert_eq!(
        interpolate(4, xs.span(), ys.span(), Interpolation::Linear, Extrapolation::Constant), 12,
    );
    assert_eq!(
        interpolate(4, xs.span(), ys.span(), Interpolation::Linear, Extrapolation::Constant), 12,
    );
}

#[test]
#[available_gas(2000000)]
fn interp_nearest_test() {
    let xs: Array<u64> = array![3, 5, 7];
    let ys = array![11, 13, 17];
    assert_eq!(
        interpolate(4, xs.span(), ys.span(), Interpolation::Nearest, Extrapolation::Constant), 11,
    );
    assert_eq!(
        interpolate(6, xs.span(), ys.span(), Interpolation::Nearest, Extrapolation::Constant), 13,
    );
    assert_eq!(
        interpolate(7, xs.span(), ys.span(), Interpolation::Nearest, Extrapolation::Constant), 17,
    );
}

#[test]
#[available_gas(2000000)]
fn interp_constant_left_test() {
    let xs: Array<u64> = array![3, 5, 7];
    let ys = array![11, 13, 17];
    assert_eq!(
        interpolate(4, xs.span(), ys.span(), Interpolation::ConstantLeft, Extrapolation::Constant),
        13,
    );
    assert_eq!(
        interpolate(6, xs.span(), ys.span(), Interpolation::ConstantLeft, Extrapolation::Constant),
        17,
    );
    assert_eq!(
        interpolate(7, xs.span(), ys.span(), Interpolation::ConstantLeft, Extrapolation::Constant),
        17,
    );
}

#[test]
#[available_gas(2000000)]
fn interp_constant_left_diff() {
    let xs: Span<u64> = array![0, 2, 4, 6, 8].span();
    let ys: Span<u64> = array![0, 2, 4, 6, 8].span();
    let inter = Interpolation::ConstantLeft;
    let extra = Extrapolation::Constant;
    assert_eq!(@interpolate(0, xs, ys, inter, extra), @0);
    assert_eq!(@interpolate(1, xs, ys, inter, extra), @2);
    assert_eq!(@interpolate(2, xs, ys, inter, extra), @2);
    assert_eq!(@interpolate(3, xs, ys, inter, extra), @4);
    assert_eq!(@interpolate(4, xs, ys, inter, extra), @4);
    assert_eq!(@interpolate(5, xs, ys, inter, extra), @6);
    assert_eq!(@interpolate(6, xs, ys, inter, extra), @6);
    assert_eq!(@interpolate(7, xs, ys, inter, extra), @8);
    assert_eq!(@interpolate(8, xs, ys, inter, extra), @8);
    assert_eq!(@interpolate(9, xs, ys, inter, extra), @8);
}

#[test]
#[available_gas(2000000)]
fn interp_constant_right_test() {
    let xs: Array<u64> = array![3, 5, 8];
    let ys = array![11, 13, 17];
    assert_eq!(
        interpolate(4, xs.span(), ys.span(), Interpolation::ConstantRight, Extrapolation::Constant),
        11,
    );
    assert_eq!(
        interpolate(6, xs.span(), ys.span(), Interpolation::ConstantRight, Extrapolation::Constant),
        13,
    );
    assert_eq!(
        interpolate(7, xs.span(), ys.span(), Interpolation::ConstantRight, Extrapolation::Constant),
        13,
    );
}

#[test]
#[should_panic(expected: ("Arrays must have the same len",))]
#[available_gas(2000000)]
fn interp_revert_len_mismatch() {
    let xs: Array<u64> = array![3, 5];
    let ys = array![11];
    interpolate(4, xs.span(), ys.span(), Interpolation::Linear, Extrapolation::Constant);
}

#[test]
#[should_panic(expected: ("Array must have at least 2 elts",))]
#[available_gas(2000000)]
fn interp_revert_len_too_short() {
    let xs: Array<u64> = array![3];
    let ys = array![11];
    interpolate(4, xs.span(), ys.span(), Interpolation::Linear, Extrapolation::Constant);
}
