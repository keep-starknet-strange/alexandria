//! # Fast power algorithm
use core::ops::DivAssign;

/// Calculate the base ^ power
/// using the fast powering algorithm
/// #### Arguments
/// * ` base ` - The base of the exponentiation
/// * ` power ` - The power of the exponentiation
/// #### Returns
/// * ` T ` - The result of base ^ power
/// #### Panics
/// * ` base ` is 0
pub fn fast_power<
    T,
    +Div<T>,
    +DivAssign<T, T>,
    +Rem<T>,
    +Into<u8, T>,
    +Into<T, u256>,
    +TryInto<u256, T>,
    +PartialEq<T>,
    +Copy<T>,
    +Drop<T>,
>(
    base: T, mut power: T,
) -> T {
    assert!(base != 0_u8.into(), "fast_power: invalid input");

    let mut base: u256 = base.into();
    let mut result: u256 = 1;

    loop {
        if power % 2_u8.into() != 0_u8.into() {
            result *= base;
        }
        power /= 2_u8.into();
        if (power == 0_u8.into()) {
            break;
        }
        base *= base;
    }

    result.try_into().expect('too large to fit output type')
}

/// Calculate the ( base ^ power ) mod modulus
/// using the fast powering algorithm
/// #### Arguments
/// * ` base ` - The base of the exponentiation
/// * ` power ` - The power of the exponentiation
/// * ` modulus ` - The modulus used in the calculation
/// #### Returns
/// * ` T ` - The result of ( base ^ power ) mod modulus
/// #### Panics
/// * ` base ` is 0
pub fn fast_power_mod<
    T,
    +Div<T>,
    +DivAssign<T, T>,
    +Rem<T>,
    +Into<u8, T>,
    +Into<T, u256>,
    +TryInto<u256, T>,
    +PartialEq<T>,
    +Copy<T>,
    +Drop<T>,
>(
    base: T, mut power: T, modulus: T,
) -> T {
    assert!(base != 0_u8.into(), "fast_power: invalid input");

    if modulus == 1_u8.into() {
        return 0_u8.into();
    }

    let mut base: u256 = base.into();
    let modulus: u256 = modulus.into();
    let mut result: u256 = 1;

    loop {
        if power % 2_u8.into() != 0_u8.into() {
            result = (result * base) % modulus;
        }
        power /= 2_u8.into();
        if (power == 0_u8.into()) {
            break;
        }
        base = (base * base) % modulus;
    }

    result.try_into().expect('too large to fit output type')
}
