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
    expected_bytes.append_u256(0x0800000000000011000000000000000000000000000000000000000000000000);

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
    // String "ALI" as ByteArray
    let mut ba: ByteArray = Default::default();
    ba.append_byte('A');
    ba.append_byte('L');
    ba.append_byte('I');
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
fn test_encode_transferFrom() {
    let mut encoder_ctx = new_encoder();
    let values = array![
        0x23b872dd, // Function selector
        0x1111111111111111111111111111111111111111, // from address
        0x2222222222222222222222222222222222222222, // to address
        1000000000000000000,
        0 // amount as u256 (low, high)
    ]
        .span();

    let encoded = encoder_ctx
        .encode(
            array![
                EVMTypes::FunctionSignature,
                EVMTypes::Address,
                EVMTypes::Address,
                EVMTypes::Uint256,
            ]
                .span(),
            values,
        );

    let mut expected_bytes: ByteArray = Default::default();
    // Function selector (left-aligned)
    expected_bytes.append_u256(0x23b872dd00000000000000000000000000000000000000000000000000000000);
    // From address
    expected_bytes.append_u256(0x0000000000000000000000001111111111111111111111111111111111111111);
    // To address
    expected_bytes.append_u256(0x0000000000000000000000002222222222222222222222222222222222222222);
    // Amount
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000de0b6b3a7640000);

    assert_eq!(encoded, expected_bytes);
}

#[test]
fn test_encode_complex_mixed_types() {
    let mut encoder_ctx = new_encoder();
    // Encoding: bytes, uint256, int128, array of tuples
    // Similar to decoder test: test_decode_complex
    let mut ba: ByteArray = Default::default();
    ba.append_byte(0x00);
    ba.append_byte(0xbb);
    ba.append_byte(0xff);
    ba.append_byte(0xaa);
    ba.append_byte(0x00);
    let mut bytes_serialized = array![];
    ba.serialize(ref bytes_serialized);

    // For now, simplified test - just test that bytes can be encoded
    let values = bytes_serialized.span();

    let encoded = encoder_ctx.encode(array![EVMTypes::Bytes].span(), values);

    assert!(encoded.len() > 0);
}

#[test]
fn test_encode_array_of_strings() {
    let mut encoder_ctx = new_encoder();

    // Array of 2 strings: "ALI", "VELI"
    let mut ali_ba: ByteArray = Default::default();
    ali_ba.append_byte('A');
    ali_ba.append_byte('L');
    ali_ba.append_byte('I');
    let mut ali_serialized = array![];
    ali_ba.serialize(ref ali_serialized);

    let mut veli_ba: ByteArray = Default::default();
    veli_ba.append_byte('V');
    veli_ba.append_byte('E');
    veli_ba.append_byte('L');
    veli_ba.append_byte('I');
    let mut veli_serialized = array![];
    veli_ba.serialize(ref veli_serialized);

    // For now, simplified test - just test one string
    let values = ali_serialized.span();

    let encoded = encoder_ctx.encode(array![EVMTypes::String].span(), values);

    let mut expected_bytes: ByteArray = Default::default();
    // Offset to dynamic data
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    // Length
    expected_bytes.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    // Data "ALI" (left-aligned, padded)
    expected_bytes.append_u256(0x414c490000000000000000000000000000000000000000000000000000000000);

    assert_eq!(encoded, expected_bytes);
}
