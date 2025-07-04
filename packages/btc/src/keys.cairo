use starknet::SyscallResultTrait;
use starknet::secp256_trait::{Secp256PointTrait, Secp256Trait};
use starknet::secp256k1::Secp256k1Point;
use crate::hash::hash160;
use crate::types::{BitcoinNetwork, BitcoinPrivateKey, BitcoinPublicKey};

/// Generate a public key from a private key using secp256k1 elliptic curve operations
pub fn private_key_to_public_key(private_key: BitcoinPrivateKey) -> BitcoinPublicKey {
    // Get the generator point G
    let generator = Secp256Trait::<Secp256k1Point>::get_generator_point();

    // Calculate public key = private_key * G
    let public_point = generator.mul(private_key.key).unwrap_syscall();

    // Extract coordinates
    let (x, y) = public_point.get_coordinates().unwrap_syscall();

    BitcoinPublicKey { x, y, compressed: private_key.compressed }
}

/// Helper function to convert u256 to bytes in big-endian order
fn u256_to_be_bytes(mut value: u256) -> Array<u8> {
    let mut bytes = array![];
    let mut i = 0_u32;
    while i < 32 {
        let byte = (value & 0xff).try_into().unwrap();
        bytes.append(byte);
        value = value / 256;
        i += 1;
    }

    // Reverse to get big-endian order
    let mut result = array![];
    let mut j = bytes.len();
    while j > 0 {
        j -= 1;
        result.append(*bytes.at(j));
    }

    result
}

/// Serialize public key to bytes
pub fn public_key_to_bytes(public_key: BitcoinPublicKey) -> Array<u8> {
    let mut result = array![];

    if public_key.compressed {
        // Compressed format: 33 bytes (0x02/0x03 + x coordinate)
        let prefix = if (public_key.y & 1) == 0 {
            0x02
        } else {
            0x03
        };
        result.append(prefix);

        // Add x coordinate (32 bytes, big-endian)
        let x_bytes = u256_to_be_bytes(public_key.x);
        let mut i = 0_u32;
        while i < x_bytes.len() {
            result.append(*x_bytes.at(i));
            i += 1;
        };
    } else {
        // Uncompressed format: 65 bytes (0x04 + x + y coordinates)
        result.append(0x04);

        // Add x coordinate (32 bytes, big-endian)
        let x_bytes = u256_to_be_bytes(public_key.x);
        let mut i = 0_u32;
        while i < x_bytes.len() {
            result.append(*x_bytes.at(i));
            i += 1;
        }

        // Add y coordinate (32 bytes, big-endian)
        let y_bytes = u256_to_be_bytes(public_key.y);
        let mut i = 0_u32;
        while i < y_bytes.len() {
            result.append(*y_bytes.at(i));
            i += 1;
        };
    }

    result
}

/// Generate public key hash (Hash160 of public key)
pub fn public_key_hash(public_key: BitcoinPublicKey) -> Array<u8> {
    let pubkey_bytes = public_key_to_bytes(public_key);
    hash160(pubkey_bytes.span())
}

/// Create a private key from a u256 value
pub fn create_private_key(
    key: u256, network: BitcoinNetwork, compressed: bool,
) -> BitcoinPrivateKey {
    // Validate that the key is within the secp256k1 curve order
    assert!(key != 0, "Private key cannot be zero");
    let curve_size = Secp256Trait::<Secp256k1Point>::get_curve_size();
    assert!(key < curve_size, "Private key exceeds curve order");

    BitcoinPrivateKey { key, network, compressed }
}

/// Generate a random private key (placeholder implementation)
pub fn generate_private_key(network: BitcoinNetwork, compressed: bool) -> BitcoinPrivateKey {
    // In a real implementation, this would use a cryptographically secure random number generator
    // For now, we'll use a placeholder value that's within the curve order
    let curve_size = Secp256Trait::<Secp256k1Point>::get_curve_size();
    let random_key = curve_size - 0x123456789abcdef; // Ensure it's below curve size

    create_private_key(random_key, network, compressed)
}
