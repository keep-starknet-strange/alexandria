//! # Bitcoin Taproot (BIP-341) Implementation
//!
//! This module provides Taproot functionality including key tweaking, script trees,
//! and proper P2TR address generation using BIP-340 Schnorr signatures.
//!

use alexandria_bytes::byte_array_ext::SpanU8IntoByteArray;
use alexandria_bytes::reversible::ReversibleBytes;
use starknet::SyscallResultTrait;
use starknet::secp256_trait::{Secp256PointTrait, Secp256Trait};
use starknet::secp256k1::Secp256k1Point;
use crate::bip340::verify as bip340_verify;
use crate::hash::{sha256_byte_array, sha256_from_byte_array, sha256_u256};

/// Taproot tweaked public key result
#[derive(Drop, Copy)]
pub struct TweakedPublicKey {
    pub output_key: u256, // The final output key (32 bytes)
    pub parity: bool // Whether the y-coordinate is even
}

/// Script tree leaf
#[derive(Drop)]
pub struct ScriptLeaf {
    pub script: Array<u8>,
    pub leaf_version: u8,
}

/// Taproot script tree (simplified - single leaf for now)
#[derive(Drop)]
pub struct TapTree {
    pub leaf: Option<ScriptLeaf>,
}

/// Create a tagged hash according to BIP-340 tagged hash specification
///
/// #### Arguments
/// * `tag` - The tag string (e.g., "TapTweak", "TapLeaf")
/// * `data` - The data to hash
///
/// #### Returns
/// * `Array<u8>` - The tagged hash (32 bytes)
pub fn tagged_hash(tag: ByteArray, data: Span<u8>) -> Array<u8> {
    // Calculate tag_hash = SHA256(tag)
    let tag_hash = sha256_from_byte_array(@tag);

    // Create message: tag_hash || tag_hash || data

    // Append first tag_hash
    let mut message_ba: ByteArray = tag_hash.span().into();
    // Append second tag_hash
    message_ba.append(@tag_hash.span().into());
    // Append data
    message_ba.append(@data.into());

    // Return SHA256(tag_hash || tag_hash || data)
    sha256_from_byte_array(@message_ba)
}

/// Create a tagged hash from byte arrays according to BIP-340 tagged hash specification
///
/// # Arguments
/// * `tag` - The tag string (e.g., "TapTweak", "TapLeaf")
/// * `data` - The byte array data to hash
///
/// # Returns
/// * `ByteArray` - The tagged hash as ByteArray array
#[inline(always)]
pub fn tagged_hash_byte_array(tag: ByteArray, data: @ByteArray) -> ByteArray {
    let mut preimage = sha256_byte_array(@tag);

    preimage = ByteArrayTrait::concat(@preimage, @preimage);

    preimage.append(data);

    sha256_byte_array(@preimage)
}

/// Create a tagged hash from byte arrays according to BIP-340 tagged hash specification
///
/// # Arguments
/// * `tag` - The tag string (e.g., "TapTweak", "TapLeaf")
/// * `data` - The byte array data to hash
///
/// # Returns
/// * `u256` - The tagged hash as u256
#[inline(always)]
pub fn tagged_hash_u256(tag: ByteArray, data: @ByteArray) -> u256 {
    let mut preimage = sha256_byte_array(@tag);

    preimage = ByteArrayTrait::concat(@preimage, @preimage);

    preimage.append(data);

    sha256_u256(@preimage)
}

/// Tweak a public key for Taproot according to BIP-341
///
/// #### Arguments
/// * `internal_key` - The internal public key (x-coordinate only)
/// * `merkle_root` - Optional Merkle root of the script tree
///
/// #### Returns
/// * `TweakedPublicKey` - The tweaked output key and parity
pub fn tweak_public_key(internal_key: u256, merkle_root: Option<u256>) -> Option<TweakedPublicKey> {
    // Convert internal key to bytes (32 bytes, big-endian)
    let internal_key_bytes = u256_to_32_bytes_be(internal_key);

    // Prepare tweak message: internal_key || merkle_root (if present)
    let mut tweak_data: ByteArray = internal_key_bytes.span().into();
    if let Some(root) = merkle_root {
        let root_bytes = u256_to_32_bytes_be(root);
        tweak_data.append(@root_bytes.span().into());
    }

    // Calculate tweak = tagged_hash("TapTweak", internal_key || merkle_root)
    let tweak_hash = tagged_hash_u256("TapTweak", @tweak_data);

    // Lift the internal key x-coordinate to a point
    let Some(internal_point) = lift_x_coordinate(internal_key) else {
        return Option::None;
    };

    // Get the generator point for elliptic curve operations
    let generator = Secp256Trait::<Secp256k1Point>::get_generator_point();

    // Calculate tweaked point: P' = P + tweak*G
    // where P is the internal_point and G is the generator
    let tweak_point = generator.mul(tweak_hash).unwrap_syscall();

    // Add the points
    let output_point = internal_point.add(tweak_point).unwrap_syscall();

    // Extract x-coordinate and parity from the output point
    let (x, y) = output_point.get_coordinates().unwrap_syscall();

    // Check if y is even (parity = even means positive y)
    let parity = y % 2 == 0;

    Option::Some(TweakedPublicKey { output_key: x, parity })
}

