use quaireaux::sorting::merge_sort;
use quaireaux::utils;
use array::ArrayTrait;

#[test]
#[available_gas(200000)]
fn mergesort_test() {
    let mut data = array_new::<u32>();
    array_append(ref data, 2_u32);
    array_append(ref data, 1_u32);
    array_append(ref data, 3_u32);
    array_append(ref data, 0_u32);

    let mut correct = array_new::<u32>();
    array_append(ref correct, 0_u32);
    array_append(ref correct, 1_u32);
    array_append(ref correct, 2_u32);
    array_append(ref correct, 3_u32);

    let mut sorted = merge_sort::mergesort_elements(data);

    assert(utils::is_equal(ref sorted, ref correct, 0_u32), 'invalid result');
}
