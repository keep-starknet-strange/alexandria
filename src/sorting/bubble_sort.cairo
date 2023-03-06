//! Bubble sort algorithm

use array::ArrayTrait;
use option::OptionTrait;


// Bubble sort 
/// # Arguments
/// * `array` - Array to sort
/// # Returns
/// * `Array::<u32>` - Sorted array
fn bubble_sort_elements(mut array: Array::<u32>) -> Array::<u32> {
    let array_len = array.len();
    if (array_len <= 1_u32) {
        return array;
    }
    let mut sorted_array = array_new();
    let result = bubble_sort_rec(array, sorted_array, 0_u32, 1_u32, 0_u32);
    result
}

// Bubble sort recursion
/// # Arguments
/// * `array` - array to sort
/// * `sorted_array` - step-sorted array
/// * `idx1, idx2` - consecutive indexes
/// * `sorted_iteration` - defines if a sort operation occured 
/// # Returns
/// * `Array::<u32>` - Final sorted array
fn bubble_sort_rec(
    mut array: Array::<u32>,
    mut sorted_array: Array::<u32>,
    idx1: u32,
    idx2: u32,
    sorted_iteration: u32
) -> Array::<u32> {
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }
    let array_len = array.len();
    if (idx2 == array_len) {
        sorted_array.append(*array.at(idx1));
        if (sorted_iteration == 0_u32) {
            return (sorted_array);
        }
        let mut new_sorted_array = array_new();
        return bubble_sort_rec(sorted_array, new_sorted_array, 0_u32, 1_u32, 0_u32);
    }

    if (*array.at(
        idx1
    ) < *array.at(
        idx2
    )) {
        sorted_array.append(*array.at(idx1));
        return bubble_sort_rec(array, sorted_array, idx2, idx2 + 1_u32, sorted_iteration);
    }
    sorted_array.append(*array.at(idx2));
    return bubble_sort_rec(array, sorted_array, idx1, idx2 + 1_u32, 1_u32);
}
