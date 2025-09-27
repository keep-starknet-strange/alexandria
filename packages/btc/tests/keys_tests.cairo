use alexandria_btc::keys::{
    create_private_key, generate_private_key, private_key_to_public_key, public_key_hash,
    public_key_to_bytes,
};
use alexandria_btc::types::{BitcoinNetwork, BitcoinPublicKeyTrait};

#[test]
fn test_create_private_key_valid() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Mainnet, true);

    assert!(private_key.key == key);
    assert!(private_key.network == BitcoinNetwork::Mainnet);
    assert!(private_key.compressed == true);
}

#[test]
fn test_create_private_key_uncompressed() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Testnet, false);

    assert!(private_key.key == key);
    assert!(private_key.network == BitcoinNetwork::Testnet);
    assert!(private_key.compressed == false);
}

#[test]
#[should_panic(expected: "Private key cannot be zero")]
fn test_create_private_key_zero() {
    create_private_key(0, BitcoinNetwork::Mainnet, true);
}

#[test]
#[should_panic]
fn test_create_private_key_too_large() {
    // Use a value that's larger than the secp256k1 curve order
    // The secp256k1 curve order is
    // 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 This value is definitely
    // larger
    let invalid_key = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364142_u256;
    create_private_key(invalid_key, BitcoinNetwork::Mainnet, true);
}

#[test]
fn test_private_key_to_public_key_compressed() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Mainnet, true);

    let public_key = private_key_to_public_key(private_key);

    assert!(public_key.is_compressed());
    assert!(public_key.bytes.len() == 33); // Compressed key length

    // First byte should be 0x02 or 0x03 for compressed keys
    let first_byte = public_key.bytes.at(0).unwrap();
    assert!(first_byte == 0x02 || first_byte == 0x03);
}

#[test]
fn test_private_key_to_public_key_uncompressed() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Mainnet, false);

    let public_key = private_key_to_public_key(private_key);

    assert!(!public_key.is_compressed());
    assert!(public_key.bytes.len() == 65); // Uncompressed key length

    // First byte should be 0x04 for uncompressed keys
    let first_byte = public_key.bytes.at(0).unwrap();
    assert!(first_byte == 0x04);
}

#[test]
fn test_different_private_keys_produce_different_public_keys() {
    let key1 = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let key2 = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdee;

    let private_key1 = create_private_key(key1, BitcoinNetwork::Mainnet, true);
    let private_key2 = create_private_key(key2, BitcoinNetwork::Mainnet, true);

    let public_key1 = private_key_to_public_key(private_key1);
    let public_key2 = private_key_to_public_key(private_key2);

    assert!(public_key1.get_x_coordinate() != public_key2.get_x_coordinate());
}

#[test]
fn test_same_private_key_different_compression() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    let private_key_compressed = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let private_key_uncompressed = create_private_key(key, BitcoinNetwork::Mainnet, false);

    let public_key_compressed = private_key_to_public_key(private_key_compressed);
    let public_key_uncompressed = private_key_to_public_key(private_key_uncompressed);

    // Same x-coordinate since it's the same private key
    assert!(public_key_compressed.get_x_coordinate() == public_key_uncompressed.get_x_coordinate());

    // Different byte representations due to compression
    assert!(public_key_compressed.bytes.len() != public_key_uncompressed.bytes.len());
}

#[test]
fn test_public_key_to_bytes() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let public_key = private_key_to_public_key(private_key);

    let bytes = public_key_to_bytes(public_key);

    assert!(bytes.len() == 33); // Compressed key
    assert!(*bytes.at(0) == 0x02 || *bytes.at(0) == 0x03);
}

#[test]
fn test_public_key_hash() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let public_key = private_key_to_public_key(private_key);

    let hash = public_key_hash(public_key);

    assert!(hash.len() == 20); // Hash160 produces 20 bytes
}

#[test]
fn test_different_public_keys_produce_different_hashes() {
    let key1 = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let key2 = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdee;

    let private_key1 = create_private_key(key1, BitcoinNetwork::Mainnet, true);
    let private_key2 = create_private_key(key2, BitcoinNetwork::Mainnet, true);

    let public_key1 = private_key_to_public_key(private_key1);
    let public_key2 = private_key_to_public_key(private_key2);

    let hash1 = public_key_hash(public_key1);
    let hash2 = public_key_hash(public_key2);

    assert!(hash1 != hash2);
}

#[test]
fn test_generate_private_key() {
    let private_key = generate_private_key(BitcoinNetwork::Mainnet, true);

    assert!(private_key.network == BitcoinNetwork::Mainnet);
    assert!(private_key.compressed == true);
    assert!(private_key.key != 0);
}

