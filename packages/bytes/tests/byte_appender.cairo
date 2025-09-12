//use alexandria_bytes::byte_appender::ByteAppender;
use alexandria_bytes::byte_array_ext::ByteArrayAppenderImpl;

// Helper functions for testing
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
fn test_array_8() -> Array<u8> {
    array![1, 2, 3, 4, 5, 6, 7, 8]
}
fn test_array_16() -> Array<u8> {
    array![1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
}
fn test_array_32() -> Array<u8> {
    array![
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
        26, 27, 28, 29, 30, 31, 32,
    ]
}
fn test_array_16_neg() -> Array<u8> {
    array![
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
        0xfe,
    ]
}
fn test_array_64() -> Array<u8> {
    array![
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
        26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
        49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64,
    ]
}
use core::integer::u512;

#[test]
fn test_append_u16() {
    let mut ba: ByteArray = Default::default();
    ba.append_u16(0x0102_u16);
    ba.append_u16(0x0304_u16);
    ba.append_u16(0x0506_u16);
    ba.append_u16(0x0708_u16);
    let _expected: ByteArray = test_byte_array_8();
    assert!(ba == test_byte_array_8());
}

#[test]
fn test_append_u16_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_u16(0x0102_u16);
    ba.append_u16(0x0304_u16);
    ba.append_u16(0x0506_u16);
    ba.append_u16(0x0708_u16);
    let _expected: Array<u8> = test_array_8();
    assert!(ba == test_array_8());
}

#[test]
fn test_append_u16_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_u16_le(0x0201_u16);
    ba.append_u16_le(0x0403_u16);
    ba.append_u16_le(0x0605_u16);
    ba.append_u16_le(0x0807_u16);
    let _expected: ByteArray = test_byte_array_8();
    assert!(ba == test_byte_array_8());
}

#[test]
fn test_append_u16_le_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_u16_le(0x0201_u16);
    ba.append_u16_le(0x0403_u16);
    ba.append_u16_le(0x0605_u16);
    ba.append_u16_le(0x0807_u16);
    let _expected: Array<u8> = test_array_8();
    assert!(ba == test_array_8());
}

#[test]
fn test_append_u32() {
    let mut ba: ByteArray = Default::default();
    ba.append_u32(0x01020304_u32);
    ba.append_u32(0x05060708_u32);
    let _expected: ByteArray = test_byte_array_8();
    assert!(ba == test_byte_array_8());
}

#[test]
fn test_append_u32_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_u32(0x01020304_u32);
    ba.append_u32(0x05060708_u32);
    let _expected: Array<u8> = test_array_8();
    assert!(ba == test_array_8());
}

#[test]
fn test_append_u32_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_u32_le(0x04030201_u32);
    ba.append_u32_le(0x08070605_u32);
    let _expected: ByteArray = test_byte_array_8();
    assert!(ba == test_byte_array_8());
}

#[test]
fn test_append_u32_le_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_u32_le(0x04030201_u32);
    ba.append_u32_le(0x08070605_u32);
    let _expected: Array<u8> = test_array_8();
    assert!(ba == test_array_8());
}

#[test]
fn test_append_u64() {
    let mut ba: ByteArray = Default::default();
    ba.append_u64(0x0102030405060708_u64);
    ba.append_u64(0x090a0b0c0d0e0f10_u64);
    let _expected: ByteArray = test_byte_array_16();
    assert!(ba == test_byte_array_16());
}

#[test]
fn test_append_u64_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_u64(0x0102030405060708_u64);
    ba.append_u64(0x090a0b0c0d0e0f10_u64);
    let _expected: Array<u8> = test_array_16();
    assert!(ba == test_array_16());
}

#[test]
fn test_append_u64_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_u64_le(0x0807060504030201_u64);
    ba.append_u64_le(0x100f0e0d0c0b0a09_u64);
    let _expected: ByteArray = test_byte_array_16();
    assert!(ba == test_byte_array_16());
}

