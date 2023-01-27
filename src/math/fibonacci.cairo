// Calculate fibonnaci
// # Arguments
// * `a` - The first number in the sequence
// * `b` - The second number in the sequence
// * `n` - The number of times to iterate
// # Returns
// * `felt` - The nth number in the sequence
fn fib(a: felt, b: felt, n: felt) -> felt {
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = array_new::<felt>();
            array_append::<felt>(ref data, 'OOG');
            panic(data);
        },
    }
    match n {
        0 => a,
        _ => fib(b, a + b, n - 1),
    }
}
