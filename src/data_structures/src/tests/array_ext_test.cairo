use alexandria_data_structures::array_ext::{ArrayTraitExt, SpanTraitExt};

// dedup

#[test]
#[available_gas(2000000)]
fn dedup_all_different() {
    let destination = array![1, 2, 3, 4];
    let new_arr = destination.dedup();

    assert_eq!(*new_arr[0], 1, "Should be 1");
    assert_eq!(*new_arr[1], 2, "Should be 2");
    assert_eq!(*new_arr[2], 3, "Should be 3");
    assert_eq!(*new_arr[3], 4, "Should be 4");
    assert_eq!(new_arr.len(), 4, "Len should be 4");
}

#[test]
#[available_gas(2000000)]
fn dedup_one_match() {
    let destination = array![1, 2, 2, 3, 4];
    let new_arr = destination.dedup();

    assert_eq!(*new_arr[0], 1, "Should be 1");
    assert_eq!(*new_arr[1], 2, "Should be 2");
    assert_eq!(*new_arr[2], 3, "Should be 3");
    assert_eq!(*new_arr[3], 4, "Should be 4");
    assert_eq!(new_arr.len(), 4, "Len should be 4");
}

#[test]
#[available_gas(2000000)]
fn dedup_two_matches() {
    let destination = array![1, 2, 2, 3, 4, 4];
    let new_arr = destination.dedup();

    assert_eq!(*new_arr[0], 1, "Should be 1");
    assert_eq!(*new_arr[1], 2, "Should be 2");
    assert_eq!(*new_arr[2], 3, "Should be 3");
    assert_eq!(*new_arr[3], 4, "Should be 4");
    assert_eq!(new_arr.len(), 4, "Len should be 4");
}

#[test]
#[available_gas(2000000)]
fn dedup_one_match_more() {
    let destination = array![1, 2, 2, 2, 3, 4, 4];
    let new_arr = destination.dedup();

    assert_eq!(*new_arr[0], 1, "Should be 1");
    assert_eq!(*new_arr[1], 2, "Should be 2");
    assert_eq!(*new_arr[2], 3, "Should be 3");
    assert_eq!(*new_arr[3], 4, "Should be 4");
    assert_eq!(new_arr.len(), 4, "Len should be 4");
}

#[test]
#[available_gas(2000000)]
fn dedup_all_same() {
    let destination = array![2, 2, 2, 2];
    let new_arr = destination.dedup();

    assert_eq!(*new_arr[0], 2, "Should be 2");
    assert_eq!(new_arr.len(), 1, "Len should be 1");
}

#[test]
#[available_gas(2000000)]
fn dedup_one_elem() {
    let destination = array![2];
    let new_arr = destination.dedup();

    assert_eq!(*new_arr[0], 2, "Should be 2");
    assert_eq!(new_arr.len(), 1, "Len should be 1");
}

#[test]
#[available_gas(2000000)]
fn dedup_no_elem() {
    let destination: Array<felt252> = array![];
    let new_arr = destination.dedup();

    assert_eq!(new_arr.len(), 0, "Len should be 0");
}

#[test]
#[available_gas(2000000)]
fn dedup_multiple_duplicates_same() {
    let mut destination = array![1, 1, 3, 4, 3, 3, 3, 4, 2, 2];
    let new_arr = destination.dedup();

    assert_eq!(new_arr.len(), 6, "Len should be 6");
    assert_eq!(*new_arr[0], 1, "Should be 1");
    assert_eq!(*new_arr[1], 3, "Should be 3");
    assert_eq!(*new_arr[2], 4, "Should be 4");
    assert_eq!(*new_arr[3], 3, "Should be 3");
    assert_eq!(*new_arr[4], 4, "Should be 4");
    assert_eq!(*new_arr[5], 2, "Should be 2");
}

// append_all

#[test]
#[available_gas(2000000)]
fn append_all() {
    let mut destination = array![21];
    let mut source = array![42, 84];
    destination.append_all(ref source);
    assert_eq!(destination.len(), 3, "Len should be 3");
    assert_eq!(*destination[0], 21, "Should be 21");
    assert_eq!(*destination[1], 42, "Should be 42");
    assert_eq!(*destination[2], 84, "Should be 84");
}

