use alexandria_encoding::base64::{
    Base64ByteArrayDecoder, Base64ByteArrayEncoder, Base64ByteArrayUrlEncoder,
};

#[test]
#[available_gas(2000000000)]
fn base64_encode_ba_empty_test() {
    let result = Base64ByteArrayEncoder::encode(Default::default());
    assert_eq!(result.len(), 0);
}

#[test]
#[available_gas(2000000000)]
fn base64_encode_ba_simple_test() {
    let mut ba: ByteArray = "a";

    let result = Base64ByteArrayEncoder::encode(ba);
    assert_eq!(result.len(), 4);
    assert_eq!(result.at(0).unwrap(), 'Y');
    assert_eq!(result.at(1).unwrap(), 'Q');
    assert_eq!(result.at(2).unwrap(), '=');
    assert_eq!(result.at(3).unwrap(), '=');
}

#[test]
#[available_gas(2000000000)]
fn base64_encode_ba_hello_world_test() {
    let mut ba: ByteArray = "hello world";

    let result = Base64ByteArrayEncoder::encode(ba);
    assert_eq!(result.len(), 16);
    let mut expected_ba: ByteArray = "aGVsbG8gd29ybGQ=";
    assert_eq!(result, expected_ba);
}

#[test]
#[available_gas(2000000000)]
fn base64_decode_ba_empty_test() {
    let result = Base64ByteArrayDecoder::decode(Default::default());
    assert_eq!(result.len(), 0);
}

#[test]
#[available_gas(2000000000)]
fn base64_decode_ba_simple_test() {
    let mut ba: ByteArray = "YQ==";

    let result = Base64ByteArrayDecoder::decode(ba);
    assert_eq!(result.len(), 1);
    let mut expected_ba: ByteArray = "a";
    assert_eq!(result, expected_ba);
}

#[test]
#[available_gas(2000000000)]
fn base64_decode_ba_hello_world_test() {
    let mut ba: ByteArray = "aGVsbG8gd29ybGQ=";

    let result = Base64ByteArrayDecoder::decode(ba);
    assert_eq!(result.len(), 11);
    let mut expected_ba: ByteArray = "hello world";
    assert_eq!(result, expected_ba);
}

#[test]
#[available_gas(2000000000)]
fn base64_encode_ba_with_plus_and_slash() {
    let mut ba: ByteArray = Default::default();
    ba.append_byte(255);
    ba.append_byte(239);

    let result = Base64ByteArrayEncoder::encode(ba);
    let mut expected_ba: ByteArray = "/+8=";
    assert_eq!(result.len(), 4);
    assert_eq!(result, expected_ba);
}

#[test]
#[available_gas(2000000000)]
fn base64_url_encode_ba_with_plus_and_slash() {
    let mut ba: ByteArray = Default::default();
    ba.append_byte(255);
    ba.append_byte(239);

    let result = Base64ByteArrayUrlEncoder::encode(ba);
    let mut expected_ba: ByteArray = "_-8=";
    assert_eq!(result.len(), 4);
    assert_eq!(result, expected_ba);
}

#[test]
#[available_gas(2000000000)]
fn base64_decode_ba_with_plus_and_slash() {
    let mut ba: ByteArray = "/+8=";

    let result = Base64ByteArrayDecoder::decode(ba);
    assert_eq!(result.len(), 2);
    assert_eq!(result.at(0).unwrap(), 255);
    assert_eq!(result.at(1).unwrap(), 239);
}

#[test]
#[available_gas(2000000000)]
fn base64_url_decode_ba_with_plus_and_slash() {
    let mut ba: ByteArray = "_-8=";

    let result = Base64ByteArrayDecoder::decode(ba);
    assert_eq!(result.len(), 2);
    assert_eq!(result.at(0).unwrap(), 255);
    assert_eq!(result.at(1).unwrap(), 239);
}

#[test]
#[available_gas(2000000000)]
fn base64_ba_round_trip_test() {
    // Basic round trip test for "Test"
    let mut ba: ByteArray = "Test";
    let encoded1 = Base64ByteArrayEncoder::encode(ba.clone());
    let decoded1 = Base64ByteArrayDecoder::decode(encoded1);

    assert_eq!(decoded1.len(), ba.len(), "Round trip length mismatch for Test");
    assert_eq!(decoded1, ba);

    // Round trip test for "Test1" (5 bytes - 1 padding char)
    let mut ba: ByteArray = "Test1";
    let encoded1 = Base64ByteArrayEncoder::encode(ba.clone());
    let decoded1 = Base64ByteArrayDecoder::decode(encoded1);

    assert_eq!(decoded1.len(), ba.len(), "Round trip length mismatch for Test");
    assert_eq!(decoded1, ba);

    // Round trip test for "Test12" (6 bytes - 2 padding chars)
    let mut ba: ByteArray = "Test12";
    let encoded1 = Base64ByteArrayEncoder::encode(ba.clone());
    let decoded1 = Base64ByteArrayDecoder::decode(encoded1);

    assert_eq!(decoded1.len(), ba.len(), "Round trip length mismatch for Test");
    assert_eq!(decoded1, ba);

    // // Round trip test for "Test123" (7 bytes - no padding)
    let mut ba: ByteArray = "Test123";
    let encoded1 = Base64ByteArrayEncoder::encode(ba.clone());
    let decoded1 = Base64ByteArrayDecoder::decode(encoded1);

    assert_eq!(decoded1.len(), ba.len(), "Round trip length mismatch for Test");
    assert_eq!(decoded1, ba);
}

