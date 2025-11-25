//! # RIPEMD-160 Hash Function Implementation
//!
//! This module provides a complete implementation of the RIPEMD-160 cryptographic hash function
//! as specified in the RIPEMD-160 standard. RIPEMD-160 produces a 160-bit (20-byte) hash digest.
//!
//! Based on the original Cairo implementation by j1mbo64:
//! https://github.com/j1mbo64/ripemd160_cairo
//!
//! ## Algorithm Overview
//!
//! RIPEMD-160 processes input data in 512-bit (64-byte) blocks through:
//! - 5 rounds of 16 operations each on the left side
//! - 5 rounds of 16 operations each on the right side
//! - Final combination of left and right results

use core::num::traits::WrappingAdd;
use crate::opt_math::OptBitRotate;

const POW_2_32: u64 = 0x100000000;

/// Converts 4 bytes from ByteArray to u32 in little-endian format
/// This function safely handles cases where fewer than 4 bytes are available
///
/// #### Arguments
/// * `bytes` - The ByteArray containing the data
/// * `index` - Starting index for reading bytes
///
/// #### Returns
/// * `u32` - The converted 32-bit value in little-endian format
fn bytes_to_u32_swap(bytes: @ByteArray, index: usize) -> u32 {
    let len = bytes.len();
    let mut result: u32 = 0;

    // Read up to 4 bytes in little-endian order
    if index < len {
        result += bytes.at(index).unwrap().into();
        if index + 1 < len {
            result += bytes.at(index + 1).unwrap().into() * 0x100;
            if index + 2 < len {
                result += bytes.at(index + 2).unwrap().into() * 0x10000;
                if index + 3 < len {
                    result += bytes.at(index + 3).unwrap().into() * 0x1000000;
                }
            }
        }
    }
    result
}

fn u32_leftrotate(value: u32, shift: u32) -> u32 {
    OptBitRotate::rotl(value, shift.try_into().unwrap())
}

fn u32_mod_add(a: u32, b: u32) -> u32 {
    a.wrapping_add(b)
}

fn u32_mod_add_3(a: u32, b: u32, c: u32) -> u32 {
    a.wrapping_add(b).wrapping_add(c)
}

fn u32_mod_add_4(a: u32, b: u32, c: u32, d: u32) -> u32 {
    a.wrapping_add(b).wrapping_add(c).wrapping_add(d)
}

fn u32_byte_swap(value: u32) -> u32 {
    let byte0 = value & 0xff;
    let byte1 = (value / 0x100) & 0xff;
    let byte2 = (value / 0x10000) & 0xff;
    let byte3 = (value / 0x1000000) & 0xff;
    byte0 * 0x1000000 + byte1 * 0x10000 + byte2 * 0x100 + byte3
}

const BLOCK_SIZE: u32 = 64;
const BLOCK_SIZE_WO_LEN: u32 = 56;

#[derive(Drop, Clone, Copy)]
pub struct RIPEMD160Context {
    h0: u32,
    h1: u32,
    h2: u32,
    h3: u32,
    h4: u32,
}

pub impl RIPEMD160ContextIntoU256 of Into<RIPEMD160Context, u256> {
    fn into(self: RIPEMD160Context) -> u256 {
        ripemd160_context_as_u256(@self)
    }
}

pub impl RIPEMD160ContextIntoBytes of Into<RIPEMD160Context, ByteArray> {
    fn into(self: RIPEMD160Context) -> ByteArray {
        ripemd160_context_as_bytes(@self)
    }
}

pub impl RIPEMD160ContextIntoArray of Into<RIPEMD160Context, Array<u32>> {
    fn into(self: RIPEMD160Context) -> Array<u32> {
        ripemd160_context_as_array(@self)
    }
}

fn f(x: u32, y: u32, z: u32) -> u32 {
    x ^ y ^ z
}

fn g(x: u32, y: u32, z: u32) -> u32 {
    (x & y) | (~x & z)
}

fn h(x: u32, y: u32, z: u32) -> u32 {
    (x | ~y) ^ z
}

fn i(x: u32, y: u32, z: u32) -> u32 {
    (x & z) | (y & ~z)
}

fn j(x: u32, y: u32, z: u32) -> u32 {
    x ^ (y | ~z)
}

fn round_op(
    ref a: u32,
    b: u32,
    ref c: u32,
    d: u32,
    e: u32,
    x: u32,
    s: u32,
    func_result: u32,
    k: Option<u32>,
) {
    let temp = match k {
        Option::Some(k_val) => a.wrapping_add(func_result).wrapping_add(x).wrapping_add(k_val),
        Option::None => a.wrapping_add(func_result).wrapping_add(x),
    };
    a = OptBitRotate::rotl(temp, s.try_into().unwrap()).wrapping_add(e);
    c = OptBitRotate::rotl(c, 10);
}

