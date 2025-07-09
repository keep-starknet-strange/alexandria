// TODO: Potentially merge with encoder.cairo (allowing to read from encoder for arbitrary encoding)

use core::num::traits::OverflowingMul;

// TODO: see reversing logic / optimize if needed (SIMD)
const M1: u256 = 0x5555555555555555555555555555555555555555555555555555555555555555;
const M2: u256 = 0x3333333333333333333333333333333333333333333333333333333333333333;
const M4: u256 = 0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F;
const M8: u256 = 0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF;
const M16: u256 = 0x0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF;
const M32: u256 = 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF;
const M64: u256 = 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF;
const M128: u256 = 0x00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

/// Efficiently perfoms an overflowing mul
///
/// # Arguments
/// * `a` - The first u256 value
/// * `b` - The second u256 value
///
/// # Returns
/// * `u256` - The swapped bytes u256 result
#[inline(always)]
fn of_mul(a: u256, b: u256) -> u256 {
    let (result, _) = a.overflowing_mul(b);

    result
}

/// Efficient SIMD reverse bytes (usecase: swapping endianess)
///
/// # Arguments
/// * `value` - The u256 value to swap bytes from
///
/// # Returns
/// * `u256` - The swapped bytes u256 result
#[inline(always)]
pub fn reverse_bytes(value: u256) -> u256 {
    let value = (of_mul(value, 0x100) & M8) | (value / 0x100 & M8);
    let value = (of_mul(value, 0x10000) & M16) |
        (value / 0x1000 & M16);
    let value = (of_mul(value, 0x100000000) & M32) |
        (value / 0x100000000 & M32);
    let value = (of_mul(value, 0x10000000000000000) & M64) |
        (value / 0x10000000000000000 & M64);

    (of_mul(value, 0x100000000000000000000000000000000) & M128) |
        (value / 0x100000000000000000000000000000000 & M128)
}

/// Appends a u256 in Big Endian representation to ByteArray
///
/// # Arguments
/// * `data` - The byte array to append to
/// * `value` - The u256 value to append
#[inline(always)]
pub fn append_u256_be(ref data: ByteArray, value: u256) {
    data.append_byte(
        (value /
            0x100000000000000000000000000000000000000000000000000000000000000)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000
            % 0x100)
            .try_into()
            .unwrap()
    );
    data.append_byte((value / 0x100000000000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x1000000000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x10000000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x100000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x1000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x10000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x100 % 0x100).try_into().unwrap());
    data.append_byte((value % 0x100).try_into().unwrap());
}

/// Appends a u256 in Little Endian representation to ByteArray
///
/// # Arguments
/// * `data` - The byte array to append to
/// * `value` - The u256 value to append
#[inline(always)]
pub fn append_u256_le(ref data: ByteArray, value: u256) {
    data.append_byte((value % 0x100).try_into().unwrap());
    data.append_byte((value / 0x100 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x10000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x1000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x100000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x10000000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x1000000000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x100000000000000 % 0x100).try_into().unwrap());
    data.append_byte(
        (value / 0x10000000000000000 % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value / 0x1000000000000000000 % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value / 0x100000000000000000000 % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value / 0x10000000000000000000000 % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value / 0x1000000000000000000000000 % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value / 0x100000000000000000000000000 % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value / 0x10000000000000000000000000000 % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value / 0x1000000000000000000000000000000 % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000000000 %
            0x100
        ).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000000000 %
            0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000000000 %
            0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x100000000000000000000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x10000000000000000000000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value /
            0x1000000000000000000000000000000000000000000000000000000000000
            % 0x100).try_into().unwrap()
    );
    data.append_byte(
        (value / 0x100000000000000000000000000000000000000000000000000000000000000)
            .try_into().unwrap()
    );
}

/// Appends a u64 in Little Endian representation to ByteArray
///
/// # Arguments
/// * `data` - The byte array to append to
/// * `value` - The u64 value to append
#[inline(always)]
pub fn append_u64_le(ref data: ByteArray, value: u64) {
    data.append_byte((value % 0x100).try_into().unwrap());
    data.append_byte((value / 0x100 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x10000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x1000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x100000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x10000000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x1000000000000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x100000000000000).try_into().unwrap());
}

/// Appends a u32 in Little Endian representation to ByteArray
///
/// # Arguments
/// * `data` - The byte array to append to
/// * `value` - The u32 value to append
#[inline(always)]
pub fn append_u32_le(ref data: ByteArray, value: u32) {
    data.append_byte((value % 0x100).try_into().unwrap());
    data.append_byte((value / 0x100 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x10000 % 0x100).try_into().unwrap());
    data.append_byte((value / 0x1000000).try_into().unwrap());
}

/// Appends an encoded varint to ByteArray (len prefixed)
///
/// # Arguments
/// * `data` - The byte array to append to
/// * `value` - The u32 value to append
#[inline(always)]
pub fn append_varint(ref data: ByteArray, value: u32) {
    if value < 0xfd {
        data.append_byte(value.try_into().unwrap());
    } else if value <= 0xffff {
        data.append_byte(0xfd);

        let val_u16: u16 = value.try_into().unwrap();

        data.append_byte((val_u16 % 0x100).try_into().unwrap());
        data.append_byte(
            (val_u16 / 0x100 % 0x100).try_into().unwrap()
        );
    } else {
        data.append_byte(0xfe);
        append_u32_le(ref data, value);
    }
}

/// Appends an encoded varslice (ByteArray) to ByteArray (len prefixed)
///
/// # Arguments
/// * `data` - The byte array to append to
/// * `value` - The ByteArray slice to append
#[inline(always)]
pub fn append_varslice(ref data: ByteArray, slice: @ByteArray) {
    let len = slice.len();

    data.append_byte(len.try_into().unwrap());

    data = ByteArrayTrait::concat(@data, slice);
}
