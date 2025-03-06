use alexandria_data_structures::array_ext::ArrayTraitExt;
use alexandria_encoding::base64::{
    Base64Encoder, Base64FeltEncoder, Base64UrlEncoder, Base64UrlFeltEncoder,
};

fn bytes_be(val: felt252) -> Array<u8> {
    let mut result = array![];

    let mut num: u256 = val.into();
    while (num != 0) {
        let (quotient, remainder) = DivRem::div_rem(num, 256_u256.try_into().unwrap());
        result.append(remainder.try_into().unwrap());
        num = quotient;
    }
    while (result.len() < 32) {
        result.append(0);
    }
    result = result.reversed();
    result
}

#[test]
#[available_gas(2000000000)]
fn base64encode_empty_test() {
    let input = 0;
    let result = Base64FeltEncoder::encode(input);
    let check = Base64Encoder::encode(bytes_be(input));
    assert_eq!(result, check);
}

#[test]
#[available_gas(2000000000)]
fn base64encode_simple_test() {
    let input = 'a';
    let result = Base64FeltEncoder::encode(input);
    let check = Base64Encoder::encode(bytes_be(input));
    assert_eq!(result, check);
}

#[test]
#[available_gas(2000000000)]
fn base64encode_hello_world_test() {
    let input = 'hello world';
    let result = Base64FeltEncoder::encode(input);
    let check = Base64Encoder::encode(bytes_be(input));
    assert_eq!(result, check);
}


#[test]
#[available_gas(2000000000)]
fn base64encode_with_plus_and_slash() {
    let mut input = 65519; // Equivalent to array![255, 239] as bytes_be

    let result = Base64FeltEncoder::encode(input);
    let check = Base64Encoder::encode(bytes_be(input));
    assert_eq!(result, check);
}

#[test]
#[available_gas(2000000000)]
fn base64urlencode_with_plus_and_slash() {
    let mut input = 65519; // Equivalent to array![255, 239] as bytes_be

    let result = Base64UrlFeltEncoder::encode(input);
    let check = Base64UrlEncoder::encode(bytes_be(input));
    assert_eq!(result, check);
}
