use alexandria_math::fast_power::fast_power;

#[test]
#[available_gas(1000000000)]
fn fast_power_test() {
    assert(fast_power(2, 1, 17) == 2, 'invalid result');
    assert(fast_power(2, 2, 17) == 4, 'invalid result');
    assert(fast_power(2, 3, 17) == 8, 'invalid result');
    assert(fast_power(3, 4, 17) == 13, 'invalid result');
    assert(fast_power(2, 100, 1000000007) == 976371285, 'invalid result');
}
