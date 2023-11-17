use alexandria_data_structures::byte_array_ext::{ByteArrayTraitExt};
use integer::u512;

#[test]
#[available_gas(1000000)]
fn test_append_u16() {
    let mut ba: ByteArray = Default::default();
    ba.append_u16(0x0102_u16);
    ba.append_u16(0x0304_u16);
    ba.append_u16(0x0506_u16);
    ba.append_u16(0x0708_u16);
    assert(ba == test_byte_array_8(), 'u16 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_u16_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_u16_le(0x0201_u16);
    ba.append_u16_le(0x0403_u16);
    ba.append_u16_le(0x0605_u16);
    ba.append_u16_le(0x0807_u16);
    assert(ba == test_byte_array_8(), 'u16 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_u32() {
    let mut ba: ByteArray = Default::default();
    ba.append_u32(0x01020304_u32);
    ba.append_u32(0x05060708_u32);
    assert(ba == test_byte_array_8(), 'u32 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_u32_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_u32_le(0x04030201_u32);
    ba.append_u32_le(0x08070605_u32);
    assert(ba == test_byte_array_8(), 'u32 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_u64() {
    let mut ba: ByteArray = Default::default();
    ba.append_u64(0x0102030405060708_u64);
    ba.append_u64(0x090a0b0c0d0e0f10_u64);
    assert(ba == test_byte_array_16(), 'u64 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_u64_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_u64_le(0x0807060504030201_u64);
    ba.append_u64_le(0x100f0e0d0c0b0a09_u64);
    assert(ba == test_byte_array_16(), 'u64 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_u128() {
    let mut ba: ByteArray = Default::default();
    ba.append_u128(0x0102030405060708090a0b0c0d0e0f10_u128);
    ba.append_u128(0x1112131415161718191a1b1c1d1e1f20_u128);
    assert(ba == test_byte_array_32(), 'u128 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_u128_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_u128_le(0x100f0e0d0c0b0a090807060504030201_u128);
    ba.append_u128_le(0x201f1e1d1c1b1a191817161514131211_u128);
    assert(ba == test_byte_array_32(), 'u128 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_u256() {
    let mut ba: ByteArray = Default::default();
    let word = u256 {
        high: 0x0102030405060708090a0b0c0d0e0f10_u128, low: 0x1112131415161718191a1b1c1d1e1f20_u128,
    };
    ba.append_u256(word);
    assert(ba == test_byte_array_32(), 'u256 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_u256_le() {
    let mut ba: ByteArray = Default::default();
    let word = u256 {
        low: 0x100f0e0d0c0b0a090807060504030201_u128, high: 0x201f1e1d1c1b1a191817161514131211_u128,
    };
    ba.append_u256_le(word);
    assert(ba == test_byte_array_32(), 'u256 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_u512() {
    let test64 = u512 {
        limb3: 0x0102030405060708090a0b0c0d0e0f10_u128,
        limb2: 0x1112131415161718191a1b1c1d1e1f20_u128,
        limb1: 0x2122232425262728292a2b2c2d2e2f30_u128,
        limb0: 0x3132333435363738393a3b3c3d3e3f40_u128,
    };

    let mut ba: ByteArray = Default::default();
    ba.append_u512(test64);
    assert(ba == test_byte_array_64(), 'test64 differs');
}

#[test]
#[available_gas(10000000)]
fn test_append_u512_le() {
    let test64 = u512 {
        limb0: 0x100f0e0d0c0b0a090807060504030201_u128,
        limb1: 0x201f1e1d1c1b1a191817161514131211_u128,
        limb2: 0x302f2e2d2c2b2a292827262524232221_u128,
        limb3: 0x403f3e3d3c3b3a393837363534333231_u128,
    };

    let mut ba: ByteArray = Default::default();
    ba.append_u512_le(test64);
    assert(ba == test_byte_array_64(), 'test64 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i8() {
    let mut ba1 = Default::default();
    ba1.append_i8(127_i8);
    let mut ba2 = Default::default();
    ba2.append_byte(0x7f_u8);
    assert(ba1 == ba2, 'i8 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i8_neg() {
    let mut ba1 = Default::default();
    ba1.append_i8(-128_i8);
    let mut ba2 = Default::default();
    ba2.append_byte(0x80_u8);
    assert(ba1 == ba2, 'negative i8 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i16() {
    let mut ba1 = Default::default();
    ba1.append_i16(0x0102_i16);
    ba1.append_i16(0x0304_i16);
    ba1.append_i16(0x0506_i16);
    ba1.append_i16(0x0708_i16);
    assert(ba1 == test_byte_array_8(), 'i16 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i16_le() {
    let mut ba1 = Default::default();
    ba1.append_i16_le(0x0201_i16);
    ba1.append_i16_le(0x0403_i16);
    ba1.append_i16_le(0x0605_i16);
    ba1.append_i16_le(0x0807_i16);
    assert(ba1 == test_byte_array_8(), 'i16 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i16_neg() {
    let mut ba1 = Default::default();
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-2_i16);
    assert(ba1 == test_byte_array_16_neg(), 'negative i16 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i16_le_neg() {
    let mut ba1 = Default::default();
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-257_i16);
    assert(ba1 == test_byte_array_16_neg(), 'negative i16 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i32() {
    let mut ba = Default::default();
    ba.append_i32(0x01020304_i32);
    ba.append_i32(0x05060708_i32);
    assert(ba == test_byte_array_8(), 'i32 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i32_le() {
    let mut ba = Default::default();
    ba.append_i32_le(0x04030201_i32);
    ba.append_i32_le(0x08070605_i32);
    assert(ba == test_byte_array_8(), 'i32 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i32_neg() {
    let mut ba = Default::default();
    ba.append_i32(-1_i32);
    ba.append_i32(-1_i32);
    ba.append_i32(-1_i32);
    ba.append_i32(-2_i32);
    assert(ba == test_byte_array_16_neg(), 'negative i32 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i32_le_neg() {
    let mut ba = Default::default();
    ba.append_i32_le(-1_i32);
    ba.append_i32_le(-1_i32);
    ba.append_i32_le(-1_i32);
    ba.append_i32_le(-16777217_i32);
    assert(ba == test_byte_array_16_neg(), 'negative i32 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i64() {
    let mut ba: ByteArray = Default::default();
    ba.append_i64(0x0102030405060708_i64);
    ba.append_i64(0x090a0b0c0d0e0f10_i64);
    assert(ba == test_byte_array_16(), 'i64 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i64_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_i64_le(0x0807060504030201_i64);
    ba.append_i64_le(0x100f0e0d0c0b0a09_i64);
    assert(ba == test_byte_array_16(), 'i64 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i64_neg() {
    let mut ba: ByteArray = Default::default();
    ba.append_i64(-1_i64);
    ba.append_i64(-2_i64);
    assert(ba == test_byte_array_16_neg(), 'negative i64 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i64_le_neg() {
    let mut ba: ByteArray = Default::default();
    ba.append_i64_le(-1_i64);
    ba.append_i64_le(-72057594037927937_i64);
    assert(ba == test_byte_array_16_neg(), 'negative i64 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i128() {
    let mut ba: ByteArray = Default::default();
    ba.append_i128(0x0102030405060708090a0b0c0d0e0f10_i128);
    ba.append_i128(0x1112131415161718191a1b1c1d1e1f20_i128);
    assert(ba == test_byte_array_32(), 'i128 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i128_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_i128_le(0x100f0e0d0c0b0a090807060504030201_i128);
    ba.append_i128_le(0x201f1e1d1c1b1a191817161514131211_i128);
    assert(ba == test_byte_array_32(), 'i128 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i128_neg() {
    let mut ba: ByteArray = Default::default();
    ba.append_i128(-2_i128);
    assert(ba == test_byte_array_16_neg(), 'negative i128 differs');
}

#[test]
#[available_gas(1000000)]
fn test_append_i128_le_neg() {
    let mut ba: ByteArray = Default::default();
    ba.append_i128_le(-1329227995784915872903807060280344577_i128);
    assert(ba == test_byte_array_16_neg(), 'negative i128 differs');
}

#[test]
#[available_gas(1000000)]
fn test_word_u16() {
    let word = test_byte_array_64().word_u16(62).unwrap();
    assert(word == 0x3f40_u16, 'word u16 differs');
}

#[test]
#[available_gas(1000000)]
fn test_word_u16_le() {
    let word = test_byte_array_64().word_u16_le(62).unwrap();
    assert(word == 0x403f_u16, 'word u16 differs');
}

#[test]
#[available_gas(1000000)]
fn test_word_u16_none() {
    let is_none = test_byte_array_64().word_u16(63).is_none();
    assert(is_none, 'word u16 should be empty');
}

#[test]
#[available_gas(1000000)]
fn test_word_u16_le_none() {
    let is_none = test_byte_array_64().word_u16_le(63).is_none();
    assert(is_none, 'word u16 should be empty');
}

#[test]
#[available_gas(1000000)]
fn test_word_u32() {
    let word = test_byte_array_64().word_u32(60).unwrap();
    assert(word == 0x3d3e3f40_u32, 'word u32 differs');
}

#[test]
#[available_gas(1000000)]
fn test_word_u32_le() {
    let word = test_byte_array_64().word_u32_le(60).unwrap();
    assert(word == 0x403f3e3d_u32, 'word u32 differs');
}

#[test]
#[available_gas(1000000)]
fn test_word_u32_none() {
    let is_none = test_byte_array_64().word_u32(61).is_none();
    assert(is_none, 'word u32 should be empty');
}

#[test]
#[available_gas(1000000)]
fn test_word_u32_le_none() {
    let is_none = test_byte_array_64().word_u32_le(61).is_none();
    assert(is_none, 'word u32 should be empty');
}

#[test]
#[available_gas(1000000)]
fn test_word_u64() {
    let word = test_byte_array_64().word_u64(56).unwrap();
    assert(word == 0x393a3b3c3d3e3f40_u64, 'word u64 differs');
}

#[test]
#[available_gas(1000000)]
fn test_word_u64_le() {
    let word = test_byte_array_64().word_u64_le(56).unwrap();
    assert(word == 0x403f3e3d3c3b3a39_u64, 'word u64 differs');
}

#[test]
#[available_gas(1000000)]
fn test_word_u64_none() {
    let is_none = test_byte_array_64().word_u64(57).is_none();
    assert(is_none, 'word u64 should be empty');
}

#[test]
#[available_gas(1000000)]
fn test_word_u64_le_none() {
    let is_none = test_byte_array_64().word_u64_le(57).is_none();
    assert(is_none, 'word u64 should be empty');
}

#[test]
#[available_gas(2000000)]
fn test_word_u128() {
    let word = test_byte_array_64().word_u128(48).unwrap();
    assert(word == 0x3132333435363738393a3b3c3d3e3f40_u128, 'word u128 differs');
}

#[test]
#[available_gas(2000000)]
fn test_word_u128_le() {
    let word = test_byte_array_64().word_u128_le(48).unwrap();
    assert(word == 0x403f3e3d3c3b3a393837363534333231_u128, 'word u128 differs');
}

#[test]
#[available_gas(2000000)]
fn test_word_u128_none() {
    let is_none = test_byte_array_64().word_u128(49).is_none();
    assert(is_none, 'word u128 should be empty');
}

#[test]
#[available_gas(2000000)]
fn test_word_u128_le_none() {
    let is_none = test_byte_array_64().word_u128_le(49).is_none();
    assert(is_none, 'word u128 should be empty');
}

#[test]
#[available_gas(2000000)]
fn test_reader_helper() {
    let ba = test_byte_array_64();
    let reader = ba.reader();
    assert(reader.data == @ba, 'reader failed');
}


// helpers
fn test_byte_array_8() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0x0102030405060708, 8);
    ba1
}

fn test_byte_array_16() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0x0102030405060708090a0b0c0d0e0f10, 16);
    ba1
}

fn test_byte_array_32() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f, 31);
    ba1.append_word(0x20, 1);
    ba1
}

fn test_byte_array_32_neg() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0xfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1, 31);
    ba1.append_word(0xe0, 1);
    ba1
}

fn test_byte_array_16_neg() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0xfffffffffffffffffffffffffffffffe, 16);
    ba1
}

fn test_byte_array_64() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f, 31);
    ba1.append_word(0x202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e, 31);
    ba1.append_word(0x3f40, 2);
    ba1
}
