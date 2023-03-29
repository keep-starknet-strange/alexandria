//! Merge Sort

// Core Library Imports
use array::ArrayTrait;

// Internal Imports
use utils::utils::check_gas;
use utils::utils::split_array;

// Merge Sort
/// # Arguments
/// * `arr` - Array to sort
/// # Returns
/// * `Array::<T>` - Sorted array
fn merge<T, impl TCopy: Copy::<T>, impl TDrop: Drop::<T>, impl TPartialOrd: PartialOrd::<T>>(
    mut arr: Array::<T>
) -> Array::<T> {
    check_gas();

    let len = arr.len();
    if len <= 1_usize {
        return arr;
    }

    // Create left and right arrays
    let middle = len / 2_usize;
    let (mut left_arr, mut right_arr) = split_array(ref arr, middle);

    // Recursively sort the left and right arrays
    let mut sorted_left = merge(left_arr);
    let mut sorted_right = merge(right_arr);

    let mut result_arr = ArrayTrait::new();
    merge_recursive(sorted_left, sorted_right, ref result_arr, 0_usize, 0_usize);
    result_arr
}

// Merge two sorted arrays
/// # Arguments
/// * `left_arr` - Left array
/// * `right_arr` - Right array
/// * `result_arr` - Result array
/// * `left_arr_ix` - Left array index
/// * `right_arr_ix` - Right array index
/// # Returns
/// * `Array::<usize>` - Sorted array
fn merge_recursive<T,
impl TCopy: Copy::<T>,
impl TDrop: Drop::<T>,
impl TPartialOrd: PartialOrd::<T>>(
    mut left_arr: Array::<T>,
    mut right_arr: Array::<T>,
    ref result_arr: Array::<T>,
    left_arr_ix: usize,
    right_arr_ix: usize
) {
    check_gas();

    if result_arr.len() == left_arr.len() + right_arr.len() {
        return ();
    }

    if left_arr_ix == left_arr.len() {
        result_arr.append(*right_arr.at(right_arr_ix));
        return merge_recursive(
            left_arr, right_arr, ref result_arr, left_arr_ix, right_arr_ix + 1_usize
        );
    }

    if right_arr_ix == right_arr.len() {
        result_arr.append(*left_arr.at(left_arr_ix));
        return merge_recursive(
            left_arr, right_arr, ref result_arr, left_arr_ix + 1_usize, right_arr_ix
        );
    }

    if *left_arr.at(
        left_arr_ix
    ) < *right_arr.at(
        right_arr_ix
    ) {
        result_arr.append(*left_arr.at(left_arr_ix));
        merge_recursive(left_arr, right_arr, ref result_arr, left_arr_ix + 1_usize, right_arr_ix)
    } else {
        result_arr.append(*right_arr.at(right_arr_ix));
        merge_recursive(left_arr, right_arr, ref result_arr, left_arr_ix, right_arr_ix + 1_usize)
    }
}

