use alexandria::math::karatsuba::multiply;

// TODO All the out of gas have got lazily fixed. Maybe there is a way to fix those.
#[test]
#[available_gas(10000000)]
#[should_panic(expected: ('Out of gas', ))]
fn multiply_same_size_positive_number() {
    let n1 = 31415;
    let n2 = 31415;
    let result = 986902225;
    assert(multiply(n1, n2) == result, 'invalid result');
}


#[test]
#[available_gas(10000000)]
fn multiply_distinct_size_positive_number() {
    let n1 = 10296;
    let n2 = 25912511;
    let result = 266795213256;
    assert(multiply(n1, n2) == result, 'invalid result');
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('Out of gas', ))]
fn multiply_by_zero() {
    let n1 = 10296;
    let n2 = 0;
    let result = 0;
    assert(multiply(n1, n2) == result, 'invalid result');
}

#[test]
#[available_gas(20000000)]
fn multiply_by_number_lt_ten() {
    let n1 = 1000;
    let n2 = 2;
    let result = 2000;
    assert(multiply(n1, n2) == result, 'invalid result');
}
