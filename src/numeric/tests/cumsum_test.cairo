use array::ArrayTrait;
use alexandria::numeric::cumsum::cumsum;

#[test]
#[available_gas(2000000)]
fn cumsum_test() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    xs.append(5);
    xs.append(7);
    let ys = cumsum(xs.span());
    assert(*ys[0] == *xs[0], 'wrong value at index 0');
    assert(*ys[1] == *xs[0] + *xs[1], 'wrong value at index 1');
    assert(*ys[2] == *xs[0] + *xs[1] + *xs[2], 'wrong value at index 2');
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn cumsum_test_revert_empty() {
    let mut xs = ArrayTrait::<u64>::new();
    let ys = cumsum(xs.span());
}
