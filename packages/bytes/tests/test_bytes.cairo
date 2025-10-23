use alexandria_bytes::utils::{BytesDebug, BytesDisplay};
use alexandria_bytes::{Bytes, BytesIndex, BytesTrait};

#[test]
fn test_bytes_zero() {
    let bytes = BytesTrait::zero(1);
    assert!(bytes.size() == 1);
    assert!(*bytes[0] == 0);

    let bytes = BytesTrait::zero(17);
    assert!(bytes.size() == 17);
    assert!(*bytes[0] == 0);
    assert!(*bytes[1] == 0);
    let (_, value) = bytes.read_u8(15);
    assert!(value == 0);
    let (_, value) = bytes.read_u8(0);
    assert!(value == 0);
    let (_, value) = bytes.read_u8(16);
    assert!(value == 0);
}

#[test]
#[should_panic(expected: ('update out of bound',))]
fn test_bytes_update_panic() {
    let mut bytes = BytesTrait::new_empty();
    bytes.update_at(0, 0x01);
}

#[test]
fn test_bytes_update() {
    let mut bytes = BytesTrait::new(5, array![0x01020304050000000000000000000000]);

    bytes.update_at(0, 0x05);
    assert!(bytes.size() == 5);
    assert!(*bytes[0] == 0x05020304050000000000000000000000);

    bytes.update_at(1, 0x06);
    assert!(bytes.size() == 5);
    assert!(*bytes[0] == 0x05060304050000000000000000000000);

    bytes.update_at(2, 0x07);
    assert!(bytes.size() == 5);
    assert!(*bytes[0] == 0x05060704050000000000000000000000);

    bytes.update_at(3, 0x08);
    assert!(bytes.size() == 5);
    assert!(*bytes[0] == 0x05060708050000000000000000000000);

    bytes.update_at(4, 0x09);
    assert!(bytes.size() == 5);
    assert!(*bytes[0] == 0x05060708090000000000000000000000);

    let mut bytes = BytesTrait::new(
        42,
        array![
            0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
            0x01020304050607080910000000000000,
        ],
    );

    bytes.update_at(16, 0x16);
    assert!(bytes.size() == 42);
    assert!(*bytes[0] == 0x01020304050607080910111213141516);
    assert!(*bytes[1] == 0x16020304050607080910111213141516);
    assert!(*bytes[2] == 0x01020304050607080910000000000000);

    bytes.update_at(15, 0x01);
    assert!(bytes.size() == 42);
    assert!(*bytes[0] == 0x01020304050607080910111213141501);
    assert!(*bytes[1] == 0x16020304050607080910111213141516);
    assert!(*bytes[2] == 0x01020304050607080910000000000000);
}

#[test]
fn test_bytes_read_u128_packed() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u128_packed(0, 1);
    assert!(new_offset == 1);
    assert!(value == 0x01);

    let (new_offset, value) = bytes.read_u128_packed(new_offset, 14);
    assert!(new_offset == 15);
    assert!(value == 0x0203040506070809101112131415);

    let (new_offset, value) = bytes.read_u128_packed(new_offset, 15);
    assert!(new_offset == 30);
    assert!(value == 0x160102030405060708091011121314);

    let (new_offset, value) = bytes.read_u128_packed(new_offset, 8);
    assert!(new_offset == 38);
    assert!(value == 0x1516010203040506);

    let (new_offset, value) = bytes.read_u128_packed(new_offset, 4);
    assert!(new_offset == 42);
    assert!(value == 0x07080910);
}

#[test]
#[should_panic(expected: ('out of bound',))]
fn test_bytes_read_u128_packed_out_of_bound() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_u128_packed(0, 43);
}

#[test]
#[should_panic(expected: ('too large',))]
fn test_bytes_read_u128_packed_too_large() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_u128_packed(0, 17);
}

