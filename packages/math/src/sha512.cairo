use core::integer::{bitwise, u64_bitwise};
use core::num::traits::{Bounded, WrappingAdd};
use core::traits::{BitAnd, BitOr, BitXor};


// Variable naming is compliant to RFC-6234 (https://datatracker.ietf.org/doc/html/rfc6234)

pub const SHA512_LEN: usize = 64;

pub const TWO_POW_56_NZ: NonZero<u64> = 0x100000000000000;
pub const TWO_POW_48_NZ: NonZero<u64> = 0x1000000000000;
pub const TWO_POW_40_NZ: NonZero<u64> = 0x10000000000;
pub const TWO_POW_32_NZ: NonZero<u64> = 0x100000000;
pub const TWO_POW_24_NZ: NonZero<u64> = 0x1000000;
pub const TWO_POW_16_NZ: NonZero<u64> = 0x10000;
pub const TWO_POW_8_NZ: NonZero<u64> = 0x100;

pub const TWO_POW_56: u64 = 0x100000000000000;
pub const TWO_POW_48: u64 = 0x1000000000000;
pub const TWO_POW_40: u64 = 0x10000000000;
pub const TWO_POW_32: u64 = 0x100000000;
pub const TWO_POW_24: u64 = 0x1000000;
pub const TWO_POW_16: u64 = 0x10000;
pub const TWO_POW_8: u64 = 0x100;


pub const TWO_POW_4: u64 = 0x10;
pub const TWO_POW_2: u64 = 0x4;
pub const TWO_POW_1: u64 = 0x2;
pub const TWO_POW_0: u64 = 0x1;

const TWO_POW_6: u64 = 0x40;
const TWO_POW_7: u64 = 0x80;
const TWO_POW_14: u64 = 0x4000;
const TWO_POW_18: u64 = 0x40000;
const TWO_POW_19: u64 = 0x80000;
const TWO_POW_28: u64 = 0x10000000;
const TWO_POW_34: u64 = 0x400000000;
const TWO_POW_39: u64 = 0x8000000000;
const TWO_POW_41: u64 = 0x20000000000;
const TWO_POW_61: u64 = 0x2000000000000000;
const TWO_POW_64: u128 = 0x10000000000000000;

const TWO_POW_64_MINUS_1: u64 = 0x8000000000000000;
const TWO_POW_64_MINUS_8: u64 = 0x100000000000000;
const TWO_POW_64_MINUS_14: u64 = 0x4000000000000;
const TWO_POW_64_MINUS_18: u64 = 0x400000000000;
const TWO_POW_64_MINUS_19: u64 = 0x200000000000;
const TWO_POW_64_MINUS_28: u64 = 0x1000000000;
const TWO_POW_64_MINUS_34: u64 = 0x40000000;
const TWO_POW_64_MINUS_39: u64 = 0x2000000;
const TWO_POW_64_MINUS_41: u64 = 0x800000;
const TWO_POW_64_MINUS_61: u64 = 0x8;

// Max u8 and u64 for bitwise operations
pub const MAX_U8: u64 = 0xff;
pub const MAX_U64: u128 = 0xffffffffffffffff;

#[derive(Drop, Copy)]
pub struct Word64 {
    pub data: u64,
}

impl WordBitAnd of BitAnd<Word64> {
    fn bitand(lhs: Word64, rhs: Word64) -> Word64 {
        Word64 { data: lhs.data & rhs.data }
    }
}

impl WordBitXor of BitXor<Word64> {
    fn bitxor(lhs: Word64, rhs: Word64) -> Word64 {
        Word64 { data: lhs.data ^ rhs.data }
    }
}

impl WordBitOr of BitOr<Word64> {
    fn bitor(lhs: Word64, rhs: Word64) -> Word64 {
        Word64 { data: lhs.data | rhs.data }
    }
}

impl WordBitNot of BitNot<Word64> {
    fn bitnot(a: Word64) -> Word64 {
        Word64 { data: ~a.data }
    }
}

