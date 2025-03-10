use alexandria_data_structures::bit_array::{
    BitArray, BitArrayTrait, one_shift_left_bytes_felt252, shift_bit,
};
use core::integer::u512;
use core::num::traits::Bounded;

#[test]
#[available_gas(30000000)]
fn test_append_bit() {
    let mut ba: BitArray = Default::default();
    let mut c = 250;
    while (c != 0) {
        ba.append_bit(true);
        ba.append_bit(false);
        c -= 1;
    }
    let val: bytes31 = 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        .try_into()
        .unwrap();
    let expected: Array<bytes31> = array![val, val];
    assert_eq!(ba.current(), 0xa * one_shift_left_bytes_felt252(30) * shift_bit(4).into());
    assert!(ba.data() == expected, "illegal array");
}

#[test]
#[available_gas(20000000)]
fn test_at() {
    let ba = sample_bit_array();
    let mut index: usize = 0;
    loop {
        if index == 8 * 16 - 1 {
            // last value
            assert!(ba[index] == false, "expected false");
            break;
        }
        assert!(ba.at(index).unwrap() == true, "expected true");
        index += 1;
    };
}

#[test]
#[available_gas(2000000)]
fn test_at_none() {
    let ba = sample_bit_array();
    assert!(ba.at(8 * 16).is_none(), "expected none");
}

#[test]
#[available_gas(20000000)]
fn test_index() {
    let ba = sample_bit_array();
    assert!(ba[0] == true, "expected true");
    assert!(ba[8 * 16 - 1] == false, "expected false");
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('Index out of bounds',))]
fn test_index_fail() {
    let ba = sample_bit_array();
    ba[8 * 16];
}

#[test]
#[available_gas(2000000)]
fn test_len() {
    let mut ba = sample_bit_array();
    let expected = 8 * 16;
    assert!(ba.len() == expected, "expected len 8 * 16");
    ba.append_bit(true);
    assert!(ba.len() == expected + 1, "expected len 8 * 16 + 1");
    let _ = ba.pop_front();
    assert!(ba.len() == expected, "expected len 8 * 16");
}

#[test]
#[available_gas(2000000)]
fn test_pop_front() {
    let mut ba = sample_bit_array();
    assert!(ba.pop_front() == Option::Some(true), "expected (some) true");
}

#[test]
#[available_gas(2000000)]
fn test_pop_front_empty() {
    let mut ba: BitArray = Default::default();
    assert!(ba.pop_front() == Option::None, "expected none");
}

#[test]
#[available_gas(20000000)]
fn test_read_word_be() {
    let mut ba = sample_bit_array();
    assert_eq!(ba.read_word_be(length: 128).unwrap(), Bounded::<u128>::MAX.into() - 1);
}

#[test]
#[available_gas(20000000)]
fn test_read_word_le() {
    let mut ba = sample_bit_array();
    assert_eq!(ba.read_word_le(length: 128).unwrap(), 0x7fffffffffffffffffffffffffffffff);
}

#[test]
#[available_gas(40000000)]
fn test_read_word_be_u256() {
    let mut ba = sample_bit_array();
    let low = 0x101112131415161718191a1b1c1d1e1f_u128;
    ba.write_word_be(low.into(), 128);
    let high = 0xfffffffffffffffffffffffffffffffe_u128;
    assert!(ba.read_word_be_u256(length: 256).unwrap() == u256 { low, high });
}

#[test]
#[available_gas(40000000)]
fn test_read_word_le_u256() {
    let mut ba = sample_bit_array();
    let low = 0x7fffffffffffffffffffffffffffffff_u128;
    let high = 0x101112131415161718191a1b1c1d1e1f_u128;
    ba.write_word_le(high.into(), 128);
    assert!(ba.read_word_le_u256(length: 256).unwrap() == u256 { low, high });
}

