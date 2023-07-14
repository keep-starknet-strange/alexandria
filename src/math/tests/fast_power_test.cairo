use alexandria::math::fast_power::fast_power;

#[test]
#[available_gas(1000000000)]
fn fast_power_test() {
    assert(fast_power(2, 1, 17) == 2, 'invalid result');
    assert(fast_power(2, 2, 17) == 4, 'invalid result');
    assert(fast_power(2, 3, 17) == 8, 'invalid result');
    assert(fast_power(3, 4, 17) == 13, 'invalid result');
    assert(fast_power(2, 100, 1000000007) == 976371285, 'invalid result');
    assert(
        fast_power(
            2, 127, 340282366920938463463374607431768211454
        ) == 170141183460469231731687303715884105728,
        'invalid result'
    );
    assert(fast_power(2, 127, 34028236692093846346337460743176821144) == 8, 'invalid result');

    assert(fast_power(2, 128, 9299) == 1412, 'invalid result');

    assert(
        fast_power(2, 88329, 34028236692093846346337460743176821144) == 2199023255552,
        'invalid result'
    );
}