#[test]
fn test_bytes_read_u128_array_packed() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, new_array) = bytes.read_u128_array_packed(0, 3, 3);
    assert!(new_offset == 9);
    assert!(*new_array[0] == 0x010203);
    assert!(*new_array[1] == 0x040506);
    assert!(*new_array[2] == 0x070809);

    let (new_offset, new_array) = bytes.read_u128_array_packed(9, 4, 7);
    assert!(new_offset == 37);
    assert!(*new_array[0] == 0x10111213141516);
    assert!(*new_array[1] == 0x01020304050607);
    assert!(*new_array[2] == 0x08091011121314);
    assert!(*new_array[3] == 0x15160102030405);
}

#[test]
#[should_panic(expected: ('out of bound',))]
fn test_bytes_read_u128_array_packed_out_of_bound() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_u128_array_packed(0, 11, 4);
}

#[test]
#[should_panic(expected: ('too large',))]
fn test_bytes_read_u128_array_packed_too_large() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_u128_array_packed(0, 2, 17);
}

#[test]
fn test_bytes_read_felt252_packed() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_felt252_packed(13, 20);
    assert!(new_offset == 33);
    assert!(value == 0x1415160102030405060708091011121314151601);
}

#[test]
#[should_panic(expected: ('out of bound',))]
fn test_bytes_read_felt252_packed_out_of_bound() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_felt252_packed(0, 43);
}

#[test]
#[should_panic(expected: ('too large',))]
fn test_bytes_read_felt252_packed_too_large() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_felt252_packed(0, 32);
}

#[test]
fn test_bytes_read_u8() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u8(15);
    assert!(new_offset == 16);
    assert!(value == 0x16);
}

#[test]
fn test_bytes_read_u16() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u16(15);
    assert!(new_offset == 17);
    assert!(value == 0x1601);
}

#[test]
fn test_bytes_read_u32() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u32(15);
    assert!(new_offset == 19);
    assert!(value == 0x16010203);
}

#[test]
fn test_bytes_read_usize() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_usize(15);
    assert!(new_offset == 19);
    assert!(value == 0x16010203);
}

#[test]
fn test_bytes_read_u64() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u64(15);
    assert!(new_offset == 23);
    assert!(value == 0x1601020304050607);
}

#[test]
fn test_bytes_read_u128() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u128(15);
    assert!(new_offset == 31);
    assert!(value == 0x16010203040506070809101112131415);
}

#[test]
fn test_bytes_read_u256() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u256(4);
    assert!(new_offset == 36);
    assert!(value.high == 0x05060708091011121314151601020304);
    assert!(value.low == 0x05060708091011121314151601020304);
}

#[test]
fn test_bytes_read_bytes31() {
    let bytes: Bytes = BytesTrait::new(
        42, array![0x0102030405060708090a0b0c0d0e0f10, 0x1112131415161718191a1b1c1d1e1f17, 0x0],
    );
    let (offset, val) = bytes.read_bytes31(2);
    assert!(offset == 33);
    let byte31: bytes31 = 0x030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f1700
        .try_into()
        .unwrap();
    assert!(val == byte31, "read_bytes31 test failed")
}

#[test]
fn test_bytes_read_u256_array() {
    let array = array![
        0x01020304050607080910111213141516, 0x16151413121110090807060504030201,
        0x16151413121110090807060504030201, 0x01020304050607080910111213141516,
        0x01020304050607080910111213141516, 0x16151413121110090000000000000000,
    ];

    let bytes = BytesTrait::new(88, array);

    let (new_offset, new_array) = bytes.read_u256_array(7, 2);
    assert!(new_offset == 71);
    let result: u256 = *new_array[0];
    assert!(result.high == 0x08091011121314151616151413121110);
    assert!(result.low == 0x09080706050403020116151413121110);
    let result: u256 = *new_array[1];
    assert!(result.high == 0x09080706050403020101020304050607);
    assert!(result.low == 0x08091011121314151601020304050607);
}

