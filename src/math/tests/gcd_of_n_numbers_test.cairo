use array::ArrayTrait;
use alexandria::math::gcd_of_n_numbers::gcd;

#[test]
#[available_gas(1000000000)]
fn gcd_test() {
    let mut arr = ArrayTrait::new();
    arr.append(2);
    arr.append(4);
    arr.append(6);
    arr.append(8);
    arr.append(10);
    assert(gcd(arr.span()) == 2, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn gcd_test_inverse() {
    let mut arr = ArrayTrait::new();
    arr.append(10);
    arr.append(8);
    arr.append(6);
    arr.append(6);
    arr.append(4);
    assert(gcd(arr.span()) == 2, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn gcd_test_3() {
    let mut arr = ArrayTrait::new();
    arr.append(3);
    arr.append(6);
    arr.append(12);
    arr.append(99);
    assert(gcd(arr.span()) == 3, 'invalid result');
}


#[test]
#[available_gas(1000000000)]
fn gcd_single_test() {
    let mut arr = ArrayTrait::new();
    arr.append(10);
    assert(gcd(arr.span()) == 10, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
#[should_panic(expected: ('EI', ))]
fn gcd_empty_input_test() {
    let mut arr = ArrayTrait::new();
    gcd(arr.span());
}
