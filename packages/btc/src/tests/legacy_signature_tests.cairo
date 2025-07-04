use starknet::secp256_trait::Signature;
use alexandria_btc::verify_legacy_signature;

#[test]
fn test_legacy_verify_success() {
    let pub_key: u256 = 0x5c114743590e28ceaae0d5229ada58a93bcccf8b226a152069a402b8b1238bd1;
    let v: u256 = 0x19;
    let sig = Signature {
        r: 0x220eb5bbd38f34f748ff7f6247fd2d05a129b7e8bd375e9c9568c2f7b0203649,
        s: 0x29fb478e0416568e8254258969c56369d7b4e3c528416cb0bbc4211fd362528a,
        y_parity: v % 2 == 0
    };

    let msg: u256 = 0xadb989cbc22bb0b956f2db501df0f0a265fd38257802c940bb136e8ba10be754;

    verify_legacy_signature(msg, sig, pub_key);
}

#[test]
#[should_panic]
fn test_legacy_verify_addr_failure() {
    let pub_key: u256 = 0xc47dffa16ee5b364913435006f26813e65dd30a5a715989b;
    let v: u256 = 0x19;
    let sig = Signature {
        r: 0x220eb5bbd38f34f748ff7f6247fd2d05a129b7e8bd375e9c9568c2f7b0203649,
        s: 0x29fb478e0416568e8254258969c56369d7b4e3c528416cb0bbc4211fd362528a,
        y_parity: v % 2 == 0
    };
    let msg: u256 = 0xadb989cbc22bb0b956f2db501df0f0a265fd38257802c940bb136e8ba10be754;

    verify_legacy_signature(msg, sig, pub_key);
}

#[test]
#[should_panic]
fn test_legacy_verify_msg_failure() {
    let pub_key: u256 = 0xc47dffa16ee5a364913435006f26813e65dd30a5a715989b;
    let v: u256 = 0x19;
    let sig = Signature {
        r: 0x220eb5bbd38f34f748ff7f6247fd2d05a129b7e8bd375e9c9568c2f7b0203649,
        s: 0x29fb478e0416568e8254258969c56369d7b4e3c528416cb0bbc4211fd362528a,
        y_parity: v % 2 == 0
    };
    let msg: u256 = 0xadb989cbc22ba0b956f2db501df0f0a265fd38257802c940bb136e8ba10be754;

    verify_legacy_signature(msg, sig, pub_key);
}

#[test]
#[should_panic]
fn test_legacy_verify_sig_failure() {
    let pub_key: u256 = 0xc47dffa16ee5a364913435006f26813e65dd30a5a715989b;
    let v: u256 = 0x19;
    let sig = Signature {
        r: 0x220eb5bbd38f34f748ff7f6247fd2d05a129b7e8bd375e9c9568c2f7b0203649,
        s: 0x29fb478e0416538e8254258969c56369d7b4e3c528416cb0bbc4211fd362528a,
        y_parity: v % 2 == 0
    };
    let msg: u256 = 0xadb989cbc22bb0b956f2db501df0f0a265fd38257802c940bb136e8ba10be754;

    verify_legacy_signature(msg, sig, pub_key);
}