impl WordAdd of Add<Word64> {
    fn add(lhs: Word64, rhs: Word64) -> Word64 {
        Word64 { data: lhs.data.wrapping_add(rhs.data) }
    }
}

impl U128IntoWord of Into<u128, Word64> {
    fn into(self: u128) -> Word64 {
        Word64 { data: self.try_into().unwrap() }
    }
}

impl U64IntoWord of Into<u64, Word64> {
    fn into(self: u64) -> Word64 {
        Word64 { data: self }
    }
}

impl WordIntoFelt252 of Into<Word64, felt252> {
    fn into(self: Word64) -> felt252 {
        self.data.into()
    }
}
use core::circuit::conversions::bounded_int::{
    AddHelper, BoundedInt, DivRemHelper, MulHelper, UnitInt,
};
use core::circuit::conversions::{DivRemU128By64, NZ_POW64_TYPED, bounded_int, upcast};

impl Felt252IntoWord of Into<felt252, Word64> {
    fn into(self: felt252) -> Word64 {
        let f_128: u128 = self.try_into().unwrap();
        let (_, rem) = bounded_int::div_rem(f_128, NZ_POW64_TYPED);
        Word64 { data: upcast(rem) }
    }
}

pub trait WordOperations<T> {
    fn rotr_precomputed(self: T, two_pow_n: u64, two_pow_64_n: u64) -> u128;
}

pub impl Word64WordOperations of WordOperations<Word64> {
    // does the work of rotr but with precomputed values 2**n and 2**(64-n)
    fn rotr_precomputed(self: Word64, two_pow_n: u64, two_pow_64_n: u64) -> u128 {
        let data = self.data.into();
        let data: u128 = math_shr_precomputed::<u128>(data, two_pow_n.into())
            | math_shl_precomputed_u128(data, two_pow_64_n.into());

        data
    }
}


fn ch(e: Word64, f: Word64, g: Word64) -> felt252 {
    (e & f).into() + (~e & g).into()
}

fn maj(x: Word64, y: Word64, z: Word64) -> felt252 {
    // (x & y) ^ (x & z) ^ (y & z)
    let x_xor_y = x ^ y;
    let x_xor_y_xor_z = x_xor_y ^ z;

    let res: felt252 = core::felt252_div(
        (x.into() + y.into() + z.into() - x_xor_y_xor_z.into()), 2,
    );
    res
}

/// Performs x.rotr(28) ^ x.rotr(34) ^ x.rotr(39),
/// Using precomputed values to avoid recomputation
fn bsig0(x: Word64) -> u128 {
    // x.rotr(28) ^ x.rotr(34) ^ x.rotr(39)
    x.rotr_precomputed(TWO_POW_28, TWO_POW_64_MINUS_28)
        ^ x.rotr_precomputed(TWO_POW_34, TWO_POW_64_MINUS_34)
        ^ x.rotr_precomputed(TWO_POW_39, TWO_POW_64_MINUS_39)
}

/// Performs x.rotr(14) ^ x.rotr(18) ^ x.rotr(41),
/// Using precomputed values to avoid recomputation
fn bsig1(x: Word64) -> u128 {
    // x.rotr(14) ^ x.rotr(18) ^ x.rotr(41)
    x.rotr_precomputed(TWO_POW_14, TWO_POW_64_MINUS_14)
        ^ x.rotr_precomputed(TWO_POW_18, TWO_POW_64_MINUS_18)
        ^ x.rotr_precomputed(TWO_POW_41, TWO_POW_64_MINUS_41)
}

/// Performs x.rotr(1) ^ x.rotr(8) ^ x.shr(7),
/// Using precomputed values to avoid recomputation
fn ssig0(x: Word64) -> u128 {
    // x.rotr(1) ^ x.rotr(8) ^ x.shr(7)
    x.rotr_precomputed(TWO_POW_1, TWO_POW_64_MINUS_1)
        ^ x.rotr_precomputed(TWO_POW_8, TWO_POW_64_MINUS_8)
        ^ math_shr_precomputed::<u64>(x.data.into(), TWO_POW_7).into() // 2 ** 7
}