#[test]
fn test_append_u64_le_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_u64_le(0x0807060504030201_u64);
    ba.append_u64_le(0x100f0e0d0c0b0a09_u64);
    let _expected: Array<u8> = test_array_16();
    assert!(ba == test_array_16());
}

#[test]
fn test_append_u128() {
    let mut ba: ByteArray = Default::default();
    ba.append_u128(0x0102030405060708090a0b0c0d0e0f10_u128);
    ba.append_u128(0x1112131415161718191a1b1c1d1e1f20_u128);
    let _expected: ByteArray = test_byte_array_32();
    assert!(ba == test_byte_array_32());
}

#[test]
fn test_append_u128_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_u128(0x0102030405060708090a0b0c0d0e0f10_u128);
    ba.append_u128(0x1112131415161718191a1b1c1d1e1f20_u128);
    let _expected: Array<u8> = test_array_32();
    assert!(ba == test_array_32());
}

#[test]
fn test_append_u128_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_u128_le(0x100f0e0d0c0b0a090807060504030201_u128);
    ba.append_u128_le(0x201f1e1d1c1b1a191817161514131211_u128);
    let _expected: ByteArray = test_byte_array_32();
    assert!(ba == test_byte_array_32());
}

#[test]
fn test_append_u128_le_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_u128_le(0x100f0e0d0c0b0a090807060504030201_u128);
    ba.append_u128_le(0x201f1e1d1c1b1a191817161514131211_u128);
    let _expected: Array<u8> = test_array_32();
    assert!(ba == test_array_32());
}

#[test]
fn test_append_u256() {
    let mut ba: ByteArray = Default::default();
    let word = u256 {
        high: 0x0102030405060708090a0b0c0d0e0f10_u128, low: 0x1112131415161718191a1b1c1d1e1f20_u128,
    };
    ba.append_u256(word);
    let _expected: ByteArray = test_byte_array_32();
    assert!(ba == test_byte_array_32());
}

#[test]
fn test_append_u256_arr() {
    let mut ba: Array<u8> = array![];
    let word = u256 {
        high: 0x0102030405060708090a0b0c0d0e0f10_u128, low: 0x1112131415161718191a1b1c1d1e1f20_u128,
    };
    ba.append_u256(word);
    assert!(ba == test_array_32());
}

#[test]
fn test_append_u256_le() {
    let mut ba: ByteArray = Default::default();
    let word = u256 {
        low: 0x100f0e0d0c0b0a090807060504030201_u128, high: 0x201f1e1d1c1b1a191817161514131211_u128,
    };
    ba.append_u256_le(word);
    let _expected: ByteArray = test_byte_array_32();
    assert!(ba == test_byte_array_32());
}

#[test]
fn test_append_u256_le_arr() {
    let mut ba: Array<u8> = array![];
    let word = u256 {
        low: 0x100f0e0d0c0b0a090807060504030201_u128, high: 0x201f1e1d1c1b1a191817161514131211_u128,
    };
    ba.append_u256_le(word);
    let _expected: Array<u8> = test_array_32();
    assert!(ba == test_array_32());
}

#[test]
fn test_append_u512() {
    let test64 = u512 {
        limb3: 0x0102030405060708090a0b0c0d0e0f10_u128,
        limb2: 0x1112131415161718191a1b1c1d1e1f20_u128,
        limb1: 0x2122232425262728292a2b2c2d2e2f30_u128,
        limb0: 0x3132333435363738393a3b3c3d3e3f40_u128,
    };

    let mut ba: ByteArray = Default::default();
    ba.append_u512(test64);
    let _expected: ByteArray = test_byte_array_64();
    assert!(ba == test_byte_array_64());
}

#[test]
fn test_append_u512_arr() {
    let test64 = u512 {
        limb3: 0x0102030405060708090a0b0c0d0e0f10_u128,
        limb2: 0x1112131415161718191a1b1c1d1e1f20_u128,
        limb1: 0x2122232425262728292a2b2c2d2e2f30_u128,
        limb0: 0x3132333435363738393a3b3c3d3e3f40_u128,
    };

    let mut ba: Array<u8> = array![];
    ba.append_u512(test64);
    let _expected: Array<u8> = test_array_64();
    assert!(ba == test_array_64());
}

