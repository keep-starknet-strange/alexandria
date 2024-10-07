//! bip340 implementation
use core::byte_array::ByteArrayTrait;
use core::option::OptionTrait;
use core::result::ResultTrait;
use core::sha256::compute_sha256_byte_array; //Available in Cairo ^2.7.0.
use core::starknet::SyscallResultTrait;
use core::to_byte_array::{AppendFormattedToByteArray, FormatAsByteArray};
use core::traits::Into;
use core::math::u256_mul_mod_n;

use starknet::{secp256k1::{Secp256k1Point}, secp256_trait::{Secp256Trait, Secp256PointTrait}};

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
/// # Parameters:
/// - `rx`: `u256` - The x-coordinate of the R point from the signature.
/// - `px`: `u256` - The x-coordinate of the public key.
/// - `m`: `ByteArray` - The message for which the signature is being verified.
///
/// # Returns:
/// `sha256(tag) || sha256(tag) || bytes(rx) || bytes(px) || m` as u256 where tag =
/// "BIP0340/challenge".
fn hash_challenge(rx: u256, px: u256, m: ByteArray) -> u256 {
    // sha256(tag)
    let [x0, x1, x2, x3, x4, x5, x6, x7] = compute_sha256_byte_array(@"BIP0340/challenge");

    let mut ba = Default::default();
    // sha256(tag)
    ba.append_word(x0.into(), 4);
    ba.append_word(x1.into(), 4);
    ba.append_word(x2.into(), 4);
    ba.append_word(x3.into(), 4);
    ba.append_word(x4.into(), 4);
    ba.append_word(x5.into(), 4);
    ba.append_word(x6.into(), 4);
    ba.append_word(x7.into(), 4);
    // sha256(tag)
    ba.append_word(x0.into(), 4);
    ba.append_word(x1.into(), 4);
    ba.append_word(x2.into(), 4);
    ba.append_word(x3.into(), 4);
    ba.append_word(x4.into(), 4);
    ba.append_word(x5.into(), 4);
    ba.append_word(x6.into(), 4);
    ba.append_word(x7.into(), 4);
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
/// # Parameters
/// - `px`: `u256` - The x-coordinate of the public key.
/// - `rx`: `u256` - The x-coordinate of the R point from the signature.
/// - `s`: `u256` - The scalar component of the signature.
/// - `m`: `ByteArray` - The message for which the signature is being verified.
///
/// # Returns
/// Returns `true` if the signature is valid for the given message and public key; otherwise,
/// returns `false`.
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
        Option::None => { return false; }
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
