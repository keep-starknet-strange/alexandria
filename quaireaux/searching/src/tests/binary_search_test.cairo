use quaireaux_searching::binary_search::binary_search;
use array::ArrayTrait;
use option::OptionTrait;

#[test]
#[available_gas(2000000)]
fn value_found() {
    let mut arr: Array<u128> = ArrayTrait::new();

    arr.append(100); // 0
    arr.append(200); // 1
    arr.append(300); // 2
    arr.append(400); // 3
    arr.append(500); // 4
    arr.append(600); // 5

    let mut span = arr.span();

    // Test with an even length
    assert(binary_search(span, 100).unwrap() == 0, 'Incorrect index');
    assert(binary_search(span, 200).unwrap() == 1, 'Incorrect index');
    assert(binary_search(span, 300).unwrap() == 2, 'Incorrect index');
    assert(binary_search(span, 400).unwrap() == 3, 'Incorrect index');

    // Odd length
    arr.append(700); // 5
    span = arr.span();
    assert(binary_search(span, 100).unwrap() == 0, 'Incorrect index');
    assert(binary_search(span, 200).unwrap() == 1, 'Incorrect index');
    assert(binary_search(span, 300).unwrap() == 2, 'Incorrect index');
    assert(binary_search(span, 400).unwrap() == 3, 'Incorrect index');
}

#[test]
#[available_gas(2000000)]
fn value_not_found() {
    let mut arr: Array<u128> = ArrayTrait::new();

    arr.append(100); // 0
    arr.append(200); // 1
    arr.append(300); // 2
    arr.append(400); // 3
    arr.append(500); // 4
    arr.append(600); // 5

    // Test with an even length
    let mut span = arr.span();
    assert(binary_search(span, 20).is_none() == true, 'value was found');
    assert(binary_search(span, 42000).is_none() == true, 'value was found');
    assert(binary_search(span, 760).is_none() == true, 'value was found');

    // Odd length
    arr.append(700); // 6
    span = arr.span();
    assert(binary_search(span, 20).is_none() == true, 'value was found');
    assert(binary_search(span, 42000).is_none() == true, 'value was found');
    assert(binary_search(span, 760).is_none() == true, 'value was found');
}

#[test]
#[available_gas(2000000)]
fn value_found_length_one() {
    let mut arr: Array<u128> = ArrayTrait::new();

    arr.append(100); // 0

    let span = arr.span();
    assert(binary_search(span, 100).unwrap() == 0, 'value was found')
}

#[test]
#[available_gas(2000000)]
fn value_not_found_length_one() {
    let mut arr: Array<u128> = ArrayTrait::new();

    arr.append(100); // 0

    let span = arr.span();
    assert(binary_search(span, 50).is_none() == true, 'value was found')
}

#[test]
#[available_gas(2000000)]
fn zero_length_span() {
    let mut arr: Array<u128> = ArrayTrait::new();

    let span = arr.span();
    assert(binary_search(span, 100).is_none() == true, 'value was found')
}
