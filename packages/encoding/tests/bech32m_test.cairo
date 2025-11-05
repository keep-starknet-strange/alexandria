use alexandria_encoding::bech32::convert_bits;
use alexandria_encoding::bech32m::{Decoder, Encoder};

#[test]
fn test_bech32m_encode_decode() {
    let hrp = "bc";
    let data = array![0, 1, 2, 3, 4, 5];

    let encoded = Encoder::encode(hrp, data.span());
    let (decoded_hrp, decoded_data, _) = Decoder::decode(encoded);

    // Check HRP matches
    assert!(decoded_hrp == "bc");

    // Check data matches
    assert!(decoded_data.len() == data.len());
    let mut i = 0;
    while i < data.len() {
        assert!(*decoded_data.at(i) == *data.at(i));
        i += 1;
    };
}

#[test]
fn test_bech32m_with_testnet_hrp() {
    let hrp = "tb";
    let data = array![0, 10, 20, 30];

    let encoded = Encoder::encode(hrp, data.span());
    let (decoded_hrp, decoded_data, _) = Decoder::decode(encoded);

    assert!(decoded_hrp == "tb");
    assert!(decoded_data.len() == data.len());
}

#[test]
fn test_convert_bits_no_padding() {
    let data = array![0xff]; // 8 bits
    let converted = convert_bits(data.span(), 8, 5, false);

    // Should convert without padding
    assert!(converted.len() > 0);
}

#[test]
fn test_convert_bits_with_padding() {
    let data = array![0xff]; // 8 bits
    let converted = convert_bits(data.span(), 8, 5, true);

    // Should convert with padding
    assert!(converted.len() > 0);
}

#[test]
fn test_convert_bits_valid_conversion() {
    let data = array![0xff]; // 8 bits
    let converted = convert_bits(data.span(), 8, 5, true);

    // Should convert successfully
    assert!(converted.len() > 0);
}

#[test]
#[should_panic]
fn test_bech32m_invalid_format() {
    // Create an invalid string without separator
    let invalid_encoded: ByteArray = "bcqpzry9x8gf2tvdw0s3jn54khce6mua7l";

    // This should fail because there's no '1' separator
    Decoder::decode(invalid_encoded);
}

#[test]
fn test_bech32m_long_input() {
    let hrp = "bc";
    // Create a long data array with 50 elements (reasonable for testing)
    let mut long_data = array![];
    let mut i = 0_u8;
    while i < 50 {
        long_data.append(i % 32); // Keep values within valid Bech32 range (0-31)
        i += 1;
    }

    let encoded = Encoder::encode(hrp, long_data.span());
    let (decoded_hrp, decoded_data, _) = Decoder::decode(encoded);

    // Verify HRP matches
    assert!(decoded_hrp == "bc");

    // Verify data length matches
    assert!(decoded_data.len() == long_data.len());

    // Verify data content matches
    let mut j = 0;
    while j < long_data.len() {
        assert!(*decoded_data.at(j) == *long_data.at(j));
        j += 1;
    };
}

#[test]
fn test_bech32m_address_length_limits() {
    // Test minimum viable data (should produce address around 26+ chars)
    let min_data = array![0, 1, 2]; // Small data
    let encoded_min = Encoder::encode("bc", min_data.span());

    // Verify minimum length encoded address
    assert!(
        encoded_min.len() >= 12, "min length failed",
    ); // hrp(2) + separator(1) + data(3) + checksum(6) = 12 minimum

    // Test maximum allowed data length (50 elements for "bc" to stay ≤90 chars)
    let mut max_data = array![];
    let mut i = 0_u8;
    while i < 50 { // Adjusted to avoid exceeding 90 chars
        max_data.append(i % 32);
        i += 1;
    }

    let encoded_max = Encoder::encode("bc", max_data.span());
    let (decoded_hrp, decoded_data, _) = Decoder::decode(encoded_max.clone());

    // Verify encoding/decoding works for maximum length
    assert!(decoded_hrp == "bc");
    assert!(decoded_data.len() == max_data.len());

    // Verify the encoded address respects BIP-350 90-character limit
    assert!(encoded_max.clone().len() <= 90);
}

