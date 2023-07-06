use alexandria::math::fibonacci::fib;

#[test]
#[available_gas(200000)]
fn fibonacci_test() {
    assert(fib(0, 1, 10) == 55, 'invalid result');
    assert(fib(2, 4, 8) == 110, 'invalid result');
}
