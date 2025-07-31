use core::integer::u512;
use core::num::traits::{OverflowingAdd, OverflowingSub};
use core::result::ResultTrait;

/// Performs addition with overflow detection
/// #### Arguments
/// * `lhs` - Left operand (u256)
/// * `rhs` - Right operand (u256)
/// #### Returns
/// * `Result<u256, u256>` - Ok(sum) if no overflow, Err(wrapped_sum) if overflow
fn u256_overflow_add(lhs: u256, rhs: u256) -> Result<u256, u256> implicits(RangeCheck) {
    let (sum, overflow) = lhs.overflowing_add(rhs);
    if overflow {
        Result::Err(sum)
    } else {
        Result::Ok(sum)
    }
}

/// Performs subtraction with overflow detection
/// #### Arguments
/// * `lhs` - Left operand (u256)
/// * `rhs` - Right operand (u256)
/// #### Returns
/// * `Result<u256, u256>` - Ok(difference) if no overflow, Err(wrapped_difference) if overflow
fn u256_overflow_sub(lhs: u256, rhs: u256) -> Result<u256, u256> implicits(RangeCheck) {
    let (sum, overflow) = lhs.overflowing_sub(rhs);
    if overflow {
        Result::Err(sum)
    } else {
        Result::Ok(sum)
    }
}

#[derive(Copy, Drop, Hash, PartialEq, Serde)]
pub struct u256X2 {
    low: u256,
    high: u256,
}

pub impl U512Intou256X2 of Into<u512, u256X2> {
    #[inline(always)]
    fn into(self: u512) -> u256X2 {
        let u512 { limb0: low, limb1: high, limb2, limb3 } = self;
        u256X2 { low: u256 { low, high }, high: u256 { low: limb2, high: limb3 } }
    }
}

/// Adds two u512 values with overflow panic
/// #### Arguments
/// * `lhs` - Left operand (u512)
/// * `rhs` - Right operand (u512)
/// #### Returns
/// * `u512` - Sum of lhs and rhs
/// #### Panics
/// * Panics if the addition would overflow u512 bounds
#[inline(always)]
pub fn u512_add(lhs: u512, rhs: u512) -> u512 {
    let lhs: u256X2 = lhs.into();
    let rhs: u256X2 = rhs.into();

    // No overflow allowed
    let u256 {
        low: limb2, high: limb3,
    } = u256_overflow_add(lhs.high, rhs.high).expect('u512 add overflow');

    match u256_overflow_add(lhs.low, rhs.low) {
        Result::Ok(u256 { low: limb0, high: limb1 }) => { u512 { limb0, limb1, limb2, limb3 } },
        Result::Err(u256 {
            low: limb0, high: limb1,
        }) => {
            // Try to move overflow to limb2
            let (limb2, did_overflow) = limb2.overflowing_add(1_u128);
            if did_overflow {
                // Try to move overflow to limb3
                let (limb3, did_overflow) = limb3.overflowing_add(1_u128);
                if did_overflow {
                    panic!("u512 add overflow");
                }
                u512 { limb0, limb1, limb2, limb3 }
            } else {
                u512 { limb0, limb1, limb2, limb3 }
            }
        },
    }
}

/// Subtracts two u512 values with overflow panic
/// #### Arguments
/// * `lhs` - Left operand (u512)
/// * `rhs` - Right operand (u512)
/// #### Returns
/// * `u512` - Difference of lhs and rhs
/// #### Panics
/// * Panics if the subtraction would underflow (result < 0)
#[inline(always)]
pub fn u512_sub(lhs: u512, rhs: u512) -> u512 {
    let lhs: u256X2 = lhs.into();
    let rhs: u256X2 = rhs.into();

    // No overflow allowed
    let u256 {
        low: limb2, high: limb3,
    } = u256_overflow_sub(lhs.high, rhs.high).expect('u512 sub overflow');

    match u256_overflow_sub(lhs.low, rhs.low) {
        Result::Ok(u256 { low: limb0, high: limb1 }) => { u512 { limb0, limb1, limb2, limb3 } },
        Result::Err(u256 {
            low: limb0, high: limb1,
        }) => {
            // Try to move overflow to limb2
            let (limb2, did_overflow) = limb2.overflowing_sub(1_u128);
            if did_overflow {
                // Try to move overflow to limb3
                let (limb3, did_overflow) = limb3.overflowing_sub(1_u128);
                if did_overflow {
                    panic!("u512 sub overflow");
                }
                u512 { limb0, limb1, limb2, limb3 }
            } else {
                u512 { limb0, limb1, limb2, limb3 }
            }
        },
    }
}
