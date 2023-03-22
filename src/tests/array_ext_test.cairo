use array::ArrayTrait;
use array::SpanTrait;

use quaireaux::data_structures::array_ext::ArrayTraitExt;

#[test]
#[available_gas(2000000)]
fn test_append_all() {
    let mut destination = ArrayTrait::new();
    let mut source = ArrayTrait::new();
    destination.append(21);
    source.append(42);
    source.append(84);
    destination.append_all(ref source);
    assert(destination.len() == 3_usize, 'Len should be 3');
    assert(*destination.at(0_usize) == 21, 'Should be 21');
    assert(*destination.at(1_usize) == 42, 'Should be 42');
    assert(*destination.at(2_usize) == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn test_append_all_different_type() {
    let mut destination = ArrayTrait::new();
    let mut source = ArrayTrait::new();
    destination.append(21_u128);
    source.append(42_u128);
    source.append(84_u128);
    destination.append_all(ref source);
    assert(destination.len() == 3_usize, 'Len should be 3');
    assert(*destination.at(0_usize) == 21_u128, 'Should be 21_u128');
    assert(*destination.at(1_usize) == 42_u128, 'Should be 42_u128');
    assert(*destination.at(2_usize) == 84_u128, 'Should be 84_u128');
}

#[test]
#[available_gas(2000000)]
fn test_append_all_destination_empty() {
    let mut destination = ArrayTrait::new();
    let mut source = ArrayTrait::new();
    source.append(21);
    source.append(42);
    source.append(84);
    destination.append_all(ref source);
    assert(destination.len() == 3_usize, 'Len should be 3');
    assert(*destination.at(0_usize) == 21, 'Should be 21');
    assert(*destination.at(1_usize) == 42, 'Should be 42');
    assert(*destination.at(2_usize) == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn test_append_all_source_empty() {
    let mut destination = ArrayTrait::new();
    let mut source = ArrayTrait::new();
    destination.append(21);
    destination.append(42);
    destination.append(84);
    destination.append_all(ref source);
    assert(destination.len() == 3_usize, 'Len should be 3');
    assert(*destination.at(0_usize) == 21, 'Should be 21');
    assert(*destination.at(1_usize) == 42, 'Should be 42');
    assert(*destination.at(2_usize) == 84, 'Should be 84');
}

#[test]
#[available_gas(2000000)]
fn test_append_all_both_empty() {
    let mut destination = ArrayTrait::<felt252>::new();
    let mut source = ArrayTrait::new();
    destination.append_all(ref source);
    assert(source.len() == 0_usize, 'Len should be 0');
    assert(destination.len() == 0_usize, 'Len should be 0');
}

#[test]
#[available_gas(2000000)]
fn test_reverse() {
    let mut arr = ArrayTrait::new();
    arr.append(21);
    arr.append(42);
    arr.append(84);
    let response = arr.reverse();
    assert(response.len() == 3_usize, 'Len should be 3');
    assert(*response.at(0_usize) == 84, 'Should be 84');
    assert(*response.at(1_usize) == 42, 'Should be 42');
    assert(*response.at(2_usize) == 21, 'Should be 21');
}

#[test]
#[available_gas(2000000)]
fn test_reverse_size_1() {
    let mut arr = ArrayTrait::new();
    arr.append(21);
    let response = arr.reverse();
    assert(response.len() == 1_usize, 'Len should be 3');
    assert(*response.at(0_usize) == 21, 'Should be 21');
}

#[test]
#[available_gas(2000000)]
fn test_reverse_empty() {
    let mut arr = ArrayTrait::<felt252>::new();
    let response = arr.reverse();
    assert(response.len() == 0_usize, 'Len should be 0');
}

#[test]
#[available_gas(2000000)]
fn test_reverse_different_type() {
    let mut arr = ArrayTrait::new();
    arr.append(21_u128);
    arr.append(42_u128);
    arr.append(84_u128);
    let response = arr.reverse();
    assert(response.len() == 3_usize, 'Len should be 3');
    assert(*response.at(0_usize) == 84_u128, 'Should be 84_u128');
    assert(*response.at(1_usize) == 42_u128, 'Should be 42_u128');
    assert(*response.at(2_usize) == 21_u128, 'Should be 21_u128');
}