#[test]
fn test_bytes_read_address() {
    let array = array![
        0x01020304050607080910111213140154, 0x01855d7796176b05d160196ff92381eb,
        0x7910f5446c2e0e04e13db2194a4f0000,
    ];

    let bytes = BytesTrait::new(46, array);
    let address = 0x015401855d7796176b05d160196ff92381eb7910f5446c2e0e04e13db2194a4f;

    let (new_offset, value) = bytes.read_address(14);
    assert!(new_offset == 46);
    assert!(value.into() == address);
}

#[test]
fn test_bytes_read_bytes() {
    let array = array![
        0x01020304050607080910111213140154, 0x01855d7796176b05d160196ff92381eb,
        0x7910f5446c2e0e04e13db2194a4f0000,
    ];

    let bytes = BytesTrait::new(46, array);

    let (new_offset, sub_bytes) = bytes.read_bytes(4, 37);
    let sub_bytes_data = @sub_bytes;
    assert!(new_offset == 41);
    assert!(sub_bytes.size() == 37);
    assert!(*sub_bytes_data[0] == 0x05060708091011121314015401855d77);
    assert!(*sub_bytes_data[1] == 0x96176b05d160196ff92381eb7910f544);
    assert!(*sub_bytes_data[2] == 0x6c2e0e04e10000000000000000000000);

    let (new_offset, sub_bytes) = bytes.read_bytes(0, 14);
    let sub_bytes_data = @sub_bytes;
    assert!(new_offset == 14);
    assert!(sub_bytes.size() == 14);
    assert!(*sub_bytes_data[0] == 0x01020304050607080910111213140000);

    // read first byte
    let (new_offset, sub_bytes) = bytes.read_bytes(0, 1);
    let sub_bytes_data = @sub_bytes;
    assert!(new_offset == 1);
    assert!(sub_bytes.size() == 1);
    assert!(*sub_bytes_data[0] == 0x01000000000000000000000000000000);

    // read last byte
    let (new_offset, sub_bytes) = bytes.read_bytes(45, 1);
    let sub_bytes_data = @sub_bytes;
    assert!(new_offset == 46);
    assert!(sub_bytes.size() == 1);
    assert!(*sub_bytes_data[0] == 0x4f000000000000000000000000000000);
}

