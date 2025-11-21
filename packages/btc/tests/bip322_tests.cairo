use alexandria_btc::bip322::{
    SighashType, bip322_msg_hash, bip322_msg_hash_with_type, tweak_public_key,
};
use alexandria_btc::bip340::verify;

const PUB_KEY: u256 = 0x08c80f3bf06bcc87154dcd3cf294aada4ee9b3218d4ba60e2bbaf91c17d351ee;

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
    let mut input: ByteArray = "";

    input.append_byte(0xba);
    input.append_byte(0xbe);

    let r = 0xb004d6cc1e748ba99479ff294c456055572cbf96aa5ba485f562cc5daa8ee7c4;
    let s = 0x9c04219cbc45a3915c447f5fefa3ac8878056e2e5780fb12049fd4c55ed360cc;

    let msg_hash = bip322_msg_hash(PUB_KEY, input);

    assert!(verify(PUB_KEY, r, s, msg_hash));
}

#[test]
fn test_bip322_sighash_default_verify_short_msg_success() {
    let mut input: ByteArray = "";

    input.append_byte(0xba);
    input.append_byte(0xbe);

    let r = 0x58b23bf34f410f9da8e82eaf143750525473e274a605db6d123b2a82857a8e3d;
    let s = 0xfd5ab0b79e481a6e5f5fa60f8cc4a1c9f4e2dd7c2206938f32dd712e89dbb9ba;

    let msg_hash = bip322_msg_hash_with_type(SighashType::DEFAULT, PUB_KEY, input);

    assert!(verify(PUB_KEY, r, s, msg_hash));
}

#[test]
fn test_bip322_verify_long_msg_success() {
    let mut input: ByteArray =
        "Forget everything you thought you knew about scaling. We are not iterating; we are building from first principles. While other ecosystems are stuck in the mud of state bloat and centralized sequencers, we are executing on the one true path: verifiable computation. Every single state transition on Starknet is not just processed, it's proven. The elegance of the STARK proof, a cryptographic marvel, underpins our entire architecture. We don't need to hope for validity; we mathematically guarantee it. The Cairo programming language isn't just a new syntax; it's a paradigm shift, a DSL for provable programs that will unlock use cases the EVM can only dream of. We're not just building L2s; we're architecting a fractal future of L3s, L4s, and beyond, where each layer inherits the full security of Ethereum while offering exponential gains in throughput. This is about true composability, where the cost of a function call doesn't depend on gas price auctions but on the raw computational complexity of the task. Our focus is on abstracting away the noise, on delivering a seamless developer experience with account abstraction at the native level, not as a bolted-on afterthought. The future is a constellation of hyper-scaled, interconnected appchains, all settling to Starknet, all secured by Ethereum. This isn't just another blockchain; it's the final frontier of computation. We are the architects of this new digital reality. Execute, prove, scale. This is the way.";

    let r = 0x52cffafb54d8fc578c9de6bac3ff91fb746e6bb3abb94cd1c8baf3098d15de7c;
    let s = 0xfebf73e052d8f28b4124640fd2ce8fde6a153a9081af4124f29d5cf55136c72a;

    let msg_hash = bip322_msg_hash(PUB_KEY, input);

    assert!(verify(PUB_KEY, r, s, msg_hash));
}

#[test]
fn test_bip322_sighash_default_verify_long_msg_success() {
    let mut input: ByteArray =
        "Forget everything you thought you knew about scaling. We are not iterating; we are building from first principles. While other ecosystems are stuck in the mud of state bloat and centralized sequencers, we are executing on the one true path: verifiable computation. Every single state transition on Starknet is not just processed, it's proven. The elegance of the STARK proof, a cryptographic marvel, underpins our entire architecture. We don't need to hope for validity; we mathematically guarantee it. The Cairo programming language isn't just a new syntax; it's a paradigm shift, a DSL for provable programs that will unlock use cases the EVM can only dream of. We're not just building L2s; we're architecting a fractal future of L3s, L4s, and beyond, where each layer inherits the full security of Ethereum while offering exponential gains in throughput. This is about true composability, where the cost of a function call doesn't depend on gas price auctions but on the raw computational complexity of the task. Our focus is on abstracting away the noise, on delivering a seamless developer experience with account abstraction at the native level, not as a bolted-on afterthought. The future is a constellation of hyper-scaled, interconnected appchains, all settling to Starknet, all secured by Ethereum. This isn't just another blockchain; it's the final frontier of computation. We are the architects of this new digital reality. Execute, prove, scale. This is the way.";

    let r = 0x4fc32c433189c49015377b8873d0d2a73690893978520088b1d2a6740a8ef51d;
    let s = 0x7145b09bfc55584144c1f5aad74edf296f13eaaad2c4945af1f4905066a8e4bf;

    let msg_hash = bip322_msg_hash_with_type(SighashType::DEFAULT, PUB_KEY, input);

    assert!(verify(PUB_KEY, r, s, msg_hash));
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
