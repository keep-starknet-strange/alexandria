use core::traits::Destruct;
// Core lib imports
use array::ArrayTrait;
use traits::{Index, Into, TryInto};
use option::OptionTrait;
use result::ResultTrait;
use dict::Felt252DictTrait;
use integer::u128_as_non_zero;

// Internal imports
use alexandria_data_structures::fenwick_tree::FenwickTreeTrait;
use alexandria_data_structures::fenwick_tree::FenwickTreeImpl;
use alexandria_data_structures::fenwick_tree::FenwickTree;

impl U128Zeroable of Zeroable<u128> {
    fn zero() -> u128 {
        0
    }
    #[inline(always)]
    fn is_zero(self: u128) -> bool {
        self == U128Zeroable::zero()
    }
    #[inline(always)]
    fn is_non_zero(self: u128) -> bool {
        self != U128Zeroable::zero()
    }
}

fn a_fenwick_tree() -> FenwickTree<u128> {
    let mut ft = FenwickTreeTrait::<u128>::new(10_u128);
    ft.add(1_u128, 1_u128);
    ft.add(2_u128, 7_u128);
    ft.add(3_u128, 3_u128);
    ft.add(4_u128, 99_u128);
    ft.add(5_u128, 13_u128);
    ft.add(6_u128, 49_u128);
    ft.add(7_u128, 21_u128);
    ft.add(8_u128, 3_u128);
    ft.add(9_u128, 1_u128);
    ft.add(10_u128, 200_u128);

    ft
}

#[test]
#[available_gas(2000000)]
fn fw_new_test() {
    let mut ft = FenwickTreeTrait::<u128>::new(10_u128);
    assert(ft.len == 10_u128, 'wrong length');
    assert(ft.sum(10) == 0_u128, 'wrong sum');
}

#[test]
#[available_gas(20000000)]
fn ft_sum_test() {
    let mut ft = a_fenwick_tree();

    assert(ft.sum(0_u128) == 0_u128, 'wrong sum of 0');
    assert(ft.sum(10_u128) == 1_u128 + 7_u128 + 3_u128 + 99_u128 + 13_u128 + 49_u128 + 21_u128 + 3_u128 + 1_u128 + 200_u128, 'wrong sum between: 1 - 10');
    assert(ft.sum_between(1_u128, 3_u128) == 1_u128 + 7_u128 + 3_u128, 'wrong sum between: 1 - 3');
    assert(ft.sum_between(4_u128, 6_u128) == 99_u128 + 13_u128 + 49_u128, 'wrong sum between: 4 - 6');
    assert(ft.sum_between(8_u128, 10_u128) == 3_u128 + 1_u128 + 200_u128, 'wrong sum between: 8 - 10');
}

#[test]
#[available_gas(20000000)]
fn ft_add_test() {
    let mut ft = a_fenwick_tree();

    let s0_10 = ft.sum(10_u128);
    let s2_10 = ft.sum_between(2_u128, 10_u128);

    ft.add(1_u128, 1_u128);

    assert(ft.sum(10_u128) == s0_10 + 1_u128, 'wrong sum(1,10) after add');
    assert(ft.sum_between(2_u128, 10_u128) == s2_10, 'wrong sum(2,10) after add');

}


// 1_u128 + 7_u128 + 3_u128 + 99_u128 + 13_u128 + 49_u128 + 21_u128 + 3_u128 + 1_u128 + 200_u128


// #[test]
// #[available_gas(2000000)]
// fn vec_get_test() {
//     let mut vec = VecTrait::<u128>::new();
//     let insert_val: u128 = 1;
//     vec.items.insert(0, insert_val);
//     vec.len = 1;
//     let result_exists = vec.get(0);
//     let result_none = vec.get(1);
//     assert(result_exists.unwrap() == 1, 'vec get should return 1');
//     assert(result_none.is_none(), 'vec get should return none');
// }

// #[test]
// #[available_gas(2000000)]
// fn vec_at_test() {
//     let mut vec = VecTrait::<u128>::new();
//     let insert_val: u128 = 1;
//     vec.items.insert(0, insert_val);
//     vec.len = 1;
//     let result = vec.at(0);
//     assert(result == 1, 'vec at should return 1');
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected: ('Index out of bounds', ))]
// fn vec_at_out_of_bounds_test() {
//     let mut vec = VecTrait::<u128>::new();
//     let result = vec.at(0);
// }

// #[test]
// #[available_gas(2000000)]
// fn vec_push_test() {
//     let mut vec = VecTrait::<u128>::new();
//     let pushed_val: u128 = 1;
//     vec.push(pushed_val);
//     let result_len = vec.len();
//     assert(result_len == 1, 'vec length should be 1');
//     let value = vec.at(0);
//     assert(value == pushed_val, 'vec get should return 1');
// }

// #[test]
// #[available_gas(2000000)]
// fn vec_set_test() {
//     let mut vec = VecTrait::<u128>::new();
//     vec.push(1);
//     vec.set(0, 2);
//     let result = vec.get(0);
//     assert(result.unwrap() == 2, 'vec get should return 2');
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected: ('Index out of bounds', ))]
// fn vec_set_test_expect_error() {
//     let mut vec = VecTrait::<u128>::new();
//     vec.push(1);
//     vec.set(1, 2)
// }

// #[test]
// #[available_gas(2000000)]
// fn vec_index_trait_test() {
//     let mut vec = VecTrait::<u128>::new();
//     vec.push(42);
//     vec.push(0x1337);
//     assert(vec[0] == 42, 'vec[0] != 42');
//     assert(vec[1] == 0x1337, 'vec[1] != 0x1337');
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected: ('Index out of bounds', ))]
// fn vec_index_trait_out_of_bounds_test() {
//     let mut vec = VecTrait::<u128>::new();
//     vec[0];
// }
