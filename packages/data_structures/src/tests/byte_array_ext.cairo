use alexandria_data_structures::byte_array_ext::{ByteArrayIntoArrayU8, SpanU8IntoBytearray};

#[test]
#[available_gas(1000000)]
fn test_span_u8_into_byte_array() {
    let array: Array<u8> = array![1, 2, 3, 4, 5, 6, 7, 8,];
    let ba: ByteArray = array.span().into();
    let mut index = 0_usize;
    while let Option::Some(byte) = ba.at(index) {
        assert!(*(array[index]) == byte);
        index += 1;
    };
}

#[test]
#[available_gas(10000000)]
fn test_byte_array_into_array_u8() {
    let array: Array<u8> = test_byte_array_64().into();
    let mut index = 0_usize;
    while (index != 64) {
        assert!((*array[index]).into() == index + 1, "unexpected result");
        index += 1;
    }
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
