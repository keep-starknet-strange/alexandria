use alexandria_data_structures::vec::{Felt252Vec, VecTrait};
use alexandria_sorting::QuickSort;

/// * `a` - The first Felt252Vec.
/// * `b` - The second array.
/// # Returns
/// * `bool` - True if the arrays are equal, false otherwise.
fn is_equal_vec(mut a: Felt252Vec<u32>, mut b: Span<u32>) -> bool {
    if a.len() != b.len() {
        return false;
    }

    let mut compare_id = 0;

    loop {
        if compare_id == b.len() {
            break true;
        }

        if a[compare_id] != *b[compare_id] {
            break false;
        }

        compare_id += 1;
    }
}

#[test]
#[available_gas(20000000000000)]
fn quicksort_test() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(4);
    data.push(2);
    data.push(1);
    data.push(3);
    data.push(5);
    data.push(0);
    let correct = array![0_u32, 1, 2, 3, 4, 5];

    let sorted = QuickSort::sort(data);

    assert!(is_equal_vec(sorted, correct.span()));
}


#[test]
#[available_gas(2000000)]
fn quicksort_test_empty() {
    let data = VecTrait::<Felt252Vec, u32>::new();
    let correct = array![];

    let sorted = QuickSort::sort(data);

    assert!(is_equal_vec(sorted, correct.span()));
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_one_element() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(2);
    let correct = array![2_u32];

    let sorted = QuickSort::sort(data);

    assert!(is_equal_vec(sorted, correct.span()));
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(1);
    data.push(2);
    data.push(3);
    data.push(4);
    let correct = array![1_u32, 2, 3, 4];

    let sorted = QuickSort::sort(data);

    assert!(is_equal_vec(sorted, correct.span()));
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted_decreasing() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(4);
    data.push(3);
    data.push(2);
    data.push(1);
    let correct = array![1_u32, 2, 3, 4];

    let sorted = QuickSort::sort(data);

    assert!(is_equal_vec(sorted, correct.span()));
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted_2_same_values() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(1);
    data.push(2);
    data.push(2);
    data.push(4);
    let correct = array![1_u32, 2, 2, 4];

    let sorted = QuickSort::sort(data);

    assert!(is_equal_vec(sorted, correct.span()));
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_2_same_values() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(1);
    data.push(2);
    data.push(4);
    data.push(2);
    let correct = array![1_u32, 2, 2, 4];

    let sorted = QuickSort::sort(data);

    assert!(is_equal_vec(sorted, correct.span()));
}
