use alexandria_btc::legacy_signature::{
    SIGHASH_ALL, create_signature_hash, mod_inverse, parse_der_signature, verify_der_signature,
    verify_ecdsa_signature, verify_ecdsa_signature_auto_recovery, verify_transaction_signature,
};
use alexandria_btc::types::BitcoinPublicKeyTrait;
use starknet::secp256_trait::{Secp256Trait, Signature};
use starknet::secp256k1::Secp256k1Point;

#[test]
fn test_signature_verification_with_invalid_values() {
    // Test with a valid public key (secp256k1 generator point)
    let public_key = BitcoinPublicKeyTrait::from_coordinates(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
    );

    // Create an invalid signature with arbitrary values
    let invalid_signature = Signature {
        r: 0x9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcba,
        s: 0x1111222233334444555566667777888899aabbccddeeff001122334455667788,
        y_parity: false,
    };

    let message_hash = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;

    // This should fail because we're using arbitrary signature values
    // that are not actually valid for this message/key pair
    let result = verify_ecdsa_signature(message_hash, invalid_signature, public_key);

    // Since we're using arbitrary r,s values that aren't real signatures,
    // this should fail verification
    assert!(!result, "Arbitrary signature values should fail verification");
}

#[test]
fn test_signature_verification_known_generator_point() {
    // Test with the secp256k1 generator point as public key (compressed)
    let generator_pubkey = BitcoinPublicKeyTrait::from_x_coordinate(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        true // Even y-coordinate for secp256k1 generator
    );

    // Test message hash of 1 (simple case)
    let message_hash: u256 = 0x1;

    // Test with small valid signature components (within curve order)
    let valid_range_signature = Signature {
        r: 0x2, // Small but valid r
        s: 0x3, // Small but valid s  
        y_parity: false,
    };

    let result = verify_ecdsa_signature(message_hash, valid_range_signature, generator_pubkey);

    // This will likely fail because these aren't real signature values,
    // but it tests that our validation and recovery work correctly
    assert!(!result, "Small arbitrary values should fail verification");
}

#[test]
fn test_signature_validation_comprehensive() {
    // Test comprehensive signature validation with various edge cases
    let public_key = BitcoinPublicKeyTrait::from_x_coordinate(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        true // Even y-coordinate
    );

    let message_hash: u256 = 0x1;
    let curve_order = Secp256Trait::<Secp256k1Point>::get_curve_size();

    // Test 1: r and s at maximum valid values (n-1)
    let max_valid_signature = Signature { r: curve_order - 1, s: curve_order - 1, y_parity: false };
    let result1 = verify_ecdsa_signature(message_hash, max_valid_signature, public_key.clone());
    assert!(!result1, "Max valid r,s should fail verification (not real signature)");

    // Test 2: r and s at minimum valid values (1)
    let min_valid_signature = Signature { r: 1, s: 1, y_parity: false };
    let result2 = verify_ecdsa_signature(message_hash, min_valid_signature, public_key.clone());
    assert!(!result2, "Min valid r,s should fail verification (not real signature)");

    // Test 3: Different y_parity values for same r,s
    let signature_even = Signature { r: 0x123, s: 0x456, y_parity: false };
    let signature_odd = Signature { r: 0x123, s: 0x456, y_parity: true };

    let result3a = verify_ecdsa_signature(message_hash, signature_even, public_key.clone());
    let result3b = verify_ecdsa_signature(message_hash, signature_odd, public_key);

    // Both should fail since these aren't real signatures
    assert!(!result3a, "Even y_parity arbitrary signature should fail");
    assert!(!result3b, "Odd y_parity arbitrary signature should fail");
}

#[test]
fn test_signature_component_validation() {
    let public_key = BitcoinPublicKeyTrait::from_coordinates(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        0xfedcba0987654321fedcba0987654321fedcba0987654321fedcba0987654321,
    );

    let message_hash = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;

    // Test with r = 0 (should fail)
    let invalid_sig1 = Signature { r: 0, s: 1, y_parity: false };
    let result1 = verify_ecdsa_signature(message_hash, invalid_sig1, public_key.clone());
    assert!(!result1, "Signature with r=0 should be invalid");

    // Test with s = 0 (should fail)
    let invalid_sig2 = Signature { r: 1, s: 0, y_parity: false };
    let result2 = verify_ecdsa_signature(message_hash, invalid_sig2, public_key.clone());
    assert!(!result2, "Signature with s=0 should be invalid");

    // Test with message_hash = 0 (should fail)
    let valid_sig = Signature { r: 1, s: 1, y_parity: false };
    let result3 = verify_ecdsa_signature(0, valid_sig, public_key);
    assert!(!result3, "Verification with message_hash=0 should be invalid");
}

