use alexandria_bytes::bytes::BytesTrait;

#[test]
fn test_index_within_bounds() {
    let bytes = BytesTrait::new(16, array![0x11111111111111111111111111111111]);

    let value = bytes[0];
    assert(*value == 0x11111111111111111111111111111111, 'value mismatch');
}

#[test]
fn test_index_multiple_elements() {
    // size=33 bytes requires ceil(33/16) = 3 elements
    let bytes = BytesTrait::new(
        33,
        array![
            0x11111111111111111111111111111111, 0x22222222222222222222222222222222,
            0x33000000000000000000000000000000,
        ],
    );

    let first = bytes[0];
    let second = bytes[1];
    let third = bytes[2];

    assert(*first == 0x11111111111111111111111111111111, 'first mismatch');
    assert(*second == 0x22222222222222222222222222222222, 'second mismatch');
    assert(*third == 0x33000000000000000000000000000000, 'third mismatch');
}

#[test]
#[should_panic(expected: ('Index out of bounds',))]
fn test_index_out_of_bounds() {
    let bytes = BytesTrait::new(16, array![0x11111111111111111111111111111111]);
    let _ = bytes[1];
}

#[test]
#[should_panic(expected: ('Index out of bounds',))]
fn test_index_way_out_of_bounds() {
    let bytes = BytesTrait::new(16, array![0x11111111111111111111111111111111]);
    let _ = bytes[100];
}

#[test]
fn test_index_at_boundary() {
    // size=32 bytes = exactly 2 elements
    let bytes = BytesTrait::new(
        32, array![0x11111111111111111111111111111111, 0x22222222222222222222222222222222],
    );

    let _ = bytes[0];
    let _ = bytes[1];
}

#[test]
#[should_panic(expected: ('Index out of bounds',))]
fn test_index_exceeds_boundary() {
    let bytes = BytesTrait::new(
        32, array![0x11111111111111111111111111111111, 0x22222222222222222222222222222222],
    );
    let _ = bytes[2];
}
