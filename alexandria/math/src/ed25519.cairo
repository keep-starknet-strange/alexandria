use array::{ArrayTrait, SpanTrait};
use traits::{Into, TryInto};
use option::OptionTrait;
use integer::u512;
use alexandria_math::sha512::{sha512, SHA512_LEN};
use alexandria_math::mod_arithmetics::{
    add_mod, sub_mod, mult_mod, div_mod, pow_mod, add_inverse_mod
};
use alexandria_data_structures::array_ext::{ArrayTraitExt};

// As per RFC-8032: https://datatracker.ietf.org/doc/html/rfc8032#section-5.1.7
// Variable namings in this function refer to naming in the RFC

const p: u256 =
    57896044618658097711785492504343953926634992332820282019728792003956564819949; // 2^255 - 19
const d: u256 =
    37095705934669439343138083508754565189542113879843219016388785533085940283555; // d of Edwards255519, i.e. -121665/121666 
const l: u256 =
    7237005577332262213973186563042994240857116359379907606001950938285454250989; // 2^252 + 27742317777372353535851937790883648493


const PUB_KEY_LEN: usize = 32;

const SIG_LEN: usize = 64;

#[derive(Drop, Copy)]
struct Point {
    x: u256,
    y: u256
}

#[derive(Drop, Copy)]
struct ExtendedHomogeneousPoint {
    X: u256,
    Y: u256,
    Z: u256,
    T: u256,
}

trait PointDoubling<T> {
    fn double(self: T) -> T;
}

impl PointDoublingExtendedHomogeneousPoint of PointDoubling<ExtendedHomogeneousPoint> {
    fn double(self: ExtendedHomogeneousPoint) -> ExtendedHomogeneousPoint {
        let A: u256 = mult_mod(self.X, self.X, p);
        let B: u256 = mult_mod(self.Y, self.Y, p);
        let C: u256 = mult_mod(2, mult_mod(self.Z, self.Z, p), p);
        let H: u256 = A + B;
        let E: u256 = sub_mod(H, pow_mod(add_mod(self.X, self.Y, p), 2, p), p);
        let G: u256 = sub_mod(A, B, p);
        let F: u256 = add_mod(C, G, p);
        ExtendedHomogeneousPoint {
            X: mult_mod(E, F, p), Y: mult_mod(G, H, p), T: mult_mod(E, H, p), Z: mult_mod(F, G, p)
        }
    }
}

impl ExtendedHomogeneousPointAdd of Add<ExtendedHomogeneousPoint> {
    fn add(
        lhs: ExtendedHomogeneousPoint, rhs: ExtendedHomogeneousPoint
    ) -> ExtendedHomogeneousPoint {
        let A: u256 = mult_mod(sub_mod(lhs.Y, lhs.X, p), sub_mod(rhs.Y, rhs.X, p), p);
        let B: u256 = mult_mod(add_mod(lhs.Y, lhs.X, p), add_mod(rhs.Y, rhs.X, p), p);
        let C: u256 = mult_mod(mult_mod(mult_mod(lhs.T, 2, p), d, p), rhs.T, p);
        let D: u256 = mult_mod(mult_mod(lhs.Z, 2, p), rhs.Z, p);
        let E: u256 = sub_mod(B, A, p);
        let F: u256 = sub_mod(D, C, p);
        let G: u256 = add_mod(D, C, p);
        let H: u256 = add_mod(B, A, p);

        let X_3 = mult_mod(E, F, p);
        let Y_3 = mult_mod(G, H, p);
        let T_3 = mult_mod(E, H, p);
        let Z_3 = mult_mod(F, G, p);

        ExtendedHomogeneousPoint { X: X_3, Y: Y_3, T: T_3, Z: Z_3 }
    }
}

impl PartialEqExtendedHomogeneousPoint of PartialEq<ExtendedHomogeneousPoint> {
    fn eq(lhs: @ExtendedHomogeneousPoint, rhs: @ExtendedHomogeneousPoint) -> bool {
        // lhs.X * rhs.Z - rhs.X * lhs.Z
        if (sub_mod(mult_mod(*lhs.X, *rhs.Z, p), mult_mod(*rhs.X, *lhs.Z, p), p) != 0) {
            return false;
        }
        // lhs.Y * rhs.Z - rhs.Y * lhs.Z
        if (sub_mod(mult_mod(*lhs.Y, *rhs.Z, p), mult_mod(*rhs.Y, *lhs.Z, p), p) != 0) {
            return false;
        }
        return true;
    }
    fn ne(lhs: @ExtendedHomogeneousPoint, rhs: @ExtendedHomogeneousPoint) -> bool {
        !(lhs == rhs)
    }
}

