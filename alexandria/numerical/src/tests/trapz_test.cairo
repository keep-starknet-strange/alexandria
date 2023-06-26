// Core library imports.
use array::ArrayTrait;

use alexandria_numerical::trapz::trapz;

#[test]
#[available_gas(2000000)]
fn trapz_test() {
    let mut xs = ArrayTrait::new();
    xs.append(1);
    xs.append(2);
    xs.append(3);
    let mut ys = ArrayTrait::new();
    ys.append(30);
    ys.append(20);
    ys.append(10);
    assert(trapz(xs, ys) == 40, 'invalid integral');
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn trapz_test_check_len() {
    let mut xs = ArrayTrait::new();
    xs.append(1);
    let mut ys = ArrayTrait::new();
    trapz(xs, ys);
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn trapz_test_check_size() {
    let mut xs = ArrayTrait::new();
    xs.append(1);
    let mut ys = ArrayTrait::new();
    ys.append(30);
    trapz(xs, ys);
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn trapz_test_check_sorted() {
    let mut xs = ArrayTrait::new();
    xs.append(2);
    xs.append(1);
    let mut ys = ArrayTrait::new();
    ys.append(30);
    ys.append(20);
    trapz(xs, ys);
}