fn l1(ref a: u32, b: u32, ref c: u32, d: u32, e: u32, x: u32, s: u32) {
    round_op(ref a, b, ref c, d, e, x, s, f(b, c, d), Option::None);
}

fn l2(ref a: u32, b: u32, ref c: u32, d: u32, e: u32, x: u32, s: u32) {
    round_op(ref a, b, ref c, d, e, x, s, g(b, c, d), Option::Some(0x5a827999));
}

fn l3(ref a: u32, b: u32, ref c: u32, d: u32, e: u32, x: u32, s: u32) {
    round_op(ref a, b, ref c, d, e, x, s, h(b, c, d), Option::Some(0x6ed9eba1));
}

fn l4(ref a: u32, b: u32, ref c: u32, d: u32, e: u32, x: u32, s: u32) {
    round_op(ref a, b, ref c, d, e, x, s, i(b, c, d), Option::Some(0x8f1bbcdc));
}

fn l5(ref a: u32, b: u32, ref c: u32, d: u32, e: u32, x: u32, s: u32) {
    round_op(ref a, b, ref c, d, e, x, s, j(b, c, d), Option::Some(0xa953fd4e));
}

fn r1(ref a: u32, b: u32, ref c: u32, d: u32, e: u32, x: u32, s: u32) {
    round_op(ref a, b, ref c, d, e, x, s, j(b, c, d), Option::Some(0x50a28be6));
}

fn r2(ref a: u32, b: u32, ref c: u32, d: u32, e: u32, x: u32, s: u32) {
    round_op(ref a, b, ref c, d, e, x, s, i(b, c, d), Option::Some(0x5c4dd124));
}

fn r3(ref a: u32, b: u32, ref c: u32, d: u32, e: u32, x: u32, s: u32) {
    round_op(ref a, b, ref c, d, e, x, s, h(b, c, d), Option::Some(0x6d703ef3));
}

fn r4(ref a: u32, b: u32, ref c: u32, d: u32, e: u32, x: u32, s: u32) {
    round_op(ref a, b, ref c, d, e, x, s, g(b, c, d), Option::Some(0x7a6d76e9));
}

fn r5(ref a: u32, b: u32, ref c: u32, d: u32, e: u32, x: u32, s: u32) {
    round_op(ref a, b, ref c, d, e, x, s, f(b, c, d), Option::None);
}

