use alexandria_data_structures::byte_array_ext::ByteArraySerde;

#[test]
#[available_gas(1000000)]
fn test_serialize() {
    let mut out = array![];
    let ba = test_byte_array_64();
    ba.serialize(ref out);
    let expected = serialized_byte_array_64();
    assert(out == expected, 'serialization differs');
}

#[test]
#[available_gas(1000000)]
fn test_deserialize() {
    let mut in = serialized_byte_array_64().span();
    let ba: ByteArray = Serde::deserialize(ref in).unwrap();
    assert(ba == test_byte_array_64(), 'deserialized ByteArray differs');
}

fn test_byte_array_64() -> ByteArray {
    let mut ba1 = Default::default();
    ba1.append_word(0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f, 31);
    ba1.append_word(0x202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e, 31);
    ba1.append_word(0x3f40, 2);
    ba1
}

fn serialized_byte_array_64() -> Array<felt252> {
    array![
        0x40,
        0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f,
        0x202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e,
        0x3f40
    ]
}