/// Performs x.rotr(19) ^ x.rotr(61) ^ x.shr(6),
/// Using precomputed values to avoid recomputation
fn ssig1(x: Word64) -> u128 {
    // x.rotr(19) ^ x.rotr(61) ^ x.shr(6)
    x.rotr_precomputed(TWO_POW_19, TWO_POW_64_MINUS_19)
        ^ x.rotr_precomputed(TWO_POW_61, TWO_POW_64_MINUS_61)
        ^ math_shr_precomputed::<u64>(x.data, TWO_POW_6).into() // 2 ** 6
}


// Shift left with precomputed powers of 2
// Only use in this file. Unsafe otherwise.
fn math_shl_precomputed_u128(x: u128, two_power_n: u128) -> u128 {
    let mul: felt252 = x.into() * two_power_n.into();
    mul.try_into().unwrap()
}

// Shift right with precomputed powers of 2
fn math_shr_precomputed<T, +Div<T>, +Rem<T>, +Drop<T>, +Copy<T>, +Into<T, u128>>(
    x: T, two_power_n: T,
) -> T {
    x / two_power_n
}

fn add_trailing_zeroes(ref data: Array<u8>, msg_len: usize) {
    let mdi = msg_len % 128;
    let padding_len = if (mdi < 112) {
        119 - mdi
    } else {
        247 - mdi
    };

    let mut i = 0;
    while (i != padding_len) {
        data.append(0);
        i += 1;
    };
}

// Input must be a multiple of 8.
fn from_u8Array_to_WordArray(mut data: Span<u8>) -> Array<Word64> {
    let mut new_arr: Array<Word64> = array![];

    while let Some(b8) = data.multi_pop_front::<8>() {
        let [b7, b6, b5, b4, b3, b2, b1, b0] = b8.unbox();
        let b0: felt252 = b0.into();
        let b1: felt252 = b1.into();
        let b2: felt252 = b2.into();
        let b3: felt252 = b3.into();
        let b4: felt252 = b4.into();
        let b5: felt252 = b5.into();
        let b6: felt252 = b6.into();
        let b7: felt252 = b7.into();

        let new_word: felt252 = b0
            + 256
                * (b1 + 256 * (b2 + 256 * (b3 + 256 * (b4 + 256 * (b5 + 256 * (b6 + 256 * b7))))));

        new_arr.append(Word64 { data: new_word.try_into().unwrap() });
    }
    new_arr
}

fn from_WordArray_to_u8array(data: Span<Word64>) -> Array<u8> {
    let mut arr: Array<u8> = array![];

    // Use precomputed powers of 2 for shift right to avoid recomputation
    for word in data {
        let data_i: u64 = *word.data;
        let (w7, w) = DivRem::div_rem(data_i, TWO_POW_56_NZ);
        let (w6, w) = DivRem::div_rem(w, TWO_POW_48_NZ);
        let (w5, w) = DivRem::div_rem(w, TWO_POW_40_NZ);
        let (w4, w) = DivRem::div_rem(w, TWO_POW_32_NZ);
        let (w3, w) = DivRem::div_rem(w, TWO_POW_24_NZ);
        let (w2, w) = DivRem::div_rem(w, TWO_POW_16_NZ);
        let (w1, w0) = DivRem::div_rem(w, TWO_POW_8_NZ);

        arr.append(w7.try_into().unwrap());
        arr.append(w6.try_into().unwrap());
        arr.append(w5.try_into().unwrap());
        arr.append(w4.try_into().unwrap());
        arr.append(w3.try_into().unwrap());
        arr.append(w2.try_into().unwrap());
        arr.append(w1.try_into().unwrap());
        arr.append(w0.try_into().unwrap());
    }
    arr
}

