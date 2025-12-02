use alexandria_btc::address::create_p2wpkh_script_pubkey;
use alexandria_btc::bip322::{
    SighashType, bip322_msg_hash_p2tr, bip322_msg_hash_p2tr_with_type, bip322_msg_hash_p2wpkh,
    build_to_sign_tx, build_to_spend_tx, tweak_public_key,
};
use alexandria_btc::bip340::verify;
use alexandria_btc::encoder::TransactionEncoderTrait;
use alexandria_btc::hash::{hash160_from_byte_array, hash256_from_byte_array};
use alexandria_btc::legacy_signature::verify_ecdsa_signature_auto_recovery;
use alexandria_btc::taproot::u256_to_32_bytes_be;
use alexandria_btc::types::{BitcoinPublicKey, BitcoinPublicKeyTrait, BitcoinTransaction};
use alexandria_bytes::byte_array_ext::{ByteArrayTraitExt, SpanU8IntoByteArray};

const PUB_KEY: u256 = 0x08c80f3bf06bcc87154dcd3cf294aada4ee9b3218d4ba60e2bbaf91c17d351ee;
const BIP322_VECTOR_PUBKEY_X: u256 =
    0xc7f12003196442943d8588e01aee840423cc54fc1521526a3b85c2b0cbd58872;
// Reference: BIP-322 test vectors (https://bips.dev/322/). The published txids are shown
// in Bitcoin's display (little-endian) order, so the constants below are converted to the
// big-endian byte order returned by our double-SHA256 helper.
const BIP322_TO_SPEND_TXID_EMPTY: u256 =
    0xa7995a543c2866b51ba965e78d01de5db50435cde9d482bf60d8b89ba60a68c5;
const BIP322_TO_SPEND_TXID_HELLO: u256 =
    0x2b3503d6a2614deaf1716c23325c53e0514b4afc98101c771752ad4067199db7;
const BIP322_TO_SIGN_TXID_EMPTY: u256 =
    0xd6aeebaaa38b63df1efedcca1de8278ad77fc6e64d4c60c844baa551e954961e;
const BIP322_TO_SIGN_TXID_HELLO: u256 =
    0xdfbd939d8c5c9c148c9811a5af568dcba1e93a154bcc935f1477206fe87a7388;


fn bip322_vector_public_key() -> BitcoinPublicKey {
    BitcoinPublicKeyTrait::from_x_coordinate(BIP322_VECTOR_PUBKEY_X, true)
}

fn bip322_vector_script_pubkey() -> ByteArray {
    let public_key = bip322_vector_public_key();
    let pubkey_bytes = public_key.bytes.clone();
    let pubkey_hash = hash160_from_byte_array(@pubkey_bytes);

    create_p2wpkh_script_pubkey(pubkey_hash)
}

fn bip322_to_spend_tx_hash(message: ByteArray) -> ByteArray {
    let script_pubkey = bip322_vector_script_pubkey();
    let to_spend_tx = build_to_spend_tx(@message, @script_pubkey);

    serialize_and_hash_transaction(to_spend_tx)
}

fn bip322_to_sign_tx_hash(message: ByteArray) -> ByteArray {
    let script_pubkey = bip322_vector_script_pubkey();
    let to_spend_tx = build_to_spend_tx(@message, @script_pubkey);
    let to_spend_tx_id = serialize_and_hash_transaction(to_spend_tx);
    let to_sign_tx = build_to_sign_tx(to_spend_tx_id, script_pubkey.clone(), true);

    serialize_and_hash_transaction(to_sign_tx)
}

fn serialize_and_hash_transaction(tx: BitcoinTransaction) -> ByteArray {
    // BIP-322 test vectors have the tx_has of the to_sign transaction without the witness
    // so we strip the witness to verify correct transaction building
    let tx_to_hash = if tx.is_segwit {
        BitcoinTransaction {
            version: tx.version,
            inputs: tx.inputs,
            outputs: tx.outputs,
            locktime: tx.locktime,
            witness: array![],
            is_segwit: false,
        }
    } else {
        tx
    };

    let mut encoder = TransactionEncoderTrait::new();
    let serialized = encoder.encode_transaction(tx_to_hash);
    hash256_from_byte_array(@serialized).span().into()
}


