use alexandria_data_structures::array_ext::SpanTraitExt;
use alexandria_math::mod_arithmetics::{
    add_mod, sub_mod, mult_mod, div_mod, pow_mod, add_inverse_mod, equality_mod
};
use alexandria_math::pow;
use alexandria_math::sha512::{sha512, SHA512_LEN};
use core::array::ArrayTrait;
use core::integer::{u512, u512_safe_div_rem_by_u256, u256_wide_mul};
use core::option::OptionTrait;
use core::traits::Div;
use core::traits::TryInto;

// As per RFC-8032: https://datatracker.ietf.org/doc/html/rfc8032#section-5.1.7
// Variable namings in this function refer to naming in the RFC

fn sub_wo_mod(mut a: u256, mut b: u256, modulo: u256) -> u256 {
    a + p - b
}

pub const p: u256 =
    57896044618658097711785492504343953926634992332820282019728792003956564819949; // 2^255 - 19
const a: u256 =
    57896044618658097711785492504343953926634992332820282019728792003956564819948; // - 1
const c: u256 = 3;
const d: u256 =
    37095705934669439343138083508754565189542113879843219016388785533085940283555; // d of Edwards255519, i.e. -121665/121666
const l: u256 =
    7237005577332262213973186563042994240857116359379907606001950938285454250989; // 2^252 + 27742317777372353535851937790883648493

const prime: u256 = 57896044618658097711785492504343953926634992332820282019728792003956564819949;
const prime_non_zero: NonZero<u256> =
    57896044618658097711785492504343953926634992332820282019728792003956564819949;
const w: u256 = 4;

const TWO_POW_8_NON_ZERO: NonZero<u256> = 0x100;


#[derive(Drop, Copy)]
pub struct Point {
    x: u256,
    y: u256,
}

#[derive(Drop, Copy)]
pub struct ExtendedHomogeneousPoint {
    pub X: u256,
    pub Y: u256,
    pub Z: u256,
    pub T: u256,
}

pub trait PointOperations<T> {
    fn double(self: T, prime_nz: NonZero<u256>) -> T;
    fn add(self: T, rhs: T, prime_nz: NonZero<u256>) -> T;
}

impl PointDoublingExtendedHomogeneousPoint of PointOperations<ExtendedHomogeneousPoint> {
    fn double(self: ExtendedHomogeneousPoint, prime_nz: NonZero<u256>) -> ExtendedHomogeneousPoint {
        let A: u256 = mult_mod(self.X, self.X, prime_nz);
        let B: u256 = mult_mod(self.Y, self.Y, prime_nz);
        let C: u256 = mult_mod(2, mult_mod(self.Z, self.Z, prime_nz), prime_nz);
        let D: u256 = add_inverse_mod(A, prime);
        let x_1_y_1 = add_mod(self.X, self.Y, prime);
        let x_1_squared: u256 = mult_mod(x_1_y_1, x_1_y_1, prime_nz);
        let E: u256 = sub_mod(sub_mod(x_1_squared, A, p), B, p);
        let G: u256 = add_mod(D, B, prime);
        let F: u256 = sub_mod(G, C, prime);
        let H: u256 = sub_mod(D, B, prime);
        ExtendedHomogeneousPoint {
            X: mult_mod(E, F, prime_nz),
            Y: mult_mod(G, H, prime_nz),
            T: mult_mod(E, H, prime_nz),
            Z: mult_mod(F, G, prime_nz),
        }
    }

