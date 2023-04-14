//! Bubble sort algorithm
use array::ArrayTrait;

use quaireaux_utils::check_gas;

// Bubble sort 
/// # Arguments
/// * `array` - Array to sort
/// # Returns
/// * `Array<usize>` - Sorted array
fn bubble_sort_elements<T,
impl TCopy: Copy<T>,
impl TDrop: Drop<T>,
impl TPartialOrd: PartialOrd<T>>(
    mut array: Array<T>
) -> Array<T> {
    if array.len() <= 1_usize {
        return array;
    }
    let mut idx1 = 0_usize;
    let mut idx2 = 1_usize;
    let mut sorted_iteration = 0_usize;
    let mut sorted_array = ArrayTrait::new();

    loop {
        check_gas();

        if idx2 == array.len() {
            sorted_array.append(*array[idx1]);
            if (sorted_iteration == 0_usize) {
                break ();
            }
            array = sorted_array;
            sorted_array = ArrayTrait::new();
            idx1 = 0_usize;
            idx2 = 1_usize;
            sorted_iteration = 0_usize;
        } else {
            if *array[idx1] < *array[idx2] {
                sorted_array.append(*array[idx1]);
                idx1 = idx2;
                idx2 = idx2 + 1;
            } else {
                sorted_array.append(*array[idx2]);
                idx2 = idx2 + 1;
                sorted_iteration = 1;
            }
        };
    };
    sorted_array
}