#[test]
#[should_panic(expected: "Data payload too long")]
fn test_bech32m_data_length_limit_exceeded() {
    let hrp = "bc";

    // Test with data length exceeding the 65-element limit
    let mut too_long_data = array![];
    let mut i = 0_u8;
    while i < 66 { // Exceeds the 65-element limit
        too_long_data.append(i % 32);
        i += 1;
    }

    // This should panic due to data length exceeding limit
    Encoder::encode(hrp, too_long_data.span());
}

#[test]
#[should_panic(expected: "Encoded string would exceed maximum length of 90 characters")]
fn test_bech32m_total_length_limit_exceeded() {
    let hrp = "verylonghrpthatexceedslimit"; // 28 chars

    // Use 57 data elements: hrp(28) + separator(1) + data(57) + checksum(6) = 92 chars > 90
    let mut data = array![];
    let mut i = 0_u8;
    while i < 57 { // This should cause total to exceed 90 chars
        data.append(i % 32);
        i += 1;
    }

    // This should panic due to total length exceeding 90 characters
    Encoder::encode(hrp, data.span());
}

#[test]
#[should_panic(expected: "HRP too long")]
fn test_bech32m_hrp_length_limit_exceeded() {
    // Create an HRP that exceeds 83 characters
    let mut very_long_hrp = "";
    let mut i = 0_u8;
    while i < 84 { // Exceeds 83 character limit
        very_long_hrp.append_byte('a');
        i += 1;
    }

    let data = array![0, 1, 2];

    // This should panic due to HRP being too long
    Encoder::encode(very_long_hrp, data.span());
}

#[test]
#[should_panic(expected: "HRP too short")]
fn test_bech32m_hrp_too_short() {
    let empty_hrp = "";
    let data = array![0, 1, 2];

    // This should panic due to empty HRP
    Encoder::encode(empty_hrp, data.span());
}

// ============================================================================
// BIP-350 Test Vectors - Valid Bech32 Strings
// Reference: https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
// ============================================================================

#[test]
fn test_bip350_valid_a1lqfn3a_lowercase() {
    // BIP-350 valid test vector: a1lqfn3a
    let encoded: ByteArray = "a1lqfn3a";
    let (hrp, data, _) = Decoder::decode(encoded);

    assert!(hrp == "a", "HRP should be 'a'");
    assert!(data.len() == 0, "Data should be empty");
}

#[test]
fn test_bip350_valid_long_hrp() {
    // BIP-350 valid test vector:
    // an83characterlonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11sg7hg6
    let encoded: ByteArray =
        "an83characterlonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11sg7hg6";
    let (hrp, data, _) = Decoder::decode(encoded);

    assert!(
        hrp == "an83characterlonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber1",
        "HRP should match",
    );
    assert!(data.len() == 0, "Data should be empty after checksum");
}

#[test]
fn test_bip350_valid_abcdef() {
    // BIP-350 valid test vector: abcdef1l7aum6echk45nj3s0wdvt2fg8x9yrzpqzd3ryx
    let encoded: ByteArray = "abcdef1l7aum6echk45nj3s0wdvt2fg8x9yrzpqzd3ryx";
    let (hrp, data, _) = Decoder::decode(encoded);

    assert!(hrp == "abcdef", "HRP should be 'abcdef'");
    assert!(data.len() > 0, "Data should not be empty");
}

#[test]
fn test_bip350_valid_all_ones() {
    // BIP-350 valid test vector:
    // 11llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllludsr8
    let encoded: ByteArray =
        "11llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllludsr8";
    let (hrp, data, _) = Decoder::decode(encoded);

    assert!(hrp == "1", "HRP should be '1'");
    assert!(data.len() > 0, "Data should not be empty");
}

#[test]
fn test_bip350_valid_split() {
    // BIP-350 valid test vector: split1checkupstagehandshakeupstreamerranterredcaperredlc445v
    let encoded: ByteArray = "split1checkupstagehandshakeupstreamerranterredcaperredlc445v";
    let (hrp, data, _) = Decoder::decode(encoded);

    assert!(hrp == "split", "HRP should be 'split'");
    assert!(data.len() > 0, "Data should not be empty");
}

// ============================================================================
// BIP-350 Test Vectors - Invalid Bech32 Strings
// These should fail due to various validation errors
// ============================================================================