#[test]
#[available_gas(2000000)]
fn append_all_different_type() {
    let mut destination = array![21_u128];
    let mut source = array![42_u128, 84_u128];
    destination.append_all(ref source);
    assert_eq!(destination.len(), 3, "Len should be 3");
    assert_eq!(*destination[0], 21_u128, "Should be 21_u128");
    assert_eq!(*destination[1], 42_u128, "Should be 42_u128");
    assert_eq!(*destination[2], 84_u128, "Should be 84_u128");
}

#[test]
#[available_gas(2000000)]
fn append_all_destination_empty() {
    let mut destination = array![];
    let mut source = array![21, 42, 84];
    destination.append_all(ref source);
    assert_eq!(destination.len(), 3, "Len should be 3");
    assert_eq!(*destination[0], 21, "Should be 21");
    assert_eq!(*destination[1], 42, "Should be 42");
    assert_eq!(*destination[2], 84, "Should be 84");
}

#[test]
#[available_gas(2000000)]
fn append_all_source_empty() {
    let mut destination = array![];
    let mut source = array![21, 42, 84];
    destination.append_all(ref source);
    assert_eq!(destination.len(), 3, "Len should be 3");
    assert_eq!(*destination[0], 21, "Should be 0");
    assert_eq!(*destination[1], 42, "Should be 1");
    assert_eq!(*destination[2], 84, "Should be 2");
}

#[test]
#[available_gas(2000000)]
fn append_all_both_empty() {
    let mut destination: Array<felt252> = array![];
    let mut source = array![];
    destination.append_all(ref source);
    assert_eq!(source.len(), 0, "Len should be 0");
    assert_eq!(destination.len(), 0, "Len should be 0");
}

// reverse

#[test]
#[available_gas(2000000)]
fn reverse() {
    let mut arr = array![21, 42, 84];
    let response = arr.reverse();
    assert_eq!(response.len(), 3, "Len should be 3");
    assert_eq!(*response[0], 84, "Should be 84");
    assert_eq!(*response[1], 42, "Should be 42");
    assert_eq!(*response[2], 21, "Should be 21");
}

#[test]
#[available_gas(2000000)]
fn reverse_size_1() {
    let mut arr = array![21];
    let response = arr.reverse();
    assert_eq!(response.len(), 1, "Len should be 1");
    assert_eq!(*response[0], 21, "Should be 21");
}

#[test]
#[available_gas(2000000)]
fn reverse_empty() {
    let mut arr: Array<felt252> = array![];
    let response = arr.reverse();
    assert_eq!(response.len(), 0, "Len should be 0");
}

#[test]
#[available_gas(2000000)]
fn reverse_different_type() {
    let mut arr = array![21_u128, 42_u128, 84_u128];
    let response = arr.reverse();
    assert_eq!(response.len(), 3, "Len should be 3");
    assert_eq!(*response[0], 84_u128, "Should be 84_u128");
    assert_eq!(*response[1], 42_u128, "Should be 42_u128");
    assert_eq!(*response[2], 21_u128, "Should be 21_u128");
}

#[test]
#[available_gas(2000000)]
fn reverse_span() {
    let mut arr = array![21, 42, 84];
    let response = arr.span().reverse();
    assert_eq!(response.len(), 3, "Len should be 3");
    assert_eq!(*response[0], 84, "Should be 84");
    assert_eq!(*response[1], 42, "Should be 42");
    assert_eq!(*response[2], 21, "Should be 21");
}

#[test]
#[available_gas(2000000)]
fn reverse_size_1_span() {
    let mut arr = array![21];
    let response = arr.span().reverse();
    assert_eq!(response.len(), 1, "Len should be 1");
    assert_eq!(*response[0], 21, "Should be 21");
}

#[test]
#[available_gas(2000000)]
fn reverse_empty_span() {
    let mut arr: Array<felt252> = array![];
    let response = arr.span().reverse();
    assert_eq!(response.len(), 0, "Len should be 0");
}