// RIPEMD-160 compression function
fn ripemd160_process_block(ref ctx: RIPEMD160Context, block: @Array<u32>) {
    let mut lh0 = ctx.h0;
    let mut lh1 = ctx.h1;
    let mut lh2 = ctx.h2;
    let mut lh3 = ctx.h3;
    let mut lh4 = ctx.h4;
    let mut rh0 = ctx.h0;
    let mut rh1 = ctx.h1;
    let mut rh2 = ctx.h2;
    let mut rh3 = ctx.h3;
    let mut rh4 = ctx.h4;

    // Left round 1
    l1(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(0), 11);
    l1(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(1), 14);
    l1(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(2), 15);
    l1(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(3), 12);
    l1(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(4), 5);
    l1(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(5), 8);
    l1(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(6), 7);
    l1(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(7), 9);
    l1(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(8), 11);
    l1(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(9), 13);
    l1(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(10), 14);
    l1(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(11), 15);
    l1(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(12), 6);
    l1(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(13), 7);
    l1(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(14), 9);
    l1(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(15), 8);

    // Left round 2
    l2(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(7), 7);
    l2(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(4), 6);
    l2(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(13), 8);
    l2(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(1), 13);
    l2(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(10), 11);
    l2(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(6), 9);
    l2(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(15), 7);
    l2(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(3), 15);
    l2(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(12), 7);
    l2(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(0), 12);
    l2(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(9), 15);
    l2(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(5), 9);
    l2(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(2), 11);
    l2(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(14), 7);
    l2(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(11), 13);
    l2(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(8), 12);

    // Left round 3
    l3(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(3), 11);
    l3(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(10), 13);
    l3(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(14), 6);
    l3(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(4), 7);
    l3(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(9), 14);
    l3(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(15), 9);
    l3(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(8), 13);
    l3(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(1), 15);
    l3(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(2), 14);
    l3(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(7), 8);
    l3(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(0), 13);
    l3(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(6), 6);
    l3(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(13), 5);
    l3(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(11), 12);
    l3(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(5), 7);
    l3(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(12), 5);

    // Left round 4
    l4(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(1), 11);
    l4(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(9), 12);
    l4(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(11), 14);
    l4(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(10), 15);
    l4(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(0), 14);
    l4(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(8), 15);
    l4(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(12), 9);
    l4(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(4), 8);
    l4(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(13), 9);
    l4(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(3), 14);
    l4(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(7), 5);
    l4(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(15), 6);
    l4(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(14), 8);
    l4(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(5), 6);
    l4(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(6), 5);
    l4(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(2), 12);

    // Left round 5
    l5(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(4), 9);
    l5(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(0), 15);
    l5(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(5), 5);
    l5(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(9), 11);
    l5(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(7), 6);
    l5(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(12), 8);
    l5(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(2), 13);
    l5(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(10), 12);
    l5(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(14), 5);
    l5(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(1), 12);
    l5(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(3), 13);
    l5(ref lh0, lh1, ref lh2, lh3, lh4, *block.at(8), 14);
    l5(ref lh4, lh0, ref lh1, lh2, lh3, *block.at(11), 11);
    l5(ref lh3, lh4, ref lh0, lh1, lh2, *block.at(6), 8);
    l5(ref lh2, lh3, ref lh4, lh0, lh1, *block.at(15), 5);
    l5(ref lh1, lh2, ref lh3, lh4, lh0, *block.at(13), 6);

    // Ensure calculation of `left` is kept as local and not as temporary when compiling Sierra to
    // CASM with `inlining-strategy = "avoid`.
    core::internal::revoke_ap_tracking();

    // Right round 1
    r1(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(5), 8);
    r1(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(14), 9);
    r1(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(7), 9);
    r1(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(0), 11);
    r1(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(9), 13);
    r1(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(2), 15);
    r1(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(11), 15);
    r1(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(4), 5);
    r1(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(13), 7);
    r1(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(6), 7);
    r1(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(15), 8);
    r1(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(8), 11);
    r1(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(1), 14);
    r1(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(10), 14);
    r1(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(3), 12);
    r1(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(12), 6);

    // Right round 2
    r2(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(6), 9);
    r2(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(11), 13);
    r2(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(3), 15);
    r2(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(7), 7);
    r2(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(0), 12);
    r2(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(13), 8);
    r2(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(5), 9);
    r2(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(10), 11);
    r2(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(14), 7);
    r2(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(15), 7);
    r2(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(8), 12);
    r2(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(12), 7);
    r2(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(4), 6);
    r2(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(9), 15);
    r2(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(1), 13);
    r2(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(2), 11);

    // Right round 3
    r3(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(15), 9);
    r3(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(5), 7);
    r3(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(1), 15);
    r3(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(3), 11);
    r3(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(7), 8);
    r3(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(14), 6);
    r3(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(6), 6);
    r3(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(9), 14);
    r3(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(11), 12);
    r3(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(8), 13);
    r3(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(12), 5);
    r3(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(2), 14);
    r3(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(10), 13);
    r3(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(0), 13);
    r3(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(4), 7);
    r3(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(13), 5);

    // Right round 4
    r4(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(8), 15);
    r4(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(6), 5);
    r4(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(4), 8);
    r4(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(1), 11);
    r4(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(3), 14);
    r4(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(11), 14);
    r4(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(15), 6);
    r4(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(0), 14);
    r4(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(5), 6);
    r4(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(12), 9);
    r4(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(2), 12);
    r4(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(13), 9);
    r4(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(9), 12);
    r4(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(7), 5);
    r4(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(10), 15);
    r4(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(14), 8);

    // Right round 5
    r5(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(12), 8);
    r5(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(15), 5);
    r5(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(10), 12);
    r5(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(4), 9);
    r5(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(1), 12);
    r5(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(5), 5);
    r5(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(8), 14);
    r5(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(7), 6);
    r5(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(6), 8);
    r5(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(2), 13);
    r5(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(13), 6);
    r5(ref rh0, rh1, ref rh2, rh3, rh4, *block.at(14), 5);
    r5(ref rh4, rh0, ref rh1, rh2, rh3, *block.at(0), 15);
    r5(ref rh3, rh4, ref rh0, rh1, rh2, *block.at(3), 13);
    r5(ref rh2, rh3, ref rh4, rh0, rh1, *block.at(9), 11);
    r5(ref rh1, rh2, ref rh3, rh4, rh0, *block.at(11), 11);

    // Combine results
    let temp = ctx.h1.wrapping_add(lh2).wrapping_add(rh3);
    ctx.h1 = ctx.h2.wrapping_add(lh3).wrapping_add(rh4);
    ctx.h2 = ctx.h3.wrapping_add(lh4).wrapping_add(rh0);
    ctx.h3 = ctx.h4.wrapping_add(lh0).wrapping_add(rh1);
    ctx.h4 = ctx.h0.wrapping_add(lh1).wrapping_add(rh2);
    ctx.h0 = temp;
}

