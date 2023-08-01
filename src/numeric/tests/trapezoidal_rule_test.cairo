use array::ArrayTrait;
use alexandria::numeric::trapezoidal_rule::trapezoidal_rule;

#[test]
#[available_gas(2000000)]
fn trapezoidal_rule_test() {
    let xs: Array::<u64> = array![3, 5, 7];
    let ys = array![11, 13, 17];
    assert(trapezoidal_rule(xs.span(), ys.span()) == 54, 'invalid integral');
}

#[test]
#[should_panic(expected: ('Arrays must have the same len', ))]
#[available_gas(2000000)]
fn trapezoidal_rule_test_revert_len_mismatch() {
    let xs: Array::<u64> = array![3];
    let mut ys = array![];
    trapezoidal_rule(xs.span(), ys.span());
}

#[test]
#[should_panic(expected: ('Array must have at least 2 elts', ))]
#[available_gas(2000000)]
fn trapezoidal_rule_test_revert_len_too_short() {
    let xs: Array::<u64> = array![3];
    let mut ys = array![11];
    trapezoidal_rule(xs.span(), ys.span());
}

#[test]
#[should_panic(expected: ('Abscissa must be sorted', ))]
#[available_gas(2000000)]
fn trapezoidal_rule_test_revert_not_sorted() {
    let xs: Array::<u64> = array![5, 3];
    let ys = array![11, 13];
    trapezoidal_rule(xs.span(), ys.span());
}