#[test]
fn test_append_u512_le() {
    let test64 = u512 {
        limb0: 0x100f0e0d0c0b0a090807060504030201_u128,
        limb1: 0x201f1e1d1c1b1a191817161514131211_u128,
        limb2: 0x302f2e2d2c2b2a292827262524232221_u128,
        limb3: 0x403f3e3d3c3b3a393837363534333231_u128,
    };

    let mut ba: ByteArray = Default::default();
    ba.append_u512_le(test64);
    let _expected: ByteArray = test_byte_array_64();
    assert!(ba == test_byte_array_64());
}

#[test]
fn test_append_u512_le_arr() {
    let test64 = u512 {
        limb0: 0x100f0e0d0c0b0a090807060504030201_u128,
        limb1: 0x201f1e1d1c1b1a191817161514131211_u128,
        limb2: 0x302f2e2d2c2b2a292827262524232221_u128,
        limb3: 0x403f3e3d3c3b3a393837363534333231_u128,
    };

    let mut ba: Array<u8> = array![];
    ba.append_u512_le(test64);
    let _expected: Array<u8> = test_array_64();
    assert!(ba == test_array_64());
}

#[test]
fn test_append_i8() {
    let mut ba1: ByteArray = Default::default();
    ba1.append_i8(127_i8);
    let mut ba2: ByteArray = Default::default();
    ba2.append_byte(0x7f_u8);
    assert!(ba1 == ba2);
}

#[test]
fn test_append_i8_arr() {
    let mut ba1: Array<u8> = array![];
    ba1.append_i8(127_i8);
    let mut ba2: Array<u8> = array![];
    ba2.append(0x7f_u8);
    assert!(ba1 == ba2);
}

#[test]
fn test_append_i8_neg() {
    let mut ba1: ByteArray = Default::default();
    ba1.append_i8(-128_i8);
    let mut ba2: ByteArray = Default::default();
    ba2.append_byte(0x80_u8);
    assert!(ba1 == ba2);
}

#[test]
fn test_append_i8_neg_arr() {
    let mut ba1: Array<u8> = array![];
    ba1.append_i8(-128_i8);
    let mut ba2: Array<u8> = array![];
    ba2.append(0x80_u8);
    assert!(ba1 == ba2);
}

#[test]
fn test_append_i16() {
    let mut ba1: ByteArray = Default::default();
    ba1.append_i16(0x0102_i16);
    ba1.append_i16(0x0304_i16);
    ba1.append_i16(0x0506_i16);
    ba1.append_i16(0x0708_i16);
    let _expected: ByteArray = test_byte_array_8();
    assert!(ba1 == test_byte_array_8());
}

#[test]
fn test_append_i16_arr() {
    let mut ba1: Array<u8> = array![];
    ba1.append_i16(0x0102_i16);
    ba1.append_i16(0x0304_i16);
    ba1.append_i16(0x0506_i16);
    ba1.append_i16(0x0708_i16);
    let _expected: Array<u8> = test_array_8();
    assert!(ba1 == test_array_8());
}

#[test]
fn test_append_i16_le() {
    let mut ba1: ByteArray = Default::default();
    ba1.append_i16_le(0x0201_i16);
    ba1.append_i16_le(0x0403_i16);
    ba1.append_i16_le(0x0605_i16);
    ba1.append_i16_le(0x0807_i16);
    let _expected: ByteArray = test_byte_array_8();
    assert!(ba1 == test_byte_array_8());
}

#[test]
fn test_append_i16_le_arr() {
    let mut ba1: Array<u8> = array![];
    ba1.append_i16_le(0x0201_i16);
    ba1.append_i16_le(0x0403_i16);
    ba1.append_i16_le(0x0605_i16);
    ba1.append_i16_le(0x0807_i16);
    let _expected: Array<u8> = test_array_8();
    assert!(ba1 == test_array_8());
}

