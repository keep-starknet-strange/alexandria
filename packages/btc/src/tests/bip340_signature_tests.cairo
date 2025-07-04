use starknet::secp256_trait::Signature;
use alexandria_btc::verify_bip340_signature;

#[test]
fn test_bip340_verify_success() {
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659; // 3e304cdd0efe378178266f9d1acfaf3d1335604e
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let sig = Signature {
        r: 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341,
        s: 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a,
        y_parity: true
    };

    verify_bip340_signature(msg, sig, pub_key);
}

#[test]
#[should_panic]
fn test_bip340_verify_pk_failure() {
    let pub_key: u256 = 0xdf01d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659; // 3e304cdd0efe378178266f9d1acfaf3d1335604e
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let sig = Signature {
        r: 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341,
        s: 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a,
        y_parity: true
    };

    verify_bip340_signature(msg, sig, pub_key);
}

#[test]
#[should_panic]
fn test_bip340_verify_msg_failure() {
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659; // 3e304cdd0efe378178266f9d1acfaf3d1335604e
    let msg: u256 = 0x243f6a8985a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let sig = Signature {
        r: 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341,
        s: 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a,
        y_parity: true
    };

    verify_bip340_signature(msg, sig, pub_key);
}

#[test]
#[should_panic]
fn test_bip340_verify_sig_failure() {
    let pub_key: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659; // 3e304cdd0efe378178266f9d1acfaf3d1335604e
    let msg: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    let sig = Signature {
        r: 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341,
        s: 0x8906d11ac976abcab20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a,
        y_parity: true
    };

    verify_bip340_signature(msg, sig, pub_key);
}