fn digest_hash(data: Span<Word64>, msg_len: usize) -> [Word64; 8] {
    let k = K.span();

    let block_nb = msg_len / 128;

    let [mut h_0, mut h_1, mut h_2, mut h_3, mut h_4, mut h_5, mut h_6, mut h_7] = H;

    let mut i = 0;

    while (i != block_nb) {
        // Prepare message schedule
        let mut t: usize = 0;

        let mut W: Array<Word64> = array![];
        while (t != 80) {
            if t < 16 {
                W.append(*data.at(i * 16 + t));
            } else {
                let buf_felt252: felt252 = ssig1(*W.at(t - 2)).into()
                    + (*W.at(t - 7)).into()
                    + ssig0(*W.at(t - 15)).into()
                    + (*W.at(t - 16)).into();
                let buf: Word64 = buf_felt252.into();
                W.append(buf);
            }
            t += 1;
        }

        let mut a = h_0;
        let mut b = h_1;
        let mut c = h_2;
        let mut d = h_3;
        let mut e = h_4;
        let mut f = h_5;
        let mut g = h_6;
        let mut h = h_7;

        let mut W = W.span();
        for _k in k {
            let T1_felt252: felt252 = h.into()
                + bsig1(e).into()
                + ch(e, f, g)
                + (*_k).into()
                + (*W.pop_front().unwrap()).into();

            let T1_T2_felt252: felt252 = bsig0(a).into() + maj(a, b, c) + T1_felt252;
            h = g;
            g = f;
            f = e;
            e = d + T1_felt252.into();
            d = c;
            c = b;
            b = a;
            a = T1_T2_felt252.into();
        }

        h_0 = a + h_0;
        h_1 = b + h_1;
        h_2 = c + h_2;
        h_3 = d + h_3;
        h_4 = e + h_4;
        h_5 = f + h_5;
        h_6 = g + h_6;
        h_7 = h + h_7;

        i += 1;
    }

    return [h_0, h_1, h_2, h_3, h_4, h_5, h_6, h_7];
}

pub fn sha512(mut data: Array<u8>) -> Array<u8> {
    let hash = _sha512(data);
    from_WordArray_to_u8array(hash.span())
}

pub fn _sha512(mut data: Array<u8>) -> [Word64; 8] {
    let bit_numbers: u128 = data.len().into() * 8;
    // any u32 * 8 fits in u64
    // let bit_numbers = bit_numbers & Bounded::<u64>::MAX.into();

    let max_u8: u128 = MAX_U8.into();
    let mut msg_len = data.len();

    // Appends 1
    data.append(0x80);

    add_trailing_zeroes(ref data, msg_len);

    // add length to the end
    // Use precomputed powers of 2 for shift right to avoid recomputation
    let mut res: u128 = math_shr_precomputed(bit_numbers, TWO_POW_56.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_48.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_40.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_32.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_24.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_16.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_8.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_0.into()) & max_u8;
    data.append(res.try_into().unwrap());

    msg_len = data.len();

    let mut data = from_u8Array_to_WordArray(data.span());

    let hash = digest_hash(data.span(), msg_len);
    hash
}


const H: [Word64; 8] = [
    Word64 { data: 0x6a09e667f3bcc908 }, Word64 { data: 0xbb67ae8584caa73b },
    Word64 { data: 0x3c6ef372fe94f82b }, Word64 { data: 0xa54ff53a5f1d36f1 },
    Word64 { data: 0x510e527fade682d1 }, Word64 { data: 0x9b05688c2b3e6c1f },
    Word64 { data: 0x1f83d9abfb41bd6b }, Word64 { data: 0x5be0cd19137e2179 },
];