#[test]
#[available_gas(2000000000)]
fn base64_ba_binary_data_test() {
    // Test with binary data
    let mut ba: ByteArray = Default::default();
    ba.append_byte(0);
    ba.append_byte(127);
    ba.append_byte(128);
    ba.append_byte(255);

    let encoded = Base64ByteArrayEncoder::encode(ba.clone());
    let decoded = Base64ByteArrayDecoder::decode(encoded);

    assert_eq!(decoded.len(), ba.len());
    assert_eq!(decoded.at(0).unwrap(), 0);
    assert_eq!(decoded.at(1).unwrap(), 127);
    assert_eq!(decoded.at(2).unwrap(), 128);
    assert_eq!(decoded.at(3).unwrap(), 255);
}

#[test]
#[available_gas(2000000000)]
fn base64_ba_longer_input_test() {
    // Test with longer input (16 bytes)
    let mut ba = Default::default();
    let mut i = 0;
    while i != 16 {
        ba.append_byte(i.try_into().unwrap());
        i += 1;
    }

    let encoded = Base64ByteArrayEncoder::encode(ba.clone());
    let decoded = Base64ByteArrayDecoder::decode(encoded);

    assert_eq!(decoded.len(), ba.len());

    i = 0;
    while i != ba.len() {
        assert_eq!(decoded.at(i), ba.at(i));
        i += 1;
    }
}

#[test]
#[available_gas(2000000000)]
fn base64_ba_sample_byte_values_test() {
    // Test with some sample byte values
    let mut ba: ByteArray = Default::default();
    ba.append_byte(0);
    ba.append_byte(50);
    ba.append_byte(100);
    ba.append_byte(150);
    ba.append_byte(200);
    ba.append_byte(255);

    let mut i = 0;
    while i != ba.len() {
        let val = ba.at(i).unwrap();
        let mut input = Default::default();
        input.append_byte(val);
        let encoded = Base64ByteArrayEncoder::encode(input);
        let decoded = Base64ByteArrayDecoder::decode(encoded);

        assert_eq!(decoded.len(), 1);
        assert_eq!(decoded.at(0).unwrap(), val);

        i += 1;
    }
}

#[test]
#[available_gas(2000000000)]
fn base64_ba_double_padding_test() {
    // Test with input that requires double padding
    let mut ba: ByteArray = "f";

    let encoded = Base64ByteArrayEncoder::encode(ba.clone());
    assert_eq!(encoded.len(), 4);
    assert_eq!(encoded.at(2).unwrap(), '=');
    assert_eq!(encoded.at(3).unwrap(), '=');

    let decoded = Base64ByteArrayDecoder::decode(encoded);
    assert_eq!(decoded.len(), 1);
    assert_eq!(decoded, ba);
}

#[test]
#[available_gas(2000000000)]
fn base64_ba_single_padding_test() {
    // Test with input that requires single padding
    let mut ba: ByteArray = "fo";

    let encoded = Base64ByteArrayEncoder::encode(ba.clone());
    assert_eq!(encoded.len(), 4);
    assert_eq!(encoded.at(3).unwrap(), '=');

    let decoded = Base64ByteArrayDecoder::decode(encoded);
    assert_eq!(decoded, ba);
}

#[test]
#[available_gas(2000000000)]
fn base64_ba_no_padding_test() {
    // Test with input that requires no padding
    let mut ba: ByteArray = "foo";

    let encoded = Base64ByteArrayEncoder::encode(ba.clone());
    assert_eq!(encoded.len(), 4);

    // Verify no padding
    let last_char = encoded.at(encoded.len() - 1).unwrap();
    assert_ne!(last_char, '=', "Expected no padding but found padding character");

    let decoded = Base64ByteArrayDecoder::decode(encoded);
    assert_eq!(decoded.len(), 3);
    assert_eq!(decoded, ba);
}

#[test]
#[available_gas(2000000000)]
fn base64_url_ba_round_trip_test() {
    // Test with URL-safe encoding/decoding
    // Binary data with values that produce special chars
    let mut ba: ByteArray = Default::default();
    ba.append_byte(255);
    ba.append_byte(239);
    ba.append_byte(223);
    ba.append_byte(191);

    let encoded = Base64ByteArrayUrlEncoder::encode(ba.clone());

    // Ensure no '+' or '/' characters
    let mut i = 0;
    while i != ba.len() {
        let current_char = encoded.at(i).unwrap();
        assert_ne!(current_char, '+', "Found non-URL-safe character '+'");
        assert_ne!(current_char, '/', "Found non-URL-safe character '/'");
        i += 1;
    }

    let decoded = Base64ByteArrayDecoder::decode(encoded);
    assert_eq!(decoded.len(), ba.len());
    assert_eq!(decoded, ba);
}
