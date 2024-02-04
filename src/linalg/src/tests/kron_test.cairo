use alexandria_linalg::kron::{kron, KronError};

#[test]
#[available_gas(2000000)]
fn kron_product_test() {
    let xs = array![1_u64, 10, 100];
    let ys = array![5, 6, 7];
    let zs = kron(xs.span(), ys.span()).unwrap();
    assert_eq!(*zs[0], 5, "wrong value at index 0");
    assert_eq!(*zs[1], 6, "wrong value at index 1");
    assert_eq!(*zs[2], 7, "wrong value at index 2");
    assert_eq!(*zs[3], 50, "wrong value at index 3");
    assert_eq!(*zs[4], 60, "wrong value at index 4");
    assert_eq!(*zs[5], 70, "wrong value at index 5");
    assert_eq!(*zs[6], 500, "wrong value at index 6");
    assert_eq!(*zs[7], 600, "wrong value at index 7");
    assert_eq!(*zs[8], 700, "wrong value at index 8");
}

#[test]
#[available_gas(2000000)]
fn kron_product_test_check_len() {
    let xs = array![1_u64];
    let ys = array![];
    assert(
        kron(xs.span(), ys.span()) == Result::Err(KronError::UnequalLength),
        'Arrays must have the same len'
    );
}
