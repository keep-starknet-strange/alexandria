//! Quick sort algorithm
use alexandria_data_structures::vec::{Felt252Vec, VecTrait};

// Quick sort
/// # Arguments
/// * `Felt252Vec<T>` - Array to sort
/// # Returns
/// * `Felt252Vec<T>` - Sorted array
fn quick_sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +PartialEq<T>, +Felt252DictValue<T>>(
    mut array: Felt252Vec<T>
) -> Felt252Vec<T> {
    let array_size = array.len();
    if array_size <= 1 {
        return array;
    }
    quick_sort_range(ref array, 0, array_size - 1);

    return array;
}


fn quick_sort_range<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +PartialEq<T>, +Felt252DictValue<T>>(
    ref array: Felt252Vec<T>, left: usize, right: usize
) {
    if left >= right {
        return;
    }

    let mut l = left;
    let mut r = right;

    loop {
        if l >= r {
            break;
        }

        loop {
            if (l >= r) || (array.get(r).unwrap() < array.get(left).unwrap()) {
                break;
            }
            r -= 1;
        };

        loop {
            if (l >= r) || (array.get(l).unwrap() > array.get(left).unwrap()) {
                break;
            }
            l += 1;
        };

        if left != right {
            let tmp = array.get(l).unwrap();
            array.set(l, array.get(r).unwrap());
            array.set(r, tmp);
        }
    };

    let tmp = array.get(left).unwrap();
    array.set(left, array.get(l).unwrap());
    array.set(l, tmp);

    if l > 1 {
        quick_sort_range(ref array, left, l - 1);
    }

    quick_sort_range(ref array, r + 1, right);
}
