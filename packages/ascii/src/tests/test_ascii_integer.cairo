use alexandria_ascii::ToAsciiTrait;
use core::num::traits::Bounded;

#[test]
#[available_gas(2000000000)]
fn u256_to_ascii() {
    // ------------------------------ max u256 test ----------------------------- //
    // max u256 int in cairo is GitHub Copilot: The maximum u256 number in Cairo is `
    // 115792089237316195423570985008687907853269984665640564039457584007913129639935`.
    let num: u256 = Bounded::MAX;
    let ascii: Array<felt252> = num.to_ascii();
    assert_eq!(ascii.len(), 3);
    assert_eq!(*ascii.at(0), '1157920892373161954235709850086');
    assert_eq!(*ascii.at(1), '8790785326998466564056403945758');
    assert_eq!(*ascii.at(2), '4007913129639935');
    // ------------------------------ min u256 test ----------------------------- //
    let num: u256 = Bounded::MIN;
    let ascii: Array<felt252> = num.to_ascii();

    assert_eq!(ascii.len(), 1);
    assert_eq!(*ascii.at(0), '0');
    // ---------------------------- 31 char u256 test --------------------------- //
    let ascii: Array<felt252> = 1157920892373161954235709850086_u256.to_ascii();
    assert_eq!(ascii.len(), 1);
    assert_eq!(*ascii.at(0), '1157920892373161954235709850086');
    // ---------------------------- 62 char u256 test --------------------------- //
    let ascii: Array<felt252> = 11579208923731619542357098500868790785326998466564056403945758_u256
        .to_ascii();
    assert_eq!(ascii.len(), 2);
    assert_eq!(*ascii.at(0), '1157920892373161954235709850086');
    assert_eq!(*ascii.at(1), '8790785326998466564056403945758');
}

#[test]
#[available_gas(2000000)]
fn u128_to_ascii() {
    // ------------------------------ max u128 test ----------------------------- //
    // max u128 int in cairo is 340282366920938463463374607431768211455
    let num: u128 = Bounded::MAX;
    let ascii: Array<felt252> = num.to_ascii();

    assert_eq!(ascii.len(), 2);
    assert_eq!(*ascii.at(0), '3402823669209384634633746074317');
    assert_eq!(*ascii.at(1), '68211455');
    // ------------------------------ min u128 test ----------------------------- //
    let num: u128 = Bounded::MIN;
    let ascii: Array<felt252> = num.to_ascii();

    assert_eq!(ascii.len(), 1);
    assert_eq!(*ascii.at(0), '0');
    // ---------------------------- 31 char u128 test --------------------------- //
    let ascii: Array<felt252> = 3402823669209384634633746074317_u128.to_ascii();
    assert_eq!(ascii.len(), 1);
    assert_eq!(*ascii.at(0), '3402823669209384634633746074317');
}

#[test]
#[available_gas(2000000)]
fn u64_to_ascii() {
    // ------------------------------ max u64 test ------------------------------ //
    let num: u64 = Bounded::MAX;
    assert_eq!(num.to_ascii(), '18446744073709551615');
    // ------------------------------ min u64 test ------------------------------ //
    let num: u64 = Bounded::MIN;
    assert_eq!(num.to_ascii(), '0');
}

#[test]
#[available_gas(2000000)]
fn u32_to_ascii() {
    // ------------------------------ max u32 test ------------------------------ //
    let num: u32 = Bounded::MAX;
    assert_eq!(num.to_ascii(), '4294967295');
    // ------------------------------ min u32 test ------------------------------ //
    let num: u32 = Bounded::MIN;
    assert_eq!(num.to_ascii(), '0');
}

#[test]
#[available_gas(2000000)]
fn u16_to_ascii() {
    // ------------------------------ max u16 test ------------------------------ //
    let num: u16 = Bounded::MAX;
    assert_eq!(num.to_ascii(), '65535');
    // ------------------------------ min u16 test ------------------------------ //
    let num: u16 = Bounded::MIN;
    assert_eq!(num.to_ascii(), '0');
}

#[test]
#[available_gas(2000000)]
fn u8_to_ascii() {
    // ------------------------------- max u8 test ------------------------------ //
    let num: u8 = Bounded::MAX;
    assert_eq!(num.to_ascii(), '255');
    // ------------------------------- min u8 test ------------------------------ //
    let num: u8 = Bounded::MIN;
    assert_eq!(num.to_ascii(), '0');
}
