use alexandria_encoding::bech32::{Decoder, Encoder, convert_bits};

#[test]
fn test_bech32_encode_decode() {
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
fn test_bech32_with_testnet_hrp() {
    let hrp = "tb";
    let data = array![0, 10, 20, 30];

    let encoded = Encoder::encode(hrp, data.span());
    let (decoded_hrp, decoded_data, _) = Decoder::decode(encoded);

    assert!(decoded_hrp == "tb");
    assert!(decoded_data.len() == data.len());
}

#[test]
fn test_convert_bits_no_padding() {
    let data = array![0xff]; // 11111000
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
fn test_bech32_invalid_format() {
    // Create an invalid string without separator
    let invalid_encoded: ByteArray = "bcqpzry9x8gf2tvdw0s3jn54khce6mua7l";

    // This should fail because there's no '1' separator
    Decoder::decode(invalid_encoded);
}

#[test]
fn test_bech32_long_input() {
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
fn test_bech32_address_length_limits() {
    // Test minimum viable data (should produce address around 26+ chars)
    let min_data = array![0, 1, 2]; // Small dataz
    let encoded_min = Encoder::encode("bc", min_data.span());

    // Verify minimum length encoded address
    assert!(
        encoded_min.len() >= 12, "min length failed",
    ); // hrp(2) + separator(1) + data(3) + checksum(6) = 12 minimum

    // Test maximum allowed data length (65 elements)
    let mut max_data = array![];
    let mut i = 0_u8;
    while i < 65 { // Maximum allowed data length
        max_data.append(i % 32);
        i += 1;
    }

    let encoded_max = Encoder::encode("bc", max_data.span());
    let (decoded_hrp, decoded_data, _) = Decoder::decode(encoded_max.clone());

    // Verify encoding/decoding works for maximum length
    assert!(decoded_hrp == "bc");
    assert!(decoded_data.len() == max_data.len());

    // Verify the encoded address respects BIP-173 90-character limit
    assert!(encoded_max.clone().len() <= 90);
}

#[test]
#[should_panic(expected: "Data payload too long")]
fn test_bech32_data_length_limit_exceeded() {
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
fn test_bech32_total_length_limit_exceeded() {
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
fn test_bech32_hrp_length_limit_exceeded() {
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
fn test_bech32_hrp_too_short() {
    let empty_hrp = "";
    let data = array![0, 1, 2];

    // This should panic due to empty HRP
    Encoder::encode(empty_hrp, data.span());
}

// ============================================================================
// BIP-173 Test Vectors - Valid Bech32 Strings
// Reference: https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki
// ============================================================================

#[test]
fn test_bip173_valid_a12uel5l_lowercase() {
    // BIP-173 valid test vector: a12uel5l
    let encoded: ByteArray = "a12uel5l";
    let (hrp, data, _) = Decoder::decode(encoded);

    assert!(hrp == "a", "HRP should be 'a'");
    assert!(data.len() == 0, "Data should be empty");
}

#[test]
fn test_bip173_valid_long_hrp() {
    // BIP-173 valid test vector: an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1tt5tgs
    let encoded: ByteArray = "an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1tt5tgs";
    let (hrp, data, _) = Decoder::decode(encoded);

    assert!(hrp == "an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio", "HRP should match");
    assert!(data.len() == 0, "Data should be empty after checksum");
}

#[test]
fn test_bip173_valid_abcdef() {
    // BIP-173 valid test vector: abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw
    let encoded: ByteArray = "abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw";
    let (hrp, data, _) = Decoder::decode(encoded);

    assert!(hrp == "abcdef", "HRP should be 'abcdef'");
    assert!(data.len() > 0, "Data should not be empty");
}

#[test]
fn test_bip173_valid_all_ones() {
    // BIP-173 valid test vector: 11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j
    let encoded: ByteArray = "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j";
    let (hrp, data, _) = Decoder::decode(encoded);

    assert!(hrp == "1", "HRP should be '1'");
    assert!(data.len() > 0, "Data should not be empty");
}

#[test]
fn test_bip173_valid_split() {
    // BIP-173 valid test vector: split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w
    let encoded: ByteArray = "split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w";
    let (hrp, data, _) = Decoder::decode(encoded);

    assert!(hrp == "split", "HRP should be 'split'");
    assert!(data.len() > 0, "Data should not be empty");
}

// ============================================================================
// BIP-173 Test Vectors - Invalid Bech32 Strings
// These should fail due to various validation errors
// ============================================================================

#[test]
#[should_panic(expected: "Invalid HRP character")]
fn test_bip173_invalid_a12uel5l_uppercase() {
    // BIP-173 valid test vector: A12UEL5L
    let encoded: ByteArray = "A12UEL5L";
    let (hrp, data, _) = Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid Bech32(m) character")]
fn test_bip173_invalid_a12uel5l_mixed_case() {
    // BIP-173 valid test vector: a12UEL5l
    let encoded: ByteArray = "a12UEL5l";
    let (hrp, data, _) = Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid HRP character")]
fn test_bip173_invalid_question_mark() {
    // BIP-173 valid test vector: ?1ezyfcl
    let encoded: ByteArray = "?1ezyfcl";
    let (hrp, data, _) = Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid HRP character")]
fn test_bip173_invalid_hrp_char_0x20() {
    // BIP-173 Invalid: 0x20 + "1nwldj5" - HRP character out of range
    let mut encoded: ByteArray = "";

    encoded.append_byte(0x20);
    encoded.append_byte('1');
    encoded.append_byte('n');
    encoded.append_byte('w');
    encoded.append_byte('l');
    encoded.append_byte('d');
    encoded.append_byte('j');
    encoded.append_byte('5');

    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid HRP character")]
fn test_bip173_invalid_hrp_char_0x7f() {
    // BIP-173 Invalid: 0x7F + "1axkwrx" - HRP character out of range
    let mut encoded: ByteArray = "";

    encoded.append_byte(0x7F);
    encoded.append_byte('1');
    encoded.append_byte('a');
    encoded.append_byte('x');
    encoded.append_byte('k');
    encoded.append_byte('w');
    encoded.append_byte('r');
    encoded.append_byte('x');

    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid HRP character")]
fn test_bip173_invalid_hrp_char_0x80() {
    // BIP-173 Invalid: 0x80 + "1eym55h" - HRP character out of range
    let mut encoded: ByteArray = "";

    encoded.append_byte(0x80);
    encoded.append_byte('1');
    encoded.append_byte('e');
    encoded.append_byte('y');
    encoded.append_byte('m');
    encoded.append_byte('5');
    encoded.append_byte('5');
    encoded.append_byte('h');

    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Encoded string would exceed maximum length of 90 characters")]
fn test_bip173_invalid_overall_max_length_84chars() {
    // BIP-173 Invalid: an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx
    // overall max length exceeded
    let encoded: ByteArray = "an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "No separator found")]
fn test_bip173_invalid_no_separator() {
    // BIP-173 Invalid: pzry9x0s0muk - No separator character
    let encoded: ByteArray = "pzry9x0s0muk";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "No separator found")]
fn test_bip173_invalid_empty_hrp_1pzry() {
    // BIP-173 Invalid: 1pzry9x0s0muk - Empty HRP
    let encoded: ByteArray = "1pzry9x0s0muk";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid Bech32(m) character")]
fn test_bip173_invalid_data_char_x1b4n0q5v() {
    // BIP-173 Invalid: x1b4n0q5v - Invalid data character
    let encoded: ByteArray = "x1b4n0q5v";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Too short checksum" )]
fn test_bip173_invalid_short_checksum() {
    // BIP-173 Invalid: li1dgmt3 - Too short checksum
    let encoded: ByteArray = "li1dgmt3";
    let (hrp, data, _) = Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Encoded string too short")]
fn test_bip173_invalid_empty_hrp_10a06t8() {
    // BIP-173 Invalid: 10a06t8 - empty HRP
    let encoded: ByteArray = "10a06t8";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Too short checksum")]
fn test_bip173_too_short_checksum_li1dgmt3() {
    // BIP-173 Invalid: li1dgmt3 - invalid checksum
    let encoded: ByteArray = "li1dgmt3";
    Decoder::decode(encoded);
}

#[test]
#[should_panic(expected: "Invalid Bech32(m) character")]
fn test_bip173_invalid_checksum_de1lg7wt() {
    // BIP-173 Invalid: de1lg7wt + 0xFF - invalid checksum
    let mut encoded: ByteArray = "de1lg7wt";

    encoded.append_byte(0xff);

    Decoder::decode(encoded);
}
