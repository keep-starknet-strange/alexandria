use alexandria_encoding::reversible::{ReversibleBits, ReversibleBytes};
use core::integer::u512;

#[test]
#[available_gas(1000000)]
fn test_reverse_bytes_u8() {
    let t: u8 = 0b10111010;
    let rev = t.reverse_bytes();
    assert!(t == rev, "not equal");
    assert!(t == rev.reverse_bytes(), "not equal");
}

#[test]
#[available_gas(1000000)]
fn test_reverse_bytes_u16() {
    let t: u16 = 0x1122;
    let rev = t.reverse_bytes();
    assert!(rev == 0x2211, "not equal");
    assert!(rev.reverse_bytes() == t, "not equal");
}

#[test]
#[available_gas(1000000)]
fn test_reverse_bytes_u32() {
    let t: u32 = 0x11223344;
    let rev = t.reverse_bytes();
    assert!(rev == 0x44332211, "not equal");
    assert!(rev.reverse_bytes() == t, "not equal");
}

#[test]
#[available_gas(1000000)]
fn test_reverse_bytes_u64() {
    let t: u64 = 0x1122334455667788;
    let rev = t.reverse_bytes();
    assert!(rev == 0x8877665544332211, "not equal");
    assert!(rev.reverse_bytes() == t, "not equal");
}

#[test]
#[available_gas(1000000)]
fn test_reverse_bytes_u128() {
    let t: u128 = 0x112233445566778899aabbccddeeff00;
    let rev = t.reverse_bytes();
    assert!(rev == 0x00ffeeddccbbaa998877665544332211, "not equal");
    assert!(rev.reverse_bytes() == t, "not equal");
}

#[test]
#[available_gas(10000000)]
fn test_reverse_bytes_u256() {
    let t1: u128 = 0x101112131415161718191a1b1c1d1e1f;
    let t2: u128 = 0x202122232425262728292a2b2c2d2e2f;
    let t = u256 { low: t1, high: t2 };
    let rev = t.reverse_bytes();
    assert!(rev == u256 { low: t2.reverse_bytes(), high: t1.reverse_bytes() });
    assert!(rev.reverse_bytes() == t, "not equal");
}

#[test]
#[available_gas(10000000)]
fn test_reverse_bytes_u512() {
    let t0: u128 = 0x101112131415161718191a1b1c1d1e1f;
    let t1: u128 = 0x202122232425262728292a2b2c2d2e2f;
    let t2: u128 = 0x303132333435363738393a3b3c3d3e3f;
    let t3: u128 = 0x404142434445464748494a4b4c4d4e4f;
    let t = u512 { limb0: t0, limb1: t1, limb2: t2, limb3: t3 };
    let t_rev = u512 {
        limb0: t3.reverse_bytes(),
        limb1: t2.reverse_bytes(),
        limb2: t1.reverse_bytes(),
        limb3: t0.reverse_bytes()
    };
    let rev = t.reverse_bytes();
    assert!(rev == t_rev, "not equal");
    assert!(rev.reverse_bytes() == t, "not equal");
}

#[test]
#[available_gas(10000000)]
fn test_reverse_bytes_bytes31() {
    let t1: u128 = 0x101112131415161718191a1b1c1d1e1f;
    let t2: u128 = 0x202122232425262728292a2b2c2d2e;
    let felt: felt252 = u256 { low: t1, high: t2 }.try_into().unwrap();
    let t: bytes31 = felt.try_into().unwrap();
    let t_rev_u256 = u256 {
        low: 0x2e2d2c2b2a292827262524232221201f, high: 0x1e1d1c1b1a19181716151413121110,
    };
    let t_rev_felt: felt252 = t_rev_u256.try_into().unwrap();
    let t_rev: bytes31 = t_rev_felt.try_into().unwrap();
    let rev = t.reverse_bytes();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bytes() == t, "not equal");
}

#[test]
#[available_gas(10000000)]
fn test_reverse_bytes_array() {
    let t: Array<u16> = array![0x1122, 0x3344, 0x5566, 0x7788, 0x99aa, 0xbbcc, 0xddee];
    let t_rev: Array<u16> = array![0xeedd, 0xccbb, 0xaa99, 0x8877, 0x6655, 0x4433, 0x2211];
    let rev = t.reverse_bytes();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bytes() == t, "not equal");
}

