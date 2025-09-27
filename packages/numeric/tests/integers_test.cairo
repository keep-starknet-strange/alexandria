use alexandria_numeric::integers::UIntBytes;


#[test]
fn test_u32_from_bytes() {
    let input: Array<u8> = array![0xf4, 0x32, 0x15, 0x62];
    let res: Option<u32> = UIntBytes::from_bytes(input.span());

    assert!(res.is_some(), "should have a value");
    assert!(res.unwrap() == 0xf4321562);
}

#[test]
fn test_u32_from_bytes_too_big() {
    let input: Array<u8> = array![0xf4, 0x32, 0x15, 0x62, 0x01];
    let res: Option<u32> = UIntBytes::from_bytes(input.span());

    assert!(res.is_none(), "should not have a value");
}


#[test]
fn test_u32_to_bytes_full() {
    let input: u32 = 0xf4321562;
    let res: Span<u8> = input.to_bytes();

    assert!(res.len() == 4);
    assert!(*res[0] == 0xf4);
    assert!(*res[1] == 0x32);
    assert!(*res[2] == 0x15);
    assert!(*res[3] == 0x62);
}

#[test]
fn test_u32_to_bytes_partial() {
    let input: u32 = 0xf43215;
    let res: Span<u8> = input.to_bytes();

    assert!(res.len() == 3);
    assert!(*res[0] == 0xf4);
    assert!(*res[1] == 0x32);
    assert!(*res[2] == 0x15);
}


#[test]
fn test_u32_to_bytes_leading_zeros() {
    let input: u32 = 0x00f432;
    let res: Span<u8> = input.to_bytes();

    assert!(res.len() == 2);
    assert!(*res[0] == 0xf4);
    assert!(*res[1] == 0x32);
}