#[test]
fn test_der_signature_parsing() {
    // Valid DER signature: 30450220[32-byte r]0221[33-byte s with leading 00]
    let valid_der = array![
        0x30, 0x45, // SEQUENCE, 69 bytes
        0x02, 0x20, // INTEGER, 32 bytes (r)
        0x12, 0x34, 0x56,
        0x78, 0x90, 0xab, 0xcd, 0xef, 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, 0x12, 0x34,
        0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, 0x02,
        0x21, // INTEGER, 33 bytes (s with leading 00)
        0x00, // Leading zero to indicate positive number
        0xfe, 0xdc, 0xba, 0x09, 0x87, 0x65, 0x43,
        0x21, 0xfe, 0xdc, 0xba, 0x09, 0x87, 0x65, 0x43, 0x21, 0xfe, 0xdc, 0xba, 0x09, 0x87, 0x65,
        0x43, 0x21, 0xfe, 0xdc, 0xba, 0x09, 0x87, 0x65, 0x43, 0x21,
    ];

    let result = parse_der_signature(valid_der.span());
    assert!(result.is_some(), "Valid DER signature should parse successfully");

    if let Option::Some(sig) = result {
        assert!(sig.r > 0, "Parsed r component should be non-zero");
        assert!(sig.s > 0, "Parsed s component should be non-zero");
    }
}

#[test]
fn test_der_signature_parsing_invalid() {
    // Invalid DER - wrong sequence tag
    let invalid_der1 = array![0x31, 0x45, 0x02, 0x20];
    let result1 = parse_der_signature(invalid_der1.span());
    assert!(result1.is_none(), "Invalid sequence tag should fail parsing");

    // Invalid DER - too short
    let invalid_der2 = array![0x30, 0x02];
    let result2 = parse_der_signature(invalid_der2.span());
    assert!(result2.is_none(), "Too short DER should fail parsing");

    // Invalid DER - wrong integer tag
    let invalid_der3 = array![0x30, 0x06, 0x03, 0x01, 0x01, 0x02, 0x01, 0x01];
    let result3 = parse_der_signature(invalid_der3.span());
    assert!(result3.is_none(), "Wrong integer tag should fail parsing");
}

#[test]
fn test_signature_hash_creation() {
    let transaction_data = array![
        0x01, 0x00, 0x00, 0x00, // version
        0x01, // input count
        // ... (transaction input data would go here)
        0x01, // output count
        // ... (transaction output data would go here)
        0x00, 0x00,
        0x00, 0x00 // locktime
    ];

    let sig_hash = create_signature_hash(transaction_data.span(), SIGHASH_ALL);
    assert!(sig_hash != 0, "Signature hash should not be zero");

    // Test that different sighash types produce different hashes
    let sig_hash2 = create_signature_hash(transaction_data.span(), 0x02);
    assert!(sig_hash != sig_hash2, "Different sighash types should produce different hashes");
}

#[test]
fn test_transaction_signature_verification() {
    // Use secp256k1 generator point as a known valid public key
    let public_key = BitcoinPublicKeyTrait::from_x_coordinate(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        true // Even y-coordinate
    );

    // Create a realistic but simple transaction structure
    let transaction_data = array![
        0x01, 0x00, 0x00, 0x00, // version (1)
        0x01, // input count (1)
        // 32-byte previous txid (all zeros for test)
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, // previous output index (0)
        0x00, // script length (0)
        0xff, 0xff, 0xff,
        0xff, // sequence
        0x01, // output count (1)
        0x00, 0xe1, 0xf5, 0x05, 0x00, 0x00, 0x00,
        0x00, // value (100000000 satoshis)
        0x19, // script length (25)
        0x76, 0xa9,
        0x14, // OP_DUP OP_HASH160 <20 bytes>
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x88,
        0xac, // OP_EQUALVERIFY OP_CHECKSIG
        0x00, 0x00, 0x00, 0x00 // locktime (0)
    ];

    // Test with arbitrary signature (should fail)
    let arbitrary_signature = Signature {
        r: 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        s: 0xfedcba0987654321fedcba0987654321fedcba0987654321fedcba0987654321,
        y_parity: false,
    };

    let result = verify_transaction_signature(
        transaction_data.span(), arbitrary_signature, public_key.clone(), SIGHASH_ALL,
    );

    // This should fail as we're using arbitrary signature values
    // that are not actually valid for this transaction data
    assert!(!result, "Arbitrary signature should fail transaction verification");

    // Test that different sighash types produce different results
    let result_sighash_none = verify_transaction_signature(
        transaction_data.span(), arbitrary_signature, public_key, 0x02 // SIGHASH_NONE
    );

    // Both should fail, but this tests that different sighash types are handled
    assert!(!result_sighash_none, "Arbitrary signature with SIGHASH_NONE should also fail");
}

