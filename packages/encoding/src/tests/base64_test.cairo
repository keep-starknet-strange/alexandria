use alexandria_encoding::base64::{Base64Encoder, Base64Decoder, Base64UrlEncoder, Base64UrlDecoder};

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
        'a', 'G', 'V', 's', 'b', 'G', '8', 'g', 'd', '2', '9', 'y', 'b', 'G', 'Q', '='
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