#[test]
fn test_bytes_append() {
    let mut bytes = BytesTrait::new_empty();

    // append_u128_packed
    bytes.append_u128_packed(0x101112131415161718, 9);
    assert!(bytes.size() == 9);
    assert!(*bytes[0] == 0x10111213141516171800000000000000);
    bytes = BytesTrait::new(bytes.size(), bytes.data());

    bytes.append_u128_packed(0x101112131415161718, 9);
    assert!(bytes.size() == 18);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180000000000000000000000000000);
    bytes = BytesTrait::new(bytes.size(), bytes.data());

    // append_u8
    bytes.append_u8(0x01);
    assert!(bytes.size() == 19);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180100000000000000000000000000);
    bytes = BytesTrait::new(bytes.size(), bytes.data());

    // append_u16
    bytes.append_u16(0x0102);
    assert!(bytes.size() == 21);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180101020000000000000000000000);
    bytes = BytesTrait::new(bytes.size(), bytes.data());

    // append_u32
    bytes.append_u32(0x01020304);
    assert!(bytes.size() == 25);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180101020102030400000000000000);
    bytes = BytesTrait::new(bytes.size(), bytes.data());

    // append_usize
    bytes.append_usize(0x01);
    assert!(bytes.size() == 29);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180101020102030400000001000000);
    bytes = BytesTrait::new(bytes.size(), bytes.data());

    // append_u64
    bytes.append_u64(0x030405060708);
    assert!(bytes.size() == 37);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180101020102030400000001000003);
    assert!(*bytes[2] == 0x04050607080000000000000000000000);
    bytes = BytesTrait::new(bytes.size(), bytes.data());

    // append_u128
    bytes.append_u128(0x101112131415161718);
    assert!(bytes.size() == 53);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180101020102030400000001000003);
    assert!(*bytes[2] == 0x04050607080000000000000010111213);
    assert!(*bytes[3] == 0x14151617180000000000000000000000);
    bytes = BytesTrait::new(bytes.size(), bytes.data());

    // append_u256
    bytes.append_u256(u256 { low: 0x01020304050607, high: 0x010203040506070809 });
    assert!(bytes.size() == 85);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180101020102030400000001000003);
    assert!(*bytes[2] == 0x04050607080000000000000010111213);
    assert!(*bytes[3] == 0x14151617180000000000000001020304);
    assert!(*bytes[4] == 0x05060708090000000000000000000102);
    assert!(*bytes[5] == 0x03040506070000000000000000000000);
    bytes = BytesTrait::new(bytes.size(), bytes.data());

    // append_address
    let address = 0x015401855d7796176b05d160196ff92381eb7910f5446c2e0e04e13db2194a4f
        .try_into()
        .unwrap();
    bytes.append_address(address);
    assert!(bytes.size() == 117);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180101020102030400000001000003);
    assert!(*bytes[2] == 0x04050607080000000000000010111213);
    assert!(*bytes[3] == 0x14151617180000000000000001020304);
    assert!(*bytes[4] == 0x05060708090000000000000000000102);
    assert!(*bytes[5] == 0x0304050607015401855d7796176b05d1);
    assert!(*bytes[6] == 0x60196ff92381eb7910f5446c2e0e04e1);
    assert!(*bytes[7] == 0x3db2194a4f0000000000000000000000);
}

#[test]
fn test_bytes_concat() {
    let array: Array<u128> = array![
        0x10111213141516171810111213141516, 0x17180101020102030400000001000003,
        0x04050607080000000000000010111213, 0x14151617180000000000000001020304,
        0x05060708090000000000000000000102, 0x0304050607015401855d7796176b05d1,
        0x60196ff92381eb7910f5446c2e0e04e1, 0x3db2194a4f0000000000000000000000,
    ];
    let mut bytes = BytesTrait::new(117, array);

    let array: Array<u128> = array![
        0x01020304050607080910111213140154, 0x01855d7796176b05d160196ff92381eb,
        0x7910f5446c2e0e04e13db2194a4f0000,
    ];
    let other = BytesTrait::new(46, array);

    bytes.concat(@other);
    assert!(bytes.size() == 163);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180101020102030400000001000003);
    assert!(*bytes[2] == 0x04050607080000000000000010111213);
    assert!(*bytes[3] == 0x14151617180000000000000001020304);
    assert!(*bytes[4] == 0x05060708090000000000000000000102);
    assert!(*bytes[5] == 0x0304050607015401855d7796176b05d1);
    assert!(*bytes[6] == 0x60196ff92381eb7910f5446c2e0e04e1);
    assert!(*bytes[7] == 0x3db2194a4f0102030405060708091011);
    assert!(*bytes[8] == 0x121314015401855d7796176b05d16019);
    assert!(*bytes[9] == 0x6ff92381eb7910f5446c2e0e04e13db2);
    assert!(*bytes[10] == 0x194a4f00000000000000000000000000);
    bytes = BytesTrait::new(bytes.size(), bytes.data());

    // empty bytes concat
    let mut empty_bytes = BytesTrait::new_empty();
    empty_bytes.concat(@bytes);

    assert!(bytes.size() == 163);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180101020102030400000001000003);
    assert!(*bytes[2] == 0x04050607080000000000000010111213);
    assert!(*bytes[3] == 0x14151617180000000000000001020304);
    assert!(*bytes[4] == 0x05060708090000000000000000000102);
    assert!(*bytes[5] == 0x0304050607015401855d7796176b05d1);
    assert!(*bytes[6] == 0x60196ff92381eb7910f5446c2e0e04e1);
    assert!(*bytes[7] == 0x3db2194a4f0102030405060708091011);
    assert!(*bytes[8] == 0x121314015401855d7796176b05d16019);
    assert!(*bytes[9] == 0x6ff92381eb7910f5446c2e0e04e13db2);
    assert!(*bytes[10] == 0x194a4f00000000000000000000000000);

    // concat empty_bytes
    let empty_bytes = BytesTrait::new_empty();
    bytes.concat(@empty_bytes);

    assert!(bytes.size() == 163);
    assert!(*bytes[0] == 0x10111213141516171810111213141516);
    assert!(*bytes[1] == 0x17180101020102030400000001000003);
    assert!(*bytes[2] == 0x04050607080000000000000010111213);
    assert!(*bytes[3] == 0x14151617180000000000000001020304);
    assert!(*bytes[4] == 0x05060708090000000000000000000102);
    assert!(*bytes[5] == 0x0304050607015401855d7796176b05d1);
    assert!(*bytes[6] == 0x60196ff92381eb7910f5446c2e0e04e1);
    assert!(*bytes[7] == 0x3db2194a4f0102030405060708091011);
    assert!(*bytes[8] == 0x121314015401855d7796176b05d16019);
    assert!(*bytes[9] == 0x6ff92381eb7910f5446c2e0e04e13db2);
    assert!(*bytes[10] == 0x194a4f00000000000000000000000000);
}

