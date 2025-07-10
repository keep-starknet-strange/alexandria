/// Calculate fibonacci sequence value at the nth position
///
/// This function computes the fibonacci number at position n using a recursive approach.
/// The sequence starts with the provided initial values a and b, and continues according
/// to the fibonacci rule where each number is the sum of the two preceding ones.
///
/// #### Arguments
/// * `a` - The first number in the sequence (F₀)
/// * `b` - The second number in the sequence (F₁)
/// * `n` - The position in the sequence to calculate (0-indexed)
///
/// #### Returns
/// * `felt252` - The nth number in the fibonacci sequence
pub fn fib(a: felt252, b: felt252, n: felt252) -> felt252 {
    match n {
        0 => a,
        _ => fib(b, a + b, n - 1),
    }
}
