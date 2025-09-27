use alexandria_math::opt_math::{OptBitRotate, OptBitShift, OptWrapping};
use alexandria_math::pow;
use core::num::traits::Bounded;

#[test]
fn shl_should_not_overflow() {
    assert!(OptBitShift::shl(pow::<u8>(2, 7), 1) == 0);
    assert!(OptBitShift::shl(pow::<u16>(2, 15), 1) == 0);
    assert!(OptBitShift::shl(pow::<u32>(2, 31), 1) == 0);
    assert!(OptBitShift::shl(pow::<u64>(2, 63), 1) == 0);
    assert!(OptBitShift::shl(pow::<u128>(2, 127), 1) == 0);
    assert!(OptBitShift::shl(pow::<u256>(2, 255), 1) == 0);
}

#[test]
fn shr_should_not_underflow() {
    assert!(OptBitShift::shr(0_u8, 1) == 0);
    assert!(OptBitShift::shr(0_u16, 1) == 0);
    assert!(OptBitShift::shr(0_u32, 1) == 0);
    assert!(OptBitShift::shr(0_u64, 1) == 0);
    assert!(OptBitShift::shr(0_u128, 1) == 0);
    assert!(OptBitShift::shr(0_u256, 1) == 0);
}

#[test]
fn test_rotl_min() {
    assert!(OptBitRotate::rotl(pow::<u8>(2, 7) + 1, 1) == 3);
    assert!(OptBitRotate::rotl(pow::<u16>(2, 15) + 1, 1) == 3);
    assert!(OptBitRotate::rotl(pow::<u32>(2, 31) + 1, 1) == 3);
    assert!(OptBitRotate::rotl(pow::<u64>(2, 63) + 1, 1) == 3);
    assert!(OptBitRotate::rotl(pow::<u128>(2, 127) + 1, 1) == 3);
    assert!(OptBitRotate::rotl(pow::<u256>(2, 255) + 1, 1) == 3);
}

#[test]
fn test_rotl_max() {
    assert!(OptBitRotate::rotl(0b101, 7) == pow::<u8>(2, 7) + 0b10);
    assert!(OptBitRotate::rotl(0b101, 15) == pow::<u16>(2, 15) + 0b10);
    assert!(OptBitRotate::rotl(0b101, 31) == pow::<u32>(2, 31) + 0b10);
    assert!(OptBitRotate::rotl(0b101, 63) == pow::<u64>(2, 63) + 0b10);
    assert!(OptBitRotate::rotl(0b101, 127) == pow::<u128>(2, 127) + 0b10);
    assert!(OptBitRotate::rotl(0b101, 255) == pow::<u256>(2, 255) + 0b10);
}

#[test]
fn test_rotr_min() {
    assert!(OptBitRotate::rotr(pow::<u8>(2, 7) + 1, 1) == 0b11 * pow(2, 6));
    assert!(OptBitRotate::rotr(pow::<u16>(2, 15) + 1, 1) == 0b11 * pow(2, 14));
    assert!(OptBitRotate::rotr(pow::<u32>(2, 31) + 1, 1) == 0b11 * pow(2, 30));
    assert!(OptBitRotate::rotr(pow::<u64>(2, 63) + 1, 1) == 0b11 * pow(2, 62));
    assert!(OptBitRotate::rotr(pow::<u128>(2, 127) + 1, 1) == 0b11 * pow(2, 126));
    assert!(OptBitRotate::rotr(pow::<u256>(2, 255) + 1, 1) == 0b11 * pow(2, 254));
}

#[test]
fn test_rotr_max() {
    assert!(OptBitRotate::rotr(0b101_u8, 7) == 0b1010);
    assert!(OptBitRotate::rotr(0b101_u16, 15) == 0b1010);
    assert!(OptBitRotate::rotr(0b101_u32, 31) == 0b1010);
    assert!(OptBitRotate::rotr(0b101_u64, 63) == 0b1010);
    assert!(OptBitRotate::rotr(0b101_u128, 127) == 0b1010);
    assert!(OptBitRotate::rotr(0b101_u256, 255) == 0b1010);
}

