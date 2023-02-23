//! # Amicable Numbers.

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;

// Internal imports.
use quaireaux::utils;

/// Algorithm to find amicable pairs under a specified number
/// # Arguments
/// * `num` - The maximum number to check for amicable pairs.
/// # Returns
/// * `Array` - An array of tuples representing amicable pairs under num.
fn amicable_pairs_under_n(num: felt) -> Array::<(felt, felt)> {
    let mut results = ArrayTrait::<(felt, felt)>::new();
    let index = 1;
    _amicable_pairs_under_n(num, index, results)
}

/// Recursive helper function to find amicable pairs under a specified number.
/// # Arguments
/// * `num` - The maximum number to consider in the search for amicable pairs.
/// * `index` - The current index in the search for amicable pairs.
/// * `arr` - The running list of amicable pairs found so far.
/// # Returns
/// * `None` - This function does not return a value, it updates the arr argument in place.
fn _amicable_pairs_under_n(num: felt, index: felt, mut arr: Array::<(felt, felt)>) -> Array::<(felt, felt)> {
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

    if index > num {
        return arr;
    }

    let sum_1 = sum_of_divisors(index);
    let sum_2 = sum_of_divisors(sum_1);

    if sum_2 == index & index != sum_1 {
        arr.append((index, sum_1));
    }
    _amicable_pairs_under_n(num, index + 1, arr)
}

/// Algorithm to calculate the sum of divisors of a number
/// # Arguments
/// * `num` - The number for which the sum of divisors is to be calculated.
/// # Returns
/// * `felt` - The sum of divisors of num.
fn sum_of_divisors(num: felt) -> felt{
    let (q, _) = utils::unsafe_euclidean_div(num, 2);
    _sum_of_divisors(num, 1, q)
}

/// Recursive helper function to calculate the sum of divisors of a number
/// # Arguments
/// * `num` - The number for which the sum of divisors is being calculated.
/// * `index` - The current value being evaluated in the recursive loop.
/// * `limit` - The maximum value to be evaluated in the recursive loop.
/// # Returns
/// * `felt` - The sum of the divisors of num.
fn _sum_of_divisors(num: felt, index: felt, limit: felt) -> felt {
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

    if index > limit {
        return 0;
    }
    
    let (_, r) = utils::unsafe_euclidean_div(num, index);
    match r {
        0 => index + _sum_of_divisors(num, index + 1, limit),
        _ => _sum_of_divisors(num, index + 1, limit)
    }
}

impl ArrayTupleDrop of Drop::<Array::<(felt, felt)>>;