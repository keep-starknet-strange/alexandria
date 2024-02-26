use alexandria_bytes::{Bytes, BytesTrait};
use starknet::ContractAddress;

#[test]
#[available_gas(20000000)]
fn test_bytes_zero() {
    let bytes = BytesTrait::zero(1);
    assert_eq!(bytes.size, 1, "invalid size");
    assert_eq!(*bytes.data[0], 0, "invalid value");

    let bytes = BytesTrait::zero(17);
    assert_eq!(bytes.size, 17, "invalid size");
    assert_eq!(*bytes.data[0], 0, "invalid value");
    assert_eq!(*bytes.data[1], 0, "invalid value");
    let (_, value) = bytes.read_u8(15);
    assert_eq!(value, 0, "invalid value");
    let (_, value) = bytes.read_u8(0);
    assert_eq!(value, 0, "invalid value");
    let (_, value) = bytes.read_u8(16);
    assert_eq!(value, 0, "invalid value");
}

#[test]
#[available_gas(200000000)]
#[should_panic(expected: ('update out of bound',))]
fn test_bytes_update_panic() {
    let mut bytes = BytesTrait::new_empty();
    bytes.update_at(0, 0x01);
}

#[test]
#[available_gas(200000000)]
fn test_bytes_update() {
    let mut bytes = BytesTrait::new(5, array![0x01020304050000000000000000000000]);

    bytes.update_at(0, 0x05);
    assert_eq!(bytes.size, 5, "update_size1");
    assert_eq!(*bytes.data[0], 0x05020304050000000000000000000000, "update_value_1");

    bytes.update_at(1, 0x06);
    assert_eq!(bytes.size, 5, "update_size2");
    assert_eq!(*bytes.data[0], 0x05060304050000000000000000000000, "update_value_2");

    bytes.update_at(2, 0x07);
    assert_eq!(bytes.size, 5, "update_size3");
    assert_eq!(*bytes.data[0], 0x05060704050000000000000000000000, "update_value_3");

    bytes.update_at(3, 0x08);
    assert_eq!(bytes.size, 5, "update_size4");
    assert_eq!(*bytes.data[0], 0x05060708050000000000000000000000, "update_value_4");

    bytes.update_at(4, 0x09);
    assert_eq!(bytes.size, 5, "update_size5");
    assert_eq!(*bytes.data[0], 0x05060708090000000000000000000000, "update_value_5");

    let mut bytes = BytesTrait::new(
        42,
        array![
            0x01020304050607080910111213141516,
            0x01020304050607080910111213141516,
            0x01020304050607080910000000000000
        ]
    );

    bytes.update_at(16, 0x16);
    assert_eq!(bytes.size, 42, "update_size6");
    assert_eq!(*bytes.data[0], 0x01020304050607080910111213141516, "update_value_6");
    assert_eq!(*bytes.data[1], 0x16020304050607080910111213141516, "update_value_7");
    assert_eq!(*bytes.data[2], 0x01020304050607080910000000000000, "update_value_8");

    bytes.update_at(15, 0x01);
    assert_eq!(bytes.size, 42, "update_size7");
    assert_eq!(*bytes.data[0], 0x01020304050607080910111213141501, "update_value_9");
    assert_eq!(*bytes.data[1], 0x16020304050607080910111213141516, "update_value_10");
    assert_eq!(*bytes.data[2], 0x01020304050607080910000000000000, "update_value_11");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u128_packed() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u128_packed(0, 1);
    assert_eq!(new_offset, 1, "read_u128_packed_1_offset");
    assert_eq!(value, 0x01, "read_u128_packed_1_value");

    let (new_offset, value) = bytes.read_u128_packed(new_offset, 14);
    assert_eq!(new_offset, 15, "read_u128_packed_2_offset");
    assert_eq!(value, 0x0203040506070809101112131415, "read_u128_packed_2_value");

    let (new_offset, value) = bytes.read_u128_packed(new_offset, 15);
    assert_eq!(new_offset, 30, "read_u128_packed_3_offset");
    assert_eq!(value, 0x160102030405060708091011121314, "read_u128_packed_3_value");

    let (new_offset, value) = bytes.read_u128_packed(new_offset, 8);
    assert_eq!(new_offset, 38, "read_u128_packed_4_offset");
    assert_eq!(value, 0x1516010203040506, "read_u128_packed_4_value");

    let (new_offset, value) = bytes.read_u128_packed(new_offset, 4);
    assert_eq!(new_offset, 42, "read_u128_packed_5_offset");
    assert_eq!(value, 0x07080910, "read_u128_packed_5_value");
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('out of bound',))]
fn test_bytes_read_u128_packed_out_of_bound() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_u128_packed(0, 43);
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('too large',))]
fn test_bytes_read_u128_packed_too_large() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_u128_packed(0, 17);
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u128_array_packed() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, new_array) = bytes.read_u128_array_packed(0, 3, 3);
    assert_eq!(new_offset, 9, "read_u128_array_1_offset");
    assert_eq!(*new_array[0], 0x010203, "read_u128_array_1_value_1");
    assert_eq!(*new_array[1], 0x040506, "read_u128_array_1_value_2");
    assert_eq!(*new_array[2], 0x070809, "read_u128_array_1_value_3");

    let (new_offset, new_array) = bytes.read_u128_array_packed(9, 4, 7);
    assert_eq!(new_offset, 37, "read_u128_array_2_offset");
    assert_eq!(*new_array[0], 0x10111213141516, "read_u128_array_2_value_1");
    assert_eq!(*new_array[1], 0x01020304050607, "read_u128_array_2_value_2");
    assert_eq!(*new_array[2], 0x08091011121314, "read_u128_array_2_value_3");
    assert_eq!(*new_array[3], 0x15160102030405, "read_u128_array_2_value_4");
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('out of bound',))]
fn test_bytes_read_u128_array_packed_out_of_bound() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_u128_array_packed(0, 11, 4);
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('too large',))]
fn test_bytes_read_u128_array_packed_too_large() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_u128_array_packed(0, 2, 17);
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_felt252_packed() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_felt252_packed(13, 20);
    assert_eq!(new_offset, 33, "read_felt252_1_offset");
    assert_eq!(value, 0x1415160102030405060708091011121314151601, "read_felt252_1_value");
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('out of bound',))]
fn test_bytes_read_felt252_packed_out_of_bound() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_felt252_packed(0, 43);
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('too large',))]
fn test_bytes_read_felt252_packed_too_large() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    bytes.read_felt252_packed(0, 32);
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u8() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u8(15);
    assert_eq!(new_offset, 16, "read_u8_offset");
    assert_eq!(value, 0x16, "read_u8_value");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u16() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u16(15);
    assert_eq!(new_offset, 17, "read_u16_offset");
    assert_eq!(value, 0x1601, "read_u16_value");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u32() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u32(15);
    assert_eq!(new_offset, 19, "read_u32_offset");
    assert_eq!(value, 0x16010203, "read_u32_value");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_usize() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_usize(15);
    assert_eq!(new_offset, 19, "read_usize_offset");
    assert_eq!(value, 0x16010203, "read_usize_value");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u64() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u64(15);
    assert_eq!(new_offset, 23, "read_u64_offset");
    assert_eq!(value, 0x1601020304050607, "read_u64_value");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u128() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u128(15);
    assert_eq!(new_offset, 31, "read_u128_offset");
    assert_eq!(value, 0x16010203040506070809101112131415, "read_u128_value");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u256() {
    let array = array![
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x01020304050607080910000000000000
    ];

    let bytes = BytesTrait::new(42, array);

    let (new_offset, value) = bytes.read_u256(4);
    assert_eq!(new_offset, 36, "read_u256_1_offset");
    assert_eq!(value.high, 0x05060708091011121314151601020304, "read_u256_1_value_high");
    assert_eq!(value.low, 0x05060708091011121314151601020304, "read_u256_1_value_low");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u256_array() {
    let array = array![
        0x01020304050607080910111213141516,
        0x16151413121110090807060504030201,
        0x16151413121110090807060504030201,
        0x01020304050607080910111213141516,
        0x01020304050607080910111213141516,
        0x16151413121110090000000000000000
    ];

    let bytes = BytesTrait::new(88, array);

    let (new_offset, new_array) = bytes.read_u256_array(7, 2);
    assert_eq!(new_offset, 71, "read_u256_array_offset");
    let result: u256 = *new_array[0];
    assert_eq!(result.high, 0x08091011121314151616151413121110, "read_256_array_value_1_high");
    assert_eq!(result.low, 0x09080706050403020116151413121110, "read_256_array_value_1_low");
    let result: u256 = *new_array[1];
    assert_eq!(result.high, 0x09080706050403020101020304050607, "read_256_array_value_2_high");
    assert_eq!(result.low, 0x08091011121314151601020304050607, "read_256_array_value_2_low");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_address() {
    let array = array![
        0x01020304050607080910111213140154,
        0x01855d7796176b05d160196ff92381eb,
        0x7910f5446c2e0e04e13db2194a4f0000,
    ];

    let bytes = BytesTrait::new(46, array);
    let address = 0x015401855d7796176b05d160196ff92381eb7910f5446c2e0e04e13db2194a4f;

    let (new_offset, value) = bytes.read_address(14);
    assert_eq!(new_offset, 46, "read_address_offset");
    assert_eq!(value.into(), address, "read_address_value");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_bytes() {
    let array = array![
        0x01020304050607080910111213140154,
        0x01855d7796176b05d160196ff92381eb,
        0x7910f5446c2e0e04e13db2194a4f0000,
    ];

    let bytes = BytesTrait::new(46, array);

    let (new_offset, sub_bytes) = bytes.read_bytes(4, 37);
    let sub_bytes_data = @sub_bytes.data;
    assert_eq!(new_offset, 41, "read_bytes_offset");
    assert_eq!(sub_bytes.size(), 37, "read_bytes_size");
    assert_eq!(*sub_bytes_data[0], 0x05060708091011121314015401855d77, "read_bytes_value_1");
    assert_eq!(*sub_bytes_data[1], 0x96176b05d160196ff92381eb7910f544, "read_bytes_value_2");
    assert_eq!(*sub_bytes_data[2], 0x6c2e0e04e10000000000000000000000, "read_bytes_value_3");

    let (new_offset, sub_bytes) = bytes.read_bytes(0, 14);
    let sub_bytes_data = @sub_bytes.data;
    assert_eq!(new_offset, 14, "read_bytes_offset");
    assert_eq!(sub_bytes.size(), 14, "read_bytes_size");
    assert_eq!(*sub_bytes_data[0], 0x01020304050607080910111213140000, "read_bytes_value_4");

    // read first byte
    let (new_offset, sub_bytes) = bytes.read_bytes(0, 1);
    let sub_bytes_data = @sub_bytes.data;
    assert_eq!(new_offset, 1, "read_bytes_offset");
    assert_eq!(sub_bytes.size(), 1, "read_bytes_size");
    assert_eq!(*sub_bytes_data[0], 0x01000000000000000000000000000000, "read_bytes_value_5");

    // read last byte
    let (new_offset, sub_bytes) = bytes.read_bytes(45, 1);
    let sub_bytes_data = @sub_bytes.data;
    assert_eq!(new_offset, 46, "read_bytes_offset");
    assert_eq!(sub_bytes.size(), 1, "read_bytes_size");
    assert_eq!(*sub_bytes_data[0], 0x4f000000000000000000000000000000, "read_bytes_value_6");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_append() {
    let mut bytes = BytesTrait::new_empty();

    // append_u128_packed
    bytes.append_u128_packed(0x101112131415161718, 9);
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 9, "append_u128_packed_1_size");
    assert_eq!(*data[0], 0x10111213141516171800000000000000, "append_u128_packed_1_value_1");
    bytes = Bytes { size: size, data: data };

    bytes.append_u128_packed(0x101112131415161718, 9);
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 18, "append_u128_packed_2_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "append_u128_packed_2_value_1");
    assert_eq!(*data[1], 0x17180000000000000000000000000000, "append_u128_packed_2_value_2");
    bytes = Bytes { size: size, data: data };

    // append_u8
    bytes.append_u8(0x01);
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 19, "append_u8_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "append_u8_value_1");
    assert_eq!(*data[1], 0x17180100000000000000000000000000, "append_u8_value_2");
    bytes = Bytes { size: size, data: data };

    // append_u16
    bytes.append_u16(0x0102);
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 21, "append_u16_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "append_u16_value_1");
    assert_eq!(*data[1], 0x17180101020000000000000000000000, "append_u16_value_2");
    bytes = Bytes { size: size, data: data };

    // append_u32
    bytes.append_u32(0x01020304);
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 25, "append_u32_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "append_u32_value_1");
    assert_eq!(*data[1], 0x17180101020102030400000000000000, "append_u32_value_2");
    bytes = Bytes { size: size, data: data };

    // append_usize
    bytes.append_usize(0x01);
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 29, "append_usize_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "append_usize_value_1");
    assert_eq!(*data[1], 0x17180101020102030400000001000000, "append_usize_value_2");
    bytes = Bytes { size: size, data: data };

    // append_u64
    bytes.append_u64(0x030405060708);
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 37, "append_u64_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "append_u64_value_1");
    assert_eq!(*data[1], 0x17180101020102030400000001000003, "append_u64_value_2");
    assert_eq!(*data[2], 0x04050607080000000000000000000000, "append_u64_value_3");
    bytes = Bytes { size: size, data: data };

    // append_u128
    bytes.append_u128(0x101112131415161718);
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 53, "append_u128_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "append_u128_value_1");
    assert_eq!(*data[1], 0x17180101020102030400000001000003, "append_u128_value_2");
    assert_eq!(*data[2], 0x04050607080000000000000010111213, "append_u128_value_3");
    assert_eq!(*data[3], 0x14151617180000000000000000000000, "append_u128_value_4");
    bytes = Bytes { size: size, data: data };

    // append_u256
    bytes.append_u256(u256 { low: 0x01020304050607, high: 0x010203040506070809 });
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 85, "append_u256_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "append_u256_value_1");
    assert_eq!(*data[1], 0x17180101020102030400000001000003, "append_u256_value_2");
    assert_eq!(*data[2], 0x04050607080000000000000010111213, "append_u256_value_3");
    assert_eq!(*data[3], 0x14151617180000000000000001020304, "append_u256_value_4");
    assert_eq!(*data[4], 0x05060708090000000000000000000102, "append_u256_value_5");
    assert_eq!(*data[5], 0x03040506070000000000000000000000, "append_u256_value_6");
    bytes = Bytes { size: size, data: data };

    // append_address
    let address = 0x015401855d7796176b05d160196ff92381eb7910f5446c2e0e04e13db2194a4f
        .try_into()
        .unwrap();
    bytes.append_address(address);
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 117, "append_address_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "append_address_value_1");
    assert_eq!(*data[1], 0x17180101020102030400000001000003, "append_address_value_2");
    assert_eq!(*data[2], 0x04050607080000000000000010111213, "append_address_value_3");
    assert_eq!(*data[3], 0x14151617180000000000000001020304, "append_address_value_4");
    assert_eq!(*data[4], 0x05060708090000000000000000000102, "append_address_value_5");
    assert_eq!(*data[5], 0x0304050607015401855d7796176b05d1, "append_address_value_6");
    assert_eq!(*data[6], 0x60196ff92381eb7910f5446c2e0e04e1, "append_address_value_7");
    assert_eq!(*data[7], 0x3db2194a4f0000000000000000000000, "append_address_value_8");
}

#[test]
#[available_gas(20000000)]
fn test_bytes_concat() {
    let array: Array<u128> = array![
        0x10111213141516171810111213141516,
        0x17180101020102030400000001000003,
        0x04050607080000000000000010111213,
        0x14151617180000000000000001020304,
        0x05060708090000000000000000000102,
        0x0304050607015401855d7796176b05d1,
        0x60196ff92381eb7910f5446c2e0e04e1,
        0x3db2194a4f0000000000000000000000
    ];
    let mut bytes = BytesTrait::new(117, array);

    let array: Array<u128> = array![
        0x01020304050607080910111213140154,
        0x01855d7796176b05d160196ff92381eb,
        0x7910f5446c2e0e04e13db2194a4f0000
    ];
    let other = BytesTrait::new(46, array);

    bytes.concat(@other);
    let Bytes { size, mut data } = bytes;
    assert_eq!(size, 163, "concat_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "concat_value_1");
    assert_eq!(*data[1], 0x17180101020102030400000001000003, "concat_value_2");
    assert_eq!(*data[2], 0x04050607080000000000000010111213, "concat_value_3");
    assert_eq!(*data[3], 0x14151617180000000000000001020304, "concat_value_4");
    assert_eq!(*data[4], 0x05060708090000000000000000000102, "concat_value_5");
    assert_eq!(*data[5], 0x0304050607015401855d7796176b05d1, "concat_value_6");
    assert_eq!(*data[6], 0x60196ff92381eb7910f5446c2e0e04e1, "concat_value_7");
    assert_eq!(*data[7], 0x3db2194a4f0102030405060708091011, "concat_value_8");
    assert_eq!(*data[8], 0x121314015401855d7796176b05d16019, "concat_value_9");
    assert_eq!(*data[9], 0x6ff92381eb7910f5446c2e0e04e13db2, "concat_value_10");
    assert_eq!(*data[10], 0x194a4f00000000000000000000000000, "concat_value_11");
    bytes = Bytes { size: size, data: data };

    // empty bytes concat
    let mut empty_bytes = BytesTrait::new_empty();
    empty_bytes.concat(@bytes);
    let Bytes { size, data } = empty_bytes;

    assert_eq!(size, 163, "concat_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "concat_value_1");
    assert_eq!(*data[1], 0x17180101020102030400000001000003, "concat_value_2");
    assert_eq!(*data[2], 0x04050607080000000000000010111213, "concat_value_3");
    assert_eq!(*data[3], 0x14151617180000000000000001020304, "concat_value_4");
    assert_eq!(*data[4], 0x05060708090000000000000000000102, "concat_value_5");
    assert_eq!(*data[5], 0x0304050607015401855d7796176b05d1, "concat_value_6");
    assert_eq!(*data[6], 0x60196ff92381eb7910f5446c2e0e04e1, "concat_value_7");
    assert_eq!(*data[7], 0x3db2194a4f0102030405060708091011, "concat_value_8");
    assert_eq!(*data[8], 0x121314015401855d7796176b05d16019, "concat_value_9");
    assert_eq!(*data[9], 0x6ff92381eb7910f5446c2e0e04e13db2, "concat_value_10");
    assert_eq!(*data[10], 0x194a4f00000000000000000000000000, "concat_value_11");

    // concat empty_bytes
    let empty_bytes = BytesTrait::new_empty();
    bytes.concat(@empty_bytes);

    assert_eq!(size, 163, "concat_size");
    assert_eq!(*data[0], 0x10111213141516171810111213141516, "concat_value_1");
    assert_eq!(*data[1], 0x17180101020102030400000001000003, "concat_value_2");
    assert_eq!(*data[2], 0x04050607080000000000000010111213, "concat_value_3");
    assert_eq!(*data[3], 0x14151617180000000000000001020304, "concat_value_4");
    assert_eq!(*data[4], 0x05060708090000000000000000000102, "concat_value_5");
    assert_eq!(*data[5], 0x0304050607015401855d7796176b05d1, "concat_value_6");
    assert_eq!(*data[6], 0x60196ff92381eb7910f5446c2e0e04e1, "concat_value_7");
    assert_eq!(*data[7], 0x3db2194a4f0102030405060708091011, "concat_value_8");
    assert_eq!(*data[8], 0x121314015401855d7796176b05d16019, "concat_value_9");
    assert_eq!(*data[9], 0x6ff92381eb7910f5446c2e0e04e13db2, "concat_value_10");
    assert_eq!(*data[10], 0x194a4f00000000000000000000000000, "concat_value_11");
}

#[test]
#[available_gas(20000000)]
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
    assert_eq!(res, hash, "bytes_keccak_0");

    // u256{low: 1, high: 0}
    let mut array = array![];
    array.append(0);
    array.append(1);
    let bytes: Bytes = BytesTrait::new(32, array);
    let res = bytes.keccak();
    let hash: u256 = 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6;
    assert_eq!(res, hash, "bytes_keccak_1");

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
    assert_eq!(res, hash, "bytes_keccak_2");
}

#[test]
#[available_gas(20000000000)]
fn test_bytes_sha256() {
    // empty
    let bytes = BytesTrait::new_empty();
    let hash: u256 = 0xe3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855;
    let res = bytes.sha256();
    assert_eq!(res, hash, "bytes_sha256_0");

    // u256{low: 1, high: 0}
    // 0x0000000000000000000000000000000000000000000000000000000000000001
    let array = array![0, 1];
    let bytes: Bytes = BytesTrait::new(32, array);
    let res = bytes.sha256();
    let hash: u256 = 0xec4916dd28fc4c10d78e287ca5d9cc51ee1ae73cbfde08c6b37324cbfaac8bc5;
    assert_eq!(res, hash, "bytes_sha256_1");

    // test_bytes_append bytes
    let array = array![
        0x10111213141516171810111213141516,
        0x17180101020102030400000001000003,
        0x04050607080000000000000010111213,
        0x14151617180000000000000001020304,
        0x05060708090000000000000000000102,
        0x0304050607015401855d7796176b05d1,
        0x60196ff92381eb7910f5446c2e0e04e1,
        0x3db2194a4f0000000000000000000000,
    ];

    let bytes: Bytes = BytesTrait::new(117, array);

    let hash: u256 = 0xc3ab2c0ce2c246454f265f531ab14f210215ce72b91c23338405c273dc14ce1d;
    let res = bytes.sha256();
    assert_eq!(res, hash, "bytes_sha256_2");
}
