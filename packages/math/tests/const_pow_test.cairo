use alexandria_math::const_pow::{pow10, pow10_u256, pow2, pow2_u256};


#[test]
fn pow2_test() {
    assert!(pow2(0) == 1, "2^0 should be 1");
    assert!(pow2(1) == 2, "2^1 should be 2");
    assert!(pow2(2) == 4, "2^2 should be 4");
    assert!(pow2(3) == 8, "2^3 should be 8");
    assert!(pow2(10) == 1024, "2^10 should be 1024");
    assert!(pow2(63) == 0x8000000000000000, "2^63 should be 0x8000000000000000");
    assert!(
        pow2(127) == 0x80000000000000000000000000000000,
        "2^127 should be 0x80000000000000000000000000000000",
    );
}

#[test]
fn pow2_u256_test() {
    assert!(pow2_u256(0) == 1, "2^0 should be 1");
    assert!(pow2_u256(1) == 2, "2^1 should be 2");
    assert!(
        pow2_u256(128) == 340282366920938463463374607431768211456,
        "2^128 should be 340282366920938463463374607431768211456",
    );
    assert!(
        pow2_u256(
            255,
        ) == 57896044618658097711785492504343953926634992332820282019728792003956564819968,
        "2^255 should be 57896044618658097711785492504343953926634992332820282019728792003956564819968",
    );
}

#[test]
fn pow10_test() {
    assert!(pow10(0) == 1, "10^0 should be 1");
    assert!(pow10(1) == 10, "10^1 should be 10");
    assert!(pow10(2) == 100, "10^2 should be 100");
    assert!(pow10(9) == 1000000000, "10^9 should be 1000000000");
    assert!(pow10(18) == 1000000000000000000, "10^18 should be 1000000000000000000");
    assert!(
        pow10(37) == 10000000000000000000000000000000000000,
        "10^37 should be 10000000000000000000000000000000000000",
    );
}

#[test]
fn pow10_u256_test() {
    assert!(pow10_u256(0) == 1, "10^0 should be 1");
    assert!(pow10_u256(1) == 10, "10^1 should be 10");
    assert!(pow10_u256(2) == 100, "10^2 should be 100");
    assert!(
        pow10_u256(38) == 100000000000000000000000000000000000000,
        "10^38 should be 100000000000000000000000000000000000000",
    );
    assert!(
        pow10_u256(
            76,
        ) == 10000000000000000000000000000000000000000000000000000000000000000000000000000_u256,
        "10^76 should be 10000000000000000000000000000000000000000000000000000000000000000000000000000",
    );
}

#[test]
#[should_panic]
fn pow2_out_of_range_test() {
    pow2(128);
}

#[test]
#[should_panic]
fn pow2_u256_out_of_range_test() {
    pow2_u256(256);
}

#[test]
#[should_panic]
fn pow10_out_of_range_test() {
    pow10(38);
}

#[test]
#[should_panic]
fn pow10_u256_out_of_range_test() {
    pow10_u256(77);
}

