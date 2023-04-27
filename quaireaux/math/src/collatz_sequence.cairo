//! # Collatz Sequence
use array::ArrayTrait;

use quaireaux_utils::check_gas;

/// Generates the Collatz sequence for a given number.
/// # Arguments
/// * `number` - The number to generate the Collatz sequence for.
/// # Returns
/// * `Array` - The Collatz sequence as an array of `felt252` numbers.
fn sequence(mut number: u128) -> Array<u128> {
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

        if number % 2 == 0 {
            number = number / 2;
        } else {
            number = 3 * number + 1;
        };
    };
    arr
}
