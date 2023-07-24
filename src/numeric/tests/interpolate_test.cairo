use array::ArrayTrait;
use alexandria::numeric::interpolate::{interpolate, Interpolation, Extrapolation};

#[test]
#[available_gas(2000000)]
fn interp_extrapolation_test() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    xs.append(5);
    xs.append(7);
    let mut ys = ArrayTrait::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(
        interpolate(
            0, xs.span(), ys.span(), Interpolation::Linear(()), Extrapolation::Constant(())
        ) == 11,
        'invalid extrapolation'
    );
    assert(
        interpolate(
            9, xs.span(), ys.span(), Interpolation::Linear(()), Extrapolation::Constant(())
        ) == 17,
        'invalid extrapolation'
    );
    assert(
        interpolate(
            0, xs.span(), ys.span(), Interpolation::Linear(()), Extrapolation::Null(())
        ) == 0,
        'invalid extrapolation'
    );
    assert(
        interpolate(
            9, xs.span(), ys.span(), Interpolation::Linear(()), Extrapolation::Null(())
        ) == 0,
        'invalid extrapolation'
    );
}

#[test]
#[available_gas(2000000)]
fn interp_linear_test() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    xs.append(5);
    xs.append(7);
    let mut ys = ArrayTrait::<u64>::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(
        interpolate(
            4, xs.span(), ys.span(), Interpolation::Linear(()), Extrapolation::Constant(())
        ) == 12,
        'invalid interpolation'
    );
    assert(
        interpolate(
            4, xs.span(), ys.span(), Interpolation::Linear(()), Extrapolation::Constant(())
        ) == 12,
        'invalid interpolation'
    );
}

#[test]
#[available_gas(2000000)]
fn interp_nearest_test() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    xs.append(5);
    xs.append(8);
    let mut ys = ArrayTrait::<u64>::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(
        interpolate(
            4, xs.span(), ys.span(), Interpolation::Nearest(()), Extrapolation::Constant(())
        ) == 11,
        'invalid interpolation'
    );
    assert(
        interpolate(
            6, xs.span(), ys.span(), Interpolation::Nearest(()), Extrapolation::Constant(())
        ) == 13,
        'invalid interpolation'
    );
    assert(
        interpolate(
            7, xs.span(), ys.span(), Interpolation::Nearest(()), Extrapolation::Constant(())
        ) == 17,
        'invalid interpolation'
    );
}

#[test]
#[available_gas(2000000)]
fn interp_constant_left_test() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    xs.append(5);
    xs.append(8);
    let mut ys = ArrayTrait::<u64>::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(
        interpolate(
            4, xs.span(), ys.span(), Interpolation::ConstantLeft(()), Extrapolation::Constant(())
        ) == 13,
        'invalid interpolation'
    );
    assert(
        interpolate(
            6, xs.span(), ys.span(), Interpolation::ConstantLeft(()), Extrapolation::Constant(())
        ) == 17,
        'invalid interpolation'
    );
    assert(
        interpolate(
            7, xs.span(), ys.span(), Interpolation::ConstantLeft(()), Extrapolation::Constant(())
        ) == 17,
        'invalid interpolation'
    );
}

#[test]
#[available_gas(2000000)]
fn interp_constant_right_test() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    xs.append(5);
    xs.append(8);
    let mut ys = ArrayTrait::<u64>::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(
        interpolate(
            4, xs.span(), ys.span(), Interpolation::ConstantRight(()), Extrapolation::Constant(())
        ) == 11,
        'invalid interpolation'
    );
    assert(
        interpolate(
            6, xs.span(), ys.span(), Interpolation::ConstantRight(()), Extrapolation::Constant(())
        ) == 13,
        'invalid interpolation'
    );
    assert(
        interpolate(
            7, xs.span(), ys.span(), Interpolation::ConstantRight(()), Extrapolation::Constant(())
        ) == 13,
        'invalid interpolation'
    );
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn interp_revert_len_mismatch() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    xs.append(5);
    let mut ys = ArrayTrait::<u64>::new();
    ys.append(11);
    interpolate(4, xs.span(), ys.span(), Interpolation::Linear(()), Extrapolation::Constant(()));
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn interp_revert_len_too_short() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    let mut ys = ArrayTrait::<u64>::new();
    ys.append(11);
    interpolate(4, xs.span(), ys.span(), Interpolation::Linear(()), Extrapolation::Constant(()));
}
