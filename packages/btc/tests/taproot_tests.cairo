use alexandria_btc::address::public_key_to_address;
use alexandria_btc::keys::{create_private_key, private_key_to_public_key};
use alexandria_btc::taproot::{
    calculate_merkle_root, create_key_path_output, create_script_path_output, create_script_tree,
    tagged_hash, tweak_public_key, u256_to_32_bytes_be, verify_taproot_signature,
};
use alexandria_btc::types::{BitcoinAddressType, BitcoinNetwork};

#[test]
fn test_tagged_hash() {
    let tag1: ByteArray = "TapTweak";
    let tag2: ByteArray = "TapLeaf";
    let data = array![0x01, 0x02, 0x03, 0x04];

    let hash = tagged_hash(tag1.clone(), data.span());

    assert!(hash.len() == 32, "Tagged hash should be 32 bytes");

    // Tagged hash should be deterministic
    let hash2 = tagged_hash(tag1.clone(), data.span());
    assert!(hash == hash2, "Tagged hash should be deterministic");

    // Different tags should produce different hashes
    let hash3 = tagged_hash(tag2, data.span());
    assert!(hash != hash3, "Different tags should produce different hashes");
}

#[test]
fn test_key_tweaking() {
    // Test with a valid internal key
    let internal_key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    let tweaked_result = tweak_public_key(internal_key, Option::None);

    match tweaked_result {
        Option::Some(tweaked) => {
            assert!(
                tweaked.output_key != internal_key,
                "Output key should be different from internal key",
            );
            assert!(tweaked.output_key > 0, "Output key should be non-zero");
        },
        Option::None => { assert!(false, "Key tweaking should succeed for valid internal key"); },
    }
}

#[test]
fn test_key_tweaking_with_merkle_root() {
    let internal_key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let merkle_root = 0xfedcba0987654321fedcba0987654321fedcba0987654321fedcba0987654321;

    let tweaked_result = tweak_public_key(internal_key, Option::Some(merkle_root));

    match tweaked_result {
        Option::Some(tweaked) => {
            assert!(
                tweaked.output_key != internal_key,
                "Output key should be different from internal key",
            );

            // Compare with key-path only tweaking
            let key_path_result = tweak_public_key(internal_key, Option::None);
            match key_path_result {
                Option::Some(key_path_tweaked) => {
                    assert!(
                        tweaked.output_key != key_path_tweaked.output_key,
                        "Script-path and key-path should produce different outputs",
                    );
                },
                Option::None => { assert!(false, "Key-path tweaking should also succeed"); },
            }
        },
        Option::None => { assert!(false, "Key tweaking with merkle root should succeed"); },
    }
}

#[test]
fn test_u256_to_32_bytes_conversion() {
    let value = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let bytes = u256_to_32_bytes_be(value);

    assert!(bytes.len() == 32, "Should convert to exactly 32 bytes");
    assert!(*bytes.at(0) == 0x12, "First byte should be 0x12 (big-endian)");
    assert!(*bytes.at(31) == 0xef, "Last byte should be 0xef");

    // Test with zero
    let zero_bytes = u256_to_32_bytes_be(0);
    assert!(zero_bytes.len() == 32, "Zero should also convert to 32 bytes");

    let mut all_zero = true;
    let mut i = 0;
    while i < 32 {
        if *zero_bytes.at(i) != 0 {
            all_zero = false;
            break;
        }
        i += 1;
    }
    assert!(all_zero, "All bytes should be zero for input 0");
}

#[test]
fn test_create_key_path_output() {
    let internal_key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    let output = create_key_path_output(internal_key);

    match output {
        Option::Some(tweaked) => {
            assert!(tweaked.output_key != internal_key, "Key-path output should be tweaked");
        },
        Option::None => { assert!(false, "Key-path output creation should succeed"); },
    }
}

#[test]
fn test_script_tree_operations() {
    let script = array![0x51]; // OP_1 (simple script)
    let leaf_version = 0xc0;

    let script_tree = create_script_tree(script, leaf_version);
    let merkle_root = calculate_merkle_root(@script_tree);

    match merkle_root {
        Option::Some(root) => {
            assert!(root > 0, "Merkle root should be non-zero for non-empty tree");
        },
        Option::None => { assert!(false, "Should have merkle root for tree with script"); },
    }

    // Test empty tree
    let empty_tree = create_script_tree(array![], 0xc0);
    let _empty_root = calculate_merkle_root(@empty_tree);
    // Note: Current implementation will still return Some for empty script
// In a more complete implementation, you might handle this differently
}

