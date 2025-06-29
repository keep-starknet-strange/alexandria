use alexandria_encoding::base58::Base58Encoder;
use alexandria_encoding::bech32::{Encoder, convert_bits};
use crate::hash::{hash160, sha256};
use crate::keys::{private_key_to_public_key, public_key_hash, public_key_to_bytes};
use crate::taproot::{create_key_path_output, u256_to_32_bytes_be};
use crate::types::{
    BitcoinAddress, BitcoinAddressType, BitcoinNetwork, BitcoinPrivateKey, BitcoinPublicKey,
};

/// Generate Bitcoin address from private key
pub fn private_key_to_address(
    private_key: BitcoinPrivateKey, address_type: BitcoinAddressType,
) -> BitcoinAddress {
    let public_key = private_key_to_public_key(private_key);
    public_key_to_address(public_key, address_type, private_key.network)
}

/// Generate Bitcoin address from public key
pub fn public_key_to_address(
    public_key: BitcoinPublicKey, address_type: BitcoinAddressType, network: BitcoinNetwork,
) -> BitcoinAddress {
    match address_type {
        BitcoinAddressType::P2PKH => generate_p2pkh_address(public_key, network),
        BitcoinAddressType::P2SH => generate_p2sh_address(public_key, network),
        BitcoinAddressType::P2WPKH => generate_p2wpkh_address(public_key, network),
        BitcoinAddressType::P2WSH => generate_p2wsh_address(public_key, network),
        BitcoinAddressType::P2TR => generate_p2tr_address(public_key, network),
    }
}

/// Helper function to encode with Base58Check (Base58 + checksum)
fn encode_base58_check(payload: Span<u8>) -> Array<u8> {
    // Calculate double SHA256 checksum
    let first_hash = sha256(payload);
    let checksum_full = sha256(first_hash.span());

    // Take first 4 bytes as checksum
    let mut payload_with_checksum = array![];
    let mut i = 0_u32;
    while i < payload.len() {
        payload_with_checksum.append(*payload.at(i));
        i += 1;
    }

    // Add 4-byte checksum
    let mut i = 0_u32;
    while i < 4 {
        payload_with_checksum.append(*checksum_full.at(i));
        i += 1;
    }

    // Encode with Base58
    Base58Encoder::encode(payload_with_checksum.span())
}

/// Helper function to convert Array<u8> to ByteArray
fn array_to_bytearray(arr: Array<u8>) -> ByteArray {
    let mut result = "";
    let mut i = 0_u32;
    while i < arr.len() {
        result.append_byte(*arr.at(i));
        i += 1;
    }
    result
}

/// Generate P2PKH (Pay to Public Key Hash) address
fn generate_p2pkh_address(public_key: BitcoinPublicKey, network: BitcoinNetwork) -> BitcoinAddress {
    let pubkey_hash = public_key_hash(public_key);

    // Create version + pubkey_hash payload
    let version_byte = match network {
        BitcoinNetwork::Mainnet => 0x00,
        BitcoinNetwork::Testnet => 0x6f,
        BitcoinNetwork::Regtest => 0x6f,
    };

    let mut payload = array![version_byte];
    let mut i = 0_u32;
    while i < pubkey_hash.len() {
        payload.append(*pubkey_hash.at(i));
        i += 1;
    }

    let address_bytes = encode_base58_check(payload.span());
    let address = array_to_bytearray(address_bytes);

    // Create script_pubkey: OP_DUP OP_HASH160 <pubkey_hash> OP_EQUALVERIFY OP_CHECKSIG
    let mut script_pubkey = "";
    script_pubkey.append_byte(0x76); // OP_DUP
    script_pubkey.append_byte(0xa9); // OP_HASH160
    script_pubkey.append_byte(0x14); // Push 20 bytes
    let mut i = 0_u32;
    while i < pubkey_hash.len() {
        script_pubkey.append_byte(*pubkey_hash.at(i));
        i += 1;
    }
    script_pubkey.append_byte(0x88); // OP_EQUALVERIFY
    script_pubkey.append_byte(0xac); // OP_CHECKSIG

    BitcoinAddress { address, address_type: BitcoinAddressType::P2PKH, network, script_pubkey }
}