// Add RIPEMD-160 padding to the input.
fn ripemd160_padding(ref data: ByteArray) {
    // Get message len in bits
    let mut data_bits_len: felt252 = data.len().into() * 8;

    // Append padding bit
    data.append_byte(0x80);

    // Add padding zeroes
    let mut len = data.len();
    while (len % BLOCK_SIZE != BLOCK_SIZE_WO_LEN) {
        data.append_byte(0);
        len += 1;
    }

    // Add message len in little-endian
    data.append_word_rev(data_bits_len, 8);
}

// Update the context by processing the whole data.
fn ripemd160_update(ref ctx: RIPEMD160Context, data: ByteArray) {
    let mut i: usize = 0;
    let len = data.len();

    while i != len {
        let mut block: Array<u32> = array![
            bytes_to_u32_swap(@data, i), bytes_to_u32_swap(@data, i + 4),
            bytes_to_u32_swap(@data, i + 8), bytes_to_u32_swap(@data, i + 12),
            bytes_to_u32_swap(@data, i + 16), bytes_to_u32_swap(@data, i + 20),
            bytes_to_u32_swap(@data, i + 24), bytes_to_u32_swap(@data, i + 28),
            bytes_to_u32_swap(@data, i + 32), bytes_to_u32_swap(@data, i + 36),
            bytes_to_u32_swap(@data, i + 40), bytes_to_u32_swap(@data, i + 44),
            bytes_to_u32_swap(@data, i + 48), bytes_to_u32_swap(@data, i + 52),
            bytes_to_u32_swap(@data, i + 56), bytes_to_u32_swap(@data, i + 60),
        ];

        ripemd160_process_block(ref ctx, @block);
        i += BLOCK_SIZE;
    }

    ctx.h0 = u32_byte_swap(ctx.h0);
    ctx.h1 = u32_byte_swap(ctx.h1);
    ctx.h2 = u32_byte_swap(ctx.h2);
    ctx.h3 = u32_byte_swap(ctx.h3);
    ctx.h4 = u32_byte_swap(ctx.h4);
}

// Init context with RIPEMD-160 constant.
fn ripemd160_init() -> RIPEMD160Context {
    RIPEMD160Context {
        h0: 0x67452301, h1: 0xefcdab89, h2: 0x98badcfe, h3: 0x10325476, h4: 0xc3d2e1f0,
    }
}

// Return hash as bytes.
pub fn ripemd160_context_as_bytes(ctx: @RIPEMD160Context) -> ByteArray {
    let mut result: ByteArray = Default::default();
    result.append_word((*ctx.h0).into(), 4);
    result.append_word((*ctx.h1).into(), 4);
    result.append_word((*ctx.h2).into(), 4);
    result.append_word((*ctx.h3).into(), 4);
    result.append_word((*ctx.h4).into(), 4);
    result
}

// Return hash as u32 array.
pub fn ripemd160_context_as_array(ctx: @RIPEMD160Context) -> Array<u32> {
    let mut result: Array<u32> = ArrayTrait::new();
    result.append(*ctx.h0);
    result.append(*ctx.h1);
    result.append(*ctx.h2);
    result.append(*ctx.h3);
    result.append(*ctx.h4);
    result
}

// Return hash as u256.
pub fn ripemd160_context_as_u256(ctx: @RIPEMD160Context) -> u256 {
    let h0: u256 = (*ctx.h0).into();
    let h1: u256 = (*ctx.h1).into();
    let h2: u256 = (*ctx.h2).into();
    let h3: u256 = (*ctx.h3).into();
    let h4: u256 = (*ctx.h4).into();

    (h0 * POW_2_32.into() * POW_2_32.into() * POW_2_32.into() * POW_2_32.into())
        + (h1 * POW_2_32.into() * POW_2_32.into() * POW_2_32.into())
        + (h2 * POW_2_32.into() * POW_2_32.into())
        + (h3 * POW_2_32.into())
        + h4
}

/// RIPEMD-160 hash function entrypoint
///
/// Computes the RIPEMD-160 hash of the input data. This implementation is based on
/// the original work by j1mbo64: https://github.com/j1mbo64/ripemd160_cairo
///
/// #### Arguments
/// * `data` - Input data to hash
///
/// #### Returns
/// * `RIPEMD160Context` - Context containing the computed hash
///
/// #### Example
/// ```rust
/// let data: ByteArray = "Hello, World!";
/// let hash_ctx = ripemd160_hash(@data);
/// let hash_u256 = ripemd160_context_as_u256(@hash_ctx);
/// ```
pub fn ripemd160_hash(data: @ByteArray) -> RIPEMD160Context {
    let mut data = data.clone();
    let mut ctx = ripemd160_init();
    ripemd160_padding(ref data);
    ripemd160_update(ref ctx, data);
    ctx
}
