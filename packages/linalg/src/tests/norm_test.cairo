use alexandria_linalg::norm::norm;

#[test]
#[available_gas(2000000)]
fn norm_test_1() {
    let array = array![3_u128, 4];
    assert_eq!(norm(array.span(), 2, 10), 5);
}

#[test]
#[available_gas(2000000)]
fn norm_test_2() {
    let array = array![3_u128, 4];
    assert_eq!(norm(array.span(), 1, 10), 7);
}

#[test]
#[available_gas(2000000)]
fn norm_test_3() {
    let array = array![3_u128, 4];
    assert_eq!(norm(array.span(), 0, 10), 2);
}

#[test]
#[available_gas(2000000)]
fn norm_test_into() {
    let array = array![3_u32, 4];
    assert_eq!(norm(array.span(), 2, 10), 5);
}
