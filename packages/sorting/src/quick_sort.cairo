//! Quick sort algorithm
use alexandria_data_structures::vec::{Felt252Vec, VecTrait};
use super::SortableVec;

/// Implementation of QuickSort algorithm for Felt252Vec
pub impl QuickSort of SortableVec {
    /// Sorts a Felt252Vec using the QuickSort algorithm
    /// Time complexity: O(n log n) average case, O(n²) worst case
    /// Space complexity: O(log n) due to recursion
    /// #### Arguments
    /// * `Felt252Vec<T>` - Array to sort
    /// #### Returns
    /// * `Felt252Vec<T>` - Sorted array
    fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +Felt252DictValue<T>>(
        mut array: Felt252Vec<T>,
    ) -> Felt252Vec<T> {
        let array_size = array.len();
        if array_size <= 1 {
            return array;
        }
        quick_sort_range(ref array, 0, array_size - 1);

        return array;
    }
}

/// Recursively sorts a range of elements in the array using QuickSort
/// Uses the leftmost element as pivot and partitions around it
/// #### Arguments
/// * `array` - The array to sort (passed by reference)
/// * `left` - Starting index of the range to sort
/// * `right` - Ending index of the range to sort
fn quick_sort_range<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +Felt252DictValue<T>>(
    ref array: Felt252Vec<T>, left: usize, right: usize,
) {
    if left >= right {
        return;
    }

    let mut l = left;
    let mut r = right;

    while l < r {
        while (l < r) && (array[r] >= array[left]) {
            r -= 1;
        }

        while (l < r) && (array[l] <= array[left]) {
            l += 1;
        }

        if left != right {
            let tmp = array[l];
            array.set(l, array[r]);
            array.set(r, tmp);
        }
    }

    let tmp = array[left];
    array.set(left, array[l]);
    array.set(l, tmp);

    if l > 1 {
        quick_sort_range(ref array, left, l - 1);
    }

    quick_sort_range(ref array, r + 1, right);
}
