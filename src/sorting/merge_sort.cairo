//! Merge Sort

// Core Library Imports
use array::ArrayTrait;

// Internal Imports
use quaireaux::utils;

// Merge Sort
/// # Arguments
/// * `arr` - Array to sort
/// # Returns
/// * `Array::<u32>` - Sorted array
fn mergesort_elements(mut arr: Array::<u32>) -> Array::<u32> {
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    let len = arr.len();
    if len <= 1_u32 {
        return arr;
    }

    // Create left and right arrays
    let middle = len / 2_u32;
    let (mut left_arr, mut right_arr) = utils::split_array(ref arr, middle);

    // Recursively sort the left and right arrays
    let mut sorted_left = mergesort_elements(left_arr);
    let mut sorted_right = mergesort_elements(right_arr);

    let mut result_arr = ArrayTrait::<u32>::new();
    let sorted_arr = _merge(sorted_left, sorted_right, result_arr, 0_u32, 0_u32);

    sorted_arr
}

// Merge two sorted arrays
/// # Arguments
/// * `left_arr` - Left array
/// * `right_arr` - Right array
/// * `result_arr` - Result array
/// * `left_arr_ix` - Left array index
/// * `right_arr_ix` - Right array index
/// # Returns
/// * `Array::<u32>` - Sorted array
fn _merge(
    mut left_arr: Array::<u32>,
    mut right_arr: Array::<u32>,
    mut result_arr: Array::<u32>,
    left_arr_ix: u32,
    right_arr_ix: u32
) -> Array::<u32> {
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if result_arr.len() == left_arr.len() + right_arr.len() {
        return result_arr;
    }

    if left_arr_ix == left_arr.len() {
        result_arr.append(*right_arr.at(right_arr_ix));
        return _merge(left_arr, right_arr, result_arr, left_arr_ix, right_arr_ix + 1_u32);
    }

    if right_arr_ix == right_arr.len() {
        result_arr.append(*left_arr.at(left_arr_ix));
        return _merge(left_arr, right_arr, result_arr, left_arr_ix + 1_u32, right_arr_ix);
    }

    if *left_arr.at(
        left_arr_ix
    ) < *right_arr.at(
        right_arr_ix
    ) {
        result_arr.append(*left_arr.at(left_arr_ix));
        return _merge(left_arr, right_arr, result_arr, left_arr_ix + 1_u32, right_arr_ix);
    } else {
        result_arr.append(*right_arr.at(right_arr_ix));
        return _merge(left_arr, right_arr, result_arr, left_arr_ix, right_arr_ix + 1_u32);
    }
}

