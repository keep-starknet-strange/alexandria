use core::array::ArrayTrait;
use core::option::OptionTrait;
use alexandria_data_structures::array_ext::SpanTraitExt;
use alexandria_math::mod_arithmetics::{
    add_mod, sub_mod, mult_mod, div_mod, pow_mod, add_inverse_mod, equality_mod
};
use alexandria_math::sha512::{sha512, SHA512_LEN};
use core::integer::u512;
use core::traits::TryInto;
use alexandria_math::pow;

// As per RFC-8032: https://datatracker.ietf.org/doc/html/rfc8032#section-5.1.7
// Variable namings in this function refer to naming in the RFC

pub const p: u256 =
    57896044618658097711785492504343953926634992332820282019728792003956564819949; // 2^255 - 19
const d: u256 =
    37095705934669439343138083508754565189542113879843219016388785533085940283555; // d of Edwards255519, i.e. -121665/121666
const l: u256 =
    7237005577332262213973186563042994240857116359379907606001950938285454250989; // 2^252 + 27742317777372353535851937790883648493

const w: u256 = 4;

const TWO_POW_8_NON_ZERO: NonZero<u256> = 0x100;


#[derive(Drop, Copy)]
pub struct Point {
    x: u256,
    y: u256,
    prime: u256,
    prime_non_zero: NonZero<u256>
}

#[derive(Drop, Copy)]
pub struct ExtendedHomogeneousPoint {
    pub X: u256,
    pub Y: u256,
    pub Z: u256,
    pub T: u256,
    pub prime: u256,
    pub prime_non_zero: NonZero<u256>
}

pub trait PointDoubling<T> {
    fn double(self: T) -> T;
}
use core::traits::Div;

impl PointDoublingExtendedHomogeneousPoint of PointDoubling<ExtendedHomogeneousPoint> {
    fn double(self: ExtendedHomogeneousPoint) -> ExtendedHomogeneousPoint {
        let A: u256 = mult_mod(self.X, self.X, self.prime_non_zero);
        let B: u256 = mult_mod(self.Y, self.Y, self.prime_non_zero);
        let C: u256 = mult_mod(
            2, mult_mod(self.Z, self.Z, self.prime_non_zero), self.prime_non_zero
        );
        let D: u256 = add_inverse_mod(A, self.prime);
        let x_1_y_1 = add_mod(self.X, self.Y, self.prime);
        let x_1_squared: u256 = mult_mod(x_1_y_1, x_1_y_1, self.prime_non_zero);
        let E: u256 = sub_mod(sub_mod(x_1_squared, A, p), B, p);
        let G: u256 = add_mod(D, B, self.prime);
        let F: u256 = sub_mod(G, C, self.prime);
        let H: u256 = sub_mod(D, B, self.prime);
        ExtendedHomogeneousPoint {
            X: mult_mod(E, F, self.prime_non_zero),
            Y: mult_mod(G, H, self.prime_non_zero),
            T: mult_mod(E, H, self.prime_non_zero),
            Z: mult_mod(F, G, self.prime_non_zero),
            prime: self.prime,
            prime_non_zero: self.prime_non_zero
        }
    }
}

impl ExtendedHomogeneousPointAdd of Add<ExtendedHomogeneousPoint> {
    fn add(
        lhs: ExtendedHomogeneousPoint, rhs: ExtendedHomogeneousPoint
    ) -> ExtendedHomogeneousPoint {
        if (lhs.prime != rhs.prime) {
            panic!("not in the same field");
        }

        let A: u256 = mult_mod(
            sub_mod(lhs.Y, lhs.X, lhs.prime), sub_mod(rhs.Y, rhs.X, lhs.prime), lhs.prime_non_zero
        );
        let B: u256 = mult_mod(
            add_mod(lhs.Y, lhs.X, lhs.prime), add_mod(rhs.Y, rhs.X, lhs.prime), lhs.prime_non_zero
        );
        let C: u256 = mult_mod(
            mult_mod(mult_mod(lhs.T, 2, lhs.prime_non_zero), d, lhs.prime_non_zero),
            rhs.T,
            lhs.prime_non_zero
        );
        let D: u256 = mult_mod(mult_mod(lhs.Z, 2, lhs.prime_non_zero), rhs.Z, lhs.prime_non_zero);

        let E: u256 = sub_mod(B, A, lhs.prime);
        let F: u256 = sub_mod(D, C, lhs.prime);
        let G: u256 = add_mod(D, C, lhs.prime);
        let H: u256 = add_mod(B, A, lhs.prime);

        let X_3 = mult_mod(E, F, lhs.prime_non_zero);
        let Y_3 = mult_mod(G, H, lhs.prime_non_zero);
        let T_3 = mult_mod(E, H, lhs.prime_non_zero);
        let Z_3 = mult_mod(F, G, lhs.prime_non_zero);

        ExtendedHomogeneousPoint {
            X: X_3, Y: Y_3, T: T_3, Z: Z_3, prime: lhs.prime, prime_non_zero: lhs.prime_non_zero
        }
    }
}

