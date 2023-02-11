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
fn amicable_pairs_under_n(ref num: felt) -> Array::<(felt, felt)> {
    let mut results = ArrayTrait::<(felt, felt)>::new();
    let mut index = 1;
    _amicable_pairs_under_n(ref num, ref index, ref results);
    results
}

/// Recursive helper function to find amicable pairs under a specified number.
/// # Arguments
/// * `num` - The maximum number to consider in the search for amicable pairs.
/// * `index` - The current index in the search for amicable pairs.
/// * `arr` - The running list of amicable pairs found so far.
/// # Returns
/// * `None` - This function does not return a value, it updates the arr argument in place.
fn _amicable_pairs_under_n(ref num: felt, ref index: felt, ref arr: Array::<(felt, felt)>) {
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

    if index == num {
        return ();
    }

    let sum_1 = sum_of_divisors(index);
    let sum_2 = sum_of_divisors(sum_1);

    if sum_2 == index & index != sum_1 { // & !contain_tuple(ref arr, (index, sum_1) 
        if !contain_tuple(ref arr, (index, sum_1)) {
            arr.append((index, sum_1));
        }
    }
    update_step(ref index);
    _amicable_pairs_under_n(ref num, ref index, ref arr);
}

/// Update the step of the function _amicable_pairs_under_n.
fn update_step(ref index: felt) {
    index = index + 1;
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

/// Algorithm to check if a tuple exists in an array of tuples
/// # Arguments
/// * `arr` - The array of tuples to be checked.
/// * `tuple` - The tuple to be searched for in the array.
/// # Returns
/// * `bool` - True if the tuple exists in the array, false otherwise.
fn contain_tuple(ref arr: Array::<(felt, felt)>, tuple: (felt, felt)) -> bool {
    let mut index = 0_usize;
    _contain_tuple(ref arr, tuple, index)
}

/// Algorithm to check if a tuple exists in an array of tuples.
/// # Arguments
/// * `arr` - The array of tuples to search.
/// * `tuple` - The tuple to look for in the array.
/// * `index` - The current index in the search process.
/// # Returns
/// * `bool` - True if the tuple exists in the array, false otherwise.
fn _contain_tuple(ref arr: Array::<(felt, felt)>, tuple: (felt, felt), index: usize) -> bool {
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

    if index == arr.len() {
        return false;
    }
    
    let (x, y) = arr.at(index);
    let (tup_1, tup_2) = tuple;
    // if arr.at(index) == tup {
    //     return true;
    // }
    if x == tup_1 & y == tup_2 {
        return true;
    }
    if x == tup_2 & y == tup_1 {
        return true;
    }
    _contain_tuple(ref arr, tuple, index + 1_usize)
}

impl ArrayTupleDrop of Drop::<Array::<(felt, felt)>>;