#[test]
fn test_bytes_keccak() {
    // Calculating keccak by Python
    // from Crypto.Hash import keccak
    // k = keccak.new(digest_bits=256)
    // k.update(bytes.fromhex(''))
    // print(k.hexdigest())

    // empty
    let bytes = BytesTrait::new_empty();
    let hash: u256 = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
    let res = bytes.keccak();
    assert!(res == hash);

    // u256{low: 1, high: 0}
    //0x0000000000000000000000000000000000000000000000000000000000000001
    let mut array = array![];
    array.append(0);
    array.append(1);
    let bytes: Bytes = BytesTrait::new(32, array);
    let res = bytes.keccak();
    let hash: u256 = 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6;
    assert!(res == hash);

    // test_bytes_append bytes
    let mut array = array![];
    array.append(0x10111213141516171810111213141516);
    array.append(0x17180101020102030400000001000003);
    array.append(0x04050607080000000000000010111213);
    array.append(0x14151617180000000000000001020304);
    array.append(0x05060708090000000000000000000102);
    array.append(0x0304050607015401855d7796176b05d1);
    array.append(0x60196ff92381eb7910f5446c2e0e04e1);
    array.append(0x3db2194a4f0000000000000000000000);

    let bytes: Bytes = BytesTrait::new(117, array);

    let hash: u256 = 0xcb1bcb5098bb2f588b82ea341e3b1148b7d1eeea2552d624b30f4240b5b85995;
    let res = bytes.keccak();
    assert!(res == hash);
}

#[test]
fn test_bytes_sha256() {
    // empty
    let bytes = BytesTrait::new_empty();
    let hash: u256 = 0xe3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855;
    let res = bytes.sha256();
    assert!(res == hash);

    // u256{low: 1, high: 0}
    // 0x0000000000000000000000000000000000000000000000000000000000000001
    let array = array![0, 1];
    let bytes: Bytes = BytesTrait::new(32, array);
    let res = bytes.sha256();
    let hash: u256 = 0xec4916dd28fc4c10d78e287ca5d9cc51ee1ae73cbfde08c6b37324cbfaac8bc5;
    assert!(res == hash);

    // test_bytes_append bytes
    let array = array![
        0x10111213141516171810111213141516, 0x17180101020102030400000001000003,
        0x04050607080000000000000010111213, 0x14151617180000000000000001020304,
        0x05060708090000000000000000000102, 0x0304050607015401855d7796176b05d1,
        0x60196ff92381eb7910f5446c2e0e04e1, 0x3db2194a4f0000000000000000000000,
    ];

    let bytes: Bytes = BytesTrait::new(117, array);

    let hash: u256 = 0xc3ab2c0ce2c246454f265f531ab14f210215ce72b91c23338405c273dc14ce1d;
    let res = bytes.sha256();
    assert!(res == hash);
}

