use alexandria_sorting::BubbleSort;

#[test]
#[available_gas(20000000000000)]
fn bubble_sort_test() {
    let data = array![4_u32, 2, 1, 3, 5, 0];
    let correct = array![0_u32, 1, 2, 3, 4, 5];

    let sorted = BubbleSort::sort(data);

    assert_eq!(sorted.span(), correct.span(), "invalid result");
}


#[test]
#[available_gas(2000000)]
fn bubble_sort_test_empty() {
    let data: Array<u8> = array![];
    let correct = array![];

    let sorted = BubbleSort::sort(data);

    assert_eq!(sorted.span(), correct.span(), "invalid result");
}

#[test]
#[available_gas(2000000)]
fn bubble_sort_test_one_element() {
    let data = array![2_u32];
    let correct = array![2_u32];

    let sorted = BubbleSort::sort(data);

    assert_eq!(sorted.span(), correct.span(), "invalid result");
}

#[test]
#[available_gas(2000000)]
fn bubble_sort_test_pre_sorted() {
    let data = array![1_u32, 2, 3, 4];
    let correct = array![1_u32, 2, 3, 4];

    let sorted = BubbleSort::sort(data);

    assert_eq!(sorted.span(), correct.span(), "invalid result");
}

#[test]
#[available_gas(2000000)]
fn bubble_sort_test_pre_sorted_decreasing() {
    let data = array![4_u32, 3, 2, 1];
    let correct = array![1_u32, 2, 3, 4];

    let sorted = BubbleSort::sort(data);

    assert_eq!(sorted.span(), correct.span(), "invalid result");
}

#[test]
#[available_gas(2000000)]
fn bubble_sort_test_pre_sorted_2_same_values() {
    let data = array![1_u32, 2, 2, 4];
    let correct = array![1_u32, 2, 2, 4];

    let sorted = BubbleSort::sort(data);

    assert_eq!(sorted.span(), correct.span(), "invalid result");
}

#[test]
#[available_gas(2000000)]
fn bubble_sort_test_2_same_values() {
    let data = array![1_u32, 2, 4, 2];
    let correct = array![1_u32, 2, 2, 4];

    let sorted = BubbleSort::sort(data);

    assert_eq!(sorted.span(), correct.span(), "invalid result");
}
