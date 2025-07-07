use core::option::OptionTrait;
#[allow(unused_imports)]
use starknet::secp256_trait::{
    Secp256PointTrait,
    Secp256Trait,
    Signature,
    is_signature_entry_valid,
    recover_public_key,
};
use core::sha256::{compute_sha256_byte_array};
#[allow(unused_imports)]
use starknet::secp256k1::Secp256k1Point;
#[allow(unused_imports)]
use starknet::{SyscallResult, SyscallResultTrait};
use crate::bytes_utils::{
    byte_at,
    sha256_to_byte_array,
    append_sha256,
    append_u256_be,
    padd_32_bytes_str,
    shl_byte,
};
use ripemd160::ripemd160_hash;

#[inline(always)]
pub fn verify_legacy_signature(
    msg_hash: u256,
    signature: Signature,
    pub_key: u256
) {
    match is_legacy_signature_valid(
        :msg_hash,
        :signature,
        :pub_key
    ) {
        Result::Ok(()) => {},
        Result::Err(err) => core::panic_with_felt252(err),
    }
}

#[inline(always)]
pub fn is_legacy_signature_valid(
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

pub fn public_key_point_to_legacy_address<
    Secp256Point,
    +Drop<Secp256Point>,
    +Secp256Trait<Secp256Point>,
    +Secp256PointTrait<Secp256Point>,
>(
    public_key_point: Secp256Point,
) -> u256 {
    let (x, y) = public_key_point.get_coordinates().unwrap_syscall();

    let prefix: u8 = if y.low & 1 == 0 { 0x02 } else { 0x03 };
    let mut comp: ByteArray = Default::default();

    comp.append_byte(prefix);

    append_u256_be(ref comp, x);

    let sha = compute_sha256_byte_array(@comp).span();

    let mut sha_bytes = sha256_to_byte_array(sha);

    let hash_u256: u256 = ripemd160_hash(@sha_bytes).into();
    let checksum = compute_checksum(hash_u256);

    hash_u256 * 4294967296_u256 | checksum.into()
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

    append_sha256(ref sha_bytes, sha);

    let sha = compute_sha256_byte_array(@sha_bytes).span();

    *sha[0]
}

#[inline(always)]
pub fn get_legacy_message_hash(msg_hash: felt252) -> u256 {
    let full_msg = format!("\u0018Bitcoin Signed Message:\n@{}", padd_32_bytes_str(msg_hash.into()));
    let msg_hash_array = compute_sha256_byte_array(@full_msg).span();

    let msg_hash_array = compute_sha256_byte_array(
        @sha256_to_byte_array(msg_hash_array)
    ).span();

    shl_byte(0x1c, (*msg_hash_array[0]).into()) |
        shl_byte(0x18, (*msg_hash_array[1]).into()) |
        shl_byte(0x14, (*msg_hash_array[2]).into()) |
        shl_byte(0x10, (*msg_hash_array[3]).into()) |
        shl_byte(0xc, (*msg_hash_array[4]).into()) |
        shl_byte(0x8, (*msg_hash_array[5]).into()) |
        shl_byte(0x4, (*msg_hash_array[6]).into()) |
        (*msg_hash_array[7]).into()
}
