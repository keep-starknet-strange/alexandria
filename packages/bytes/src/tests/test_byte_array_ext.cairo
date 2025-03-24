use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;

// Tests for boundary conditions and edge cases
#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('out of bound',))]
fn test_read_from_empty_byte_array() {
    let ba = Default::default();
    ba.read_u16(0);
}

#[test]
#[available_gas(20000000)]
fn test_read_write_max_u16() {
    let max_u16 = 0xffff_u16;
    let mut ba = Default::default();
    ba.append_u16(max_u16);
    let (new_offset, result) = ba.read_u16(0);
    assert_eq!(new_offset, 2);
    assert_eq!(result, max_u16);
}

#[test]
#[available_gas(20000000)]
fn test_read_write_max_u32() {
    let max_u32 = 0xffffffff_u32;
    let mut ba = Default::default();
    ba.append_u32(max_u32);
    let (new_offset, result) = ba.read_u32(0);
    assert_eq!(new_offset, 4);
    assert_eq!(result, max_u32);
}

#[test]
#[available_gas(20000000)]
fn test_read_zero_length_u128_array() {
    let mut ba = Default::default();
    let (new_offset, result) = ba.read_u128_array_packed(0, 0, 16);
    assert_eq!(new_offset, 0);
    assert_eq!(result.len(), 0);
}

// Tests for appending values
#[test]
#[available_gas(20000000)]
fn test_append_u128() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    assert_eq!(ba.len(), 16);
    assert_eq!(ba.at(0).unwrap(), 0x01);
    assert_eq!(ba.at(15).unwrap(), 0x16);
}

#[test]
#[available_gas(20000000)]
fn test_append_u256() {
    let mut ba = Default::default();
    ba
        .append_u256(
            u256 {
                high: 0x01020304050607080910111213141516, low: 0x17181920212223242526272829303132,
            },
        );
    assert_eq!(ba.len(), 32);
    assert_eq!(ba.at(0).unwrap(), 0x01);
    assert_eq!(ba.at(31).unwrap(), 0x32);
}

#[test]
#[available_gas(20000000)]
fn test_append_felt252() {
    let mut ba = Default::default();
    let felt_value: felt252 = 0x0102030405060708091011121314151617181920212223242526272829303132
        .try_into()
        .unwrap();
    ba.append_felt252(felt_value);
    assert_eq!(ba.len(), 32);
    assert_eq!(ba.at(0).unwrap(), 0x01);
    assert_eq!(ba.at(31).unwrap(), 0x32);
}

// Tests for reading values
#[test]
#[available_gas(20000000)]
fn test_read_felt252() {
    let mut ba = Default::default();
    let felt_value: felt252 = 0x0102030405060708091011121314151617181920212223242526272829303132
        .try_into()
        .unwrap();
    ba.append_felt252(felt_value);
    let (new_offset, result) = ba.read_felt252(0);
    assert_eq!(new_offset, 32);
    assert_eq!(result, felt_value);
}

#[test]
#[available_gas(20000000)]
fn test_read_u16_at_boundary() {
    let mut ba = Default::default();
    ba.append_u32(0x03040506);
    let (new_offset, result) = ba.read_u16(2);
    assert_eq!(new_offset, 4);
    assert_eq!(result, 0x0506);
}

#[test]
#[available_gas(20000000)]
fn test_bytes_append() {
    let mut ba = Default::default();
    ba.append_u16(0x0102);
    assert_eq!(ba.len(), 2);
    assert_eq!(ba.at(0).unwrap(), 0x01);
    assert_eq!(ba.at(1).unwrap(), 0x02);

    ba.append_u32(0x03040506);
    assert_eq!(ba.len(), 6);
    assert_eq!(ba.at(2).unwrap(), 0x03);
    assert_eq!(ba.at(5).unwrap(), 0x06);

    ba.append_u64(0x0708091011121314);
    assert_eq!(ba.len(), 14);
    assert_eq!(ba.at(6).unwrap(), 0x07);
    assert_eq!(ba.at(13).unwrap(), 0x14);

    let mut ba2 = Default::default();
    let address = 0x015401855d7796176b05d160196ff92381eb7910f5446c2e0e04e13db2194a4f
        .try_into()
        .unwrap();
    ba2.append_address(address);
    assert_eq!(ba2.len(), 32);
}

#[test]
#[available_gas(20000000)]
fn test_append_byte_31() {
    let b31: bytes31 = 0x030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f1700
        .try_into()
        .unwrap();

    let mut ba = Default::default();
    ba.append_bytes31(b31);
    let (offset, val) = ba.read_bytes31(0);
    assert_eq!(offset, 31, "wrong offset");
    assert!(val == b31, "append_bytes31 mismatch expected value");
}

// Tests for reading specific data types
#[test]
#[available_gas(20000000)]
fn test_read_u16() {
    let mut ba = Default::default();
    ba.append_u32(0x03040506);
    let (new_offset, result) = ba.read_u16(1);
    assert_eq!(new_offset, 3);
    assert_eq!(result, 0x0405);
}

#[test]
#[available_gas(20000000)]
fn test_read_u32() {
    let mut ba = Default::default();
    ba.append_u32(0x03040506);
    let (new_offset, result) = ba.read_u32(0);
    assert_eq!(new_offset, 4);
    assert_eq!(result, 0x03040506);
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_usize() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);
    let (new_offset, result) = ba.read_usize(15);
    assert_eq!(new_offset, 19);
    assert_eq!(result, 0x16010203);
}

