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
/// * `felt` - The product between x and y
fn multiply(x: felt, y: felt) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match get_gas() {
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

    let max_digit_counts = utils::max(utils::count_digits(x), utils::count_digits(y));
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
/// * `felt` - Half (rounded up) of num.
fn _div_half_ceil(num: felt) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    let (q, r) = utils::unsafe_euclidean_div(num, 2);
    if r != 0 {
        let (q, _) = utils::unsafe_euclidean_div((num + 1),  2);
    }
    return q;
}

/// Helper function for 'multiply',splits a number at the indicated index and returns it in a tuple.
/// # Arguments
/// * `num` - The current value to be splited.
/// * `split_idx` - Index at which the number will be split
/// # Returns
/// * `(felt, felt)` -tuple representing the split number.
fn _split_number(num: felt, split_idx: felt) -> (felt, felt) {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match get_gas() {
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