use alexandria_data_structures::byte_reader::ByteReader;
use core::integer::u512;

#[test]
#[available_gas(1000000)]
fn test_word_u16() {
    let word = test_byte_array_64().word_u16(62).unwrap();
    assert!(word == 0x3f40_u16, "word u16 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u16_arr() {
    let word = test_array_64().word_u16(62).unwrap();
    assert!(word == 0x3f40_u16, "word u16 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u16_le() {
    let word = test_byte_array_64().word_u16_le(62).unwrap();
    assert!(word == 0x403f_u16, "word u16 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u16_le_arr() {
    let word = test_array_64().word_u16_le(62).unwrap();
    assert!(word == 0x403f_u16, "word u16 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u16_none() {
    let is_none = test_byte_array_64().word_u16(63).is_none();
    assert!(is_none, "word u16 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u16_none_arr() {
    let is_none = test_array_64().word_u16(63).is_none();
    assert!(is_none, "word u16 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u16_le_none() {
    let is_none = test_byte_array_64().word_u16_le(63).is_none();
    assert!(is_none, "word u16 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u16_le_none_arr() {
    let is_none = test_array_64().word_u16_le(63).is_none();
    assert!(is_none, "word u16 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u32() {
    let word = test_byte_array_64().word_u32(60).unwrap();
    assert!(word == 0x3d3e3f40_u32, "word u32 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u32_arr() {
    let word = test_array_64().word_u32(60).unwrap();
    assert!(word == 0x3d3e3f40_u32, "word u32 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u32_le() {
    let word = test_byte_array_64().word_u32_le(60).unwrap();
    assert!(word == 0x403f3e3d_u32, "word u32 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u32_le_arr() {
    let word = test_array_64().word_u32_le(60).unwrap();
    assert!(word == 0x403f3e3d_u32, "word u32 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u32_none() {
    let is_none = test_byte_array_64().word_u32(61).is_none();
    assert!(is_none, "word u32 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u32_none_arr() {
    let is_none = test_array_64().word_u32(61).is_none();
    assert!(is_none, "word u32 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u32_le_none() {
    let is_none = test_byte_array_64().word_u32_le(61).is_none();
    assert!(is_none, "word u32 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u32_le_none_arr() {
    let is_none = test_array_64().word_u32_le(61).is_none();
    assert!(is_none, "word u32 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u64() {
    let word = test_byte_array_64().word_u64(56).unwrap();
    assert!(word == 0x393a3b3c3d3e3f40_u64, "word u64 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u64_arr() {
    let word = test_array_64().word_u64(56).unwrap();
    assert!(word == 0x393a3b3c3d3e3f40_u64, "word u64 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u64_le() {
    let word = test_byte_array_64().word_u64_le(56).unwrap();
    assert!(word == 0x403f3e3d3c3b3a39_u64, "word u64 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u64_le_arr() {
    let word = test_array_64().word_u64_le(56).unwrap();
    assert!(word == 0x403f3e3d3c3b3a39_u64, "word u64 differs");
}

#[test]
#[available_gas(1000000)]
fn test_word_u64_none() {
    let is_none = test_byte_array_64().word_u64(57).is_none();
    assert!(is_none, "word u64 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u64_none_arr() {
    let is_none = test_array_64().word_u64(57).is_none();
    assert!(is_none, "word u64 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u64_le_none() {
    let is_none = test_byte_array_64().word_u64_le(57).is_none();
    assert!(is_none, "word u64 should be empty");
}

#[test]
#[available_gas(1000000)]
fn test_word_u64_le_none_arr() {
    let is_none = test_array_64().word_u64_le(57).is_none();
    assert!(is_none, "word u64 should be empty");
}

#[test]
#[available_gas(2000000)]
fn test_word_u128() {
    let word = test_byte_array_64().word_u128(48).unwrap();
    assert!(word == 0x3132333435363738393a3b3c3d3e3f40_u128, "word u128 differs");
}

#[test]
#[available_gas(2000000)]
fn test_word_u128_arr() {
    let word = test_array_64().word_u128(48).unwrap();
    assert!(word == 0x3132333435363738393a3b3c3d3e3f40_u128, "word u128 differs");
}

#[test]
#[available_gas(2000000)]
fn test_word_u128_le() {
    let word = test_byte_array_64().word_u128_le(48).unwrap();
    assert!(word == 0x403f3e3d3c3b3a393837363534333231_u128, "word u128 differs");
}

#[test]
#[available_gas(2000000)]
fn test_word_u128_le_arr() {
    let word = test_array_64().word_u128_le(48).unwrap();
    assert!(word == 0x403f3e3d3c3b3a393837363534333231_u128, "word u128 differs");
}

#[test]
#[available_gas(2000000)]
fn test_word_u128_none() {
    let is_none = test_byte_array_64().word_u128(49).is_none();
    assert!(is_none, "word u128 should be empty");
}

fn test_word_u128_none_arr() {
    let is_none = test_array_64().word_u128(49).is_none();
    assert!(is_none, "word u128 should be empty");
}

#[test]
#[available_gas(2000000)]
fn test_word_u128_le_none() {
    let is_none = test_byte_array_64().word_u128_le(49).is_none();
    assert!(is_none, "word u128 should be empty");
}

#[test]
#[available_gas(2000000)]
fn test_word_u128_le_none_arr() {
    let is_none = test_array_64().word_u128_le(49).is_none();
    assert!(is_none, "word u128 should be empty");
}

#[test]
#[available_gas(2000000)]
fn test_reader_helper() {
    let ba = test_byte_array_64();
    let reader = ba.reader();
    assert!(reader.data == @ba, "reader failed");
}

#[test]
#[available_gas(2000000)]
fn test_reader_helper_arr() {
    let ba = test_array_64();
    let reader = ba.reader();
    assert!(reader.data == @ba, "reader failed");
}

#[test]
#[available_gas(20000000)]
fn test_len() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    assert!(64 == rd.len(), "expected len 64");
    let _ = rd.read_u8().expect('some');
    assert!(63 == rd.len(), "expected len 63");
    let _ = rd.read_u256().expect('some');
    assert!(31 == rd.len(), "expected len 31");
    let _ = rd.read_u128().expect('some');
    assert!(15 == rd.len(), "expected len 15");
    let _ = rd.read_u64().expect('some');
    assert!(7 == rd.len(), "expected len 7");
    let _ = rd.read_u32().expect('some');
    assert!(3 == rd.len(), "expected len 3");
    let _ = rd.read_u16().expect('some');
    assert!(1 == rd.len(), "expected len 1");
    let _ = rd.read_i8().expect('some');
    assert!(0 == rd.len(), "expected len 0");
}

#[test]
#[available_gas(20000000)]
fn test_len_arr() {
    let ba = test_array_64();
    let mut rd = ba.reader();
    assert!(64 == rd.len(), "expected len 64");
    let _ = rd.read_u8().expect('some');
    assert!(63 == rd.len(), "expected len 63");
    let _ = rd.read_u256().expect('some');
    assert!(31 == rd.len(), "expected len 31");
    let _ = rd.read_u128().expect('some');
    assert!(15 == rd.len(), "expected len 15");
    let _ = rd.read_u64().expect('some');
    assert!(7 == rd.len(), "expected len 7");
    let _ = rd.read_u32().expect('some');
    assert!(3 == rd.len(), "expected len 3");
    let _ = rd.read_u16().expect('some');
    assert!(1 == rd.len(), "expected len 1");
    let _ = rd.read_i8().expect('some');
    assert!(0 == rd.len(), "expected len 0");
}

#[test]
#[available_gas(20000000)]
fn test_read_u256() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    let u256 { low: low1, high: high1 } = rd.read_u256().unwrap();
    assert!(high1 == 0x0102030405060708090a0b0c0d0e0f10_u128, "wrong value for high1");
    assert!(low1 == 0x1112131415161718191a1b1c1d1e1f20_u128, "wrong value for low1");
}

#[test]
#[available_gas(20000000)]
fn test_read_u256_arr() {
    let ba = test_array_64();
    let mut rd = ba.reader();
    let u256 { low: low1, high: high1 } = rd.read_u256().unwrap();
    assert!(high1 == 0x0102030405060708090a0b0c0d0e0f10_u128, "wrong value for high1");
    assert!(low1 == 0x1112131415161718191a1b1c1d1e1f20_u128, "wrong value for low1");
}

#[test]
#[available_gas(20000000)]
fn test_read_u256_le() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    let u256 { low: low1, high: high1 } = rd.read_u256_le().unwrap();
    assert!(high1 == 0x201f1e1d1c1b1a191817161514131211_u128, "wrong value for high1");
    assert!(low1 == 0x100f0e0d0c0b0a090807060504030201_u128, "wrong value for low1");
}

#[test]
#[available_gas(20000000)]
fn test_read_u256_le_arr() {
    let ba = test_array_64();
    let mut rd = ba.reader();
    let u256 { low: low1, high: high1 } = rd.read_u256_le().unwrap();
    assert!(high1 == 0x201f1e1d1c1b1a191817161514131211_u128, "wrong value for high1");
    assert!(low1 == 0x100f0e0d0c0b0a090807060504030201_u128, "wrong value for low1");
}

#[test]
#[available_gas(20000000)]
fn test_read_u512() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    let u512 { limb0, limb1, limb2, limb3 } = rd.read_u512().unwrap();

    assert!(limb3 == 0x0102030405060708090a0b0c0d0e0f10_u128, "wrong value for limb3");
    assert!(limb2 == 0x1112131415161718191a1b1c1d1e1f20_u128, "wrong value for limb2");
    assert!(limb1 == 0x2122232425262728292a2b2c2d2e2f30_u128, "wrong value for limb1");
    assert!(limb0 == 0x3132333435363738393a3b3c3d3e3f40_u128, "wrong value for limb0");
}

#[test]
#[available_gas(20000000)]
fn test_read_u512_arr() {
    let ba = test_array_64();
    let mut rd = ba.reader();
    let u512 { limb0, limb1, limb2, limb3 } = rd.read_u512().unwrap();

    assert!(limb3 == 0x0102030405060708090a0b0c0d0e0f10_u128, "wrong value for limb3");
    assert!(limb2 == 0x1112131415161718191a1b1c1d1e1f20_u128, "wrong value for limb2");
    assert!(limb1 == 0x2122232425262728292a2b2c2d2e2f30_u128, "wrong value for limb1");
    assert!(limb0 == 0x3132333435363738393a3b3c3d3e3f40_u128, "wrong value for limb0");
}

#[test]
#[available_gas(20000000)]
fn test_read_u512_le() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    let u512 { limb0, limb1, limb2, limb3 } = rd.read_u512_le().unwrap();
    assert!(limb0 == 0x100f0e0d0c0b0a090807060504030201_u128, "wrong value for limb0");
    assert!(limb1 == 0x201f1e1d1c1b1a191817161514131211_u128, "wrong value for limb1");
    assert!(limb2 == 0x302f2e2d2c2b2a292827262524232221_u128, "wrong value for limb2");
    assert!(limb3 == 0x403f3e3d3c3b3a393837363534333231_u128, "wrong value for limb3");
}

#[test]
#[available_gas(20000000)]
fn test_read_u512_le_arr() {
    let ba = test_array_64();
    let mut rd = ba.reader();
    let u512 { limb0, limb1, limb2, limb3 } = rd.read_u512_le().unwrap();
    assert!(limb0 == 0x100f0e0d0c0b0a090807060504030201_u128, "wrong value for limb0");
    assert!(limb1 == 0x201f1e1d1c1b1a191817161514131211_u128, "wrong value for limb1");
    assert!(limb2 == 0x302f2e2d2c2b2a292827262524232221_u128, "wrong value for limb2");
    assert!(limb3 == 0x403f3e3d3c3b3a393837363534333231_u128, "wrong value for limb3");
}

#[test]
#[available_gas(20000000)]
fn test_read_sequence() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    assert!(rd.read_i8() == Option::Some(1), "expected 1");
    assert!(rd.read_i128() == Option::Some(0x02030405060708090a0b0c0d0e0f1011));
    assert!(rd.read_u128() == Option::Some(0x12131415161718191a1b1c1d1e1f2021));
    assert!(rd.read_i64() == Option::Some(0x2223242526272829));
    assert!(rd.read_u128() == Option::Some(0x2a2b2c2d2e2f30313233343536373839));
    assert!(rd.read_u32() == Option::Some(0x3a3b3c3d), "not 0x3a3b3c3d");
    assert!(rd.read_i16() == Option::Some(0x3e3f), "not 0x3e3f");
    assert!(rd.read_u8() == Option::Some(0x40), "not 0x40");
    assert!(rd.read_u8().is_none(), "expected none");
}

#[test]
#[available_gas(20000000)]
fn test_read_sequence_arr() {
    let ba = test_array_64();
    let mut rd = ba.reader();
    assert!(rd.read_i8() == Option::Some(1), "expected 1");
    assert!(rd.read_i128() == Option::Some(0x02030405060708090a0b0c0d0e0f1011));
    assert!(rd.read_u128() == Option::Some(0x12131415161718191a1b1c1d1e1f2021));
    assert!(rd.read_i64() == Option::Some(0x2223242526272829), "not 0x22232425...");
    assert!(rd.read_u128() == Option::Some(0x2a2b2c2d2e2f30313233343536373839));
    assert!(rd.read_u32() == Option::Some(0x3a3b3c3d), "not 0x3a3b3c3d");
    assert!(rd.read_i16() == Option::Some(0x3e3f), "not 0x3e3f");
    assert!(rd.read_u8() == Option::Some(0x40), "not 0x40");
    assert!(rd.read_u8().is_none(), "expected none");
}

#[test]
#[available_gas(20000000)]
fn test_read_sequence_le() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    assert!(rd.read_i8() == Option::Some(1), "expected 1");
    assert!(rd.read_i128_le() == Option::Some(0x11100f0e0d0c0b0a0908070605040302));
    assert!(rd.read_u128_le() == Option::Some(0x21201f1e1d1c1b1a1918171615141312));
    assert!(rd.read_i64_le() == Option::Some(0x2928272625242322), "not 0x29282726...");
    assert!(rd.read_u128_le() == Option::Some(0x393837363534333231302f2e2d2c2b2a));
    assert!(rd.read_u32_le() == Option::Some(0x3d3c3b3a), "not 0x3d3c3b3a");
    assert!(rd.read_i16_le() == Option::Some(0x3f3e), "not 0x3f3e");
    assert!(rd.read_u8() == Option::Some(0x40), "not 0x40");
    assert!(rd.read_u8().is_none(), "expected none");
}

#[test]
#[available_gas(20000000)]
fn test_read_sequence_le_arr() {
    let ba = test_array_64();
    let mut rd = ba.reader();
    assert!(rd.read_i8() == Option::Some(1), "expected 1");
    assert!(rd.read_i128_le() == Option::Some(0x11100f0e0d0c0b0a0908070605040302));
    assert!(rd.read_u128_le() == Option::Some(0x21201f1e1d1c1b1a1918171615141312));
    assert!(rd.read_i64_le() == Option::Some(0x2928272625242322), "not 0x29282726...");
    assert!(rd.read_u128_le() == Option::Some(0x393837363534333231302f2e2d2c2b2a));
    assert!(rd.read_u32_le() == Option::Some(0x3d3c3b3a), "not 0x3d3c3b3a");
    assert!(rd.read_i16_le() == Option::Some(0x3f3e), "not 0x3f3e");
    assert!(rd.read_u8() == Option::Some(0x40), "not 0x40");
    assert!(rd.read_u8().is_none(), "expected none");
}

#[test]
#[available_gas(10000000)]
fn test_clone_byte_array_reader() {
    let ba = test_byte_array_64();
    let mut rd1 = ba.reader();
    let mut rd2 = rd1.clone();
    let a = rd1.read_u128().unwrap();
    assert!(rd1.len() != rd2.len(), "indices equal");
    let b = rd2.read_u128().unwrap();
    assert!(rd1.len() == rd2.len(), "indices not equal");
    assert!(a == b, "copy ByteArrayReader failed");
}

#[test]
#[available_gas(10000000)]
fn test_clone_array_of_bytes_reader() {
    let ba = test_array_64();
    let mut rd1 = ba.reader();
    let mut rd2 = rd1.clone();
    let a = rd1.read_u128().unwrap();
    assert!(rd1.len() != rd2.len(), "indices equal");
    let b = rd2.read_u128().unwrap();
    assert!(rd1.len() == rd2.len(), "indices not equal");
    assert!(a == b, "copy ByteArrayReader failed");
}

#[test]
#[available_gas(10000000)]
fn test_byte_array_reader_equals_array_of_bytes_reader() {
    let mut ba = test_array_64().reader();
    let mut bb = test_byte_array_64().reader();
    assert!(ba.read_u16() == bb.read_u16(), "not equal");
    assert!(ba.read_u16_le() == bb.read_u16_le(), "not equal");
    assert!(ba.read_i16() == bb.read_i16(), "not equal");
    assert!(ba.read_i16_le() == bb.read_i16_le(), "not equal");
    assert!(ba.read_u256() == bb.read_u256(), "not equal");
}

// helpers
pub fn test_byte_array_8() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0x0102030405060708, 8);
    ba1
}

pub fn test_byte_array_16() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0x0102030405060708090a0b0c0d0e0f10, 16);
    ba1
}

pub fn test_byte_array_32() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f, 31);
    ba1.append_word(0x20, 1);
    ba1
}

pub fn test_byte_array_32_neg() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0xfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1, 31);
    ba1.append_word(0xe0, 1);
    ba1
}

pub fn test_byte_array_16_neg() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0xfffffffffffffffffffffffffffffffe, 16);
    ba1
}

pub fn test_byte_array_64() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f, 31);
    ba1.append_word(0x202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e, 31);
    ba1.append_word(0x3f40, 2);
    ba1
}

pub fn test_array_8() -> Array<u8> {
    array![1, 2, 3, 4, 5, 6, 7, 8]
}

pub fn test_array_16() -> Array<u8> {
    array![1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
}

pub fn test_array_32() -> Array<u8> {
    array![
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32
    ]
}

pub fn test_array_32_neg() -> Array<u8> {
    array![
        0xff,
        0xfe,
        0xfd,
        0xfc,
        0xfb,
        0xfa,
        0xf9,
        0xf8,
        0xf7,
        0xf6,
        0xf5,
        0xf4,
        0xf3,
        0xf2,
        0xf1,
        0xf0,
        0xef,
        0xee,
        0xed,
        0xec,
        0xeb,
        0xea,
        0xe9,
        0xe8,
        0xe7,
        0xe6,
        0xe5,
        0xe4,
        0xe3,
        0xe2,
        0xe1,
        0xe0
    ]
}

pub fn test_array_16_neg() -> Array<u8> {
    array![
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xfe
    ]
}

pub fn test_array_64() -> Array<u8> {
    array![
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36,
        37,
        38,
        39,
        40,
        41,
        42,
        43,
        44,
        45,
        46,
        47,
        48,
        49,
        50,
        51,
        52,
        53,
        54,
        55,
        56,
        57,
        58,
        59,
        60,
        61,
        62,
        63,
        64
    ]
}


fn serialized_byte_array_64() -> Array<felt252> {
    array![
        0x40,
        0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f,
        0x202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e,
        0x3f40
    ]
}
