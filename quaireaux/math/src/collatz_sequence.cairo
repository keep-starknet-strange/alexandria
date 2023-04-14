//! # Collatz Sequence
use array::ArrayTrait;

use quaireaux_utils::check_gas;

use quaireaux_math::unsafe_euclidean_div;

/// Generates the Collatz sequence for a given number.
/// # Arguments
/// * `number` - The number to generate the Collatz sequence for.
/// # Returns
/// * `Array` - The Collatz sequence as an array of `felt252` numbers.
fn sequence(mut number: felt252) -> Array<felt252> {
    let mut arr = ArrayTrait::new();
    if number == 0 {
        return arr;
    }

    loop {
        check_gas();

        arr.append(number);
        if number == 1 {
            break ();
        }
        
        let (q, r) = unsafe_euclidean_div(number, 2);
        if r == 0 {
            number = q;
        } else {
            number = 3 * number + 1;
        };
    };
    arr
}
