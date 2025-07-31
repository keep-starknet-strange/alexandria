use alexandria_bytes::reversible::ReversibleBytes;
use starknet::SyscallResultTrait;
use starknet::secp256_trait::{Secp256PointTrait, Secp256Trait};
use starknet::secp256k1::Secp256k1Point;
use crate::hash::hash160;
use crate::types::{BitcoinNetwork, BitcoinPrivateKey, BitcoinPublicKey, BitcoinPublicKeyTrait};

/// Generates a Bitcoin public key from a private key using secp256k1 elliptic curve operations.
///
/// Performs elliptic curve point multiplication (private_key * G) where G is the
/// secp256k1 generator point to derive the corresponding public key coordinates.
///
/// #### Arguments
/// * `private_key` - The Bitcoin private key containing the scalar value and compression flag
///
/// #### Returns
/// * `BitcoinPublicKey` - Public key with x,y coordinates and compression setting
pub fn private_key_to_public_key(private_key: BitcoinPrivateKey) -> BitcoinPublicKey {
    // Get the generator point G
    let generator = Secp256Trait::<Secp256k1Point>::get_generator_point();

    // Calculate public key = private_key * G
    let public_point = generator.mul(private_key.key).unwrap_syscall();

    // Extract coordinates
    let (x, y) = public_point.get_coordinates().unwrap_syscall();

    if private_key.compressed {
        BitcoinPublicKeyTrait::from_x_coordinate(x, y % 2 == 0)
    } else {
        BitcoinPublicKeyTrait::from_coordinates(x, y)
    }
}

/// Converts a u256 value to bytes in big-endian order.
///
/// Converts a 256-bit integer to a 32-byte array in big-endian format,
/// which is the standard representation for Bitcoin cryptographic operations.
///
/// #### Arguments
/// * `value` - The u256 value to convert
///
/// #### Returns
/// * `Array<u8>` - 32-byte array in big-endian order
fn u256_to_be_bytes(mut value: u256) -> Array<u8> {
    let mut bytes = array![];
    let mut i = 0_u32;
    while i < 32 {
        let byte = (value & 0xff).try_into().unwrap();
        bytes.append(byte);
        value = value / 256;
        i += 1;
    }

    let result: Array<u8> = bytes.reverse_bytes();
    result
}

/// Serializes a Bitcoin public key to its byte representation.
///
/// Converts a public key to either compressed (33 bytes) or uncompressed (65 bytes)
/// format according to SEC 1 standard:
/// - Compressed: 0x02/0x03 prefix + x-coordinate (33 bytes)
/// - Uncompressed: 0x04 prefix + x-coordinate + y-coordinate (65 bytes)
///
/// #### Arguments
/// * `public_key` - The Bitcoin public key to serialize
///
/// #### Returns
/// * `Array<u8>` - Serialized public key bytes (33 or 65 bytes)
pub fn public_key_to_bytes(public_key: BitcoinPublicKey) -> Array<u8> {
    let mut result = array![];

    // The new BitcoinPublicKey already stores the raw bytes in the correct format
    // Just convert the ByteArray to Array<u8>
    let mut i = 0_usize;
    while i < public_key.bytes.len() {
        result.append(public_key.bytes.at(i).unwrap());
        i += 1;
    }

    result
}

/// Generates a Bitcoin public key hash using Hash160 (RIPEMD160 of SHA256).
///
/// Computes the standard Bitcoin public key hash by serializing the public key
/// and applying the Hash160 function (RIPEMD160(SHA256(pubkey))).
///
/// #### Arguments
/// * `public_key` - The Bitcoin public key to hash
///
/// #### Returns
/// * `Array<u8>` - 20-byte public key hash
pub fn public_key_hash(public_key: BitcoinPublicKey) -> Array<u8> {
    let pubkey_bytes = public_key_to_bytes(public_key);
    hash160(pubkey_bytes.span())
}

/// Creates a Bitcoin private key from a u256 value with validation.
///
/// Validates that the provided key value is within the secp256k1 curve order
/// and creates a properly formatted Bitcoin private key structure.
///
/// #### Arguments
/// * `key` - The private key scalar value (must be 1 < key < curve_order)
/// * `network` - The Bitcoin network this key will be used on
/// * `compressed` - Whether the corresponding public key should use compressed format
///
/// #### Returns
/// * `BitcoinPrivateKey` - Validated private key structure
///
/// #### Panics
/// Panics if key is zero or exceeds the secp256k1 curve order.
pub fn create_private_key(
    key: u256, network: BitcoinNetwork, compressed: bool,
) -> BitcoinPrivateKey {
    // Validate that the key is within the secp256k1 curve order
    assert!(key != 0, "Private key cannot be zero");
    let curve_size = Secp256Trait::<Secp256k1Point>::get_curve_size();
    assert!(key < curve_size, "Private key exceeds curve order");

    BitcoinPrivateKey { key, network, compressed }
}

/// Generates a random Bitcoin private key (placeholder implementation).
///
/// Creates a private key using a deterministic value for testing purposes.
/// In production, this should use a cryptographically secure random number generator.
///
/// #### Arguments
/// * `network` - The Bitcoin network for the private key
/// * `compressed` - Whether the corresponding public key should use compressed format
///
/// #### Returns
/// * `BitcoinPrivateKey` - Generated private key structure
///
/// #### Security Note
/// This implementation is NOT cryptographically secure and should only be used for testing.
/// Production implementations must use proper random number generation.
pub fn generate_private_key(network: BitcoinNetwork, compressed: bool) -> BitcoinPrivateKey {
    // In a real implementation, this would use a cryptographically secure random number generator
    // For now, we'll use a placeholder value that's within the curve order
    let curve_size = Secp256Trait::<Secp256k1Point>::get_curve_size();
    let random_key = curve_size - 0x123456789abcdef; // Ensure it's below curve size

    create_private_key(random_key, network, compressed)
}
