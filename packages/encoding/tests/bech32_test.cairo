use alexandria_encoding::bech32::{Decoder, Encoder, convert_bits};

#[test]
fn test_bech32_encode_decode() {
    let hrp = "bc";
    let data = array![0, 1, 2, 3, 4, 5];

    let encoded = Encoder::encode(hrp, data.span());
    let (decoded_hrp, decoded_data) = Decoder::decode(encoded);

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
    let (decoded_hrp, decoded_data) = Decoder::decode(encoded);

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
    let (decoded_hrp, decoded_data) = Decoder::decode(encoded);

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
    let (decoded_hrp, decoded_data) = Decoder::decode(encoded_max.clone());

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
