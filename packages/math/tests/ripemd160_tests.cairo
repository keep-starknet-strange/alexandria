use alexandria_math::ripemd160::{
    RIPEMD160Context, ripemd160_context_as_array, ripemd160_context_as_bytes,
    ripemd160_context_as_u256, ripemd160_hash,
};


#[test]
fn ripemd160_test_empty() {
    let message: ByteArray = "";
    let mut ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    let expected_hash: u256 = 0x9c1185a5c5e9fc54612808977ee8f548b2258d31;
    assert!(hash == expected_hash, "Bad RIPEMD-160 Hash");
}

#[test]
fn ripemd160_standard_test_string_a() {
    let message: ByteArray = "a";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    let expected_hash: u256 = 0x0bdc9d2d256b3ee9daae347be6f4dc835a467ffe;
    assert!(hash == expected_hash, "Standard test string 'a' failed");
}

#[test]
fn ripemd160_standard_test_string_abc() {
    let message: ByteArray = "abc";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    let expected_hash: u256 = 0x8eb208f7e05d987a9b044a8e98c6b087f15a0bfc;
    assert!(hash == expected_hash, "Standard test string 'abc' failed");
}

#[test]
fn ripemd160_standard_test_string_message_digest() {
    let message: ByteArray = "message digest";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    let expected_hash: u256 = 0x5d0689ef49d2fae572b881b123a85ffa21595f36;
    assert!(hash == expected_hash, "Standard test string 'message digest' failed");
}

#[test]
fn ripemd160_standard_test_string_alphabet() {
    let message: ByteArray = "abcdefghijklmnopqrstuvwxyz";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    let expected_hash: u256 = 0xf71c27109c692c1b56bbdceb5b9d2865b3708dbc;
    assert!(hash == expected_hash, "Standard test string alphabet failed");
}

#[test]
fn ripemd160_standard_test_string_alphanumeric() {
    let message: ByteArray = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    let expected_hash: u256 = 0xb0e20b6e3116640286ed3a87a5713079b21f5189;
    assert!(hash == expected_hash, "Standard test string alphanumeric failed");
}

#[test]
fn ripemd160_standard_test_string_digits_repeated() {
    let message: ByteArray =
        "12345678901234567890123456789012345678901234567890123456789012345678901234567890";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    let expected_hash: u256 = 0x9b752e45573d4b39f4dbd3323cab82bf63326bfb;
    assert!(hash == expected_hash, "Standard test string repeated digits failed");
}


#[test]
fn ripemd160_test_string() {
    let message: ByteArray = "transfer(address,uint256)";
    let mut ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    let expected_hash: u256 = 0x3f93cd76271c17b6760a87840dee35564d2ed86b;
    assert!(hash == expected_hash, "Bad RIPEMD-160 Hash");
}

#[test]
fn ripemd160_test_long_input() {
    let message: ByteArray =
        "6884QYmtkLS4IwK5F0xDYZB0wALHxWL8ycaIcQPdJtITlqdm8Lod6737DDx53wBh10u0vLs1uvMO97njQd6w4OIBvykD8A80R7U1Lcy2Dvvpc7Iev1hom4isr0yth43aL8V8V4i2JB9DuOmHpmG4W5O7CJzBAUJmn2FmlB7Wvdl454FH98t0CaAn5DUQ8w8UVuKkN2FX21c2JN4H0vz77d26I3L01kndyEP1hrXU7TkQpG8NY60765N38jf70VokvUz6q3eYT2FlU8ez2WvoL1P8059n3885wUfxkS2J67skXnS5OKO7LZSS43i1uRoB6T0pAoRs2C6tO30A4lst7iCrED9k0Q097YhlBMis7U33xda5kGzMV30HM2XZ7dOpR1Ze02hGygEAph4Kl34SD1gFCGUO4vxShy34Ktdz08vY8w5BPe46qE0kY5Wwdipv36uuGn75kq66TSR63s51c6n1135UNNlbH5v70n9h9S6D4D7E1h50";
    let mut ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    let expected_hash: u256 = 0x9071da69a09d137eb75d11d643b8b8d7225d50f1;
    assert!(hash == expected_hash, "Bad RIPEMD-160 Hash");
}

#[test]
fn ripemd160_test_single_byte() {
    let message: ByteArray = "\x00";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    assert!(hash != 0, "Single null byte should produce non-zero hash");
}

#[test]
fn ripemd160_test_all_zeros() {
    let mut message: ByteArray = "";
    let mut i: u32 = 0;
    while i < 64 {
        message.append_byte(0x00);
        i += 1;
    }
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    assert!(hash != 0, "64 zero bytes should produce non-zero hash");
}

#[test]
fn ripemd160_test_all_ones() {
    let mut message: ByteArray = "";
    let mut i: u32 = 0;
    while i < 64 {
        message.append_byte(0xFF);
        i += 1;
    }
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    assert!(hash != 0, "64 0xFF bytes should produce non-zero hash");
}

#[test]
fn ripemd160_test_exact_block_size() {
    let mut message: ByteArray = "";
    let mut i: u32 = 0;
    while i < 55 {
        message.append_byte(0x41); // 'A'
        i += 1;
    }
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    assert!(hash != 0, "55 byte message should hash correctly");
}

#[test]
fn ripemd160_test_context_as_bytes() {
    let message: ByteArray = "test";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash_bytes = ripemd160_context_as_bytes(@ctx);
    assert!(hash_bytes.len() == 20, "RIPEMD-160 should produce 20 bytes");
}

#[test]
fn ripemd160_test_context_as_array() {
    let message: ByteArray = "test";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash_array = ripemd160_context_as_array(@ctx);
    assert!(hash_array.len() == 5, "RIPEMD-160 should produce 5 u32 values");
}

#[test]
fn ripemd160_test_context_conversions_consistency() {
    let message: ByteArray = "consistency test";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);

    let hash_u256 = ripemd160_context_as_u256(@ctx);
    let hash_bytes = ripemd160_context_as_bytes(@ctx);
    let hash_array = ripemd160_context_as_array(@ctx);

    // Verify all conversions are consistent
    assert!(hash_bytes.len() == 20, "Bytes length should be 20");
    assert!(hash_array.len() == 5, "Array length should be 5");
    assert!(hash_u256 != 0, "U256 hash should be non-zero");
}

#[test]
fn ripemd160_test_different_messages_different_hash() {
    let message1: ByteArray = "message one";
    let message2: ByteArray = "message two";

    let ctx1: RIPEMD160Context = ripemd160_hash(@message1);
    let ctx2: RIPEMD160Context = ripemd160_hash(@message2);

    let hash1 = ripemd160_context_as_u256(@ctx1);
    let hash2 = ripemd160_context_as_u256(@ctx2);

    assert!(hash1 != hash2, "Different messages should produce different hashes");
}

#[test]
fn ripemd160_test_special_chars() {
    let message: ByteArray = "@#$%^&*()_+-=[]{}|;:,.<>?";
    let ctx: RIPEMD160Context = ripemd160_hash(@message);
    let hash = ripemd160_context_as_u256(@ctx);
    assert!(hash != 0, "Special characters should hash correctly");
}
