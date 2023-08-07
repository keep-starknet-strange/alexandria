use array::ArrayTrait;
use alexandria::math::gcd_of_n_numbers::gcd;

#[test]
#[available_gas(1000000000)]
fn gcd_test() {
    let arr = array![2, 4, 6, 8, 10];
    assert(gcd(arr.span()) == 2, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn gcd_test_inverse() {
    let arr = array![10, 8, 6, 4, 2];
    assert(gcd(arr.span()) == 2, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn gcd_test_3() {
    let arr = array![3, 6, 12, 99];
    assert(gcd(arr.span()) == 3, 'invalid result');
}


#[test]
#[available_gas(1000000000)]
fn gcd_single_test() {
    let arr = array![10];
    assert(gcd(arr.span()) == 10, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
#[should_panic(expected: ('EI', ))]
fn gcd_empty_input_test() {
    let mut arr = array![];
    gcd(arr.span());
}
