use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use alexandria_encoding::rlp_byte_array::{RLPError, RLPItemByteArray, RLPTrait};

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_type_byte() {
    let mut ba: ByteArray = Default::default();
    ba.append_byte(0x78);
    let result = RLPTrait::decode_byte_array(@ba).unwrap();

    assert!(result.len() == 1, "Wrong size");
    assert!(result[0].at(0).unwrap() == 0x78, "Wrong value");
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_type_short_string() {
    let mut ba: ByteArray = Default::default();
    ba.append_u16(0x8181);
    let result = RLPTrait::decode_byte_array(@ba).unwrap();

    assert!(result.len() == 1, "Wrong size");
    assert!(result[0].at(0).unwrap() == 0x81, "Wrong value");
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_type_long_string() {
    let mut ba: ByteArray = Default::default();
    ba.append_word(0xb90102, 3);

    let a_byte = 0x41_u8;
    let mut i = 0;
    while i != 258 {
        ba.append_byte(a_byte);
        i += 1;
    }

    let result = RLPTrait::decode_byte_array(@ba).unwrap();
    assert!(result.len() == 1, "Wrong size");
    assert!(result[0].len() == 258, "Wrong size in ByteArray");
}


#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_type_short_list() {
    let mut input_ba: ByteArray = Default::default();
    input_ba.append_u32(0xc3814180); // list prefix (3 bytes)

    let result = RLPTrait::decode_byte_array(@input_ba).unwrap();

    assert!(result.len() == 2, "Wrong size");
    assert!(result[0].len() == 1, "Wrong size in ByteArray");
    assert!(result[1].len() == 0, "Wrong size in ByteArray 2");
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_type_long_list() {
    let mut input_ba: ByteArray = Default::default();
    input_ba.append_u256(0x7070707070707070707070707070707070707070707070707070707070707070);
    input_ba.append_word(0x70707070707070707070707070707070707070707070707070707070, 28);

    let mut ba: ByteArray = Default::default();
    ba.append_u256(0xB83C707070707070707070707070707070707070707070707070707070707070);
    ba.append_word(0x707070707070707070707070707070707070707070707070707070707070, 30);
    let res = RLPTrait::decode_byte_array(@ba).unwrap();

    assert!(res[0] == @input_ba, "Wrong decoded value");
}


#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_type_long_list_len_too_short() {
    let mut input_ba: ByteArray = Default::default();
    input_ba.append_word(0xf901, 2);

    let res = RLPTrait::decode_byte_array(@input_ba);

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}


#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_type_long_string_payload_too_long() {
    let mut input_ba: ByteArray = Default::default();
    input_ba.append_word(0xbf0102020202020202, 9);

    let res = RLPTrait::decode_byte_array(@input_ba);

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::PayloadTooLong, "err != PayloadTooLong");
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_type_long_list_payload_too_long() {
    let mut input_ba: ByteArray = Default::default();
    input_ba.append_word(0xfc0102020202, 6);

    let res = RLPTrait::decode_byte_array(@input_ba);

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::PayloadTooLong, "err != PayloadTooLong");
}

