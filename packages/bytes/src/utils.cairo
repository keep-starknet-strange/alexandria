use alexandria_bytes::{Bytes, BytesTrait};
use alexandria_math::const_pow::pow2;
use core::fmt::{Debug, Display, Error, Formatter};
use core::integer::u128_byte_reverse;
use core::keccak::cairo_keccak;
use core::to_byte_array::FormatAsByteArray;

fn format_byte_hex(byte: u8, ref f: Formatter) -> Result<(), Error> {
    let base: NonZero<u8> = 16_u8.try_into().unwrap();
    if byte < 0x10 {
        // Add leading zero for single digit numbers
        let zero: ByteArray = "0";
        Display::fmt(@zero, ref f)?;
    }
    Display::fmt(@byte.format_as_byte_array(base), ref f)
}

pub impl BytesDebug of Debug<Bytes> {
    fn fmt(self: @Bytes, ref f: Formatter) -> Result<(), Error> {
        let mut i: usize = 0;
        let prefix: ByteArray = "0x";
        Display::fmt(@prefix, ref f)?;
        let mut res: Result<(), Error> = Result::Ok(());
        while i < self.size() {
            let (new_i, value) = self.read_u8(i);
            res = format_byte_hex(value, ref f);
            if res.is_err() {
                break;
            }
            i = new_i;
        }
        res
    }
}

pub impl BytesDisplay of Display<Bytes> {
    fn fmt(self: @Bytes, ref f: Formatter) -> Result<(), Error> {
        let mut i: usize = 0;
        let prefix: ByteArray = "0x";
        Display::fmt(@prefix, ref f)?;
        let mut res: Result<(), Error> = Result::Ok(());
        while i < self.size() {
            let (new_i, value) = self.read_u8(i);
            res = format_byte_hex(value, ref f);
            if res.is_err() {
                break;
            }
            i = new_i;
        }
        res
    }
}

/// Computes the keccak256 of multiple uint128 values.
/// The values are interpreted as big-endian.
/// https://github.com/starkware-libs/cairo/blob/main/corelib/src/keccak.cairo
pub fn keccak_u128s_be(input: Span<u128>, n_bytes: usize) -> u256 {
    let mut keccak_input = array![];
    let mut size = n_bytes;
    for v in input {
        let value_size = core::cmp::min(size, 16);
        keccak_add_uint128_be(ref keccak_input, *v, value_size);
        size -= value_size;
    }

    let aligned = n_bytes % 8 == 0;
    if aligned {
        u256_reverse_endian(cairo_keccak(ref keccak_input, 0, 0))
    } else {
        let last_input_num_bytes = n_bytes % 8;
        let last_input_word = *keccak_input[keccak_input.len() - 1];
        let mut inputs = u64_array_slice(@keccak_input, 0, keccak_input.len() - 1);
        u256_reverse_endian(cairo_keccak(ref inputs, last_input_word, last_input_num_bytes))
    }
}

fn u256_reverse_endian(input: u256) -> u256 {
    let low = u128_byte_reverse(input.high);
    let high = u128_byte_reverse(input.low);
    u256 { low, high }
}

fn keccak_add_uint128_be(ref keccak_input: Array<u64>, value: u128, value_size: usize) {
    if value_size == 16 {
        let (high, low) = core::integer::u128_safe_divmod(
            u128_byte_reverse(value), 0x10000000000000000_u128.try_into().unwrap(),
        );
        keccak_input.append(low.try_into().unwrap());
        keccak_input.append(high.try_into().unwrap());
    } else {
        let reversed_value = u128_byte_reverse(value);
        let (reversed_value, _) = u128_split(reversed_value, 16, value_size);
        if value_size <= 8 {
            keccak_input.append(reversed_value.try_into().unwrap());
        } else {
            let (high, low) = DivRem::div_rem(
                reversed_value, pow2(64).try_into().expect('Division by 0'),
            );
            keccak_input.append(low.try_into().unwrap());
            keccak_input.append(high.try_into().unwrap());
        }
    }
}

fn update_u256_array_at(arr: @Array<u256>, index: usize, value: u256) -> Array<u256> {
    assert(index < arr.len(), 'index out of range');
    let mut new_arr = array![];
    let mut i = 0;

    while i != arr.len() {
        if i == index {
            new_arr.append(value);
        } else {
            new_arr.append(*arr[i]);
        }
        i += 1;
    }
    new_arr
}

/// Convert sha256 result(Array<u8>) to u256
/// result length MUST be 32
pub fn u8_array_to_u256(arr: Span<u8>) -> u256 {
    assert(arr.len() == 32, 'too large');
    let mut i = 0;
    let mut high = 0;
    let mut low = 0;
    // process high
    while i < arr.len() && i != 16 {
        high = u128_join(high, (*arr[i]).into(), 1);
        i += 1;
    }
    // process low
    while i < arr.len() && i != 32 {
        low = u128_join(low, (*arr[i]).into(), 1);
        i += 1;
    }

    u256 { low, high }
}

