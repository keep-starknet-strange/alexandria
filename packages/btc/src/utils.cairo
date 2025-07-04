use core::num::traits::OverflowingMul;
use starknet::{
    SyscallResultTrait,
    secp256_trait::{
        Secp256PointTrait,
        Secp256Trait,
    },
};
use crate::constants::PRIME_FIELD;

pub fn ec_point_negate<
    Secp256Point,
    +Drop<Secp256Point>,
    +Secp256Trait<Secp256Point>,
    +Secp256PointTrait<Secp256Point>
>(p: Secp256Point) -> Secp256Point {
    let (x, y) = p.get_coordinates().unwrap_syscall();
    let y_neg = PRIME_FIELD - y;

    Secp256Trait::<Secp256Point>::secp256_ec_new_syscall(x, y_neg)
        .unwrap_syscall()
        .unwrap()
}

const BYTE_SHIFT_TABLE: [u256; 32] = [
    0x1,
    0x100,
    0x10000,
    0x1000000,
    0x100000000,
    0x10000000000,
    0x1000000000000,
    0x100000000000000,
    0x10000000000000000,
    0x1000000000000000000,
    0x100000000000000000000,
    0x10000000000000000000000,
    0x1000000000000000000000000,
    0x100000000000000000000000000,
    0x10000000000000000000000000000,
    0x1000000000000000000000000000000,
    0x100000000000000000000000000000000,
    0x10000000000000000000000000000000000,
    0x1000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000000000000,
];

#[inline(always)]
pub fn byte_at(value: u256, index: u32) -> u8 {
    (value / (*BYTE_SHIFT_TABLE.span()[index]) & 0xff).try_into().unwrap()
}

#[inline(always)]
pub fn shl_byte(bytes: u32, value: u256) -> u256 {
    let (res, _) = value.overflowing_mul(*BYTE_SHIFT_TABLE.span()[bytes]);

    res
}

#[inline(always)]
pub fn byte_array_append_sha256(input: Span<u32>, ref output: ByteArray) {
    for i in 0..8_u32 {
        let val = *input[i];

        output.append_byte(byte_at(val.into(), 3));
        output.append_byte(byte_at(val.into(), 2));
        output.append_byte(byte_at(val.into(), 1));
        output.append_byte(byte_at(val.into(), 0));
    };
}

#[inline(always)]
pub fn byte_array_append_u256_be(input: u256, ref output: ByteArray) {
    let mut i = 0x1f_u32;

    loop {
        output.append_byte(byte_at(input, i));

        if i == 0 {
            break;
        }

        i -= 1;
    };
}
