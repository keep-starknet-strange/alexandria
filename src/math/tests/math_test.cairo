use alexandria::math::{pow, math::BitShift, count_digits_of_base};

// Test power function
#[test]
#[available_gas(2000000)]
fn pow_test() {
    assert(pow(2, 0) == 1, 'invalid result');
    assert(pow(2, 1) == 2, 'invalid result');
    assert(pow(2, 12) == 4096, 'invalid result');
    assert(pow(5, 9) == 1953125, 'invalid result');
}

// Test counting of number of digits function
#[test]
#[available_gas(2000000)]
fn count_digits_of_base_test() {
    assert(count_digits_of_base(0, 10) == 0, 'invalid result');
    assert(count_digits_of_base(2, 10) == 1, 'invalid result');
    assert(count_digits_of_base(10, 10) == 2, 'invalid result');
    assert(count_digits_of_base(100, 10) == 3, 'invalid result');
    assert(count_digits_of_base(0x80, 16) == 2, 'invalid result');
    assert(count_digits_of_base(0x800, 16) == 3, 'invalid result');
    assert(count_digits_of_base(0x888888888888888888, 16) == 18, 'invalid result');
}

// Test fast power function
#[test]
#[available_gas(2000000)]
fn fpow_test() {
    assert(BitShift::fpow(3_u128, 8) == 6561, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn fpow_test_u2156() {
    assert(BitShift::fpow(3_u256, 8) == 6561, 'invalid result');
}
