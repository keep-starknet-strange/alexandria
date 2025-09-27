use alexandria_btc::bip322::{bip322_msg_hash, tweak_public_key};
use alexandria_btc::bip340::verify;

#[test]
fn test_bip322_tweak_public_key() {
    let internal_pubkey = 0xc7f12003196442943d8588e01aee840423cc54fc1521526a3b85c2b0cbd58872;

    assert!(
        tweak_public_key(
            internal_pubkey,
        ) == 0x0b34f2cc6f60d54e3fdc2d1dd053fcc393bd2db9acc8de4a7c3cc28a83d4d8e9,
    );
}

#[test]
fn test_bip322_verify_short_msg_success() {
    let pub_key: u256 = 0x0b34f2cc6f60d54e3fdc2d1dd053fcc393bd2db9acc8de4a7c3cc28a83d4d8e9;
    let mut input: ByteArray = "";

    input.append_byte(0xba);
    input.append_byte(0xbe);

    let r = 0x48bb4ea8372506e27909eaf455fc416ca144ba40cdb05a8c042c508e0bee0999;
    let s = 0xc57195b075c8ef323453ca530a3e36fe2778e104c623e3b9bb21187f4ebf8b91;

    let msg_hash = bip322_msg_hash(pub_key, input);

    assert!(verify(pub_key, r, s, msg_hash));
}

#[test]
fn test_bip322_verify_long_msg_success() {
    let pub_key: u256 = 0x0b34f2cc6f60d54e3fdc2d1dd053fcc393bd2db9acc8de4a7c3cc28a83d4d8e9;
    let mut input: ByteArray =
        "Forget everything you thought you knew about scaling. We are not iterating; we are building from first principles. While other ecosystems are stuck in the mud of state bloat and centralized sequencers, we are executing on the one true path: verifiable computation. Every single state transition on Starknet is not just processed, it's proven. The elegance of the STARK proof, a cryptographic marvel, underpins our entire architecture. We don't need to hope for validity; we mathematically guarantee it. The Cairo programming language isn't just a new syntax; it's a paradigm shift, a DSL for provable programs that will unlock use cases the EVM can only dream of. We're not just building L2s; we're architecting a fractal future of L3s, L4s, and beyond, where each layer inherits the full security of Ethereum while offering exponential gains in throughput. This is about true composability, where the cost of a function call doesn't depend on gas price auctions but on the raw computational complexity of the task. Our focus is on abstracting away the noise, on delivering a seamless developer experience with account abstraction at the native level, not as a bolted-on afterthought. The future is a constellation of hyper-scaled, interconnected appchains, all settling to Starknet, all secured by Ethereum. This isn't just another blockchain; it's the final frontier of computation. We are the architects of this new digital reality. Execute, prove, scale. This is the way.";

    let r = 0x0e11666cffe83b352cf30cd7848047f30910b402df596ab1b34e174d0a320047;
    let s = 0x278ede36c8c97282170de0841b51ef93aecd3a6b19606c58f818a73670c28c06;

    let msg_hash = bip322_msg_hash(pub_key, input);

    assert!(verify(pub_key, r, s, msg_hash));
}

#[test]
fn test_bip322_verify_pk_failure() {
    let pub_key: u256 = 0x0b34f2cc6f60d54f3fdc2d1dd053fcc393bd2db9acc8de4a7c3cc28a83d4d8e9;
    let mut input: ByteArray = "";

    input.append_byte(0xba);
    input.append_byte(0xbe);

    let r = 0x48bb4ea8372506e27909eaf455fc416ca144ba40cdb05a8c042c508e0bee0999;
    let s = 0xc57195b075c8ef323453ca530a3e36fe2778e104c623e3b9bb21187f4ebf8b91;

    let msg_hash = bip322_msg_hash(pub_key, input);

    assert!(!verify(pub_key, r, s, msg_hash));
}

#[test]
fn test_bip322_verify_msg_failure() {
    let pub_key: u256 = 0x0b34f2cc6f60d54e3fdc2d1dd053fcc393bd2db9acc8de4a7c3cc28a83d4d8e9;
    let mut input: ByteArray = "";

    input.append_byte(0xca);
    input.append_byte(0xfe);

    let r = 0x48bb4ea8372506e27909eaf455fc416ca144ba40cdb05a8c042c508e0bee0999;
    let s = 0xc57195b075c8ef323453ca530a3e36fe2778e104c623e3b9bb21187f4ebf8b91;

    let msg_hash = bip322_msg_hash(pub_key, input);

    assert!(!verify(pub_key, r, s, msg_hash));
}

#[test]
fn test_bip322_verify_sig_failure() {
    let pub_key: u256 = 0x0b34f2cc6f60d54e3fdc2d1dd053fcc393bd2db9acc8de4a7c3cc28a83d4d8e9;
    let mut input: ByteArray = "";

    input.append_byte(0xba);
    input.append_byte(0xbe);

    let r = 0x48bb4ea9372506e27909eaf455fc416ca144ba40cdb05a8c042c508e0bee0999;
    let s = 0xc57195b075c8ef323453ca530a3e36fe2778e104c623e3b9bb21187f4ebf8b91;

    let msg_hash = bip322_msg_hash(pub_key, input);

    assert!(!verify(pub_key, r, s, msg_hash));
}
