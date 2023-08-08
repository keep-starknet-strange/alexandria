use core::option::OptionTrait;
use array::{ArrayTrait, SpanTrait};

use alexandria::data_structures::array_ext::{ArrayTraitExt, SpanTraitExt};

// append_all

#[test]
#[available_gas(2000000)]
fn append_all() {
    let mut destination = array![21];
    let mut source = array![42, 84];
    destination.append_all(ref source);
    assert(destination.len() == 3, 'Len should be 3');
    assert(*destination[0] == 21, 'Should be 21');
    assert(*destination[1] == 42, 'Should be 42');
    assert(*destination[2] == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn append_all_different_type() {
    let mut destination = array![21_u128];
    let mut source = array![42_u128, 84_u128];
    destination.append_all(ref source);
    assert(destination.len() == 3, 'Len should be 3');
    assert(*destination[0] == 21_u128, 'Should be 21_u128');
    assert(*destination[1] == 42_u128, 'Should be 42_u128');
    assert(*destination[2] == 84_u128, 'Should be 84_u128');
}

#[test]
#[available_gas(2000000)]
fn append_all_destination_empty() {
    let mut destination = array![];
    let mut source = array![21, 42, 84];
    destination.append_all(ref source);
    assert(destination.len() == 3, 'Len should be 3');
    assert(*destination[0] == 21, 'Should be 21');
    assert(*destination[1] == 42, 'Should be 42');
    assert(*destination[2] == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn append_all_source_empty() {
    let mut destination = array![];
    let mut source = array![21, 42, 84];
    destination.append_all(ref source);
    assert(destination.len() == 3, 'Len should be 3');
    assert(*destination[0] == 21, 'Should be 0');
    assert(*destination[1] == 42, 'Should be 1');
    assert(*destination[2] == 84, 'Should be 2');
}

#[test]
#[available_gas(2000000)]
fn append_all_both_empty() {
    let mut destination: Array<felt252> = array![];
    let mut source = array![];
    destination.append_all(ref source);
    assert(source.len() == 0, 'Len should be 0');
    assert(destination.len() == 0, 'Len should be 0');
}

// reverse

#[test]
#[available_gas(2000000)]
fn reverse() {
    let mut arr = array![21, 42, 84];
    let response = arr.reverse();
    assert(response.len() == 3, 'Len should be 3');
    assert(*response[0] == 84, 'Should be 84');
    assert(*response[1] == 42, 'Should be 42');
    assert(*response[2] == 21, 'Should be 21');
}

#[test]
#[available_gas(2000000)]
fn reverse_size_1() {
    let mut arr = array![21];
    let response = arr.reverse();
    assert(response.len() == 1, 'Len should be 1');
    assert(*response[0] == 21, 'Should be 21');
}

#[test]
#[available_gas(2000000)]
fn reverse_empty() {
    let mut arr: Array<felt252> = array![];
    let response = arr.reverse();
    assert(response.len() == 0, 'Len should be 0');
}

#[test]
#[available_gas(2000000)]
fn reverse_different_type() {
    let mut arr = array![21_u128, 42_u128, 84_u128];
    let response = arr.reverse();
    assert(response.len() == 3, 'Len should be 3');
    assert(*response[0] == 84_u128, 'Should be 84_u128');
    assert(*response[1] == 42_u128, 'Should be 42_u128');
    assert(*response[2] == 21_u128, 'Should be 21_u128');
}

#[test]
#[available_gas(2000000)]
fn reverse_span() {
    let mut arr = array![21, 42, 84];
    let response = arr.span().reverse();
    assert(response.len() == 3, 'Len should be 3');
    assert(*response[0] == 84, 'Should be 84');
    assert(*response[1] == 42, 'Should be 42');
    assert(*response[2] == 21, 'Should be 21');
}

#[test]
#[available_gas(2000000)]
fn reverse_size_1_span() {
    let mut arr = array![21];
    let response = arr.span().reverse();
    assert(response.len() == 1, 'Len should be 1');
    assert(*response[0] == 21, 'Should be 21');
}

#[test]
#[available_gas(2000000)]
fn reverse_empty_span() {
    let mut arr: Array<felt252> = array![];
    let response = arr.span().reverse();
    assert(response.len() == 0, 'Len should be 0');
}

#[test]
#[available_gas(2000000)]
fn reverse_different_type_span() {
    let mut arr = array![21_u128, 42_u128, 84_u128];
    let response = arr.span().reverse();
    assert(response.len() == 3, 'Len should be 3');
    assert(*response[0] == 84_u128, 'Should be 84_u128');
    assert(*response[1] == 42_u128, 'Should be 42_u128');
    assert(*response[2] == 21_u128, 'Should be 21_u128');
}


// pop front n

#[test]
#[available_gas(2000000)]
fn pop_front_n() {
    let mut arr = get_felt252_array();
    arr.pop_front_n(2);
    assert(arr.len() == 1, 'Len should be 1');
    assert(arr.pop_front().unwrap() == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_different_type() {
    let mut arr = get_u128_array();
    arr.pop_front_n(2);
    assert(arr.len() == 1, 'Len should be 1');
    assert(arr.pop_front().unwrap() == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_empty_array() {
    let mut arr: Array<felt252> = array![];
    assert(arr.is_empty(), 'Should be empty');
    arr.pop_front_n(2);
    assert(arr.is_empty(), 'Should be empty');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_zero() {
    let mut arr = get_felt252_array();
    arr.pop_front_n(0);
    assert(arr.len() == 3, 'Len should be 1');
    assert(arr.pop_front().unwrap() == 21, 'Should be 21');
    assert(arr.pop_front().unwrap() == 42, 'Should be 42');
    assert(arr.pop_front().unwrap() == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_exact_len() {
    let mut arr = get_felt252_array();
    arr.pop_front_n(3);
    assert(arr.is_empty(), 'Should be empty');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_more_then_len() {
    let mut arr = get_felt252_array();
    arr.pop_front_n(4);
    assert(arr.is_empty(), 'Should be empty');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_front_n(2);
    assert(arr.len() == 1, 'Len should be 1');
    assert(*arr.pop_front().unwrap() == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_different_type_span() {
    let mut arr = get_u128_array().span();
    arr.pop_front_n(2);
    assert(arr.len() == 1, 'Len should be 1');
    assert(*arr.pop_front().unwrap() == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_empty_array_span() {
    let mut arr: Span<felt252> = array![].span();
    assert(arr.is_empty(), 'Should be empty');
    arr.pop_front_n(2);
    assert(arr.is_empty(), 'Should be empty');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_zero_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_front_n(0);
    assert(arr.len() == 3, 'Len should be 1');
    assert(*arr.pop_front().unwrap() == 21, 'Should be 21');
    assert(*arr.pop_front().unwrap() == 42, 'Should be 42');
    assert(*arr.pop_front().unwrap() == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_exact_len_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_front_n(3);
    assert(arr.is_empty(), 'Should be empty');
}

#[test]
#[available_gas(2000000)]
fn pop_front_n_more_then_len_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_front_n(4);
    assert(arr.is_empty(), 'Should be empty');
}

// pop back n
#[test]
#[available_gas(2000000)]
fn pop_back_n_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_back_n(2);
    assert(arr.len() == 1, 'Len should be 1');
    assert(*arr.pop_back().unwrap() == 21, 'Should be 21');
}

#[test]
#[available_gas(2000000)]
fn pop_back_n_different_type_span() {
    let mut arr = get_u128_array().span();
    arr.pop_back_n(2);
    assert(arr.len() == 1, 'Len should be 1');
    assert(*arr.pop_back().unwrap() == 21, 'Should be 21');
}

#[test]
#[available_gas(2000000)]
fn pop_back_n_empty_array_span() {
    let mut arr: Span<felt252> = array![].span();
    assert(arr.is_empty(), 'Should be empty');
    arr.pop_back_n(2);
    assert(arr.is_empty(), 'Should be empty');
}

#[test]
#[available_gas(2000000)]
fn pop_back_n_zero_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_back_n(0);
    assert(arr.len() == 3, 'Len should be 1');
    assert(*arr.pop_front().unwrap() == 21, 'Should be 21');
    assert(*arr.pop_front().unwrap() == 42, 'Should be 42');
    assert(*arr.pop_front().unwrap() == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn pop_back_n_exact_len_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_back_n(3);
    assert(arr.is_empty(), 'Should be empty');
}

#[test]
#[available_gas(2000000)]
fn pop_back_n_more_then_len_span() {
    let mut arr = get_felt252_array().span();
    arr.pop_back_n(4);
    assert(arr.is_empty(), 'Should be empty');
}


// contains

#[test]
#[available_gas(2000000)]
fn contains() {
    let mut arr = get_felt252_array();
    assert(arr.contains(21), 'Should contain 21');
    assert(arr.contains(42), 'Should contain 42');
    assert(arr.contains(84), 'Should contain 84');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn contains_different_type() {
    let mut arr = get_u128_array();
    assert(arr.contains(21_u128), 'Should contain 21_u128');
    assert(arr.contains(42_u128), 'Should contain 42_u128');
    assert(arr.contains(84_u128), 'Should contain 84_u128');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn contains_false() {
    let mut arr = get_felt252_array();
    assert(!arr.contains(85), 'Should be false');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn contains_empty_array() {
    let mut arr = array![];
    assert(!arr.contains(85), 'Should be false');
    assert(arr.len() == 0, 'arr should not be consummed');
}


#[test]
#[available_gas(2000000)]
fn contains_span() {
    let mut arr = get_felt252_array().span();
    assert(arr.contains(21), 'Should contain 21');
    assert(arr.contains(42), 'Should contain 42');
    assert(arr.contains(84), 'Should contain 84');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn contains_different_type_span() {
    let mut arr = get_u128_array().span();
    assert(arr.contains(21_u128), 'Should contain 21_u128');
    assert(arr.contains(42_u128), 'Should contain 42_u128');
    assert(arr.contains(84_u128), 'Should contain 84_u128');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn contains_false_span() {
    let mut arr = get_felt252_array().span();
    assert(!arr.contains(85), 'Should be false');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn contains_empty_array_span() {
    let mut arr = (array![]).span();
    assert(!arr.contains(85), 'Should be false');
    assert(arr.len() == 0, 'arr should not be consummed');
}

// index_of

#[test]
#[available_gas(2000000)]
fn index_of() {
    let mut arr = get_felt252_array();
    assert(arr.index_of(21).unwrap() == 0, 'Index should be 0');
    assert(arr.index_of(42).unwrap() == 1, 'Index should be 1');
    assert(arr.index_of(84).unwrap() == 2, 'Index should be 2');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_different_type() {
    let mut arr = get_u128_array();
    assert(arr.index_of(21_u128).unwrap() == 0, 'Index should be 0');
    assert(arr.index_of(42_u128).unwrap() == 1, 'Index should be 1');
    assert(arr.index_of(84_u128).unwrap() == 2, 'Index should be 2');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_panic() {
    let mut arr = get_felt252_array();
    assert(arr.index_of(12).is_none(), 'Should NOT contain 12');
}

#[test]
#[available_gas(2000000)]
fn index_of_empty_array() {
    let mut arr = array![];
    assert(arr.index_of(21).is_none(), 'Should NOT contain 21');
}

#[test]
#[available_gas(2000000)]
fn index_of_span() {
    let mut arr = get_felt252_array().span();
    assert(arr.index_of(21).unwrap() == 0, 'Index should be 0');
    assert(arr.index_of(42).unwrap() == 1, 'Index should be 1');
    assert(arr.index_of(84).unwrap() == 2, 'Index should be 2');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_different_type_span() {
    let mut arr = get_u128_array().span();
    assert(arr.index_of(21_u128).unwrap() == 0, 'Index should be 0');
    assert(arr.index_of(42_u128).unwrap() == 1, 'Index should be 1');
    assert(arr.index_of(84_u128).unwrap() == 2, 'Index should be 2');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_panic_span() {
    let mut arr = get_felt252_array().span();
    assert(arr.index_of(12).is_none(), 'Should NOT contain 12');
}

#[test]
#[available_gas(2000000)]
fn index_of_empty_array_span() {
    let mut arr = (array![]).span();
    assert(arr.index_of(21).is_none(), 'Should NOT contain 21');
}

// occurrences_of

#[test]
#[available_gas(2000000)]
fn occurrences_of() {
    let mut arr = get_felt252_array();
    assert(arr.occurrences_of(21) == 1, 'Should contain 21 exactly once');
    assert(arr.occurrences_of(42) == 1, 'Should contain 42 exactly once');
    assert(arr.occurrences_of(84) == 1, 'Should contain 84 exactly once');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_different_type() {
    let mut arr = get_u128_array();
    assert(arr.occurrences_of(21_u128) == 1, 'Should contain 21 exactly once');
    assert(arr.occurrences_of(42_u128) == 1, 'Should contain 42 exactly once');
    assert(arr.occurrences_of(84_u128) == 1, 'Should contain 84 exactly once');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_not_in_array() {
    let mut arr = get_felt252_array();
    assert(arr.occurrences_of(12) == 0, 'Should contain exactly once');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_empty_array() {
    let mut arr = array![];
    assert(arr.occurrences_of(12) == 0, 'Should contain exactly 0');
    assert(arr.len() == 0, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_double() {
    let mut arr = array![21, 21, 84];
    assert(arr.occurrences_of(21) == 2, 'Should contain exactly 2');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_filled() {
    let mut arr = array![21, 21, 21];
    assert(arr.occurrences_of(21) == 3, 'Should contain exactly 3');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_span() {
    let mut arr = get_felt252_array().span();
    assert(arr.occurrences_of(21) == 1, 'Should contain 21 exactly once');
    assert(arr.occurrences_of(42) == 1, 'Should contain 42 exactly once');
    assert(arr.occurrences_of(84) == 1, 'Should contain 84 exactly once');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_different_type_span() {
    let mut arr = get_u128_array().span();
    assert(arr.occurrences_of(21_u128) == 1, 'Should contain 21 exactly once');
    assert(arr.occurrences_of(42_u128) == 1, 'Should contain 42 exactly once');
    assert(arr.occurrences_of(84_u128) == 1, 'Should contain 84 exactly once');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_not_in_array_span() {
    let mut arr = get_felt252_array().span();
    assert(arr.occurrences_of(12) == 0, 'Should contain exactly once');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_empty_array_span() {
    let mut arr = array![].span();
    assert(arr.occurrences_of(12) == 0, 'Should contain exactly 0');
    assert(arr.len() == 0, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_double_span() {
    let mut arr = array![21, 21, 84];
    assert(arr.span().occurrences_of(21) == 2, 'Should contain exactly 2');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn occurrences_of_filled_span() {
    let mut arr = array![21, 21, 21];
    assert(arr.span().occurrences_of(21) == 3, 'Should contain exactly 3');
    assert(arr.len() == 3, 'arr should not be consummed');
}

// min

#[test]
#[available_gas(2000000)]
fn min() {
    let mut arr = @get_u128_array();
    assert(arr.min().unwrap() == 21_u128, 'Min should be 21');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn min_step_one() {
    let mut arr = get_u128_array();
    arr.append(20_u128);
    assert(arr.min().unwrap() == 20_u128, 'Min should be 20');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn min_with_duplicate() {
    let mut arr = get_u128_array();
    arr.append(21_u128);
    assert(arr.min().unwrap() == 21_u128, 'Min should be 21');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn min_empty_array() {
    let mut arr: @Array<u128> = @array![];
    assert(arr.index_of(12).is_none(), 'Should be None');
}

#[test]
#[available_gas(2000000)]
fn min_one_item() {
    let mut arr = array![21_u128];
    assert(arr.min().unwrap() == 21_u128, 'Min should be 21');
    assert(arr.len() == 1, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn min_last() {
    let mut arr = array![84_u128, 42_u128, 21_u128];
    assert(arr.min().unwrap() == 21_u128, 'Min should be 21');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn min_span() {
    let mut arr = get_u128_array().span();
    assert(arr.min().unwrap() == 21_u128, 'Min should be 21');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn min_step_one_span() {
    let mut arr = get_u128_array();
    arr.append(20_u128);
    assert(arr.span().min().unwrap() == 20_u128, 'Min should be 20');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn min_with_duplicate_span() {
    let mut arr = get_u128_array();
    arr.append(21_u128);
    assert(arr.span().min().unwrap() == 21_u128, 'Min should be 21');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn min_empty_array_span() {
    let mut arr: Span<u128> = array![].span();
    assert(arr.index_of(12).is_none(), 'Should be None');
}

#[test]
#[available_gas(2000000)]
fn min_one_item_span() {
    let mut arr = array![21_u128];
    assert(arr.span().min().unwrap() == 21_u128, 'Min should be 21');
    assert(arr.len() == 1, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn min_last_span() {
    let mut arr = array![84_u128, 42_u128, 21_u128];
    assert(arr.span().min().unwrap() == 21_u128, 'Min should be 21');
    assert(arr.len() == 3, 'arr should not be consummed');
}

// index_of_min

#[test]
#[available_gas(2000000)]
fn index_of_min() {
    let mut arr = get_u128_array();
    assert(arr.index_of_min().unwrap() == 0, 'index_of_min should be 0');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_min_step_one() {
    let mut arr = get_u128_array();
    arr.append(20_u128);
    assert(arr.index_of_min().unwrap() == 3, 'index_of_min should be 3');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_min_with_duplicate() {
    let mut arr = get_u128_array();
    arr.append(21_u128);
    assert(arr.index_of_min().unwrap() == 0, 'index_of_min should be 0');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_min_empty_array() {
    let mut arr: Array<u128> = array![];
    assert(arr.index_of_min().is_none(), 'Should be None');
}

#[test]
#[available_gas(2000000)]
fn index_of_min_one_item() {
    let mut arr = array![21_u128];
    assert(arr.index_of_min().unwrap() == 0, 'index_of_min should be 0');
    assert(arr.len() == 1, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_min_last() {
    let mut arr = array![84_u128, 42_u128, 21_u128];
    assert(arr.index_of_min().unwrap() == 2, 'index_of_min should be 2');
    assert(arr.len() == 3, 'arr should not be consummed');
}


#[test]
#[available_gas(2000000)]
fn index_of_min_span() {
    let mut arr = get_u128_array();
    assert(arr.span().index_of_min().unwrap() == 0, 'index_of_min should be 0');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_min_step_one_span() {
    let mut arr = get_u128_array();
    arr.append(20_u128);
    assert(arr.span().index_of_min().unwrap() == 3, 'index_of_min should be 3');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_min_with_duplicate_span() {
    let mut arr = get_u128_array();
    arr.append(21_u128);
    assert(arr.span().index_of_min().unwrap() == 0, 'index_of_min should be 0');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_min_empty_array_span() {
    let mut arr: Array<u128> = array![];
    assert(arr.span().index_of_min().is_none(), 'Should be None');
}

#[test]
#[available_gas(2000000)]
fn index_of_min_one_item_span() {
    let mut arr = array![21_u128];
    assert(arr.span().index_of_min().unwrap() == 0, 'index_of_min should be 0');
    assert(arr.len() == 1, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_min_last_span() {
    let mut arr = array![84_u128, 42_u128, 21_u128];
    assert(arr.span().index_of_min().unwrap() == 2, 'index_of_min should be 2');
    assert(arr.len() == 3, 'arr should not be consummed');
}

// max

#[test]
#[available_gas(2000000)]
fn max() {
    let mut arr = get_u128_array();
    assert(arr.max().unwrap() == 84_u128, 'Max should be 84');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn max_step_one() {
    let mut arr = get_u128_array();
    arr.append(85_u128);
    assert(arr.max().unwrap() == 85_u128, 'Max should be 85');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn max_with_duplicate() {
    let mut arr = get_u128_array();
    arr.append(84_u128);
    assert(arr.max().unwrap() == 84_u128, 'Max should be 84');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn max_empty_array() {
    let mut arr: @Array<u128> = @array![];
    assert(arr.index_of(12).is_none(), 'Should be None');
}

#[test]
#[available_gas(2000000)]
fn max_one_item() {
    let mut arr = array![21_u128];
    assert(arr.max().unwrap() == 21_u128, 'Max should be 21');
    assert(arr.len() == 1, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn max_first() {
    let mut arr = array![84_u128, 42_u128, 21_u128];
    assert(arr.max().unwrap() == 84_u128, 'Max should be 84');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn max_span() {
    let mut arr = get_u128_array();
    assert(arr.max().unwrap() == 84_u128, 'Max should be 84');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn max_step_one_span() {
    let mut arr = get_u128_array();
    arr.append(85_u128);
    assert(arr.span().max().unwrap() == 85_u128, 'Max should be 85');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn max_with_duplicate_span() {
    let mut arr = get_u128_array();
    arr.append(84_u128);
    assert(arr.span().max().unwrap() == 84_u128, 'Max should be 84');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn max_empty_array_span() {
    let mut arr: Span<u128> = array![].span();
    assert(arr.index_of(12).is_none(), 'Should be None');
}

#[test]
#[available_gas(2000000)]
fn max_one_item_span() {
    let mut arr = array![21_u128];
    assert(arr.span().max().unwrap() == 21_u128, 'Max should be 21');
    assert(arr.len() == 1, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn max_first_span() {
    let mut arr = array![84_u128, 42_u128, 21_u128];
    assert(arr.span().max().unwrap() == 84_u128, 'Max should be 84');
    assert(arr.len() == 3, 'arr should not be consummed');
}

// index_of_max

#[test]
#[available_gas(2000000)]
fn index_of_max() {
    let mut arr = get_u128_array();
    assert(arr.index_of_max().unwrap() == 2, 'index_of_max should be 2');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_max_step_one() {
    let mut arr = get_u128_array();
    arr.append(85_u128);
    assert(arr.index_of_max().unwrap() == 3, 'index_of_max should be 3');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_max_with_duplicate() {
    let mut arr = get_u128_array();
    arr.append(84_u128);
    assert(arr.index_of_max().unwrap() == 2, 'index_of_max should be 2');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_max_empty_array() {
    let mut arr: Array<u128> = array![];
    assert(arr.index_of_max().is_none(), 'Should be None');
}

#[test]
#[available_gas(2000000)]
fn index_of_max_one_item() {
    let mut arr = array![21_u128];
    assert(arr.index_of_max().unwrap() == 0, 'index_of_max should be 0');
    assert(arr.len() == 1, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_max_last() {
    let mut arr = array![84_u128, 42_u128, 21_u128];
    assert(arr.index_of_max().unwrap() == 0, 'index_of_max should be 0');
    assert(arr.len() == 3, 'arr should not be consummed');
}


#[test]
#[available_gas(2000000)]
fn index_of_max_span() {
    let mut arr = get_u128_array();
    assert(arr.span().index_of_max().unwrap() == 2, 'index_of_max should be 2');
    assert(arr.len() == 3, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_max_step_one_span() {
    let mut arr = get_u128_array();
    arr.append(85_u128);
    assert(arr.span().index_of_max().unwrap() == 3, 'index_of_max should be 3');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_max_with_duplicate_span() {
    let mut arr = get_u128_array();
    arr.append(84_u128);
    assert(arr.span().index_of_max().unwrap() == 2, 'index_of_max should be 2');
    assert(arr.len() == 4, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_max_empty_array_span() {
    let mut arr: Array<u128> = array![];
    assert(arr.span().index_of_max().is_none(), 'Should be None');
}

#[test]
#[available_gas(2000000)]
fn index_of_max_one_item_span() {
    let mut arr = array![21_u128];
    assert(arr.span().index_of_max().unwrap() == 0, 'index_of_max should be 0');
    assert(arr.len() == 1, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_max_last_span() {
    let mut arr = array![84_u128, 42_u128, 21_u128];
    assert(arr.span().index_of_max().unwrap() == 0, 'index_of_max should be 0');
    assert(arr.len() == 3, 'arr should not be consummed');
}


// Utility fn

fn get_felt252_array() -> Array<felt252> {
    let mut arr = array![21, 42, 84];
    arr
}

fn get_u128_array() -> Array<u128> {
    let mut arr = array![21_u128, 42_u128, 84_u128];
    arr
}
