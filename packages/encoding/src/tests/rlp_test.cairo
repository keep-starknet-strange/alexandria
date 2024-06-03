use alexandria_encoding::rlp::{RLPError, RLPType, RLPTrait, RLPItem};

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_type_byte() {
    let arr = array![0x78];

    let (rlp_type, offset, size) = RLPTrait::decode_type(arr.span()).unwrap();

    assert!(rlp_type == RLPType::String, "Wrong type");
    assert!(offset == 0, "Wrong offset");
    assert!(size == 1, "Wrong size");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_type_short_string() {
    let arr = array![0x82];

    let (rlp_type, offset, size) = RLPTrait::decode_type(arr.span()).unwrap();

    assert!(rlp_type == RLPType::String, "Wrong type");
    assert!(offset == 1, "Wrong offset");
    assert!(size == 2, "Wrong size");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_type_long_string() {
    let arr = array![0xb9, 0x01, 0x02];

    let (rlp_type, offset, size) = RLPTrait::decode_type(arr.span()).unwrap();

    assert!(rlp_type == RLPType::String, "Wrong type");
    assert!(offset == 3, "Wrong offset");
    assert!(size == 258, "Wrong size");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_type_short_list() {
    let arr = array![0xc3];

    let (rlp_type, offset, size) = RLPTrait::decode_type(arr.span()).unwrap();

    assert!(rlp_type == RLPType::List, "Wrong type");
    assert!(offset == 1, "Wrong offset");
    assert!(size == 3, "Wrong size");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_type_long_list() {
    let arr = array![0xf9, 0x01, 0x02];

    let (rlp_type, offset, size) = RLPTrait::decode_type(arr.span()).unwrap();

    assert!(rlp_type == RLPType::List, "Wrong type");
    assert!(offset == 3, "Wrong offset");
    assert!(size == 258, "Wrong size");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_type_long_list_len_too_short() {
    let arr = array![0xf9, 0x01];

    let res = RLPTrait::decode_type(arr.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_type_long_string_payload_too_long() {
    let arr = array![0xbf, 0x01, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02];

    let res = RLPTrait::decode_type(arr.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::PayloadTooLong, "err != PayloadTooLong");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_type_long_list_payload_too_long() {
    let arr = array![0xfc, 0x01, 0x02, 0x02, 0x02, 0x02];

    let res = RLPTrait::decode_type(arr.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::PayloadTooLong, "err != PayloadTooLong");
}

#[test]
#[available_gas(9999999)]
fn test_rlp_empty() {
    let res = RLPTrait::decode(ArrayTrait::new().span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::EmptyInput, "err != EmptyInput");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_string_default_value() {
    let arr = array![0x80];

    let rlp_item = RLPTrait::decode(arr.span()).unwrap();
    let expected = RLPItem::String(array![].span());

    assert!(rlp_item.len() == 1, "item length not 0");
    assert!(*rlp_item[0] == expected, "wrong item");
}


#[test]
#[available_gas(99999999)]
fn test_rlp_decode_string() {
    let mut i = 0;
    while (i != 128) {
        let arr = array![i];

        let res = RLPTrait::decode(arr.span()).unwrap();

        assert!(res == array![RLPItem::String(arr.span())].span(), "Wrong value");

        i += 1;
    };
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_short_string() {
    let mut arr = array![
        0x9b,
        0x5a,
        0x80,
        0x6c,
        0xf6,
        0x34,
        0xc0,
        0x39,
        0x8d,
        0x8f,
        0x2d,
        0x89,
        0xfd,
        0x49,
        0xa9,
        0x1e,
        0xf3,
        0x3d,
        0xa4,
        0x74,
        0xcd,
        0x84,
        0x94,
        0xbb,
        0xa8,
        0xda,
        0x3b,
        0xf7
    ];

    let res = RLPTrait::decode(arr.span()).unwrap();

    // Remove the byte representing the data type
    let _ = arr.pop_front();
    let expected_item = array![RLPItem::String(arr.span())].span();

    assert!(res == expected_item, "Wrong value");
}


#[test]
#[available_gas(99999999)]
fn test_rlp_decode_short_string_input_too_short() {
    let arr = array![
        0x9b,
        0x5a,
        0x80,
        0x6c,
        0xf6,
        0x34,
        0xc0,
        0x39,
        0x8d,
        0x8f,
        0x2d,
        0x89,
        0xfd,
        0x49,
        0xa9,
        0x1e,
        0xf3,
        0x3d,
        0xa4,
        0x74,
        0xcd,
        0x84,
        0x94,
        0xbb,
        0xa8,
        0xda,
        0x3b
    ];

    let res = RLPTrait::decode(arr.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_long_string_with_payload_len_on_1_byte() {
    let mut arr = array![
        0xb8,
        0x3c,
        0xf7,
        0xa1,
        0x7e,
        0xf9,
        0x59,
        0xd4,
        0x88,
        0x38,
        0x8d,
        0xdc,
        0x34,
        0x7b,
        0x3a,
        0x10,
        0xdd,
        0x85,
        0x43,
        0x1d,
        0x0c,
        0x37,
        0x98,
        0x6a,
        0x63,
        0xbd,
        0x18,
        0xba,
        0xa3,
        0x8d,
        0xb1,
        0xa4,
        0x81,
        0x6f,
        0x24,
        0xde,
        0xc3,
        0xec,
        0x16,
        0x6e,
        0xb3,
        0xb2,
        0xac,
        0xc4,
        0xc4,
        0xf7,
        0x79,
        0x04,
        0xba,
        0x76,
        0x3c,
        0x67,
        0xc6,
        0xd0,
        0x53,
        0xda,
        0xea,
        0x10,
        0x86,
        0x19,
        0x7d,
        0xd9
    ];

    let res = RLPTrait::decode(arr.span()).unwrap();

    // Remove the bytes representing the data type and their length
    let _ = arr.pop_front();
    let _ = arr.pop_front();
    let expected_item = array![RLPItem::String(arr.span())].span();

    assert!(res == expected_item, "Wrong value");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_long_string_with_input_too_short() {
    let arr = array![
        0xb8,
        0x3c,
        0xf7,
        0xa1,
        0x7e,
        0xf9,
        0x59,
        0xd4,
        0x88,
        0x38,
        0x8d,
        0xdc,
        0x34,
        0x7b,
        0x3a,
        0x10,
        0xdd,
        0x85,
        0x43,
        0x1d,
        0x0c,
        0x37,
        0x98,
        0x6a,
        0x63,
        0xbd,
        0x18,
        0xba,
        0xa3,
        0x8d,
        0xb1,
        0xa4,
        0x81,
        0x6f,
        0x24,
        0xde,
        0xc3,
        0xec,
        0x16,
        0x6e,
        0xb3,
        0xb2,
        0xac,
        0xc4,
        0xc4,
        0xf7,
        0x79,
        0x04,
        0xba,
        0x76,
        0x3c,
        0x67,
        0xc6,
        0xd0,
        0x53,
        0xda,
        0xea,
        0x10,
        0x86,
        0x19,
    ];

    let res = RLPTrait::decode(arr.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}


#[test]
#[available_gas(99999999)]
fn test_rlp_decode_long_string_with_payload_len_on_2_bytes() {
    let mut arr = array![
        0xb9,
        0x01,
        0x02,
        0xf7,
        0xa1,
        0x7e,
        0xf9,
        0x59,
        0xd4,
        0x88,
        0x38,
        0x8d,
        0xdc,
        0x34,
        0x7b,
        0x3a,
        0x10,
        0xdd,
        0x85,
        0x43,
        0x1d,
        0x0c,
        0x37,
        0x98,
        0x6a,
        0x63,
        0xbd,
        0x18,
        0xba,
        0xa3,
        0x8d,
        0xb1,
        0xa4,
        0x81,
        0x6f,
        0x24,
        0xde,
        0xc3,
        0xec,
        0x16,
        0x6e,
        0xb3,
        0xb2,
        0xac,
        0xc4,
        0xc4,
        0xf7,
        0x79,
        0x04,
        0xba,
        0x76,
        0x3c,
        0x67,
        0xc6,
        0xd0,
        0x53,
        0xda,
        0xea,
        0x10,
        0x86,
        0x19,
        0x7d,
        0xd9,
        0x33,
        0x58,
        0x47,
        0x69,
        0x34,
        0x76,
        0x89,
        0x43,
        0x67,
        0x93,
        0x45,
        0x76,
        0x87,
        0x34,
        0x95,
        0x67,
        0x89,
        0x34,
        0x36,
        0x43,
        0x86,
        0x79,
        0x43,
        0x63,
        0x34,
        0x78,
        0x63,
        0x49,
        0x58,
        0x67,
        0x83,
        0x59,
        0x64,
        0x56,
        0x37,
        0x93,
        0x74,
        0x58,
        0x69,
        0x69,
        0x43,
        0x67,
        0x39,
        0x48,
        0x67,
        0x98,
        0x45,
        0x63,
        0x89,
        0x45,
        0x67,
        0x94,
        0x37,
        0x63,
        0x04,
        0x56,
        0x40,
        0x39,
        0x68,
        0x43,
        0x08,
        0x68,
        0x40,
        0x65,
        0x03,
        0x46,
        0x80,
        0x93,
        0x48,
        0x64,
        0x95,
        0x36,
        0x87,
        0x39,
        0x84,
        0x56,
        0x73,
        0x76,
        0x89,
        0x34,
        0x95,
        0x86,
        0x73,
        0x65,
        0x40,
        0x93,
        0x60,
        0x98,
        0x34,
        0x56,
        0x83,
        0x04,
        0x56,
        0x80,
        0x36,
        0x08,
        0x59,
        0x68,
        0x45,
        0x06,
        0x83,
        0x06,
        0x68,
        0x40,
        0x59,
        0x68,
        0x40,
        0x65,
        0x84,
        0x03,
        0x68,
        0x30,
        0x48,
        0x65,
        0x03,
        0x46,
        0x83,
        0x49,
        0x57,
        0x68,
        0x95,
        0x79,
        0x68,
        0x34,
        0x76,
        0x83,
        0x74,
        0x69,
        0x87,
        0x43,
        0x59,
        0x63,
        0x84,
        0x75,
        0x63,
        0x98,
        0x47,
        0x56,
        0x34,
        0x86,
        0x73,
        0x94,
        0x87,
        0x65,
        0x43,
        0x98,
        0x67,
        0x34,
        0x96,
        0x79,
        0x34,
        0x86,
        0x57,
        0x93,
        0x48,
        0x57,
        0x69,
        0x34,
        0x87,
        0x56,
        0x89,
        0x34,
        0x57,
        0x68,
        0x73,
        0x49,
        0x56,
        0x53,
        0x79,
        0x43,
        0x95,
        0x67,
        0x34,
        0x96,
        0x79,
        0x38,
        0x47,
        0x63,
        0x94,
        0x65,
        0x37,
        0x89,
        0x63,
        0x53,
        0x45,
        0x68,
        0x79,
        0x88,
        0x97,
        0x68,
        0x87,
        0x68,
        0x68,
        0x68,
        0x76,
        0x99,
        0x87,
        0x60
    ];

    let res = RLPTrait::decode(arr.span()).unwrap();

    // Remove the bytes representing the data type and their length
    let _ = arr.pop_front();
    let _ = arr.pop_front();
    let _ = arr.pop_front();
    let expected_item = array![RLPItem::String(arr.span())].span();

    assert!(res == expected_item, "Wrong value");
}

#[test]
#[available_gas(99999999)]
fn test_rlp_decode_long_string_with_payload_len_too_short() {
    let arr = array![0xb9, 0x01,];

    let res = RLPTrait::decode(arr.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}

#[test]
#[available_gas(99999999999)]
fn test_rlp_decode_short_list() {
    let arr = array![0xc9, 0x83, 0x35, 0x35, 0x35, 0x42, 0x83, 0x45, 0x38, 0x92];
    let res = RLPTrait::decode(arr.span()).unwrap();

    let expected_0 = RLPItem::String(array![0x35, 0x35, 0x35].span());
    let expected_1 = RLPItem::String(array![0x42].span());
    let expected_2 = RLPItem::String(array![0x45, 0x38, 0x92].span());

    let expected_list = RLPItem::List(array![expected_0, expected_1, expected_2].span());

    assert!(res == array![expected_list].span(), "Wrong value");
}

#[test]
#[available_gas(99999999999)]
fn test_rlp_decode_short_nested_list() {
    let arr = array![0xc7, 0xc0, 0xc1, 0xc0, 0xc3, 0xc0, 0xc1, 0xc0];
    let res = RLPTrait::decode(arr.span()).unwrap();

    let expected_0 = RLPItem::List(array![].span());
    let expected_1 = RLPItem::List(array![expected_0].span());
    let expected_2 = RLPItem::List(array![expected_0, expected_1].span());

    let expected = RLPItem::List(array![expected_0, expected_1, expected_2].span());

    assert!(res == array![expected].span(), "Wrong value");
}

#[test]
#[available_gas(99999999999)]
fn test_rlp_decode_multi_list() {
    let mut arr = array![0xc6, 0x82, 0x7a, 0x77, 0xc1, 0x04, 0x01,];

    let res = RLPTrait::decode(arr.span()).unwrap();

    let expected_0 = RLPItem::String(array![0x7a, 0x77].span());
    let expected_1 = RLPItem::String(array![0x04].span());
    let expected_1 = RLPItem::List(array![expected_1].span());
    let expected_2 = RLPItem::String(array![0x01].span());
    let expected = RLPItem::List(array![expected_0, expected_1, expected_2].span());

    assert!(res == array![expected].span(), "Wrong value");
}

#[test]
#[available_gas(99999999999)]
fn test_rlp_decode_short_list_with_input_too_short() {
    let arr = array![0xc9, 0x83, 0x35, 0x35, 0x89, 0x42, 0x83, 0x45, 0x38];

    let res = RLPTrait::decode(arr.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}

#[test]
#[available_gas(99999999999)]
fn test_rlp_decode_long_list() {
    let mut arr = array![
        0xf9,
        0x02,
        0x11,
        0xa0,
        0x77,
        0x70,
        0xcf,
        0x09,
        0xb5,
        0x06,
        0x7a,
        0x1b,
        0x35,
        0xdf,
        0x62,
        0xa9,
        0x24,
        0x89,
        0x81,
        0x75,
        0xce,
        0xae,
        0xec,
        0xad,
        0x1f,
        0x68,
        0xcd,
        0xb4,
        0xa8,
        0x44,
        0x40,
        0x0c,
        0x73,
        0xc1,
        0x4a,
        0xf4,
        0xa0,
        0x1e,
        0xa3,
        0x85,
        0xd0,
        0x5a,
        0xb2,
        0x61,
        0x46,
        0x6d,
        0x5c,
        0x04,
        0x87,
        0xfe,
        0x68,
        0x45,
        0x34,
        0xc1,
        0x9f,
        0x1a,
        0x4b,
        0x5c,
        0x4b,
        0x18,
        0xdc,
        0x1a,
        0x36,
        0x35,
        0x60,
        0x02,
        0x50,
        0x71,
        0xb4,
        0xa0,
        0x2c,
        0x4c,
        0x04,
        0xce,
        0x35,
        0x40,
        0xd3,
        0xd1,
        0x46,
        0x18,
        0x72,
        0x30,
        0x3c,
        0x53,
        0xa5,
        0xe5,
        0x66,
        0x83,
        0xc1,
        0x30,
        0x4f,
        0x8d,
        0x36,
        0xa8,
        0x80,
        0x0c,
        0x6a,
        0xf5,
        0xfa,
        0x3f,
        0xcd,
        0xee,
        0xa0,
        0xa9,
        0xdc,
        0x77,
        0x8d,
        0xc5,
        0x4b,
        0x7d,
        0xd3,
        0xc4,
        0x82,
        0x22,
        0xe7,
        0x39,
        0xd1,
        0x61,
        0xfe,
        0xb0,
        0xc0,
        0xee,
        0xce,
        0xb2,
        0xdc,
        0xd5,
        0x17,
        0x37,
        0xf0,
        0x5b,
        0x8e,
        0x37,
        0xa6,
        0x38,
        0x51,
        0xa0,
        0xa9,
        0x5f,
        0x4d,
        0x55,
        0x56,
        0xdf,
        0x62,
        0xdd,
        0xc2,
        0x62,
        0x99,
        0x04,
        0x97,
        0xae,
        0x56,
        0x9b,
        0xcd,
        0x8e,
        0xfd,
        0xda,
        0x7b,
        0x20,
        0x07,
        0x93,
        0xf8,
        0xd3,
        0xde,
        0x4c,
        0xdb,
        0x97,
        0x18,
        0xd7,
        0xa0,
        0x39,
        0xd4,
        0x06,
        0x6d,
        0x14,
        0x38,
        0x22,
        0x6e,
        0xaf,
        0x4a,
        0xc9,
        0xe9,
        0x43,
        0xa8,
        0x74,
        0xa9,
        0xa9,
        0xc2,
        0x5f,
        0xb0,
        0xd8,
        0x1d,
        0xb9,
        0x86,
        0x1d,
        0x8c,
        0x13,
        0x36,
        0xb3,
        0xe2,
        0x03,
        0x4c,
        0xa0,
        0x7a,
        0xcc,
        0x7c,
        0x63,
        0xb4,
        0x6a,
        0xa4,
        0x18,
        0xb3,
        0xc9,
        0xa0,
        0x41,
        0xa1,
        0x25,
        0x6b,
        0xcb,
        0x73,
        0x61,
        0x31,
        0x6b,
        0x39,
        0x7a,
        0xda,
        0x5a,
        0x88,
        0x67,
        0x49,
        0x1b,
        0xbb,
        0x13,
        0x01,
        0x30,
        0xa0,
        0x15,
        0x35,
        0x8a,
        0x81,
        0x25,
        0x2e,
        0xc4,
        0x93,
        0x71,
        0x13,
        0xfe,
        0x36,
        0xc7,
        0x80,
        0x46,
        0xb7,
        0x11,
        0xfb,
        0xa1,
        0x97,
        0x34,
        0x91,
        0xbb,
        0x29,
        0x18,
        0x7a,
        0x00,
        0x78,
        0x5f,
        0xf8,
        0x52,
        0xae,
        0xa0,
        0x68,
        0x91,
        0x42,
        0xd3,
        0x16,
        0xab,
        0xfa,
        0xa7,
        0x1c,
        0x8b,
        0xce,
        0xdf,
        0x49,
        0x20,
        0x1d,
        0xdb,
        0xb2,
        0x10,
        0x4e,
        0x25,
        0x0a,
        0xdc,
        0x90,
        0xc4,
        0xe8,
        0x56,
        0x22,
        0x1f,
        0x53,
        0x4a,
        0x96,
        0x58,
        0xa0,
        0xdc,
        0x36,
        0x50,
        0x99,
        0x25,
        0x34,
        0xfd,
        0xa8,
        0xa3,
        0x14,
        0xa7,
        0xdb,
        0xb0,
        0xae,
        0x3b,
        0xa8,
        0xc7,
        0x9d,
        0xb5,
        0x55,
        0x0c,
        0x69,
        0xce,
        0x2a,
        0x24,
        0x60,
        0xc0,
        0x07,
        0xad,
        0xc4,
        0xc1,
        0xa3,
        0xa0,
        0x20,
        0xb0,
        0x68,
        0x3b,
        0x66,
        0x55,
        0xb0,
        0x05,
        0x9e,
        0xe1,
        0x03,
        0xd0,
        0x4e,
        0x4b,
        0x50,
        0x6b,
        0xcb,
        0xc1,
        0x39,
        0x00,
        0x63,
        0x92,
        0xb7,
        0xda,
        0xb1,
        0x11,
        0x78,
        0xc2,
        0x66,
        0x03,
        0x42,
        0xe7,
        0xa0,
        0x8e,
        0xed,
        0xeb,
        0x45,
        0xfb,
        0x63,
        0x0f,
        0x1c,
        0xd9,
        0x97,
        0x36,
        0xeb,
        0x18,
        0x57,
        0x22,
        0x17,
        0xcb,
        0xc6,
        0xd5,
        0xf3,
        0x15,
        0xb7,
        0x1b,
        0xe2,
        0x03,
        0xb0,
        0x3c,
        0xe8,
        0xd9,
        0x9b,
        0x26,
        0x14,
        0xa0,
        0x79,
        0x23,
        0xa3,
        0x3d,
        0xf6,
        0x5a,
        0x98,
        0x6f,
        0xd5,
        0xe7,
        0xf9,
        0xe6,
        0xe4,
        0xc2,
        0xb9,
        0x69,
        0x73,
        0x6b,
        0x08,
        0x94,
        0x4e,
        0xbe,
        0x99,
        0x39,
        0x4a,
        0x86,
        0x14,
        0x61,
        0x2f,
        0xe6,
        0x09,
        0xf3,
        0xa0,
        0x65,
        0x34,
        0xd7,
        0xd0,
        0x1a,
        0x20,
        0x71,
        0x4a,
        0xa4,
        0xfb,
        0x2a,
        0x55,
        0xb9,
        0x46,
        0xce,
        0x64,
        0xc3,
        0x22,
        0x2d,
        0xff,
        0xad,
        0x2a,
        0xa2,
        0xd1,
        0x8a,
        0x92,
        0x34,
        0x73,
        0xc9,
        0x2a,
        0xb1,
        0xfd,
        0xa0,
        0xbf,
        0xf9,
        0xc2,
        0x8b,
        0xfe,
        0xb8,
        0xbf,
        0x2d,
        0xa9,
        0xb6,
        0x18,
        0xc8,
        0xc3,
        0xb0,
        0x6f,
        0xe8,
        0x0c,
        0xb1,
        0xc0,
        0xbd,
        0x14,
        0x47,
        0x38,
        0xf7,
        0xc4,
        0x21,
        0x61,
        0xff,
        0x29,
        0xe2,
        0x50,
        0x2f,
        0xa0,
        0x7f,
        0x14,
        0x61,
        0x69,
        0x3c,
        0x70,
        0x4e,
        0xa5,
        0x02,
        0x1b,
        0xbb,
        0xa3,
        0x5e,
        0x72,
        0xc5,
        0x02,
        0xf6,
        0x43,
        0x9e,
        0x45,
        0x8f,
        0x98,
        0x24,
        0x2e,
        0xd0,
        0x37,
        0x48,
        0xea,
        0x8f,
        0xe2,
        0xb3,
        0x5f,
        0x80
    ];
    let res = RLPTrait::decode(arr.span()).unwrap();

    let expected_0 = RLPItem::String(
        array![
            0x77,
            0x70,
            0xcf,
            0x09,
            0xb5,
            0x06,
            0x7a,
            0x1b,
            0x35,
            0xdf,
            0x62,
            0xa9,
            0x24,
            0x89,
            0x81,
            0x75,
            0xce,
            0xae,
            0xec,
            0xad,
            0x1f,
            0x68,
            0xcd,
            0xb4,
            0xa8,
            0x44,
            0x40,
            0x0c,
            0x73,
            0xc1,
            0x4a,
            0xf4
        ]
            .span()
    );
    let expected_1 = RLPItem::String(
        array![
            0x1e,
            0xa3,
            0x85,
            0xd0,
            0x5a,
            0xb2,
            0x61,
            0x46,
            0x6d,
            0x5c,
            0x04,
            0x87,
            0xfe,
            0x68,
            0x45,
            0x34,
            0xc1,
            0x9f,
            0x1a,
            0x4b,
            0x5c,
            0x4b,
            0x18,
            0xdc,
            0x1a,
            0x36,
            0x35,
            0x60,
            0x02,
            0x50,
            0x71,
            0xb4
        ]
            .span()
    );
    let expected_2 = RLPItem::String(
        array![
            0x2c,
            0x4c,
            0x04,
            0xce,
            0x35,
            0x40,
            0xd3,
            0xd1,
            0x46,
            0x18,
            0x72,
            0x30,
            0x3c,
            0x53,
            0xa5,
            0xe5,
            0x66,
            0x83,
            0xc1,
            0x30,
            0x4f,
            0x8d,
            0x36,
            0xa8,
            0x80,
            0x0c,
            0x6a,
            0xf5,
            0xfa,
            0x3f,
            0xcd,
            0xee
        ]
            .span()
    );
    let expected_3 = RLPItem::String(
        array![
            0xa9,
            0xdc,
            0x77,
            0x8d,
            0xc5,
            0x4b,
            0x7d,
            0xd3,
            0xc4,
            0x82,
            0x22,
            0xe7,
            0x39,
            0xd1,
            0x61,
            0xfe,
            0xb0,
            0xc0,
            0xee,
            0xce,
            0xb2,
            0xdc,
            0xd5,
            0x17,
            0x37,
            0xf0,
            0x5b,
            0x8e,
            0x37,
            0xa6,
            0x38,
            0x51
        ]
            .span()
    );
    let expected_4 = RLPItem::String(
        array![
            0xa9,
            0x5f,
            0x4d,
            0x55,
            0x56,
            0xdf,
            0x62,
            0xdd,
            0xc2,
            0x62,
            0x99,
            0x04,
            0x97,
            0xae,
            0x56,
            0x9b,
            0xcd,
            0x8e,
            0xfd,
            0xda,
            0x7b,
            0x20,
            0x07,
            0x93,
            0xf8,
            0xd3,
            0xde,
            0x4c,
            0xdb,
            0x97,
            0x18,
            0xd7
        ]
            .span()
    );
    let expected_5 = RLPItem::String(
        array![
            0x39,
            0xd4,
            0x06,
            0x6d,
            0x14,
            0x38,
            0x22,
            0x6e,
            0xaf,
            0x4a,
            0xc9,
            0xe9,
            0x43,
            0xa8,
            0x74,
            0xa9,
            0xa9,
            0xc2,
            0x5f,
            0xb0,
            0xd8,
            0x1d,
            0xb9,
            0x86,
            0x1d,
            0x8c,
            0x13,
            0x36,
            0xb3,
            0xe2,
            0x03,
            0x4c
        ]
            .span()
    );
    let expected_6 = RLPItem::String(
        array![
            0x7a,
            0xcc,
            0x7c,
            0x63,
            0xb4,
            0x6a,
            0xa4,
            0x18,
            0xb3,
            0xc9,
            0xa0,
            0x41,
            0xa1,
            0x25,
            0x6b,
            0xcb,
            0x73,
            0x61,
            0x31,
            0x6b,
            0x39,
            0x7a,
            0xda,
            0x5a,
            0x88,
            0x67,
            0x49,
            0x1b,
            0xbb,
            0x13,
            0x01,
            0x30
        ]
            .span()
    );
    let expected_7 = RLPItem::String(
        array![
            0x15,
            0x35,
            0x8a,
            0x81,
            0x25,
            0x2e,
            0xc4,
            0x93,
            0x71,
            0x13,
            0xfe,
            0x36,
            0xc7,
            0x80,
            0x46,
            0xb7,
            0x11,
            0xfb,
            0xa1,
            0x97,
            0x34,
            0x91,
            0xbb,
            0x29,
            0x18,
            0x7a,
            0x00,
            0x78,
            0x5f,
            0xf8,
            0x52,
            0xae
        ]
            .span()
    );
    let expected_8 = RLPItem::String(
        array![
            0x68,
            0x91,
            0x42,
            0xd3,
            0x16,
            0xab,
            0xfa,
            0xa7,
            0x1c,
            0x8b,
            0xce,
            0xdf,
            0x49,
            0x20,
            0x1d,
            0xdb,
            0xb2,
            0x10,
            0x4e,
            0x25,
            0x0a,
            0xdc,
            0x90,
            0xc4,
            0xe8,
            0x56,
            0x22,
            0x1f,
            0x53,
            0x4a,
            0x96,
            0x58
        ]
            .span()
    );
    let expected_9 = RLPItem::String(
        array![
            0xdc,
            0x36,
            0x50,
            0x99,
            0x25,
            0x34,
            0xfd,
            0xa8,
            0xa3,
            0x14,
            0xa7,
            0xdb,
            0xb0,
            0xae,
            0x3b,
            0xa8,
            0xc7,
            0x9d,
            0xb5,
            0x55,
            0x0c,
            0x69,
            0xce,
            0x2a,
            0x24,
            0x60,
            0xc0,
            0x07,
            0xad,
            0xc4,
            0xc1,
            0xa3
        ]
            .span()
    );
    let expected_10 = RLPItem::String(
        array![
            0x20,
            0xb0,
            0x68,
            0x3b,
            0x66,
            0x55,
            0xb0,
            0x05,
            0x9e,
            0xe1,
            0x03,
            0xd0,
            0x4e,
            0x4b,
            0x50,
            0x6b,
            0xcb,
            0xc1,
            0x39,
            0x00,
            0x63,
            0x92,
            0xb7,
            0xda,
            0xb1,
            0x11,
            0x78,
            0xc2,
            0x66,
            0x03,
            0x42,
            0xe7
        ]
            .span()
    );
    let expected_11 = RLPItem::String(
        array![
            0x8e,
            0xed,
            0xeb,
            0x45,
            0xfb,
            0x63,
            0x0f,
            0x1c,
            0xd9,
            0x97,
            0x36,
            0xeb,
            0x18,
            0x57,
            0x22,
            0x17,
            0xcb,
            0xc6,
            0xd5,
            0xf3,
            0x15,
            0xb7,
            0x1b,
            0xe2,
            0x03,
            0xb0,
            0x3c,
            0xe8,
            0xd9,
            0x9b,
            0x26,
            0x14
        ]
            .span()
    );
    let expected_12 = RLPItem::String(
        array![
            0x79,
            0x23,
            0xa3,
            0x3d,
            0xf6,
            0x5a,
            0x98,
            0x6f,
            0xd5,
            0xe7,
            0xf9,
            0xe6,
            0xe4,
            0xc2,
            0xb9,
            0x69,
            0x73,
            0x6b,
            0x08,
            0x94,
            0x4e,
            0xbe,
            0x99,
            0x39,
            0x4a,
            0x86,
            0x14,
            0x61,
            0x2f,
            0xe6,
            0x09,
            0xf3
        ]
            .span()
    );
    let expected_13 = RLPItem::String(
        array![
            0x65,
            0x34,
            0xd7,
            0xd0,
            0x1a,
            0x20,
            0x71,
            0x4a,
            0xa4,
            0xfb,
            0x2a,
            0x55,
            0xb9,
            0x46,
            0xce,
            0x64,
            0xc3,
            0x22,
            0x2d,
            0xff,
            0xad,
            0x2a,
            0xa2,
            0xd1,
            0x8a,
            0x92,
            0x34,
            0x73,
            0xc9,
            0x2a,
            0xb1,
            0xfd
        ]
            .span()
    );
    let expected_14 = RLPItem::String(
        array![
            0xbf,
            0xf9,
            0xc2,
            0x8b,
            0xfe,
            0xb8,
            0xbf,
            0x2d,
            0xa9,
            0xb6,
            0x18,
            0xc8,
            0xc3,
            0xb0,
            0x6f,
            0xe8,
            0x0c,
            0xb1,
            0xc0,
            0xbd,
            0x14,
            0x47,
            0x38,
            0xf7,
            0xc4,
            0x21,
            0x61,
            0xff,
            0x29,
            0xe2,
            0x50,
            0x2f
        ]
            .span()
    );
    let expected_15 = RLPItem::String(
        array![
            0x7f,
            0x14,
            0x61,
            0x69,
            0x3c,
            0x70,
            0x4e,
            0xa5,
            0x02,
            0x1b,
            0xbb,
            0xa3,
            0x5e,
            0x72,
            0xc5,
            0x02,
            0xf6,
            0x43,
            0x9e,
            0x45,
            0x8f,
            0x98,
            0x24,
            0x2e,
            0xd0,
            0x37,
            0x48,
            0xea,
            0x8f,
            0xe2,
            0xb3,
            0x5f
        ]
            .span()
    );

    let expected_16 = RLPItem::String(array![].span());

    let expected = array![
        expected_0,
        expected_1,
        expected_2,
        expected_3,
        expected_4,
        expected_5,
        expected_6,
        expected_7,
        expected_8,
        expected_9,
        expected_10,
        expected_11,
        expected_12,
        expected_13,
        expected_14,
        expected_15,
        expected_16
    ];

    let expected_item = RLPItem::List(expected.span());

    assert!(res == array![expected_item].span(), "Wrong value");
}


#[test]
#[available_gas(99999999999)]
fn test_rlp_decode_long_list_with_input_too_short() {
    let mut arr = array![
        0xf9,
        0x02,
        0x11,
        0xa0,
        0x77,
        0x70,
        0xcf,
        0x09,
        0xb5,
        0x06,
        0x7a,
        0x1b,
        0x35,
        0xdf,
        0x62,
        0xa9,
        0x24,
        0x89,
        0x81,
        0x75,
        0xce,
        0xae,
        0xec,
        0xad,
        0x1f,
        0x68,
        0xcd,
        0xb4
    ];

    let res = RLPTrait::decode(arr.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}

#[test]
#[available_gas(99999999999)]
fn test_rlp_decode_long_list_with_len_too_short() {
    let arr = array![0xf9, 0x02,];

    let res = RLPTrait::decode(arr.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::InputTooShort, "err != InputTooShort");
}

#[test]
#[available_gas(20000000)]
fn test_rlp_encode_empty_input_should_fail() {
    let input = array![];

    let res = RLPTrait::encode(input.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::EmptyInput, "err != EmptyInput");
}


#[test]
#[available_gas(20000000)]
fn test_rlp_encode_default_value() {
    let input = RLPItem::String(array![].span());

    let res = RLPTrait::encode(array![input].span()).unwrap();

    assert!(res.len() == 1, "wrong len");
    assert!(*res[0] == 0x80, "wrong encoded value");
}

#[test]
#[available_gas(20000000)]
fn test_rlp_encode_string_single_byte_lt_0x80() {
    let mut input: Array<u8> = Default::default();
    input.append(0x40);

    let res = RLPTrait::encode(array![RLPItem::String(input.span())].span()).unwrap();

    assert!(res.len() == 1, "wrong len");
    assert!(*res[0] == 0x40, "wrong encoded value");
}

#[test]
#[available_gas(20000000)]
fn test_rlp_encode_string_single_byte_ge_0x80() {
    let mut input: Array<u8> = Default::default();
    input.append(0x80);

    let res = RLPTrait::encode(array![RLPItem::String(input.span())].span()).unwrap();

    assert!(res.len() == 2, "wrong len");
    assert!(*res[0] == 0x81, "wrong prefix");
    assert!(*res[1] == 0x80, "wrong encoded value");
}

#[test]
#[available_gas(20000000)]
fn test_rlp_encode_string_length_between_2_and_55() {
    let mut input: Array<u8> = Default::default();
    input.append(0x40);
    input.append(0x50);

    let res = RLPTrait::encode(array![RLPItem::String(input.span())].span()).unwrap();

    assert!(res.len() == 3, "wrong len");
    assert!(*res[0] == 0x82, "wrong prefix");
    assert!(*res[1] == 0x40, "wrong first value");
    assert!(*res[2] == 0x50, "wrong second value");
}

#[test]
#[available_gas(20000000)]
fn test_rlp_encode_string_length_exactly_56() {
    let mut input: Array<u8> = Default::default();
    let mut i = 0;
    while (i != 56) {
        input.append(0x60);
        i += 1;
    };

    let res = RLPTrait::encode(array![RLPItem::String(input.span())].span()).unwrap();

    assert!(res.len() == 58, "wrong len");
    assert!(*res[0] == 0xb8, "wrong prefix");
    assert!(*res[1] == 56, "wrong string length");
    let mut i = 2;
    while (i != 58) {
        if i == 58 {
            break;
        }
        assert!(*res[i] == 0x60, "wrong value in sequence");
        i += 1;
    };
}


#[test]
#[available_gas(20000000)]
fn test_rlp_encode_string_length_greater_than_56() {
    let mut input: Array<u8> = Default::default();
    let mut i = 0;
    while (i != 60) {
        input.append(0x70);
        i += 1;
    };

    let res = RLPTrait::encode(array![RLPItem::String(input.span())].span()).unwrap();

    assert!(res.len() == 62, "wrong len");
    assert!(*res[0] == 0xb8, "wrong prefix");
    assert!(*res[1] == 60, "wrong length byte");
    let mut i = 2;
    while (i != 62) {
        assert!(*res[i] == 0x70, "wrong value in sequence");
        i += 1;
    }
}

#[test]
#[available_gas(200000000)]
fn test_rlp_encode_string_large_bytearray_inputs() {
    let mut input: Array<u8> = Default::default();
    let mut i = 0;
    while (i != 500) {
        input.append(0x70);
        i += 1;
    };

    let res = RLPTrait::encode(array![RLPItem::String(input.span())].span()).unwrap();

    assert!(res.len() == 503, "wrong len");
    assert!(*res[0] == 0xb9, "wrong prefix");
    assert!(*res[1] == 0x01, "wrong first length byte");
    assert!(*res[2] == 0xF4, "wrong second length byte");
    let mut i = 3;
    while (i != 503) {
        assert!(*res[i] == 0x70, "wrong value in sequence");
        i += 1;
    }
}

#[test]
#[available_gas(20000000)]
fn test_rlp_encode_mutilple_string() {
    let mut input = array![];
    input.append(RLPItem::String(array![0x40, 0x53, 0x15, 0x94, 0x50, 0x40, 0x40, 0x40].span()));
    input.append(RLPItem::String(array![0x03].span()));

    let res = RLPTrait::encode(input.span()).unwrap();

    assert!(res.len() == 10, "wrong len");
    assert!(*res[0] == 0x88, "wrong prefix");
    assert!(*res[1] == 0x40, "wrong first value");
    assert!(*res[2] == 0x53, "wrong second value");
}

#[test]
#[available_gas(99999999999)]
fn test_rlp_encode_short_list() {
    let string_0 = RLPItem::String(array![0x35, 0x35, 0x35].span());
    let string_1 = RLPItem::String(array![0x42].span());
    let string_2 = RLPItem::String(array![0x45, 0x38, 0x92].span());

    let list = RLPItem::List(array![string_0, string_1, string_2].span());
    let res = RLPTrait::encode(array![list].span()).unwrap();

    let expected = array![0xc9, 0x83, 0x35, 0x35, 0x35, 0x42, 0x83, 0x45, 0x38, 0x92];

    assert!(res.len() == 10, "wrong len");
    assert!(res == expected.span(), "wrong encoded result");
}

#[test]
#[available_gas(99999999999)]
fn test_rlp_encode_short_nested_list() {
    let string_0 = RLPItem::List(array![].span());
    let string_1 = RLPItem::List(array![string_0].span());
    let string_2 = RLPItem::List(array![string_0, string_1].span());

    let list = RLPItem::List(array![string_0, string_1, string_2].span());
    let res = RLPTrait::encode(array![list].span()).unwrap();

    let expected = array![0xc7, 0xc0, 0xc1, 0xc0, 0xc3, 0xc0, 0xc1, 0xc0];

    assert!(res.len() == 8, "wrong len");
    assert!(res == expected.span(), "wrong encoded result");
}

#[test]
#[available_gas(99999999999)]
fn test_rlp_encode_long_list() {
    let string_0 = RLPItem::String(
        array![
            0x77,
            0x70,
            0xcf,
            0x09,
            0xb5,
            0x06,
            0x7a,
            0x1b,
            0x35,
            0xdf,
            0x62,
            0xa9,
            0x24,
            0x89,
            0x81,
            0x75,
            0xce,
            0xae,
            0xec,
            0xad,
            0x1f,
            0x68,
            0xcd,
            0xb4,
            0xa8,
            0x44,
            0x40,
            0x0c,
            0x73,
            0xc1,
            0x4a,
            0xf4
        ]
            .span()
    );
    let string_1 = RLPItem::String(
        array![
            0x1e,
            0xa3,
            0x85,
            0xd0,
            0x5a,
            0xb2,
            0x61,
            0x46,
            0x6d,
            0x5c,
            0x04,
            0x87,
            0xfe,
            0x68,
            0x45,
            0x34,
            0xc1,
            0x9f,
            0x1a,
            0x4b,
            0x5c,
            0x4b,
            0x18,
            0xdc,
            0x1a,
            0x36,
            0x35,
            0x60,
            0x02,
            0x50,
            0x71,
            0xb4
        ]
            .span()
    );
    let string_2 = RLPItem::String(
        array![
            0x2c,
            0x4c,
            0x04,
            0xce,
            0x35,
            0x40,
            0xd3,
            0xd1,
            0x46,
            0x18,
            0x72,
            0x30,
            0x3c,
            0x53,
            0xa5,
            0xe5,
            0x66,
            0x83,
            0xc1,
            0x30,
            0x4f,
            0x8d,
            0x36,
            0xa8,
            0x80,
            0x0c,
            0x6a,
            0xf5,
            0xfa,
            0x3f,
            0xcd,
            0xee
        ]
            .span()
    );
    let string_3 = RLPItem::String(
        array![
            0xa9,
            0xdc,
            0x77,
            0x8d,
            0xc5,
            0x4b,
            0x7d,
            0xd3,
            0xc4,
            0x82,
            0x22,
            0xe7,
            0x39,
            0xd1,
            0x61,
            0xfe,
            0xb0,
            0xc0,
            0xee,
            0xce,
            0xb2,
            0xdc,
            0xd5,
            0x17,
            0x37,
            0xf0,
            0x5b,
            0x8e,
            0x37,
            0xa6,
            0x38,
            0x51
        ]
            .span()
    );
    let string_4 = RLPItem::String(
        array![
            0xa9,
            0x5f,
            0x4d,
            0x55,
            0x56,
            0xdf,
            0x62,
            0xdd,
            0xc2,
            0x62,
            0x99,
            0x04,
            0x97,
            0xae,
            0x56,
            0x9b,
            0xcd,
            0x8e,
            0xfd,
            0xda,
            0x7b,
            0x20,
            0x07,
            0x93,
            0xf8,
            0xd3,
            0xde,
            0x4c,
            0xdb,
            0x97,
            0x18,
            0xd7
        ]
            .span()
    );
    let string_5 = RLPItem::String(
        array![
            0x39,
            0xd4,
            0x06,
            0x6d,
            0x14,
            0x38,
            0x22,
            0x6e,
            0xaf,
            0x4a,
            0xc9,
            0xe9,
            0x43,
            0xa8,
            0x74,
            0xa9,
            0xa9,
            0xc2,
            0x5f,
            0xb0,
            0xd8,
            0x1d,
            0xb9,
            0x86,
            0x1d,
            0x8c,
            0x13,
            0x36,
            0xb3,
            0xe2,
            0x03,
            0x4c
        ]
            .span()
    );
    let string_6 = RLPItem::String(
        array![
            0x7a,
            0xcc,
            0x7c,
            0x63,
            0xb4,
            0x6a,
            0xa4,
            0x18,
            0xb3,
            0xc9,
            0xa0,
            0x41,
            0xa1,
            0x25,
            0x6b,
            0xcb,
            0x73,
            0x61,
            0x31,
            0x6b,
            0x39,
            0x7a,
            0xda,
            0x5a,
            0x88,
            0x67,
            0x49,
            0x1b,
            0xbb,
            0x13,
            0x01,
            0x30
        ]
            .span()
    );
    let string_7 = RLPItem::String(
        array![
            0x15,
            0x35,
            0x8a,
            0x81,
            0x25,
            0x2e,
            0xc4,
            0x93,
            0x71,
            0x13,
            0xfe,
            0x36,
            0xc7,
            0x80,
            0x46,
            0xb7,
            0x11,
            0xfb,
            0xa1,
            0x97,
            0x34,
            0x91,
            0xbb,
            0x29,
            0x18,
            0x7a,
            0x00,
            0x78,
            0x5f,
            0xf8,
            0x52,
            0xae
        ]
            .span()
    );
    let string_8 = RLPItem::String(
        array![
            0x68,
            0x91,
            0x42,
            0xd3,
            0x16,
            0xab,
            0xfa,
            0xa7,
            0x1c,
            0x8b,
            0xce,
            0xdf,
            0x49,
            0x20,
            0x1d,
            0xdb,
            0xb2,
            0x10,
            0x4e,
            0x25,
            0x0a,
            0xdc,
            0x90,
            0xc4,
            0xe8,
            0x56,
            0x22,
            0x1f,
            0x53,
            0x4a,
            0x96,
            0x58
        ]
            .span()
    );
    let string_9 = RLPItem::String(
        array![
            0xdc,
            0x36,
            0x50,
            0x99,
            0x25,
            0x34,
            0xfd,
            0xa8,
            0xa3,
            0x14,
            0xa7,
            0xdb,
            0xb0,
            0xae,
            0x3b,
            0xa8,
            0xc7,
            0x9d,
            0xb5,
            0x55,
            0x0c,
            0x69,
            0xce,
            0x2a,
            0x24,
            0x60,
            0xc0,
            0x07,
            0xad,
            0xc4,
            0xc1,
            0xa3
        ]
            .span()
    );
    let string_10 = RLPItem::String(
        array![
            0x20,
            0xb0,
            0x68,
            0x3b,
            0x66,
            0x55,
            0xb0,
            0x05,
            0x9e,
            0xe1,
            0x03,
            0xd0,
            0x4e,
            0x4b,
            0x50,
            0x6b,
            0xcb,
            0xc1,
            0x39,
            0x00,
            0x63,
            0x92,
            0xb7,
            0xda,
            0xb1,
            0x11,
            0x78,
            0xc2,
            0x66,
            0x03,
            0x42,
            0xe7
        ]
            .span()
    );
    let string_11 = RLPItem::String(
        array![
            0x8e,
            0xed,
            0xeb,
            0x45,
            0xfb,
            0x63,
            0x0f,
            0x1c,
            0xd9,
            0x97,
            0x36,
            0xeb,
            0x18,
            0x57,
            0x22,
            0x17,
            0xcb,
            0xc6,
            0xd5,
            0xf3,
            0x15,
            0xb7,
            0x1b,
            0xe2,
            0x03,
            0xb0,
            0x3c,
            0xe8,
            0xd9,
            0x9b,
            0x26,
            0x14
        ]
            .span()
    );
    let string_12 = RLPItem::String(
        array![
            0x79,
            0x23,
            0xa3,
            0x3d,
            0xf6,
            0x5a,
            0x98,
            0x6f,
            0xd5,
            0xe7,
            0xf9,
            0xe6,
            0xe4,
            0xc2,
            0xb9,
            0x69,
            0x73,
            0x6b,
            0x08,
            0x94,
            0x4e,
            0xbe,
            0x99,
            0x39,
            0x4a,
            0x86,
            0x14,
            0x61,
            0x2f,
            0xe6,
            0x09,
            0xf3
        ]
            .span()
    );
    let string_13 = RLPItem::String(
        array![
            0x65,
            0x34,
            0xd7,
            0xd0,
            0x1a,
            0x20,
            0x71,
            0x4a,
            0xa4,
            0xfb,
            0x2a,
            0x55,
            0xb9,
            0x46,
            0xce,
            0x64,
            0xc3,
            0x22,
            0x2d,
            0xff,
            0xad,
            0x2a,
            0xa2,
            0xd1,
            0x8a,
            0x92,
            0x34,
            0x73,
            0xc9,
            0x2a,
            0xb1,
            0xfd
        ]
            .span()
    );
    let string_14 = RLPItem::String(
        array![
            0xbf,
            0xf9,
            0xc2,
            0x8b,
            0xfe,
            0xb8,
            0xbf,
            0x2d,
            0xa9,
            0xb6,
            0x18,
            0xc8,
            0xc3,
            0xb0,
            0x6f,
            0xe8,
            0x0c,
            0xb1,
            0xc0,
            0xbd,
            0x14,
            0x47,
            0x38,
            0xf7,
            0xc4,
            0x21,
            0x61,
            0xff,
            0x29,
            0xe2,
            0x50,
            0x2f
        ]
            .span()
    );
    let string_15 = RLPItem::String(
        array![
            0x7f,
            0x14,
            0x61,
            0x69,
            0x3c,
            0x70,
            0x4e,
            0xa5,
            0x02,
            0x1b,
            0xbb,
            0xa3,
            0x5e,
            0x72,
            0xc5,
            0x02,
            0xf6,
            0x43,
            0x9e,
            0x45,
            0x8f,
            0x98,
            0x24,
            0x2e,
            0xd0,
            0x37,
            0x48,
            0xea,
            0x8f,
            0xe2,
            0xb3,
            0x5f
        ]
            .span()
    );

    let string_16 = RLPItem::String(array![].span());

    let strings_list = array![
        string_0,
        string_1,
        string_2,
        string_3,
        string_4,
        string_5,
        string_6,
        string_7,
        string_8,
        string_9,
        string_10,
        string_11,
        string_12,
        string_13,
        string_14,
        string_15,
        string_16
    ];

    let list = RLPItem::List(strings_list.span());

    let res = RLPTrait::encode(array![list].span()).unwrap();

    let expected = array![
        0xf9,
        0x02,
        0x11,
        0xa0,
        0x77,
        0x70,
        0xcf,
        0x09,
        0xb5,
        0x06,
        0x7a,
        0x1b,
        0x35,
        0xdf,
        0x62,
        0xa9,
        0x24,
        0x89,
        0x81,
        0x75,
        0xce,
        0xae,
        0xec,
        0xad,
        0x1f,
        0x68,
        0xcd,
        0xb4,
        0xa8,
        0x44,
        0x40,
        0x0c,
        0x73,
        0xc1,
        0x4a,
        0xf4,
        0xa0,
        0x1e,
        0xa3,
        0x85,
        0xd0,
        0x5a,
        0xb2,
        0x61,
        0x46,
        0x6d,
        0x5c,
        0x04,
        0x87,
        0xfe,
        0x68,
        0x45,
        0x34,
        0xc1,
        0x9f,
        0x1a,
        0x4b,
        0x5c,
        0x4b,
        0x18,
        0xdc,
        0x1a,
        0x36,
        0x35,
        0x60,
        0x02,
        0x50,
        0x71,
        0xb4,
        0xa0,
        0x2c,
        0x4c,
        0x04,
        0xce,
        0x35,
        0x40,
        0xd3,
        0xd1,
        0x46,
        0x18,
        0x72,
        0x30,
        0x3c,
        0x53,
        0xa5,
        0xe5,
        0x66,
        0x83,
        0xc1,
        0x30,
        0x4f,
        0x8d,
        0x36,
        0xa8,
        0x80,
        0x0c,
        0x6a,
        0xf5,
        0xfa,
        0x3f,
        0xcd,
        0xee,
        0xa0,
        0xa9,
        0xdc,
        0x77,
        0x8d,
        0xc5,
        0x4b,
        0x7d,
        0xd3,
        0xc4,
        0x82,
        0x22,
        0xe7,
        0x39,
        0xd1,
        0x61,
        0xfe,
        0xb0,
        0xc0,
        0xee,
        0xce,
        0xb2,
        0xdc,
        0xd5,
        0x17,
        0x37,
        0xf0,
        0x5b,
        0x8e,
        0x37,
        0xa6,
        0x38,
        0x51,
        0xa0,
        0xa9,
        0x5f,
        0x4d,
        0x55,
        0x56,
        0xdf,
        0x62,
        0xdd,
        0xc2,
        0x62,
        0x99,
        0x04,
        0x97,
        0xae,
        0x56,
        0x9b,
        0xcd,
        0x8e,
        0xfd,
        0xda,
        0x7b,
        0x20,
        0x07,
        0x93,
        0xf8,
        0xd3,
        0xde,
        0x4c,
        0xdb,
        0x97,
        0x18,
        0xd7,
        0xa0,
        0x39,
        0xd4,
        0x06,
        0x6d,
        0x14,
        0x38,
        0x22,
        0x6e,
        0xaf,
        0x4a,
        0xc9,
        0xe9,
        0x43,
        0xa8,
        0x74,
        0xa9,
        0xa9,
        0xc2,
        0x5f,
        0xb0,
        0xd8,
        0x1d,
        0xb9,
        0x86,
        0x1d,
        0x8c,
        0x13,
        0x36,
        0xb3,
        0xe2,
        0x03,
        0x4c,
        0xa0,
        0x7a,
        0xcc,
        0x7c,
        0x63,
        0xb4,
        0x6a,
        0xa4,
        0x18,
        0xb3,
        0xc9,
        0xa0,
        0x41,
        0xa1,
        0x25,
        0x6b,
        0xcb,
        0x73,
        0x61,
        0x31,
        0x6b,
        0x39,
        0x7a,
        0xda,
        0x5a,
        0x88,
        0x67,
        0x49,
        0x1b,
        0xbb,
        0x13,
        0x01,
        0x30,
        0xa0,
        0x15,
        0x35,
        0x8a,
        0x81,
        0x25,
        0x2e,
        0xc4,
        0x93,
        0x71,
        0x13,
        0xfe,
        0x36,
        0xc7,
        0x80,
        0x46,
        0xb7,
        0x11,
        0xfb,
        0xa1,
        0x97,
        0x34,
        0x91,
        0xbb,
        0x29,
        0x18,
        0x7a,
        0x00,
        0x78,
        0x5f,
        0xf8,
        0x52,
        0xae,
        0xa0,
        0x68,
        0x91,
        0x42,
        0xd3,
        0x16,
        0xab,
        0xfa,
        0xa7,
        0x1c,
        0x8b,
        0xce,
        0xdf,
        0x49,
        0x20,
        0x1d,
        0xdb,
        0xb2,
        0x10,
        0x4e,
        0x25,
        0x0a,
        0xdc,
        0x90,
        0xc4,
        0xe8,
        0x56,
        0x22,
        0x1f,
        0x53,
        0x4a,
        0x96,
        0x58,
        0xa0,
        0xdc,
        0x36,
        0x50,
        0x99,
        0x25,
        0x34,
        0xfd,
        0xa8,
        0xa3,
        0x14,
        0xa7,
        0xdb,
        0xb0,
        0xae,
        0x3b,
        0xa8,
        0xc7,
        0x9d,
        0xb5,
        0x55,
        0x0c,
        0x69,
        0xce,
        0x2a,
        0x24,
        0x60,
        0xc0,
        0x07,
        0xad,
        0xc4,
        0xc1,
        0xa3,
        0xa0,
        0x20,
        0xb0,
        0x68,
        0x3b,
        0x66,
        0x55,
        0xb0,
        0x05,
        0x9e,
        0xe1,
        0x03,
        0xd0,
        0x4e,
        0x4b,
        0x50,
        0x6b,
        0xcb,
        0xc1,
        0x39,
        0x00,
        0x63,
        0x92,
        0xb7,
        0xda,
        0xb1,
        0x11,
        0x78,
        0xc2,
        0x66,
        0x03,
        0x42,
        0xe7,
        0xa0,
        0x8e,
        0xed,
        0xeb,
        0x45,
        0xfb,
        0x63,
        0x0f,
        0x1c,
        0xd9,
        0x97,
        0x36,
        0xeb,
        0x18,
        0x57,
        0x22,
        0x17,
        0xcb,
        0xc6,
        0xd5,
        0xf3,
        0x15,
        0xb7,
        0x1b,
        0xe2,
        0x03,
        0xb0,
        0x3c,
        0xe8,
        0xd9,
        0x9b,
        0x26,
        0x14,
        0xa0,
        0x79,
        0x23,
        0xa3,
        0x3d,
        0xf6,
        0x5a,
        0x98,
        0x6f,
        0xd5,
        0xe7,
        0xf9,
        0xe6,
        0xe4,
        0xc2,
        0xb9,
        0x69,
        0x73,
        0x6b,
        0x08,
        0x94,
        0x4e,
        0xbe,
        0x99,
        0x39,
        0x4a,
        0x86,
        0x14,
        0x61,
        0x2f,
        0xe6,
        0x09,
        0xf3,
        0xa0,
        0x65,
        0x34,
        0xd7,
        0xd0,
        0x1a,
        0x20,
        0x71,
        0x4a,
        0xa4,
        0xfb,
        0x2a,
        0x55,
        0xb9,
        0x46,
        0xce,
        0x64,
        0xc3,
        0x22,
        0x2d,
        0xff,
        0xad,
        0x2a,
        0xa2,
        0xd1,
        0x8a,
        0x92,
        0x34,
        0x73,
        0xc9,
        0x2a,
        0xb1,
        0xfd,
        0xa0,
        0xbf,
        0xf9,
        0xc2,
        0x8b,
        0xfe,
        0xb8,
        0xbf,
        0x2d,
        0xa9,
        0xb6,
        0x18,
        0xc8,
        0xc3,
        0xb0,
        0x6f,
        0xe8,
        0x0c,
        0xb1,
        0xc0,
        0xbd,
        0x14,
        0x47,
        0x38,
        0xf7,
        0xc4,
        0x21,
        0x61,
        0xff,
        0x29,
        0xe2,
        0x50,
        0x2f,
        0xa0,
        0x7f,
        0x14,
        0x61,
        0x69,
        0x3c,
        0x70,
        0x4e,
        0xa5,
        0x02,
        0x1b,
        0xbb,
        0xa3,
        0x5e,
        0x72,
        0xc5,
        0x02,
        0xf6,
        0x43,
        0x9e,
        0x45,
        0x8f,
        0x98,
        0x24,
        0x2e,
        0xd0,
        0x37,
        0x48,
        0xea,
        0x8f,
        0xe2,
        0xb3,
        0x5f,
        0x80
    ];

    assert!(res == expected.span(), "Wrong value");
}