impl SpanU8IntoU256 of Into<Span<u8>, u256> {
    fn into(self: Span<u8>) -> u256 {
        if (self.len() > 32) {
            return 0;
        }
        let mut ret: u256 = 0;
        let mut i = 0;
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

impl SpanU8IntoU512 of Into<Span<u8>, u512> {
    fn into(self: Span<u8>) -> u512 {
        let half_1 = self.slice(0, SHA512_LEN / 2);
        let half_2 = self.slice(32, SHA512_LEN / 2);
        let low: u256 = half_1.into();
        let high: u256 = half_2.into();

        u512 { limb0: low.low, limb1: low.high, limb2: high.low, limb3: high.high }
    }
}

impl SpanU8TryIntoPoint of TryInto<Span<u8>, Point> {
    fn try_into(mut self: Span<u8>) -> Option<Point> {
        let mut x = 0;

        let mut y: u256 = self.into();
        if (y >= p) {
            return Option::None(());
        }
        // bitshit of 255
        let bitshift_255: u256 =
            57896044618658097711785492504343953926634992332820282019728792003956564819968;
        let x_0: u256 = y / bitshift_255; // bitshift of 255 

        y = (y & bitshift_255 - 1);

        let y_2 = pow_mod(y, 2, p);
        let u: u256 = sub_mod(y_2, 1, p);
        let v: u256 = add_mod(mult_mod(d, y_2, p), 1, p);
        let v_pow_3 = pow_mod(v, 3, p);
        let v_pow_4 = pow_mod(v, 4, p);
        let v_pow7: u256 = mult_mod(v_pow_3, v_pow_4, p);
        let p_minus_5_div_8: u256 = div_mod(p - 5, 8, p);
        let u_times_v_power_3: u256 = mult_mod(u, v_pow_3, p);

        let x_candidate_root: u256 = mult_mod(
            u_times_v_power_3, pow_mod(mult_mod(u, v_pow7, p), p_minus_5_div_8, p), p
        );
        let x_times_v_squared: u256 = mult_mod(v, pow_mod(x_candidate_root, 2, p), p);
        if (x_times_v_squared == u) {
            x = x_candidate_root;
        } else if (x_times_v_squared == add_inverse_mod(u, p)) {
            let p_minus_one_over_4: u256 = div_mod(sub_mod(p, 1, p), 4, p);
            x = mult_mod(x_candidate_root, pow_mod(2, p_minus_one_over_4, p), p);
        } else {
            return Option::None(());
        }

        if (x == 0) {
            if (x_0 == 1) {
                return Option::None(());
            }
        }
        if (x_0 != x % 2) {
            x = p - x;
        }

        Option::Some(Point { x: x, y: y })
    }
}

impl PointIntoExtendedHomogeneousPoint of Into<Point, ExtendedHomogeneousPoint> {
    fn into(self: Point) -> ExtendedHomogeneousPoint {
        ExtendedHomogeneousPoint { X: self.x, Y: self.y, Z: 1, T: mult_mod(self.x, self.y, p) }
    }
}

/// Function that performs point multiplication for an Elliptic Curve point using the double and add method.
/// # Arguments
/// * `scalar` - Scalar such that scalar * P = P + P + P + ... + P.
/// * `P` - Elliptic Curve point in the Extended Homogeneous form.
/// # Returns
/// * `u256` - Resulting point in the Extended Homogeneous form.
fn point_mult(mut scalar: u256, mut P: ExtendedHomogeneousPoint) -> ExtendedHomogeneousPoint {
    let mut Q = ExtendedHomogeneousPoint { X: 0, Y: 1, Z: 1, T: 0 };
    let zero_u512 = Default::default();
    let one_u512 = u512 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 };
    let two_non_zero: NonZero<u256> = integer::u256_try_as_non_zero(2).unwrap();

    // Double and add method
    loop {
        if (scalar == zero_u512) {
            break ();
        }
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
    S: u256, R: ExtendedHomogeneousPoint, k: u256, mut A_prime: ExtendedHomogeneousPoint
) -> bool {
    // (X(P),Y(P)) of edwards25519 in https://datatracker.ietf.org/doc/html/rfc7748
    let B: Point = Point {
        x: 15112221349535400772501151409588531511454012693041857206046113283949847762202,
        y: 46316835694926478169428394003475163141307993866256225615783033603165251855960
    };

    let B_extended: ExtendedHomogeneousPoint = B.into();

    // Check group equation [S]B = R + [k]A'
    let lhs: ExtendedHomogeneousPoint = point_mult(S, B_extended);
    let rhs: ExtendedHomogeneousPoint = R + point_mult(k, A_prime);
    lhs == rhs
}

fn verify_signature(msg: Span<u8>, signature: Span<u8>, pub_key: Span<u8>) -> bool {
    if (pub_key.len() != PUB_KEY_LEN) {
        return false;
    }

    if (signature.len() != SIG_LEN) {
        return false;
    }

    let r_string = signature.slice(0, SIG_LEN / 2);
    let s_string = signature.slice(32, SIG_LEN / 2);
    let R_opt: Option<Point> = r_string.try_into();
    if (R_opt.is_none()) {
        return false;
    }
    let A_prime_opt: Option<Point> = pub_key.try_into();
    if (A_prime_opt.is_none()) {
        return false;
    }
    let R: Point = R_opt.unwrap();
    let S: u256 = s_string.into();
    let A_prime: Point = A_prime_opt.unwrap();

    let R_extended: ExtendedHomogeneousPoint = R.into();
    let A_prime_ex: ExtendedHomogeneousPoint = A_prime.into();

    // k = SHA512(dom2(F, C) -> empty string || R -> half of sig || A -> pub_key || PH(M) -> identity function for msg)
    let k: Array<u8> = sha512(r_string.snapshot.concat(pub_key.snapshot).concat(msg.snapshot));
    let k_u512: u512 = k.span().into();

    let l_non_zero: NonZero<u256> = integer::u256_try_as_non_zero(l).unwrap();
    let (_, k_reduced) = integer::u512_safe_div_rem_by_u256(k_u512, l_non_zero);

    check_group_equation(S, R_extended, k_reduced, A_prime_ex)
}
