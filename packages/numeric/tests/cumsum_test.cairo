use alexandria_numeric::cumsum::cumsum;


#[test]
fn cumsum_test() {
    let xs: Array<u64> = array![3, 5, 7];
    let ys = cumsum(xs.span());
    assert!(*ys[0] == *xs[0]);
    assert!(*ys[1] == *xs[0] + *xs[1]);
    assert!(*ys[2] == *xs[0] + *xs[1] + *xs[2]);
}

#[test]
#[should_panic(expected: ('Array must have at least 1 elt',))]
fn cumsum_test_revert_empty() {
    let xs: Array<u64> = array![];
    cumsum(xs.span());
}
