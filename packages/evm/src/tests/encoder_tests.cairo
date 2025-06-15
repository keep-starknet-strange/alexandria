use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use encoder::AbiEncodeTrait;
use crate::encoder;
use crate::evm_enum::EVMTypes;

fn new_encoder() -> encoder::EVMCalldata {
    encoder::EVMCalldata {
        calldata: Default::default(),
        offset: 0,
        dynamic_data: Default::default(),
        dynamic_offset: 0,
    }
}

#[test]
fn test_encode_felt252() {
    let mut encoder_ctx = new_encoder();
    let values = array![0xffff00000000000000000000000000000000000000000000020].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Felt252].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x0000000000000ffff00000000000000000000000000000000000000000000020);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_felt252_max() {
    let mut encoder_ctx = new_encoder();
    let values = array![0x800000000000011000000000000000000000000000000000000000000000000].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Felt252].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes
        .append_felt252(0x0800000000000011000000000000000000000000000000000000000000000000);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_uint128() {
    let mut encoder_ctx = new_encoder();
    let values = array![0x20, 0x44].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Uint128, EVMTypes::Uint128].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000044);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_uint256() {
    let mut encoder_ctx = new_encoder();
    let values = array![0x20, 0x0, 0x44].span(); // low, high, next_value
    let encoded = encoder_ctx.encode(array![EVMTypes::Uint256, EVMTypes::Uint128].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000044);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_address() {
    let mut encoder_ctx = new_encoder();
    let values = array![0x742d35Cc6634C0532925a3b844Bc454e4438f44e].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Address].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x000000000000000000000000742d35Cc6634C0532925a3b844Bc454e4438f44e);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_bool_true() {
    let mut encoder_ctx = new_encoder();
    let values = array![1].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Bool].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_bool_false() {
    let mut encoder_ctx = new_encoder();
    let values = array![0].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Bool].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000000);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_int8_positive() {
    let mut encoder_ctx = new_encoder();
    let values = array![5].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Int8].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000005);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_int8_negative() {
    let mut encoder_ctx = new_encoder();
    let values = array![-5].span(); // In Cairo, this would be represented as FELT252_MAX - 4
    let encoded = encoder_ctx.encode(array![EVMTypes::Int8].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_int128_negative() {
    let mut encoder_ctx = new_encoder();
    let values = array![-128].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Int128].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff80);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_int256_positive() {
    let mut encoder_ctx = new_encoder();
    let values = array![60, 0, 0].span(); // low, high, sign_bit
    let encoded = encoder_ctx.encode(array![EVMTypes::Int256].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x000000000000000000000000000000000000000000000000000000000000003c);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_int256_negative() {
    let mut encoder_ctx = new_encoder();
    let values = array![50, 0, 1].span(); // low, high, sign_bit (1 means negative)
    let encoded = encoder_ctx.encode(array![EVMTypes::Int256].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffce);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_int256_zero() {
    let mut encoder_ctx = new_encoder();
    let values = array![0, 0, 0].span(); // low, high, sign_bit
    let encoded = encoder_ctx.encode(array![EVMTypes::Int256].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000000);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_bytes2() {
    let mut encoder_ctx = new_encoder();
    // For fixed bytes, pass the value as a single felt252
    // 0xff22 as a felt252 value
    let values = array![0xff22].span();

    let encoded = encoder_ctx.encode(array![EVMTypes::Bytes2].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0xff22000000000000000000000000000000000000000000000000000000000000);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_bytes32() {
    let mut encoder_ctx = new_encoder();

    // Debug: check lengths
    let types = array![EVMTypes::Bytes32].span();
    let values = array![
        0xffffffffffffffffffffffffffffffff, // low: lower 128 bits (16 bytes of 0xff)
        0xaaffffffffffffffffffffffffffffff // high: upper 128 bits (0xaa + 15 bytes of 0xff)
    ]
        .span();

    // These should be equal now
    assert!(types.len() == 1, "Types length should be 1");
    assert!(values.len() == 2, "Values length should be 2");

    let encoded = encoder_ctx.encode(types, values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0xaaffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_function_signature() {
    let mut encoder_ctx = new_encoder();
    let values = array![0x23b872dd].span(); // transferFrom selector
    let encoded = encoder_ctx.encode(array![EVMTypes::FunctionSignature].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x23b872dd00000000000000000000000000000000000000000000000000000000);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_tuple_static() {
    let mut encoder_ctx = new_encoder();
    let values = array![0x7b, 0x22b].span(); // 123, 555
    let tuple_types = array![EVMTypes::Uint128, EVMTypes::Uint128].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Tuple(tuple_types)].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x000000000000000000000000000000000000000000000000000000000000007b);
    expected_bytes.append_u256(0x000000000000000000000000000000000000000000000000000000000000022b);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_tuple_uint256() {
    let mut encoder_ctx = new_encoder();
    let values = array![0x7b, 0x0, 0x22b, 0x0].span(); // (123 as u256), (555 as u256)
    let tuple_types = array![EVMTypes::Uint256, EVMTypes::Uint256].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Tuple(tuple_types)].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    expected_bytes.append_u256(0x000000000000000000000000000000000000000000000000000000000000007b);
    expected_bytes.append_u256(0x000000000000000000000000000000000000000000000000000000000000022b);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_array_uint128() {
    let mut encoder_ctx = new_encoder();
    let values = array![0x3, 0x1bd, 0x16462, 0x1a6e41e3].span(); // length=3, then 3 values
    let array_types = array![EVMTypes::Uint128].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Array(array_types)].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Array length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    // Array elements
    expected_bytes.append_u256(0x00000000000000000000000000000000000000000000000000000000000001bd);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000016462);
    expected_bytes.append_u256(0x000000000000000000000000000000000000000000000000000000001a6e41e3);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_array_of_struct() {
    let mut encoder_ctx = new_encoder();
    // Array length=3, then 3 tuples of (uint128, uint128)
    let values = array![0x3, 0xb, 0x16, 0x1618, 0x36f, 0xe8d4a50fff, 0x989680].span();
    let tuple_types = array![EVMTypes::Uint128, EVMTypes::Uint128].span();
    let array_types = array![EVMTypes::Tuple(tuple_types)].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Array(array_types)].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Array length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    // First tuple
    expected_bytes.append_u256(0x000000000000000000000000000000000000000000000000000000000000000b);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000016);
    // Second tuple
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000001618);
    expected_bytes.append_u256(0x000000000000000000000000000000000000000000000000000000000000036f);
    // Third tuple
    expected_bytes.append_u256(0x000000000000000000000000000000000000000000000000000000e8d4a50fff);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000989680);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_bytes_short() {
    let mut encoder_ctx = new_encoder();
    // ByteArray representation of 3 bytes: 0xffaabb
    let mut ba: ByteArray = Default::default();
    ba.append_byte(0xff);
    ba.append_byte(0xaa);
    ba.append_byte(0xbb);
    let mut serialized = array![];
    ba.serialize(ref serialized);

    let encoded = encoder_ctx.encode(array![EVMTypes::Bytes].span(), serialized.span());

    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    // Data (left-aligned, padded to 32 bytes)
    expected_bytes.append_u256(0xffaabb0000000000000000000000000000000000000000000000000000000000);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_bytes_one_full_slot() {
    let mut encoder_ctx = new_encoder();
    // ByteArray representation of 32 bytes
    let mut ba: ByteArray = Default::default();
    ba.append_u256(0xffffffffffffffffffaaaaaaaaaaaaaaaaaaafffffffffffffffffafafafaffa);
    let mut serialized = array![];
    ba.serialize(ref serialized);

    let encoded = encoder_ctx.encode(array![EVMTypes::Bytes].span(), serialized.span());

    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Data
    expected_bytes.append_u256(0xffffffffffffffffffaaaaaaaaaaaaaaaaaaafffffffffffffffffafafafaffa);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_string() {
    let mut encoder_ctx = new_encoder();
    let mut ba: ByteArray = "ALI";
    let mut serialized = array![];
    ba.serialize(ref serialized);

    let encoded = encoder_ctx.encode(array![EVMTypes::String].span(), serialized.span());

    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    // Data "ALI" (left-aligned, padded)
    expected_bytes.append_u256(0x414c490000000000000000000000000000000000000000000000000000000000);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_complex_mixed_types() {
    let mut encoder_ctx = new_encoder();
    // Encoding: bytes, uint256, int128, array of tuples
    // This should match the decoder test: test_decode_complex

    // 1. Prepare bytes data: 0x00bbffaa00 (5 bytes)
    let mut ba: ByteArray = Default::default();
    ba.append_byte(0x00);
    ba.append_byte(0xbb);
    ba.append_byte(0xff);
    ba.append_byte(0xaa);
    ba.append_byte(0x00);
    let mut bytes_serialized = array![];
    ba.serialize(ref bytes_serialized);

    // 2. Prepare all values in order
    let mut all_values = array![];

    // Add bytes data
    let mut i = 0;
    while i < bytes_serialized.len() {
        all_values.append(*bytes_serialized.at(i));
        i += 1;
    }

    // Add uint256: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    all_values.append(0xffffffffffffffffffffffffffffffff); // low (16 bytes of 0xff)
    all_values.append(0xffffffffffffffffffffffffffffffff); // high (16 bytes of 0xff)

    // Add int128: -48923 (encoded as two's complement)
    all_values.append(-48923); // This should be 0xffffffffffffffffffffffffffff40e5 in felt252

    // Add array of tuples: [(111, 222), (777, 888)]
    all_values.append(0x2); // array length = 2
    all_values.append(0x6f); // 111
    all_values.append(0xde); // 222
    all_values.append(0x309); // 777
    all_values.append(0x378); // 888

    // 3. Define types
    let tuple_types = array![EVMTypes::Uint128, EVMTypes::Uint128].span();
    let array_types = array![EVMTypes::Tuple(tuple_types)].span();
    let types = array![
        EVMTypes::Bytes, EVMTypes::Uint256, EVMTypes::Int128, EVMTypes::Array(array_types),
    ]
        .span();

    // 4. Encode
    let encoded = encoder_ctx.encode(types, all_values.span());

    // 5. Verify expected structure with proper assertions
    let mut expected_bytes: ByteArray = Default::default();

    // Offset to bytes (first dynamic field)
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Uint256 value (all 0xff)
    expected_bytes.append_u256(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    // Int128 value (-48923 = 0xffffffffffffffffffffffffffff40e5)
    expected_bytes.append_u256(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff40e5);
    // Offset to array (second dynamic field)
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000060);

    // Bytes data
    expected_bytes
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000005,
        ); // length = 5
    expected_bytes
        .append_u256(0x00bbffaa00000000000000000000000000000000000000000000000000000000); // data

    // Array data
    expected_bytes
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000002,
        ); // length = 2
    expected_bytes
        .append_u256(0x000000000000000000000000000000000000000000000000000000000000006f); // 111
    expected_bytes
        .append_u256(0x00000000000000000000000000000000000000000000000000000000000000de); // 222
    expected_bytes
        .append_u256(0x0000000000000000000000000000000000000000000000000000000000000309); // 777
    expected_bytes
        .append_u256(0x0000000000000000000000000000000000000000000000000000000000000378); // 888

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_array_of_strings() {
    let mut encoder_ctx = new_encoder();

    // Array of 2 strings: "ALI", "VELI"
    let mut ali_ba: ByteArray = "ALI";
    let mut ali_serialized = array![];
    ali_ba.serialize(ref ali_serialized);

    let mut veli_ba: ByteArray = "VELI";
    let mut veli_serialized = array![];
    veli_ba.serialize(ref veli_serialized);

    // Combine all serialized strings with array length at the beginning
    let mut all_values = array![2]; // Array length
    let mut i = 0;
    while i < ali_serialized.len() {
        all_values.append(*ali_serialized.at(i));
        i += 1;
    }
    i = 0;
    while i < veli_serialized.len() {
        all_values.append(*veli_serialized.at(i));
        i += 1;
    }

    let array_types = array![EVMTypes::String].span();
    let encoded = encoder_ctx
        .encode(array![EVMTypes::Array(array_types)].span(), all_values.span());

    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Array length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002);
    // Offsets to each string (relative to start of array data)
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000040);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000080);
    // First string "ALI"
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    expected_bytes.append_u256(0x414c490000000000000000000000000000000000000000000000000000000000);
    // Second string "VELI"
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000004);
    expected_bytes.append_u256(0x56454c4900000000000000000000000000000000000000000000000000000000);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_array_of_strings_long_elements() {
    let mut encoder_ctx = new_encoder();

    // Create array of 4 strings: "ALI", "VELI", long string, "shortback"
    let mut ali_ba: ByteArray = "ALI";
    let mut ali_serialized = array![];
    ali_ba.serialize(ref ali_serialized);

    let mut veli_ba: ByteArray = "VELI";
    let mut veli_serialized = array![];
    veli_ba.serialize(ref veli_serialized);

    let mut long_ba: ByteArray = "LONGSTRINGLONGERTHAN1231231231233123ASASDASDADAD";
    let mut long_serialized = array![];
    long_ba.serialize(ref long_serialized);

    let mut short_ba: ByteArray = "shortback";
    let mut short_serialized = array![];
    short_ba.serialize(ref short_serialized);
    // Combine all serialized strings with array length at the beginning
    let mut all_values = array![4]; // Array length
    let mut i = 0;
    while i < ali_serialized.len() {
        all_values.append(*ali_serialized.at(i));
        i += 1;
    }
    i = 0;
    while i < veli_serialized.len() {
        all_values.append(*veli_serialized.at(i));
        i += 1;
    }
    i = 0;
    while i < long_serialized.len() {
        all_values.append(*long_serialized.at(i));
        i += 1;
    }
    i = 0;
    while i < short_serialized.len() {
        all_values.append(*short_serialized.at(i));
        i += 1;
    }
    let array_types = array![EVMTypes::String].span();
    let encoded = encoder_ctx
        .encode(array![EVMTypes::Array(array_types)].span(), all_values.span());
    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Array length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000004);
    // Offsets to each string (relative to start of array data)
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000080);
    expected_bytes.append_u256(0x00000000000000000000000000000000000000000000000000000000000000c0);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000100);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000160);
    // First string "ALI"
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    expected_bytes.append_u256(0x414c490000000000000000000000000000000000000000000000000000000000);
    // Second string "VELI"
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000004);
    expected_bytes.append_u256(0x56454c4900000000000000000000000000000000000000000000000000000000);
    // Third string (long string) - 48 bytes
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000030);
    expected_bytes.append_u256(0x4c4f4e47535452494e474c4f4e4745525448414e313233313233313233313233);
    expected_bytes.append_u256(0x3331323341534153444153444144414400000000000000000000000000000000);
    // Fourth string "shortback"
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000009);
    expected_bytes.append_u256(0x73686f72746261636b0000000000000000000000000000000000000000000000);
    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_array_of_struct_mixed_types() {
    let mut encoder_ctx = new_encoder();
    // Array of structs with mixed types: (uint128, address, bool)
    // Array length=2, then 2 structs
    let values = array![
        0x2, // array length
        0x7b, // first struct: uint128 = 123
        0x742d35Cc6634C0532925a3b844Bc454e4438f44e, // address
        0x1, // bool = true
        0x1a4, // second struct: uint128 = 420
        0x1111111111111111111111111111111111111111, // address
        0x0 // bool = false
    ]
        .span();

    let tuple_types = array![EVMTypes::Uint128, EVMTypes::Address, EVMTypes::Bool].span();
    let array_types = array![EVMTypes::Tuple(tuple_types)].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Array(array_types)].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Array length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002);
    // First struct
    expected_bytes.append_u256(0x000000000000000000000000000000000000000000000000000000000000007b);
    expected_bytes.append_u256(0x000000000000000000000000742d35Cc6634C0532925a3b844Bc454e4438f44e);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);
    // Second struct
    expected_bytes.append_u256(0x00000000000000000000000000000000000000000000000000000000000001a4);
    expected_bytes.append_u256(0x0000000000000000000000001111111111111111111111111111111111111111);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000000);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_array_of_struct_with_different_types() {
    let mut encoder_ctx = new_encoder();
    // Array of structs with different field types: (uint256, address)
    // Array length=2, then 2 tuples
    let values = array![
        0x2, // array length
        0x123,
        0x0, // first struct: uint256 = (0x123, 0x0)
        0x742d35Cc6634C0532925a3b844Bc454e4438f44e, // address
        0x456,
        0x0, // second struct: uint256 = (0x456, 0x0)
        0x1111111111111111111111111111111111111111 // address
    ]
        .span();

    let tuple_types = array![EVMTypes::Uint256, EVMTypes::Address].span();
    let array_types = array![EVMTypes::Tuple(tuple_types)].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Array(array_types)].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Array length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002);
    // First struct
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000123);
    expected_bytes.append_u256(0x000000000000000000000000742d35Cc6634C0532925a3b844Bc454e4438f44e);
    // Second struct
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000456);
    expected_bytes.append_u256(0x0000000000000000000000001111111111111111111111111111111111111111);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_array_of_addresses() {
    let mut encoder_ctx = new_encoder();
    // Test array of addresses: [addr1, addr2, addr3]
    let values = array![
        0x3, // length=3
        0x742d35Cc6634C0532925a3b844Bc454e4438f44e, // address 1
        0x1111111111111111111111111111111111111111, // address 2  
        0x2222222222222222222222222222222222222222 // address 3
    ]
        .span();

    let array_types = array![EVMTypes::Address].span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Array(array_types)].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Array length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    // Array elements
    expected_bytes.append_u256(0x000000000000000000000000742d35Cc6634C0532925a3b844Bc454e4438f44e);
    expected_bytes.append_u256(0x0000000000000000000000001111111111111111111111111111111111111111);
    expected_bytes.append_u256(0x0000000000000000000000002222222222222222222222222222222222222222);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_struct_with_multiple_static_fields() {
    let mut encoder_ctx = new_encoder();
    // Struct with multiple static fields: (uint256, address, bool, uint128)
    let values = array![
        0x1234,
        0x0, // uint256 = (0x1234, 0x0)
        0x742d35Cc6634C0532925a3b844Bc454e4438f44e, // address
        0x1, // bool = true
        0x5678 // uint128 = 0x5678
    ]
        .span();

    let struct_types = array![
        EVMTypes::Uint256, EVMTypes::Address, EVMTypes::Bool, EVMTypes::Uint128,
    ]
        .span();
    let encoded = encoder_ctx.encode(array![EVMTypes::Tuple(struct_types)].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    // All fields are static, so they're encoded inline
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000001234);
    expected_bytes.append_u256(0x000000000000000000000000742d35Cc6634C0532925a3b844Bc454e4438f44e);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000005678);

    assert_eq!(encoded, expected_bytes);
}
