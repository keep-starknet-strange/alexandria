//! Merge Sort
use array::ArrayTrait;

use quaireaux_utils::check_gas;

// Merge Sort
/// # Arguments
/// * `arr` - Array to sort
/// # Returns
/// * `Array::<T>` - Sorted array
fn merge<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>, impl TPartialOrd: PartialOrd<T>>(
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
fn merge_recursive<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>, impl TPartialOrd: PartialOrd<T>>(
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

// Split an array into two arrays.
/// * `arr` - The array to split.
/// * `index` - The index to split the array at.
/// # Returns
/// * `(Array::<T>, Array::<T>)` - The two arrays.
fn split_array<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>>(
    ref arr: Array::<T>, index: usize
) -> (Array::<T>, Array::<T>) {
    check_gas();

    let mut arr1 = ArrayTrait::new();
    let mut arr2 = ArrayTrait::new();
    let len = arr.len();

    fill_array(ref arr1, ref arr, 0_u32, index);
    fill_array(ref arr2, ref arr, index, len - index);

    (arr1, arr2)
}

// Fill an array with a value.
/// * `arr` - The array to fill.
/// * `fill_arr` - The array to fill with.
/// * `index` - The index to start filling at.
/// * `count` - The number of elements to fill.
/// # Returns
/// * `Array::<T>` - The filled array.
fn fill_array<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>>(
    ref arr: Array::<T>, ref fill_arr: Array::<T>, index: usize, count: usize
) {
    check_gas();

    if count == 0_usize {
        return ();
    }
    let element = fill_arr.at(index);
    arr.append(*element);

    fill_array(ref arr, ref fill_arr, index + 1_usize, count - 1_usize)
}
