use alexandria_bytes::byte_array_ext::{
    ByteArrayIntoArrayU8, ByteArrayTraitExt, SpanU8IntoByteArray,
};
use alexandria_bytes::utils::u256_reverse_endian;

#[test]
fn test_new() {
    let array = array![
        0x01020304050607080910111213141516, 0x01020304050607080910111213141516,
        0x01020304050607080910000000000000,
    ];

    let ba: ByteArray = ByteArrayTraitExt::new(48, array);
    assert!(ba.len() == 48, "Failed to instantiate new ByteArray from array");

    let (new_offset, result) = ba.read_u128(15);
    assert!(new_offset == 31);
    assert!(result == 0x16010203040506070809101112131415);
}

#[test]
fn test_new_empty() {
    let ba: ByteArray = ByteArrayTraitExt::new_empty();
    assert!(ba.len() == 0, "Failed to instantiate new empty ByteArray");
}

#[test]
#[should_panic(expected: ('out of bound',))]
fn test_read_from_empty_byte_array() {
    let ba = Default::default();
    ba.read_u16(0);
}

#[test]
fn test_read_write_max_u16() {
    let max_u16 = 0xffff_u16;
    let mut ba: ByteArray = Default::default();
    assert!(ba.len() == 0);
    ba.append_u16(max_u16);
    let (new_offset, result) = ba.read_u16(0);
    assert!(new_offset == 2);
    assert!(result == max_u16);
}

#[test]
fn test_read_write_max_u32() {
    let max_u32 = 0xffffffff_u32;
    let mut ba = Default::default();
    ba.append_u32(max_u32);
    let (new_offset, result) = ba.read_u32(0);
    assert!(new_offset == 4);
    assert!(result == max_u32);
}

#[test]
fn test_read_zero_length_u128_array() {
    let mut ba = Default::default();
    let (new_offset, result) = ba.read_u128_array_packed(0, 0, 16);
    assert!(new_offset == 0);
    assert!(result.len() == 0);
}

// Tests for appending values
#[test]
fn test_append_u128() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    assert!(ba.len() == 16);
    assert!(ba.at(0).unwrap() == 0x01);
    assert!(ba.at(15).unwrap() == 0x16);
}

#[test]
fn test_append_u256() {
    let mut ba = Default::default();
    ba
        .append_u256(
            u256 {
                high: 0x01020304050607080910111213141516, low: 0x17181920212223242526272829303132,
            },
        );
    assert!(ba.len() == 32);
    assert!(ba.at(0).unwrap() == 0x01);
    assert!(ba.at(31).unwrap() == 0x32);
}

#[test]
fn test_append_felt252() {
    let mut ba = Default::default();
    let felt_value: felt252 = 0x91020304050607080910111213141516171819202122232425262728293031
        .try_into()
        .unwrap();
    ba.append_felt252(felt_value);
    assert!(ba.len() == 32);
    assert!(ba.at(0).unwrap() == 0x00);
    assert!(ba.at(31).unwrap() == 0x31);
}

// Tests for reading values
#[test]
fn test_read_felt252() {
    let mut ba = Default::default();
    let felt_value: felt252 = 0x0102030405060708091011121314151617181920212223242526272829303132
        .try_into()
        .unwrap();
    ba.append_felt252(felt_value);
    let (new_offset, result) = ba.read_felt252(0);
    assert!(new_offset == 32);
    assert!(result == felt_value);
}

#[test]
fn test_read_u16_at_boundary() {
    let mut ba = Default::default();
    ba.append_u32(0x03040506);
    let (new_offset, result) = ba.read_u16(2);
    assert!(new_offset == 4);
    assert!(result == 0x0506);
}

#[test]
fn test_bytes_append() {
    let mut ba = Default::default();
    ba.append_u16(0x0102);
    assert!(ba.len() == 2);
    assert!(ba.at(0).unwrap() == 0x01);
    assert!(ba.at(1).unwrap() == 0x02);

    ba.append_u32(0x03040506);
    assert!(ba.len() == 6);
    assert!(ba.at(2).unwrap() == 0x03);
    assert!(ba.at(5).unwrap() == 0x06);

    ba.append_u64(0x0708091011121314);
    assert!(ba.len() == 14);
    assert!(ba.at(6).unwrap() == 0x07);
    assert!(ba.at(13).unwrap() == 0x14);

    ba.append_usize(0x15161718);
    assert!(ba.len() == 18);
    assert!(ba.at(14).unwrap() == 0x15);
    assert!(ba.at(17).unwrap() == 0x18);

    let mut ba2 = Default::default();
    let address = 0x015401855d7796176b05d160196ff92381eb7910f5446c2e0e04e13db2194a4f
        .try_into()
        .unwrap();
    ba2.append_address(address);
    assert!(ba2.len() == 32);
}

#[test]
fn test_append_byte_31() {
    let b31: bytes31 = 0x030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f1700
        .try_into()
        .unwrap();

    let mut ba = Default::default();
    ba.append_bytes31(b31);
    let (offset, val) = ba.read_bytes31(0);
    assert!(offset == 31, "wrong offset");
    assert!(val == b31, "append_bytes31 mismatch expected value");
}