#[test]
fn test_append_i16_neg() {
    let mut ba1: ByteArray = Default::default();
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-2_i16);
    let _expected: ByteArray = test_byte_array_16_neg();
    assert!(ba1 == test_byte_array_16_neg());
}

#[test]
fn test_append_i16_neg_arr() {
    let mut ba1: Array<u8> = array![];
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-1_i16);
    ba1.append_i16(-2_i16);
    let _expected: Array<u8> = test_array_16_neg();
    assert!(ba1 == test_array_16_neg());
}

#[test]
fn test_append_i16_le_neg() {
    let mut ba1: ByteArray = Default::default();
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-257_i16);
    let _expected: ByteArray = test_byte_array_16_neg();
    assert!(ba1 == test_byte_array_16_neg());
}

#[test]
fn test_append_i16_le_neg_arr() {
    let mut ba1: Array<u8> = array![];
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-1_i16);
    ba1.append_i16_le(-257_i16);
    let _expected: Array<u8> = test_array_16_neg();
    assert!(ba1 == test_array_16_neg());
}

#[test]
fn test_append_i32() {
    let mut ba: ByteArray = Default::default();
    ba.append_i32(0x01020304_i32);
    ba.append_i32(0x05060708_i32);
    let _expected: ByteArray = test_byte_array_8();
    assert!(ba == test_byte_array_8());
}

#[test]
fn test_append_i32_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i32(0x01020304_i32);
    ba.append_i32(0x05060708_i32);
    let _expected: Array<u8> = test_array_8();
    assert!(ba == test_array_8());
}

#[test]
fn test_append_i32_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_i32_le(0x04030201_i32);
    ba.append_i32_le(0x08070605_i32);
    let _expected: ByteArray = test_byte_array_8();
    assert!(ba == test_byte_array_8());
}

#[test]
fn test_append_i32_le_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i32_le(0x04030201_i32);
    ba.append_i32_le(0x08070605_i32);
    let _expected: Array<u8> = test_array_8();
    assert!(ba == test_array_8());
}

#[test]
fn test_append_i32_neg() {
    let mut ba: ByteArray = Default::default();
    ba.append_i32(-1_i32);
    ba.append_i32(-1_i32);
    ba.append_i32(-1_i32);
    ba.append_i32(-2_i32);
    let _expected: ByteArray = test_byte_array_16_neg();
    assert!(ba == test_byte_array_16_neg());
}
#[test]
fn test_append_i32_neg_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i32(-1_i32);
    ba.append_i32(-1_i32);
    ba.append_i32(-1_i32);
    ba.append_i32(-2_i32);
    let _expected: Array<u8> = test_array_16_neg();
    assert!(ba == test_array_16_neg());
}

#[test]
fn test_append_i32_le_neg() {
    let mut ba: ByteArray = Default::default();
    ba.append_i32_le(-1_i32);
    ba.append_i32_le(-1_i32);
    ba.append_i32_le(-1_i32);
    ba.append_i32_le(-16777217_i32);
    let _expected: ByteArray = test_byte_array_16_neg();
    assert!(ba == test_byte_array_16_neg());
}

#[test]
fn test_append_i32_le_neg_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i32_le(-1_i32);
    ba.append_i32_le(-1_i32);
    ba.append_i32_le(-1_i32);
    ba.append_i32_le(-16777217_i32);
    let _expected: Array<u8> = test_array_16_neg();
    assert!(ba == test_array_16_neg());
}

#[test]
fn test_append_i64() {
    let mut ba: ByteArray = Default::default();
    ba.append_i64(0x0102030405060708_i64);
    ba.append_i64(0x090a0b0c0d0e0f10_i64);
    let _expected: ByteArray = test_byte_array_16();
    assert!(ba == test_byte_array_16());
}

#[test]
fn test_append_i64_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i64(0x0102030405060708_i64);
    ba.append_i64(0x090a0b0c0d0e0f10_i64);
    let _expected: Array<u8> = test_array_16();
    assert!(ba == test_array_16());
}

