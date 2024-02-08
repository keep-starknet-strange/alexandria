use alexandria_ascii::ToAsciiTrait;
use integer::BoundedInt;

#[test]
#[available_gas(2000000000)]
fn u256_to_ascii() {
    // ------------------------------ max u256 test ----------------------------- //
    // max u256 int in cairo is GitHub Copilot: The maximum u256 number in Cairo is `
    // 115792089237316195423570985008687907853269984665640564039457584007913129639935`.
    let num: u256 = BoundedInt::max();
    let ascii: Array<felt252> = num.to_ascii();
    assert_eq!(ascii.len(), 3, "max u256 wrong len");
    assert_eq!(*ascii.at(0), '1157920892373161954235709850086', "max u256 wrong first felt");
    assert_eq!(*ascii.at(1), '8790785326998466564056403945758', "max u256 wrong second felt");
    assert_eq!(*ascii.at(2), '4007913129639935', "max u256 wrong third felt");
    // ------------------------------ min u256 test ----------------------------- //
    let num: u256 = BoundedInt::min();
    let ascii: Array<felt252> = num.to_ascii();

    assert_eq!(ascii.len(), 1, "min u256 wrong len");
    assert_eq!(*ascii.at(0), '0', "min u256 wrong felt");
    // ---------------------------- 31 char u256 test --------------------------- //
    let ascii: Array<felt252> = 1157920892373161954235709850086_u256.to_ascii();
    assert_eq!(ascii.len(), 1, "u256 31 char wrong len");
    assert_eq!(*ascii.at(0), '1157920892373161954235709850086', "31 char u256 wrong felt");
    // ---------------------------- 62 cahr u256 test --------------------------- //
    let ascii: Array<felt252> = 11579208923731619542357098500868790785326998466564056403945758_u256
        .to_ascii();
    assert_eq!(ascii.len(), 2, "u256 31 char wrong len");
    assert_eq!(*ascii.at(0), '1157920892373161954235709850086', "31 char u256 wrong felt");
    assert_eq!(*ascii.at(1), '8790785326998466564056403945758', "62 char u256 wrong felt");
}

#[test]
#[available_gas(2000000)]
fn u128_to_ascii() {
    // ------------------------------ max u128 test ----------------------------- //
    // max u128 int in cairo is 340282366920938463463374607431768211455
    let num: u128 = BoundedInt::max();
    let ascii: Array<felt252> = num.to_ascii();

    assert_eq!(ascii.len(), 2, "max u128 wrong len");
    assert_eq!(*ascii.at(0), '3402823669209384634633746074317', "max u128 wrong first felt");
    assert_eq!(*ascii.at(1), '68211455', "max u128 wrong second felt");
    // ------------------------------ min u128 test ----------------------------- //
    let num: u128 = BoundedInt::min();
    let ascii: Array<felt252> = num.to_ascii();

    assert_eq!(ascii.len(), 1, "min u128 wrong len");
    assert_eq!(*ascii.at(0), '0', "min u128 wrong felt");
    // ---------------------------- 31 char u128 test --------------------------- //
    let ascii: Array<felt252> = 3402823669209384634633746074317_u128.to_ascii();
    assert_eq!(ascii.len(), 1, "u128 31 char wrong len");
    assert_eq!(*ascii.at(0), '3402823669209384634633746074317', "31 char u128 wrong felt");
}

#[test]
#[available_gas(2000000)]
fn u64_to_ascii() {
    // ------------------------------ max u64 test ------------------------------ //
    let num: u64 = BoundedInt::max();
    assert_eq!(num.to_ascii(), '18446744073709551615', "incorect u64 max felt");
    // ------------------------------ min u64 test ------------------------------ //
    let num: u64 = BoundedInt::min();
    assert_eq!(num.to_ascii(), '0', "incorect u64 min felt");
}

#[test]
#[available_gas(2000000)]
fn u32_to_ascii() {
    // ------------------------------ max u32 test ------------------------------ //
    let num: u32 = BoundedInt::max();
    assert_eq!(num.to_ascii(), '4294967295', "incorect u32 max felt");
    // ------------------------------ min u32 test ------------------------------ //
    let num: u32 = BoundedInt::min();
    assert_eq!(num.to_ascii(), '0', "incorect u32 min felt");
}

#[test]
#[available_gas(2000000)]
fn u16_to_ascii() {
    // ------------------------------ max u16 test ------------------------------ //
    let num: u16 = BoundedInt::max();
    assert_eq!(num.to_ascii(), '65535', "incorect u16 max felt");
    // ------------------------------ min u16 test ------------------------------ //
    let num: u16 = BoundedInt::min();
    assert_eq!(num.to_ascii(), '0', "incorect u16 min felt");
}

#[test]
#[available_gas(2000000)]
fn u8_to_ascii() {
    // ------------------------------- max u8 test ------------------------------ //
    let num: u8 = BoundedInt::max();
    assert_eq!(num.to_ascii(), '255', "incorect u8 max felt");
    // ------------------------------- min u8 test ------------------------------ //
    let num: u8 = BoundedInt::min();
    assert_eq!(num.to_ascii(), '0', "incorect u8 min felt");
}
