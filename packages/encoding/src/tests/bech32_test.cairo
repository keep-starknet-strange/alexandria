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