#[test]
fn test_append_i64_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_i64_le(0x0807060504030201_i64);
    ba.append_i64_le(0x100f0e0d0c0b0a09_i64);
    let _expected: ByteArray = test_byte_array_16();
    assert!(ba == test_byte_array_16());
}

#[test]
fn test_append_i64_le_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i64_le(0x0807060504030201_i64);
    ba.append_i64_le(0x100f0e0d0c0b0a09_i64);
    let _expected: Array<u8> = test_array_16();
    assert!(ba == test_array_16());
}

#[test]
fn test_append_i64_neg() {
    let mut ba: ByteArray = Default::default();
    ba.append_i64(-1_i64);
    ba.append_i64(-2_i64);
    let _expected: ByteArray = test_byte_array_16_neg();
    assert!(ba == test_byte_array_16_neg());
}

#[test]
fn test_append_i64_neg_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i64(-1_i64);
    ba.append_i64(-2_i64);
    let _expected: Array<u8> = test_array_16_neg();
    assert!(ba == test_array_16_neg());
}

#[test]
fn test_append_i64_le_neg() {
    let mut ba: ByteArray = Default::default();
    ba.append_i64_le(-1_i64);
    ba.append_i64_le(-72057594037927937_i64);
    let _expected: ByteArray = test_byte_array_16_neg();
    assert!(ba == test_byte_array_16_neg());
}

#[test]
fn test_append_i64_le_neg_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i64_le(-1_i64);
    ba.append_i64_le(-72057594037927937_i64);
    let _expected: Array<u8> = test_array_16_neg();
    assert!(ba == test_array_16_neg());
}

#[test]
fn test_append_i128() {
    let mut ba: ByteArray = Default::default();
    ba.append_i128(0x0102030405060708090a0b0c0d0e0f10_i128);
    ba.append_i128(0x1112131415161718191a1b1c1d1e1f20_i128);
    let _expected: ByteArray = test_byte_array_32();
    assert!(ba == test_byte_array_32());
}

#[test]
fn test_append_i128_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i128(0x0102030405060708090a0b0c0d0e0f10_i128);
    ba.append_i128(0x1112131415161718191a1b1c1d1e1f20_i128);
    let _expected: Array<u8> = test_array_32();
    assert!(ba == test_array_32());
}

#[test]
fn test_append_i128_le() {
    let mut ba: ByteArray = Default::default();
    ba.append_i128_le(0x100f0e0d0c0b0a090807060504030201_i128);
    ba.append_i128_le(0x201f1e1d1c1b1a191817161514131211_i128);
    let _expected: ByteArray = test_byte_array_32();
    assert!(ba == test_byte_array_32());
}

#[test]
fn test_append_i128_le_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i128_le(0x100f0e0d0c0b0a090807060504030201_i128);
    ba.append_i128_le(0x201f1e1d1c1b1a191817161514131211_i128);
    let _expected: Array<u8> = test_array_32();
    assert!(ba == test_array_32());
}

#[test]
fn test_append_i128_neg() {
    let mut ba: ByteArray = Default::default();
    ba.append_i128(-2_i128);
    let _expected: ByteArray = test_byte_array_16_neg();
    assert!(ba == test_byte_array_16_neg());
}

#[test]
fn test_append_i128_neg_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i128(-2_i128);
    let _expected: Array<u8> = test_array_16_neg();
    assert!(ba == test_array_16_neg());
}

#[test]
fn test_append_i128_le_neg() {
    let mut ba: ByteArray = Default::default();
    ba.append_i128_le(-1329227995784915872903807060280344577_i128);
    let _expected: ByteArray = test_byte_array_16_neg();
    assert!(ba == test_byte_array_16_neg());
}

#[test]
fn test_append_i128_le_neg_arr() {
    let mut ba: Array<u8> = array![];
    ba.append_i128_le(-1329227995784915872903807060280344577_i128);
    let _expected: Array<u8> = test_array_16_neg();
    assert!(ba == test_array_16_neg());
}
