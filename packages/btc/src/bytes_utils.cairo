use core::num::traits::OverflowingMul;
use core::array::ArrayTrait;
use starknet::ContractAddress;

const BIT_SHIFT_TABLE: [u256; 256] = [
    0x1,
    0x2,
    0x4,
    0x8,
    0x10,
    0x20,
    0x40,
    0x80,
    0x100,
    0x200,
    0x400,
    0x800,
    0x1000,
    0x2000,
    0x4000,
    0x8000,
    0x10000,
    0x20000,
    0x40000,
    0x80000,
    0x100000,
    0x200000,
    0x400000,
    0x800000,
    0x1000000,
    0x2000000,
    0x4000000,
    0x8000000,
    0x10000000,
    0x20000000,
    0x40000000,
    0x80000000,
    0x100000000,
    0x200000000,
    0x400000000,
    0x800000000,
    0x1000000000,
    0x2000000000,
    0x4000000000,
    0x8000000000,
    0x10000000000,
    0x20000000000,
    0x40000000000,
    0x80000000000,
    0x100000000000,
    0x200000000000,
    0x400000000000,
    0x800000000000,
    0x1000000000000,
    0x2000000000000,
    0x4000000000000,
    0x8000000000000,
    0x10000000000000,
    0x20000000000000,
    0x40000000000000,
    0x80000000000000,
    0x100000000000000,
    0x200000000000000,
    0x400000000000000,
    0x800000000000000,
    0x1000000000000000,
    0x2000000000000000,
    0x4000000000000000,
    0x8000000000000000,
    0x10000000000000000,
    0x20000000000000000,
    0x40000000000000000,
    0x80000000000000000,
    0x100000000000000000,
    0x200000000000000000,
    0x400000000000000000,
    0x800000000000000000,
    0x1000000000000000000,
    0x2000000000000000000,
    0x4000000000000000000,
    0x8000000000000000000,
    0x10000000000000000000,
    0x20000000000000000000,
    0x40000000000000000000,
    0x80000000000000000000,
    0x100000000000000000000,
    0x200000000000000000000,
    0x400000000000000000000,
    0x800000000000000000000,
    0x1000000000000000000000,
    0x2000000000000000000000,
    0x4000000000000000000000,
    0x8000000000000000000000,
    0x10000000000000000000000,
    0x20000000000000000000000,
    0x40000000000000000000000,
    0x80000000000000000000000,
    0x100000000000000000000000,
    0x200000000000000000000000,
    0x400000000000000000000000,
    0x800000000000000000000000,
    0x1000000000000000000000000,
    0x2000000000000000000000000,
    0x4000000000000000000000000,
    0x8000000000000000000000000,
    0x10000000000000000000000000,
    0x20000000000000000000000000,
    0x40000000000000000000000000,
    0x80000000000000000000000000,
    0x100000000000000000000000000,
    0x200000000000000000000000000,
    0x400000000000000000000000000,
    0x800000000000000000000000000,
    0x1000000000000000000000000000,
    0x2000000000000000000000000000,
    0x4000000000000000000000000000,
    0x8000000000000000000000000000,
    0x10000000000000000000000000000,
    0x20000000000000000000000000000,
    0x40000000000000000000000000000,
    0x80000000000000000000000000000,
    0x100000000000000000000000000000,
    0x200000000000000000000000000000,
    0x400000000000000000000000000000,
    0x800000000000000000000000000000,
    0x1000000000000000000000000000000,
    0x2000000000000000000000000000000,
    0x4000000000000000000000000000000,
    0x8000000000000000000000000000000,
    0x10000000000000000000000000000000,
    0x20000000000000000000000000000000,
    0x40000000000000000000000000000000,
    0x80000000000000000000000000000000,
    0x100000000000000000000000000000000,
    0x200000000000000000000000000000000,
    0x400000000000000000000000000000000,
    0x800000000000000000000000000000000,
    0x1000000000000000000000000000000000,
    0x2000000000000000000000000000000000,
    0x4000000000000000000000000000000000,
    0x8000000000000000000000000000000000,
    0x10000000000000000000000000000000000,
    0x20000000000000000000000000000000000,
    0x40000000000000000000000000000000000,
    0x80000000000000000000000000000000000,
    0x100000000000000000000000000000000000,
    0x200000000000000000000000000000000000,
    0x400000000000000000000000000000000000,
    0x800000000000000000000000000000000000,
    0x1000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000000000000000000
];