#[test]
fn test_generate_private_key_different_networks() {
    let mainnet_key = generate_private_key(BitcoinNetwork::Mainnet, true);
    let testnet_key = generate_private_key(BitcoinNetwork::Testnet, true);

    assert!(mainnet_key.network == BitcoinNetwork::Mainnet);
    assert!(testnet_key.network == BitcoinNetwork::Testnet);

    // Both should be valid but may have same key value (deterministic implementation)
    assert!(mainnet_key.key != 0);
    assert!(testnet_key.key != 0);
}

#[test]
fn test_public_key_x_coordinate_consistency() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let public_key = private_key_to_public_key(private_key);

    let x_coord = public_key.get_x_coordinate();
    assert!(x_coord != 0); // Should be valid coordinate
}

#[test]
fn test_public_key_bytes_consistency() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let public_key = private_key_to_public_key(private_key);

    let bytes1 = public_key_to_bytes(public_key.clone());
    let bytes2 = public_key_to_bytes(public_key);

    assert!(bytes1 == bytes2); // Should be consistent
}

#[test]
fn test_private_key_curve_boundary() {
    // Test with a key very close to the curve order
    let curve_size = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
    let near_max_key = curve_size - 1;

    let private_key = create_private_key(near_max_key, BitcoinNetwork::Mainnet, true);
    let public_key = private_key_to_public_key(private_key);

    assert!(private_key.key == near_max_key);
    assert!(public_key.is_compressed());
    assert!(public_key.bytes.len() == 33);
}

#[test]
fn test_private_key_one() {
    // Test with the smallest valid private key (1)
    let private_key = create_private_key(1, BitcoinNetwork::Mainnet, true);
    let public_key = private_key_to_public_key(private_key);

    assert!(private_key.key == 1);
    assert!(public_key.is_compressed());

    // Should produce a valid, non-zero public key
    let x_coord = public_key.get_x_coordinate();
    assert!(x_coord != 0);
}

#[test]
fn test_public_key_compression_flag_consistency() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    // Test compressed
    let private_key_compressed = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let public_key_compressed = private_key_to_public_key(private_key_compressed);

    assert!(public_key_compressed.is_compressed());
    let first_byte_compressed = public_key_compressed.bytes.at(0).unwrap();
    assert!(first_byte_compressed == 0x02 || first_byte_compressed == 0x03);

    // Test uncompressed
    let private_key_uncompressed = create_private_key(key, BitcoinNetwork::Mainnet, false);
    let public_key_uncompressed = private_key_to_public_key(private_key_uncompressed);

    assert!(!public_key_uncompressed.is_compressed());
    let first_byte_uncompressed = public_key_uncompressed.bytes.at(0).unwrap();
    assert!(first_byte_uncompressed == 0x04);
}

#[test]
fn test_public_key_y_coordinate_extraction() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Mainnet, false);
    let public_key = private_key_to_public_key(private_key);

    // Uncompressed key should have y-coordinate
    let y_coord = public_key.get_y_coordinate();
    assert!(y_coord.is_some());
    assert!(y_coord.unwrap() != 0);

    // Compressed key should not have y-coordinate
    let private_key_compressed = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let public_key_compressed = private_key_to_public_key(private_key_compressed);
    let y_coord_compressed = public_key_compressed.get_y_coordinate();
    assert!(y_coord_compressed.is_none());
}

#[test]
fn test_public_key_coordinates_consistency() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    let private_key_compressed = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let private_key_uncompressed = create_private_key(key, BitcoinNetwork::Mainnet, false);

    let public_key_compressed = private_key_to_public_key(private_key_compressed);
    let public_key_uncompressed = private_key_to_public_key(private_key_uncompressed);

    // Same x-coordinate for both
    assert!(public_key_compressed.get_x_coordinate() == public_key_uncompressed.get_x_coordinate());

    // Different byte lengths
    assert!(public_key_compressed.bytes.len() == 33);
    assert!(public_key_uncompressed.bytes.len() == 65);
}

#[test]
fn test_generate_private_key_uniqueness() {
    // Note: This test depends on the current deterministic implementation
    // In a real implementation with proper randomness, this would be different
    let key1 = generate_private_key(BitcoinNetwork::Mainnet, true);
    let key2 = generate_private_key(BitcoinNetwork::Testnet, true);

    // Keys should be valid
    assert!(key1.key != 0);
    assert!(key2.key != 0);

    // Network should be different
    assert!(key1.network != key2.network);
}

#[test]
fn test_private_key_all_networks() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    let mainnet_key = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let testnet_key = create_private_key(key, BitcoinNetwork::Testnet, true);
    let regtest_key = create_private_key(key, BitcoinNetwork::Regtest, true);

    assert!(mainnet_key.network == BitcoinNetwork::Mainnet);
    assert!(testnet_key.network == BitcoinNetwork::Testnet);
    assert!(regtest_key.network == BitcoinNetwork::Regtest);

    // All should have same key value
    assert!(mainnet_key.key == testnet_key.key);
    assert!(testnet_key.key == regtest_key.key);
}

