use array::ArrayTrait;
use alexandria::linalg::dot::dot;

#[test]
#[available_gas(2000000)]
fn dot_product_test() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    xs.append(5);
    xs.append(7);
    let mut ys = ArrayTrait::<u64>::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(dot(xs.span(), ys.span()) == 217, 'invalid dot product');
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn dot_product_test_check_len() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(1);
    let mut ys = ArrayTrait::<u64>::new();
    dot(xs.span(), ys.span());
}
