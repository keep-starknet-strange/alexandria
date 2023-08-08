//! Bubble sort algorithm
use array::ArrayTrait;

// Bubble sort 
/// # Arguments
/// * `array` - Array to sort
/// # Returns
/// * `Array<usize>` - Sorted array
fn bubble_sort_elements<
    T, impl TCopy: Copy<T>, impl TDrop: Drop<T>, impl TPartialOrd: PartialOrd<T>
>(
    mut array: Array<T>
) -> Array<T> {
    if array.len() <= 1 {
        return array;
    }
    let mut idx1 = 0;
    let mut idx2 = 1;
    let mut sorted_iteration = 0;
    let mut sorted_array = array![];

    loop {
        if idx2 == array.len() {
            sorted_array.append(*array[idx1]);
            if sorted_iteration == 0 {
                break ();
            }
            array = sorted_array;
            sorted_array = array![];
            idx1 = 0;
            idx2 = 1;
            sorted_iteration = 0;
        } else {
            if *array[idx1] < *array[idx2] {
                sorted_array.append(*array[idx1]);
                idx1 = idx2;
                idx2 += 1;
            } else {
                sorted_array.append(*array[idx2]);
                idx2 += 1;
                sorted_iteration = 1;
            }
        };
    };
    sorted_array
}