impl PartialEqExtendedHomogeneousPoint of PartialEq<ExtendedHomogeneousPoint> {
    fn eq(lhs: @ExtendedHomogeneousPoint, rhs: @ExtendedHomogeneousPoint) -> bool {
        if (lhs.prime != rhs.prime) {
            panic!("not in the same field");
        }
        // lhs.X * rhs.Z - rhs.X * lhs.Z
        if (sub_mod(
            mult_mod(*lhs.X, *rhs.Z, *lhs.prime_non_zero),
            mult_mod(*rhs.X, *lhs.Z, *lhs.prime_non_zero),
            *lhs.prime
        ) != 0) {
            return false;
        }
        // lhs.Y * rhs.Z - rhs.Y * lhs.Z
        sub_mod(
            mult_mod(*lhs.Y, *rhs.Z, *lhs.prime_non_zero),
            mult_mod(*rhs.Y, *lhs.Z, *lhs.prime_non_zero),
            *lhs.prime
        ) == 0
    }
    fn ne(lhs: @ExtendedHomogeneousPoint, rhs: @ExtendedHomogeneousPoint) -> bool {
        if (lhs.prime != rhs.prime) {
            panic!("not in the same field");
        }
        !(lhs == rhs)
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

        let prime_non_zero: NonZero<u256> = p.try_into().unwrap();

        let y_2 = pow_mod(y, 2, prime_non_zero);
        let u: u256 = sub_mod(y_2, 1, p);
        let v: u256 = add_mod(mult_mod(d, y_2, prime_non_zero), 1, p);
        let v_pow_3 = pow_mod(v, 3, prime_non_zero);

        let v_pow_7: u256 = pow_mod(v, 7, prime_non_zero);

        let p_minus_5_div_8: u256 = div_mod(sub_mod(p, 5, p), 8, prime_non_zero);

        let u_times_v_power_3: u256 = mult_mod(u, v_pow_3, prime_non_zero);

        let x_candidate_root: u256 = mult_mod(
            u_times_v_power_3,
            pow_mod(mult_mod(u, v_pow_7, prime_non_zero), p_minus_5_div_8, prime_non_zero),
            prime_non_zero
        );

        let v_times_x_squared: u256 = mult_mod(
            v, pow_mod(x_candidate_root, 2, prime_non_zero), prime_non_zero
        );

        if (equality_mod(v_times_x_squared, u, p)) {
            x = x_candidate_root;
        } else if (equality_mod(v_times_x_squared, add_inverse_mod(u, p), p)) {
            let p_minus_one_over_4: u256 = div_mod(sub_mod(p, 1, p), 4, prime_non_zero);
            x =
                mult_mod(
                    x_candidate_root, pow_mod(2, p_minus_one_over_4, prime_non_zero), prime_non_zero
                );
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

        Option::Some(Point { x: x, y: y, prime: p, prime_non_zero: prime_non_zero })
    }
}

impl PointIntoExtendedHomogeneousPoint of Into<Point, ExtendedHomogeneousPoint> {
    fn into(self: Point) -> ExtendedHomogeneousPoint {
        let prime_non_zero = p.try_into().unwrap();
        ExtendedHomogeneousPoint {
            X: self.x,
            Y: self.y,
            Z: 1,
            T: mult_mod(self.x, self.y, prime_non_zero),
            prime: p,
            prime_non_zero: prime_non_zero
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
    mut scalar: u256, mut P: ExtendedHomogeneousPoint
) -> ExtendedHomogeneousPoint {
    let prime_non_zero = p.try_into().unwrap();
    let mut Q = ExtendedHomogeneousPoint {
        X: 0, Y: 1, Z: 1, T: 0, prime: p, prime_non_zero: prime_non_zero // neutral element
    };
    let zero_u512 = Default::default();

    // Double and add method
    while (scalar != zero_u512) {
        if ((scalar.low & 1) == 1) {
            Q = Q + P;
        }
        P = P.double();
        scalar = scalar / 2;
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
    let prime_non_zero = p.try_into().unwrap();
    // (X(P),Y(P)) of edwards25519 in https://datatracker.ietf.org/doc/html/rfc7748
    let B: ExtendedHomogeneousPoint = ExtendedHomogeneousPoint {
        X: 15112221349535400772501151409588531511454012693041857206046113283949847762202,
        Y: 46316835694926478169428394003475163141307993866256225615783033603165251855960,
        Z: 1,
        T: 46827403850823179245072216630277197565144205554125654976674165829533817101731,
        prime: p,
        prime_non_zero: prime_non_zero
    };

    // Check group equation [S]B = R + [k]A'
    let lhs: ExtendedHomogeneousPoint = point_mult_double_and_add(S, B);
    let kA: ExtendedHomogeneousPoint = point_mult_double_and_add(k, A_prime);
    let rhs: ExtendedHomogeneousPoint = R + kA;
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
