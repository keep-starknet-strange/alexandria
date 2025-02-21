use alexandria_math::keccak256::keccak256;

#[test]
#[available_gas(2000000)]
fn test_keccak256_empty_bytes() {
    let input = array![];

    let hash = keccak256(input.span());
    let expected = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

    assert_eq!(hash, expected)
}

#[test]
#[available_gas(2000000)]
fn test_keccak256_partial_bytes() {
    let input = array![0x00, 0x01, 0x02, 0x03, 0x04, 0x05];

    let hash = keccak256(input.span());
    let expected = 0x51e8babe8b42352100dffa7f7b3843c95245d3d545c6cbf5052e80258ae80627;

    assert_eq!(hash, expected);
}

#[test]
#[available_gas(2000000)]
fn test_keccak256_full_u256() {
    let input = array![
        0x00,
        0x01,
        0x02,
        0x03,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
        0x09,
        0x10,
        0x11,
        0x12,
        0x13,
        0x14,
        0x15,
        0x16,
        0x17,
        0x18,
        0x19,
        0x20,
        0x21,
        0x22,
        0x23,
        0x24,
        0x25,
        0x26,
        0x27,
        0x28,
        0x29,
        0x30,
        0x31,
        0x32
    ];

    let hash = keccak256(input.span());
    let expected = 0x98cfb1eca8a71b4a4b1c115f3d5a462296a66487d1d97fb4c47b979c64bde069;

    assert_eq!(hash, expected);
}