#[test]
fn test_public_key_hash_deterministic() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let public_key = private_key_to_public_key(private_key);

    // Multiple calls should produce same hash
    let hash1 = public_key_hash(public_key.clone());
    let hash2 = public_key_hash(public_key.clone());
    let hash3 = public_key_hash(public_key);

    assert!(hash1 == hash2);
    assert!(hash2 == hash3);
    assert!(hash1.len() == 20);
}

#[test]
fn test_public_key_bytes_format_validation() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    // Test compressed key format
    let private_key_compressed = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let public_key_compressed = private_key_to_public_key(private_key_compressed);
    let bytes_compressed = public_key_to_bytes(public_key_compressed);

    assert!(bytes_compressed.len() == 33);
    assert!(*bytes_compressed.at(0) == 0x02 || *bytes_compressed.at(0) == 0x03);

    // Test uncompressed key format
    let private_key_uncompressed = create_private_key(key, BitcoinNetwork::Mainnet, false);
    let public_key_uncompressed = private_key_to_public_key(private_key_uncompressed);
    let bytes_uncompressed = public_key_to_bytes(public_key_uncompressed);

    assert!(bytes_uncompressed.len() == 65);
    assert!(*bytes_uncompressed.at(0) == 0x04);
}

#[test]
fn test_multiple_private_keys_unique_public_keys() {
    let mut keys = array![];
    keys.append(0x1);
    keys.append(0x2);
    keys.append(0x3);
    keys.append(0x1000);
    keys.append(0x2000000000000000);

    let mut public_keys = array![];
    let mut i = 0_u32;
    while i < keys.len() {
        let private_key = create_private_key(*keys.at(i), BitcoinNetwork::Mainnet, true);
        let public_key = private_key_to_public_key(private_key);
        public_keys.append(public_key);
        i += 1;
    }

    // All public keys should be different
    let mut i = 0_u32;
    while i < public_keys.len() {
        let mut j = i + 1;
        while j < public_keys.len() {
            let key_i = public_keys.at(i);
            let key_j = public_keys.at(j);
            assert!(key_i.get_x_coordinate() != key_j.get_x_coordinate());
            j += 1;
        }
        i += 1;
    }
}

#[test]
fn test_public_key_coordinates_range() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let private_key = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let public_key = private_key_to_public_key(private_key);

    let x_coord = public_key.get_x_coordinate();

    // X coordinate should be in valid range (less than field prime)
    let field_prime = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
    assert!(x_coord < field_prime);
    assert!(x_coord != 0);
}

#[test]
fn test_public_key_to_coords_conversion() {
    let key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    // Test compressed key conversion
    let private_key_compressed = create_private_key(key, BitcoinNetwork::Mainnet, true);
    let public_key_compressed = private_key_to_public_key(private_key_compressed);
    let coords_compressed = public_key_compressed.to_coords();

    assert!(coords_compressed.compressed == true);
    assert!(coords_compressed.x == public_key_compressed.get_x_coordinate());
    assert!(coords_compressed.y == 0); // y should be 0 for compressed

    // Test uncompressed key conversion
    let private_key_uncompressed = create_private_key(key, BitcoinNetwork::Mainnet, false);
    let public_key_uncompressed = private_key_to_public_key(private_key_uncompressed);
    let coords_uncompressed = public_key_uncompressed.to_coords();

    assert!(coords_uncompressed.compressed == false);
    assert!(coords_uncompressed.x == public_key_uncompressed.get_x_coordinate());
    assert!(coords_uncompressed.y == public_key_uncompressed.get_y_coordinate().unwrap());
}

#[test]
fn test_edge_case_private_keys() {
    // Test with various edge case private keys
    let edge_keys = array![
        0x1, // Minimum valid key
        0x2, // Second minimum
        0x10, // Small key
        0x100, // Slightly larger
        0x1000, // Even larger
        0x123456789abcdef, // Mid-range
        0x1000000000000000, // Large key
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364140 // Near maximum
    ];

    let mut i = 0_u32;
    while i < edge_keys.len() {
        let key = *edge_keys.at(i);
        let private_key = create_private_key(key, BitcoinNetwork::Mainnet, true);
        let public_key = private_key_to_public_key(private_key);

        // All should produce valid public keys
        assert!(public_key.is_compressed());
        assert!(public_key.bytes.len() == 33);
        assert!(public_key.get_x_coordinate() != 0);

        i += 1;
    }
}
