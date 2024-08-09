use alexandria_math::lcm_of_n_numbers::{lcm, LCMError};

// the following trait is not safe, it is only used for testing.
impl u128_into_u32 of Into<u128, u32> {
    fn into(self: u128) -> u32 {
        let self: felt252 = self.into();
        self.try_into().unwrap()
    }
}

#[test]
#[available_gas(1000000000)]
fn lcm_test() {
    let arr = array![2_u128, 4, 6, 8, 10];
    assert_eq!(lcm(arr.span()).unwrap(), 120);
}

#[test]
#[available_gas(1000000000)]
fn lcm_test_tryinto() {
    let arr = array![2_u32, 4, 6, 8, 10];
    assert_eq!(lcm(arr.span()).unwrap(), 120);
}

#[test]
#[available_gas(1000000000)]
fn lcm_test_inverse() {
    let arr = array![10_u128, 8, 6, 4, 2];
    assert_eq!(lcm(arr.span()).unwrap(), 120);
}

#[test]
#[available_gas(1000000000)]
fn lcm_test_3() {
    let arr = array![3_u128, 6, 12, 99];
    assert_eq!(lcm(arr.span()).unwrap(), 396);
}

#[test]
#[available_gas(1000000000)]
fn lcm_test_4() {
    let arr = array![1_u128, 2, 8, 3];
    assert_eq!(lcm(arr.span()).unwrap(), 24);
}


#[test]
#[available_gas(1000000000)]
fn lcm_single_test() {
    let arr = array![10_u128];
    assert_eq!(lcm(arr.span()).unwrap(), 10);
}

#[test]
#[available_gas(1000000000)]
fn lcm_empty_input_test() {
    let arr: Array<u128> = array![];
    assert!(lcm(arr.span()) == Result::Err(LCMError::EmptyInput), "Empty inputs");
}