    fn add(
        self: ExtendedHomogeneousPoint, rhs: ExtendedHomogeneousPoint, prime_nz: NonZero<u256>
    ) -> ExtendedHomogeneousPoint {
        let lhs = self;
        let A: u256 = mult_mod(
            sub_mod(lhs.Y, lhs.X, prime), sub_mod(rhs.Y, rhs.X, prime), prime_nz
        );
        let B: u256 = mult_mod(
            add_mod(lhs.Y, lhs.X, prime), add_mod(rhs.Y, rhs.X, prime), prime_nz
        );
        let C: u256 = mult_mod(
            mult_mod(mult_mod(lhs.T, 2, prime_nz), d, prime_nz), rhs.T, prime_nz
        );
        let D: u256 = mult_mod(mult_mod(lhs.Z, 2, prime_nz), rhs.Z, prime_nz);

        let E: u256 = sub_mod(B, A, prime);
        let F: u256 = sub_mod(D, C, prime);
        let G: u256 = add_mod(D, C, prime);
        let H: u256 = add_mod(B, A, prime);

        let X_3 = mult_mod(E, F, prime_nz);
        let Y_3 = mult_mod(G, H, prime_nz);
        let T_3 = mult_mod(E, H, prime_nz);
        let Z_3 = mult_mod(F, G, prime_nz);

        ExtendedHomogeneousPoint { X: X_3, Y: Y_3, T: T_3, Z: Z_3, }
    }
}

impl PartialEqExtendedHomogeneousPoint of PartialEq<ExtendedHomogeneousPoint> {
    fn eq(lhs: @ExtendedHomogeneousPoint, rhs: @ExtendedHomogeneousPoint) -> bool {
        let prime_nz = prime_non_zero;
        // lhs.X * rhs.Z == rhs.X * lhs.Z
        mult_mod(*lhs.X, *rhs.Z, prime_nz) == mult_mod(*rhs.X, *lhs.Z, prime_nz)
            && // lhs.Y * rhs.Z == rhs.Y * lhs.Z
            mult_mod(*lhs.Y, *rhs.Z, prime_nz) == mult_mod(*rhs.Y, *lhs.Z, prime_nz)
    }
    fn ne(lhs: @ExtendedHomogeneousPoint, rhs: @ExtendedHomogeneousPoint) -> bool {
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
        };

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
        let mut y_le_span: Span<u8> = y_span.reverse().span();

        let last_byte = *y_le_span[31];

        let _ = y_le_span.pop_back();
        let mut normed_array: Array<u8> = y_le_span.dedup();
        normed_array.append(last_byte & ~0x80);

        let x_0: u256 = (last_byte.into() / 128) & 1; // bitshift of 255

        let y: u256 = normed_array.span().into();
        if (y >= p) {
            return Option::None;
        }

        let prime_nz = prime_non_zero;

        let y_2 = pow_mod(y, 2, prime_nz);
        let u: u256 = sub_mod(y_2, 1, p);
        let v: u256 = add_mod(mult_mod(d, y_2, prime_nz), 1, p);
        let v_pow_3 = pow_mod(v, 3, prime_nz);

        let v_pow_7: u256 = pow_mod(v, 7, prime_nz);

        let p_minus_5_div_8: u256 = div_mod(sub_mod(p, 5, p), 8, prime_nz);

        let u_times_v_power_3: u256 = mult_mod(u, v_pow_3, prime_nz);

        let x_candidate_root: u256 = mult_mod(
            u_times_v_power_3,
            pow_mod(mult_mod(u, v_pow_7, prime_nz), p_minus_5_div_8, prime_nz),
            prime_nz
        );

        let v_times_x_squared: u256 = mult_mod(v, pow_mod(x_candidate_root, 2, prime_nz), prime_nz);

        if (equality_mod(v_times_x_squared, u, p)) {
            x = x_candidate_root;
        } else if (equality_mod(v_times_x_squared, add_inverse_mod(u, p), p)) {
            let p_minus_one_over_4: u256 = div_mod(sub_mod(p, 1, p), 4, prime_nz);
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

        Option::Some(Point { x: x, y: y, })
    }
}

impl PointIntoExtendedHomogeneousPoint of Into<Point, ExtendedHomogeneousPoint> {
    fn into(self: Point) -> ExtendedHomogeneousPoint {
        ExtendedHomogeneousPoint {
            X: self.x, Y: self.y, Z: 1, T: mult_mod(self.x, self.y, prime_non_zero),
        }
    }
}

