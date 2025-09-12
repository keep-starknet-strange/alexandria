use alexandria_math::fibonacci::fib;

#[test]
fn fibonacci_test() {
    assert!(fib(0, 1, 10) == 55);
    assert!(fib(2, 4, 8) == 110);
}
