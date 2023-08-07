use core::option::OptionTrait;
use core::array::SpanTrait;
use alexandria::math::ed25519::{p, Point, verify_signature, SpanU8TryIntoPoint};
use array::ArrayTrait;
use debug::PrintTrait;
use traits::TryInto;

fn gen_msg() -> Span<u8> {
    let mut msg: Array<u8> = Default::default();
    // Hello World!
    msg.append(0x48);
    msg.append(0x65);
    msg.append(0x6c);
    msg.append(0x6c);
    msg.append(0x6f);
    msg.append(0x20);
    msg.append(0x57);
    msg.append(0x6f);
    msg.append(0x72);
    msg.append(0x6c);
    msg.append(0x64);
    msg.append(0x21);
    msg.span()
}

fn gen_wrong_msg() -> Span<u8> {
    let mut msg: Array<u8> = Default::default();
    // Hello Bro!
    msg.append(0x48);
    msg.append(0x65);
    msg.append(0x6C);
    msg.append(0x6C);
    msg.append(0x6F);
    msg.append(0x20);
    msg.append(0x42);
    msg.append(0x72);
    msg.append(0x6F);
    msg.append(0x21);
    msg.span()
}

fn gen_sig() -> Span<u8> {
    let mut sig: Array<u8> = Default::default();
    // 2228eb055b60cab2b3abfefbc79eef16441dc7edf9aae9778013ffa7b2607b115f7a5709381b49d18437e842a7234881a328707b3de17dbfee25608b7cb99b04
    sig.append(0x22);
    sig.append(0x28);
    sig.append(0xeb);
    sig.append(0x05);
    sig.append(0x5b);
    sig.append(0x60);
    sig.append(0xca);
    sig.append(0xb2);
    sig.append(0xb3);
    sig.append(0xab);
    sig.append(0xfe);
    sig.append(0xfb);
    sig.append(0xc7);
    sig.append(0x9e);
    sig.append(0xef);
    sig.append(0x16);
    sig.append(0x44);
    sig.append(0x1d);
    sig.append(0xc7);
    sig.append(0xed);
    sig.append(0xf9);
    sig.append(0xaa);
    sig.append(0xe9);
    sig.append(0x77);
    sig.append(0x80);
    sig.append(0x13);
    sig.append(0xff);
    sig.append(0xa7);
    sig.append(0xb2);
    sig.append(0x60);
    sig.append(0x7b);
    sig.append(0x11);
    sig.append(0x5f);
    sig.append(0x7a);
    sig.append(0x57);
    sig.append(0x09);
    sig.append(0x38);
    sig.append(0x1b);
    sig.append(0x49);
    sig.append(0xd1);
    sig.append(0x84);
    sig.append(0x37);
    sig.append(0xe8);
    sig.append(0x42);
    sig.append(0xa7);
    sig.append(0x23);
    sig.append(0x48);
    sig.append(0x81);
    sig.append(0xa3);
    sig.append(0x28);
    sig.append(0x70);
    sig.append(0x7b);
    sig.append(0x3d);
    sig.append(0xe1);
    sig.append(0x7d);
    sig.append(0xbf);
    sig.append(0xee);
    sig.append(0x25);
    sig.append(0x60);
    sig.append(0x8b);
    sig.append(0x7c);
    sig.append(0xb9);
    sig.append(0x9b);
    sig.append(0x04);
    sig.span()
}

fn gen_pub_key() -> Span<u8> {
    let mut pub_key: Array<u8> = Default::default();
    pub_key.append(0x99);
    pub_key.append(0xb9);
    pub_key.append(0x8a);
    pub_key.append(0xc7);
    pub_key.append(0x34);
    pub_key.append(0x27);
    pub_key.append(0x8c);
    pub_key.append(0x17);
    pub_key.append(0xb4);
    pub_key.append(0x91);
    pub_key.append(0x9a);
    pub_key.append(0xa5);
    pub_key.append(0xd9);
    pub_key.append(0x7a);
    pub_key.append(0xdc);
    pub_key.append(0x7a);
    pub_key.append(0xd2);
    pub_key.append(0x18);
    pub_key.append(0xb2);
    pub_key.append(0xcb);
    pub_key.append(0x40);
    pub_key.append(0xaf);
    pub_key.append(0x81);
    pub_key.append(0x56);
    pub_key.append(0x9f);
    pub_key.append(0xfb);
    pub_key.append(0x13);
    pub_key.append(0x00);
    pub_key.append(0xe7);
    pub_key.append(0x73);
    pub_key.append(0x89);
    pub_key.append(0x0c);
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
    let sig: Span<u8> = Default::default().span();
    let pub_key: Span<u8> = gen_pub_key();

    assert(!verify_signature(empty_msg, sig, pub_key), 'Signature should be invalid');
}

#[test]
#[available_gas(3200000000)]
fn verify_signature_empty_pub_key_test() {
    let empty_msg: Span<u8> = gen_msg();
    let sig: Span<u8> = gen_sig();
    let pub_key: Span<u8> = Default::default().span();

    assert(!verify_signature(empty_msg, sig, pub_key), 'Signature should be invalid');
}

