//! Bubble sort algorithm

use array::ArrayTrait;
use option::OptionTrait;

use utils::check_gas;


// Bubble sort 
/// # Arguments
/// * `array` - Array to sort
/// # Returns
/// * `Array::<usize>` - Sorted array
fn bubble_sort_elements<T,
impl TCopy: Copy::<T>,
impl TDrop: Drop::<T>,
impl TPartialOrd: PartialOrd::<T>>(
    mut array: Array::<T>
) -> Array::<T> {
    if array.len() <= 1_usize {
        return array;
    }

    bubble_sort_rec(array, ArrayTrait::new(), 0_usize, 1_usize, 0_usize)
}

// Bubble sort recursion
/// # Arguments
/// * `array` - array to sort
/// * `sorted_array` - step-sorted array
/// * `idx1, idx2` - consecutive indexes
/// * `sorted_iteration` - defines if a sort operation occured 
/// # Returns
/// * `Array::<usize>` - Final sorted array
fn bubble_sort_rec<T,
impl TPartialOrd: PartialOrd::<T>,
impl TDrop: Drop::<T>,
impl TCopy: Copy::<T>>(
    mut array: Array::<T>,
    mut sorted_array: Array::<T>,
    idx1: usize,
    idx2: usize,
    sorted_iteration: usize
) -> Array::<T> {
    check_gas();

    if idx2 == array.len() {
        sorted_array.append(*array.at(idx1));
        if (sorted_iteration == 0_usize) {
            return sorted_array;
        }
        let mut new_sorted_array = ArrayTrait::new();
        return bubble_sort_rec(sorted_array, new_sorted_array, 0_usize, 1_usize, 0_usize);
    }

    if *array.at(
        idx1
    ) < *array.at(
        idx2
    ) {
        sorted_array.append(*array.at(idx1));
        bubble_sort_rec(array, sorted_array, idx2, idx2 + 1_usize, sorted_iteration)
    } else {
        sorted_array.append(*array.at(idx2));
        bubble_sort_rec(array, sorted_array, idx1, idx2 + 1_usize, 1_usize)
    }
}