/// Function that performs point multiplication for an Elliptic Curve point using the double and add method.
/// # Arguments
/// * `scalar` - Scalar such that scalar * P = P + P + P + ... + P.
/// * `P` - Elliptic Curve point in the Extended Homogeneous form.
/// # Returns
/// * `u256` - Resulting point in the Extended Homogeneous form.
pub fn point_mult_double_and_add(
    mut scalar: u256, mut P: ExtendedHomogeneousPoint, prime_nz: NonZero<u256>
) -> ExtendedHomogeneousPoint {
    let mut Q = ExtendedHomogeneousPoint { X: 0, Y: 1, Z: 1, T: 0, // neutral element
     };
    let zero = 0;

    // Double and add method
    while (scalar != zero) {
        let (q, r) = DivRem::div_rem(scalar, 2);
        if r == 1 {
            Q = Q.add(P, prime_nz);
        }
        P = P.double(prime_nz);
        scalar = q;
    };
    Q
}

/// Function that checks the equality [S]B = R + [k]A'
/// # Arguments
/// * `S` - Scalar coming from the second half of the signature.
/// * `R` - Result of point decoding of the first half of the signature in Extended Homogeneous form.
/// * `k` - SHA512(dom2(F, C) || R || A || PH(M)) interpreted as a scalar.
/// * `A_prime` - Result of point decoding of the public key in Extended Homogeneous form.
/// # Returns
/// * `bool` - true if the signature fits to the message and the public key, false otherwise.
fn check_group_equation(
    S: u256, R: ExtendedHomogeneousPoint, k: u256, A_prime: ExtendedHomogeneousPoint
) -> bool {
    // (X(P),Y(P)) of edwards25519 in https://datatracker.ietf.org/doc/html/rfc7748
    let B: ExtendedHomogeneousPoint = ExtendedHomogeneousPoint {
        X: 15112221349535400772501151409588531511454012693041857206046113283949847762202,
        Y: 46316835694926478169428394003475163141307993866256225615783033603165251855960,
        Z: 1,
        T: 46827403850823179245072216630277197565144205554125654976674165829533817101731,
    };

    let prime_nz = prime_non_zero;

    // Check group equation [S]B = R + [k]A'
    let lhs: ExtendedHomogeneousPoint = point_mult_double_and_add(S, B, prime_nz);
    let kA: ExtendedHomogeneousPoint = point_mult_double_and_add(k, A_prime, prime_nz);
    let rhs: ExtendedHomogeneousPoint = R.add(kA, prime_nz);
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
    let reversed_s_span = s_span.reverse();
    let s: u256 = reversed_s_span.span().into();
    if (s >= l) {
        return false;
    }

    let A_prime_opt: Option<Point> = pub_key.try_into();
    if (A_prime_opt.is_none()) {
        return false;
    }

    let R: Point = r_point.unwrap();
    let A_prime: Point = A_prime_opt.unwrap();

    let R_extended: ExtendedHomogeneousPoint = R.into();
    let A_prime_ex: ExtendedHomogeneousPoint = A_prime.into();

    let r_bytes: Span<u8> = r.into();
    let r_bytes = r_bytes.reverse().span();
    let pub_key_bytes: Span<u8> = pub_key.into();
    let pub_key_bytes = pub_key_bytes.reverse().span();

    let hashable = r_bytes.concat(pub_key_bytes).span().concat(msg);
    // k = SHA512(dom2(F, C) -> empty string || R -> half of sig || A -> pub_key || PH(M) -> identity function for msg)
    let k: Array<u8> = sha512(hashable);
    let k_u512: u512 = k.span().into();

    let l_non_zero: NonZero<u256> = l.try_into().unwrap();
    let (_, k_reduced) = core::integer::u512_safe_div_rem_by_u256(k_u512, l_non_zero);

    check_group_equation(s, R_extended, k_reduced, A_prime_ex)
}
