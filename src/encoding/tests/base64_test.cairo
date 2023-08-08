use array::ArrayTrait;
use debug::PrintTrait;
use alexandria::encoding::base64::{
    Base64Encoder, Base64Decoder, Base64UrlEncoder, Base64UrlDecoder
};

#[test]
#[available_gas(2000000000)]
fn base64encode_empty_test() {
    let mut input = array![];
    let result = Base64Encoder::encode(input);
    assert(result.len() == 0, 'invalid result length');
}

#[test]
#[available_gas(2000000000)]
fn base64encode_simple_test() {
    let mut input = array!['a'];

    let result = Base64Encoder::encode(input);
    assert(result.len() == 4, 'invalid result length');
    assert(*result[0] == 'Y', 'invalid result[0]');
    assert(*result[1] == 'Q', 'invalid result[1]');
    assert(*result[2] == '=', 'invalid result[2]');
    assert(*result[3] == '=', 'invalid result[3]');
}

#[test]
#[available_gas(2000000000)]
fn base64encode_hello_world_test() {
    let mut input = array!['h', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd'];

    let result = Base64Encoder::encode(input);
    assert(result.len() == 16, 'invalid result length');
    assert(*result[0] == 'a', 'invalid result[0]');
    assert(*result[1] == 'G', 'invalid result[1]');
    assert(*result[2] == 'V', 'invalid result[2]');
    assert(*result[3] == 's', 'invalid result[3]');
    assert(*result[4] == 'b', 'invalid result[4]');
    assert(*result[5] == 'G', 'invalid result[5]');
    assert(*result[6] == '8', 'invalid result[6]');
    assert(*result[7] == 'g', 'invalid result[7]');
    assert(*result[8] == 'd', 'invalid result[8]');
    assert(*result[9] == '2', 'invalid result[9]');
    assert(*result[10] == '9', 'invalid result[10]');
    assert(*result[11] == 'y', 'invalid result[11]');
    assert(*result[12] == 'b', 'invalid result[12]');
    assert(*result[13] == 'G', 'invalid result[13]');
    assert(*result[14] == 'Q', 'invalid result[14]');
    assert(*result[15] == '=', 'invalid result[15]');
}

#[test]
#[available_gas(2000000000)]
fn base64decode_empty_test() {
    let mut input = array![];

    let result = Base64Decoder::decode(input);
    assert(result.len() == 0, 'invalid result length');
}

#[test]
#[available_gas(2000000000)]
fn base64decode_simple_test() {
    let mut input = array!['Y', 'Q', '=', '='];

    let result = Base64Decoder::decode(input);
    assert(result.len() == 1, 'invalid result length');
    assert(*result[0] == 'a', 'invalid result[0]');
}

#[test]
#[available_gas(2000000000)]
fn base64decode_hello_world_test() {
    let mut input = array![
        'a', 'G', 'V', 's', 'b', 'G', '8', 'g', 'd', '2', '9', 'y', 'b', 'G', 'Q', '='
    ];

    let result = Base64Decoder::decode(input);
    assert(result.len() == 11, 'invalid result length');
    assert(*result[0] == 'h', 'invalid result[0]');
    assert(*result[1] == 'e', 'invalid result[1]');
    assert(*result[2] == 'l', 'invalid result[2]');
    assert(*result[3] == 'l', 'invalid result[3]');
    assert(*result[4] == 'o', 'invalid result[4]');
    assert(*result[5] == ' ', 'invalid result[5]');
    assert(*result[6] == 'w', 'invalid result[6]');
    assert(*result[7] == 'o', 'invalid result[7]');
    assert(*result[8] == 'r', 'invalid result[8]');
    assert(*result[9] == 'l', 'invalid result[9]');
    assert(*result[10] == 'd', 'invalid result[10]');
}

#[test]
#[available_gas(2000000000)]
fn base64encode_with_plus_and_slash() {
    let mut input = array![255, 239];

    let result = Base64Encoder::encode(input);
    assert(result.len() == 4, 'invalid result length');
    assert(*result[0] == '/', 'invalid result[0]');
    assert(*result[1] == '+', 'invalid result[1]');
    assert(*result[2] == '8', 'invalid result[2]');
    assert(*result[3] == '=', 'invalid result[3]');
}

#[test]
#[available_gas(2000000000)]
fn base64urlencode_with_plus_and_slash() {
    let mut input = array![255, 239];

    let result = Base64UrlEncoder::encode(input);
    assert(result.len() == 4, 'invalid result length');
    assert(*result[0] == '_', 'invalid result[0]');
    assert(*result[1] == '-', 'invalid result[1]');
    assert(*result[2] == '8', 'invalid result[2]');
    assert(*result[3] == '=', 'invalid result[3]');
}

#[test]
#[available_gas(2000000000)]
fn base64decode_with_plus_and_slash() {
    let mut input = array!['/', '+', '8', '='];

    let result = Base64UrlDecoder::decode(input);
    assert(result.len() == 2, 'invalid result length');
    assert(*result[0] == 255, 'invalid result[0]');
    assert(*result[1] == 239, 'invalid result[1]');
}

#[test]
#[available_gas(2000000000)]
fn base64urldecode_with_plus_and_slash() {
    let mut input = array!['_', '-', '8', '='];

    let result = Base64UrlDecoder::decode(input);
    assert(result.len() == 2, 'invalid result length');
    assert(*result[0] == 255, 'invalid result[0]');
    assert(*result[1] == 239, 'invalid result[1]');
}
