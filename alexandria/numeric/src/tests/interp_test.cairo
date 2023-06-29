// Core library imports.
use array::ArrayTrait;

use alexandria_numeric::interp::{interp, Interpolation, Extrapolation};

#[test]
#[available_gas(2000000)]
fn interp_extrapolation_test() {
    let mut xs = ArrayTrait::new();
    xs.append(3);
    xs.append(5);
    xs.append(7);
    let mut ys = ArrayTrait::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(
        interp(0, @xs, @ys, Interpolation::Linear(()), Extrapolation::Constant(())) == 11,
        'invalid extrapolation'
    );
    assert(
        interp(9, @xs, @ys, Interpolation::Linear(()), Extrapolation::Constant(())) == 17,
        'invalid extrapolation'
    );
    assert(
        interp(0, @xs, @ys, Interpolation::Linear(()), Extrapolation::Null(())) == 0,
        'invalid extrapolation'
    );
    assert(
        interp(9, @xs, @ys, Interpolation::Linear(()), Extrapolation::Null(())) == 0,
        'invalid extrapolation'
    );
}

#[test]
#[available_gas(2000000)]
fn interp_linear_test() {
    let mut xs = ArrayTrait::new();
    xs.append(3);
    xs.append(5);
    xs.append(7);
    let mut ys = ArrayTrait::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(
        interp(4, @xs, @ys, Interpolation::Linear(()), Extrapolation::Constant(())) == 12,
        'invalid interpolation'
    );
    assert(
        interp(4, @xs, @ys, Interpolation::Linear(()), Extrapolation::Constant(())) == 12,
        'invalid interpolation'
    );
}

#[test]
#[available_gas(2000000)]
fn interp_nearest_test() {
    let mut xs = ArrayTrait::new();
    xs.append(3);
    xs.append(5);
    xs.append(8);
    let mut ys = ArrayTrait::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(
        interp(4, @xs, @ys, Interpolation::Nearest(()), Extrapolation::Constant(())) == 11,
        'invalid interpolation'
    );
    assert(
        interp(6, @xs, @ys, Interpolation::Nearest(()), Extrapolation::Constant(())) == 13,
        'invalid interpolation'
    );
    assert(
        interp(7, @xs, @ys, Interpolation::Nearest(()), Extrapolation::Constant(())) == 17,
        'invalid interpolation'
    );
}

#[test]
#[available_gas(2000000)]
fn interp_constant_left_test() {
    let mut xs = ArrayTrait::new();
    xs.append(3);
    xs.append(5);
    xs.append(8);
    let mut ys = ArrayTrait::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(
        interp(4, @xs, @ys, Interpolation::ConstantLeft(()), Extrapolation::Constant(())) == 13,
        'invalid interpolation'
    );
    assert(
        interp(6, @xs, @ys, Interpolation::ConstantLeft(()), Extrapolation::Constant(())) == 17,
        'invalid interpolation'
    );
    assert(
        interp(7, @xs, @ys, Interpolation::ConstantLeft(()), Extrapolation::Constant(())) == 17,
        'invalid interpolation'
    );
}

#[test]
#[available_gas(2000000)]
fn interp_constant_right_test() {
    let mut xs = ArrayTrait::new();
    xs.append(3);
    xs.append(5);
    xs.append(8);
    let mut ys = ArrayTrait::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(
        interp(4, @xs, @ys, Interpolation::ConstantRight(()), Extrapolation::Constant(())) == 11,
        'invalid interpolation'
    );
    assert(
        interp(6, @xs, @ys, Interpolation::ConstantRight(()), Extrapolation::Constant(())) == 13,
        'invalid interpolation'
    );
    assert(
        interp(7, @xs, @ys, Interpolation::ConstantRight(()), Extrapolation::Constant(())) == 13,
        'invalid interpolation'
    );
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn interp_revert_len_mismatch() {
    let mut xs = ArrayTrait::new();
    xs.append(3);
    xs.append(5);
    let mut ys = ArrayTrait::new();
    ys.append(11);
    interp(4, @xs, @ys, Interpolation::Linear(()), Extrapolation::Constant(()));
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn interp_revert_len_too_short() {
    let mut xs = ArrayTrait::new();
    xs.append(3);
    let mut ys = ArrayTrait::new();
    ys.append(11);
    interp(4, @xs, @ys, Interpolation::Linear(()), Extrapolation::Constant(()));
}
