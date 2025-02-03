use core::num::traits::{Bounded, WrappingAdd};
use core::traits::{BitAnd, BitOr, BitXor};

// Variable naming is compliant to RFC-6234 (https://datatracker.ietf.org/doc/html/rfc6234)

pub const SHA512_LEN: usize = 64;

pub const U64_BIT_NUM: u64 = 64;

// Powers of two to avoid recomputing
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

const TWO_POW_7: u64 = 0x80;
const TWO_POW_14: u64 = 0x4000;
const TWO_POW_18: u64 = 0x40000;
const TWO_POW_19: u64 = 0x80000;
const TWO_POW_28: u64 = 0x10000000;
const TWO_POW_34: u64 = 0x400000000;
const TWO_POW_39: u64 = 0x8000000000;
const TWO_POW_41: u64 = 0x20000000000;
const TWO_POW_61: u64 = 0x2000000000000000;

const TWO_POW_64_MINUS_1: u64 = 0x8000000000000000;
const TWO_POW_64_MINUS_6: u64 = 0x40;
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
        let data = BitAnd::bitand(lhs.data, rhs.data);
        Word64 { data }
    }
}

impl WordBitXor of BitXor<Word64> {
    fn bitxor(lhs: Word64, rhs: Word64) -> Word64 {
        let data = BitXor::bitxor(lhs.data, rhs.data);
        Word64 { data }
    }
}

impl WordBitOr of BitOr<Word64> {
    fn bitor(lhs: Word64, rhs: Word64) -> Word64 {
        let data = BitOr::bitor(lhs.data, rhs.data);
        Word64 { data }
    }
}

