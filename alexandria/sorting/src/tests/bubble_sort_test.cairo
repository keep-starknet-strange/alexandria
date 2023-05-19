use array::ArrayTrait;

use alexandria_sorting::{is_equal, bubble_sort};

#[test]
#[available_gas(20000000000000)]
fn bubblesort_test() {
    let mut data = ArrayTrait::new();
    data.append(4_u32);
    data.append(2_u32);
    data.append(1_u32);
    data.append(3_u32);
    data.append(5_u32);
    data.append(0_u32);

    let mut correct = ArrayTrait::new();
    correct.append(0_u32);
    correct.append(1_u32);
    correct.append(2_u32);
    correct.append(3_u32);
    correct.append(4_u32);
    correct.append(5_u32);

    let mut sorted = bubble_sort::bubble_sort_elements(data);

    assert(is_equal(ref sorted, ref correct, 0_u32) == true, 'invalid result');
}


#[test]
#[available_gas(2000000)]
fn bubblesort_test_empty() {
    let mut data = ArrayTrait::new();

    let mut correct = ArrayTrait::new();

    let mut sorted = bubble_sort::bubble_sort_elements(data);

    assert(is_equal(ref sorted, ref correct, 0_u32) == true, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn bubblesort_test_one_element() {
    let mut data = ArrayTrait::new();
    data.append(2_u32);

    let mut correct = ArrayTrait::new();
    correct.append(2_u32);

    let mut sorted = bubble_sort::bubble_sort_elements(data);

    assert(is_equal(ref sorted, ref correct, 0_u32) == true, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn bubblesort_test_pre_sorted() {
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

    let mut sorted = bubble_sort::bubble_sort_elements(data);

    assert(is_equal(ref sorted, ref correct, 0_u32) == true, 'invalid result');
}

