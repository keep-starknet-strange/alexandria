use alexandria_math::lcm_of_n_numbers::lcm;

#[test]
#[available_gas(1000000000)]
fn gcd_test() {
    let arr = array![2, 4, 6, 8, 10];
    assert(lcm(arr.span()) == 120, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn gcd_test_inverse() {
    let arr = array![10, 8, 6, 4, 2];
    assert(lcm(arr.span()) == 120, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn gcd_test_3() {
    let arr = array![3, 6, 12, 99];
    assert(lcm(arr.span()) == 396, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn gcd_test_4() {
    let arr = array![1, 2, 8, 3];
    assert(lcm(arr.span()) == 24, 'invalid result');
}


#[test]
#[available_gas(1000000000)]
fn gcd_single_test() {
    let arr = array![10];
    assert(lcm(arr.span()) == 10, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
#[should_panic(expected: ('EI',))]
fn gcd_empty_input_test() {
    let mut arr = array![];
    lcm(arr.span());
}
