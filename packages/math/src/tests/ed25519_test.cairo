use alexandria_math::ed25519::{Point, PointOperations, p_non_zero, verify_signature};

// Public keys and signatures were generated with JS library Noble
// (https://github.com/paulmillr/noble-ed25519)

#[test]
#[available_gas(3200000000)]
fn verify_signature_test_0() {
    let pub_key: u256 = 0x1e6c5b385880849f46716d691b8a447d7cbe4a7ef154f3e2174ffb3c5256fcfe;

    let msg: Span<u8> = array![0xab, 0xcd].span();

    let r_sign: u256 = 0x71eb4ef992551292a9ba5a4817df47fdda2372b2065ed60758b7ee346b7a9e78;
    let s_sign: u256 = 0x6a9473f6492676e988709498b228df873fe3cfdf59255b1a9e1add4f87ec610b;
    let signature = array![r_sign, s_sign];

    assert!(verify_signature(msg, signature.span(), pub_key));
}

#[test]
#[available_gas(3200000000)]
fn verify_signature_test_1() {
    let pub_key: u256 = 0xcc05c1a7ba2937b1c0e71ca1ac636e7240c39fdc8e4672bb0c125eff082324d4;

    let msg: Span<u8> = array![0xab, 0xcd].span();

    let r_sign: u256 = 0xfb781006491fb38af68f9e4be91ce983a32e9363cd8d878325820336283b7d9d;
    let s_sign: u256 = 0x7d1308162466f8e6097f8afa310c074796d13459d4b53cdecf80ca7413410000;
    let signature = array![r_sign, s_sign];

    assert!(verify_signature(msg, signature.span(), pub_key));
}

#[test]
#[available_gas(3200000000)]
fn verify_signature_test_2() {
    let pub_key: u256 = 0x136fa0f7464a55d9a19e9dd0e2edf4f605d3b3f3228dbbe3d7337136ae216d49;

    let msg: Span<u8> = array![0xab, 0xcd].span();

    let r_sign: u256 = 0x9bb411c27a49ea96de338a9c2d5c920357cb9eef5f121f7922c4d2bb00def377;
    let s_sign: u256 = 0xcc2e419abf32f91bc20419ba0905ad52923c7c110d14623b62300711b8f9370c;
    let signature = array![r_sign, s_sign];

    assert!(verify_signature(msg, signature.span(), pub_key));
}

#[test]
#[available_gas(3200000000)]
fn verify_signature_test_3() {
    let pub_key: u256 = 0x040369a47bcee3ae0cb373037ec0d2e36cae4a3762e388ff0682962aef49f444;

    let msg: Span<u8> = array![0x12, 0x34, 0x56, 0x78].span();

    let r_sign: u256 = 0xc71970448f7368c295d11cd64bb4fc7bb8899c830d9055832b6686b3f606b76d;
    let s_sign: u256 = 0x68e015fa8775659d1f40a01e1f69b8af4409046f4dc8ff02cdb04fdc3585eb0d;
    let signature = array![r_sign, s_sign];

    assert!(verify_signature(msg, signature.span(), pub_key));
}

#[test]
#[available_gas(3200000000)]
fn verify_signature_invalid() {
    let pub_key: u256 = 0x040369a47bcee3ae0cb373037ec0d2e36cae4a3762e388ff0682962aef49f444;

    let msg: Span<u8> = array![0x12, 0x34, 0x56, 0x78].span();

    let r_sign: u256 = 0xc71970448f7368c295d11cd64bb4fc7bb8899c830d9055832b6686b3f606b76a;
    let s_sign: u256 = 0x68e015fa8775659d1f40a01e1f69b8af4409046f4dc8ff02cdb04fdc3585eb01;
    let signature = array![r_sign, s_sign];

    assert!(!verify_signature(msg, signature.span(), pub_key));
}

#[test]
#[available_gas(3200000000)]
fn verify_signature_invalid_length() {
    let pub_key: u256 = 0x040369a47bcee3ae0cb373037ec0d2e36cae4a3762e388ff0682962aef49f444;

    let msg: Span<u8> = array![0x0].span();

    let r_sign: u256 = 0xc71970448f7368c295d11cd64bb4fc7bb8899c830d9055832b6686b3f606b76d;
    let s_sign: u256 = 0x68e015fa8775659d1f40a01e1f69b8af4409046f4dc8ff02cdb04fdc3585eb0d;
    let signature = array![r_sign, s_sign, s_sign];

    assert!(!verify_signature(msg, signature.span(), pub_key));
    assert!(!verify_signature(msg, array![r_sign].span(), pub_key));
}

#[test]
fn affine_point_op() {
    let p1 = Point {
        x: 46706390780465557264338673484185971070529246228527338942042475661633188627656,
        y: 15299170165656271974649334809062094114079726227711063015095704409550798436788,
    };
    let p2 = Point {
        x: 26148317933504540005443173402042326458672162458767831815669826413036406984486,
        y: 30850316547316149219369061290562558254923949145644564178378051444253659681385,
    };
    let res = Point {
        x: 34426924428514608760437100447421064591311588584549077394333265447466212246087,
        y: 29872771498517479181395568267318965384440757492476580330810382845026939417492,
    };
    assert!(res == p1.add(p2, p_non_zero));
}

#[test]
fn verify_signature_test_with_pub_key_having_consecutive_identical_bytes() {
    let pub_key: u256 = 0x523548db04e2e31898ebd886bfb92f9691bbf8f6a704d772ccd9f1a1f0e7928b;

    let msg: Span<u8> = [
        0x77, 0x08, 0x02, 0x11, 0x46, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x48, 0x0a,
        0x20, 0x4b, 0xbb, 0xe7, 0x20, 0x4f, 0x38, 0xe9, 0x00, 0x39, 0x3f, 0x79, 0xd2, 0xa6, 0x38,
        0xd2, 0xd0, 0x6d, 0x36, 0x9b, 0xac, 0xbc, 0x6d, 0x4d, 0x1f, 0xd8, 0x7c, 0x07, 0x7c, 0x2f,
        0x12, 0xda, 0x43, 0x12, 0x24, 0x08, 0x01, 0x12, 0x20, 0x5b, 0xdf, 0xeb, 0xcc, 0x94, 0x62,
        0x2a, 0xed, 0xaf, 0xc2, 0x79, 0xea, 0x9f, 0xb1, 0x9e, 0xc7, 0xe9, 0x3c, 0xdc, 0xe4, 0xea,
        0xe5, 0x9b, 0x21, 0x81, 0x34, 0xea, 0x85, 0xaf, 0x6f, 0xe4, 0x8c, 0x2a, 0x0c, 0x08, 0xc3,
        0x8f, 0xf4, 0xbf, 0x06, 0x10, 0xc9, 0xaa, 0xcc, 0x85, 0x03, 0x32, 0x12, 0x63, 0x68, 0x61,
        0x69, 0x6e, 0x2d, 0x31, 0x2d, 0x33, 0x39, 0x36, 0x35, 0x31, 0x39, 0x32, 0x35, 0x32, 0x34,
    ]
        .span();

    let r_sign: u256 = 0xc46c6184dcdc01402522f7010d41704265030a3d618b5935f1ebfdd21231ff21;
    let s_sign: u256 = 0xe9bd2b662b7e4b3c88968c45a78b75358e219e6c2f341fe89aa65ea376109507;
    let signature = array![r_sign, s_sign];

    assert!(verify_signature(msg, signature.span(), pub_key));
}