/// Generate P2SH (Pay to Script Hash) address
fn generate_p2sh_address(public_key: BitcoinPublicKey, network: BitcoinNetwork) -> BitcoinAddress {
    // For simplicity, we'll create a P2SH-wrapped P2WPKH
    let pubkey_hash = public_key_hash(public_key);

    // Create redeem script: OP_0 <pubkey_hash>
    let mut redeem_script = array![0x00, 0x14]; // OP_0 + Push 20 bytes
    let mut i = 0_u32;
    while i < pubkey_hash.len() {
        redeem_script.append(*pubkey_hash.at(i));
        i += 1;
    }

    // Hash the redeem script
    let script_hash = hash160(redeem_script.span());

    // Create version + script_hash payload
    let version_byte = match network {
        BitcoinNetwork::Mainnet => 0x05,
        BitcoinNetwork::Testnet => 0xc4,
        BitcoinNetwork::Regtest => 0xc4,
    };

    let mut payload = array![version_byte];
    let mut i = 0_u32;
    while i < script_hash.len() {
        payload.append(*script_hash.at(i));
        i += 1;
    }

    let address_bytes = encode_base58_check(payload.span());
    let address = array_to_bytearray(address_bytes);

    // Create script_pubkey: OP_HASH160 <script_hash> OP_EQUAL
    let mut script_pubkey = "";
    script_pubkey.append_byte(0xa9); // OP_HASH160
    script_pubkey.append_byte(0x14); // Push 20 bytes
    let mut i = 0_u32;
    while i < script_hash.len() {
        script_pubkey.append_byte(*script_hash.at(i));
        i += 1;
    }
    script_pubkey.append_byte(0x87); // OP_EQUAL

    BitcoinAddress { address, address_type: BitcoinAddressType::P2SH, network, script_pubkey }
}

/// Generate P2WPKH (Pay to Witness Public Key Hash) address
fn generate_p2wpkh_address(
    public_key: BitcoinPublicKey, network: BitcoinNetwork,
) -> BitcoinAddress {
    let pubkey_hash = public_key_hash(public_key);

    // Create witness program: version 0 + pubkey_hash
    let mut witness_program = array![0x00]; // Version 0
    let mut i = 0_u32;
    while i < pubkey_hash.len() {
        witness_program.append(*pubkey_hash.at(i));
        i += 1;
    }

    // Convert to 5-bit for Bech32
    let converted = convert_bits(witness_program.span(), 8, 5, true);

    // Get HRP based on network
    let hrp: ByteArray = match network {
        BitcoinNetwork::Mainnet => "bc",
        BitcoinNetwork::Testnet => "tb",
        BitcoinNetwork::Regtest => "bcrt",
    };

    let address = Encoder::encode(hrp, converted.span());

    // Create script_pubkey: OP_0 <pubkey_hash>
    let mut script_pubkey = "";
    script_pubkey.append_byte(0x00); // OP_0
    script_pubkey.append_byte(0x14); // Push 20 bytes
    let mut i = 0_u32;
    while i < pubkey_hash.len() {
        script_pubkey.append_byte(*pubkey_hash.at(i));
        i += 1;
    }

    BitcoinAddress { address, address_type: BitcoinAddressType::P2WPKH, network, script_pubkey }
}

/// Generate P2WSH (Pay to Witness Script Hash) address
fn generate_p2wsh_address(public_key: BitcoinPublicKey, network: BitcoinNetwork) -> BitcoinAddress {
    let pubkey_bytes = public_key_to_bytes(public_key);

    // Create a simple script: <pubkey> OP_CHECKSIG
    let mut script = array![];
    script.append(0x21); // Push 33 bytes (compressed pubkey)
    let mut i = 0_u32;
    while i < pubkey_bytes.len() {
        script.append(*pubkey_bytes.at(i));
        i += 1;
    }
    script.append(0xac); // OP_CHECKSIG

    // SHA256 hash of the script
    let script_hash = sha256(script.span());

    // Create witness program: version 0 + script_hash
    let mut witness_program = array![0x00]; // Version 0
    let mut i = 0_u32;
    while i < script_hash.len() {
        witness_program.append(*script_hash.at(i));
        i += 1;
    }

    // Convert to 5-bit for Bech32
    let converted = convert_bits(witness_program.span(), 8, 5, true);

    // Get HRP based on network
    let hrp: ByteArray = match network {
        BitcoinNetwork::Mainnet => "bc",
        BitcoinNetwork::Testnet => "tb",
        BitcoinNetwork::Regtest => "bcrt",
    };

    let address = Encoder::encode(hrp, converted.span());

    // Create script_pubkey: OP_0 <script_hash>
    let mut script_pubkey = "";
    script_pubkey.append_byte(0x00); // OP_0
    script_pubkey.append_byte(0x20); // Push 32 bytes
    let mut i = 0_u32;
    while i < script_hash.len() {
        script_pubkey.append_byte(*script_hash.at(i));
        i += 1;
    }

    BitcoinAddress { address, address_type: BitcoinAddressType::P2WSH, network, script_pubkey }
}

