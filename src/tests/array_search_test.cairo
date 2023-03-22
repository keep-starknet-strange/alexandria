use array::ArrayTrait;
use array::SpanTrait;

use quaireaux::data_structures::array_search::ArraySearchExt;

#[test]
#[available_gas(2000000)]
fn test_contains() {
    let mut arr = ArrayTrait::new();
    arr.append(21);
    arr.append(42);
    arr.append(84);
    assert(arr.contains(21), 'Should contain 21');
    assert(arr.contains(42), 'Should contain 42');
    assert(arr.contains(84), 'Should contain 84');
    assert(arr.len() == 3_usize, 'arr should not be consummed');
    assert(*arr.at(0_usize) == 21, 'Should be 21');
    assert(*arr.at(1_usize) == 42, 'Should be 42');
    assert(*arr.at(2_usize) == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn test_contains_different_type() {
    let mut arr = get_felt252_array();
    assert(arr.contains(21), 'Should contain 21');
    assert(arr.contains(42), 'Should contain 42');
    assert(arr.contains(84), 'Should contain 84');
    assert(arr.len() == 3_usize, 'arr should not be consummed');
    assert(*arr.at(0_usize) == 21, 'Should be 21');
    assert(*arr.at(1_usize) == 42, 'Should be 42');
    assert(*arr.at(2_usize) == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn test_contains_false() {
    let mut arr = ArrayTrait::new();
    arr.append(21);
    arr.append(42);
    arr.append(84);
    assert(arr.contains(85) == false, 'Should be false');
}

// Utility fn

fn get_felt252_array() -> Array<felt252> {
    let mut arr = ArrayTrait::new();
    arr.append(21);
    arr.append(42);
    arr.append(84);
    arr
}
