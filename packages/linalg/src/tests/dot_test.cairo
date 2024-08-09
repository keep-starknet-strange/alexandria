use alexandria_linalg::dot::dot;

#[test]
#[available_gas(2000000)]
fn dot_product_test() {
    let xs = array![3_u64, 5, 7];
    let ys = array![11, 13, 17];
    assert_eq!(dot(xs.span(), ys.span()), 217);
}

#[test]
#[should_panic(expected: ('Arrays must have the same len',))]
#[available_gas(2000000)]
fn dot_product_test_check_len() {
    let xs = array![1_u64];
    let ys = array![];
    dot(xs.span(), ys.span());
}