const K: [Word64; 80] = [
    Word64 { data: 0x428a2f98d728ae22 }, Word64 { data: 0x7137449123ef65cd },
    Word64 { data: 0xb5c0fbcfec4d3b2f }, Word64 { data: 0xe9b5dba58189dbbc },
    Word64 { data: 0x3956c25bf348b538 }, Word64 { data: 0x59f111f1b605d019 },
    Word64 { data: 0x923f82a4af194f9b }, Word64 { data: 0xab1c5ed5da6d8118 },
    Word64 { data: 0xd807aa98a3030242 }, Word64 { data: 0x12835b0145706fbe },
    Word64 { data: 0x243185be4ee4b28c }, Word64 { data: 0x550c7dc3d5ffb4e2 },
    Word64 { data: 0x72be5d74f27b896f }, Word64 { data: 0x80deb1fe3b1696b1 },
    Word64 { data: 0x9bdc06a725c71235 }, Word64 { data: 0xc19bf174cf692694 },
    Word64 { data: 0xe49b69c19ef14ad2 }, Word64 { data: 0xefbe4786384f25e3 },
    Word64 { data: 0x0fc19dc68b8cd5b5 }, Word64 { data: 0x240ca1cc77ac9c65 },
    Word64 { data: 0x2de92c6f592b0275 }, Word64 { data: 0x4a7484aa6ea6e483 },
    Word64 { data: 0x5cb0a9dcbd41fbd4 }, Word64 { data: 0x76f988da831153b5 },
    Word64 { data: 0x983e5152ee66dfab }, Word64 { data: 0xa831c66d2db43210 },
    Word64 { data: 0xb00327c898fb213f }, Word64 { data: 0xbf597fc7beef0ee4 },
    Word64 { data: 0xc6e00bf33da88fc2 }, Word64 { data: 0xd5a79147930aa725 },
    Word64 { data: 0x06ca6351e003826f }, Word64 { data: 0x142929670a0e6e70 },
    Word64 { data: 0x27b70a8546d22ffc }, Word64 { data: 0x2e1b21385c26c926 },
    Word64 { data: 0x4d2c6dfc5ac42aed }, Word64 { data: 0x53380d139d95b3df },
    Word64 { data: 0x650a73548baf63de }, Word64 { data: 0x766a0abb3c77b2a8 },
    Word64 { data: 0x81c2c92e47edaee6 }, Word64 { data: 0x92722c851482353b },
    Word64 { data: 0xa2bfe8a14cf10364 }, Word64 { data: 0xa81a664bbc423001 },
    Word64 { data: 0xc24b8b70d0f89791 }, Word64 { data: 0xc76c51a30654be30 },
    Word64 { data: 0xd192e819d6ef5218 }, Word64 { data: 0xd69906245565a910 },
    Word64 { data: 0xf40e35855771202a }, Word64 { data: 0x106aa07032bbd1b8 },
    Word64 { data: 0x19a4c116b8d2d0c8 }, Word64 { data: 0x1e376c085141ab53 },
    Word64 { data: 0x2748774cdf8eeb99 }, Word64 { data: 0x34b0bcb5e19b48a8 },
    Word64 { data: 0x391c0cb3c5c95a63 }, Word64 { data: 0x4ed8aa4ae3418acb },
    Word64 { data: 0x5b9cca4f7763e373 }, Word64 { data: 0x682e6ff3d6b2b8a3 },
    Word64 { data: 0x748f82ee5defb2fc }, Word64 { data: 0x78a5636f43172f60 },
    Word64 { data: 0x84c87814a1f0ab72 }, Word64 { data: 0x8cc702081a6439ec },
    Word64 { data: 0x90befffa23631e28 }, Word64 { data: 0xa4506cebde82bde9 },
    Word64 { data: 0xbef9a3f7b2c67915 }, Word64 { data: 0xc67178f2e372532b },
    Word64 { data: 0xca273eceea26619c }, Word64 { data: 0xd186b8c721c0c207 },
    Word64 { data: 0xeada7dd6cde0eb1e }, Word64 { data: 0xf57d4f7fee6ed178 },
    Word64 { data: 0x06f067aa72176fba }, Word64 { data: 0x0a637dc5a2c898a6 },
    Word64 { data: 0x113f9804bef90dae }, Word64 { data: 0x1b710b35131c471b },
    Word64 { data: 0x28db77f523047d84 }, Word64 { data: 0x32caab7b40c72493 },
    Word64 { data: 0x3c9ebe0a15c9bebc }, Word64 { data: 0x431d67c49c100d4c },
    Word64 { data: 0x4cc5d4becb3e42b6 }, Word64 { data: 0x597f299cfc657e2a },
    Word64 { data: 0x5fcb6fab3ad6faec }, Word64 { data: 0x6c44198c4a475817 },
];

