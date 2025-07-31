use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use starknet::eth_address::EthAddress;
use starknet::eth_signature::is_eth_signature_valid;
use starknet::secp256_trait::Signature;

#[generate_trait]
pub impl SignatureImpl of SignatureTrait {
    /// Verifies an Ethereum signature against a message hash and an Ethereum address.
    ///
    /// This function expects a 65-byte signature (r, s, v) in the standard Ethereum format.
    /// It extracts the components, builds a `Signature` struct, and calls the verification routine.
    ///
    /// #### Arguments
    /// * `msg_hash` - The hash of the signed message (typically a Keccak256 hash of a message
    /// prefix + payload).
    /// * `signature` - The 65-byte signature as a `ByteArray`: r (32 bytes) | s (32 bytes) | v (1
    /// byte).
    /// * `eth_address` - The Ethereum address expected to have signed the message.
    fn verify_signature(msg_hash: u256, signature: ByteArray, eth_address: EthAddress) {
        // build Signature
        let mut offset = 0;
        let (offset, r) = signature.read_u256(offset);
        let (offset, s) = signature.read_u256(offset);
        let (_, y) = signature.read_u8(offset);

        let y_parity: bool = if y == 28 {
            true
        } else {
            false
        };

        let sig: Signature = Signature { r, s, y_parity };

        match is_eth_signature_valid(msg_hash, sig, eth_address) {
            Ok(()) => {},
            Err(err) => core::panic_with_felt252(err),
        }
    }
}