#[test]
#[available_gas(1000000)]
fn test_reverse_bits_u8() {
    let t: u8 = 0b10111010;
    let t_rev: u8 = 0b01011101;
    let rev = t.reverse_bits();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bits() == t, "not equal");
}

#[test]
#[available_gas(1000000)]
fn test_reverse_bits_u16() {
    let t: u16 = 0x11aa;
    let t_rev: u16 = 0x5588;
    let rev = t.reverse_bits();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bits() == t, "not equal");
}

#[test]
#[available_gas(10000000)]
fn test_reverse_bits_u32() {
    let t: u32 = 0x1111aaaa;
    let t_rev: u32 = 0x55558888;
    let rev = t.reverse_bits();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bits() == t, "not equal");
}

#[test]
#[available_gas(10000000)]
fn test_reverse_bits_u64() {
    let t: u64 = 0x11111111aaaaaaaa;
    let t_rev: u64 = 0x5555555588888888;
    let rev = t.reverse_bits();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bits() == t, "not equal");
}

#[test]
#[available_gas(10000000)]
fn test_reverse_bits_u128() {
    let t: u128 = 0x1111111111111111aaaaaaaaaaaaaaaa;
    let t_rev: u128 = 0x55555555555555558888888888888888;
    let rev = t.reverse_bits();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bits() == t, "not equal");
}

#[test]
#[available_gas(100000000)]
fn test_reverse_bits_u256() {
    let t1: u128 = 0x1111111111111111aaaaaaaaaaaaaaaa;
    let t2: u128 = 0xcccccccccccccccc7777777777777777;
    let t: u256 = u256 { low: t1, high: t2 };
    let t_rev: u256 = u256 {
        low: 0xeeeeeeeeeeeeeeee3333333333333333, high: 0x55555555555555558888888888888888,
    };
    let rev = t.reverse_bits();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bits() == t, "not equal");
}

#[test]
#[available_gas(100000000)]
fn test_reverse_bits_u512() {
    let t0: u128 = 0x1111111111111111aaaaaaaaaaaaaaaa;
    let t1: u128 = 0xcccccccccccccccc7777777777777777;
    let t2: u128 = 0x33333333333333334444444444444444;
    let t3: u128 = 0xaaaaaaaaaaaaaaaaeeeeeeeeeeeeeeee;
    let t: u512 = u512 { limb0: t0, limb1: t1, limb2: t2, limb3: t3 };
    let t_rev = u512 {
        limb0: t3.reverse_bits(),
        limb1: t2.reverse_bits(),
        limb2: t1.reverse_bits(),
        limb3: t0.reverse_bits(),
    };
    let rev = t.reverse_bits();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bits() == t, "not equal");
}

#[test]
#[available_gas(100000000)]
fn test_reverse_bits_bytes31() {
    let t1: u128 = 0x123457bcde123457bcde123457bcde12;
    let t2: u128 = 0x84c2aed3b784c2aed3b784c2aed3b7;
    let t_u256: u256 = u256 { low: t1, high: t2 };
    let felt: felt252 = t_u256.try_into().unwrap();
    let t: bytes31 = felt.try_into().unwrap();
    let t_rev_u256: u256 = u256 {
        low: 0xedcb754321edcb754321edcb75432148, high: 0x7b3dea2c487b3dea2c487b3dea2c48,
    };
    let t_rev_felt: felt252 = t_rev_u256.try_into().unwrap();
    let t_rev: bytes31 = t_rev_felt.try_into().unwrap();
    let rev = t.reverse_bits();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bits() == t, "not equal");
}

#[test]
#[available_gas(100000000)]
fn test_reverse_bits_array() {
    let t: Array<u16> = array![0x1234, 0x57bc, 0xde84, 0xc2ae, 0xd3b7];
    let t_rev: Array<u16> = array![0xedcb, 0x7543, 0x217b, 0x3dea, 0x2c48];
    let rev = t.reverse_bits();
    assert!(rev == t_rev, "not equal rev");
    assert!(rev.reverse_bits() == t, "not equal");
}
