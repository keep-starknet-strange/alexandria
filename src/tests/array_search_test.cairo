use array::ArrayTrait;
use array::SpanTrait;

use quaireaux::data_structures::array_search::ArraySearchExt;

#[test]
#[available_gas(2000000)]
fn contains() {
    let mut arr = get_felt252_array();
    assert(arr.contains(21), 'Should contain 21');
    assert(arr.contains(42), 'Should contain 42');
    assert(arr.contains(84), 'Should contain 84');
    assert(arr.len() == 3_usize, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn contains_different_type() {
    let mut arr = get_u128_array();
    assert(arr.contains(21_u128), 'Should contain 21_u128');
    assert(arr.contains(42_u128), 'Should contain 42_u128');
    assert(arr.contains(84_u128), 'Should contain 84_u128');
    assert(arr.len() == 3_usize, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn contains_false() {
    let mut arr = get_felt252_array();
    assert(arr.contains(85) == false, 'Should be false');
    assert(arr.len() == 3_usize, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of() {
    let mut arr = get_felt252_array();
    assert(arr.index_of(21) == 0_usize, 'Index should be 0');
    assert(arr.index_of(42) == 1_usize, 'Index should be 1');
    assert(arr.index_of(84) == 2_usize, 'Index should be 2');
    assert(arr.len() == 3_usize, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
fn index_of_different_type() {
    let mut arr = get_u128_array();
    assert(arr.index_of(21_u128) == 0_usize, 'Index should be 0');
    assert(arr.index_of(42_u128) == 1_usize, 'Index should be 1');
    assert(arr.index_of(84_u128) == 2_usize, 'Index should be 2');
    assert(arr.len() == 3_usize, 'arr should not be consummed');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('Item not in array', ))]
fn index_of_panic() {
    let mut arr = get_felt252_array();
    arr.index_of(12);
}

// Utility fn
fn get_felt252_array() -> Array<felt252> {
    let mut arr = ArrayTrait::new();
    arr.append(21);
    arr.append(42);
    arr.append(84);
    arr
}

fn get_u128_array() -> Array<u128> {
    let mut arr = ArrayTrait::new();
    arr.append(21_u128);
    arr.append(42_u128);
    arr.append(84_u128);
    arr
}