impl WordBitNot of BitNot<Word64> {
    fn bitnot(a: Word64) -> Word64 {
        Word64 { data: Bounded::MAX - a.data }
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

pub trait WordOperations<T> {
    fn shr(self: T, n: u64) -> T;
    fn shl(self: T, n: u64) -> T;
    fn rotr(self: T, n: u64) -> T;
    fn rotr_precomputed(self: T, two_pow_n: u64, two_pow_64_n: u64) -> T;
    fn rotl(self: T, n: u64) -> T;
}

pub impl Word64WordOperations of WordOperations<Word64> {
    fn shr(self: Word64, n: u64) -> Word64 {
        Word64 { data: math_shr_u64(self.data, n) }
    }
    fn shl(self: Word64, n: u64) -> Word64 {
        Word64 { data: math_shl_u64(self.data, n) }
    }
    fn rotr(self: Word64, n: u64) -> Word64 {
        let data = BitOr::bitor(
            math_shr_u64(self.data, n), math_shl_u64(self.data, (U64_BIT_NUM - n)),
        );
        Word64 { data }
    }
    // does the work of rotr but with precomputed values 2**n and 2**(64-n)
    fn rotr_precomputed(self: Word64, two_pow_n: u64, two_pow_64_n: u64) -> Word64 {
        let data = self.data.into();
        let data: u128 = BitOr::bitor(
            math_shr_precomputed::<u128>(data, two_pow_n.into()),
            math_shl_precomputed::<u128>(data, two_pow_64_n.into()),
        );

        let data: u64 = match data.try_into() {
            Option::Some(data) => data,
            Option::None => (data & MAX_U64).try_into().unwrap(),
        };

        Word64 { data }
    }
    fn rotl(self: Word64, n: u64) -> Word64 {
        let data = BitOr::bitor(
            math_shl_u64(self.data, n), math_shr_u64(self.data, (U64_BIT_NUM - n)),
        );
        Word64 { data }
    }
}


fn ch(x: Word64, y: Word64, z: Word64) -> Word64 {
    (x & y) ^ (~x & z)
}

fn maj(x: Word64, y: Word64, z: Word64) -> Word64 {
    (x & y) ^ (x & z) ^ (y & z)
}

/// Performs x.rotr(28) ^ x.rotr(34) ^ x.rotr(39),
/// Using precomputed values to avoid recomputation
fn bsig0(x: Word64) -> Word64 {
    // x.rotr(28) ^ x.rotr(34) ^ x.rotr(39)
    x.rotr_precomputed(TWO_POW_28, TWO_POW_64_MINUS_28)
        ^ x.rotr_precomputed(TWO_POW_34, TWO_POW_64_MINUS_34)
        ^ x.rotr_precomputed(TWO_POW_39, TWO_POW_64_MINUS_39)
}

/// Performs x.rotr(14) ^ x.rotr(18) ^ x.rotr(41),
/// Using precomputed values to avoid recomputation
fn bsig1(x: Word64) -> Word64 {
    // x.rotr(14) ^ x.rotr(18) ^ x.rotr(41)
    x.rotr_precomputed(TWO_POW_14, TWO_POW_64_MINUS_14)
        ^ x.rotr_precomputed(TWO_POW_18, TWO_POW_64_MINUS_18)
        ^ x.rotr_precomputed(TWO_POW_41, TWO_POW_64_MINUS_41)
}

/// Performs x.rotr(1) ^ x.rotr(8) ^ x.shr(7),
/// Using precomputed values to avoid recomputation
fn ssig0(x: Word64) -> Word64 {
    // x.rotr(1) ^ x.rotr(8) ^ x.shr(7)
    x.rotr_precomputed(TWO_POW_1, TWO_POW_64_MINUS_1)
        ^ x.rotr_precomputed(TWO_POW_8, TWO_POW_64_MINUS_8)
        ^ math_shr_precomputed::<u64>(x.data.into(), TWO_POW_7).into() // 2 ** 7
}

/// Performs x.rotr(19) ^ x.rotr(61) ^ x.shr(6),
/// Using precomputed values to avoid recomputation
fn ssig1(x: Word64) -> Word64 {
    // x.rotr(19) ^ x.rotr(61) ^ x.shr(6)
    x.rotr_precomputed(TWO_POW_19, TWO_POW_64_MINUS_19)
        ^ x.rotr_precomputed(TWO_POW_61, TWO_POW_64_MINUS_61)
        ^ math_shr_precomputed::<u64>(x.data, TWO_POW_64_MINUS_6).into() // 2 ** 6
}

/// Calculates base ** power
pub fn fpow(mut base: u128, mut power: u128) -> u128 {
    // Return invalid input error
    assert!(base != 0, "fpow: invalid input");

    let mut result = 1;
    while (power != 0) {
        let (q, r) = DivRem::div_rem(power, 2);
        if r == 1 {
            result = (result * base);
        }
        base = base * base;
        power = q;
    }

    result
}

const two_squarings: [u64; 6] = [
    TWO_POW_1, TWO_POW_2, TWO_POW_4, TWO_POW_8, TWO_POW_16, TWO_POW_32,
];
// Uses cache for faster powers of 2 in a u128
// Uses TWO_POW_* constants
// Generic T to use with both u128 and u64
pub fn two_pow<T, +DivRem<T>, +Mul<T>, +Into<u64, T>, +Drop<T>>(mut power: u64) -> T {
    let mut i = 0;
    let mut result: T = 1_u64.into();
    let two_squarings = two_squarings.span();
    while (power != 0) {
        let (q, r) = DivRem::div_rem(power, 2);
        if r == 1 {
            result = result * (*two_squarings[i]).into();
        }
        i = i + 1;
        power = q;
    }

    result
}

// Shift left with math_shl_precomputed function
fn math_shl(x: u128, n: u64) -> u128 {
    math_shl_precomputed(x, two_pow(n))
}

// Shift right with math_shr_precomputed function
fn math_shr(x: u128, n: u64) -> u128 {
    math_shr_precomputed(x, two_pow(n))
}

// Shift left with precomputed powers of 2
fn math_shl_precomputed<T, +Mul<T>, +Rem<T>, +Drop<T>, +Copy<T>, +Into<T, u128>>(
    x: T, two_power_n: T,
) -> T {
    x * two_power_n
}

// Shift right with precomputed powers of 2
fn math_shr_precomputed<T, +Div<T>, +Rem<T>, +Drop<T>, +Copy<T>, +Into<T, u128>>(
    x: T, two_power_n: T,
) -> T {
    x / two_power_n
}

// Shift left wrapper for u64
fn math_shl_u64(x: u64, n: u64) -> u64 {
    (math_shl(x.into(), n) % Bounded::<u64>::MAX.into()).try_into().unwrap()
}

// Shift right wrapper for u64
fn math_shr_u64(x: u64, n: u64) -> u64 {
    (math_shr(x.into(), n) % Bounded::<u64>::MAX.into()).try_into().unwrap()
}

fn add_trailing_zeroes(ref data: Array<u8>, msg_len: usize) {
    let mdi = msg_len % 128;
    let padding_len = if (mdi < 112) {
        119 - mdi
    } else {
        247 - mdi
    };

    let mut i = 0;
    while (i < padding_len) {
        data.append(0);
        i += 1;
    };
}

fn from_u8Array_to_WordArray(data: Array<u8>) -> Array<Word64> {
    let mut new_arr: Array<Word64> = array![];
    let mut i = 0;

    // Use precomputed powers of 2 for shift left to avoid recomputation
    // Safe to use u64 coz we shift u8 to the left by max 56 bits in u64
    while (i < data.len()) {
        let new_word: u64 = math_shl_precomputed::<u64>((*data[i + 0]).into(), TWO_POW_56)
            + math_shl_precomputed((*data[i + 1]).into(), TWO_POW_48)
            + math_shl_precomputed((*data[i + 2]).into(), TWO_POW_40)
            + math_shl_precomputed((*data[i + 3]).into(), TWO_POW_32)
            + math_shl_precomputed((*data[i + 4]).into(), TWO_POW_24)
            + math_shl_precomputed((*data[i + 5]).into(), TWO_POW_16)
            + math_shl_precomputed((*data[i + 6]).into(), TWO_POW_8)
            + math_shl_precomputed((*data[i + 7]).into(), TWO_POW_0);
        new_arr.append(Word64 { data: new_word });
        i += 8;
    }
    new_arr
}

fn from_WordArray_to_u8array(data: Span<Word64>) -> Array<u8> {
    let mut arr: Array<u8> = array![];

    let mut i = 0;
    // Use precomputed powers of 2 for shift right to avoid recomputation
    while (i != data.len()) {
        let mut res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_56) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_48) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_40) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_32) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_24) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_16) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_8) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_0) & MAX_U8;
        arr.append(res.try_into().unwrap());
        i += 1;
    }
    arr
}

