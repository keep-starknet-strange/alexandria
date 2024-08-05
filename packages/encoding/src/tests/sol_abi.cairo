use alexandria_bytes::utils::{BytesDebug, BytesDisplay};
use alexandria_bytes::{Bytes, BytesTrait};
use alexandria_encoding::sol_abi::{
    encode::SolAbiEncodeTrait, encode_as::SolAbiEncodeAsTrait, encode::SolAbiEncodeSelectorTrait,
    decode::SolAbiDecodeTrait, sol_bytes::SolBytesTrait
};
use core::bytes_31;
use core::to_byte_array::FormatAsByteArray;
use starknet::{ContractAddress, EthAddress};

// Compare Bytes types up to the size of the data ( incase different values outside size range )
fn compare_bytes(actual: @Bytes, expected: @Bytes) -> bool {
    if actual.size() != expected.size() {
        return false;
    }
    let mut i: usize = 0;
    while i < actual.size() {
        let (_, actual_val) = actual.read_u8(i);
        let (_, expected_val) = expected.read_u8(i);
        if actual_val != expected_val {
            break;
        }
        i += 1;
    };
    if i < actual.size() {
        return false;
    }
    true
}

#[test]
fn encode_test() {
    let expected: Bytes = BytesTrait::new(
        480,
        array![
            0x00000000000000000000000000000000,
            0x0000000000000000000000000000001a,
            0x00000000000000000000000000000000,
            0x101112131415161718191a1b1c1d1e1f,
            0x00000000000000000000000000000000,
            0x000000000000000000000000ddccbbaa,
            0x00000000000000000000000000000000,
            0x00000000000000000000000000001112,
            0x00000000000000000000000000000000,
            0x0000000000000000090a0b0c0d0e0f10,
            0x00000000000000000000000000000000,
            0x00000000000000000000000000000001,
            0x0102030405060708090a0b0c0d0e1011,
            0x12131415161718191a1b1c1d1e1f2021,
            0x00000000000000000000000000000000,
            0x00000000000000000000000000000000,
            0x00000000000000000000000000000000,
            0x00000000000000000000000000000001,
            0x00000000000000000000000000000000,
            1234567890,
            0x0000000000000000000000000000abcd,
            0xefabcdefabcdefabcdefabcdefabcdef,
            0x000a0b0c0d0e0f000000000000000000,
            0x00000000000000000000000000000000,
            0x0000abcdef0000000000000000000000,
            0x00000000000000000000000000000000,
            0x049d36570d4e46f48e99674bd3fcc846,
            0x44ddd6b96f7c741b1562b82f9e004dc7,
            0x000000000000000000000000DeaDbeef,
            0xdEAdbeefdEadbEEFdeadbeEFdEaDbeeF
        ]
    );
    let mut encoded: Bytes = BytesTrait::new_empty();
    let address: ContractAddress =
        0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7_felt252
        .try_into()
        .expect('Couldn\'t convert to address');
    let eth_address: EthAddress = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF_u256.into();
    let sba: ByteArray = (SolBytesTrait::bytes5(0x0000abcdef).into());
    encoded = encoded
        .encode(0x1a_u8)
        .encode(0x101112131415161718191a1b1c1d1e1f_u128)
        .encode(0xddccbbaa_u32)
        .encode(0x1112_u16)
        .encode(0x090a0b0c0d0e0f10_u64)
        .encode(0x1_u8)
        .encode(0x0102030405060708090a0b0c0d0e101112131415161718191a1b1c1d1e1f2021_u256)
        .encode(false)
        .encode(true)
        .encode(1234567890_felt252)
        .encode(0xabcdefabcdefabcdefabcdefabcdefabcdef)
        .encode(SolBytesTrait::bytes7(0xa0b0c0d0e0f))
        .encode(sba)
        .encode(address)
        .encode(eth_address);
    assert_eq!(encoded, expected);
}

