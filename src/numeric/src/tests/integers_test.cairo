use alexandria_numeric::integers::UIntBytes;

#[test]
#[available_gas(2000000)]
fn test_u32_from_bytes() {
    let input: Array<u8> = array![0xf4, 0x32, 0x15, 0x62];
    let res: Option<u32> = UIntBytes::from_bytes(input.span());

    assert!(res.is_some(), "should have a value");
    assert_eq!(res.unwrap(), 0xf4321562, "wrong result value");
}

#[test]
#[available_gas(2000000)]
fn test_u32_from_bytes_too_big() {
    let input: Array<u8> = array![0xf4, 0x32, 0x15, 0x62, 0x01];
    let res: Option<u32> = UIntBytes::from_bytes(input.span());

    assert!(res.is_none(), "should not have a value");
}


#[test]
#[available_gas(2000000)]
fn test_u32_to_bytes_full() {
    let input: u32 = 0xf4321562;
    let res: Span<u8> = input.to_bytes();

    assert_eq!(res.len(), 4, "wrong result length");
    assert_eq!(*res[0], 0xf4, "wrong result value");
    assert_eq!(*res[1], 0x32, "wrong result value");
    assert_eq!(*res[2], 0x15, "wrong result value");
    assert_eq!(*res[3], 0x62, "wrong result value");
}

#[test]
#[available_gas(2000000)]
fn test_u32_to_bytes_partial() {
    let input: u32 = 0xf43215;
    let res: Span<u8> = input.to_bytes();

    assert_eq!(res.len(), 3, "wrong result length");
    assert_eq!(*res[0], 0xf4, "wrong result value");
    assert_eq!(*res[1], 0x32, "wrong result value");
    assert_eq!(*res[2], 0x15, "wrong result value");
}


#[test]
#[available_gas(2000000)]
fn test_u32_to_bytes_leading_zeros() {
    let input: u32 = 0x00f432;
    let res: Span<u8> = input.to_bytes();

    assert_eq!(res.len(), 2, "wrong result length");
    assert_eq!(*res[0], 0xf4, "wrong result value");
    assert_eq!(*res[1], 0x32, "wrong result value");
}

#[test]
#[available_gas(20000000)]
fn test_u32_bytes_used() {
    let len: u32 = 0x1234;
    let bytes_count = len.bytes_used();

    assert_eq!(bytes_count, 2, "wrong bytes count");
}

#[test]
#[available_gas(20000000)]
fn test_u32_bytes_used_leading_zeroes() {
    let len: u32 = 0x001234;
    let bytes_count = len.bytes_used();

    assert_eq!(bytes_count, 2, "wrong bytes count");
}