#[test]
#[available_gas(20000000)]
fn test_read_u64() {
    let mut ba = Default::default();
    ba.append_u64(0x0708091011121314);
    let (new_offset, result) = ba.read_u64(0);
    assert_eq!(new_offset, 8);
    assert_eq!(result, 0x0708091011121314);
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u128() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);
    let (new_offset, result) = ba.read_u128(15);
    assert_eq!(new_offset, 31);
    assert_eq!(result, 0x16010203040506070809101112131415);
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u256() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);
    let (new_offset, result) = ba.read_u256(4);
    assert_eq!(new_offset, 36);
    assert_eq!(result.high, 0x05060708091011121314151601020304);
    assert_eq!(result.low, 0x05060708091011121314151601020304);
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_address() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213140154);
    ba.append_u128(0x01855d7796176b05d160196ff92381eb);
    ba.append_u128(0x7910f5446c2e0e04e13db2194a4f0000);

    let address = 0x015401855d7796176b05d160196ff92381eb7910f5446c2e0e04e13db2194a4f;

    let (new_offset, value) = ba.read_address(14);
    assert_eq!(new_offset, 46);
    assert_eq!(value.into(), address);
}

// Tests for reading bytes
#[test]
#[available_gas(20000000)]
fn test_read_bytes_size_0() {
    let mut ba = Default::default();
    let (new_offset, result) = ba.read_bytes(0, 0);
    assert_eq!(new_offset, 0);
    assert_eq!(result, Default::default());
}

#[test]
#[available_gas(20000000)]
fn test_read_bytes_lower_than_32() {
    let mut ba = Default::default();
    let mut expected_result = Default::default();
    expected_result.append_u16(0x0405);
    ba.append_u32(0x03040506);
    let (new_offset, result) = ba.read_bytes(1, 2);
    assert_eq!(new_offset, 3);
    assert_eq!(result, expected_result);
}

#[test]
#[available_gas(20000000)]
fn test_read_bytes_greater_than_32() {
    let mut ba = Default::default();
    let mut expected_result = Default::default();
    expected_result.append_u32(0x08091011);
    expected_result.append_u16(0x1213);
    ba.append_u64(0x0708091011121314);
    let (new_offset, result) = ba.read_bytes(1, 6);
    assert_eq!(new_offset, 7);
    assert_eq!(result, expected_result);
}

// Tests for updating bytes
#[test]
#[available_gas(20000000)]
fn test_update_at() {
    let mut ba = Default::default();
    let mut expected_result = Default::default();
    expected_result.append_u32(0x08071011);
    ba.append_u32(0x08091011);
    ba.update_at(1, 0x07);
    assert_eq!(ba.len(), expected_result.len());
    assert_eq!(ba, expected_result);
}

#[test]
#[available_gas(20000000)]
fn test_update_at_first_byte() {
    let mut ba = Default::default();
    let mut expected_result = Default::default();
    expected_result.append_u32(0x07091011);
    ba.append_u32(0x08091011);
    ba.update_at(0, 0x07);
    assert_eq!(ba.len(), expected_result.len());
    assert_eq!(ba, expected_result);
}

#[test]
#[available_gas(20000000)]
fn test_update_at_last_byte() {
    let mut ba = Default::default();
    let mut expected_result = Default::default();
    expected_result.append_u32(0x08091007);
    ba.append_u32(0x08091011);
    ba.update_at(ba.len() - 1, 0x07);
    assert_eq!(ba.len(), expected_result.len());
    assert_eq!(ba, expected_result);
}

// Tests for reading arrays
#[test]
#[available_gas(20000000)]
fn test_bytes_read_u128_array_packed() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910000000000000);

    let (new_offset, new_array) = ba.read_u128_array_packed(0, 3, 3);
    assert_eq!(new_offset, 9);
    assert_eq!(*new_array[0], 0x010203);
    assert_eq!(*new_array[1], 0x040506);
    assert_eq!(*new_array[2], 0x070809);

    let (new_offset, new_array) = ba.read_u128_array_packed(9, 4, 7);
    assert_eq!(new_offset, 37);
    assert_eq!(*new_array[0], 0x10111213141516);
    assert_eq!(*new_array[1], 0x01020304050607);
    assert_eq!(*new_array[2], 0x08091011121314);
    assert_eq!(*new_array[3], 0x15160102030405);
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('out of bound',))]
fn test_bytes_read_u128_array_packed_out_of_bound() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.read_u128_array_packed(0, 11, 4);
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_u256_array() {
    let mut ba = Default::default();
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x16151413121110090807060504030201);
    ba.append_u128(0x16151413121110090807060504030201);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x01020304050607080910111213141516);
    ba.append_u128(0x16151413121110090000000000000000);

    let (new_offset, new_array) = ba.read_u256_array(7, 2);
    assert_eq!(new_offset, 71);
    let result: u256 = *new_array[0];
    assert_eq!(result.high, 0x08091011121314151616151413121110);
    assert_eq!(result.low, 0x09080706050403020116151413121110);
    let result: u256 = *new_array[1];
    assert_eq!(result.high, 0x09080706050403020101020304050607);
    assert_eq!(result.low, 0x08091011121314151601020304050607);
}

#[test]
#[available_gas(20000000)]
fn test_bytes_read_bytes31() {
    let mut ba = Default::default();
    ba.append_u128(0x0102030405060708090a0b0c0d0e0f10);
    ba.append_u128(0x1112131415161718191a1b1c1d1e1f17);
    ba.append_u128(0x00);

    let (offset, val) = ba.read_bytes31(2);

    assert_eq!(offset, 33);
    let byte31: bytes31 = 0x030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f1700
        .try_into()
        .unwrap();

    assert!(val == byte31, "read_bytes31 mismatch expected value");
}
