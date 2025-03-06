//! Bubble sort algorithm

// Bubble sort
/// # Arguments
/// * `array` - Array to sort
/// # Returns
/// * `Array<usize>` - Sorted array
use super::Sortable;

pub impl BubbleSort of Sortable {
    fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(mut array: Span<T>) -> Array<T> {
        if array.len() == 0 {
            return array![];
        }
        if array.len() == 1 {
            return array![*array[0]];
        }
        let mut idx1 = 0;
        let mut idx2 = 1;
        let mut sorted_iteration = true;
        let mut sorted_array = array![];

        loop {
            if idx2 == array.len() {
                sorted_array.append(*array[idx1]);
                if sorted_iteration {
                    break;
                }
                array = sorted_array.span();
                sorted_array = array![];
                idx1 = 0;
                idx2 = 1;
                sorted_iteration = true;
            } else {
                if *array[idx1] <= *array[idx2] {
                    sorted_array.append(*array[idx1]);
                    idx1 = idx2;
                    idx2 += 1;
                } else {
                    sorted_array.append(*array[idx2]);
                    idx2 += 1;
                    sorted_iteration = false;
                }
            };
        }
        sorted_array
    }
}