#[test]
fn test_byte_array_conversions() {
    let bytes = BytesTrait::new(
        64,
        array![
            0x01020304050607080910111213141516, 0x16151413121110090807060504030201,
            0x60196ff92381eb7910f5446c2e0e04e1, 0x3db2194a000000000000000000000000,
        ],
    );
    let byte_array: ByteArray = bytes.clone().into();
    let new_bytes: Bytes = byte_array.into();
    assert!(bytes == new_bytes);
}

#[test]
fn test_bytes_new_with_padded_first() {
    let array = array![
        0x0123, 0x01020304050607080910111213141516, 0x01020304050607080910000000000000,
    ];

    let bytes = BytesTrait::new(48, array);

    let (new_offset, value) = bytes.read_u128(0);
    assert!(new_offset == 16);
    assert!(value == 0x00000000000000000000000000000123);
}

#[test]
fn test_bytes_new_with_padded_mid() {
    let array = array![
        0x01020304050607080910111213141516, 0x0123, 0x01020304050607080910111213141516,
    ];

    let bytes = BytesTrait::new(48, array);

    let (new_offset, value) = bytes.read_u128(16);
    assert!(new_offset == 32);
    assert!(value == 0x00000000000000000000000000000123);
}

#[test]
fn test_bytes_new_with_padded_last() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516, 0x0123,
    ];

    let bytes = BytesTrait::new(48, array);

    let (new_offset, value) = bytes.read_u128_packed(32, 16);
    assert!(new_offset == 48);
    assert!(value == 0x00000000000000000000000000000123);
}

#[test]
fn test_bytes_new_with_padded_multi() {
    let array = array![
        0x01020304050607080910111213141516, 0x0123, 0x01020304050607080910111213141516, 0x1234,
        0x123450,
    ];

    let bytes = BytesTrait::new(80, array);

    let (new_offset, value) = bytes.read_u128_packed(16, 16);
    assert!(new_offset == 32);
    assert!(value == 0x00000000000000000000000000000123);

    let (new_offset, value) = bytes.read_u128_packed(32, 16);
    assert!(new_offset == 48);
    assert!(value == 0x01020304050607080910111213141516);

    let (new_offset, value) = bytes.read_u128(48);
    assert!(new_offset == 64);
    assert!(value == 0x00000000000000000000000000001234);

    let (new_offset, value) = bytes.read_u128_packed(64, 16);
    assert!(new_offset == 80);
    assert!(value == 0x00000000000000000000000000123450);
}

#[test]
fn test_serde() {
    let mut out = array![];
    let mut array = array![0x01, 0x02, 0x03];

    let bytes = BytesTrait::new(48, array);

    bytes.serialize(ref out);

    assert!(out.pop_front().unwrap().try_into().unwrap() == bytes.size(), "expected equal size");

    let array_size: felt252 = out.pop_front().unwrap();
    let array_size: u32 = array_size.try_into().unwrap();
    assert!(array_size == 3, "expected array equal size");

    let array_1_pos: felt252 = out.pop_front().unwrap();
    let array_1_pos: u128 = array_1_pos.try_into().unwrap();
    assert!(array_1_pos == 0x00000000000000000000000000000001, "expected same u128 at pos 1");

    let array_2_pos: felt252 = out.pop_front().unwrap();
    let array_2_pos: u128 = array_2_pos.try_into().unwrap();
    assert!(array_2_pos == 0x00000000000000000000000000000002, "expected same u128 at pos 2");

    let array_3_pos: felt252 = out.pop_front().unwrap();
    let array_3_pos: u128 = array_3_pos.try_into().unwrap();
    assert!(array_3_pos == 0x00000000000000000000000000000003, "expected same u128 at pos 3");
}

