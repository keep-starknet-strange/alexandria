use alexandria_btc::hash::{
    checksum, hash160, hash160_from_byte_array, hash256, hash256_from_byte_array, sha256,
    sha256_byte_array, sha256_from_byte_array, sha256_u256,
};

#[test]
fn test_sha256_empty_input() {
    let empty_data = array![].span();
    let result = sha256(empty_data);

    assert!(result.len() == 32);
    // SHA256 of empty string is e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
    assert!(*result.at(0) == 0xe3);
    assert!(*result.at(1) == 0xb0);
    assert!(*result.at(2) == 0xc4);
    assert!(*result.at(3) == 0x42);
}

#[test]
fn test_sha256_simple_input() {
    let mut data = array![];
    data.append(0x61); // 'a'
    let result = sha256(data.span());

    assert!(result.len() == 32);
    // SHA256 of 'a' is ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb
    assert!(*result.at(0) == 0xca);
    assert!(*result.at(1) == 0x97);
    assert!(*result.at(2) == 0x81);
    assert!(*result.at(3) == 0x12);
}

#[test]
fn test_hash256_double_sha256() {
    let mut data = array![];
    data.append(0x61); // 'a'
    let result = hash256(data.span());

    assert!(result.len() == 32);
    // Double SHA256 should produce different result than single SHA256
    let single_sha = sha256(data.span());
    assert!(result != single_sha);
}

#[test]
fn test_hash160_bitcoin_format() {
    let mut data = array![];
    data.append(0x21); // Compressed public key prefix
    // Add some dummy public key data
    let mut i = 0_u32;
    while i < 32 {
        data.append(0x12);
        i += 1;
    }

    let result = hash160(data.span());
    assert!(result.len() == 20); // Hash160 always produces 20 bytes
}

#[test]
fn test_checksum_base58check() {
    let mut data = array![];
    data.append(0x00); // Version byte for mainnet P2PKH
    // Add dummy hash160 data
    let mut i = 0_u32;
    while i < 20 {
        data.append(0x12);
        i += 1;
    }

    let result = checksum(data.span());
    assert!(result.len() == 4); // Checksum is always 4 bytes
}

#[test]
fn test_sha256_from_byte_array() {
    let data = "hello";
    let result = sha256_from_byte_array(@data);

    assert!(result.len() == 32);
    // Should produce same result as span version
    let span_data = array![0x68, 0x65, 0x6c, 0x6c, 0x6f]; // "hello"
    let span_result = sha256(span_data.span());
    assert!(result == span_result);
}

#[test]
fn test_hash160_from_byte_array() {
    let data = "test";
    let result = hash160_from_byte_array(@data);

    assert!(result.len() == 20);
    // Should produce same result as span version
    let span_data = array![0x74, 0x65, 0x73, 0x74]; // "test"
    let span_result = hash160(span_data.span());
    assert!(result == span_result);
}

#[test]
fn test_sha256_byte_array_output() {
    let data = "test";
    let result = sha256_byte_array(@data);

    assert!(result.len() == 32);
    // Should produce same result as array version
    let array_result = sha256_from_byte_array(@data);

    // Convert ByteArray to Array<u8> for comparison
    let mut result_array = array![];
    let mut i = 0_u32;
    while i < 32 {
        result_array.append(result.at(i).unwrap());
        i += 1;
    }

    assert!(result_array == array_result);
}

#[test]
fn test_sha256_u256_output() {
    let data = "test";
    let result = sha256_u256(@data);

    // Result should be non-zero for non-empty input
    assert!(result != 0);
}

#[test]
fn test_hash256_from_byte_array() {
    let data = "test";
    let result = hash256_from_byte_array(@data);

    assert!(result.len() == 32);
    // Should produce same result as span version
    let span_data = array![0x74, 0x65, 0x73, 0x74]; // "test"
    let span_result = hash256(span_data.span());
    assert!(result == span_result);
}

#[test]
fn test_hash_consistency() {
    // Test that all variants produce consistent results
    let test_data = "bitcoin";
    let span_data = array![0x62, 0x69, 0x74, 0x63, 0x6f, 0x69, 0x6e]; // "bitcoin"

    let span_sha256 = sha256(span_data.span());
    let ba_sha256 = sha256_from_byte_array(@test_data);

    assert!(span_sha256 == ba_sha256);

    let span_hash160 = hash160(span_data.span());
    let ba_hash160 = hash160_from_byte_array(@test_data);

    assert!(span_hash160 == ba_hash160);
}

