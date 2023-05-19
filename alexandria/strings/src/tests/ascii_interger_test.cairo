use array::ArrayTrait;
use traits::{Into, TryInto};
use integer::BoundedInt;
use alexandria_strings::ascii::IntergerToAsciiTrait;


#[test]
#[available_gas(2000000)]
fn u128_to_ascii(){
    // ------------------------------ max u128 test ----------------------------- //
    // max u128 int in cairo is 340282366920938463463374607431768211455
    let num : u128 = BoundedInt::max();
    let ascii = num.to_ascii();

    assert (ascii.len() == 2 , 'max u128 wrong len');
    assert(*ascii.at(0) == '3402823669209384634633746074317', 'max u128 wrong first felt');
    assert(*ascii.at(1) == '68211455', 'max u128 wrong second felt');
    // ------------------------------ min u128 test ----------------------------- //
    let num : u128 = BoundedInt::min();
    let ascii = num.to_ascii();

    assert (ascii.len() == 1 , 'min u128 wrong len');
    assert(*ascii.at(0) == '0', 'min u128 wrong felt');
    // ---------------------------- 31 char u128 test --------------------------- //
    let ascii = 3402823669209384634633746074317_u128.to_ascii();
    assert (ascii.len() == 1 , 'u128 31 char wrong len');
    assert(*ascii.at(0) == '3402823669209384634633746074317', '31 char u128 wrong felt');
}

#[test]
#[available_gas(2000000)]
fn u64_to_ascii(){
    // ------------------------------ max u64 test ------------------------------ //
    let num : u64 = BoundedInt::max();
    assert (num.to_ascii() == '18446744073709551615', 'incorect u64 max felt');
    // ------------------------------ min u64 test ------------------------------ //
    let num : u64 = BoundedInt::min();
    assert (num.to_ascii() == '0', 'incorect u64 min felt');
}

#[test]
#[available_gas(2000000)]
fn u32_to_ascii(){
    // ------------------------------ max u32 test ------------------------------ //
    let num : u32 = BoundedInt::max();
    assert (num.to_ascii() == '4294967295', 'incorect u32 max felt');
    // ------------------------------ min u32 test ------------------------------ //
    let num : u32 = BoundedInt::min();
    assert (num.to_ascii() == '0', 'incorect u32 min felt');
}

#[test]
#[available_gas(2000000)]
fn u16_to_ascii(){
    // ------------------------------ max u16 test ------------------------------ //
    let num : u16 = BoundedInt::max();
    assert (num.to_ascii()  == '65535', 'incorect u16 max felt');
    // ------------------------------ min u16 test ------------------------------ //
    let num : u16 = BoundedInt::min();
    assert (num.to_ascii() == '0', 'incorect u16 min felt');
}

#[test]
#[available_gas(2000000)]
fn u8_to_ascii(){
    // ------------------------------- max u8 test ------------------------------ //
    let num : u8 = BoundedInt::max();
    assert (num.to_ascii() == '255', 'incorect u8 max felt');
    // ------------------------------- min u8 test ------------------------------ //
    let num : u8 = BoundedInt::min();
    assert (num.to_ascii() == '0', 'incorect u8 min felt');
}
