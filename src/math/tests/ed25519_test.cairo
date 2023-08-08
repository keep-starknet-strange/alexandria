use core::option::OptionTrait;
use core::array::SpanTrait;
use alexandria::math::ed25519::{p, Point, verify_signature, SpanU8TryIntoPoint};
use array::ArrayTrait;
use debug::PrintTrait;
use traits::TryInto;

fn gen_msg() -> Span<u8> {
    // Hello World!
    let mut msg: Array<u8> = array![
        0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x57, 0x6f, 0x72, 0x6c, 0x64, 0x21
    ];
    msg.span()
}

fn gen_wrong_msg() -> Span<u8> {
    // Hello Bro!
    let mut msg: Array<u8> = array![0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x20, 0x42, 0x72, 0x6F, 0x21];
    msg.span()
}

fn gen_sig() -> Span<u8> {
    // 2228eb055b60cab2b3abfefbc79eef16441dc7edf9aae9778013ffa7b2607b115f7a5709381b49d18437e842a7234881a328707b3de17dbfee25608b7cb99b04
    let mut sig: Array<u8> = array![
        0x22,
        0x28,
        0xeb,
        0x05,
        0x5b,
        0x60,
        0xca,
        0xb2,
        0xb3,
        0xab,
        0xfe,
        0xfb,
        0xc7,
        0x9e,
        0xef,
        0x16,
        0x44,
        0x1d,
        0xc7,
        0xed,
        0xf9,
        0xaa,
        0xe9,
        0x77,
        0x80,
        0x13,
        0xff,
        0xa7,
        0xb2,
        0x60,
        0x7b,
        0x11,
        0x5f,
        0x7a,
        0x57,
        0x09,
        0x38,
        0x1b,
        0x49,
        0xd1,
        0x84,
        0x37,
        0xe8,
        0x42,
        0xa7,
        0x23,
        0x48,
        0x81,
        0xa3,
        0x28,
        0x70,
        0x7b,
        0x3d,
        0xe1,
        0x7d,
        0xbf,
        0xee,
        0x25,
        0x60,
        0x8b,
        0x7c,
        0xb9,
        0x9b,
        0x04
    ];
    sig.span()
}

fn gen_pub_key() -> Span<u8> {
    let mut pub_key: Array<u8> = array![
        0x99,
        0xb9,
        0x8a,
        0xc7,
        0x34,
        0x27,
        0x8c,
        0x17,
        0xb4,
        0x91,
        0x9a,
        0xa5,
        0xd9,
        0x7a,
        0xdc,
        0x7a,
        0xd2,
        0x18,
        0xb2,
        0xcb,
        0x40,
        0xaf,
        0x81,
        0x56,
        0x9f,
        0xfb,
        0x13,
        0x00,
        0xe7,
        0x73,
        0x89,
        0x0c
    ];
    pub_key.span()
}

#[test]
#[available_gas(3200000000)]
fn verify_signature_test() {
    let msg: Span<u8> = gen_msg();
    let sig: Span<u8> = gen_sig();
    let pub_key: Span<u8> = gen_pub_key();

    assert(verify_signature(msg, sig, pub_key), 'Invalid signature');
}

#[test]
#[available_gas(3200000000)]
fn verify_wrong_signature_test() {
    let wrong_msg: Span<u8> = gen_wrong_msg();
    let sig: Span<u8> = gen_sig();
    let pub_key: Span<u8> = gen_pub_key();

    assert(!verify_signature(wrong_msg, sig, pub_key), 'Signature should be invalid');
}

#[test]
#[available_gas(3200000000)]
fn verify_signature_empty_sig_test() {
    let empty_msg: Span<u8> = gen_msg();
    let sig = array![].span();
    let pub_key: Span<u8> = gen_pub_key();

    assert(!verify_signature(empty_msg, sig, pub_key), 'Signature should be invalid');
}

#[test]
#[available_gas(3200000000)]
fn verify_signature_empty_pub_key_test() {
    let empty_msg: Span<u8> = gen_msg();
    let sig: Span<u8> = gen_sig();
    let pub_key = array![].span();

    assert(!verify_signature(empty_msg, sig, pub_key), 'Signature should be invalid');
}