#[test]
fn test_wrapping_math_non_wrapping() {
    assert!(10_u8.opt_wrapping_add(10_u8) == 20_u8);
    assert!(0_u8.opt_wrapping_add(10_u8) == 10_u8);
    assert!(10_u8.opt_wrapping_add(0_u8) == 10_u8);
    assert!(0_u8.opt_wrapping_add(0_u8) == 0_u8);
    assert!(20_u8.opt_wrapping_sub(10_u8) == 10_u8);
    assert!(10_u8.opt_wrapping_sub(0_u8) == 10_u8);
    assert!(0_u8.opt_wrapping_sub(0_u8) == 0_u8);
    assert!(10_u8.opt_wrapping_mul(10_u8) == 100_u8);
    assert!(10_u8.opt_wrapping_mul(0_u8) == 0_u8);
    assert!(0_u8.opt_wrapping_mul(10_u8) == 0_u8);
    assert!(0_u8.opt_wrapping_mul(0_u8) == 0_u8);

    assert!(10_u16.opt_wrapping_add(10_u16) == 20_u16);
    assert!(0_u16.opt_wrapping_add(10_u16) == 10_u16);
    assert!(10_u16.opt_wrapping_add(0_u16) == 10_u16);
    assert!(0_u16.opt_wrapping_add(0_u16) == 0_u16);
    assert!(20_u16.opt_wrapping_sub(10_u16) == 10_u16);
    assert!(10_u16.opt_wrapping_sub(0_u16) == 10_u16);
    assert!(0_u16.opt_wrapping_sub(0_u16) == 0_u16);
    assert!(10_u16.opt_wrapping_mul(10_u16) == 100_u16);
    assert!(10_u16.opt_wrapping_mul(0_u16) == 0_u16);
    assert!(0_u16.opt_wrapping_mul(10_u16) == 0_u16);
    assert!(0_u16.opt_wrapping_mul(0_u16) == 0_u16);

    assert!(10_u32.opt_wrapping_add(10_u32) == 20_u32);
    assert!(0_u32.opt_wrapping_add(10_u32) == 10_u32);
    assert!(10_u32.opt_wrapping_add(0_u32) == 10_u32);
    assert!(0_u32.opt_wrapping_add(0_u32) == 0_u32);
    assert!(20_u32.opt_wrapping_sub(10_u32) == 10_u32);
    assert!(10_u32.opt_wrapping_sub(0_u32) == 10_u32);
    assert!(0_u32.opt_wrapping_sub(0_u32) == 0_u32);
    assert!(10_u32.opt_wrapping_mul(10_u32) == 100_u32);
    assert!(10_u32.opt_wrapping_mul(0_u32) == 0_u32);
    assert!(0_u32.opt_wrapping_mul(10_u32) == 0_u32);
    assert!(0_u32.opt_wrapping_mul(0_u32) == 0_u32);

    assert!(10_u64.opt_wrapping_add(10_u64) == 20_u64);
    assert!(0_u64.opt_wrapping_add(10_u64) == 10_u64);
    assert!(10_u64.opt_wrapping_add(0_u64) == 10_u64);
    assert!(0_u64.opt_wrapping_add(0_u64) == 0_u64);
    assert!(20_u64.opt_wrapping_sub(10_u64) == 10_u64);
    assert!(10_u64.opt_wrapping_sub(0_u64) == 10_u64);
    assert!(0_u64.opt_wrapping_sub(0_u64) == 0_u64);
    assert!(10_u64.opt_wrapping_mul(10_u64) == 100_u64);
    assert!(10_u64.opt_wrapping_mul(0_u64) == 0_u64);
    assert!(0_u64.opt_wrapping_mul(10_u64) == 0_u64);
    assert!(0_u64.opt_wrapping_mul(0_u64) == 0_u64);

    assert!(10_u128.opt_wrapping_add(10_u128) == 20_u128);
    assert!(0_u128.opt_wrapping_add(10_u128) == 10_u128);
    assert!(10_u128.opt_wrapping_add(0_u128) == 10_u128);
    assert!(0_u128.opt_wrapping_add(0_u128) == 0_u128);
    assert!(20_u128.opt_wrapping_sub(10_u128) == 10_u128);
    assert!(10_u128.opt_wrapping_sub(0_u128) == 10_u128);
    assert!(0_u128.opt_wrapping_sub(0_u128) == 0_u128);
    assert!(10_u128.opt_wrapping_mul(10_u128) == 100_u128);
    assert!(10_u128.opt_wrapping_mul(0_u128) == 0_u128);
    assert!(0_u128.opt_wrapping_mul(10_u128) == 0_u128);
    assert!(0_u128.opt_wrapping_mul(0_u128) == 0_u128);

    assert!(10_u256.opt_wrapping_add(10_u256) == 20_u256);
    assert!(0_u256.opt_wrapping_add(10_u256) == 10_u256);
    assert!(10_u256.opt_wrapping_add(0_u256) == 10_u256);
    assert!(0_u256.opt_wrapping_add(0_u256) == 0_u256);
    assert!(20_u256.opt_wrapping_sub(10_u256) == 10_u256);
    assert!(10_u256.opt_wrapping_sub(0_u256) == 10_u256);
    assert!(0_u256.opt_wrapping_sub(0_u256) == 0_u256);
    assert!(10_u256.opt_wrapping_mul(10_u256) == 100_u256);
    assert!(10_u256.opt_wrapping_mul(0_u256) == 0_u256);
    assert!(0_u256.opt_wrapping_mul(10_u256) == 0_u256);
    assert!(0_u256.opt_wrapping_mul(0_u256) == 0_u256);
}

