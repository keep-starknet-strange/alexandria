use alexandria_math::fibonacci::fib;

#[test]
#[available_gas(200000)]
fn fibonacci_test() {
    assert_eq!(fib(0, 1, 10), 55);
    assert_eq!(fib(2, 4, 8), 110);
}