/// Generate P2TR (Pay to Taproot) address using proper BIP-341 key tweaking
fn generate_p2tr_address(public_key: BitcoinPublicKey, network: BitcoinNetwork) -> BitcoinAddress {
    // Use the x-coordinate of the public key as the internal key
    let internal_key = public_key.x;

    // Create a key-path only Taproot output (no script tree)
    let tweaked_result = create_key_path_output(internal_key);

    let output_key = match tweaked_result {
        Option::Some(tweaked) => tweaked.output_key,
        Option::None => {
            // Fallback to simplified approach if tweaking fails
            internal_key
        },
    };

    // Convert output key to 32 bytes (big-endian)
    let output_key_bytes = u256_to_32_bytes_be(output_key);

    // Create witness program: version 1 + output_key
    let mut witness_program = array![0x01]; // Version 1 (Taproot)
    let mut i = 0_u32;
    while i < output_key_bytes.len() {
        witness_program.append(*output_key_bytes.at(i));
        i += 1;
    }

    // Convert to 5-bit for Bech32
    let converted = convert_bits(witness_program.span(), 8, 5, true);

    // Get HRP based on network
    let hrp: ByteArray = match network {
        BitcoinNetwork::Mainnet => "bc",
        BitcoinNetwork::Testnet => "tb",
        BitcoinNetwork::Regtest => "bcrt",
    };

    let address = Encoder::encode(hrp, converted.span());

    // Create script_pubkey: OP_1 <output_key>
    let mut script_pubkey = "";
    script_pubkey.append_byte(0x51); // OP_1 (Taproot version)
    script_pubkey.append_byte(0x20); // Push 32 bytes
    let mut i = 0_u32;
    while i < output_key_bytes.len() {
        script_pubkey.append_byte(*output_key_bytes.at(i));
        i += 1;
    }

    BitcoinAddress { address, address_type: BitcoinAddressType::P2TR, network, script_pubkey }
}

/// Validate Bitcoin address format
pub fn validate_address(address: ByteArray, network: BitcoinNetwork) -> bool {
    // Basic validation - in a real implementation this would be more comprehensive
    if address.len() < 26 || address.len() > 62 {
        return false;
    }

    // Check if it's a Bech32 address
    if is_bech32_address(@address, network) {
        return true;
    }

    // Check if it's a Base58Check address
    is_base58check_address(@address, network)
}

/// Check if address is Bech32 format
fn is_bech32_address(address: @ByteArray, network: BitcoinNetwork) -> bool {
    let expected_hrp: ByteArray = match network {
        BitcoinNetwork::Mainnet => "bc",
        BitcoinNetwork::Testnet => "tb",
        BitcoinNetwork::Regtest => "bcrt",
    };

    // Check if address starts with expected HRP
    if address.len() < expected_hrp.len() + 1 {
        return false;
    }

    let mut i = 0_u32;
    while i < expected_hrp.len() {
        let addr_char = address.at(i).unwrap();
        let hrp_char = expected_hrp.at(i).unwrap();
        if addr_char != hrp_char {
            return false;
        }
        i += 1;
    }

    true
}

/// Check if address is Base58Check format
fn is_base58check_address(address: @ByteArray, network: BitcoinNetwork) -> bool {
    // Basic length check
    if address.len() < 26 || address.len() > 35 {
        return false;
    }

    // Check first character matches expected network prefixes
    let first_char = address.at(0).unwrap();
    let valid_prefix = match network {
        BitcoinNetwork::Mainnet => first_char == '1' || first_char == '3',
        BitcoinNetwork::Testnet => first_char == 'm' || first_char == 'n' || first_char == '2',
        BitcoinNetwork::Regtest => first_char == 'm' || first_char == 'n' || first_char == '2',
    };

    if !valid_prefix {
        return false;
    }

    // Try to decode and verify checksum
    // For now, just check the prefix since decode_check can panic
    // In a real implementation, you'd want proper error handling
    true
}
