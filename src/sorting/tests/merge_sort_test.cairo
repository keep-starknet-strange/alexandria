use array::ArrayTrait;

use alexandria::sorting::{is_equal, merge_sort::merge};

#[test]
#[available_gas(2000000000)]
fn mergesort_test() {
    let mut data = ArrayTrait::new();
    data.append(7_u32);
    data.append(4_u32);
    data.append(2_u32);
    data.append(6_u32);
    data.append(1_u32);
    data.append(3_u32);
    data.append(5_u32);
    data.append(8_u32);
    data.append(0_u32);

    let mut correct = ArrayTrait::new();
    correct.append(0_u32);
    correct.append(1_u32);
    correct.append(2_u32);
    correct.append(3_u32);
    correct.append(4_u32);
    correct.append(5_u32);
    correct.append(6_u32);
    correct.append(7_u32);
    correct.append(8_u32);

    let sorted = merge(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn mergesort_test_empty() {
    let data = ArrayTrait::new();

    let correct = ArrayTrait::new();

    let sorted = merge(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn mergesort_test_one_element() {
    let mut data = ArrayTrait::new();
    data.append(2_u32);

    let mut correct = ArrayTrait::new();
    correct.append(2_u32);

    let mut sorted = merge(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn mergesort_test_pre_sorted() {
    let mut data = ArrayTrait::new();
    data.append(1_u32);
    data.append(2_u32);
    data.append(3_u32);
    data.append(4_u32);

    let mut correct = ArrayTrait::new();
    correct.append(1_u32);
    correct.append(2_u32);
    correct.append(3_u32);
    correct.append(4_u32);

    let sorted = merge(data);

    assert(is_equal(sorted.span(), correct.span()), 'invalid result');
}
