use array::ArrayTrait;

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
    assert(*destination.at(0_usize) == 21, 'Should be 42');
    assert(*destination.at(1_usize) == 42, 'Should be 21');
    assert(*destination.at(2_usize) == 84, 'Should be 21');
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
    assert(*destination.at(0_usize) == 21, 'Should be 42');
    assert(*destination.at(1_usize) == 42, 'Should be 21');
    assert(*destination.at(2_usize) == 84, 'Should be 21');
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
    assert(*destination.at(0_usize) == 21, 'Should be 42');
    assert(*destination.at(1_usize) == 42, 'Should be 21');
    assert(*destination.at(2_usize) == 84, 'Should be 21');
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