// Core library imports.
use array::ArrayTrait;

use alexandria_linalg::dot::dot;

#[test]
#[available_gas(2000000)]
fn dot_product_test() {
    let mut xs = ArrayTrait::new();
    xs.append(1);
    xs.append(2);
    xs.append(3);
    let mut ys = ArrayTrait::new();
    ys.append(30);
    ys.append(20);
    ys.append(10);
    assert(dot(xs, ys) == 100, 'invalid dot product');
}

#[test]
#[available_gas(2000000)]
fn dot_product_test_check_len() {
    let mut xs = ArrayTrait::new();
    xs.append(1);
    let mut ys = ArrayTrait::new();
    dot(xs, ys);
}
