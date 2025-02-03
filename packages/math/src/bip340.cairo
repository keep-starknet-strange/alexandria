//! bip340 implementation
use core::sha256::compute_sha256_byte_array; //Available in Cairo ^2.7.0.
use core::starknet::SyscallResultTrait;
use starknet::secp256_trait::{Secp256PointTrait, Secp256Trait};
use starknet::secp256k1::Secp256k1Point;

const TWO_POW_32: u128 = 0x100000000;
const TWO_POW_64: u128 = 0x10000000000000000;
const TWO_POW_96: u128 = 0x1000000000000000000000000;

const p: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;


/// Computes BIP0340/challenge tagged hash.
///
/// References:
///   Schnorr signatures explained:
///   https://www.youtube.com/watch?v=wjACBRJDfxc&ab_channel=Bitcoinology
///   NIP-01:
///   https://github.com/nostr-protocol/nips/blob/master/01.md
///   BIP-340:
///   https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki
///   reference implementation:
///   https://github.com/bitcoin/bips/blob/master/bip-0340/reference.py
///
///
/// # Arguments:
/// * `rx`: `u256` - The x-coordinate of the R point from the signature.
/// * `px`: `u256` - The x-coordinate of the public key.
/// * `m`: `ByteArray` - The message for which the signature is being verified.
///
/// # Returns:
/// * `u256` - `sha256(tag) || sha256(tag) || bytes(rx) || bytes(px) || m` as u256 where tag =
/// "BIP0340/challenge".
fn hash_challenge(rx: u256, px: u256, m: ByteArray) -> u256 {
    // sha256(tag)

    //Precomputed values -> tag = 'compute_sha256_byte_array(@"BIP0340/challenge")'
    // sha256(tag) || sha256(tag)
    let mut ba: ByteArray = Default::default();
    ba.append_word(0x7bb52d7a9fef58323eb1bf7a407db382d2f3f2d81bb1224f49fe518f6d48d3, 31);
    ba.append_word(0x7c7bb52d7a9fef58323eb1bf7a407db382d2f3f2d81bb1224f49fe518f6d48, 31);
    ba.append_word(0xd37c, 2);
    // bytes(rx)
    ba.append_word(rx.high.into(), 16);
    ba.append_word(rx.low.into(), 16);
    // bytes(px)
    ba.append_word(px.high.into(), 16);
    ba.append_word(px.low.into(), 16);
    // m
    ba.append(@m);

    let [x0, x1, x2, x3, x4, x5, x6, x7] = compute_sha256_byte_array(@ba);

    u256 {
        high: x0.into() * TWO_POW_96 + x1.into() * TWO_POW_64 + x2.into() * TWO_POW_32 + x3.into(),
        low: x4.into() * TWO_POW_96 + x5.into() * TWO_POW_64 + x6.into() * TWO_POW_32 + x7.into(),
    }
}

/// Verifies a signature according to the BIP-340.
///
/// This function checks if the signature `(rx, s)` is valid for a message `m` with
/// respect to the public key `px`.
///
/// # Arguments
/// * `px`: `u256` - The x-coordinate of the public key.
/// * `rx`: `u256` - The x-coordinate of the R point from the signature.
/// * `s`: `u256` - The scalar component of the signature.
/// * `m`: `ByteArray` - The message for which the signature is being verified.
///
/// # Returns
/// * `bool` - `true` if the signature is verified for the message and public key, `false`
/// otherwise.
pub fn verify(px: u256, rx: u256, s: u256, m: ByteArray) -> bool {
    let n = Secp256Trait::<Secp256k1Point>::get_curve_size();

    if px >= p || rx >= p || s >= n {
        return false;
    }

    // p - field size, n - curve order
    // point P for which x(P) = px and has_even_y(P),
    let P =
        match Secp256Trait::<Secp256k1Point>::secp256_ec_get_point_from_x_syscall(px, false)
            .unwrap_syscall() {
        Option::Some(P) => P,
        Option::None => { return false; },
    };

    // e = int(hashBIP0340/challenge(bytes(rx) || bytes(px) || m)) mod n.
    let e = hash_challenge(rx, px, m) % n;

    let G = Secp256Trait::<Secp256k1Point>::get_generator_point();

    // R = s⋅G - e⋅P
    let p1 = G.mul(s).unwrap_syscall();
    let minus_e = Secp256Trait::<Secp256k1Point>::get_curve_size() - e;
    let p2 = P.mul(minus_e).unwrap_syscall();

    let R = p1.add(p2).unwrap_syscall();

    let (Rx, Ry) = R.get_coordinates().unwrap_syscall();

    // fail if is_infinite(R) || not has_even_y(R) || x(R) ≠ rx.
    !(Rx == 0 && Ry == 0) && Ry % 2 == 0 && Rx == rx
}
