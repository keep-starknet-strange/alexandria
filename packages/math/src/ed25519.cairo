use alexandria_math::mod_arithmetics::{div_mod, mult_mod, pow_mod, sqr_mod};
use alexandria_math::sha512::{SHA512_LEN, sha512};
use alexandria_math::u512_arithmetics::u512_sub;
use core::integer::{u512, u512_safe_div_rem_by_u256};
use core::math::u256_inv_mod;
use core::num::traits::WideMul;

// Subtraction without modulo operation
// assumes a, b < modulo
// For result x: u256, 0 <= x < 2 * modulo
#[inline(always)]
fn sub_wo_mod(a: u256, b: u256, modulo: u256) -> u256 {
    a + modulo - b
}

#[inline(always)]
fn sub_wo_mod_u512(a: u512, b: u512, modulo: u256) -> u512 {
    u512_sub(
        if b.limb3 < a.limb3 {
            // If highest limb of b is smaller than a, a - b is safe
            a
        } else {
            // If highest limb of b is NOT smaller than a, a - b overflows,
            // Add p to high limbs of a to avoid overflow
            let u512 { limb0, limb1, limb2: low, limb3: high } = a;
            let u256 { low: limb2, high: limb3 } = u256 { low, high } + modulo;
            u512 { limb0, limb1, limb2, limb3 }
        },
        b,
    )
}

// As per RFC-8032: https://datatracker.ietf.org/doc/html/rfc8032#section-5.1.7
// Variable namings in this function refer to naming in the RFC

// p = 2^255 - 19
pub const p: u256 = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed;
pub const p_non_zero: NonZero<u256> =
    0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed;
// p2x = 2p = (2^255 - 19) * 2
pub const p2x: u256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffda;
// a = -1
pub const a: u256 = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec;
pub const c: u256 = 3;
// d of Edwards255519, i.e. -121665/121666
pub const d: u256 = 0x52036cee2b6ffe738cc740797779e89800700a4d4141d8ab75eb4dca135978a3;
// d2x = 2d = -121665/121666 * 2
pub const d2x: u256 = 0xa406d9dc56dffce7198e80f2eef3d13000e0149a8283b156ebd69b9426b2f146;
// l = 2^252 + 27742317777372353535851937790883648493
pub const l: u256 = 0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed;
pub const w: u256 = 4;

const TWO_POW_8_NON_ZERO: NonZero<u256> = 0x100;


#[derive(Drop, Copy)]
pub struct Point {
    pub x: u256,
    pub y: u256,
}

pub trait PointOperations<T> {
    fn double(self: T, prime_nz: NonZero<u256>) -> T;
    fn add(self: T, rhs: T, prime_nz: NonZero<u256>) -> T;
}

impl PointDoublingPoint of PointOperations<Point> {
    // Implements Equation 2, https://eprint.iacr.org/2008/522.pdf
    fn double(self: Point, prime_nz: NonZero<u256>) -> Point {
        let Point { x, y } = self;

        let xy = mult_mod(x, y, prime_nz);
        let x2 = sqr_mod(x, prime_nz);
        let y2 = sqr_mod(y, prime_nz);

        // ax^2 + y^2, a is -1
        let ax2_y2 = sub_wo_mod(y2, x2, p);

        // 1 / (ax^2 + y^2)
        // co-prime inputs, safe to unwrap
        let ax2_y2_inv: u256 = u256_inv_mod(ax2_y2, prime_nz).unwrap().into();

        // 1 / (2 - (ax^2 + y^2))
        // co-prime inputs, safe to unwrap
        let two_sub_ax2_y2_inv: u256 = u256_inv_mod(2 + p2x - ax2_y2, prime_nz).unwrap().into();

        // x3 = (2xy) / (ax^2 + y^2)
        let x = mult_mod((xy + xy), ax2_y2_inv, prime_nz);

        // y3 = (x^2 + y^2) / (2 - ax^2 - y^2)
        let y = mult_mod((x2 + y2), two_sub_ax2_y2_inv, prime_nz);

        Point { x, y }
    }

