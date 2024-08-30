use alexandria_math::karatsuba::multiply;

#[test]
fn multiply_distinct_size_positive_number() {
    let n1 = 10296;
    let n2 = 25912511;
    let result = 266795213256;
    assert_eq!(multiply(n1, n2), result);
}

#[test]
fn multiply_by_number_lt_ten() {
    let n1 = 1000;
    let n2 = 2;
    let result = 2000;
    assert_eq!(multiply(n1, n2), result);
}