#[test]
#[should_panic(expected: "Invalid HRP character")]
fn test_bip350_invalid_a1lqfn3a_uppercase() {
    // BIP-350 valid test vector: A1LQFN3A
    let encoded: ByteArray = "A1LQFN3A";
    let (hrp, data, _) = Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid Bech32(m) character")]
fn test_bip350_invalid_a1lqfn3a_mixed_case() {
    // BIP-350 valid test vector: a1lQfn3A
    let encoded: ByteArray = "a1lQfn3A";
    let (hrp, data, _) = Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid HRP character")]
fn test_bip350_invalid_question_mark() {
    // BIP-350 valid test vector: ?1v759aa
    let encoded: ByteArray = "?1v759aa";
    let (hrp, data, _) = Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid HRP character")]
fn test_bip350_invalid_hrp_char_0x20() {
    // BIP-350 Invalid: 0x20 + "1xj0phk" - HRP character out of range
    let mut encoded: ByteArray = "";

    encoded.append_byte(0x20);
    encoded.append_byte('1');
    encoded.append_byte('x');
    encoded.append_byte('j');
    encoded.append_byte('0');
    encoded.append_byte('p');
    encoded.append_byte('h');
    encoded.append_byte('k');

    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid HRP character")]
fn test_bip350_invalid_hrp_char_0x7f() {
    // BIP-350 Invalid: 0x7F + "1g6xzxy" - HRP character out of range
    let mut encoded: ByteArray = "";

    encoded.append_byte(0x7F);
    encoded.append_byte('1');
    encoded.append_byte('g');
    encoded.append_byte('6');
    encoded.append_byte('x');
    encoded.append_byte('z');
    encoded.append_byte('x');
    encoded.append_byte('y');

    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid HRP character")]
fn test_bip350_invalid_hrp_char_0x80() {
    // BIP-350 Invalid: 0x80 + "1vctc34" - HRP character out of range
    let mut encoded: ByteArray = "";

    encoded.append_byte(0x80);
    encoded.append_byte('1');
    encoded.append_byte('v');
    encoded.append_byte('c');
    encoded.append_byte('t');
    encoded.append_byte('c');
    encoded.append_byte('3');
    encoded.append_byte('4');

    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Encoded string would exceed maximum length of 90 characters")]
fn test_bip350_invalid_overall_max_length_84chars() {
    // BIP-350 Invalid:
    // an84characterslonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11d6pts4
    // overall max length exceeded
    let encoded: ByteArray =
        "an84characterslonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11d6pts4";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "No separator found")]
fn test_bip350_invalid_no_separator() {
    // BIP-350 Invalid: qyrz8wqd2c9m - No separator character
    let encoded: ByteArray = "qyrz8wqd2c9m";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "No separator found")]
fn test_bip350_invalid_empty_hrp_1pzry() {
    // BIP-350 Invalid: 1qyrz8wqd2c9m - Empty HRP
    let encoded: ByteArray = "1qyrz8wqd2c9m";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid Bech32(m) character")]
fn test_bip350_invalid_data_char_y1b0jsk6g() {
    // BIP-350 Invalid: y1b0jsk6g - Invalid data character
    let encoded: ByteArray = "y1b0jsk6g";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid Bech32(m) character")]
fn test_bip350_invalid_data_char_lt1igcx5c0() {
    // BIP-350 Invalid: lt1igcx5c0 - Invalid data character
    let encoded: ByteArray = "lt1igcx5c0";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Too short checksum")]
fn test_bip350_invalid_short_checksum() {
    // BIP-350 Invalid: in1muywd - Too short checksum
    let encoded: ByteArray = "in1muywd";
    let (hrp, data, _) = Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Encoded string too short")]
fn test_bip350_invalid_empty_hrp_16plkw9() {
    // BIP-350 Invalid: 16plkw9 - empty HRP
    let encoded: ByteArray = "16plkw9";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Too short checksum")]
fn test_bip350_too_short_checksum_in1muywd() {
    // BIP-173 Invalid: in1muywd - invalid checksum
    let encoded: ByteArray = "in1muywd";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid Bech32(m) character")]
fn test_bip350_invalid_checksum_mm1crxm3i() {
    // BIP-173 Invalid: mm1crxm3i - invalid checksum
    let encoded: ByteArray = "mm1crxm3i";
    Decoder::decode(encoded);
}
