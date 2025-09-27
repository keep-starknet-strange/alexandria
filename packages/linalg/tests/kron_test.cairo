use alexandria_linalg::kron::{KronError, kron};

#[test]
fn kron_product_test() {
    let xs = array![1_u64, 10, 100];
    let ys = array![5, 6, 7];
    let zs = kron(xs.span(), ys.span()).unwrap();
    assert!(*zs[0] == 5);
    assert!(*zs[1] == 6);
    assert!(*zs[2] == 7);
    assert!(*zs[3] == 50);
    assert!(*zs[4] == 60);
    assert!(*zs[5] == 70);
    assert!(*zs[6] == 500);
    assert!(*zs[7] == 600);
    assert!(*zs[8] == 700);
}

#[test]
fn kron_product_test_check_len() {
    let xs = array![1_u64];
    let ys = array![];
    assert!(kron(xs.span(), ys.span()) == Result::Err(KronError::UnequalLength));
}