    // Implements Equation 3, https://eprint.iacr.org/2008/522.pdf
    fn add(self: Point, rhs: Point, prime_nz: NonZero<u256>) -> Point {
        let Point { x: x1, y: y1 } = self;
        let Point { x: x2, y: y2 } = rhs;

        let x1y1 = mult_mod(x1, y1, prime_nz);
        let x2y2 = mult_mod(x2, y2, prime_nz);
        let y1y2_512 = WideMul::wide_mul(y1, y2);
        let x1x2_512 = WideMul::wide_mul(x1, x2);
        let x1y2_512 = WideMul::wide_mul(x1, y2);
        let y1x2_512 = WideMul::wide_mul(y1, x2);

        // y1y2 + ax1x2 = y1y2 - x1x2, a  = -1
        let (_, y1y2_ax1x2) = u512_safe_div_rem_by_u256(
            sub_wo_mod_u512(y1y2_512, x1x2_512, p), prime_nz,
        );

        // 1 / (y1y2 + ax1x2)
        // co-prime inputs, safe to unwrap
        let y1y2_ax1x2_inv = u256_inv_mod(y1y2_ax1x2, prime_nz).unwrap().into();

        // x1y2 − y1x2
        let (_, x1y2_sub_y1x2) = u512_safe_div_rem_by_u256(
            sub_wo_mod_u512(x1y2_512, y1x2_512, p), prime_nz,
        );

        // 1 / (x1y2 − y1x2)
        // co-prime inputs, safe to unwrap
        let x1y2_sub_y1x2_inv = u256_inv_mod(x1y2_sub_y1x2, prime_nz).unwrap().into();

        // x = (x1y1 + x2y2) / (y1y2 + ax1x2)
        let x = mult_mod(x1y1 + x2y2, y1y2_ax1x2_inv, prime_nz);

        // y = (x1y1 − x2y2) / (x1y2 − y1x2)
        let y = mult_mod(sub_wo_mod(x1y1, x2y2, p), x1y2_sub_y1x2_inv, prime_nz);

        Point { x, y }
    }
}

impl PartialEqPoint of PartialEq<Point> {
    fn eq(lhs: @Point, rhs: @Point) -> bool {
        *lhs.x == *rhs.x && *lhs.y == *rhs.y
    }
    fn ne(lhs: @Point, rhs: @Point) -> bool {
        lhs != rhs
    }
}

impl SpanU8IntoU256 of Into<Span<u8>, u256> {
    /// Decode as little endian
    fn into(self: Span<u8>) -> u256 {
        if (self.len() > 32) {
            return 0;
        }
        let mut ret: u256 = 0;
        let two_pow_0 = 1;
        let two_pow_1 = 256;
        let two_pow_2 = 65536;
        let two_pow_3 = 16777216;
        let two_pow_4 = 4294967296;
        let two_pow_5 = 1099511627776;
        let two_pow_6 = 281474976710656;
        let two_pow_7 = 72057594037927936;
        let two_pow_8 = 18446744073709551616;
        let two_pow_9 = 4722366482869645213696;
        let two_pow_10 = 1208925819614629174706176;
        let two_pow_11 = 309485009821345068724781056;
        let two_pow_12 = 79228162514264337593543950336;
        let two_pow_13 = 20282409603651670423947251286016;
        let two_pow_14 = 5192296858534827628530496329220096;
        let two_pow_15 = 1329227995784915872903807060280344576;
        ret.low += (*self[0]).into() * two_pow_0;
        ret.low += (*self[1]).into() * two_pow_1;
        ret.low += (*self[2]).into() * two_pow_2;
        ret.low += (*self[3]).into() * two_pow_3;
        ret.low += (*self[4]).into() * two_pow_4;
        ret.low += (*self[5]).into() * two_pow_5;
        ret.low += (*self[6]).into() * two_pow_6;
        ret.low += (*self[7]).into() * two_pow_7;
        ret.low += (*self[8]).into() * two_pow_8;
        ret.low += (*self[9]).into() * two_pow_9;
        ret.low += (*self[10]).into() * two_pow_10;
        ret.low += (*self[11]).into() * two_pow_11;
        ret.low += (*self[12]).into() * two_pow_12;
        ret.low += (*self[13]).into() * two_pow_13;
        ret.low += (*self[14]).into() * two_pow_14;
        ret.low += (*self[15]).into() * two_pow_15;

        ret.high += (*self[16]).into() * two_pow_0;
        ret.high += (*self[17]).into() * two_pow_1;
        ret.high += (*self[18]).into() * two_pow_2;
        ret.high += (*self[19]).into() * two_pow_3;
        ret.high += (*self[20]).into() * two_pow_4;
        ret.high += (*self[21]).into() * two_pow_5;
        ret.high += (*self[22]).into() * two_pow_6;
        ret.high += (*self[23]).into() * two_pow_7;
        ret.high += (*self[24]).into() * two_pow_8;
        ret.high += (*self[25]).into() * two_pow_9;
        ret.high += (*self[26]).into() * two_pow_10;
        ret.high += (*self[27]).into() * two_pow_11;
        ret.high += (*self[28]).into() * two_pow_12;
        ret.high += (*self[29]).into() * two_pow_13;
        ret.high += (*self[30]).into() * two_pow_14;
        ret.high += (*self[31]).into() * two_pow_15;
        ret
    }
}

