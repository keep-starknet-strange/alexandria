use core::integer::u512;
use core::integer::{u128_overflowing_add, u128_overflowing_sub};
use core::result::ResultTrait;

pub fn u256_overflow_add(lhs: u256, rhs: u256) -> Result<u256, u256> implicits(RangeCheck) nopanic {
    let (sum, overflow) = core::integer::u256_overflowing_add(lhs, rhs);
    if overflow {
        Result::Err(sum)
    } else {
        Result::Ok(sum)
    }
}

pub fn u256_overflow_sub(lhs: u256, rhs: u256) -> Result<u256, u256> implicits(RangeCheck) nopanic {
    let (sum, overflow) = core::integer::u256_overflow_sub(lhs, rhs);
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

#[inline(always)]
pub fn u512_add(lhs: u512, rhs: u512) -> u512 {
    let lhs: u256X2 = lhs.into();
    let rhs: u256X2 = rhs.into();

    // No overflow allowed
    let u256 { low: limb2, high: limb3 } = u256_overflow_add(lhs.high, rhs.high)
        .expect('u512 add overflow');

    match u256_overflow_add(lhs.low, rhs.low) {
        Result::Ok(u256 { low: limb0, high: limb1 }) => { u512 { limb0, limb1, limb2, limb3 } },
        Result::Err(u256 { low: limb0,
        high: limb1 }) => {
            // Try to move overflow to limb2
            return match u128_overflowing_add(limb2, 1_u128) {
                Result::Ok(limb2) => u512 { limb0, limb1, limb2, limb3 },
                Result::Err(limb2) => {
                    // Try to move overflow to limb3
                    let limb3 = u128_overflowing_add(limb3, 1_u128).expect('u512 add overflow');
                    u512 { limb0, limb1, limb2, limb3 }
                },
            };
        },
    }
}

#[inline(always)]
pub fn u512_sub(lhs: u512, rhs: u512) -> u512 {
    let lhs: u256X2 = lhs.into();
    let rhs: u256X2 = rhs.into();

    // No overflow allowed
    let u256 { low: limb2, high: limb3 } = u256_overflow_sub(lhs.high, rhs.high)
        .expect('u512 sub overflow');

    match u256_overflow_sub(lhs.low, rhs.low) {
        Result::Ok(u256 { low: limb0, high: limb1 }) => { u512 { limb0, limb1, limb2, limb3 } },
        Result::Err(u256 { low: limb0,
        high: limb1 }) => {
            // Try to move overflow to limb2
            return match u128_overflowing_sub(limb2, 1_u128) {
                Result::Ok(limb2) => u512 { limb0, limb1, limb2, limb3 },
                Result::Err(limb2) => {
                    // Try to move overflow to limb3
                    let limb3 = u128_overflowing_sub(limb3, 1_u128).expect('u512 sub overflow');
                    u512 { limb0, limb1, limb2, limb3 }
                },
            };
        },
    }
}