#[test]
fn test_different_inputs_produce_different_hashes() {
    let data1 = array![0x01].span();
    let data2 = array![0x02].span();

    let hash1 = sha256(data1);
    let hash2 = sha256(data2);

    assert!(hash1 != hash2);

    let hash160_1 = hash160(data1);
    let hash160_2 = hash160(data2);

    assert!(hash160_1 != hash160_2);
}

#[test]
fn test_sha256_known_vectors() {
    // Test with known SHA256 vectors
    let abc_data = array![0x61, 0x62, 0x63]; // "abc"
    let result = sha256(abc_data.span());

    // SHA256 of "abc" is ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
    assert!(*result.at(0) == 0xba);
    assert!(*result.at(1) == 0x78);
    assert!(*result.at(2) == 0x16);
    assert!(*result.at(3) == 0xbf);
    assert!(*result.at(4) == 0x8f);
    assert!(*result.at(5) == 0x01);
    assert!(*result.at(6) == 0xcf);
    assert!(*result.at(7) == 0xea);
}

#[test]
fn test_hash160_known_vectors() {
    // Test with known compressed public key
    let mut pubkey_data = array![];
    pubkey_data.append(0x02); // Compressed prefix
    // Known x-coordinate: 79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798
    pubkey_data.append(0x79);
    pubkey_data.append(0xBE);
    pubkey_data.append(0x66);
    pubkey_data.append(0x7E);
    pubkey_data.append(0xF9);
    pubkey_data.append(0xDC);
    pubkey_data.append(0xBB);
    pubkey_data.append(0xAC);
    pubkey_data.append(0x55);
    pubkey_data.append(0xA0);
    pubkey_data.append(0x62);
    pubkey_data.append(0x95);
    pubkey_data.append(0xCE);
    pubkey_data.append(0x87);
    pubkey_data.append(0x0B);
    pubkey_data.append(0x07);
    pubkey_data.append(0x02);
    pubkey_data.append(0x9B);
    pubkey_data.append(0xFC);
    pubkey_data.append(0xDB);
    pubkey_data.append(0x2D);
    pubkey_data.append(0xCE);
    pubkey_data.append(0x28);
    pubkey_data.append(0xD9);
    pubkey_data.append(0x59);
    pubkey_data.append(0xF2);
    pubkey_data.append(0x81);
    pubkey_data.append(0x5B);
    pubkey_data.append(0x16);
    pubkey_data.append(0xF8);
    pubkey_data.append(0x17);
    pubkey_data.append(0x98);

    let result = hash160(pubkey_data.span());
    assert!(result.len() == 20);
    // First few bytes should be deterministic
    assert!(*result.at(0) == 0x75);
    assert!(*result.at(1) == 0x1E);
}

#[test]
fn test_large_data_hashing() {
    // Test with larger data chunks
    let mut large_data = array![];
    let mut i = 0_u32;
    while i < 1000 {
        large_data.append((i % 256).try_into().unwrap());
        i += 1;
    }

    let sha256_result = sha256(large_data.span());
    let hash160_result = hash160(large_data.span());
    let hash256_result = hash256(large_data.span());

    assert!(sha256_result.len() == 32);
    assert!(hash160_result.len() == 20);
    assert!(hash256_result.len() == 32);

    // Results should be deterministic
    let sha256_result2 = sha256(large_data.span());
    assert!(sha256_result == sha256_result2);
}