#[test]
#[available_gas(2000000)]
fn reverse_different_type_span() {
    let mut arr = array![21_u128, 42_u128, 84_u128];
    let response = arr.span().reverse();
    assert_eq!(response.len(), 3, "Len should be 3");
    assert_eq!(*response[0], 84_u128, "Should be 84_u128");
    assert_eq!(*response[1], 42_u128, "Should be 42_u128");
    assert_eq!(*response[2], 21_u128, "Should be 21_u128");
}


// pop front n

#[test]
#[available_gas(2000000)]
fn pop_front_n() {
    let mut arr = get_felt252_array();
    arr.pop_front_n(2);
    assert_eq!(arr.len(), 1, "Len should be 1");
    assert_eq!(arr.pop_front().unwrap(), 84, "Should be 84");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_different_type() {
    let mut arr = get_u128_array();
    arr.pop_front_n(2);
    assert_eq!(arr.len(), 1, "Len should be 1");
    assert_eq!(arr.pop_front().unwrap(), 84, "Should be 84");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_empty_array() {
    let mut arr: Array<felt252> = array![];
    assert!(arr.is_empty(), "Should be empty");
    arr.pop_front_n(2);
    assert!(arr.is_empty(), "Should be empty");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_zero() {
    let mut arr = get_felt252_array();
    arr.pop_front_n(0);
    assert_eq!(arr.len(), 3, "Len should be 1");
    assert_eq!(arr.pop_front().unwrap(), 21, "Should be 21");
    assert_eq!(arr.pop_front().unwrap(), 42, "Should be 42");
    assert_eq!(arr.pop_front().unwrap(), 84, "Should be 84");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_exact_len() {
    let mut arr = get_felt252_array();
    arr.pop_front_n(3);
    assert!(arr.is_empty(), "Should be empty");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_more_then_len() {
    let mut arr = get_felt252_array();
    arr.pop_front_n(4);
    assert!(arr.is_empty(), "Should be empty");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_front_n(2);
    assert_eq!(arr.len(), 1, "Len should be 1");
    assert_eq!(*arr.pop_front().unwrap(), 84, "Should be 84");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_different_type_span() {
    let mut arr = get_u128_array().span();
    arr.pop_front_n(2);
    assert_eq!(arr.len(), 1, "Len should be 1");
    assert_eq!(*arr.pop_front().unwrap(), 84, "Should be 84");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_empty_array_span() {
    let mut arr: Span<felt252> = array![].span();
    assert!(arr.is_empty(), "Should be empty");
    arr.pop_front_n(2);
    assert!(arr.is_empty(), "Should be empty");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_zero_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_front_n(0);
    assert_eq!(arr.len(), 3, "Len should be 1");
    assert_eq!(*arr.pop_front().unwrap(), 21, "Should be 21");
    assert_eq!(*arr.pop_front().unwrap(), 42, "Should be 42");
    assert_eq!(*arr.pop_front().unwrap(), 84, "Should be 84");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_exact_len_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_front_n(3);
    assert!(arr.is_empty(), "Should be empty");
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_more_then_len_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_front_n(4);
    assert!(arr.is_empty(), "Should be empty");
}

// pop back n
#[test]
#[available_gas(2000000)]
fn pop_back_n_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_back_n(2);
    assert_eq!(arr.len(), 1, "Len should be 1");
    assert_eq!(*arr.pop_back().unwrap(), 21, "Should be 21");
}

#[test]
#[available_gas(2000000)]
fn pop_back_n_different_type_span() {
    let mut arr = get_u128_array().span();
    arr.pop_back_n(2);
    assert_eq!(arr.len(), 1, "Len should be 1");
    assert_eq!(*arr.pop_back().unwrap(), 21, "Should be 21");
}

#[test]
#[available_gas(2000000)]
fn pop_back_n_empty_array_span() {
    let mut arr: Span<felt252> = array![].span();
    assert!(arr.is_empty(), "Should be empty");
    arr.pop_back_n(2);
    assert!(arr.is_empty(), "Should be empty");
}

#[test]
#[available_gas(2000000)]
fn pop_back_n_zero_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_back_n(0);
    assert_eq!(arr.len(), 3, "Len should be 1");
    assert_eq!(*arr.pop_front().unwrap(), 21, "Should be 21");
    assert_eq!(*arr.pop_front().unwrap(), 42, "Should be 42");
    assert_eq!(*arr.pop_front().unwrap(), 84, "Should be 84");
}

#[test]
#[available_gas(2000000)]
fn pop_back_n_exact_len_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_back_n(3);
    assert!(arr.is_empty(), "Should be empty");
}

#[test]
#[available_gas(2000000)]
fn pop_back_n_more_then_len_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_back_n(4);
    assert!(arr.is_empty(), "Should be empty");
}


// contains

#[test]
#[available_gas(2000000)]
fn contains() {
    let arr = get_felt252_array();
    assert!(arr.contains(21), "Should contain 21");
    assert!(arr.contains(42), "Should contain 42");
    assert!(arr.contains(84), "Should contain 84");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn contains_different_type() {
    let arr = get_u128_array();
    assert!(arr.contains(21_u128), "Should contain 21_u128");
    assert!(arr.contains(42_u128), "Should contain 42_u128");
    assert!(arr.contains(84_u128), "Should contain 84_u128");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn contains_false() {
    let arr = get_felt252_array();
    assert!(!arr.contains(85), "Should be false");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn contains_empty_array() {
    let arr = array![];
    assert!(!arr.contains(85), "Should be false");
    assert_eq!(arr.len(), 0, "arr should not be consummed");
}


#[test]
#[available_gas(2000000)]
fn contains_span() {
    let arr = get_felt252_array().span();
    assert!(arr.contains(21), "Should contain 21");
    assert!(arr.contains(42), "Should contain 42");
    assert!(arr.contains(84), "Should contain 84");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn contains_different_type_span() {
    let arr = get_u128_array().span();
    assert!(arr.contains(21_u128), "Should contain 21_u128");
    assert!(arr.contains(42_u128), "Should contain 42_u128");
    assert!(arr.contains(84_u128), "Should contain 84_u128");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn contains_false_span() {
    let arr = get_felt252_array().span();
    assert!(!arr.contains(85), "Should be false");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn contains_empty_array_span() {
    let arr = (array![]).span();
    assert!(!arr.contains(85), "Should be false");
    assert_eq!(arr.len(), 0, "arr should not be consummed");
}

// index_of

#[test]
#[available_gas(2000000)]
fn index_of() {
    let arr = get_felt252_array();
    assert_eq!(arr.index_of(21).unwrap(), 0, "Index should be 0");
    assert_eq!(arr.index_of(42).unwrap(), 1, "Index should be 1");
    assert_eq!(arr.index_of(84).unwrap(), 2, "Index should be 2");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_different_type() {
    let arr = get_u128_array();
    assert_eq!(arr.index_of(21_u128).unwrap(), 0, "Index should be 0");
    assert_eq!(arr.index_of(42_u128).unwrap(), 1, "Index should be 1");
    assert_eq!(arr.index_of(84_u128).unwrap(), 2, "Index should be 2");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_panic() {
    let arr = get_felt252_array();
    assert!(arr.index_of(12).is_none(), "Should NOT contain 12");
}

#[test]
#[available_gas(2000000)]
fn index_of_empty_array() {
    let arr = array![];
    assert!(arr.index_of(21).is_none(), "Should NOT contain 21");
}

#[test]
#[available_gas(2000000)]
fn index_of_span() {
    let arr = get_felt252_array().span();
    assert_eq!(arr.index_of(21).unwrap(), 0, "Index should be 0");
    assert_eq!(arr.index_of(42).unwrap(), 1, "Index should be 1");
    assert_eq!(arr.index_of(84).unwrap(), 2, "Index should be 2");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_different_type_span() {
    let arr = get_u128_array().span();
    assert_eq!(arr.index_of(21_u128).unwrap(), 0, "Index should be 0");
    assert_eq!(arr.index_of(42_u128).unwrap(), 1, "Index should be 1");
    assert_eq!(arr.index_of(84_u128).unwrap(), 2, "Index should be 2");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_panic_span() {
    let arr = get_felt252_array().span();
    assert!(arr.index_of(12).is_none(), "Should NOT contain 12");
}

#[test]
#[available_gas(2000000)]
fn index_of_empty_array_span() {
    let arr = array![].span();
    assert!(arr.index_of(21).is_none(), "Should NOT contain 21");
}

// occurrences_of

#[test]
#[available_gas(2000000)]
fn occurrences_of() {
    let arr = get_felt252_array();
    assert_eq!(arr.occurrences_of(21), 1, "Should contain 21 exactly once");
    assert_eq!(arr.occurrences_of(42), 1, "Should contain 42 exactly once");
    assert_eq!(arr.occurrences_of(84), 1, "Should contain 84 exactly once");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_different_type() {
    let arr = get_u128_array();
    assert_eq!(arr.occurrences_of(21_u128), 1, "Should contain 21 exactly once");
    assert_eq!(arr.occurrences_of(42_u128), 1, "Should contain 42 exactly once");
    assert_eq!(arr.occurrences_of(84_u128), 1, "Should contain 84 exactly once");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_not_in_array() {
    let arr = get_felt252_array();
    assert_eq!(arr.occurrences_of(12), 0, "Should contain exactly once");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_empty_array() {
    let arr = array![];
    assert_eq!(arr.occurrences_of(12), 0, "Should contain exactly 0");
    assert_eq!(arr.len(), 0, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_double() {
    let arr = array![21, 21, 84];
    assert_eq!(arr.occurrences_of(21), 2, "Should contain exactly 2");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_filled() {
    let arr = array![21, 21, 21];
    assert_eq!(arr.occurrences_of(21), 3, "Should contain exactly 3");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_span() {
    let arr = get_felt252_array().span();
    assert_eq!(arr.occurrences_of(21), 1, "Should contain 21 exactly once");
    assert_eq!(arr.occurrences_of(42), 1, "Should contain 42 exactly once");
    assert_eq!(arr.occurrences_of(84), 1, "Should contain 84 exactly once");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_different_type_span() {
    let arr = get_u128_array().span();
    assert_eq!(arr.occurrences_of(21_u128), 1, "Should contain 21 exactly once");
    assert_eq!(arr.occurrences_of(42_u128), 1, "Should contain 42 exactly once");
    assert_eq!(arr.occurrences_of(84_u128), 1, "Should contain 84 exactly once");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_not_in_array_span() {
    let arr = get_felt252_array().span();
    assert_eq!(arr.occurrences_of(12), 0, "Should contain exactly once");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_empty_array_span() {
    let arr = array![].span();
    assert_eq!(arr.occurrences_of(12), 0, "Should contain exactly 0");
    assert_eq!(arr.len(), 0, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_double_span() {
    let arr = array![21, 21, 84];
    assert_eq!(arr.span().occurrences_of(21), 2, "Should contain exactly 2");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_filled_span() {
    let arr = array![21, 21, 21];
    assert_eq!(arr.span().occurrences_of(21), 3, "Should contain exactly 3");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

// min

#[test]
#[available_gas(2000000)]
fn min() {
    let arr = @get_u128_array();
    assert_eq!(arr.min().unwrap(), 21_u128, "Min should be 21");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn min_step_one() {
    let mut arr = get_u128_array();
    arr.append(20_u128);
    assert_eq!(arr.min().unwrap(), 20_u128, "Min should be 20");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn min_with_duplicate() {
    let mut arr = get_u128_array();
    arr.append(21_u128);
    assert_eq!(arr.min().unwrap(), 21_u128, "Min should be 21");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn min_empty_array() {
    let arr: @Array<u128> = @array![];
    assert!(arr.index_of(12).is_none(), "Should be None");
}

#[test]
#[available_gas(2000000)]
fn min_one_item() {
    let arr = array![21_u128];
    assert_eq!(arr.min().unwrap(), 21_u128, "Min should be 21");
    assert_eq!(arr.len(), 1, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn min_last() {
    let arr = array![84_u128, 42_u128, 21_u128];
    assert_eq!(arr.min().unwrap(), 21_u128, "Min should be 21");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn min_span() {
    let arr = get_u128_array().span();
    assert_eq!(arr.min().unwrap(), 21_u128, "Min should be 21");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn min_step_one_span() {
    let mut arr = get_u128_array();
    arr.append(20_u128);
    assert_eq!(arr.span().min().unwrap(), 20_u128, "Min should be 20");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn min_with_duplicate_span() {
    let mut arr = get_u128_array();
    arr.append(21_u128);
    assert_eq!(arr.span().min().unwrap(), 21_u128, "Min should be 21");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn min_empty_array_span() {
    let arr: Span<u128> = array![].span();
    assert!(arr.index_of(12).is_none(), "Should be None");
}

#[test]
#[available_gas(2000000)]
fn min_one_item_span() {
    let arr = array![21_u128];
    assert_eq!(arr.span().min().unwrap(), 21_u128, "Min should be 21");
    assert_eq!(arr.len(), 1, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn min_last_span() {
    let arr = array![84_u128, 42_u128, 21_u128];
    assert_eq!(arr.span().min().unwrap(), 21_u128, "Min should be 21");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

// index_of_min

#[test]
#[available_gas(2000000)]
fn index_of_min() {
    let arr = get_u128_array();
    assert_eq!(arr.index_of_min().unwrap(), 0, "index_of_min should be 0");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_min_step_one() {
    let mut arr = get_u128_array();
    arr.append(20_u128);
    assert_eq!(arr.index_of_min().unwrap(), 3, "index_of_min should be 3");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_min_with_duplicate() {
    let mut arr = get_u128_array();
    arr.append(21_u128);
    assert_eq!(arr.index_of_min().unwrap(), 0, "index_of_min should be 0");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_min_empty_array() {
    let arr: Array<u128> = array![];
    assert!(arr.index_of_min().is_none(), "Should be None");
}

#[test]
#[available_gas(2000000)]
fn index_of_min_one_item() {
    let arr = array![21_u128];
    assert_eq!(arr.index_of_min().unwrap(), 0, "index_of_min should be 0");
    assert_eq!(arr.len(), 1, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_min_last() {
    let arr = array![84_u128, 42_u128, 21_u128];
    assert_eq!(arr.index_of_min().unwrap(), 2, "index_of_min should be 2");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}


#[test]
#[available_gas(2000000)]
fn index_of_min_span() {
    let arr = get_u128_array();
    assert_eq!(arr.span().index_of_min().unwrap(), 0, "index_of_min should be 0");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_min_step_one_span() {
    let mut arr = get_u128_array();
    arr.append(20_u128);
    assert_eq!(arr.span().index_of_min().unwrap(), 3, "index_of_min should be 3");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_min_with_duplicate_span() {
    let mut arr = get_u128_array();
    arr.append(21_u128);
    assert_eq!(arr.span().index_of_min().unwrap(), 0, "index_of_min should be 0");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_min_empty_array_span() {
    let arr: Array<u128> = array![];
    assert!(arr.span().index_of_min().is_none(), "Should be None");
}

#[test]
#[available_gas(2000000)]
fn index_of_min_one_item_span() {
    let arr = array![21_u128];
    assert_eq!(arr.span().index_of_min().unwrap(), 0, "index_of_min should be 0");
    assert_eq!(arr.len(), 1, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_min_last_span() {
    let arr = array![84_u128, 42_u128, 21_u128];
    assert_eq!(arr.span().index_of_min().unwrap(), 2, "index_of_min should be 2");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

// max

#[test]
#[available_gas(2000000)]
fn max() {
    let arr = get_u128_array();
    assert_eq!(arr.max().unwrap(), 84_u128, "Max should be 84");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn max_step_one() {
    let mut arr = get_u128_array();
    arr.append(85_u128);
    assert_eq!(arr.max().unwrap(), 85_u128, "Max should be 85");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn max_with_duplicate() {
    let mut arr = get_u128_array();
    arr.append(84_u128);
    assert_eq!(arr.max().unwrap(), 84_u128, "Max should be 84");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn max_empty_array() {
    let arr: @Array<u128> = @array![];
    assert!(arr.index_of(12).is_none(), "Should be None");
}

#[test]
#[available_gas(2000000)]
fn max_one_item() {
    let arr = array![21_u128];
    assert_eq!(arr.max().unwrap(), 21_u128, "Max should be 21");
    assert_eq!(arr.len(), 1, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn max_first() {
    let arr = array![84_u128, 42_u128, 21_u128];
    assert_eq!(arr.max().unwrap(), 84_u128, "Max should be 84");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn max_span() {
    let arr = get_u128_array();
    assert_eq!(arr.max().unwrap(), 84_u128, "Max should be 84");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn max_step_one_span() {
    let mut arr = get_u128_array();
    arr.append(85_u128);
    assert_eq!(arr.span().max().unwrap(), 85_u128, "Max should be 85");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn max_with_duplicate_span() {
    let mut arr = get_u128_array();
    arr.append(84_u128);
    assert_eq!(arr.span().max().unwrap(), 84_u128, "Max should be 84");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn max_empty_array_span() {
    let arr: Span<u128> = array![].span();
    assert!(arr.index_of(12).is_none(), "Should be None");
}

#[test]
#[available_gas(2000000)]
fn max_one_item_span() {
    let arr = array![21_u128];
    assert_eq!(arr.span().max().unwrap(), 21_u128, "Max should be 21");
    assert_eq!(arr.len(), 1, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn max_first_span() {
    let arr = array![84_u128, 42_u128, 21_u128];
    assert_eq!(arr.span().max().unwrap(), 84_u128, "Max should be 84");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

// index_of_max

#[test]
#[available_gas(2000000)]
fn index_of_max() {
    let arr = get_u128_array();
    assert_eq!(arr.index_of_max().unwrap(), 2, "index_of_max should be 2");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_max_step_one() {
    let mut arr = get_u128_array();
    arr.append(85_u128);
    assert_eq!(arr.index_of_max().unwrap(), 3, "index_of_max should be 3");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_max_with_duplicate() {
    let mut arr = get_u128_array();
    arr.append(84_u128);
    assert_eq!(arr.index_of_max().unwrap(), 2, "index_of_max should be 2");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_max_empty_array() {
    let arr: Array<u128> = array![];
    assert!(arr.index_of_max().is_none(), "Should be None");
}

#[test]
#[available_gas(2000000)]
fn index_of_max_one_item() {
    let arr = array![21_u128];
    assert_eq!(arr.index_of_max().unwrap(), 0, "index_of_max should be 0");
    assert_eq!(arr.len(), 1, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_max_last() {
    let arr = array![84_u128, 42_u128, 21_u128];
    assert_eq!(arr.index_of_max().unwrap(), 0, "index_of_max should be 0");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}


#[test]
#[available_gas(2000000)]
fn index_of_max_span() {
    let arr = get_u128_array();
    assert_eq!(arr.span().index_of_max().unwrap(), 2, "index_of_max should be 2");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_max_step_one_span() {
    let mut arr = get_u128_array();
    arr.append(85_u128);
    assert_eq!(arr.span().index_of_max().unwrap(), 3, "index_of_max should be 3");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_max_with_duplicate_span() {
    let mut arr = get_u128_array();
    arr.append(84_u128);
    assert_eq!(arr.span().index_of_max().unwrap(), 2, "index_of_max should be 2");
    assert_eq!(arr.len(), 4, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_max_empty_array_span() {
    let arr: Array<u128> = array![];
    assert!(arr.span().index_of_max().is_none(), "Should be None");
}

#[test]
#[available_gas(2000000)]
fn index_of_max_one_item_span() {
    let arr = array![21_u128];
    assert_eq!(arr.span().index_of_max().unwrap(), 0, "index_of_max should be 0");
    assert_eq!(arr.len(), 1, "arr should not be consummed");
}

#[test]
#[available_gas(2000000)]
fn index_of_max_last_span() {
    let arr = array![84_u128, 42_u128, 21_u128];
    assert_eq!(arr.span().index_of_max().unwrap(), 0, "index_of_max should be 0");
    assert_eq!(arr.len(), 3, "arr should not be consummed");
}

// unique

#[test]
#[available_gas(2000000)]
fn unique() {
    let arr = array![32_u128, 256_u128, 128_u128, 256_u128, 1024_u128];
    let out_arr = arr.unique();
    assert_eq!(out_arr.len(), 4, "Duplicates should be dropped");
    assert_eq!(*out_arr[0], 32_u128, "Should be 32");
    assert_eq!(*out_arr[1], 256_u128, "Should be 256");
    assert_eq!(*out_arr[2], 128_u128, "Should be 128");
    assert_eq!(*out_arr[3], 1024_u128, "Should be 1024");
}

#[test]
#[available_gas(2000000)]
fn unique_all() {
    let arr = array![84_u128, 84_u128, 84_u128];
    let out_arr = arr.unique();
    assert_eq!(out_arr.len(), 1, "Duplicates should be dropped");
    assert_eq!(*out_arr[0], 84_u128, "Should be 128");
}

#[test]
#[available_gas(2000000)]
fn unique_none() {
    let arr: Array<u128> = array![];
    let out_arr = arr.unique();
    assert_eq!(out_arr.len(), 0, "out_arr should be empty");
}

#[test]
#[available_gas(2000000)]
fn unique_at_start() {
    let arr = array![16_u128, 16_u128, 16_u128, 128_u128, 64_u128, 32_u128];
    let out_arr = arr.unique();
    assert_eq!(out_arr.len(), 4, "Duplicates should be dropped");
    assert_eq!(*out_arr[0], 16_u128, "Should be 16");
    assert_eq!(*out_arr[1], 128_u128, "Should be 128");
    assert_eq!(*out_arr[2], 64_u128, "Should be 64");
    assert_eq!(*out_arr[3], 32_u128, "Should be 32");
}

#[test]
#[available_gas(2000000)]
fn unique_at_middle() {
    let arr = array![128_u128, 256_u128, 84_u128, 84_u128, 84_u128, 1_u128];
    let out_arr = arr.unique();
    assert_eq!(out_arr.len(), 4, "Duplicates should be dropped");
    assert_eq!(*out_arr[0], 128_u128, "Should be 128");
    assert_eq!(*out_arr[1], 256_u128, "Should be 256");
    assert_eq!(*out_arr[2], 84_u128, "Should be 84");
    assert_eq!(*out_arr[3], 1_u128, "Should be 1");
}

#[test]
#[available_gas(2000000)]
fn unique_at_end() {
    let arr = array![32_u128, 16_u128, 64_u128, 128_u128, 128_u128, 128_u128];
    let out_arr = arr.unique();
    assert_eq!(out_arr.len(), 4, "Duplicates should be dropped");
    assert_eq!(*out_arr[0], 32_u128, "Should be 32");
    assert_eq!(*out_arr[1], 16_u128, "Should be 16");
    assert_eq!(*out_arr[2], 64_u128, "Should be 64");
    assert_eq!(*out_arr[3], 128_u128, "Should be 128");
}

#[test]
#[available_gas(2000000)]
fn unique_without_duplicates() {
    let arr = array![42_u128, 84_u128, 21_u128];
    let out_arr = arr.unique();
    assert_eq!(out_arr.len(), 3, "No values should drop");
    assert_eq!(*out_arr[0], 42_u128, "Should be 42");
    assert_eq!(*out_arr[1], 84_u128, "Should be 84");
    assert_eq!(*out_arr[2], 21_u128, "Should be 21");
}

// Utility fn

fn get_felt252_array() -> Array<felt252> {
    array![21, 42, 84]
}

fn get_u128_array() -> Array<u128> {
    array![21_u128, 42_u128, 84_u128]
}
