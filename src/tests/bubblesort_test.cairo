use quaireaux::sorting::bubble_sort;
use quaireaux::utils;
use array::ArrayTrait;

#[test]
#[available_gas(20000000000000)]
fn bubblesort_test() {
    let mut data = array::array_new::<u32>();
    data.append(4_u32);
    data.append(2_u32);
    data.append(1_u32);
    data.append(3_u32);
    data.append(5_u32);
    data.append(0_u32);

    let mut correct = array::array_new::<u32>();
    correct.append(0_u32);
    correct.append(1_u32);
    correct.append(2_u32);
    correct.append(3_u32);
    correct.append(4_u32);
    correct.append(5_u32);

    let mut sorted = bubble_sort::bubble_sort_elements(data);

    assert(utils::is_equal(ref sorted, ref correct, 0_u32) == true, 'invalid result');
}


#[test]
#[available_gas(2000000)]
fn bubblesort_test_empty() {
    let mut data = array::array_new::<u32>();

    let mut correct = array::array_new::<u32>();

    let mut sorted = bubble_sort::bubble_sort_elements(data);

    assert(utils::is_equal(ref sorted, ref correct, 0_u32) == true, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn bubblesort_test_one_element() {
    let mut data = array::array_new::<u32>();
    data.append(2_u32);

    let mut correct = array::array_new::<u32>();
    correct.append(2_u32);

    let mut sorted = bubble_sort::bubble_sort_elements(data);

    assert(utils::is_equal(ref sorted, ref correct, 0_u32) == true, 'invalid result');
}

#[test]
#[available_gas(2000000)]
fn bubblesort_test_pre_sorted() {
    let mut data = array::array_new::<u32>();
    data.append(1_u32);
    data.append(2_u32);
    data.append(3_u32);
    data.append(4_u32);

    let mut correct = array::array_new::<u32>();
    correct.append(1_u32);
    correct.append(2_u32);
    correct.append(3_u32);
    correct.append(4_u32);

    let mut sorted = bubble_sort::bubble_sort_elements(data);

    assert(utils::is_equal(ref sorted, ref correct, 0_u32) == true, 'invalid result');
}