#[test]
fn test_checksum_real_address_data() {
    // Test checksum with real mainnet P2PKH address data
    let mut addr_data = array![];
    addr_data.append(0x00); // Mainnet P2PKH version
    // Real hash160: 89ABCDEFABBAABBAABBAABBAABBAABBAABBAABBA
    addr_data.append(0x89);
    addr_data.append(0xAB);
    addr_data.append(0xCD);
    addr_data.append(0xEF);
    addr_data.append(0xAB);
    addr_data.append(0xBA);
    addr_data.append(0xAB);
    addr_data.append(0xBA);
    addr_data.append(0xAB);
    addr_data.append(0xBA);
    addr_data.append(0xAB);
    addr_data.append(0xBA);
    addr_data.append(0xAB);
    addr_data.append(0xBA);
    addr_data.append(0xAB);
    addr_data.append(0xBA);
    addr_data.append(0xAB);
    addr_data.append(0xBA);
    addr_data.append(0xAB);
    addr_data.append(0xBA);
    addr_data.append(0xAB);

    let checksum_result = checksum(addr_data.span());
    assert!(checksum_result.len() == 4);

    // Should be reproducible
    let checksum_result2 = checksum(addr_data.span());
    assert!(checksum_result == checksum_result2);
}

#[test]
fn test_hash256_vs_double_sha256() {
    let test_data = array![0x48, 0x65, 0x6c, 0x6c, 0x6f]; // "Hello"

    // Test hash256 function
    let hash256_result = hash256(test_data.span());

    // Test manual double SHA256
    let first_sha = sha256(test_data.span());
    let second_sha = sha256(first_sha.span());

    assert!(hash256_result == second_sha);
    assert!(hash256_result.len() == 32);
}

#[test]
fn test_empty_vs_single_byte() {
    let empty_data = array![].span();
    let single_byte = array![0x00].span();

    let empty_sha = sha256(empty_data);
    let single_sha = sha256(single_byte);

    assert!(empty_sha != single_sha);

    let empty_hash160 = hash160(empty_data);
    let single_hash160 = hash160(single_byte);

    assert!(empty_hash160 != single_hash160);
}

#[test]
fn test_sha256_u256_range() {
    // Test that u256 output is within valid range
    let test_data = "test_u256_range";
    let result = sha256_u256(@test_data);

    // Should be non-zero for non-empty input
    assert!(result != 0);

    // Should be less than 2^256
    let max_u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    assert!(result <= max_u256);
}

#[test]
fn test_hash_avalanche_effect() {
    // Test that small changes in input produce large changes in output
    let data1 = array![0x00, 0x01, 0x02, 0x03];
    let data2 = array![0x00, 0x01, 0x02, 0x04]; // Only last byte different

    let hash1 = sha256(data1.span());
    let hash2 = sha256(data2.span());

    // Should be completely different
    assert!(hash1 != hash2);

    // Count different bytes (should be many due to avalanche effect)
    let mut different_bytes = 0_u32;
    let mut i = 0_u32;
    while i < 32 {
        if *hash1.at(i) != *hash2.at(i) {
            different_bytes += 1;
        }
        i += 1;
    }

    // Should have many different bytes due to avalanche effect
    assert!(different_bytes > 10);
}

#[test]
fn test_all_zero_input() {
    // Test with all zero input
    let mut zero_data = array![];
    let mut i = 0_u32;
    while i < 32 {
        zero_data.append(0x00);
        i += 1;
    }

    let sha256_result = sha256(zero_data.span());
    let hash160_result = hash160(zero_data.span());
    let hash256_result = hash256(zero_data.span());

    assert!(sha256_result.len() == 32);
    assert!(hash160_result.len() == 20);
    assert!(hash256_result.len() == 32);

    // Results should be deterministic and not all zeros
    assert!(*sha256_result.at(0) != 0 || *sha256_result.at(1) != 0);
    assert!(*hash160_result.at(0) != 0 || *hash160_result.at(1) != 0);
}

#[test]
fn test_all_ff_input() {
    // Test with all 0xFF input
    let mut ff_data = array![];
    let mut i = 0_u32;
    while i < 32 {
        ff_data.append(0xFF);
        i += 1;
    }

    let sha256_result = sha256(ff_data.span());
    let hash160_result = hash160(ff_data.span());

    assert!(sha256_result.len() == 32);
    assert!(hash160_result.len() == 20);

    // Should be different from all-zero input
    let mut zero_data = array![];
    let mut i = 0_u32;
    while i < 32 {
        zero_data.append(0x00);
        i += 1;
    }

    let zero_sha256 = sha256(zero_data.span());
    let zero_hash160 = hash160(zero_data.span());

    assert!(sha256_result != zero_sha256);
    assert!(hash160_result != zero_hash160);
}
