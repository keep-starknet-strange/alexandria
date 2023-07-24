use array::ArrayTrait;
use alexandria::numeric::trapezoidal_rule::trapezoidal_rule;

#[test]
#[available_gas(2000000)]
fn trapezoidal_rule_test() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    xs.append(5);
    xs.append(7);
    let mut ys = ArrayTrait::<u64>::new();
    ys.append(11);
    ys.append(13);
    ys.append(17);
    assert(trapezoidal_rule(xs.span(), ys.span()) == 54, 'invalid integral');
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn trapezoidal_rule_test_revert_len_mismatch() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    let mut ys = ArrayTrait::<u64>::new();
    trapezoidal_rule(xs.span(), ys.span());
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn trapezoidal_rule_test_revert_len_too_short() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(3);
    let mut ys = ArrayTrait::<u64>::new();
    ys.append(11);
    trapezoidal_rule(xs.span(), ys.span());
}

#[test]
#[should_panic]
#[available_gas(2000000)]
fn trapezoidal_rule_test_revert_not_sorted() {
    let mut xs = ArrayTrait::<u64>::new();
    xs.append(5);
    xs.append(3);
    let mut ys = ArrayTrait::<u64>::new();
    ys.append(11);
    ys.append(13);
    trapezoidal_rule(xs.span(), ys.span());
}