impl U256IntoSpanU8 of Into<u256, Span<u8>> {
    fn into(self: u256) -> Span<u8> {
        let mut ret = array![];
        let mut remaining_value = self;

        let mut i: u8 = 0;
        while (i < 32) {
            let (temp_remaining, byte) = DivRem::div_rem(remaining_value, TWO_POW_8_NON_ZERO);
            ret.append(byte.try_into().unwrap());
            remaining_value = temp_remaining;
            i += 1;
        }

        ret.span()
    }
}

impl SpanU8IntoU512 of Into<Span<u8>, u512> {
    fn into(self: Span<u8>) -> u512 {
        let half_1 = self.slice(0, SHA512_LEN / 2);
        let half_2 = self.slice(32, SHA512_LEN / 2);
        let low: u256 = half_1.into();
        let high: u256 = half_2.into();

        u512 { limb0: low.low, limb1: low.high, limb2: high.low, limb3: high.high }
    }
}

impl U256TryIntoPoint of TryInto<u256, Point> {
    fn try_into(self: u256) -> Option<Point> {
        let mut x = 0;
        let mut y_span: Span<u8> = self.into();
        let mut y_le_span: Span<u8> = reverse(y_span);

        let last_byte = *y_le_span[31];

        let _ = y_le_span.pop_back();
        let mut normed_array: Array<u8> = dedup(y_le_span);
        normed_array.append(last_byte & ~0x80);

        let x_0: u256 = (last_byte.into() / 128) & 1; // bitshift of 255

        let y: u256 = normed_array.span().into();
        if (y >= p) {
            return Option::None;
        }

        let prime_nz = p_non_zero;

        let y_2 = sqr_mod(y, prime_nz);
        let u: u256 = y_2 - 1;
        let v: u256 = mult_mod(d, y_2, prime_nz) + 1;

        // v^7 = v^2 * v
        let v_pow_3 = mult_mod(v, sqr_mod(v, prime_nz), prime_nz);

        // v^7 = v^3^2 * v
        let v_pow_7: u256 = mult_mod(v, sqr_mod(v_pow_3, prime_nz), prime_nz);

        let p_minus_5_div_8: u256 = div_mod(p - 5, 8, prime_nz);

        let u_times_v_power_3: u256 = mult_mod(u, v_pow_3, prime_nz);

        let x_candidate_root: u256 = mult_mod(
            u_times_v_power_3,
            pow_mod(mult_mod(u, v_pow_7, prime_nz), p_minus_5_div_8, prime_nz),
            prime_nz,
        );

        let v_times_x_squared: u256 = mult_mod(v, sqr_mod(x_candidate_root, prime_nz), prime_nz);

        if (v_times_x_squared == u) {
            x = x_candidate_root;
        } else if (v_times_x_squared == p - u) {
            let p_minus_one_over_4: u256 = div_mod(p - 1, 4, prime_nz);
            x = mult_mod(x_candidate_root, pow_mod(2, p_minus_one_over_4, prime_nz), prime_nz);
        } else {
            return Option::None;
        }

        if (x == 0) {
            if (x_0 == 1) {
                return Option::None;
            }
        }
        if (x_0 != x % 2) {
            x = p - x;
        }

        Option::Some(Point { x: x, y: y })
    }
}

