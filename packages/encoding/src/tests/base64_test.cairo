use alexandria_encoding::base64::{Base64Decoder, Base64Encoder, Base64UrlDecoder, Base64UrlEncoder};

#[test]
#[available_gas(2000000000)]
fn base64encode_empty_test() {
    let input = array![];
    let result = Base64Encoder::encode(input);
    assert_eq!(result.len(), 0);
}

#[test]
#[available_gas(2000000000)]
fn base64encode_simple_test() {
    let input = array!['a'];

    let result = Base64Encoder::encode(input);
    assert_eq!(result.len(), 4);
    assert_eq!(*result[0], 'Y');
    assert_eq!(*result[1], 'Q');
    assert_eq!(*result[2], '=');
    assert_eq!(*result[3], '=');
}

#[test]
#[available_gas(2000000000)]
fn base64encode_hello_world_test() {
    let input = array!['h', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd'];

    let result = Base64Encoder::encode(input);
    assert_eq!(result.len(), 16);
    assert_eq!(*result[0], 'a');
    assert_eq!(*result[1], 'G');
    assert_eq!(*result[2], 'V');
    assert_eq!(*result[3], 's');
    assert_eq!(*result[4], 'b');
    assert_eq!(*result[5], 'G');
    assert_eq!(*result[6], '8');
    assert_eq!(*result[7], 'g');
    assert_eq!(*result[8], 'd');
    assert_eq!(*result[9], '2');
    assert_eq!(*result[10], '9');
    assert_eq!(*result[11], 'y');
    assert_eq!(*result[12], 'b');
    assert_eq!(*result[13], 'G');
    assert_eq!(*result[14], 'Q');
    assert_eq!(*result[15], '=');
}

#[test]
#[available_gas(2000000000)]
fn base64decode_empty_test() {
    let input = array![];

    let result = Base64Decoder::decode(input);
    assert_eq!(result.len(), 0);
}

#[test]
#[available_gas(2000000000)]
fn base64decode_simple_test() {
    let input = array!['Y', 'Q', '=', '='];

    let result = Base64Decoder::decode(input);
    assert_eq!(result.len(), 1);
    assert_eq!(*result[0], 'a');
}

#[test]
#[available_gas(2000000000)]
fn base64decode_hello_world_test() {
    let input = array![
        'a', 'G', 'V', 's', 'b', 'G', '8', 'g', 'd', '2', '9', 'y', 'b', 'G', 'Q', '=',
    ];

    let result = Base64Decoder::decode(input);
    assert_eq!(result.len(), 11);
    assert_eq!(*result[0], 'h');
    assert_eq!(*result[1], 'e');
    assert_eq!(*result[2], 'l');
    assert_eq!(*result[3], 'l');
    assert_eq!(*result[4], 'o');
    assert_eq!(*result[5], ' ');
    assert_eq!(*result[6], 'w');
    assert_eq!(*result[7], 'o');
    assert_eq!(*result[8], 'r');
    assert_eq!(*result[9], 'l');
    assert_eq!(*result[10], 'd');
}

#[test]
#[available_gas(2000000000)]
fn base64encode_with_plus_and_slash() {
    let input = array![255, 239];

    let result = Base64Encoder::encode(input);
    assert_eq!(result.len(), 4);
    assert_eq!(*result[0], '/');
    assert_eq!(*result[1], '+');
    assert_eq!(*result[2], '8');
    assert_eq!(*result[3], '=');
}

#[test]
#[available_gas(2000000000)]
fn base64urlencode_with_plus_and_slash() {
    let input = array![255, 239];

    let result = Base64UrlEncoder::encode(input);
    assert_eq!(result.len(), 4);
    assert_eq!(*result[0], '_');
    assert_eq!(*result[1], '-');
    assert_eq!(*result[2], '8');
    assert_eq!(*result[3], '=');
}

#[test]
#[available_gas(2000000000)]
fn base64decode_with_plus_and_slash() {
    let input = array!['/', '+', '8', '='];

    let result = Base64UrlDecoder::decode(input);
    assert_eq!(result.len(), 2);
    assert_eq!(*result[0], 255);
    assert_eq!(*result[1], 239);
}

#[test]
#[available_gas(2000000000)]
fn base64urldecode_with_plus_and_slash() {
    let input = array!['_', '-', '8', '='];

    let result = Base64UrlDecoder::decode(input);
    assert_eq!(result.len(), 2);
    assert_eq!(*result[0], 255);
    assert_eq!(*result[1], 239);
}

#[test]
#[available_gas(2000000000)]
fn base64_round_trip_test() {
    // Basic round trip test for "Test"
    let input1 = array!['T', 'e', 's', 't'];
    let encoded1 = Base64Encoder::encode(input1.clone());
    let decoded1 = Base64Decoder::decode(encoded1);

    assert_eq!(decoded1.len(), input1.len(), "Round trip length mismatch for Test");
    assert_eq!(*decoded1[0], 'T');
    assert_eq!(*decoded1[1], 'e');
    assert_eq!(*decoded1[2], 's');
    assert_eq!(*decoded1[3], 't');

    // Round trip test for "Test1" (5 bytes - 1 padding char)
    let input2 = array!['T', 'e', 's', 't', '1'];
    let encoded2 = Base64Encoder::encode(input2.clone());
    let decoded2 = Base64Decoder::decode(encoded2);

    assert_eq!(decoded2.len(), input2.len(), "Round trip length mismatch for Test1");
    assert_eq!(*decoded2[0], 'T');
    assert_eq!(*decoded2[1], 'e');
    assert_eq!(*decoded2[2], 's');
    assert_eq!(*decoded2[3], 't');
    assert_eq!(*decoded2[4], '1');

    // Round trip test for "Test12" (6 bytes - 2 padding chars)
    let input3 = array!['T', 'e', 's', 't', '1', '2'];
    let encoded3 = Base64Encoder::encode(input3.clone());
    let decoded3 = Base64Decoder::decode(encoded3);

    assert_eq!(decoded3.len(), input3.len(), "Round trip length mismatch for Test12");
    assert_eq!(*decoded3[0], 'T');
    assert_eq!(*decoded3[1], 'e');
    assert_eq!(*decoded3[2], 's');
    assert_eq!(*decoded3[3], 't');
    assert_eq!(*decoded3[4], '1');
    assert_eq!(*decoded3[5], '2');

    // Round trip test for "Test123" (7 bytes - no padding)
    let input4 = array!['T', 'e', 's', 't', '1', '2', '3'];
    let encoded4 = Base64Encoder::encode(input4.clone());
    let decoded4 = Base64Decoder::decode(encoded4);

    assert_eq!(decoded4.len(), input4.len(), "Round trip length mismatch for Test123");
    assert_eq!(*decoded4[0], 'T');
    assert_eq!(*decoded4[1], 'e');
    assert_eq!(*decoded4[2], 's');
    assert_eq!(*decoded4[3], 't');
    assert_eq!(*decoded4[4], '1');
    assert_eq!(*decoded4[5], '2');
    assert_eq!(*decoded4[6], '3');
}

#[test]
#[available_gas(2000000000)]
fn base64_binary_data_test() {
    // Test with binary data
    let input = array![0, 127, 128, 255];

    let encoded = Base64Encoder::encode(input.clone());
    let decoded = Base64Decoder::decode(encoded);

    assert_eq!(decoded.len(), input.len());
    assert_eq!(*decoded[0], 0);
    assert_eq!(*decoded[1], 127);
    assert_eq!(*decoded[2], 128);
    assert_eq!(*decoded[3], 255);
}

#[test]
#[available_gas(2000000000)]
fn base64_longer_input_test() {
    // Test with longer input (16 bytes)
    let mut input = array![];
    let mut i = 0;
    while i != 16 {
        input.append(i.try_into().unwrap());
        i += 1;
    }

    let encoded = Base64Encoder::encode(input.clone());
    let decoded = Base64Decoder::decode(encoded);

    assert_eq!(decoded.len(), input.len());

    i = 0;
    while i != input.len() {
        assert_eq!(*decoded[i], *input[i]);
        i += 1;
    }
}

#[test]
#[available_gas(2000000000)]
fn base64_sample_byte_values_test() {
    // Test with some sample byte values
    let samples = array![0, 50, 100, 150, 200, 255];

    let mut i = 0;
    while i != samples.len() {
        let val = *samples[i];
        let input = array![val];
        let encoded = Base64Encoder::encode(input);
        let decoded = Base64Decoder::decode(encoded);

        assert_eq!(decoded.len(), 1);
        assert_eq!(*decoded[0], val);

        i += 1;
    }
}

#[test]
#[available_gas(2000000000)]
fn base64_double_padding_test() {
    // Test with input that requires double padding
    let input = array!['f'];

    let encoded = Base64Encoder::encode(input.clone());
    assert_eq!(encoded.len(), 4);
    assert_eq!(*encoded[2], '=');
    assert_eq!(*encoded[3], '=');

    let decoded = Base64Decoder::decode(encoded);
    assert_eq!(decoded.len(), 1);
    assert_eq!(*decoded[0], 'f');
}

#[test]
#[available_gas(2000000000)]
fn base64_single_padding_test() {
    // Test with input that requires single padding
    let input = array!['f', 'o'];

    let encoded = Base64Encoder::encode(input.clone());
    assert_eq!(encoded.len(), 4);
    assert_eq!(*encoded[3], '=');

    let decoded = Base64Decoder::decode(encoded);
    assert_eq!(decoded.len(), 2);
    assert_eq!(*decoded[0], 'f');
    assert_eq!(*decoded[1], 'o');
}

#[test]
#[available_gas(2000000000)]
fn base64_no_padding_test() {
    // Test with input that requires no padding
    let input = array!['f', 'o', 'o'];

    let encoded = Base64Encoder::encode(input.clone());
    assert_eq!(encoded.len(), 4);

    // Verify no padding
    let last_char = *encoded[encoded.len() - 1];
    assert_ne!(last_char, '=', "Expected no padding but found padding character");

    let decoded = Base64Decoder::decode(encoded);
    assert_eq!(decoded.len(), 3);
    assert_eq!(*decoded[0], 'f');
    assert_eq!(*decoded[1], 'o');
    assert_eq!(*decoded[2], 'o');
}

#[test]
#[available_gas(2000000000)]
fn base64url_round_trip_test() {
    // Test with URL-safe encoding/decoding
    let input = array![255, 239, 223, 191]; // Binary data with values that produce special chars

    let encoded = Base64UrlEncoder::encode(input.clone());

    // Ensure no '+' or '/' characters
    let mut i = 0;
    while i != encoded.len() {
        let current_char = *encoded[i];
        assert_ne!(current_char, '+', "Found non-URL-safe character '+'");
        assert_ne!(current_char, '/', "Found non-URL-safe character '/'");
        i += 1;
    }

    let decoded = Base64UrlDecoder::decode(encoded);
    assert_eq!(decoded.len(), input.len());

    assert_eq!(*decoded[0], 255);
    assert_eq!(*decoded[1], 239);
    assert_eq!(*decoded[2], 223);
    assert_eq!(*decoded[3], 191);
}
