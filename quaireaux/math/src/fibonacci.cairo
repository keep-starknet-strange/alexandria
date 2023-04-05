use quaireaux_utils::check_gas;

// Calculate fibonnaci
// # Arguments
// * `a` - The first number in the sequence
// * `b` - The second number in the sequence
// * `n` - The number of times to iterate
// # Returns
// * `felt252` - The nth number in the sequence
fn fib(a: felt252, b: felt252, n: felt252) -> felt252 {
    check_gas();

    match n {
        0 => a,
        _ => fib(b, a + b, n - 1),
    }
}
