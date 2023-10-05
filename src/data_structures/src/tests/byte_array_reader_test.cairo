use integer::u512;
use alexandria_data_structures::byte_array_ext::ByteArrayTraitExt;
use alexandria_data_structures::byte_array_reader::ByteArrayReaderTrait;
use alexandria_data_structures::tests::byte_array_ext_test::test_byte_array_64;

#[test]
#[available_gas(10000000)]
fn test_clone_byte_array_reader() {
    let ba = test_byte_array_64();
    let mut rd1 = ba.reader();
    let temp = rd1.read_u256().unwrap();
    let mut rd2 = rd1.clone();
    let a = rd1.read_u128().unwrap();
    let b = rd2.read_u128().unwrap();
    assert(a == b, 'copy ByteArrayReader failed');
}

#[test]
#[available_gas(20000000)]
fn test_len() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    assert(64 == rd.len(), 'expected len 64');
    let _ = rd.read_u8().expect('some');
    assert(63 == rd.len(), 'expected len 63');
    let _ = rd.read_u256().expect('some');
    assert(31 == rd.len(), 'expected len 31');
    let _ = rd.read_u128().expect('some');
    assert(15 == rd.len(), 'expected len 15');
    let _ = rd.read_u64().expect('some');
    assert(7 == rd.len(), 'expected len 7');
    let _ = rd.read_u32().expect('some');
    assert(3 == rd.len(), 'expected len 3');
    let _ = rd.read_u16().expect('some');
    assert(1 == rd.len(), 'expected len 1');
    let _ = rd.read_i8().expect('some');
    assert(0 == rd.len(), 'expected len 0');
}

#[test]
#[available_gas(20000000)]
fn test_read() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    assert(rd.read_i8() == Option::Some(1), 'expected 1');
    // rd.read_i128().unwrap().print();
    assert(rd.read_i128() == Option::Some(0x02030405060708090a0b0c0d0e0f1011),
     'not 0x0203040506...');
    assert(rd.read_u128() == Option::Some(0x12131415161718191a1b1c1d1e1f2021),
     'not 0x1213141516...');
    assert(rd.read_i64() == Option::Some(0x2223242526272829), 'not 0x22232425...');
    assert(rd.read_u128() == Option::Some(0x2a2b2c2d2e2f30313233343536373839), 
     'not 0x2a2b2c2d2e...');
    assert(rd.read_u32() == Option::Some(0x3a3b3c3d), 'not 0x3a3b3c3d');
    assert(rd.read_i16() == Option::Some(0x3e3f), 'not 0x3e3f');
    assert(rd.read_u8() == Option::Some(0x40), 'not 0x40');
    assert(rd.read_u8().is_none(), 'expected none');
}

#[test]
#[available_gas(20000000)]
fn test_read_u256() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    let u256{low: low1, high: high1} = rd.read_u256().unwrap();
    assert(high1 == 0x0102030405060708090a0b0c0d0e0f10_u128, 'wrong value for high1');
    assert(low1 == 0x1112131415161718191a1b1c1d1e1f20_u128, 'wrong value for low1');
}

#[test]
#[available_gas(20000000)]
fn test_read_u512() {
    let ba = test_byte_array_64();
    let mut rd = ba.reader();
    let u512{limb0, limb1, limb2, limb3} = rd.read_u512().unwrap();

    assert(limb3 == 0x0102030405060708090a0b0c0d0e0f10_u128, 'wrong value for limb3');
    assert(limb2 == 0x1112131415161718191a1b1c1d1e1f20_u128, 'wrong value for limb2');
    assert(limb1 == 0x2122232425262728292a2b2c2d2e2f30_u128, 'wrong value for limb1');
    assert(limb0 == 0x3132333435363738393a3b3c3d3e3f40_u128, 'wrong value for limb0');
}