//! Utilities for Bitcoin BIP340 signature verification.
//!
//! This module provides functionality for working with Bitcpin schnorr signatures.
//! It implements verification of Bitcoin BIP340 signatures against public key
//! Conversion to address not implemented yet as might add much n steps, gas...

use core::{
    option::OptionTrait,
    sha256::compute_sha256_byte_array,
};
use starknet::{
    secp256_trait::{
        Secp256Trait,
        Secp256PointTrait,
        Signature,
        is_signature_entry_valid
    },
    secp256k1::Secp256k1Point,
    SyscallResultTrait
};
use crate::{
    constants::{PRIME_FIELD, ORDER},
    utils::{
        byte_at,
        shl_byte,
        ec_point_negate,
        byte_array_append_sha256,
        byte_array_append_u256_be
    },
};

#[inline(always)]
fn tagged_sha256(tag: ByteArray, msg: ByteArray) -> Span<u32> {
    let tag_hash = compute_sha256_byte_array(@tag).span();
    let mut preimage: ByteArray = Default::default();

    byte_array_append_sha256(tag_hash, ref preimage);
    byte_array_append_sha256(tag_hash, ref preimage);

    preimage.append(@msg);

    compute_sha256_byte_array(@preimage).span()
}

#[inline(always)]
fn compute_challenge(challenge_input: ByteArray) -> u256 {
    let tag = "BIP0340/challenge";
    let challenge_hash = tagged_sha256(tag, challenge_input);
    let mut challenge = 0_u256;

    for i in 0..8_u32 {
        let val: u256 = (*challenge_hash[i]).into();
        let base_shift = 31 - i * 4;

        challenge = challenge | shl_byte(base_shift, byte_at(val, 3).into()) |
            shl_byte(base_shift - 1, byte_at(val, 2).into()) |
            shl_byte(base_shift - 2, byte_at(val, 1).into()) |
            shl_byte(base_shift - 3, byte_at(val, 0).into());
    };

    challenge
}

#[inline(always)]
pub fn verify_bip340_signature(
    msg_hash: u256,
    signature: Signature,
    pub_key: u256,
) {
    match is_bip340_signature_valid(
        :msg_hash,
        :signature,
        :pub_key
    ) {
        Result::Ok(()) => {},
        Result::Err(err) => core::panic_with_felt252(err),
    }
}

#[inline(always)]
pub fn is_bip340_signature_valid(
    msg_hash: u256,
    signature: Signature,
    pub_key: u256,
) -> Result<(), felt252> {
    if !is_signature_entry_valid::<Secp256k1Point>(signature.r) {
        return Result::Err('Signature out of range');
    }
    if !is_signature_entry_valid::<Secp256k1Point>(signature.s) {
        return Result::Err('Signature out of range');
    }

    let public_key_point: Secp256k1Point =
        Secp256Trait::secp256_ec_get_point_from_x_syscall(
            pub_key,
            true
        ).unwrap_syscall().unwrap();

    let mut msg_bytes: ByteArray = Default::default();

    byte_array_append_u256_be(signature.r, ref msg_bytes);
    byte_array_append_u256_be(pub_key, ref msg_bytes);
    byte_array_append_u256_be(msg_hash, ref msg_bytes);

    let g = Secp256Trait::get_generator_point();
    let sg = g.mul(signature.s).unwrap_syscall();
    let e = compute_challenge(msg_bytes) % PRIME_FIELD;
    let ep = public_key_point.mul(ORDER - e).unwrap_syscall();
    let neg_ep = ec_point_negate(ep);
    let r_candidate = sg.add(neg_ep).unwrap_syscall();
    let (x, y) = r_candidate.get_coordinates().unwrap_syscall();

    if y % 2 != 0 {
        return Result::Err('R.y value should be even');
    }
    if x != signature.r {
        return Result::Err('R.x does not match r');
    }

    Result::Ok(())
}