/// Function that performs point multiplication for an Elliptic Curve point using the double and add
/// method.
/// # Arguments
/// * `scalar` - Scalar such that scalar * P = P + P + P + ... + P.
/// * `P` - Elliptic Curve point
/// * `prime_nz` - Field prime in NonZero form.
/// # Returns
/// * `u256` - Resulting point
pub fn point_mult_double_and_add(mut scalar: u256, mut P: Point, prime_nz: NonZero<u256>) -> Point {
    let mut Q = Point { x: 0, y: 1 }; // neutral element
    let zero = 0;

    // Double and add method
    while (scalar != zero) {
        let (q, r) = DivRem::div_rem(scalar, 2);
        if r == 1 {
            Q = Q.add(P, prime_nz);
        }
        P = P.double(prime_nz);
        scalar = q;
    }
    Q
}

/// Function that checks the equality [S]B = R + [k]A'
/// # Arguments
/// * `S` - Scalar coming from the second half of the signature.
/// * `R` - Result of point decoding of the first half of the signature
/// * `k` - SHA512(dom2(F, C) || R || A || PH(M)) interpreted as a scalar
/// * `A_prime` - Result of point decoding of the public key
/// # Returns
/// * `bool` - true if the signature fits to the message and the public key, false otherwise.
fn check_group_equation(S: u256, R: Point, k: u256, A_prime: Point) -> bool {
    // (X(P),Y(P)) of edwards25519 in https://datatracker.ietf.org/doc/html/rfc7748
    let B: Point = Point {
        x: 15112221349535400772501151409588531511454012693041857206046113283949847762202,
        y: 46316835694926478169428394003475163141307993866256225615783033603165251855960,
    };

    let prime_nz = p_non_zero;

    // Check group equation [S]B = R + [k]A'
    let lhs: Point = point_mult_double_and_add(S, B, prime_nz);
    let kA: Point = point_mult_double_and_add(k, A_prime, prime_nz);
    let rhs: Point = R.add(kA, prime_nz);
    lhs == rhs
}

pub fn verify_signature(msg: Span<u8>, signature: Span<u256>, pub_key: u256) -> bool {
    if (signature.len() != 2) {
        return false;
    }

    let r: u256 = *signature[0];
    let r_point: Option<Point> = r.try_into();
    if (r_point.is_none()) {
        return false;
    }

    let s: u256 = *signature[1];
    let s_span: Span<u8> = s.into();
    let reversed_s_span = reverse(s_span);
    let s: u256 = reversed_s_span.into();
    if (s >= l) {
        return false;
    }

    let A_prime_opt: Option<Point> = pub_key.try_into();
    if (A_prime_opt.is_none()) {
        return false;
    }

    let R: Point = r_point.unwrap();
    let A_prime: Point = A_prime_opt.unwrap();

    let r_bytes: Span<u8> = r.into();
    let r_bytes = reverse(r_bytes);
    let pub_key_bytes: Span<u8> = pub_key.into();
    let pub_key_bytes = reverse(pub_key_bytes);

    let mut hashable = array![];
    hashable.append_span(r_bytes);
    hashable.append_span(pub_key_bytes);
    hashable.append_span(msg);

    // k = SHA512(dom2(F, C) -> empty string || R -> half of sig || A -> pub_key || PH(M) ->
    // identity function for msg)
    let k: Array<u8> = sha512(hashable);
    let k_u512: u512 = k.span().into();

    let l_non_zero: NonZero<u256> = l.try_into().unwrap();
    let (_, k_reduced) = core::integer::u512_safe_div_rem_by_u256(k_u512, l_non_zero);

    check_group_equation(s, R, k_reduced, A_prime)
}

// reverse and dedup are helper functions copy-pasted here from
// the data_structures SpanTraitExt implementation to prevent
// dependency of the math package on the data_structures package
// and all its heavy dependencies

fn reverse(mut span: Span<u8>) -> Span<u8> {
    let mut res = array![];
    while let Option::Some(v) = span.pop_back() {
        res.append(v.clone());
    }
    res.span()
}

fn dedup(mut span: Span<u8>) -> Array<u8> {
    let mut last_value = span.pop_front().unwrap();
    let mut ret = array![last_value.clone()];

    for v in span {
        if (last_value != v) {
            last_value = v;
            ret.append(v.clone());
        }
    }

    ret
}