#[test]
fn test_create_script_path_output() {
    let internal_key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    let script = array![0x51]; // OP_1
    let script_tree = create_script_tree(script, 0xc0);

    let output = create_script_path_output(internal_key, @script_tree);

    match output {
        Option::Some(tweaked) => {
            // Compare with key-path only output
            let key_path_output = create_key_path_output(internal_key);
            match key_path_output {
                Option::Some(key_path_tweaked) => {
                    assert!(
                        tweaked.output_key != key_path_tweaked.output_key,
                        "Script-path and key-path should differ",
                    );
                },
                Option::None => { assert!(false, "Key-path output should also succeed"); },
            }
        },
        Option::None => { assert!(false, "Script-path output creation should succeed"); },
    }
}

#[test]
fn test_p2tr_address_generation() {
    let private_key = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Mainnet,
        true,
    );

    let public_key = private_key_to_public_key(private_key);
    let address = public_key_to_address(
        public_key, BitcoinAddressType::P2TR, BitcoinNetwork::Mainnet,
    );

    // Check address properties
    assert!(address.address_type == BitcoinAddressType::P2TR, "Should be P2TR address type");
    assert!(address.network == BitcoinNetwork::Mainnet, "Should be mainnet address");
    assert!(address.address.len() > 0, "Address should not be empty");

    // Check script pubkey format: OP_1 <32-byte-key>
    assert!(address.script_pubkey.len() == 34, "P2TR script pubkey should be 34 bytes");
    assert!(address.script_pubkey.at(0).unwrap() == 0x51, "Should start with OP_1");
    assert!(address.script_pubkey.at(1).unwrap() == 0x20, "Should push 32 bytes");

    // Check that address starts with correct Bech32m prefix for mainnet P2TR
    // P2TR addresses should start with "bc1p" (witness version 1 with Bech32m encoding)
    assert!(address.address.len() >= 4, "Address should be at least 4 characters long");
    assert!(address.address.at(0).unwrap() == 'b', "Should start with 'b'");
    assert!(address.address.at(1).unwrap() == 'c', "Should have 'c' as second character");
    assert!(
        address.address.at(2).unwrap() == '1', "Should have '1' as third character (separator)",
    );
    assert!(
        address.address.at(3).unwrap() == 'p',
        "Should have 'p' as fourth character (witness version 1 in Bech32m)",
    );

    // Verify full prefix
    let expected_prefix: ByteArray = "bc1p";
    let mut i = 0_u32;
    while i < 4 {
        assert!(
            address.address.at(i).unwrap() == expected_prefix.at(i).unwrap(),
            "P2TR address should start with bc1p prefix",
        );
        i += 1;
    };
}

#[test]
fn test_taproot_signature_verification_interface() {
    // Test the signature verification interface (with dummy data)
    let signature_bytes = array![
        // 32 bytes r
        0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd,
        0xef, 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef, 0x12, 0x34, 0x56, 0x78, 0x90, 0xab,
        0xcd, 0xef, // 32 bytes s
        0xfe, 0xdc, 0xba, 0x09, 0x87, 0x65, 0x43, 0x21, 0xfe, 0xdc, 0xba,
        0x09, 0x87, 0x65, 0x43, 0x21, 0xfe, 0xdc, 0xba, 0x09, 0x87, 0x65, 0x43, 0x21, 0xfe, 0xdc,
        0xba, 0x09, 0x87, 0x65, 0x43, 0x21,
    ];

    let message1: ByteArray = "Hello, Taproot!";
    let message2: ByteArray = "Hello, Taproot!";
    let public_key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    // This will likely return false since we're using dummy data,
    // but it tests that the interface works
    let result = verify_taproot_signature(signature_bytes.span(), message1, public_key);

    // Just verify the function doesn't panic and returns false for dummy data
    assert!(!result, "Dummy signature should fail verification");

    // Test with wrong signature length
    let wrong_sig = array![0x12, 0x34]; // Too short
    let result2 = verify_taproot_signature(wrong_sig.span(), message2, public_key);
    assert!(!result2, "Should reject signature with wrong length");
}

#[test]
fn test_deterministic_tweaking() {
    let internal_key = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    // Key tweaking should be deterministic
    let result1 = tweak_public_key(internal_key, Option::None);
    let result2 = tweak_public_key(internal_key, Option::None);

    match (result1, result2) {
        (
            Option::Some(tweaked1), Option::Some(tweaked2),
        ) => {
            assert!(tweaked1.output_key == tweaked2.output_key, "Tweaking should be deterministic");
            assert!(tweaked1.parity == tweaked2.parity, "Parity should also be deterministic");
        },
        _ => { assert!(false, "Both tweaking operations should succeed"); },
    }
}