#[test]
fn test_bip322_tweak_public_key() {
    assert!(
        tweak_public_key(
            BIP322_VECTOR_PUBKEY_X,
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

    let msg_hash = bip322_msg_hash_p2tr(PUB_KEY, input);

    assert!(verify(PUB_KEY, r, s, msg_hash));
}

#[test]
fn test_bip322_sighash_default_verify_short_msg_success() {
    let mut input: ByteArray = "";

    input.append_byte(0xba);
    input.append_byte(0xbe);

    let r = 0x58b23bf34f410f9da8e82eaf143750525473e274a605db6d123b2a82857a8e3d;
    let s = 0xfd5ab0b79e481a6e5f5fa60f8cc4a1c9f4e2dd7c2206938f32dd712e89dbb9ba;

    let msg_hash = bip322_msg_hash_p2tr_with_type(SighashType::DEFAULT, PUB_KEY, input);

    assert!(verify(PUB_KEY, r, s, msg_hash));
}

#[test]
fn test_bip322_verify_long_msg_success() {
    let mut input: ByteArray =
        "Forget everything you thought you knew about scaling. We are not iterating; we are building from first principles. While other ecosystems are stuck in the mud of state bloat and centralized sequencers, we are executing on the one true path: verifiable computation. Every single state transition on Starknet is not just processed, it's proven. The elegance of the STARK proof, a cryptographic marvel, underpins our entire architecture. We don't need to hope for validity; we mathematically guarantee it. The Cairo programming language isn't just a new syntax; it's a paradigm shift, a DSL for provable programs that will unlock use cases the EVM can only dream of. We're not just building L2s; we're architecting a fractal future of L3s, L4s, and beyond, where each layer inherits the full security of Ethereum while offering exponential gains in throughput. This is about true composability, where the cost of a function call doesn't depend on gas price auctions but on the raw computational complexity of the task. Our focus is on abstracting away the noise, on delivering a seamless developer experience with account abstraction at the native level, not as a bolted-on afterthought. The future is a constellation of hyper-scaled, interconnected appchains, all settling to Starknet, all secured by Ethereum. This isn't just another blockchain; it's the final frontier of computation. We are the architects of this new digital reality. Execute, prove, scale. This is the way.";

    let r = 0x52cffafb54d8fc578c9de6bac3ff91fb746e6bb3abb94cd1c8baf3098d15de7c;
    let s = 0xfebf73e052d8f28b4124640fd2ce8fde6a153a9081af4124f29d5cf55136c72a;

    let msg_hash = bip322_msg_hash_p2tr(PUB_KEY, input);

    assert!(verify(PUB_KEY, r, s, msg_hash));
}

#[test]
fn test_bip322_sighash_default_verify_long_msg_success() {
    let mut input: ByteArray =
        "Forget everything you thought you knew about scaling. We are not iterating; we are building from first principles. While other ecosystems are stuck in the mud of state bloat and centralized sequencers, we are executing on the one true path: verifiable computation. Every single state transition on Starknet is not just processed, it's proven. The elegance of the STARK proof, a cryptographic marvel, underpins our entire architecture. We don't need to hope for validity; we mathematically guarantee it. The Cairo programming language isn't just a new syntax; it's a paradigm shift, a DSL for provable programs that will unlock use cases the EVM can only dream of. We're not just building L2s; we're architecting a fractal future of L3s, L4s, and beyond, where each layer inherits the full security of Ethereum while offering exponential gains in throughput. This is about true composability, where the cost of a function call doesn't depend on gas price auctions but on the raw computational complexity of the task. Our focus is on abstracting away the noise, on delivering a seamless developer experience with account abstraction at the native level, not as a bolted-on afterthought. The future is a constellation of hyper-scaled, interconnected appchains, all settling to Starknet, all secured by Ethereum. This isn't just another blockchain; it's the final frontier of computation. We are the architects of this new digital reality. Execute, prove, scale. This is the way.";

    let r = 0x4fc32c433189c49015377b8873d0d2a73690893978520088b1d2a6740a8ef51d;
    let s = 0x7145b09bfc55584144c1f5aad74edf296f13eaaad2c4945af1f4905066a8e4bf;

    let msg_hash = bip322_msg_hash_p2tr_with_type(SighashType::DEFAULT, PUB_KEY, input);

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

    let msg_hash = bip322_msg_hash_p2tr(pub_key, input);

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

    let msg_hash = bip322_msg_hash_p2tr(pub_key, input);

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

    let msg_hash = bip322_msg_hash_p2tr(pub_key, input);

    assert!(!verify(pub_key, r, s, msg_hash));
}

#[test]
fn test_bip322_p2wpkh_hash_matches_reference() {
    let message: ByteArray = "Hello World";
    let compressed_public_key = bip322_vector_public_key();

    let hash = bip322_msg_hash_p2wpkh(compressed_public_key, message);

    let expected_hex: u256 = 0xaf8a0cd31d9b0976e2aab2b82974c4388c4a3532b2ef828b96f14039ca372c14;
    let expected_hex_bytes: ByteArray = u256_to_32_bytes_be(expected_hex).span().into();
    assert!(hash == expected_hex_bytes);
}

#[test]
fn test_bip322_to_spend_tx_hash_empty_message() {
    let message: ByteArray = "";
    let expected_bytes: ByteArray = u256_to_32_bytes_be(BIP322_TO_SPEND_TXID_EMPTY).span().into();
    let hash = bip322_to_spend_tx_hash(message);

    assert!(hash == expected_bytes);
}

#[test]
fn test_bip322_to_spend_tx_hash_hello_world() {
    let message: ByteArray = "Hello World";
    let expected_bytes: ByteArray = u256_to_32_bytes_be(BIP322_TO_SPEND_TXID_HELLO).span().into();
    let hash = bip322_to_spend_tx_hash(message);

    assert!(hash == expected_bytes);
}

#[test]
fn test_bip322_to_sign_tx_hash_empty_message() {
    let message: ByteArray = "";
    let expected_bytes: ByteArray = u256_to_32_bytes_be(BIP322_TO_SIGN_TXID_EMPTY).span().into();
    let hash = bip322_to_sign_tx_hash(message);

    assert!(hash == expected_bytes);
}

#[test]
fn test_bip322_to_sign_tx_hash_hello_world() {
    let message: ByteArray = "Hello World";
    let expected_bytes: ByteArray = u256_to_32_bytes_be(BIP322_TO_SIGN_TXID_HELLO).span().into();
    let hash = bip322_to_sign_tx_hash(message);

    assert!(hash == expected_bytes);
}

#[test]
fn test_bip322_p2wpkh_signature_verifies_with_legacy() {
    let message: ByteArray = "Hello World";
    let compressed_public_key = bip322_vector_public_key();

    // Build the SegWit v0 message hash using the standard BIP-322 flow
    let msg_hash_bytes = bip322_msg_hash_p2wpkh(compressed_public_key.clone(), message);
    let (_, msg_hash_u256) = ByteArrayTraitExt::read_u256(@msg_hash_bytes, 0);
    let expected_msg_hash: u256 =
        0xaf8a0cd31d9b0976e2aab2b82974c4388c4a3532b2ef828b96f14039ca372c14;
    assert!(msg_hash_u256 == expected_msg_hash, "Message hash mismatch vs reference");

    let pubkey_x = 0xc7f12003196442943d8588e01aee840423cc54fc1521526a3b85c2b0cbd58872;
    let pubkey_y = 0xe18b74c078d89c58ea278942bcc26563f976d0cc31b5a4cedfa42c716b83b1fe;
    let full_public_key = BitcoinPublicKeyTrait::from_coordinates(pubkey_x, pubkey_y);

    // BIP-322 reference signature (parsed form)
    let r: u256 = 0x6517c8637a7bfc3a154edcba6196d64bbd5b73955cb7da7d1626bcdde466c364;
    let s: u256 = 0x22bf10d19fc0bb69b4596e306b362acaa835293cf693bb176f7324b531f5afec;

    assert!(
        verify_ecdsa_signature_auto_recovery(msg_hash_u256, r, s, full_public_key),
        "BIP-322 signature should verify against legacy verifier",
    );
}