#[test]
#[available_gas(70000000)]
fn test_read_word_be_u512() {
    let mut ba = sample_bit_array();
    let limb0 = 0x101112131415161718191a1b1c1d1e1f_u128;
    let limb1 = 0x202122232425262728292a2b2c2d2e2f_u128;
    let limb2 = 0x303132333435363738393a3b3c3d3e3f_u128;
    ba.write_word_be(limb2.into(), 128);
    ba.write_word_be(limb1.into(), 128);
    ba.write_word_be(limb0.into(), 128);
    let limb3 = 0xfffffffffffffffffffffffffffffffe_u128;
    assert!(ba.read_word_be_u512(length: 512).unwrap() == u512 { limb0, limb1, limb2, limb3 });
}

#[test]
#[available_gas(70000000)]
fn test_read_word_le_u512() {
    let mut ba = sample_bit_array();
    let limb1 = 0x101112131415161718191a1b1c1d1e1f_u128;
    let limb2 = 0x202122232425262728292a2b2c2d2e2f_u128;
    let limb3 = 0x303132333435363738393a3b3c3d3e3f_u128;
    ba.write_word_le(limb1.into(), 128);
    ba.write_word_le(limb2.into(), 128);
    ba.write_word_le(limb3.into(), 128);
    let limb0 = 0x7fffffffffffffffffffffffffffffff_u128;
    assert!(ba.read_word_le_u512(length: 512).unwrap() == u512 { limb0, limb1, limb2, limb3 });
}

#[test]
#[available_gas(20000000)]
fn test_read_word_be_half() {
    let mut ba = sample_bit_array();
    assert!(ba.read_word_be(64).unwrap() == 0xffffffffffffffff, "unexpected result");
    assert!(ba.read_word_be(64).unwrap() == 0xfffffffffffffffe, "unexpected result");
}

#[test]
#[available_gas(20000000)]
fn test_read_word_le_half() {
    let mut ba = sample_bit_array();
    assert!(ba.read_word_le(64).unwrap() == 0xffffffffffffffff, "unexpected result");
    assert!(ba.read_word_le(64).unwrap() == 0x7fffffffffffffff, "unexpected result");
}

#[test]
#[available_gas(20000000)]
fn test_write_word_be() {
    let mut ba: BitArray = Default::default();
    ba.write_word_be(Bounded::<u128>::MAX.into() - 2, 128);
    assert_eq!(ba.read_word_be(128).unwrap(), Bounded::<u128>::MAX.into() - 2);
}

#[test]
#[available_gas(20000000)]
fn test_write_word_be_half() {
    let mut ba: BitArray = Default::default();
    ba.write_word_be(Bounded::<u128>::MAX.into() - 3, 64);
    assert!(ba.read_word_be(64).unwrap() == Bounded::<u64>::MAX.into() - 3, "unexpected value");
}

#[test]
#[available_gas(20000000)]
fn test_write_word_le() {
    let mut ba: BitArray = Default::default();
    ba.write_word_le(Bounded::<u128>::MAX.into() - 4, 128);
    assert_eq!(ba.read_word_le(128).unwrap(), Bounded::<u128>::MAX.into() - 4);
}

#[test]
#[available_gas(20000000)]
fn test_write_word_le_half() {
    let mut ba: BitArray = Default::default();
    ba.write_word_le(Bounded::<u128>::MAX.into() - 5, 64);
    assert!(ba.read_word_le(64).unwrap() == Bounded::<u64>::MAX.into() - 5, "unexpected value");
}

#[test]
#[available_gas(40000000)]
fn test_write_word_be_u256() {
    let mut ba: BitArray = Default::default();
    let expected = u256 { low: Bounded::MAX - 1, high: Bounded::MAX - 2 };
    ba.write_word_be_u256(expected, 256);
    assert!(ba.read_word_be_u256(256).unwrap() == expected, "unexpected value");
}

#[test]
#[available_gas(40000000)]
fn test_write_word_le_u256() {
    let mut ba: BitArray = Default::default();
    let expected = u256 { low: Bounded::MAX - 1, high: Bounded::MAX - 2 };
    ba.write_word_le_u256(expected, 256);
    assert!(ba.read_word_le_u256(256).unwrap() == expected, "unexpected value");
}