#[test]
fn encode_packed_test() {
    let expected: Bytes = BytesTrait::new(
        195,
        array![
            0x0800000000000000a7a8a9aaabacadae,
            0xaf000abcde002a00000000101112130f,
            0xa0a1a2a3a4a5a6a7a8a9aaabacadaeaf,
            0xb0b1b2b3b4b5b6b7b8b9babbbcbdbe00,
            0x01000000000000000000000000000000,
            0x00000000000000000000000000001234,
            0x0102030405060708090a000000000000,
            0x00000000000000000000000000000000,
            0x00000000001234567890049d36570d4e,
            0x46f48e99674bd3fcc84644ddd6b96f7c,
            0x741b1562b82f9e004dc7DeaDbeefdEAd,
            0xbeefdEadbEEFdeadbeEFdEaDbeeFa0aa,
            0xabacad00000000000000000000000000
        ]
    );
    let mut encoded: Bytes = BytesTrait::new_empty();
    let address: ContractAddress =
        0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7_felt252
        .try_into()
        .expect('Couldn\'t convert to address');
    let eth_address: EthAddress = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF_u256.into();
    let bytesArray: ByteArray = SolBytesTrait::bytes5(0xa0aaabacad_u128).into();
    let bytes_31: bytes31 = 0x1234.try_into().unwrap();
    encoded = encoded
        .encode_packed(0x8_u8)
        .encode_packed(0xa7a8a9aaabacadaeaf_u128)
        .encode_packed(0xabcde_u32)
        .encode_packed(0x2a_u16)
        .encode_packed(0x10111213_u64)
        .encode_packed(0x0fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbe_u256)
        .encode_packed(false)
        .encode_packed(true)
        .encode_packed(bytes_31)
        .encode_packed(SolBytesTrait::bytes10(0x0102030405060708090a_u128))
        .encode_packed(0x1234567890_felt252)
        .encode_packed(address)
        .encode_packed(eth_address)
        .encode_packed(bytesArray);
    assert_eq!(encoded, expected);
}

#[test]
fn encoded_as_test() {
    let expected: Bytes = BytesTrait::new(
        29, array![0x10111200000000000000000000000000, 0x0000000000aabbcc0000a0b1c2000000]
    );
    let mut encoded: Bytes = BytesTrait::new_empty();
    encoded = encoded
        .encode_as(3, 0x101112_u128)
        .encode_as(21, 0xaabbcc_felt252)
        .encode_as(5, 0xa0b1c2_u256);
    assert_eq!(encoded, expected);

    let sba: ByteArray = SolBytesTrait::bytes10(0x0000a0b1c2c3c4c5c6c8).into();
    let bytes_31: bytes31 = 0xaabbcc.try_into().unwrap();
    let mut encoded: Bytes = BytesTrait::new_empty();
    encoded = encoded
        .encode_as(3, SolBytesTrait::bytes10(0x10111213141516171910))
        .encode_as(21, bytes_31)
        .encode_as(5, sba);
    assert_eq!(encoded, expected);
}

#[test]
fn selector_test() {
    // selector for : transfer(address,uint256)
    let expected: Bytes = BytesTrait::new(4, array![0xa9059cbb000000000000000000000000]);
    let mut encoded: Bytes = BytesTrait::new_empty();
    encoded = encoded.encode_selector(0xa9059cbb_u32);
    assert_eq!(encoded, expected);

    // encode call : transfer(0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF, 10000)
    let expected: Bytes = BytesTrait::new(
        68,
        array![
            0xa9059cbb000000000000000000000000,
            0xDeaDbeefdEAdbeefdEadbEEFdeadbeEF,
            0xdEaDbeeF000000000000000000000000,
            0x00000000000000000000000000000000,
            0x00002710000000000000000000000000
        ]
    );
    let mut encoded: Bytes = BytesTrait::new_empty();
    let eth_address: EthAddress = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF_u256.into();
    encoded = encoded.encode_selector(0xa9059cbb_u32).encode(eth_address).encode(10000_u256);
    assert_eq!(encoded, expected);
}

