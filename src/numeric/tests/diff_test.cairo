use array::ArrayTrait;
use alexandria::numeric::diff::diff;

#[test]
#[available_gas(2000000)]
fn diff_test() {
    let mut xs = ArrayTrait::<u256>::new();
    xs.append(3);
    xs.append(5);
    xs.append(7);
    let ys = diff(xs.span());
    assert(*ys[0] == 0_u256, 'wrong value at index 0');
    assert(*ys[1] == *xs[1] - *xs[0], 'wrong value at index 1');
    assert(*ys[2] == *xs[2] - *xs[1], 'wrong value at index 2');
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn diff_test_revert_not_sorted() {
    let mut xs = ArrayTrait::<u128>::new();
    xs.append(3);
    xs.append(2);
    let ys = diff(xs.span());
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn diff_test_revert_empty() {
    let mut xs = ArrayTrait::<u8>::new();
    let ys = diff(xs.span());
}