#[test]
#[available_gas(80000000)]
fn test_write_word_be_u512() {
    let mut ba: BitArray = Default::default();
    let limb0 = Bounded::<u128>::MAX;
    let limb1 = Bounded::<u128>::MAX - 1;
    let limb2 = Bounded::<u128>::MAX - 2;
    let limb3 = Bounded::<u128>::MAX - 3;
    let expected = u512 { limb0, limb1, limb2, limb3 };
    ba.write_word_be_u512(expected, 512);
    assert!(ba.read_word_be_u512(512).unwrap() == expected, "unexpected value");
}

#[test]
#[available_gas(80000000)]
fn test_write_word_le_u512() {
    let mut ba: BitArray = Default::default();
    let limb0 = Bounded::<u128>::MAX;
    let limb1 = Bounded::<u128>::MAX - 1;
    let limb2 = Bounded::<u128>::MAX - 2;
    let limb3 = Bounded::<u128>::MAX - 3;
    let expected = u512 { limb0, limb1, limb2, limb3 };
    ba.write_word_le_u512(expected, 512);
    assert!(ba.read_word_le_u512(512).unwrap() == expected, "unexpected value");
}

#[test]
#[available_gas(2000000000)]
fn test_stress_test() {
    let mut ba: BitArray = Default::default();
    let mut index = 0;
    let limit = 20;
    while (index != limit) {
        let value: felt252 = index.into();
        ba.write_word_be(value, 248);
        ba.write_word_le(value, 248);
        index += 1;
    }
    index = 0;
    while (index != limit) {
        let value = ba.read_word_be(248).unwrap();
        assert!(value == index.into(), "not equal");
        let value = ba.read_word_le(248).unwrap();
        assert!(value == index.into(), "not equal");
        index += 1;
    };
}

#[test]
#[available_gas(100000)]
fn test_serde_serialize() {
    let mut out = array![];
    let ba = sample_bit_array();
    ba.serialize(ref out);
    let length = out.pop_front().unwrap();
    let length: usize = length.try_into().unwrap();
    assert!(length == ba.len(), "len not equal");
    // We gotta skip one now
    out.pop_front().unwrap();
    let data: felt252 = out.pop_front().unwrap();
    let expected: felt252 = Bounded::<u128>::MAX.into() - 1;
    let expected = expected * one_shift_left_bytes_felt252(15);
    assert!(data == expected, "unexpected data");
}

#[test]
#[available_gas(300000000)]
fn test_serde_ser_deser() {
    let mut ba: BitArray = Default::default();
    let test: felt252 = 0x101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e;
    ba.write_word_be(test, 248);
    ba.write_word_be(test + 1, 248);
    ba.write_word_be(test + 2, 248);
    ba.write_word_be(test + 3, 248);
    ba.write_word_be(test + 4, 248);
    ba.write_word_be(test + 5, 248);
    let mut out = array![];
    ba.serialize(ref out);
    let mut span = out.span();
    let mut deser = Serde::<BitArray>::deserialize(ref span).unwrap();
    assert!(deser.len() == ba.len(), "expected equal lengths");
    assert!(deser.read_word_be(248).unwrap() == test, "expected test");
    assert!(deser.read_word_be(248).unwrap() == test + 1, "expected test + 1");
    assert!(deser.read_word_be(248).unwrap() == test + 2, "expected test + 2");
    assert!(deser.read_word_be(248).unwrap() == test + 3, "expected test + 3");
    assert!(deser.read_word_be(248).unwrap() == test + 4, "expected test + 4");
    assert!(deser.read_word_be(248).unwrap() == test + 5, "expected test + 5");
}

// helpers
fn sample_bit_array() -> BitArray {
    let sample: felt252 = Bounded::<u128>::MAX.into() - 1;
    BitArrayTrait::new(array![], sample * one_shift_left_bytes_felt252(15), 0, 8 * 16)
}
