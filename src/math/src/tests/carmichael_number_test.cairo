use alexandria_math::carmichael_number::is_carmichael_number;

#[test]
#[available_gas(500000)]
fn carmichael_number_test_1() {
    assert(is_carmichael_number(4) == false, 'invalid result');
}

#[test]
#[available_gas(500000000)]
fn carmichael_number_test_2() {
    assert(is_carmichael_number(561) == true, 'invalid result');
}