#[inline(always)]
pub fn shl_256(shift: u32, value: u256) -> u256 {
    let (res, _) = value.overflowing_mul(*BIT_SHIFT_TABLE.span()[shift]);

    res
}

#[inline(always)]
pub fn shr_256(shift: u32, value: u256) -> u256 {
    value / *BIT_SHIFT_TABLE.span()[shift]
}

#[inline(always)]
pub fn shl(shift: u32, value: felt252) -> u256 {
    shl_256(shift, value.into())
}

#[inline(always)]
pub fn shr(shift: u32, value: felt252) -> u256 {
    shr_256(shift, value.into())
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

const BYTEPAIR_SHIFT_TABLE: [u256; 16] = [
    0x1,
    0x10000,
    0x100000000,
    0x1000000000000,
    0x10000000000000000,
    0x100000000000000000000,
    0x1000000000000000000000000,
    0x10000000000000000000000000000,
    0x100000000000000000000000000000000,
    0x1000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000000000,
];

#[inline(always)]
pub fn pack_byte_array(value: @ByteArray) -> Span<felt252> {
    let mut res: Array<felt252> = ArrayTrait::new();
    let (full_runs, remainder) = DivRem::div_rem(value.len(), 31);
    let end = full_runs * 31;

    let mut i: u32 = 0;

    while i < end {
        let packed = (value[i]).into() |
            shl_byte(1, value[i+1].into()) |
            shl_byte(2, value[i+2].into()) |
            shl_byte(3, value[i+3].into()) |
            shl_byte(4, value[i+4].into()) |
            shl_byte(5, value[i+5].into()) |
            shl_byte(6, value[i+6].into()) |
            shl_byte(7, value[i+7].into()) |
            shl_byte(8, value[i+8].into()) |
            shl_byte(9, value[i+9].into()) |
            shl_byte(10, value[i+10].into()) |
            shl_byte(11, value[i+11].into()) |
            shl_byte(12, value[i+12].into()) |
            shl_byte(13, value[i+13].into()) |
            shl_byte(14, value[i+14].into()) |
            shl_byte(15, value[i+15].into()) |
            shl_byte(16, value[i+16].into()) |
            shl_byte(17, value[i+17].into()) |
            shl_byte(18, value[i+18].into()) |
            shl_byte(19, value[i+19].into()) |
            shl_byte(20, value[i+20].into()) |
            shl_byte(21, value[i+21].into()) |
            shl_byte(22, value[i+22].into()) |
            shl_byte(23, value[i+23].into()) |
            shl_byte(24, value[i+24].into()) |
            shl_byte(25, value[i+25].into()) |
            shl_byte(26, value[i+26].into()) |
            shl_byte(27, value[i+27].into()) |
            shl_byte(28, value[i+28].into()) |
            shl_byte(29, value[i+29].into()) |
            shl_byte(30, value[i+30].into());

        res.append(packed.try_into().unwrap());

        i += 31;
    };

    let mut packed: u256 = 0;

    let mut j: u32 = 0;

    while j < remainder {
        packed = packed | shl_byte(j, value[i+j].into());

        j += 1;
    };

    res.append(packed.try_into().unwrap());

    res.span()
}

/// transforms the given felt252 value into a byte array
/// TODO: verify endianess / test with ed25519 impl
#[inline(always)]
pub fn felt_to_byte_array(value: felt252) -> Array<u8> {
    let mut res: Array<u8> = ArrayTrait::new();
    let value_u256: u256 = value.into();

    res.append(byte_at(value_u256, 31));
    res.append(byte_at(value_u256, 30));
    res.append(byte_at(value_u256, 29));
    res.append(byte_at(value_u256, 28));
    res.append(byte_at(value_u256, 27));
    res.append(byte_at(value_u256, 26));
    res.append(byte_at(value_u256, 25));
    res.append(byte_at(value_u256, 24));
    res.append(byte_at(value_u256, 23));
    res.append(byte_at(value_u256, 22));
    res.append(byte_at(value_u256, 21));
    res.append(byte_at(value_u256, 20));
    res.append(byte_at(value_u256, 19));
    res.append(byte_at(value_u256, 18));
    res.append(byte_at(value_u256, 17));
    res.append(byte_at(value_u256, 16));
    res.append(byte_at(value_u256, 15));
    res.append(byte_at(value_u256, 14));
    res.append(byte_at(value_u256, 13));
    res.append(byte_at(value_u256, 12));
    res.append(byte_at(value_u256, 11));
    res.append(byte_at(value_u256, 10));
    res.append(byte_at(value_u256, 9));
    res.append(byte_at(value_u256, 8));
    res.append(byte_at(value_u256, 7));
    res.append(byte_at(value_u256, 6));
    res.append(byte_at(value_u256, 5));
    res.append(byte_at(value_u256, 4));
    res.append(byte_at(value_u256, 3));
    res.append(byte_at(value_u256, 2));
    res.append(byte_at(value_u256, 1));
    res.append(byte_at(value_u256, 0));

    res
}

#[inline(always)]
pub fn shl_byte_256(bytes: u32, value: u256) -> u256 {
    let (res, _) = value.overflowing_mul(*BYTE_SHIFT_TABLE.span()[bytes]);

    res
}

#[inline(always)]
pub fn shl_pair_256(pairs: u32, value: u256) -> u256 {
    let (res, _) = value.overflowing_mul(
        *BYTEPAIR_SHIFT_TABLE.span()[pairs]
    );

    res
}

#[inline(always)]
pub fn shl_byte(bytes: u32, value: felt252) -> u256 {
    shl_byte_256(bytes, value.into())
}

#[inline(always)]
pub fn shl_pair(pairs: u32, value: felt252) -> u256 {
    shl_pair_256(pairs, value.into())
}

#[inline(always)]
pub fn bytepair_at(value: u256, index: u32) -> u16 {
    (value / (*BYTEPAIR_SHIFT_TABLE.span()[index]) & 0xffff)
        .try_into().unwrap()
}

const M1: u256 = 0x5555555555555555555555555555555555555555555555555555555555555555;
const M2: u256 = 0x3333333333333333333333333333333333333333333333333333333333333333;
const M4: u256 = 0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F;
const M8: u256 = 0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF;
const M16: u256 = 0x0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF;
const M32: u256 = 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF;
const M64: u256 = 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF;
const M128: u256 = 0x00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

// efficient simd reverse bytes (usecase: swapping endianess)
#[inline(always)]
pub fn reverse_bytes(value: u256) -> u256 {
    let value = (shr_256(0x8, value) & M8) | shl_256(0x8, value & M8);
    let value = (shr_256(0x10, value) & M16) | shl_256(0x10, value & M16);
    let value = (shr_256(0x20, value) & M32) | shl_256(0x20, value & M32);
    let value = (shr_256(0x40, value) & M64) | shl_256(0x40, value & M64);

    (shr_256(0x80, value) & M128) | shl_256(0x80, value & M128)
}

#[inline(always)]
pub fn address_to_u8_array(
    address: ContractAddress
) -> Array<u8> {
    let mut res = ArrayTrait::new();
    let address_felt: felt252 = address.into();
    let mut shifted: u256 = address_felt.into();

    let mut i: u8 = 0;

    while i < 0x1f {
        let byte: u8 = (shifted & 0xff).try_into().unwrap();

        res.append(byte);

        shifted = shifted / 256;
        i += 1;
    };

    res
}

#[inline(always)]
fn unpack_u32_chunk_byte_array(
    sha: Span<u32>,
    chunk_nb: u32,
    ref output: ByteArray
) {
    let chunk: u256 = (*sha[chunk_nb]).into();

    output.append_byte(byte_at(chunk, 3));
    output.append_byte(byte_at(chunk, 2));
    output.append_byte(byte_at(chunk, 1));
    output.append_byte(byte_at(chunk, 0));
}

#[inline(always)]
pub fn sha256_to_byte_array(sha: Span<u32>) -> ByteArray {
    let mut sha_bytes: ByteArray = Default::default();

    unpack_u32_chunk_byte_array(sha, 0, ref sha_bytes);
    unpack_u32_chunk_byte_array(sha, 1, ref sha_bytes);
    unpack_u32_chunk_byte_array(sha, 2, ref sha_bytes);
    unpack_u32_chunk_byte_array(sha, 3, ref sha_bytes);
    unpack_u32_chunk_byte_array(sha, 4, ref sha_bytes);
    unpack_u32_chunk_byte_array(sha, 5, ref sha_bytes);
    unpack_u32_chunk_byte_array(sha, 6, ref sha_bytes);
    unpack_u32_chunk_byte_array(sha, 7, ref sha_bytes);

    sha_bytes
}

#[inline(always)]
fn pack_u32_chunk(sha: Span<u32>, chunk_nb: u32) -> u256 {
    let val: u256 = (*sha[chunk_nb]).into();
    let base_shift = 31 - chunk_nb * 4;

    shl_byte(base_shift, byte_at(val, 3).into()) |
        shl_byte(base_shift - 1, byte_at(val, 2).into()) |
        shl_byte(base_shift - 2, byte_at(val, 1).into()) |
        shl_byte(base_shift - 3, byte_at(val, 0).into())
}

#[inline(always)]
pub fn pack_sha256(hash: Span<u32>) -> u256 {
    pack_u32_chunk(hash, 0) |
    pack_u32_chunk(hash, 1) |
    pack_u32_chunk(hash, 2) |
    pack_u32_chunk(hash, 3) |
    pack_u32_chunk(hash, 4) |
    pack_u32_chunk(hash, 5) |
    pack_u32_chunk(hash, 6) |
    pack_u32_chunk(hash, 7)
}

#[inline(always)]
pub fn append_sha256_u32(ref data: ByteArray, chunk_nb: u32, input: Span<u32>) {
    let val = *input[chunk_nb];

    data.append_byte(byte_at(val.into(), 3));
    data.append_byte(byte_at(val.into(), 2));
    data.append_byte(byte_at(val.into(), 1));
    data.append_byte(byte_at(val.into(), 0));
}

#[inline(always)]
pub fn append_sha256(ref data: ByteArray, input: Span<u32>) {
    append_sha256_u32(ref data, 0, input);
    append_sha256_u32(ref data, 1, input);
    append_sha256_u32(ref data, 2, input);
    append_sha256_u32(ref data, 3, input);
    append_sha256_u32(ref data, 4, input);
    append_sha256_u32(ref data, 5, input);
    append_sha256_u32(ref data, 6, input);
    append_sha256_u32(ref data, 7, input);
}

#[inline(always)]
pub fn append_u256_be(ref data: ByteArray, value: u256) {
    data.append_byte(byte_at(value, 31));
    data.append_byte(byte_at(value, 30));
    data.append_byte(byte_at(value, 29));
    data.append_byte(byte_at(value, 28));
    data.append_byte(byte_at(value, 27));
    data.append_byte(byte_at(value, 26));
    data.append_byte(byte_at(value, 25));
    data.append_byte(byte_at(value, 24));
    data.append_byte(byte_at(value, 23));
    data.append_byte(byte_at(value, 22));
    data.append_byte(byte_at(value, 21));
    data.append_byte(byte_at(value, 20));
    data.append_byte(byte_at(value, 19));
    data.append_byte(byte_at(value, 18));
    data.append_byte(byte_at(value, 17));
    data.append_byte(byte_at(value, 16));
    data.append_byte(byte_at(value, 15));
    data.append_byte(byte_at(value, 14));
    data.append_byte(byte_at(value, 13));
    data.append_byte(byte_at(value, 12));
    data.append_byte(byte_at(value, 11));
    data.append_byte(byte_at(value, 10));
    data.append_byte(byte_at(value, 9));
    data.append_byte(byte_at(value, 8));
    data.append_byte(byte_at(value, 7));
    data.append_byte(byte_at(value, 6));
    data.append_byte(byte_at(value, 5));
    data.append_byte(byte_at(value, 4));
    data.append_byte(byte_at(value, 3));
    data.append_byte(byte_at(value, 2));
    data.append_byte(byte_at(value, 1));
    data.append_byte(byte_at(value, 0));
}

#[inline(always)]
pub fn append_u256_be_from(
    ref data: ByteArray,
    input: u256,
    from: u32
) {
    let mut i = from;

    loop {
        data.append_byte(byte_at(input, i));

        if i == 0 {
            break;
        }

        i -= 1;
    };
}

#[inline(always)]
pub fn append_u256_le(ref data: ByteArray, value: u256) {
    data.append_byte(byte_at(value, 0));
    data.append_byte(byte_at(value, 1));
    data.append_byte(byte_at(value, 2));
    data.append_byte(byte_at(value, 3));
    data.append_byte(byte_at(value, 4));
    data.append_byte(byte_at(value, 5));
    data.append_byte(byte_at(value, 6));
    data.append_byte(byte_at(value, 7));
    data.append_byte(byte_at(value, 8));
    data.append_byte(byte_at(value, 9));
    data.append_byte(byte_at(value, 10));
    data.append_byte(byte_at(value, 11));
    data.append_byte(byte_at(value, 12));
    data.append_byte(byte_at(value, 13));
    data.append_byte(byte_at(value, 14));
    data.append_byte(byte_at(value, 15));
    data.append_byte(byte_at(value, 16));
    data.append_byte(byte_at(value, 17));
    data.append_byte(byte_at(value, 18));
    data.append_byte(byte_at(value, 19));
    data.append_byte(byte_at(value, 20));
    data.append_byte(byte_at(value, 21));
    data.append_byte(byte_at(value, 22));
    data.append_byte(byte_at(value, 23));
    data.append_byte(byte_at(value, 24));
    data.append_byte(byte_at(value, 25));
    data.append_byte(byte_at(value, 26));
    data.append_byte(byte_at(value, 27));
    data.append_byte(byte_at(value, 28));
    data.append_byte(byte_at(value, 29));
    data.append_byte(byte_at(value, 30));
    data.append_byte(byte_at(value, 31));
}

#[inline(always)]
pub fn append_u32_le(ref data: ByteArray, value: u32) {
    data.append_byte((value & 0xff).try_into().unwrap());
    data.append_byte(((value / 0x100) & 0xff).try_into().unwrap());
    data.append_byte(((value / 0x10000) & 0xff).try_into().unwrap());
    data.append_byte((value / 0x1000000).try_into().unwrap());
}

#[inline(always)]
pub fn append_u64_le(ref data: ByteArray, value: u64) {
    let low: u32 = (value & 0xffffffff).try_into().unwrap();
    let high: u32 = (value / 0x100000000).try_into().unwrap();
    append_u32_le(ref data, low);
    append_u32_le(ref data, high);
}

#[inline(always)]
pub fn append_varint(ref data: ByteArray, value: u32) {
    if value < 0xfd {
        data.append_byte(value.try_into().unwrap());
    } else if value <= 0xffff {
        data.append_byte(0xfd);

        let val_u16: u16 = value.try_into().unwrap();

        data.append_byte((val_u16 & 0xff).try_into().unwrap());
        data.append_byte((shr_256(8, val_u16.into()) & 0xff).try_into().unwrap());
    } else {
        data.append_byte(0xfe);
        append_u32_le(ref data, value);
    }
}

#[inline(always)]
pub fn append_varslice(ref data: ByteArray, slice: @ByteArray) {
    let len = slice.len();

    data.append_byte(len.try_into().unwrap());

    data = ByteArrayTrait::concat(@data, slice);
}

#[inline(always)]
pub fn padd_32_bytes_str(data: u256) -> ByteArray {
    let str = format!("{:x}", data);
    let mut padd = "";

    for _ in 0..(64 - str.len()) {
        padd += "0";
    };

    padd + str
}