#[test]
fn test_wrapping_math_wrapping() {
    assert!(Bounded::<u8>::MAX.opt_wrapping_add(1_u8) == 0_u8);
    assert!(1_u8.opt_wrapping_add(Bounded::<u8>::MAX) == 0_u8);
    assert!(Bounded::<u8>::MAX.opt_wrapping_add(2_u8) == 1_u8);
    assert!(2_u8.opt_wrapping_add(Bounded::<u8>::MAX) == 1_u8);
    assert!(Bounded::<u8>::MAX.opt_wrapping_add(Bounded::<u8>::MAX) == Bounded::<u8>::MAX - 1_u8);
    assert!(Bounded::<u8>::MIN.opt_wrapping_sub(1_u8) == Bounded::<u8>::MAX);
    assert!(Bounded::<u8>::MIN.opt_wrapping_sub(2_u8) == Bounded::<u8>::MAX - 1_u8);
    assert!(1_u8.opt_wrapping_sub(Bounded::<u8>::MAX) == 2_u8);
    assert!(0_u8.opt_wrapping_sub(Bounded::<u8>::MAX) == 1_u8);
    assert!(Bounded::<u8>::MAX.opt_wrapping_mul(Bounded::<u8>::MAX) == 1_u8);
    assert!((Bounded::<u8>::MAX - 1_u8).opt_wrapping_mul(2_u8) == Bounded::<u8>::MAX - 3_u8);

    assert!(Bounded::<u16>::MAX.opt_wrapping_add(1_u16) == 0_u16);
    assert!(1_u16.opt_wrapping_add(Bounded::<u16>::MAX) == 0_u16);
    assert!(Bounded::<u16>::MAX.opt_wrapping_add(2_u16) == 1_u16);
    assert!(2_u16.opt_wrapping_add(Bounded::<u16>::MAX) == 1_u16);
    assert!(
        Bounded::<u16>::MAX.opt_wrapping_add(Bounded::<u16>::MAX) == Bounded::<u16>::MAX - 1_u16,
    );
    assert!(Bounded::<u16>::MIN.opt_wrapping_sub(1_u16) == Bounded::<u16>::MAX);
    assert!(Bounded::<u16>::MIN.opt_wrapping_sub(2_u16) == Bounded::<u16>::MAX - 1_u16);
    assert!(1_u16.opt_wrapping_sub(Bounded::<u16>::MAX) == 2_u16);
    assert!(0_u16.opt_wrapping_sub(Bounded::<u16>::MAX) == 1_u16);
    assert!(Bounded::<u16>::MAX.opt_wrapping_mul(Bounded::<u16>::MAX) == 1_u16);
    assert!((Bounded::<u16>::MAX - 1_u16).opt_wrapping_mul(2_u16) == Bounded::<u16>::MAX - 3_u16);

    assert!(Bounded::<u32>::MAX.opt_wrapping_add(1_u32) == 0_u32);
    assert!(1_u32.opt_wrapping_add(Bounded::<u32>::MAX) == 0_u32);
    assert!(Bounded::<u32>::MAX.opt_wrapping_add(2_u32) == 1_u32);
    assert!(2_u32.opt_wrapping_add(Bounded::<u32>::MAX) == 1_u32);
    assert!(
        Bounded::<u32>::MAX.opt_wrapping_add(Bounded::<u32>::MAX) == Bounded::<u32>::MAX - 1_u32,
    );
    assert!(Bounded::<u32>::MIN.opt_wrapping_sub(1_u32) == Bounded::<u32>::MAX);
    assert!(Bounded::<u32>::MIN.opt_wrapping_sub(2_u32) == Bounded::<u32>::MAX - 1_u32);
    assert!(1_u32.opt_wrapping_sub(Bounded::<u32>::MAX) == 2_u32);
    assert!(0_u32.opt_wrapping_sub(Bounded::<u32>::MAX) == 1_u32);
    assert!(Bounded::<u32>::MAX.opt_wrapping_mul(Bounded::<u32>::MAX) == 1_u32);
    assert!((Bounded::<u32>::MAX - 1_u32).opt_wrapping_mul(2_u32) == Bounded::<u32>::MAX - 3_u32);

    assert!(Bounded::<u64>::MAX.opt_wrapping_add(1_u64) == 0_u64);
    assert!(1_u64.opt_wrapping_add(Bounded::<u64>::MAX) == 0_u64);
    assert!(Bounded::<u64>::MAX.opt_wrapping_add(2_u64) == 1_u64);
    assert!(2_u64.opt_wrapping_add(Bounded::<u64>::MAX) == 1_u64);
    assert!(
        Bounded::<u64>::MAX.opt_wrapping_add(Bounded::<u64>::MAX) == Bounded::<u64>::MAX - 1_u64,
    );
    assert!(Bounded::<u64>::MIN.opt_wrapping_sub(1_u64) == Bounded::<u64>::MAX);
    assert!(Bounded::<u64>::MIN.opt_wrapping_sub(2_u64) == Bounded::<u64>::MAX - 1_u64);
    assert!(1_u64.opt_wrapping_sub(Bounded::<u64>::MAX) == 2_u64);
    assert!(0_u64.opt_wrapping_sub(Bounded::<u64>::MAX) == 1_u64);
    assert!(Bounded::<u64>::MAX.opt_wrapping_mul(Bounded::<u64>::MAX) == 1_u64);
    assert!((Bounded::<u64>::MAX - 1_u64).opt_wrapping_mul(2_u64) == Bounded::<u64>::MAX - 3_u64);

    assert!(Bounded::<u128>::MAX.opt_wrapping_add(1_u128) == 0_u128);
    assert!(1_u128.opt_wrapping_add(Bounded::<u128>::MAX) == 0_u128);
    assert!(Bounded::<u128>::MAX.opt_wrapping_add(2_u128) == 1_u128);
    assert!(2_u128.opt_wrapping_add(Bounded::<u128>::MAX) == 1_u128);
    assert!(
        Bounded::<u128>::MAX.opt_wrapping_add(Bounded::<u128>::MAX) == Bounded::<u128>::MAX
            - 1_u128,
    );
    assert!(Bounded::<u128>::MIN.opt_wrapping_sub(1_u128) == Bounded::<u128>::MAX);
    assert!(Bounded::<u128>::MIN.opt_wrapping_sub(2_u128) == Bounded::<u128>::MAX - 1_u128);
    assert!(1_u128.opt_wrapping_sub(Bounded::<u128>::MAX) == 2_u128);
    assert!(0_u128.opt_wrapping_sub(Bounded::<u128>::MAX) == 1_u128);
    assert!(Bounded::<u128>::MAX.opt_wrapping_mul(Bounded::<u128>::MAX) == 1_u128);
    assert!(
        (Bounded::<u128>::MAX - 1_u128).opt_wrapping_mul(2_u128) == Bounded::<u128>::MAX - 3_u128,
    );

    assert!(Bounded::<u256>::MAX.opt_wrapping_add(1_u256) == 0_u256);
    assert!(1_u256.opt_wrapping_add(Bounded::<u256>::MAX) == 0_u256);
    assert!(Bounded::<u256>::MAX.opt_wrapping_add(2_u256) == 1_u256);
    assert!(2_u256.opt_wrapping_add(Bounded::<u256>::MAX) == 1_u256);
    assert!(
        Bounded::<u256>::MAX.opt_wrapping_add(Bounded::<u256>::MAX) == Bounded::<u256>::MAX
            - 1_u256,
    );
    assert!(Bounded::<u256>::MIN.opt_wrapping_sub(1_u256) == Bounded::<u256>::MAX);
    assert!(Bounded::<u256>::MIN.opt_wrapping_sub(2_u256) == Bounded::<u256>::MAX - 1_u256);
    assert!(1_u256.opt_wrapping_sub(Bounded::<u256>::MAX) == 2_u256);
    assert!(0_u256.opt_wrapping_sub(Bounded::<u256>::MAX) == 1_u256);
    assert!(Bounded::<u256>::MAX.opt_wrapping_mul(Bounded::<u256>::MAX) == 1_u256);
    assert!(
        (Bounded::<u256>::MAX - 1_u256).opt_wrapping_mul(2_u256) == Bounded::<u256>::MAX - 3_u256,
    );
}
