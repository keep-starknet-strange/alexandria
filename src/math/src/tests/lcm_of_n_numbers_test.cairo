use alexandria_math::lcm_of_n_numbers::{lcm, LCMError};
use core::traits::Into;

// the following trait is not safe, it is only used for testing.
impl u128_to_u32 of Into<u128, u32> {
    fn into(self: u128) -> u32 {
        self.try_into().unwrap()
    }
}

#[test]
#[available_gas(1000000000)]
fn lcm_test() {
    let arr = array![2_u128, 4_u128, 6_u128, 8_u128, 10_u128];
    assert(lcm(arr.span()).unwrap() == 120, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn lcm_test_tryinto() {
    let arr = array![2_u32, 4_u32, 6_u32, 8_u32, 10_u32];
    assert(lcm(arr.span()).unwrap() == 120, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn lcm_test_inverse() {
    let arr = array![10_u128, 8_u128, 6_u128, 4_u128, 2_u128];
    assert(lcm(arr.span()).unwrap() == 120, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn lcm_test_3() {
    let arr = array![3_u128, 6_u128, 12_u128, 99_u128];
    assert(lcm(arr.span()).unwrap() == 396, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn lcm_test_4() {
    let arr = array![1_u128, 2_u128, 8_u128, 3_u128];
    assert(lcm(arr.span()).unwrap() == 24, 'invalid result');
}


#[test]
#[available_gas(1000000000)]
fn lcm_single_test() {
    let arr = array![10_u128];
    assert(lcm(arr.span()).unwrap() == 10, 'invalid result');
}

#[test]
#[available_gas(1000000000)]
fn lcm_empty_input_test() {
    let mut arr: Array<u128> = array![];
    assert(lcm(arr.span()) == Result::Err(LCMError::EmptyInput), 'Empty inputs');
}
