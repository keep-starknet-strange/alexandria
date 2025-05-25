use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use signature::SignatureTrait;
use starknet::eth_address::EthAddress;
use starknet::secp256_trait::Secp256Trait;
use starknet::secp256k1::Secp256k1Point;
use crate::signature;


#[test]
fn test_verify_eth_signature() {
    let (msg_hash, signature, eth_address) = get_signature_input(true);
    SignatureTrait::verify_signature(msg_hash, signature, eth_address);
}

#[test]
#[should_panic(expected: ('Invalid signature',))]
fn test_verify_eth_signature_wrong_hash() {
    let (msg_hash, signature, eth_address) = get_signature_input(true);
    SignatureTrait::verify_signature(msg_hash + 1, signature, eth_address);
}

#[test]
#[should_panic(expected: ('Signature out of range',))]
fn test_verify_eth_signature_overflowing_signature_s() {
    let mut signature: ByteArray = Default::default();
    signature.append_u256(0x4c8e4fbc1fbb1dece52185e532812c4f7a5f81cf3ee10044320a0d03b62d3e9a);
    signature.append_u256(Secp256Trait::<Secp256k1Point>::get_curve_size() + 1);
    signature.append_byte(0x1b);
    let (msg_hash, _, eth_address) = get_signature_input(true);
    SignatureTrait::verify_signature(msg_hash, signature, eth_address);
}

#[test]
#[should_panic(expected: ('Invalid signature',))]
fn test_verify_eth_signature_wrong_parity() {
    let (msg_hash, signature, eth_address) = get_signature_input(false);
    SignatureTrait::verify_signature(msg_hash, signature, eth_address);
}


fn get_signature_input(parity: bool) -> (u256, ByteArray, EthAddress) {
    let mut msg_hash: u256 = 0xe888fbb4cf9ae6254f19ba12e6d9af54788f195a6f509ca3e934f78d7a71dd85;
    let eth_address: EthAddress = 0x767410c1bb448978bd42b984d7de5970bcaf5c43_u256
        .try_into()
        .unwrap();
    let mut signature: ByteArray = Default::default();
    signature.append_u256(0x4c8e4fbc1fbb1dece52185e532812c4f7a5f81cf3ee10044320a0d03b62d3e9a);
    signature.append_u256(0x4ac5e5c0c0e8a4871583cc131f35fb49c2b7f60e6a8b84965830658f08f7410c);
    if parity {
        signature.append_byte(0x1c); //28
    } else {
        signature.append_byte(0x1b); //27
    }
    (msg_hash, signature, eth_address)
}
