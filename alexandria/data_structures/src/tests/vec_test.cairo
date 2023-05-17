// Core lib imports
use array::ArrayTrait;
use traits::{Index, Into, TryInto};
use option::OptionTrait;
use result::ResultTrait;
use dict::Felt252DictTrait;

// Internal imports
use alexandria_data_structures::vec::VecTrait;

#[test]
#[available_gas(2000000)]
fn vec_new_test() {
    let mut vec = VecTrait::<u128>::new();
    let result_len = vec.len();
    assert(result_len == 0, 'vec length should be 0');
}
#[test]
#[available_gas(2000000)]
fn vec_len_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.len = 10;
    let result_len = vec.len();
    assert(result_len == 10, 'vec length should be 10');
}

#[test]
#[available_gas(2000000)]
fn vec_get_test() {
    let mut vec = VecTrait::<u128>::new();
    let insert_val: u128 = 1;
    vec.items.insert(0, insert_val);
    vec.len = 1;
    let result_exists = vec.get(0);
    let result_none = vec.get(1);
    assert(result_exists.unwrap() == 1, 'vec get should return 1');
    assert(result_none.is_none(), 'vec get should return none');
}

#[test]
#[available_gas(2000000)]
fn vec_at_test() {
    let mut vec = VecTrait::<u128>::new();
    let insert_val: u128 = 1;
    vec.items.insert(0, insert_val);
    vec.len = 1;
    let result = vec.at(0);
    assert(result == 1, 'vec at should return 1');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Index out of bounds', ))]
fn vec_at_out_of_bounds_test() {
    let mut vec = VecTrait::<u128>::new();
    let result = vec.at(0);
}

#[test]
#[available_gas(2000000)]
fn vec_push_test() {
    let mut vec = VecTrait::<u128>::new();
    let pushed_val: u128 = 1;
    vec.push(pushed_val);
    let result_len = vec.len();
    assert(result_len == 1, 'vec length should be 1');
    let value = vec.at(0);
    assert(value == pushed_val, 'vec get should return 1');
}

#[test]
#[available_gas(2000000)]
fn vec_set_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.push(1);
    vec.set(0, 2);
    let result = vec.get(0);
    assert(result.unwrap() == 2, 'vec get should return 2');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Index out of bounds', ))]
fn vec_set_test_expect_error() {
    let mut vec = VecTrait::<u128>::new();
    vec.push(1);
    vec.set(1, 2)
}

#[test]
#[available_gas(2000000)]
fn vec_index_trait_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.push(42);
    vec.push(0x1337);
    assert(vec[0] == 42, 'vec[0] != 42');
    assert(vec[1] == 0x1337, 'vec[1] != 0x1337');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Index out of bounds', ))]
fn vec_index_trait_out_of_bounds_test() {
    let mut vec = VecTrait::<u128>::new();
    vec[0];
}