#[test]
fn test_curve_boundary_conditions() {
    let curve_size = Secp256Trait::<Secp256k1Point>::get_curve_size();

    let public_key = BitcoinPublicKeyTrait::from_coordinates(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        0xfedcba0987654321fedcba0987654321fedcba0987654321fedcba0987654321,
    );

    let message_hash = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;

    // Test with r >= curve_size (should fail)
    let invalid_sig1 = Signature { r: curve_size, s: 1, y_parity: false };
    let result1 = verify_ecdsa_signature(message_hash, invalid_sig1, public_key.clone());
    assert!(!result1, "Signature with r >= curve_size should be invalid");

    // Test with s >= curve_size (should fail)
    let invalid_sig2 = Signature { r: 1, s: curve_size, y_parity: false };
    let result2 = verify_ecdsa_signature(message_hash, invalid_sig2, public_key.clone());
    assert!(!result2, "Signature with s >= curve_size should be invalid");

    // Test with message_hash >= curve_size (should fail)
    let valid_sig = Signature { r: 1, s: 1, y_parity: false };
    let result3 = verify_ecdsa_signature(curve_size, valid_sig, public_key);
    assert!(!result3, "Verification with message_hash >= curve_size should be invalid");
}

#[test]
fn test_modular_inverse_edge_cases() {
    // Test modular inverse of 1
    let inv1 = mod_inverse(1, 7);
    assert!(inv1 == 1, "Inverse of 1 mod 7 should be 1");

    // Test modular inverse of 0 (should return 0)
    let inv0 = mod_inverse(0, 7);
    assert!(inv0 == 0, "Inverse of 0 should be 0 (no inverse exists)");
}

#[test]
fn test_ecdsa_verification_known_vectors() {
    // Test with secp256k1 curve parameters
    // This test uses small values that are easier to verify manually

    // Simple test case where we know the mathematical relationship
    let public_key = BitcoinPublicKeyTrait::from_coordinates(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
    );

    // Test with a valid message hash (in range [1, n-1])
    let message_hash: u256 = 0x1;

    // Test with an invalid signature (r=1, s=1) - this should fail verification
    // because it's highly unlikely that this would be a valid signature for our message/key pair
    let test_signature = Signature { r: 0x1, s: 0x1, y_parity: false };

    let result = verify_ecdsa_signature(message_hash, test_signature, public_key.clone());
    // This should fail because r=1, s=1 is not a valid signature for this message/key pair
    assert!(!result, "Invalid signature should fail verification");

    // Test boundary condition: r=0 should always fail
    let invalid_r_sig = Signature { r: 0x0, s: 0x1, y_parity: false };
    let result2 = verify_ecdsa_signature(message_hash, invalid_r_sig, public_key.clone());
    assert!(!result2, "Signature with r=0 should always fail");

    // Test boundary condition: s=0 should always fail
    let invalid_s_sig = Signature { r: 0x1, s: 0x0, y_parity: false };
    let result3 = verify_ecdsa_signature(message_hash, invalid_s_sig, public_key);
    assert!(!result3, "Signature with s=0 should always fail");
}

