use quaireaux::math::karatsuba;

#[test]
#[available_gas(10000000)]
fn multiply_same_size_positive_number() {
    let n1 = 31415;
    let n2 = 31415;
    let result = 986902225;
    assert(karatsuba::multiply(n1, n2) == result, 'invalid result');
}

#[test]
#[available_gas(10000000)]
fn multiply_distinct_size_positive_number() {
    let n1 = 10296;
    let n2 = 25912511;
    let result = 266795213256;
    assert(karatsuba::multiply(n1, n2) == result, 'invalid result');
}

#[test]
#[available_gas(200000)]
fn multiply_by_zero() {
    let n1 = 10296;
    let n2 = 0;
    let result = 0;
    assert(karatsuba::multiply(n1, n2) == result, 'invalid result');
}

#[test]
#[available_gas(200000)]
fn multiply_by_number_lt_ten() {
    let n1 = 1000;
    let n2 = 2;
    let result = 2000;
    assert(karatsuba::multiply(n1, n2) == result, 'invalid result');
}
