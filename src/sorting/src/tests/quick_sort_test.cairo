use alexandria_data_structures::vec::{Felt252Vec, VecTrait};
use alexandria_sorting::{is_equal, is_equal_vec, quick_sort};
use core::option::OptionTrait;


#[test]
#[available_gas(20000000000000)]
fn quicksort_test() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(4_u32);
    data.push(2_u32);
    data.push(1_u32);
    data.push(3_u32);
    data.push(5_u32);
    data.push(0_u32);
    let mut correct = array![0_u32, 1_u32, 2_u32, 3_u32, 4_u32, 5_u32];

    let mut sorted = quick_sort::quick_sort(data);

    assert(is_equal_vec(sorted, correct.span()), 'invalid result');
}


#[test]
#[available_gas(2000000)]
fn quicksort_test_empty() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    let mut correct = array![];

    let mut sorted = quick_sort::quick_sort(data);

    assert(is_equal_vec(sorted, correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_one_element() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(2_u32);
    let mut correct = array![2_u32];

    let mut sorted = quick_sort::quick_sort(data);

    assert(is_equal_vec(sorted, correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(1_u32);
    data.push(2_u32);
    data.push(3_u32);
    data.push(4_u32);
    let mut correct = array![1_u32, 2_u32, 3_u32, 4_u32];

    let mut sorted = quick_sort::quick_sort(data);

    assert(is_equal_vec(sorted, correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted_decreasing() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(4_u32);
    data.push(3_u32);
    data.push(2_u32);
    data.push(1_u32);
    let mut correct = array![1_u32, 2_u32, 3_u32, 4_u32];

    let mut sorted = quick_sort::quick_sort(data);

    assert(is_equal_vec(sorted, correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_pre_sorted_2_same_values() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(1_u32);
    data.push(2_u32);
    data.push(2_u32);
    data.push(4_u32);
    let mut correct = array![1_u32, 2_u32, 2_u32, 4_u32];

    let mut sorted = quick_sort::quick_sort(data);

    assert(is_equal_vec(sorted, correct.span()), 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn quicksort_test_2_same_values() {
    let mut data = VecTrait::<Felt252Vec, u32>::new();
    data.push(1_u32);
    data.push(2_u32);
    data.push(4_u32);
    data.push(2_u32);
    let mut correct = array![1_u32, 2_u32, 2_u32, 4_u32];

    let mut sorted = quick_sort::quick_sort(data);

    assert(is_equal_vec(sorted, correct.span()), 'invalid result');
}