/// Lift an x-coordinate to a valid secp256k1 point
///
/// #### Arguments
/// * `x` - The x-coordinate
///
/// #### Returns
/// * `Option<Secp256k1Point>` - The point if x is valid, None otherwise
pub fn lift_x_coordinate(x: u256) -> Option<Secp256k1Point> {
    // Try to get point with even y-coordinate first
    Secp256Trait::<Secp256k1Point>::secp256_ec_get_point_from_x_syscall(x, false).unwrap_syscall()
}

/// Convert u256 to 32-byte array (big-endian)
pub fn u256_to_32_bytes_be(mut value: u256) -> Array<u8> {
    let mut bytes = array![];
    let mut i = 0_u32;
    while i < 32 {
        bytes.append((value & 0xff).try_into().unwrap());
        value = value / 256;
        i += 1;
    }

    bytes.reverse_bytes()
}

/// Convert 32-byte array to u256 (big-endian)
fn bytes_32_to_u256_be(bytes: Span<u8>) -> u256 {
    let mut result: u256 = 0;
    let mut i = 0;
    while i < 32 && i < bytes.len() {
        result = result * 256 + (*bytes.at(i)).into();
        i += 1;
    }
    result
}

/// Create a Taproot script tree from a single script
///
/// #### Arguments
/// * `script` - The script bytes
/// * `leaf_version` - The script version (usually 0xc0)
///
/// #### Returns
/// * `TapTree` - The script tree
pub fn create_script_tree(script: Array<u8>, leaf_version: u8) -> TapTree {
    TapTree { leaf: Option::Some(ScriptLeaf { script, leaf_version }) }
}

/// Calculate the Merkle root of a script tree
///
/// #### Arguments
/// * `tree` - The script tree
///
/// #### Returns
/// * `Option<u256>` - The Merkle root if tree has scripts, None for key-path only
pub fn calculate_merkle_root(tree: @TapTree) -> Option<u256> {
    match tree.leaf {
        Option::Some(leaf) => {
            // For a single leaf, the Merkle root is the tagged hash of the leaf
            let leaf_hash = calculate_leaf_hash(leaf);
            Option::Some(bytes_32_to_u256_be(leaf_hash.span()))
        },
        Option::None => Option::None // Key-path only spending
    }
}

/// Calculate the hash of a script leaf
///
/// #### Arguments
/// * `leaf` - The script leaf
///
/// #### Returns
/// * `Array<u8>` - The leaf hash (32 bytes)
fn calculate_leaf_hash(leaf: @ScriptLeaf) -> Array<u8> {
    // Create leaf data: leaf_version || compact_size(script) || script
    let mut leaf_data = array![];
    leaf_data.append(*leaf.leaf_version);

    // For simplicity, assume script length < 253 (single byte compact size)
    leaf_data.append(leaf.script.len().try_into().unwrap());

    let mut i = 0;
    while i < leaf.script.len() {
        leaf_data.append(*leaf.script.at(i));
        i += 1;
    }

    // Return tagged_hash("TapLeaf", leaf_data)
    tagged_hash("TapLeaf", leaf_data.span())
}

/// Verify a BIP-340 Schnorr signature for Taproot
///
/// #### Arguments
/// * `signature` - The Schnorr signature (64 bytes: r || s)
/// * `message` - The message that was signed
/// * `public_key` - The tweaked public key (x-coordinate only)
///
/// #### Returns
/// * `bool` - True if signature is valid
pub fn verify_taproot_signature(signature: Span<u8>, message: ByteArray, public_key: u256) -> bool {
    // Ensure signature is 64 bytes
    if signature.len() != 64 {
        return false;
    }

    // Extract r and s from signature
    let mut r_bytes = array![];
    let mut s_bytes = array![];

    // Extract first 32 bytes for r
    let mut i = 0_u32;
    while i < 32 {
        r_bytes.append(*signature.at(i));
        i += 1;
    }

    // Extract next 32 bytes for s
    let mut i = 32_u32;
    while i < 64 {
        s_bytes.append(*signature.at(i));
        i += 1;
    }

    let r = bytes_32_to_u256_be(r_bytes.span());
    let s = bytes_32_to_u256_be(s_bytes.span());

    // Use BIP-340 verification
    bip340_verify(public_key, r, s, message)
}

/// Generate a key-path only Taproot output
///
/// #### Arguments
/// * `internal_key` - The internal public key
///
/// #### Returns
/// * `Option<TweakedPublicKey>` - The tweaked key for key-path spending
pub fn create_key_path_output(internal_key: u256) -> Option<TweakedPublicKey> {
    // Key-path only: no script tree (merkle_root = None)
    tweak_public_key(internal_key, Option::None)
}

/// Generate a script-path Taproot output
///
/// #### Arguments
/// * `internal_key` - The internal public key
/// * `script_tree` - The script tree
///
/// #### Returns
/// * `Option<TweakedPublicKey>` - The tweaked key for script-path spending
pub fn create_script_path_output(
    internal_key: u256, script_tree: @TapTree,
) -> Option<TweakedPublicKey> {
    let merkle_root = calculate_merkle_root(script_tree);
    tweak_public_key(internal_key, merkle_root)
}