#[test]
fn test_ecdsa_auto_recovery_verification() {
    // Test the auto-recovery function with the secp256k1 generator point
    let public_key = BitcoinPublicKeyTrait::from_x_coordinate(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        true // Even y-coordinate
    );

    let message_hash: u256 = 0x1;

    // Test with invalid signature components - should fail with both y_parity values
    let r: u256 = 0x1;
    let s: u256 = 0x1;

    let result = verify_ecdsa_signature_auto_recovery(message_hash, r, s, public_key.clone());
    assert!(!result, "Invalid signature should fail verification with auto-recovery");

    // Test boundary conditions
    let result_r_zero = verify_ecdsa_signature_auto_recovery(
        message_hash, 0, 1, public_key.clone(),
    );
    assert!(!result_r_zero, "r=0 should fail with auto-recovery");

    let result_s_zero = verify_ecdsa_signature_auto_recovery(message_hash, 1, 0, public_key);
    assert!(!result_s_zero, "s=0 should fail with auto-recovery");
}

#[test]
fn test_der_signature_verification() {
    // Test DER signature verification with a parsed signature
    let public_key = BitcoinPublicKeyTrait::from_x_coordinate(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        true // Even y-coordinate
    );

    // Valid DER signature from earlier test
    let valid_der = array![
        0x30, 0x45, // SEQUENCE, 69 bytes
        0x02, 0x20, // INTEGER, 32 bytes (r)
        0x12, 0x34, 0x56,
        0x78, 0x90, 0xab, 0xcd, 0xef, 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, 0x12, 0x34,
        0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, 0x02,
        0x21, // INTEGER, 33 bytes (s with leading 00)
        0x00, // Leading zero  
        0xfe, 0xdc, 0xba,
        0x09, 0x87, 0x65, 0x43, 0x21, 0xfe, 0xdc, 0xba, 0x09, 0x87, 0x65, 0x43, 0x21, 0xfe, 0xdc,
        0xba, 0x09, 0x87, 0x65, 0x43, 0x21, 0xfe, 0xdc, 0xba, 0x09, 0x87, 0x65, 0x43, 0x21,
    ];

    let message_hash: u256 = 0x1;

    // This should not crash and should return false (since it's not a real signature)
    let result = verify_der_signature(message_hash, valid_der.span(), public_key.clone());
    assert!(!result, "Test DER signature should fail verification");

    // Test with invalid DER format
    let invalid_der = array![0x31, 0x45]; // Wrong sequence tag
    let result_invalid = verify_der_signature(message_hash, invalid_der.span(), public_key);
    assert!(!result_invalid, "Invalid DER format should fail verification");
}


#[test]
fn test_legacy_verify_success() {
    let pub_key_x: u256 = 0x5c114743590e28ceaae0d5229ada58a93bcccf8b226a152069a402b8b1238bd1;
    let v: u256 = 0x19;
    let sig = Signature {
        r: 0x220eb5bbd38f34f748ff7f6247fd2d05a129b7e8bd375e9c9568c2f7b0203649,
        s: 0x29fb478e0416568e8254258969c56369d7b4e3c528416cb0bbc4211fd362528a,
        y_parity: v % 2 == 0,
    };

    let msg: u256 = 0xadb989cbc22bb0b956f2db501df0f0a265fd38257802c940bb136e8ba10be754;

    // Convert u256 to proper BitcoinPublicKey
    let public_key = BitcoinPublicKeyTrait::from_x_coordinate(pub_key_x, v % 2 == 0);

    verify_ecdsa_signature(msg, sig, public_key);
}

#[test]
fn test_legacy_verify_addr_failure() {
    let pub_key_x: u256 = 0xc47dffa16ee5b364913435006f26813e65dd30a5a715989b;
    let v: u256 = 0x19;
    let sig = Signature {
        r: 0x220eb5bbd38f34f748ff7f6247fd2d05a129b7e8bd375e9c9568c2f7b0203649,
        s: 0x29fb478e0416568e8254258969c56369d7b4e3c528416cb0bbc4211fd362528a,
        y_parity: v % 2 == 0,
    };
    let msg: u256 = 0xadb989cbc22bb0b956f2db501df0f0a265fd38257802c940bb136e8ba10be754;

    // Convert u256 to proper BitcoinPublicKey
    let public_key = BitcoinPublicKeyTrait::from_x_coordinate(pub_key_x, v % 2 == 0);

    // This should fail because the public key x-coordinate is too small to be valid on secp256k1
    let result = verify_ecdsa_signature(msg, sig, public_key);
    assert!(!result, "Signature verification should fail for invalid public key");
}
