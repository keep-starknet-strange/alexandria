use alexandria_linalg::kron::{kron, KronError};

#[test]
#[available_gas(2000000)]
fn kron_product_test() {
    let mut xs: Array<u64> = array![1, 10, 100];
    let mut ys = array![5, 6, 7];
    let zs = kron(xs.span(), ys.span()).unwrap();
    assert(*zs[0] == 5, 'wrong value at index 0');
    assert(*zs[1] == 6, 'wrong value at index 1');
    assert(*zs[2] == 7, 'wrong value at index 2');
    assert(*zs[3] == 50, 'wrong value at index 3');
    assert(*zs[4] == 60, 'wrong value at index 4');
    assert(*zs[5] == 70, 'wrong value at index 5');
    assert(*zs[6] == 500, 'wrong value at index 6');
    assert(*zs[7] == 600, 'wrong value at index 7');
    assert(*zs[8] == 700, 'wrong value at index 8');
}

#[test]
#[available_gas(2000000)]
fn kron_product_test_check_len() {
    let mut xs: Array<u64> = array![1];
    let mut ys = array![];
    assert(
        kron(xs.span(), ys.span()) == Result::Err(KronError::UnequalLength),
        'Arrays must have the same len'
    );
}