pub fn u32s_to_u256(arr: Span<u32>) -> u256 {
    assert!(arr.len() == 8, "u32s_to_u2562: input must be 8 elements long");
    let low: u128 = (*arr[7]).into()
        + (*arr[6]).into() * 0x1_0000_0000
        + (*arr[5]).into() * 0x1_0000_0000_0000_0000
        + (*arr[4]).into() * 0x1_0000_0000_0000_0000_0000_0000;
    let low = low.try_into().expect('u32s_to_u2562:overflow-low');
    let high = (*arr[3]).into()
        + (*arr[2]).into() * 0x1_0000_0000
        + (*arr[1]).into() * 0x1_0000_0000_0000_0000
        + (*arr[0]).into() * 0x1_0000_0000_0000_0000_0000_0000;
    let high = high.try_into().expect('u32s_to_u2562:overflow-high');
    u256 { high, low }
}

fn u64_array_slice(src: @Array<u64>, mut begin: usize, len: usize) -> Array<u64> {
    let mut slice = array![];
    let end = begin + len;
    while begin < end && begin < src.len() {
        slice.append(*src[begin]);
        begin += 1;
    }
    slice
}

/// Returns the slice of an array.
/// * `arr` - The array to slice.
/// * `begin` - The index to start the slice at.
/// * `len` - The length of the slice.
/// # Returns
/// * `Array<u128>` - The slice of the array.
pub fn u128_array_slice(src: @Array<u128>, mut begin: usize, len: usize) -> Array<u128> {
    let mut slice = array![];
    let end = begin + len;
    while begin < end && begin < src.len() {
        slice.append(*src[begin]);
        begin += 1;
    }
    slice
}

fn array_slice<T, +Drop<T>, +Copy<T>>(src: @Array<T>, mut begin: usize, len: usize) -> Array<T> {
    let mut slice = array![];
    let end = begin + len;
    while begin < end && begin < src.len() {
        slice.append(*src[begin]);
        begin += 1;
    }
    slice
}

/// Split a u128 into two parts, [0, left_size-1] and [left_size, end]
/// Parameters:
///  - value: data of u128
///  - value_size: the size of `value` in bytes
///  - left_size: the size of left part in bytes
/// Returns:
///  - letf: [0, left_size-1] of the origin u128
///  - right: [left_size, end] of the origin u128 which size is (value_size - left_size)
/// Examples:
/// u128_split(0x01020304, 4, 0) -> (0, 0x01020304)
/// u128_split(0x01020304, 4, 1) -> (0x01, 0x020304)
/// u128_split(0x0001020304, 5, 1) -> (0x00, 0x01020304)
pub fn u128_split(value: u128, value_size: usize, left_size: usize) -> (u128, u128) {
    assert(value_size <= 16, 'value_size can not be gt 16');
    assert(left_size <= value_size, 'size can not be gt value_size');

    if left_size == 0 {
        (0, value)
    } else {
        let power = pow2((value_size - left_size) * 8);
        DivRem::div_rem(value, power.try_into().expect('Division by 0'))
    }
}

/// Read sub value from u128 just like substr in other language
/// Parameters:
///  - value: data of u128
///  - value_size: the size of data in bytes
///  - offset: the offset of sub value
///  - size: the size of sub value in bytes
/// Returns:
///  - sub_value: the sub value of origin u128
/// Examples:
/// u128_sub_value(0x000001020304, 6, 1, 3) -> 0x000102
pub fn read_sub_u128(value: u128, value_size: usize, offset: usize, size: usize) -> u128 {
    assert(offset + size <= value_size, 'too long');

    if (value_size == 0) || (size == 0) {
        return 0;
    }

    if size == value_size {
        return value;
    }

    let (_, right) = u128_split(value, value_size, offset);
    let (sub_value, _) = u128_split(right, value_size - offset, size);
    sub_value
}

/// Join two u128 into one
/// Parameters:
///  - left: the left part of u128
///  - right: the right part of u128
///  - right_size: the size of right part in bytes
/// Returns:
///  - value: the joined u128
/// Examples:
/// u128_join(0x010203, 0xaabb, 2) -> 0x010203aabb
/// u128_join(0x010203, 0, 2) -> 0x0102030000
pub fn u128_join(left: u128, right: u128, right_size: usize) -> u128 {
    let left_size = u128_bytes_len(left);
    assert(left_size + right_size <= 16, 'left shift overflow');
    let shift = pow2(right_size * 8);
    left * shift + right
}

/// Return the bytes len represent in u128
/// Examples:
/// u128_bytes_len(0x0102) -> 2
fn u128_bytes_len(value: u128) -> usize {
    if value <= 0xff_u128 {
        1_usize
    } else if value <= 0xffff_u128 {
        2_usize
    } else if value <= 0xffffff_u128 {
        3_usize
    } else if value <= 0xffffffff_u128 {
        4_usize
    } else if value <= 0xffffffffff_u128 {
        5_usize
    } else if value <= 0xffffffffffff_u128 {
        6_usize
    } else if value <= 0xffffffffffffff_u128 {
        7_usize
    } else if value <= 0xffffffffffffffff_u128 {
        8_usize
    } else if value <= 0xffffffffffffffffff_u128 {
        9_usize
    } else if value <= 0xffffffffffffffffffff_u128 {
        10_usize
    } else if value <= 0xffffffffffffffffffffff_u128 {
        11_usize
    } else if value <= 0xffffffffffffffffffffffff_u128 {
        12_usize
    } else if value <= 0xffffffffffffffffffffffffff_u128 {
        13_usize
    } else if value <= 0xffffffffffffffffffffffffffff_u128 {
        14_usize
    } else if value <= 0xffffffffffffffffffffffffffffff_u128 {
        15_usize
    } else {
        16_usize
    }
}
