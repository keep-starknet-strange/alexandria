use array::ArrayTrait;

use alexandria::sorting::{is_equal, bubble_sort};

#[test]
#[available_gas(20000000000000)]
fn bubblesort_test() {
    let mut data = array![4_u32, 2_u32, 1_u32, 3_u32, 5_u32, 0_u32];
    let mut correct = array![0_u32, 1_u32, 2_u32, 3_u32, 4_u32, 5_u32];

    let sorted = bubble_sort::bubble_sort_elements(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}


#[test]
#[available_gas(2000000)]
fn bubblesort_test_empty() {
    let mut data = array![];
    let mut correct = array![];

    let sorted = bubble_sort::bubble_sort_elements(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn bubblesort_test_one_element() {
    let mut data = array![2_u32];
    let mut correct = array![2_u32];

    let sorted = bubble_sort::bubble_sort_elements(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn bubblesort_test_pre_sorted() {
    let mut data = array![1_u32, 2_u32, 3_u32, 4_u32];
    let mut correct = array![1_u32, 2_u32, 3_u32, 4_u32];

    let sorted = bubble_sort::bubble_sort_elements(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

