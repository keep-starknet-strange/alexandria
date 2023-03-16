//! # Karatsuba Multiplication.

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;
// Internal imports.
use quaireaux::utils;

/// Algorithm to multiply two numbers in O(n^1.6) running time
/// # Arguments
/// * `x` - First number to multiply.
/// * `y` - Second number to multiply.
/// # Returns
/// * `felt252` - The product between x and y
fn multiply(x: felt252, y: felt252) -> felt252 {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if x < 10 {
        return x * y;
    }

    if y < 10 {
        return x * y;
    }

    let max_digit_counts = utils::max(
        utils::count_digits_of_base(x, 10), utils::count_digits_of_base(y, 10)
    );
    let middle_idx = _div_half_ceil(max_digit_counts);
    let (x1, x0) = _split_number(x, middle_idx);
    let (y1, y0) = _split_number(y, middle_idx);

    let z0 = multiply(x0, y0);
    let z1 = multiply(x1, y1);
    let z2 = multiply(x0 + x1, y0 + y1);

    return z0 + (z2 - z0 - z1) * utils::pow(10, middle_idx) + z1 * utils::pow(10, 2 * middle_idx);
}

/// Helper function for 'multiply', divides an integer in half and rounds up strictly.
/// # Arguments
/// * `num` - The current value to be divided.
/// # Returns
/// * `felt252` - Half (rounded up) of num.
fn _div_half_ceil(num: felt252) -> felt252 {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    let (q, r) = utils::unsafe_euclidean_div(num, 2);
    if r != 0 {
        let (q, _) = utils::unsafe_euclidean_div((num + 1), 2);
    }
    return q;
}

/// Helper function for 'multiply',splits a number at the indicated index and returns it in a tuple.
/// # Arguments
/// * `num` - The current value to be splited.
/// * `split_idx` - Index at which the number will be split
/// # Returns
/// * `(felt252, felt252)` -tuple representing the split number.
fn _split_number(num: felt252, split_idx: felt252) -> (felt252, felt252) {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    let divisor = utils::pow(10, split_idx);
    let (q, r) = utils::unsafe_euclidean_div(num, divisor);
    (q, r)
}