#[test]
fn test_serde_with_first_padded() {
    let mut out = array![];
    let mut array = array![0x01020304050607, 0x01020304050607080910111213141516];

    let bytes = BytesTrait::new(23, array);

    bytes.serialize(ref out);

    assert!(out.pop_front().unwrap().try_into().unwrap() == bytes.size(), "expected equal size");

    let array_size: felt252 = out.pop_front().unwrap();
    let array_size: u32 = array_size.try_into().unwrap();
    assert!(array_size == 2, "expected array equal size");

    let array_1_pos: felt252 = out.pop_front().unwrap();
    let array_1_pos: u128 = array_1_pos.try_into().unwrap();
    assert!(array_1_pos == 0x00000000000000000001020304050607, "expected same u128 at pos 1");

    let array_2_pos: felt252 = out.pop_front().unwrap();
    let array_2_pos: u128 = array_2_pos.try_into().unwrap();
    assert!(array_2_pos == 0x01020304050607080910111213141516, "expected same u128 at pos 2");
}

#[test]
fn test_serde_with_last_padded() {
    let mut out = array![];
    let mut array = array![0x01020304050607080910111213141516, 0x010203040506];

    let bytes = BytesTrait::new(22, array);

    bytes.serialize(ref out);

    assert!(out.pop_front().unwrap().try_into().unwrap() == bytes.size(), "expected equal size");

    let array_size: felt252 = out.pop_front().unwrap();
    let array_size: u32 = array_size.try_into().unwrap();
    assert!(array_size == 2, "expected array equal size");

    let array_1_pos: felt252 = out.pop_front().unwrap();
    let array_1_pos: u128 = array_1_pos.try_into().unwrap();
    assert!(array_1_pos == 0x01020304050607080910111213141516, "expected same u128 at pos 1");

    let array_2_pos: felt252 = out.pop_front().unwrap();
    let array_2_pos: u128 = array_2_pos.try_into().unwrap();
    assert!(array_2_pos == 0x00000000000000000000010203040506, "expected same u128 at pos 2");
}

#[test]
fn test_serde_with_multi_padded() {
    let mut out = array![];
    let mut array = array![
        0x01020304050607080910111213141516, 0x0123, 0x01020304050607080910111213141516, 0x01,
        0x012345,
    ];

    let bytes = BytesTrait::new(80, array);

    bytes.serialize(ref out);

    assert!(out.pop_front().unwrap().try_into().unwrap() == bytes.size(), "expected equal size");

    let array_size: felt252 = out.pop_front().unwrap();
    let array_size: u32 = array_size.try_into().unwrap();
    assert!(array_size == 5, "expected array equal size");

    let array_1_pos: felt252 = out.pop_front().unwrap();
    let array_1_pos: u128 = array_1_pos.try_into().unwrap();
    assert!(array_1_pos == 0x01020304050607080910111213141516, "expected same u128 at pos 1");

    let array_2_pos: felt252 = out.pop_front().unwrap();
    let array_2_pos: u128 = array_2_pos.try_into().unwrap();
    assert!(array_2_pos == 0x00000000000000000000000000000123, "expected same u128 at pos 2");

    let array_3_pos: felt252 = out.pop_front().unwrap();
    let array_3_pos: u128 = array_3_pos.try_into().unwrap();
    assert!(array_3_pos == 0x01020304050607080910111213141516, "expected same u128 at pos 3");

    let array_4_pos: felt252 = out.pop_front().unwrap();
    let array_4_pos: u128 = array_4_pos.try_into().unwrap();
    assert!(array_4_pos == 0x00000000000000000000000000000001, "expected same u128 at pos 4");

    let array_5_pos: felt252 = out.pop_front().unwrap();
    let array_5_pos: u128 = array_5_pos.try_into().unwrap();
    assert!(array_5_pos == 0x00000000000000000000000000012345, "expected same u128 at pos 5");
}

