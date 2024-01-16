use alexandria_sorting::{is_equal, quick_sort};

#[test]
#[available_gas(20000000000000)]
fn quicksort_test() {
    let mut data = array![4_u32, 2_u32, 1_u32, 3_u32, 5_u32, 0_u32];
    let mut correct = array![0_u32, 1_u32, 2_u32, 3_u32, 4_u32, 5_u32];

    let sorted = quick_sort::quick_sort(data, true);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}


#[test]
#[available_gas(2000000)]
fn quicksort_test_empty() {
    let mut data = array![];
    let mut correct = array![];

    let sorted = quick_sort::quick_sort(data, true);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_one_element() {
    let mut data = array![2_u32];
    let mut correct = array![2_u32];

    let sorted = quick_sort::quick_sort(data, true);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted() {
    let mut data = array![1_u32, 2_u32, 3_u32, 4_u32];
    let mut correct = array![1_u32, 2_u32, 3_u32, 4_u32];

    let sorted = quick_sort::quick_sort(data, true);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted_decreasing() {
    let mut data = array![4_u32, 3_u32, 2_u32, 1_u32];
    let mut correct = array![1_u32, 2_u32, 3_u32, 4_u32];

    let sorted = quick_sort::quick_sort(data, true);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted_2_same_values() {
    let mut data = array![1_u32, 2_u32, 2_u32, 4_u32];
    let mut correct = array![1_u32, 2_u32, 2_u32, 4_u32];

    let sorted = quick_sort::quick_sort(data, true);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_2_same_values() {
    let mut data = array![1_u32, 2_u32, 4_u32, 2_u32];
    let mut correct = array![1_u32, 2_u32, 2_u32, 4_u32];

    let sorted = quick_sort::quick_sort(data, true);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(20000000000000)]
fn quicksort_test_dsc() {
    let mut data = array![4_u32, 2_u32, 1_u32, 3_u32, 5_u32, 0_u32];
    let mut correct = array![5_u32, 4_u32, 3_u32, 2_u32, 1_u32, 0_u32];

    let sorted = quick_sort::quick_sort(data, false);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}


#[test]
#[available_gas(2000000)]
fn quicksort_test_empty_dsc() {
    let mut data = array![];
    let mut correct = array![];

    let sorted = quick_sort::quick_sort(data, false);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_one_element_dsc() {
    let mut data = array![2_u32];
    let mut correct = array![2_u32];

    let sorted = quick_sort::quick_sort(data, false);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted_dsc() {
    let mut data = array![1_u32, 2_u32, 3_u32, 4_u32];
    let mut correct = array![4_u32, 3_u32, 2_u32, 1_u32];

    let sorted = quick_sort::quick_sort(data, false);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted_decreasing_dsc() {
    let mut data = array![4_u32, 3_u32, 2_u32, 1_u32];
    let mut correct = array![4_u32, 3_u32, 2_u32, 1_u32];

    let sorted = quick_sort::quick_sort(data, false);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted_2_same_values_dsc() {
    let mut data = array![1_u32, 2_u32, 2_u32, 4_u32];
    let mut correct = array![4_u32, 2_u32, 2_u32, 1_u32];

    let sorted = quick_sort::quick_sort(data, false);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_2_same_values_dsc() {
    let mut data = array![1_u32, 2_u32, 4_u32, 2_u32];
    let mut correct = array![4_u32, 2_u32, 2_u32, 1_u32];

    let sorted = quick_sort::quick_sort(data, false);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}
