//! Utilities for Bitcoin legacy signature verification and address recovery.
//!
//! This module provides functionality for working with Bitcoin signatures.
//! It implements verification of Bitcoin signatures against addresses and conversion of public
//! keys to Bitcoin addresses.

use core::{
    option::OptionTrait,
    sha256::compute_sha256_byte_array,
};
use starknet::{
    secp256_trait::{
        Secp256PointTrait,
        Secp256Trait,
        Signature,
        is_signature_entry_valid,
        recover_public_key,
    },
    secp256k1::Secp256k1Point,
    SyscallResultTrait,
};
use ripemd160::ripemd160_hash;
use crate::utils::{
    byte_at,
    byte_array_append_sha256,
    byte_array_append_u256_be
};

/// A Bitcoin address, 20 bytes in length.
#[derive(Copy, Drop, Hash, PartialEq, Debug)]
pub struct BtcAddress {
    pub address: u256,
}

#[inline(always)]
pub fn verify_legacy_signature(
    msg_hash: u256,
    signature: Signature,
    pub_key: u256
) {
    match is_legacy_btc_signature_valid(
        :msg_hash,
        :signature,
        :pub_key
    ) {
        Result::Ok(()) => {},
        Result::Err(err) => core::panic_with_felt252(err),
    }
}

#[inline(always)]
pub fn is_legacy_btc_signature_valid(
    msg_hash: u256, signature: Signature, pub_key: u256,
) -> Result<(), felt252> {
    if !is_signature_entry_valid::<Secp256k1Point>(signature.r) {
        return Result::Err('Signature out of range');
    }
    if !is_signature_entry_valid::<Secp256k1Point>(signature.s) {
        return Result::Err('Signature out of range');
    }

    let public_key_point = recover_public_key::<Secp256k1Point>(
        :msg_hash,
        :signature
    ).unwrap();
    let (x, _) = public_key_point.get_coordinates().unwrap_syscall();

    if pub_key != x {
        return Result::Err('Invalid signature');
    }

    Result::Ok(())
}

pub fn public_key_point_to_legacy_btc_address<
    Secp256Point,
    +Drop<Secp256Point>,
    +Secp256Trait<Secp256Point>,
    +Secp256PointTrait<Secp256Point>,
>(
    public_key_point: Secp256Point,
) -> BtcAddress {
    let (x, y) = public_key_point.get_coordinates().unwrap_syscall();

    let prefix: u8 = if y.low & 1 == 0 { 0x02 } else { 0x03 };
    let mut comp: ByteArray = Default::default();

    comp.append_byte(prefix);

    byte_array_append_u256_be(x, ref comp);

    let sha = compute_sha256_byte_array(@comp).span();
    let mut sha_bytes: ByteArray = Default::default();

    byte_array_append_sha256(sha, ref sha_bytes);

    let hash_u256: u256 = ripemd160_hash(@sha_bytes).into();
    let checksum = compute_checksum(hash_u256);

    BtcAddress { address: hash_u256 * 4294967296_u256 | checksum.into() }
}

#[inline(always)]
pub fn compute_checksum(hash_u256: u256) -> u32 {
    let mut buff: ByteArray = Default::default();

    buff.append_byte(0x0);

    let mut i = 19_u32;

    loop {
        buff.append_byte(byte_at(hash_u256, i));

        if i == 0 {
            break;
        }

        i -= 1;
    };

    let sha = compute_sha256_byte_array(@buff).span();

    let mut sha_bytes: ByteArray = Default::default();

    byte_array_append_sha256(sha, ref sha_bytes);

    let sha = compute_sha256_byte_array(@sha_bytes).span();

    *sha[0]
}