#[test]
#[available_gas(9999999)]
fn test_ba_rlp_decode_empty() {
    let res = RLPTrait::decode_byte_array(Default::default());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::EmptyInput, "err != EmptyInput");
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_string_default_value() {
    let mut ba: ByteArray = Default::default();
    ba.append_byte(0x80);
    let result = RLPTrait::decode_byte_array(@ba).unwrap();

    assert!(result.len() == 1, "not empty array");
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_string() {
    let mut i = 0;
    while (i != 128) {
        let mut ba: ByteArray = Default::default();
        ba.append_byte(i);

        let res = RLPTrait::decode_byte_array(@ba).unwrap();
        assert!(res[0] == @ba, "Wrong value");
        i += 1;
    };
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_short_string() {
    let mut ba: ByteArray = Default::default();
    ba.append_word(0x9b5a806cf634c0398d8f2d89fd49a91ef33da474cd8494bba8da3bf7, 28);

    let res = RLPTrait::decode_byte_array(@ba).unwrap();
    let (_, expected_item) = ba.read_bytes(1, 27);

    assert!(res[0] == @expected_item, "Wrong value");
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_short_string_input_too_short() {
    let mut ba: ByteArray = Default::default();
    ba.append_word(0x9b5a806cf634c0398d8f2d89fd49a91ef33da474cd8494bba8da3b, 27);

    let res = RLPTrait::decode_byte_array(@ba);

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_long_string_with_payload_len_on_1_byte() {
    let mut ba: ByteArray = Default::default();
    ba.append_u256(0xb83cf7a17ef959d488388ddc347b3a10dd85431d0c37986a63bd18baa38db1a4);
    ba.append_word(0x816f24dec3ec166eb3b2acc4c4f77904ba763c67c6d053daea1086197dd9, 30);

    let res = RLPTrait::decode_byte_array(@ba).unwrap();
    let (_, expected_item) = ba.read_bytes(2, 60);

    assert!(res[0] == @expected_item, "Wrong value");
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_long_string_with_input_too_short() {
    let mut ba: ByteArray = Default::default();
    ba.append_u256(0xb83cf7a17ef959d488388ddc347b3a10dd85431d0c37986a63bd18baa38db1a4);
    ba.append_word(0x816f24dec3ec166eb3b2acc4c4f77904ba763c67c6d053daea108619, 28);

    let res = RLPTrait::decode_byte_array(@ba);

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}


#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_long_string_with_payload_len_on_2_bytes() {
    let mut ba: ByteArray = Default::default();
    ba.append_u256(0xb90102f7a17ef959d488388ddc347b3a10dd85431d0c37986a63bd18baa38db1); //29
    ba.append_u256(0xa4816f24dec3ec166eb3b2acc4c4f77904ba763c67c6d053daea1086197dd933); //32
    ba.append_u256(0x5847693476894367934576873495678934364386794363347863495867835964); //32
    ba.append_u256(0x5637937458696943673948679845638945679437630456403968430868406503); //32
    ba.append_u256(0x4680934864953687398456737689349586736540936098345683045680360859); //32
    ba.append_u256(0x6845068306684059684065840368304865034683495768957968347683746987); //32
    ba.append_u256(0x4359638475639847563486739487654398673496793486579348576934875689); //32
    ba.append_u256(0x3457687349565379439567349679384763946537896353456879889768876868); //32
    ba.append_word(0x6876998760, 5); //5

    let res = RLPTrait::decode_byte_array(@ba).unwrap();
    let (_, expected_item) = ba.read_bytes(3, 258);

    assert!(res.len() == 1, "Wrong lenght");
    assert!(res[0] == @expected_item, "Wrong value");
}

#[test]
#[available_gas(99999999)]
fn test_ba_rlp_decode_long_string_with_payload_len_too_short() {
    let mut ba: ByteArray = Default::default();
    ba.append_word(0xb901, 2);

    let res = RLPTrait::decode_byte_array(@ba);

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}

#[test]
#[available_gas(99999999999)]
fn test_ba_rlp_decode_short_list() {
    let mut ba: ByteArray = Default::default();
    ba.append_word(0xc9833535354283453892, 10);
    let res = RLPTrait::decode_byte_array(@ba).unwrap();

    let mut ba1: ByteArray = Default::default();
    ba1.append_word(0x353535, 3);

    let mut ba2: ByteArray = Default::default();
    ba2.append_u8(0x42);

    let mut ba3: ByteArray = Default::default();
    ba3.append_word(0x453892, 3);
    assert!(res == array![ba1, ba2, ba3].span(), "Wrong value");
}

#[test]
#[available_gas(99999999999)]
fn test_ba_rlp_decode_short_nested_list() {
    let mut ba: ByteArray = Default::default();
    ba.append_u64(0xc7c0c1c0c3c0c1c0);
    let res = RLPTrait::decode_byte_array(@ba).unwrap();

    assert!(
        res == array![
            Default::default(), Default::default(), Default::default(), Default::default(),
        ]
            .span(),
        "Wrong value",
    );
}

#[test]
#[available_gas(99999999999)]
fn test_ba_rlp_decode_multi_list() {
    let mut ba: ByteArray = Default::default();
    ba.append_word(0xc6827a77c10401, 7);

    let res = RLPTrait::decode_byte_array(@ba).unwrap();

    let mut ba1: ByteArray = Default::default();
    ba1.append_u16(0x7a77);

    let mut ba2: ByteArray = Default::default();
    ba2.append_u8(0x04);

    let mut ba3: ByteArray = Default::default();
    ba3.append_u8(0x01);
    assert!(res == array![ba1, ba2, ba3].span(), "Wrong value");
}


#[test]
#[available_gas(99999999999)]
fn test_ba_rlp_decode_short_list_with_input_too_short() {
    let mut ba: ByteArray = Default::default();
    ba.append_word(0xc98335358942834538, 9);

    let res = RLPTrait::decode_byte_array(@ba);

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}

#[test]
#[available_gas(99999999999)]
fn test_ba_rlp_decode_long_list() {
    let mut ba: ByteArray = Default::default();
    ba.append_u256(0xf90211a07770cf09b5067a1b35df62a924898175ceaeecad1f68cdb4a844400c);
    ba.append_u256(0x73c14af4a01ea385d05ab261466d5c0487fe684534c19f1a4b5c4b18dc1a3635);
    ba.append_u256(0x60025071b4a02c4c04ce3540d3d1461872303c53a5e56683c1304f8d36a8800c);
    ba.append_u256(0x6af5fa3fcdeea0a9dc778dc54b7dd3c48222e739d161feb0c0eeceb2dcd51737);
    ba.append_u256(0xf05b8e37a63851a0a95f4d5556df62ddc262990497ae569bcd8efdda7b200793);
    ba.append_u256(0xf8d3de4cdb9718d7a039d4066d1438226eaf4ac9e943a874a9a9c25fb0d81db9);
    ba.append_u256(0x861d8c1336b3e2034ca07acc7c63b46aa418b3c9a041a1256bcb7361316b397a);
    ba.append_u256(0xda5a8867491bbb130130a015358a81252ec4937113fe36c78046b711fba19734);
    ba.append_u256(0x91bb29187a00785ff852aea0689142d316abfaa71c8bcedf49201ddbb2104e25);
    ba.append_u256(0x0adc90c4e856221f534a9658a0dc3650992534fda8a314a7dbb0ae3ba8c79db5);
    ba.append_u256(0x550c69ce2a2460c007adc4c1a3a020b0683b6655b0059ee103d04e4b506bcbc1);
    ba.append_u256(0x39006392b7dab11178c2660342e7a08eedeb45fb630f1cd99736eb18572217cb);
    ba.append_u256(0xc6d5f315b71be203b03ce8d99b2614a07923a33df65a986fd5e7f9e6e4c2b969);
    ba.append_u256(0x736b08944ebe99394a8614612fe609f3a06534d7d01a20714aa4fb2a55b946ce);
    ba.append_u256(0x64c3222dffad2aa2d18a923473c92ab1fda0bff9c28bfeb8bf2da9b618c8c3b0);
    ba.append_u256(0x6fe80cb1c0bd144738f7c42161ff29e2502fa07f1461693c704ea5021bbba35e);
    ba.append_word(0x72c502f6439e458f98242ed03748ea8fe2b35f80, 20);

    let res = RLPTrait::decode_byte_array(@ba).unwrap();

    let mut ba1: ByteArray = Default::default();
    ba1.append_u256(0x7770cf09b5067a1b35df62a924898175ceaeecad1f68cdb4a844400c73c14af4);

    let mut ba2: ByteArray = Default::default();
    ba2.append_u256(0x1ea385d05ab261466d5c0487fe684534c19f1a4b5c4b18dc1a363560025071b4);

    let mut ba3: ByteArray = Default::default();
    ba3.append_u256(0x2c4c04ce3540d3d1461872303c53a5e56683c1304f8d36a8800c6af5fa3fcdee);

    let mut ba4: ByteArray = Default::default();
    ba4.append_u256(0xa9dc778dc54b7dd3c48222e739d161feb0c0eeceb2dcd51737f05b8e37a63851);

    let mut ba5: ByteArray = Default::default();
    ba5.append_u256(0xa95f4d5556df62ddc262990497ae569bcd8efdda7b200793f8d3de4cdb9718d7);

    let mut ba6: ByteArray = Default::default();
    ba6.append_u256(0x39d4066d1438226eaf4ac9e943a874a9a9c25fb0d81db9861d8c1336b3e2034c);

    let mut ba7: ByteArray = Default::default();
    ba7.append_u256(0x7acc7c63b46aa418b3c9a041a1256bcb7361316b397ada5a8867491bbb130130);

    let mut ba8: ByteArray = Default::default();
    ba8.append_u256(0x15358a81252ec4937113fe36c78046b711fba1973491bb29187a00785ff852ae);

    let mut ba9: ByteArray = Default::default();
    ba9.append_u256(0x689142d316abfaa71c8bcedf49201ddbb2104e250adc90c4e856221f534a9658);

    let mut ba10: ByteArray = Default::default();
    ba10.append_u256(0xdc3650992534fda8a314a7dbb0ae3ba8c79db5550c69ce2a2460c007adc4c1a3);

    let mut ba11: ByteArray = Default::default();
    ba11.append_u256(0x20b0683b6655b0059ee103d04e4b506bcbc139006392b7dab11178c2660342e7);

    let mut ba12: ByteArray = Default::default();
    ba12.append_u256(0x8eedeb45fb630f1cd99736eb18572217cbc6d5f315b71be203b03ce8d99b2614);

    let mut ba13: ByteArray = Default::default();
    ba13.append_u256(0x7923a33df65a986fd5e7f9e6e4c2b969736b08944ebe99394a8614612fe609f3);

    let mut ba14: ByteArray = Default::default();
    ba14.append_u256(0x6534d7d01a20714aa4fb2a55b946ce64c3222dffad2aa2d18a923473c92ab1fd);

    let mut ba15: ByteArray = Default::default();
    ba15.append_u256(0xbff9c28bfeb8bf2da9b618c8c3b06fe80cb1c0bd144738f7c42161ff29e2502f);

    let mut ba16: ByteArray = Default::default();
    ba16.append_u256(0x7f1461693c704ea5021bbba35e72c502f6439e458f98242ed03748ea8fe2b35f);

    let ba17: ByteArray = Default::default();

    let expected = array![
        ba1, ba2, ba3, ba4, ba5, ba6, ba7, ba8, ba9, ba10, ba11, ba12, ba13, ba14, ba15, ba16, ba17,
    ];

    assert!(res == expected.span(), "Wrong value");
}

#[test]
#[available_gas(99999999999)]
fn test_ba_rlp_decode_long_list_with_input_too_short() {
    let mut ba: ByteArray = Default::default();
    ba.append_word(0xf90211a07770cf09b5067a1b35df62a924898175ceaeecad1f68cdb4, 28);

    let res = RLPTrait::decode_byte_array(@ba);

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}


#[test]
#[available_gas(99999999999)]
fn test_ba_rlp_decode_long_list_with_len_too_short() {
    let mut ba: ByteArray = Default::default();
    ba.append_word(0xf902, 2);

    let res = RLPTrait::decode_byte_array(@ba);

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}

#[test]
#[available_gas(20000000)]
fn test_ba_rlp_encode_empty_input_should_fail() {
    let res = RLPTrait::encode_byte_array(array![].span(), 0);
    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::EmptyInput, "err != EmptyInput");
}

#[test]
#[available_gas(20000000)]
fn test_ba_rlp_encode_default_value() {
    let input = RLPItemByteArray::String(Default::default());

    let res = RLPTrait::encode_byte_array(array![input].span(), 0).unwrap();

    assert!(res.len() == 1, "wrong len");
    assert!(res.at(0).unwrap() == 0x80, "wrong encoded value");
}


#[test]
#[available_gas(20000000)]
fn test_ba_rlp_encode_string_single_byte_lt_0x80() {
    let mut ba: ByteArray = Default::default();
    ba.append_byte(0x40);

    let input = RLPItemByteArray::String(ba);

    let res = RLPTrait::encode_byte_array(array![input].span(), 0).unwrap();

    assert!(res.len() == 1, "wrong len");
    assert!(res.at(0).unwrap() == 0x40, "wrong encoded value");
}

#[test]
#[available_gas(20000000)]
fn test_ba_rlp_encode_string_single_byte_ge_0x80() {
    let mut ba: ByteArray = Default::default();
    ba.append_byte(0x80);

    let input = RLPItemByteArray::String(ba);

    let res = RLPTrait::encode_byte_array(array![input].span(), 0).unwrap();

    assert!(res.len() == 2, "wrong len");
    assert!(res.at(0).unwrap() == 0x81, "wrong prefix");
    assert!(res.at(1).unwrap() == 0x80, "wrong encoded value");
}

#[test]
#[available_gas(20000000)]
fn test_ba_rlp_encode_string_length_between_2_and_55() {
    let mut ba: ByteArray = Default::default();
    ba.append_byte(0x40);
    ba.append_byte(0x50);

    let input = RLPItemByteArray::String(ba);

    let res = RLPTrait::encode_byte_array(array![input].span(), 0).unwrap();

    assert!(res.len() == 3, "wrong len");
    assert!(res.at(0).unwrap() == 0x82, "wrong prefix");
    assert!(res.at(1).unwrap() == 0x40, "wrong first value");
    assert!(res.at(2).unwrap() == 0x50, "wrong second value");
}

#[test]
#[available_gas(200000000)]
fn test_ba_rlp_encode_string_length_exactly_56() {
    let mut input_ba: ByteArray = Default::default();
    input_ba.append_u256(0x6060606060606060606060606060606060606060606060606060606060606060);
    input_ba.append_word(0x606060606060606060606060606060606060606060606060, 24);
    let input = RLPItemByteArray::String(input_ba);
    let res = RLPTrait::encode_byte_array(array![input].span(), 0).unwrap();
    assert!(res.len() == 58, "wrong len");
    assert!(res.at(0).unwrap() == 0xB8, "wrong string length");
    assert!(res.at(1).unwrap() == 56, "wrong string length");
    let (new_offset, result) = res.read_u256(0);
    assert_eq!(new_offset, 32);
    //expect prefix 0xB838 (0XB7 + 1 byte = 0xB8, 0x38=56 =lenght of the initial array)
    assert_eq!(result, 0xB838606060606060606060606060606060606060606060606060606060606060);
    let (_, result) = res.read_uint_within_size(new_offset, 26);
    assert_eq!(result, 0x6060606060606060606060606060606060606060606060606060);
}

#[test]
#[available_gas(20000000)]
fn test_ba_rlp_encode_string_length_greater_than_56() {
    let mut input_ba: ByteArray = Default::default();
    input_ba.append_u256(0x7070707070707070707070707070707070707070707070707070707070707070);
    input_ba.append_word(0x70707070707070707070707070707070707070707070707070707070, 28);
    let input = RLPItemByteArray::String(input_ba);
    let res = RLPTrait::encode_byte_array(array![input].span(), 0).unwrap();
    assert!(res.len() == 62, "wrong len");
    assert!(res.at(0).unwrap() == 0xB8, "wrong string length");
    assert!(res.at(1).unwrap() == 60, "wrong string length");
    let (new_offset, result) = res.read_u256(0);
    assert_eq!(new_offset, 32);

    //expect prefix 0xB83C (0XB7 + 1 byte = 0xB8, 0x3C=60 =lenght of the initial array)
    assert_eq!(result, 0xB83C707070707070707070707070707070707070707070707070707070707070);
    let (_, result) = res.read_uint_within_size(new_offset, 30);
    assert_eq!(result, 0x707070707070707070707070707070707070707070707070707070707070);
}

#[test]
#[available_gas(200000000)]
fn test_ba_rlp_encode_string_large_bytearray_inputs() {
    let mut input_ba: ByteArray = Default::default();
    let mut i = 0;
    while (i != 500) {
        input_ba.append_byte(0x70);
        i += 1;
    }

    let input = RLPItemByteArray::String(input_ba);
    let res = RLPTrait::encode_byte_array(array![input].span(), 0).unwrap();

    assert!(res.len() == 503, "wrong len");
    assert!(res.at(0).unwrap() == 0xb9, "wrong prefix");
    assert!(res.at(1).unwrap() == 0x01, "wrong first length byte");
    assert!(res.at(2).unwrap() == 0xF4, "wrong second length byte");
    let mut i = 3;
    while (i != 503) {
        assert!(res.at(i).unwrap() == 0x70, "wrong value in sequence");
        i += 1;
    }
}

#[test]
#[available_gas(20000000)]
fn test_ba_rlp_encode_mutilple_string() {
    let mut input_ba1: ByteArray = Default::default();
    input_ba1.append_u64(0x4053159450404040);
    let mut input_ba2: ByteArray = Default::default();
    input_ba2.append_byte(0x03);

    let input1 = RLPItemByteArray::String(input_ba1);
    let input2 = RLPItemByteArray::String(input_ba2);

    let res = RLPTrait::encode_byte_array(array![input1, input2].span(), 0).unwrap();

    assert!(res.len() == 10, "wrong len");
    assert!(res.at(0).unwrap() == 0x88, "wrong prefix");
    assert!(res.at(1).unwrap() == 0x40, "wrong first length byte");
    assert!(res.at(2).unwrap() == 0x53, "wrong second length byte");
}

#[test]
#[available_gas(20000000)]
fn test_ba_rlp_encode_short_list() {
    let mut input_ba1: ByteArray = Default::default();
    input_ba1.append_word(0x353535, 3);
    let mut input_ba2: ByteArray = Default::default();
    input_ba2.append_byte(0x42);
    let mut input_ba3: ByteArray = Default::default();
    input_ba3.append_word(0x453892, 3);

    let input1 = RLPItemByteArray::String(input_ba1);
    let input2 = RLPItemByteArray::String(input_ba2);
    let input3 = RLPItemByteArray::String(input_ba3);

    let input = RLPItemByteArray::List(array![input1, input2, input3].span());

    let res = RLPTrait::encode_byte_array(array![input].span(), 0).unwrap();
    assert!(res.len() == 10, "wrong len");

    let (_, data) = res.read_uint_within_size(0, 10);

    assert_eq!(data, 0xc9833535354283453892);
}

#[test]
#[available_gas(99999999999)]
fn test_ba_rlp_encode_short_nested_list() {
    let input1 = RLPItemByteArray::List(array![].span());
    let input2 = RLPItemByteArray::List(array![input1].span());
    let input3 = RLPItemByteArray::List(
        array![RLPItemByteArray::List(array![].span()), input2].span(),
    );

    let list = RLPItemByteArray::List(
        array![
            RLPItemByteArray::List(array![].span()),
            RLPItemByteArray::List(array![RLPItemByteArray::List(array![].span())].span()),
            input3,
        ]
            .span(),
    );

    let res = RLPTrait::encode_byte_array(array![list].span(), 0).unwrap();
    //let expected = array![0xc7, 0xc0, 0xc1, 0xc0, 0xc3, 0xc0, 0xc1, 0xc0];

    assert!(res.len() == 8, "wrong len");
    let (_, data) = res.read_uint_within_size(0, 8);
    assert!(data == 0xc7c0c1c0c3c0c1c0, "wrong encoded result");
}

#[test]
#[available_gas(99999999999)]
fn test_ba_rlp_encode_long_list() {
    let mut ba1: ByteArray = Default::default();
    ba1.append_u256(0x7770cf09b5067a1b35df62a924898175ceaeecad1f68cdb4a844400c73c14af4);
    let input1 = RLPItemByteArray::String(ba1);

    let mut ba2: ByteArray = Default::default();
    ba2.append_u256(0x1ea385d05ab261466d5c0487fe684534c19f1a4b5c4b18dc1a363560025071b4);
    let input2 = RLPItemByteArray::String(ba2);

    let mut ba3: ByteArray = Default::default();
    ba3.append_u256(0x2c4c04ce3540d3d1461872303c53a5e56683c1304f8d36a8800c6af5fa3fcdee);
    let input3 = RLPItemByteArray::String(ba3);

    let mut ba4: ByteArray = Default::default();
    ba4.append_u256(0xa9dc778dc54b7dd3c48222e739d161feb0c0eeceb2dcd51737f05b8e37a63851);
    let input4 = RLPItemByteArray::String(ba4);

    let mut ba5: ByteArray = Default::default();
    ba5.append_u256(0xa95f4d5556df62ddc262990497ae569bcd8efdda7b200793f8d3de4cdb9718d7);
    let input5 = RLPItemByteArray::String(ba5);

    let mut ba6: ByteArray = Default::default();
    ba6.append_u256(0x39d4066d1438226eaf4ac9e943a874a9a9c25fb0d81db9861d8c1336b3e2034c);
    let input6 = RLPItemByteArray::String(ba6);

    let mut ba7: ByteArray = Default::default();
    ba7.append_u256(0x7acc7c63b46aa418b3c9a041a1256bcb7361316b397ada5a8867491bbb130130);
    let input7 = RLPItemByteArray::String(ba7);

    let mut ba8: ByteArray = Default::default();
    ba8.append_u256(0x15358a81252ec4937113fe36c78046b711fba1973491bb29187a00785ff852ae);
    let input8 = RLPItemByteArray::String(ba8);

    let mut ba9: ByteArray = Default::default();
    ba9.append_u256(0x689142d316abfaa71c8bcedf49201ddbb2104e250adc90c4e856221f534a9658);
    let input9 = RLPItemByteArray::String(ba9);

    let mut ba10: ByteArray = Default::default();
    ba10.append_u256(0xdc3650992534fda8a314a7dbb0ae3ba8c79db5550c69ce2a2460c007adc4c1a3);
    let input10 = RLPItemByteArray::String(ba10);

    let mut ba11: ByteArray = Default::default();
    ba11.append_u256(0x20b0683b6655b0059ee103d04e4b506bcbc139006392b7dab11178c2660342e7);
    let input11 = RLPItemByteArray::String(ba11);

    let mut ba12: ByteArray = Default::default();
    ba12.append_u256(0x8eedeb45fb630f1cd99736eb18572217cbc6d5f315b71be203b03ce8d99b2614);
    let input12 = RLPItemByteArray::String(ba12);

    let mut ba13: ByteArray = Default::default();
    ba13.append_u256(0x7923a33df65a986fd5e7f9e6e4c2b969736b08944ebe99394a8614612fe609f3);
    let input13 = RLPItemByteArray::String(ba13);

    let mut ba14: ByteArray = Default::default();
    ba14.append_u256(0x6534d7d01a20714aa4fb2a55b946ce64c3222dffad2aa2d18a923473c92ab1fd);
    let input14 = RLPItemByteArray::String(ba14);

    let mut ba15: ByteArray = Default::default();
    ba15.append_u256(0xbff9c28bfeb8bf2da9b618c8c3b06fe80cb1c0bd144738f7c42161ff29e2502f);
    let input15 = RLPItemByteArray::String(ba15);

    let mut ba16: ByteArray = Default::default();
    ba16.append_u256(0x7f1461693c704ea5021bbba35e72c502f6439e458f98242ed03748ea8fe2b35f);
    let input16 = RLPItemByteArray::String(ba16);

    let input17 = RLPItemByteArray::String(Default::default());

    let strings_list = array![
        input1,
        input2,
        input3,
        input4,
        input5,
        input6,
        input7,
        input8,
        input9,
        input10,
        input11,
        input12,
        input13,
        input14,
        input15,
        input16,
        input17,
    ];

    let list = RLPItemByteArray::List(strings_list.span());
    let res = RLPTrait::encode_byte_array(array![list].span(), 0).unwrap();

    let mut expected_ba: ByteArray = Default::default();
    expected_ba.append_u256(0xf90211a07770cf09b5067a1b35df62a924898175ceaeecad1f68cdb4a844400c);
    expected_ba.append_u256(0x73c14af4a01ea385d05ab261466d5c0487fe684534c19f1a4b5c4b18dc1a3635);
    expected_ba.append_u256(0x60025071b4a02c4c04ce3540d3d1461872303c53a5e56683c1304f8d36a8800c);
    expected_ba.append_u256(0x6af5fa3fcdeea0a9dc778dc54b7dd3c48222e739d161feb0c0eeceb2dcd51737);
    expected_ba.append_u256(0xf05b8e37a63851a0a95f4d5556df62ddc262990497ae569bcd8efdda7b200793);
    expected_ba.append_u256(0xf8d3de4cdb9718d7a039d4066d1438226eaf4ac9e943a874a9a9c25fb0d81db9);
    expected_ba.append_u256(0x861d8c1336b3e2034ca07acc7c63b46aa418b3c9a041a1256bcb7361316b397a);
    expected_ba.append_u256(0xda5a8867491bbb130130a015358a81252ec4937113fe36c78046b711fba19734);
    expected_ba.append_u256(0x91bb29187a00785ff852aea0689142d316abfaa71c8bcedf49201ddbb2104e25);
    expected_ba.append_u256(0x0adc90c4e856221f534a9658a0dc3650992534fda8a314a7dbb0ae3ba8c79db5);
    expected_ba.append_u256(0x550c69ce2a2460c007adc4c1a3a020b0683b6655b0059ee103d04e4b506bcbc1);
    expected_ba.append_u256(0x39006392b7dab11178c2660342e7a08eedeb45fb630f1cd99736eb18572217cb);
    expected_ba.append_u256(0xc6d5f315b71be203b03ce8d99b2614a07923a33df65a986fd5e7f9e6e4c2b969);
    expected_ba.append_u256(0x736b08944ebe99394a8614612fe609f3a06534d7d01a20714aa4fb2a55b946ce);
    expected_ba.append_u256(0x64c3222dffad2aa2d18a923473c92ab1fda0bff9c28bfeb8bf2da9b618c8c3b0);
    expected_ba.append_u256(0x6fe80cb1c0bd144738f7c42161ff29e2502fa07f1461693c704ea5021bbba35e);
    expected_ba.append_word(0x72c502f6439e458f98242ed03748ea8fe2b35f80, 20);

    assert!(res == @expected_ba, "Wrong value");
}


#[test]
fn test_rlp_encode_legacy_tx_calldata_long() {
    // nonce
    let mut nonce_ba: ByteArray = Default::default();
    nonce_ba.append_byte(0x01);
    let nonce = RLPItemByteArray::String(nonce_ba);
    // max_priority_fee_per_gas
    let mut max_priority_fee_per_gas_ba: ByteArray = Default::default();
    max_priority_fee_per_gas_ba.append_u32(0x3b9aca00);
    let max_priority_fee_per_gas = RLPItemByteArray::String(max_priority_fee_per_gas_ba);
    // max_fee_per_gas
    let mut max_fee_per_gas_ba: ByteArray = Default::default();
    max_fee_per_gas_ba.append_u32(0x3b9aca00);
    let max_fee_per_gas = RLPItemByteArray::String(max_fee_per_gas_ba);
    // gas_limit
    let mut gas_limit_ba: ByteArray = Default::default();
    gas_limit_ba.append_u16(0x5208);
    let gas_limit = RLPItemByteArray::String(gas_limit_ba);
    // to
    let mut to_ba: ByteArray = Default::default();
    to_ba.append_word(0x000035cc6634c0532925a3b844bc454e4438f44e, 20);
    let to = RLPItemByteArray::String(to_ba);
    // value
    let mut value_ba: ByteArray = Default::default();
    value_ba.append_u64(0x0de0b6b3a7640000);
    let value = RLPItemByteArray::String(value_ba);
    //chain_id
    let mut chain_id_ba: ByteArray = Default::default();
    chain_id_ba.append_byte(0x01);
    let chain_id = RLPItemByteArray::String(chain_id_ba);
    //access_list
    let access_list = RLPItemByteArray::List(array![].span());

    let mut ba: ByteArray = Default::default();

    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);

    let calldata = RLPItemByteArray::String(ba);

    let strings_list = array![
        chain_id,
        nonce,
        max_priority_fee_per_gas,
        max_fee_per_gas,
        gas_limit,
        to,
        value,
        access_list,
        calldata,
    ];
    let list = RLPItemByteArray::List(strings_list.span());
    let res = RLPTrait::encode_byte_array(array![list].span(), 0x02).unwrap();
    assert_eq!(res.len(), 517);
}


#[test]
fn test_rlp_encode_legacy_tx_calldata_long_without_using_rlp_type() {
    // nonce
    let mut nonce_ba: ByteArray = Default::default();
    nonce_ba.append_byte(0x01);
    let nonce = RLPTrait::encode_byte_array_string(@nonce_ba).unwrap();

    // max_priority_fee_per_gas
    let mut max_priority_fee_per_gas_ba: ByteArray = Default::default();
    max_priority_fee_per_gas_ba.append_u32(0x3b9aca00);
    let max_priority_fee_per_gas = RLPTrait::encode_byte_array_string(@max_priority_fee_per_gas_ba)
        .unwrap();
    // max_fee_per_gas
    let mut max_fee_per_gas_ba: ByteArray = Default::default();
    max_fee_per_gas_ba.append_u32(0x3b9aca00);
    let max_fee_per_gas = RLPTrait::encode_byte_array_string(@max_fee_per_gas_ba).unwrap();
    // gas_limit
    let mut gas_limit_ba: ByteArray = Default::default();
    gas_limit_ba.append_u16(0x5208);
    let gas_limit = RLPTrait::encode_byte_array_string(@gas_limit_ba).unwrap();
    // to
    let mut to_ba: ByteArray = Default::default();
    to_ba.append_word(0x000035cc6634c0532925a3b844bc454e4438f44e, 20);
    let to = RLPTrait::encode_byte_array_string(@to_ba).unwrap();
    // value
    let mut value_ba: ByteArray = Default::default();
    value_ba.append_u64(0x0de0b6b3a7640000);
    let value = RLPTrait::encode_byte_array_string(@value_ba).unwrap();
    //chain_id
    let mut chain_id_ba: ByteArray = Default::default();
    chain_id_ba.append_byte(0x01);
    let chain_id = RLPTrait::encode_byte_array_string(@chain_id_ba).unwrap();
    //access_list
    let access_list = RLPTrait::encode_byte_array_list(array![].span(), 0x0).unwrap();

    let mut ba: ByteArray = Default::default();
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);
    ba.append_word(0xFFF, 16);

    let calldata = RLPTrait::encode_byte_array_string(@ba).unwrap();

    let strings_list = array![
        chain_id,
        nonce,
        max_priority_fee_per_gas,
        max_fee_per_gas,
        gas_limit,
        to,
        value,
        access_list,
        calldata,
    ];

    let result = RLPTrait::encode_byte_array_list(strings_list.span(), 0x2).unwrap();
    assert_eq!(result.len(), 517);
}


#[test]
#[available_gas(99999999999)]
fn test_ba_rlp_encode_short_nested_list_without_using_rlp_type() {
    let string_0 = RLPTrait::encode_byte_array_list(array![].span(), 0x0).unwrap();
    let string_1 = RLPTrait::encode_byte_array_list(array![string_0].span(), 0x0).unwrap();
    let string_2 = RLPTrait::encode_byte_array_list(array![string_0, string_1].span(), 0x0)
        .unwrap();

    let list = RLPTrait::encode_byte_array_list(array![string_0, string_1, string_2].span(), 0x0)
        .unwrap();

    assert!(list.len() == 8, "wrong len");
    let (_, data) = list.read_uint_within_size(0, 8);
    assert!(data == 0xc7c0c1c0c3c0c1c0, "wrong encoded result");
}

