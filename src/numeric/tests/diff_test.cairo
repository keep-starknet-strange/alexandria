use array::ArrayTrait;
use alexandria::numeric::diff::diff;

#[test]
#[available_gas(2000000)]
fn diff_test() {
    let xs = array![3, 5, 7];
    let ys = diff(xs.span());
    assert(*ys[0] == 0_u256, 'wrong value at index 0');
    assert(*ys[1] == *xs[1] - *xs[0], 'wrong value at index 1');
    assert(*ys[2] == *xs[2] - *xs[1], 'wrong value at index 2');
}

#[test]
#[should_panic(expected: ('Sequence must be sorted', ))]
#[available_gas(2000000)]
fn diff_test_revert_not_sorted() {
    let xs: Array<u128> = array![3, 2];
    let ys = diff(xs.span());
}

#[test]
#[should_panic(expected: ('Array must have at least 1 elt', ))]
#[available_gas(2000000)]
fn diff_test_revert_empty() {
    let xs: Array<u128> = array![];
    let ys = diff(xs.span());
}
