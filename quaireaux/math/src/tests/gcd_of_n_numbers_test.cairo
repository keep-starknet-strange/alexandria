use array::ArrayTrait;
use math::gcd_of_n_numbers;

#[test]
#[available_gas(1000000000)]
fn gcd_test() {
    let mut arr = ArrayTrait::new();
    arr.append(2);
    arr.append(4);
    arr.append(6);
    arr.append(8);
    arr.append(10);
    assert(gcd_of_n_numbers::gcd(ref arr) == 2, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn gcd_single_test() {
    let mut arr = ArrayTrait::new();
    arr.append(10);
    assert(gcd_of_n_numbers::gcd(ref arr) == 10, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
#[should_panic]
fn gcd_empty_input_test() {
    let mut arr = ArrayTrait::new();
    gcd_of_n_numbers::gcd(ref arr);
}