fn digest_hash(data: Span<Word64>, msg_len: usize) -> Array<Word64> {
    let k = get_k().span();
    let h = get_h().span();

    let block_nb = msg_len / 128;

    let mut h_0: Word64 = *h[0];
    let mut h_1: Word64 = *h[1];
    let mut h_2: Word64 = *h[2];
    let mut h_3: Word64 = *h[3];
    let mut h_4: Word64 = *h[4];
    let mut h_5: Word64 = *h[5];
    let mut h_6: Word64 = *h[6];
    let mut h_7: Word64 = *h[7];

    let mut i = 0;

    while (i != block_nb) {
        // Prepare message schedule
        let mut t: usize = 0;

        let mut W: Array<Word64> = array![];
        while (t != 80) {
            if t < 16 {
                W.append(*data.at(i * 16 + t));
            } else {
                let buf = ssig1(*W.at(t - 2)) + *W.at(t - 7) + ssig0(*W.at(t - 15)) + *W.at(t - 16);
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

        let mut t: usize = 0;
        while (t != 80) {
            let T1 = h + bsig1(e) + ch(e, f, g) + *k.at(t) + *W.at(t);
            let T2 = bsig0(a) + maj(a, b, c);
            h = g;
            g = f;
            f = e;
            e = d + T1;
            d = c;
            c = b;
            b = a;
            a = T1 + T2;

            t += 1;
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

    array![h_0, h_1, h_2, h_3, h_4, h_5, h_6, h_7]
}

pub fn sha512(mut data: Array<u8>) -> Array<u8> {
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

    let mut data = from_u8Array_to_WordArray(data);

    let hash = digest_hash(data.span(), msg_len);
    from_WordArray_to_u8array(hash.span())
}

fn get_h() -> Array<Word64> {
    let mut h: Array<Word64> = array![];
    h.append(Word64 { data: 0x6a09e667f3bcc908 });
    h.append(Word64 { data: 0xbb67ae8584caa73b });
    h.append(Word64 { data: 0x3c6ef372fe94f82b });
    h.append(Word64 { data: 0xa54ff53a5f1d36f1 });
    h.append(Word64 { data: 0x510e527fade682d1 });
    h.append(Word64 { data: 0x9b05688c2b3e6c1f });
    h.append(Word64 { data: 0x1f83d9abfb41bd6b });
    h.append(Word64 { data: 0x5be0cd19137e2179 });
    h
}

fn get_k() -> Array<Word64> {
    let mut k: Array<Word64> = array![];
    k.append(Word64 { data: 0x428a2f98d728ae22 });
    k.append(Word64 { data: 0x7137449123ef65cd });
    k.append(Word64 { data: 0xb5c0fbcfec4d3b2f });
    k.append(Word64 { data: 0xe9b5dba58189dbbc });
    k.append(Word64 { data: 0x3956c25bf348b538 });
    k.append(Word64 { data: 0x59f111f1b605d019 });
    k.append(Word64 { data: 0x923f82a4af194f9b });
    k.append(Word64 { data: 0xab1c5ed5da6d8118 });
    k.append(Word64 { data: 0xd807aa98a3030242 });
    k.append(Word64 { data: 0x12835b0145706fbe });
    k.append(Word64 { data: 0x243185be4ee4b28c });
    k.append(Word64 { data: 0x550c7dc3d5ffb4e2 });
    k.append(Word64 { data: 0x72be5d74f27b896f });
    k.append(Word64 { data: 0x80deb1fe3b1696b1 });
    k.append(Word64 { data: 0x9bdc06a725c71235 });
    k.append(Word64 { data: 0xc19bf174cf692694 });
    k.append(Word64 { data: 0xe49b69c19ef14ad2 });
    k.append(Word64 { data: 0xefbe4786384f25e3 });
    k.append(Word64 { data: 0x0fc19dc68b8cd5b5 });
    k.append(Word64 { data: 0x240ca1cc77ac9c65 });
    k.append(Word64 { data: 0x2de92c6f592b0275 });
    k.append(Word64 { data: 0x4a7484aa6ea6e483 });
    k.append(Word64 { data: 0x5cb0a9dcbd41fbd4 });
    k.append(Word64 { data: 0x76f988da831153b5 });
    k.append(Word64 { data: 0x983e5152ee66dfab });
    k.append(Word64 { data: 0xa831c66d2db43210 });
    k.append(Word64 { data: 0xb00327c898fb213f });
    k.append(Word64 { data: 0xbf597fc7beef0ee4 });
    k.append(Word64 { data: 0xc6e00bf33da88fc2 });
    k.append(Word64 { data: 0xd5a79147930aa725 });
    k.append(Word64 { data: 0x06ca6351e003826f });
    k.append(Word64 { data: 0x142929670a0e6e70 });
    k.append(Word64 { data: 0x27b70a8546d22ffc });
    k.append(Word64 { data: 0x2e1b21385c26c926 });
    k.append(Word64 { data: 0x4d2c6dfc5ac42aed });
    k.append(Word64 { data: 0x53380d139d95b3df });
    k.append(Word64 { data: 0x650a73548baf63de });
    k.append(Word64 { data: 0x766a0abb3c77b2a8 });
    k.append(Word64 { data: 0x81c2c92e47edaee6 });
    k.append(Word64 { data: 0x92722c851482353b });
    k.append(Word64 { data: 0xa2bfe8a14cf10364 });
    k.append(Word64 { data: 0xa81a664bbc423001 });
    k.append(Word64 { data: 0xc24b8b70d0f89791 });
    k.append(Word64 { data: 0xc76c51a30654be30 });
    k.append(Word64 { data: 0xd192e819d6ef5218 });
    k.append(Word64 { data: 0xd69906245565a910 });
    k.append(Word64 { data: 0xf40e35855771202a });
    k.append(Word64 { data: 0x106aa07032bbd1b8 });
    k.append(Word64 { data: 0x19a4c116b8d2d0c8 });
    k.append(Word64 { data: 0x1e376c085141ab53 });
    k.append(Word64 { data: 0x2748774cdf8eeb99 });
    k.append(Word64 { data: 0x34b0bcb5e19b48a8 });
    k.append(Word64 { data: 0x391c0cb3c5c95a63 });
    k.append(Word64 { data: 0x4ed8aa4ae3418acb });
    k.append(Word64 { data: 0x5b9cca4f7763e373 });
    k.append(Word64 { data: 0x682e6ff3d6b2b8a3 });
    k.append(Word64 { data: 0x748f82ee5defb2fc });
    k.append(Word64 { data: 0x78a5636f43172f60 });
    k.append(Word64 { data: 0x84c87814a1f0ab72 });
    k.append(Word64 { data: 0x8cc702081a6439ec });
    k.append(Word64 { data: 0x90befffa23631e28 });
    k.append(Word64 { data: 0xa4506cebde82bde9 });
    k.append(Word64 { data: 0xbef9a3f7b2c67915 });
    k.append(Word64 { data: 0xc67178f2e372532b });
    k.append(Word64 { data: 0xca273eceea26619c });
    k.append(Word64 { data: 0xd186b8c721c0c207 });
    k.append(Word64 { data: 0xeada7dd6cde0eb1e });
    k.append(Word64 { data: 0xf57d4f7fee6ed178 });
    k.append(Word64 { data: 0x06f067aa72176fba });
    k.append(Word64 { data: 0x0a637dc5a2c898a6 });
    k.append(Word64 { data: 0x113f9804bef90dae });
    k.append(Word64 { data: 0x1b710b35131c471b });
    k.append(Word64 { data: 0x28db77f523047d84 });
    k.append(Word64 { data: 0x32caab7b40c72493 });
    k.append(Word64 { data: 0x3c9ebe0a15c9bebc });
    k.append(Word64 { data: 0x431d67c49c100d4c });
    k.append(Word64 { data: 0x4cc5d4becb3e42b6 });
    k.append(Word64 { data: 0x597f299cfc657e2a });
    k.append(Word64 { data: 0x5fcb6fab3ad6faec });
    k.append(Word64 { data: 0x6c44198c4a475817 });
    k
}