// Tests for reading specific data types
#[test]
fn test_read_u16() {
    let mut ba = Default::default();
    ba.append_u32(0x03040506);
    let (new_offset, result) = ba.read_u16(1);
    assert!(new_offset == 3);
    assert!(result == 0x0405);
}

#[test]
fn test_read_u32() {
    let mut ba = Default::default();
    ba.append_u32(0x03040506);
    let (new_offset, result) = ba.read_u32(0);
    assert!(new_offset == 4);
    assert!(result == 0x03040506);
}

#[test]
fn test_bytes_read_usize() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);
    let (new_offset, result) = ba.read_usize(15);
    assert!(new_offset == 19);
    assert!(result == 0x16010203);
}

#[test]
fn test_read_u64() {
    let mut ba = Default::default();
    ba.append_u64(0x0708091011121314);
    let (new_offset, result) = ba.read_u64(0);
    assert!(new_offset == 8);
    assert!(result == 0x0708091011121314);
}

#[test]
fn test_bytes_read_u128() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);
    let (new_offset, result) = ba.read_u128(15);
    assert!(new_offset == 31);
    assert!(result == 0x16010203040506070809101112131415);
}

#[test]
fn test_bytes_read_u128_packed() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);

    let (new_offset, value) = ba.read_u128_packed(0, 1);
    assert!(new_offset == 1);
    assert!(value == 0x01);

    let (new_offset, value) = ba.read_u128_packed(new_offset, 14);
    assert!(new_offset == 15);
    assert!(value == 0x0203040506070809101112131415);

    let (new_offset, value) = ba.read_u128_packed(new_offset, 15);
    assert!(new_offset == 30);
    assert!(value == 0x160102030405060708091011121314);

    let (new_offset, value) = ba.read_u128_packed(new_offset, 8);
    assert!(new_offset == 38);
    assert!(value == 0x1516010203040506);

    let (new_offset, value) = ba.read_u128_packed(new_offset, 4);
    assert!(new_offset == 42);
    assert!(value == 0x07080910);
}

#[test]
#[should_panic(expected: ('out of bound',))]
fn test_bytes_read_u128_packed_out_of_bound() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);

    ba.read_u128_packed(0, 49);
}

#[test]
#[should_panic(expected: ('too large',))]
fn test_bytes_read_u128_packed_too_large() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);

    ba.read_u128_packed(0, 17);
}

#[test]
fn test_bytes_read_felt252_packed() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);

    let (new_offset, value) = ba.read_felt252_packed(13, 20);
    assert!(new_offset == 33);
    assert!(value == 0x1415160102030405060708091011121314151601);
}

#[test]
#[should_panic(expected: ('out of bound',))]
fn test_bytes_read_felt252_packed_out_of_bound() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);
    ba.read_felt252_packed(0, 49);
}

#[test]
#[should_panic(expected: ('too large',))]
fn test_bytes_read_felt252_packed_too_large() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);
    ba.read_felt252_packed(0, 32);
}

#[test]
fn test_bytes_read_u256() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);
    let (new_offset, result) = ba.read_u256(4);
    assert!(new_offset == 36);
    assert!(result.high == 0x05060708091011121314151601020304);
    assert!(result.low == 0x05060708091011121314151601020304);
}

#[test]
fn test_bytes_read_address() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213140154);
    ba.append_u128(0x01855d7796176b05d160196ff92381eb);
    ba.append_u128(0x7910f5446c2e0e04e13db2194a4f0000);

    let address = 0x015401855d7796176b05d160196ff92381eb7910f5446c2e0e04e13db2194a4f;

    let (new_offset, value) = ba.read_address(14);
    assert!(new_offset == 46);
    assert!(value.into() == address);
}

// Tests for reading bytes
#[test]
fn test_read_bytes_size_0() {
    let mut ba = Default::default();
    let (new_offset, result) = ba.read_bytes(0, 0);
    assert!(new_offset == 0);
    assert!(result == Default::default());
}

#[test]
fn test_read_bytes_lower_than_32() {
    let mut ba = Default::default();
    let mut expected_result = Default::default();
    expected_result.append_u16(0x0405);
    ba.append_u32(0x03040506);
    let (new_offset, result) = ba.read_bytes(1, 2);
    assert!(new_offset == 3);
    assert!(result == expected_result);
}

#[test]
fn test_read_bytes_greater_than_32() {
    let mut ba = Default::default();
    let mut expected_result = Default::default();
    expected_result.append_u32(0x08091011);
    expected_result.append_u16(0x1213);
    ba.append_u64(0x0708091011121314);
    let (new_offset, result) = ba.read_bytes(1, 6);
    assert!(new_offset == 7);
    assert!(result == expected_result);
}

// Tests for updating bytes
#[test]
fn test_update_at() {
    let mut ba = Default::default();
    let mut expected_result = Default::default();
    expected_result.append_u32(0x08071011);
    ba.append_u32(0x08091011);
    ba.update_at(1, 0x07);
    assert!(ba.len() == expected_result.len());
    assert!(ba == expected_result);
}

