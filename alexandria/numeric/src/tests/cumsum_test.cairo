// Core library imports.
use array::ArrayTrait;

use alexandria_numeric::cumsum::cumsum;

#[test]
#[available_gas(2000000)]
fn cumsum_test() {
    let mut xs = ArrayTrait::new();
    xs.append(3);
    xs.append(5);
    xs.append(7);
    let ys = cumsum(@xs);
    assert(*ys.at(0) == *xs.at(0), 'wrong value at index 0');
    assert(*ys.at(1) == *xs.at(0) + *xs.at(1), 'wrong value at index 1');
    assert(*ys.at(2) == *xs.at(0) + *xs.at(1) + *xs.at(2), 'wrong value at index 2');
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn cumsum_test_revert_empty() {
    let mut xs = ArrayTrait::new();
    let ys = cumsum(@xs);
}
