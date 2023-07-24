// Core lib imports
use traits::{Index, Into, TryInto};
use option::OptionTrait;
use result::ResultTrait;

// Internal imports
use alexandria::data_structures::vec::{Felt252Vec, NullableVec, VecTrait};

fn vec_new_test<V, T, impl Vec: VecTrait<V, T>>(vec: @V) {
    assert(vec.len() == 0, 'vec length should be 0');
}

fn vec_len_test<
    V,
    T,
    impl Vec: VecTrait<V, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<V>
>(
    ref vec: V, val_1: T
) {
    vec.push(val_1);
    assert(vec.len() == 1, 'vec length should be 1');
}

fn vec_get_test<
    V,
    T,
    impl Vec: VecTrait<V, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<V>
>(
    ref vec: V, val_1: T
) {
    vec.push(val_1);
    assert(vec.get(0).unwrap() == val_1, 'vec get should return val_1');
    assert(vec.get(1).is_none(), 'vec get should return none');
}

fn vec_at_test<
    V,
    T,
    impl Vec: VecTrait<V, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<V>
>(
    ref vec: V, val_1: T
) {
    vec.push(val_1);
    let result = vec.at(0);
    assert(vec.at(0) == val_1, 'vec at should return val_1');
}

fn vec_at_out_of_bounds_test<
    V,
    T,
    impl Vec: VecTrait<V, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<V>
>(
    ref vec: V
) {
    let result = vec.at(0);
}

fn vec_push_test<
    V,
    T,
    impl Vec: VecTrait<V, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<V>
>(
    ref vec: V, val_1: T
) {
    vec.push(val_1);
    assert(vec.len() == 1, 'vec length should be 1');
    assert(vec.at(0) == val_1, 'vec get should return val_1');
}

fn vec_set_test<
    V,
    T,
    impl Vec: VecTrait<V, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<V>
>(
    ref vec: V, val_1: T, val_2: T
) {
    vec.push(val_1);
    vec.set(0, val_2);
    let result = vec.get(0);
    assert(result.unwrap() == val_2, 'vec get should return val_2');
}

fn vec_set_test_expect_error<
    V,
    T,
    impl Vec: VecTrait<V, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<V>
>(
    ref vec: V, val_1: T, val_2: T
) {
    vec.push(val_1);
    vec.set(1, val_2);
}

fn vec_index_trait_test<
    V,
    T,
    impl Vec: VecTrait<V, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<V>,
    impl VIndex: Index<V, usize, T>
>(
    ref vec: V, val_1: T, val_2: T
) {
    vec.push(val_1);
    vec.push(val_2);
    assert(vec[0] == val_1, 'vec[0] != val_1');
    assert(vec[1] == val_2, 'vec[1] != val_2');
}

fn vec_index_trait_out_of_bounds_test<
    V,
    T,
    impl Vec: VecTrait<V, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<V>,
    impl VIndex: Index<V, usize, T>
>(
    ref vec: V, val_1: T
) {
    vec[0];
}


#[test]
#[available_gas(2000000)]
fn felt252_vec_new_test() {
    vec_new_test(@VecTrait::<Felt252Vec, u128>::new());
}

#[test]
#[available_gas(2000000)]
fn felt252_vec_len_test() {
    let mut vec = VecTrait::<Felt252Vec, u128>::new();
    vec_len_test(ref vec, 1);
}

#[test]
#[available_gas(2000000)]
fn felt252_vec_get_test() {
    let mut vec = VecTrait::<Felt252Vec, u128>::new();
    vec_get_test(ref vec, 1);
}

#[test]
#[available_gas(2000000)]
fn felt252_vec_at_test() {
    let mut vec = VecTrait::<Felt252Vec, u128>::new();
    vec_at_test(ref vec, 1);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Index out of bounds', ))]
fn felt252_vec_at_out_of_bounds_test() {
    let mut vec = VecTrait::<Felt252Vec, u128>::new();
    vec_at_out_of_bounds_test(ref vec);
}

#[test]
#[available_gas(2000000)]
fn felt252_vec_push_test() {
    let mut vec = VecTrait::<Felt252Vec, u128>::new();
    vec_push_test(ref vec, 1);
}

#[test]
#[available_gas(2000000)]
fn felt252_vec_set_test() {
    let mut vec = VecTrait::<Felt252Vec, u128>::new();
    vec_set_test(ref vec, 1, 2);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Index out of bounds', ))]
fn felt252_vec_set_test_expect_error() {
    let mut vec = VecTrait::<Felt252Vec, u128>::new();
    vec_set_test_expect_error(ref vec, 1, 2);
}

#[test]
#[available_gas(2000000)]
fn felt252_vec_index_trait_test() {
    let mut vec = VecTrait::<Felt252Vec, u128>::new();
    vec_index_trait_test(ref vec, 1, 2);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Index out of bounds', ))]
fn felt252_vec_index_trait_out_of_bounds_test() {
    let mut vec = VecTrait::<Felt252Vec, u128>::new();
    vec_index_trait_out_of_bounds_test(ref vec, 1);
}

#[test]
#[available_gas(2000000)]
fn nullable_vec_new_test() {
    vec_new_test(@VecTrait::<NullableVec, u128>::new());
}

#[test]
#[available_gas(2000000)]
fn nullable_vec_len_test() {
    let mut vec = VecTrait::<NullableVec, u128>::new();
    vec_len_test(ref vec, 1);
}

#[test]
#[available_gas(2000000)]
fn nullable_vec_get_test() {
    let mut vec = VecTrait::<NullableVec, u128>::new();
    vec_get_test(ref vec, 1);
}

#[test]
#[available_gas(2000000)]
fn nullable_vec_at_test() {
    let mut vec = VecTrait::<NullableVec, u128>::new();
    vec_at_test(ref vec, 1);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Index out of bounds', ))]
fn nullable_vec_at_out_of_bounds_test() {
    let mut vec = VecTrait::<NullableVec, u128>::new();
    vec_at_out_of_bounds_test(ref vec);
}

#[test]
#[available_gas(2000000)]
fn nullable_vec_push_test() {
    let mut vec = VecTrait::<NullableVec, u128>::new();
    vec_push_test(ref vec, 1);
}

#[test]
#[available_gas(2000000)]
fn nullable_vec_set_test() {
    let mut vec = VecTrait::<NullableVec, u128>::new();
    vec_set_test(ref vec, 1, 2);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Index out of bounds', ))]
fn nullable_vec_set_test_expect_error() {
    let mut vec = VecTrait::<NullableVec, u128>::new();
    vec_set_test_expect_error(ref vec, 1, 2);
}

#[test]
#[available_gas(2000000)]
fn nullable_vec_index_trait_test() {
    let mut vec = VecTrait::<NullableVec, u128>::new();
    vec_index_trait_test(ref vec, 1, 2);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Index out of bounds', ))]
fn nullable_vec_index_trait_out_of_bounds_test() {
    let mut vec = VecTrait::<NullableVec, u128>::new();
    vec_index_trait_out_of_bounds_test(ref vec, 1);
}