#[test]
fn test_update_at_first_byte() {
    let mut ba = Default::default();
    let mut expected_result = Default::default();
    expected_result.append_u32(0x07091011);
    ba.append_u32(0x08091011);
    ba.update_at(0, 0x07);
    assert!(ba.len() == expected_result.len());
    assert!(ba == expected_result);
}

#[test]
fn test_update_at_last_byte() {
    let mut ba = Default::default();
    let mut expected_result = Default::default();
    expected_result.append_u32(0x08091007);
    ba.append_u32(0x08091011);
    ba.update_at(ba.len() - 1, 0x07);
    assert!(ba.len() == expected_result.len());
    assert!(ba == expected_result);
}

// Tests for reading arrays
#[test]
fn test_bytes_read_u128_array_packed() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);

    let (new_offset, new_array) = ba.read_u128_array_packed(0, 3, 3);
    assert!(new_offset == 9);
    assert!(*new_array[0] == 0x010203);
    assert!(*new_array[1] == 0x040506);
    assert!(*new_array[2] == 0x070809);

    let (new_offset, new_array) = ba.read_u128_array_packed(9, 4, 7);
    assert!(new_offset == 37);
    assert!(*new_array[0] == 0x10111213141516);
    assert!(*new_array[1] == 0x01020304050607);
    assert!(*new_array[2] == 0x08091011121314);
    assert!(*new_array[3] == 0x15160102030405);
}

#[test]
#[should_panic(expected: ('out of bound',))]
fn test_bytes_read_u128_array_packed_out_of_bound() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.read_u128_array_packed(0, 11, 4);
}

#[test]
fn test_bytes_read_u256_array() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x16151413121110090807060504030201);
    ba.append_u128(0x16151413121110090807060504030201);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x16151413121110090000000000000000);

    let (new_offset, new_array) = ba.read_u256_array(7, 2);
    assert!(new_offset == 71);
    let result: u256 = *new_array[0];
    assert!(result.high == 0x08091011121314151616151413121110);
    assert!(result.low == 0x09080706050403020116151413121110);
    let result: u256 = *new_array[1];
    assert!(result.high == 0x09080706050403020101020304050607);
    assert!(result.low == 0x08091011121314151601020304050607);
}

#[test]
fn test_bytes_read_bytes31() {
    let mut ba = Default::default();
    ba.append_u128(0x0102030405060708090a0b0c0d0e0f10);
    ba.append_u128(0x1112131415161718191a1b1c1d1e1f17);
    ba.append_u128(0x00);

    let (offset, val) = ba.read_bytes31(2);

    assert!(offset == 33);
    let byte31: bytes31 = 0x030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f1700
        .try_into()
        .unwrap();

    assert!(val == byte31, "read_bytes31 mismatch expected value");
}


#[test]
fn test_span_u8_into_byte_array() {
    let array: Array<u8> = array![1, 2, 3, 4, 5, 6, 7, 8];
    let ba: ByteArray = array.span().into();
    let mut index = 0_usize;
    while let Option::Some(byte) = ba.at(index) {
        assert!(*(array[index]) == byte);
        index += 1;
    };
}

#[test]
fn test_byte_array_into_array_u8() {
    let array: Array<u8> = test_byte_array_64().into();
    let mut index = 0_usize;
    while (index != 64) {
        assert!((*array[index]).into() == index + 1, "unexpected result");
        index += 1;
    }
}

fn test_byte_array_64() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f, 31);
    ba1.append_word(0x202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e, 31);
    ba1.append_word(0x3f40, 2);
    ba1
}

#[test]
fn test_append_u16_new() {
    let mut ba: ByteArray = Default::default();
    ba.append_u16(0x0102_u16);
}

#[test]
fn test_keccak_be() {
    let x = 1234_u256;
    let solidity_expected: u256 =
        10845050086153542540880384713334172698320754731055414623607759687799872907108;

    let mut ba: ByteArray = Default::default();
    ba.append_u256(x);
    let keccak_be_result = ba.keccak_be();

    assert!(keccak_be_result == solidity_expected);
}

#[test]
fn test_keccak_le() {
    let x = 1234_u256;
    let expected: u256 =
        45413456864617728695064797052814794331488824331538534789368531831582969100823;

    let mut ba: ByteArray = Default::default();
    ba.append_u256(x);
    let keccak_le_result = ba.keccak_le();

    assert!(keccak_le_result == expected);
}

#[test]
fn test_keccak_le_be_endian_difference() {
    let x = 1234_u256;

    let mut ba: ByteArray = Default::default();
    ba.append_u256(x);

    let keccak_le_result = ba.keccak_le();
    let keccak_be_result = ba.keccak_be();

    // Verify they are not equal (different endianness)
    assert!(keccak_le_result != keccak_be_result);

    // Verify that reversing the endianness of keccak_le gives keccak_be
    let keccak_le_reversed = u256_reverse_endian(keccak_le_result);
    assert!(keccak_le_reversed == keccak_be_result);

    // Verify that reversing the endianness of keccak_be gives keccak_le
    let keccak_be_reversed = u256_reverse_endian(keccak_be_result);
    assert!(keccak_be_reversed == keccak_le_result);
}

