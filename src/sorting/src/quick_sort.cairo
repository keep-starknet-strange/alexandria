//! Quick sort algorithm

// Quick sort
/// # Arguments
/// * `array` - Array to sort
/// # Returns
/// * `Array<usize>` - Sorted array
fn quick_sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +PartialEq<T>>(
    mut array: Array<T>, asc: bool
) -> Array<T> {
    let array_size = array.len();
    if array_size <= 1 {
        return array;
    }
    let mut asc_array = quick_sort_range(array, 0, array_size - 1);

    if asc {
        return asc_array;
    } else {
        let mut desc_array = array![];
        let mut idx = asc_array.len() - 1;

        loop {
            if idx == 0 {
                desc_array.append(*asc_array[idx]);
                break;
            }

            desc_array.append(*asc_array[idx]);
            idx -= 1;
        };

        return desc_array;
    }
}


fn quick_sort_range<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +PartialEq<T>>(
    mut array: Array<T>, left: usize, right: usize
) -> Array<T> {
    if left >= right {
        return array;
    }

    let mut l = left;
    let mut r = right;
    let mut new_array = array;

    loop {
        if l >= r {
            break;
        }

        let new_array_snapshot = @new_array;

        loop {
            if (l >= r) || (*new_array_snapshot[r] < *new_array_snapshot[left]) {
                break;
            }
            r -= 1;
        };

        loop {
            if (l >= r) || (*new_array_snapshot[l] > *new_array_snapshot[left]) {
                break;
            }
            l += 1;
        };

        if left != right {
            new_array = swap(new_array, l, r);
        }
    };

    new_array = swap(new_array, left, l);

    if l > 1 {
        new_array = quick_sort_range(new_array, left, l - 1);
    }

    new_array = quick_sort_range(new_array, r + 1, right);
    
    new_array
}

fn swap<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +PartialEq<T>>(
    mut array: Array<T>, left: usize, right: usize
) -> Array<T> {
    let test = 111111;
    let array_size = array.len();
    let mut new_array = array![];
    let mut new_array_idx = 0;

    loop {
        if (new_array_idx == array_size) {
            break;
        }

        if (new_array_idx == left) {
            new_array.append(*array[right]);
            new_array_idx += 1;
            continue;
        }

        if (new_array_idx == right) {
            new_array.append(*array[left]);
            new_array_idx += 1;
            continue;
        }

        new_array.append(*array[new_array_idx]);
        new_array_idx += 1;
    };

    new_array
}