#[test]
fn decode_test() {
    let encoded: Bytes = BytesTrait::new(
        384,
        array![
            0x00000000000000000000000000000000,
            0x0000000000000000000000000000a0a1,
            0x00000000000000000000000000000000,
            0x000000000000000000000000a2a3a4a5,
            0x00000000000000000000000000000000,
            0x000000000000000000000000000000a6,
            0x00000000000000000000000000000000,
            0xa7a8a9aaabacadaeafb0b1b2b3b4b5b6,
            0xabcdefabcdefabcdefabcdefabcdefab,
            0xcdefabcdefabcdefabcdefabcdefabcd,
            0x00000000000000000000000000000000,
            0x0000000000000000b7b8b9babbbcbdbe,
            0x00a0a1a2a30000000000000000000000,
            0x00000000000000000000000000000000,
            0xa0a1a2a3a4a5a6a7a8a9aaabacadaeaf,
            0xb0b1b2b3000000000000000000000000,
            0x000000000000000000000000000000a0,
            0xaaab00000000000000000000000000ac,
            0x00000000000000000000000000000000,
            0x00000000000000000000000000001234,
            0x00a0a1a2a30000000000000000000000,
            0x00000000000000000000000000001234,
            0x000000000000000000000000Deadbeef,
            0xDeaDbeefdEAdbeefdEadbEEFdeadbeEF
        ]
    );

    let mut offset = 0;
    let decoded: u16 = encoded.decode(ref offset);
    assert_eq!(decoded, 0xa0a1);
    assert_eq!(offset, 32);

    let decoded: u32 = encoded.decode(ref offset);
    assert_eq!(decoded, 0xa2a3a4a5);
    assert_eq!(offset, 64);

    let decoded: u8 = encoded.decode(ref offset);
    assert_eq!(decoded, 0xa6);
    assert_eq!(offset, 96);

    let decoded: u128 = encoded.decode(ref offset);
    assert_eq!(decoded, 0xa7a8a9aaabacadaeafb0b1b2b3b4b5b6);
    assert_eq!(offset, 128);

    let decoded: u256 = encoded.decode(ref offset);
    assert_eq!(
        decoded,
        0xabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcd_u256,
        "Decode uint256 failed"
    );
    assert_eq!(offset, 160);

    let decoded: u64 = encoded.decode(ref offset);
    assert_eq!(decoded, 0xb7b8b9babbbcbdbe);
    assert_eq!(offset, 192);

    let decoded: Bytes = SolBytesTrait::<Bytes>::bytes5(encoded.decode(ref offset));
    assert_eq!(decoded, SolBytesTrait::bytes5(0xa0a1a2a3));
    assert_eq!(offset, 224);

    let decoded: ByteArray = encoded.decode(ref offset);
    let expected: ByteArray = SolBytesTrait::bytes32(
        0xa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3000000000000000000000000_u256
    )
        .into();
    assert_eq!(decoded, expected);
    assert_eq!(offset, 256);

    let decoded: bytes31 = encoded.decode(ref offset);
    let bytes_31: bytes31 = 0xa0aaab00000000000000000000000000ac.try_into().unwrap();
    assert!(decoded == bytes_31, "Decode byte31 failed");
    assert_eq!(offset, 288);

    let decoded: felt252 = encoded.decode(ref offset);
    assert_eq!(decoded, 0x1234_felt252);
    assert_eq!(offset, 320);

    let expected: ContractAddress =
        0xa0a1a2a3000000000000000000000000000000000000000000000000001234_felt252
        .try_into()
        .expect('Couldn\'t convert to address');
    let decoded: ContractAddress = encoded.decode(ref offset);
    assert_eq!(decoded, expected);
    assert_eq!(offset, 352);

    let expected: EthAddress = 0xDeadbeefDeaDbeefdEAdbeefdEadbEEFdeadbeEF_u256.into();
    let decoded: EthAddress = encoded.decode(ref offset);
    assert_eq!(decoded, expected);
    assert_eq!(offset, 384);
}

#[test]
fn sol_bytes_test() {
    // Test bytesX with integer types
    let expectedVal14: Bytes = SolBytesTrait::bytes14(0x1234567890abcdef1234567890ab_u128);
    let bytesVal5: Bytes = SolBytesTrait::bytes5(0x1234567890_u256);
    let bytesVal9: Bytes = SolBytesTrait::bytes9(0xabcdef1234567890ab_felt252);
    let mut bytesValAcc: Bytes = BytesTrait::new_empty();
    bytesValAcc.concat(@bytesVal5);
    bytesValAcc.concat(@bytesVal9);
    assert_eq!(expectedVal14, bytesValAcc);

    // Test bytesX with integer types needing `into` calls
    let expectedVal21: Bytes = SolBytesTrait::bytes21(
        0x0000a0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2_u256
    );
    let bytesVal18: Bytes = SolBytesTrait::bytes18(0xa0a1a2a3a4a5a6a7a8a9aaabacadaeaf_u128);
    let bytesVal3: Bytes = SolBytesTrait::bytes3(0xb0b1b2);
    let mut bytesValAcc: Bytes = BytesTrait::new_empty();
    bytesValAcc.concat(@bytesVal18);
    bytesValAcc.concat(@bytesVal3);
    assert_eq!(expectedVal21, bytesValAcc);

    // Test bytesX with Bytes types
    let expectedVal25: Bytes = SolBytesTrait::bytes25(
        0xa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8_u256
    );
    let bytesVal6: Bytes = SolBytesTrait::bytes6(
        BytesTrait::new(16, array![0xa0a1a2a3a4a500000000000000000000])
    );
    let bytesArray: ByteArray = SolBytesTrait::bytes32(
        0xa6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b800000000000000000000000000_u256
    )
        .into();
    let bytesVal19: Bytes = SolBytesTrait::bytes19(bytesArray);
    let mut bytesValAcc: Bytes = BytesTrait::new_empty();
    bytesValAcc.concat(@bytesVal6);
    bytesValAcc.concat(@bytesVal19);
    assert_eq!(expectedVal25, bytesValAcc);
}
