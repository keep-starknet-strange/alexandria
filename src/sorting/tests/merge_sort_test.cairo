use array::ArrayTrait;

use alexandria::sorting::{is_equal, merge_sort::merge};

#[test]
#[available_gas(2000000000)]
fn mergesort_test() {
    let data = array![7_u32, 4_u32, 2_u32, 6_u32, 1_u32, 3_u32, 5_u32, 8_u32, 0_u32];
    let correct = array![0_u32, 1_u32, 2_u32, 3_u32, 4_u32, 5_u32, 6_u32, 7_u32, 8_u32].span();

    let mut sorted = merge(data).span();

    assert(is_equal(sorted, correct), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn mergesort_test_empty() {
    let mut data = array![];

    let mut correct = array![];

    let sorted = merge(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn mergesort_test_one_element() {
    let mut data = array![2_u32];
    let mut correct = array![2_u32];

    let mut sorted = merge(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn mergesort_test_pre_sorted() {
    let mut data = array![1_u32, 2_u32, 3_u32, 4_u32];
    let mut correct = array![1_u32, 2_u32, 3_u32, 4_u32];

    let sorted = merge(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}
