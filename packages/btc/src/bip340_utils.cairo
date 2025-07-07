use core::option::OptionTrait;
use starknet::secp256_trait::{
    Secp256PointTrait,
    Secp256Trait,
    Signature,
    is_signature_entry_valid,
};
use core::sha256::compute_sha256_byte_array;
use starknet::secp256k1::Secp256k1Point;
use starknet::{SyscallResultTrait};
use crate::bytes_utils::{
    append_sha256,
    append_u256_be,
    pack_sha256
};

const PRIME_FIELD: u256 =
    0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;

const ORDER: u256 =
    0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141;

fn ec_point_negate<
    Secp256Point,
    +Drop<Secp256Point>,
    +Secp256Trait<Secp256Point>,
    +Secp256PointTrait<Secp256Point>
>(
    p: Secp256Point
) -> Secp256Point {
    let (x, y) = p.get_coordinates().unwrap_syscall();
    let y_neg = PRIME_FIELD - y;

    Secp256Trait::<Secp256Point>::secp256_ec_new_syscall(x, y_neg)
        .unwrap_syscall()
        .unwrap()
}

#[inline(always)]
fn compute_challenge(challenge_input: ByteArray) -> u256 {
    pack_sha256(tagged_hash("BIP0340/challenge", @challenge_input))
}

#[inline(always)]
pub fn tagged_hash(tag: ByteArray, msg: @ByteArray) -> Span<u32> {
    let tag_hash = compute_sha256_byte_array(@tag).span();
    let mut preimage: ByteArray = Default::default();

    append_sha256(ref preimage, tag_hash);
    append_sha256(ref preimage, tag_hash);

    preimage.append(msg);

    compute_sha256_byte_array(@preimage).span()
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

    append_u256_be(ref msg_bytes, signature.r);
    append_u256_be(ref msg_bytes, pub_key);
    append_u256_be(ref msg_bytes, msg_hash);

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
