use alexandria_numeric::cumprod::cumprod;

#[test]
fn cumprod_test() {
    let xs: Array<u64> = array![3, 5, 7];
    let ys = cumprod(xs.span());
    assert_eq!(*ys[0], *xs[0]);
    assert_eq!(*ys[1], *xs[0] * *xs[1]);
    assert_eq!(*ys[2], *xs[0] * *xs[1] * *xs[2]);
}

#[test]
#[should_panic(expected: ('Array must have at least 1 elt',))]
fn cumprod_test_revert_empty() {
    let xs: Array<u64> = array![];
    cumprod(xs.span());
}
