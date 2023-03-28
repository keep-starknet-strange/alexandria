use quaireaux::math::fibonacci;

#[test]
#[available_gas(200000)]
fn fibonacci_test() {
    assert(fibonacci::fib(0, 1, 10) == 55, 'invalid result');
    assert(fibonacci::fib(2, 4, 8) == 110, 'invalid result');
}