#[test]
fn test_serde_deser() {
    let mut out = array![];

    let array = array![0x01, 0x02, 0x03];
    let expected_array = array![
        0x00000000000000000000000000000001, 0x00000000000000000000000000000002,
        0x00000000000000000000000000000003,
    ];
    let mut bytes = BytesTrait::new(48, array);
    bytes.serialize(ref out);

    let mut span = out.span();

    let mut deser = Serde::<Bytes>::deserialize(ref span).unwrap();
    assert!(deser.size() == bytes.size(), "expected equal lengths");
    assert!(deser.data() == expected_array, "expected equal data");
}


#[test]
fn test_serde_deser_multi_padded() {
    let mut out = array![];
    let array = array![
        0x01020304050607080910111213141516, 0x0123, 0x01020304050607080910111213141516, 0x1234,
        0x012345,
    ];

    let expected_array = array![
        0x01020304050607080910111213141516, 0x00000000000000000000000000000123,
        0x01020304050607080910111213141516, 0x00000000000000000000000000001234,
        0x00000000000000000000000000012345,
    ];

    let bytes = BytesTrait::new(80, array);
    bytes.serialize(ref out);

    let mut span = out.span();

    let mut deser = Serde::<Bytes>::deserialize(ref span).unwrap();
    assert!(deser.size() == bytes.size(), "expected equal lengths");
    assert!(deser.data() == expected_array, "expected equal data");
}

#[test]
fn test_serde_deser_last_not_padded() {
    let mut out = array![];
    let array = array![
        0x01020304050607080910111213141516, 0x0123, 0x1234, 0x012345,
        0x01020304050607080910111213141516,
    ];

    let expected_array = array![
        0x01020304050607080910111213141516, 0x00000000000000000000000000000123,
        0x00000000000000000000000000001234, 0x00000000000000000000000000012345,
        0x01020304050607080910111213141516,
    ];

    let bytes = BytesTrait::new(80, array);
    bytes.serialize(ref out);

    let mut span = out.span();

    let mut deser = Serde::<Bytes>::deserialize(ref span).unwrap();
    assert!(deser.size() == bytes.size(), "expected equal lengths");
    assert!(deser.data() == expected_array, "expected equal data");
}


#[test]
fn test_serde_deser_compare_bytes() {
    let mut out = array![];
    let array = array![
        0x01020304050607080910111213141516, 0x0123, 0x1234, 0x012345,
        0x01020304050607080910111213141516,
    ];

    let bytes = BytesTrait::new(80, array.clone());
    bytes.serialize(ref out);
    let mut span = out.span();
    let mut deser = Serde::<Bytes>::deserialize(ref span).unwrap();

    let expected_array: Array<felt252> = array![
        80, 5, 0x01020304050607080910111213141516, 0x0123, 0x1234, 0x012345,
        0x01020304050607080910111213141516,
    ];

    let mut span2 = expected_array.span();
    let mut bytes2 = Serde::<Bytes>::deserialize(ref span2).unwrap();

    assert!(deser.size() == bytes.size(), "expected equal lengths");
    assert!(deser.data() == bytes2.data(), "expected equal data");
}

#[test]
#[should_panic()]
fn test_deser_exceed_u128() {
    let expected_array: Array<felt252> = array![
        80, 5, 0x0102030405060708091011121314151617, 0x0123, 0x1234, 0x012345,
        0x01020304050607080910111213141516,
    ];

    let mut span = expected_array.span();
    Serde::<Bytes>::deserialize(ref span).unwrap();
}

