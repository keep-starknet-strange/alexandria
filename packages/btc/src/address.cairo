use alexandria_bytes::byte_array_ext::SpanU8IntoByteArray;
use alexandria_encoding::base58::Base58Encoder;
use alexandria_encoding::bech32::{Encoder, convert_bits, get_bech32_char};
use alexandria_encoding::bech32m;
use crate::hash::{hash160, sha256};
use crate::keys::{private_key_to_public_key, public_key_hash, public_key_to_bytes};
use crate::taproot::{create_key_path_output, u256_to_32_bytes_be};
use crate::types::{
    BitcoinAddress, BitcoinAddressType, BitcoinNetwork, BitcoinPrivateKey, BitcoinPublicKey,
    BitcoinPublicKeyTrait,
};

/// Generates a Bitcoin address from a private key for the specified address type.
///
/// This function derives the public key from the private key and generates
/// the corresponding Bitcoin address based on the specified address type.
///
/// #### Arguments
/// * `private_key` - The Bitcoin private key containing the key data, network, and compression flag
/// * `address_type` - The type of Bitcoin address to generate (P2PKH, P2SH, P2WPKH, P2WSH, P2TR)
///
/// #### Returns
/// * `BitcoinAddress` - Complete address structure with encoded address, script, and metadata
pub fn private_key_to_address(
    private_key: BitcoinPrivateKey, address_type: BitcoinAddressType,
) -> BitcoinAddress {
    let public_key = private_key_to_public_key(private_key);

    public_key_to_address(public_key, address_type, private_key.network)
}

/// Generates a Bitcoin address from a public key for the specified address type and network.
///
/// This is the primary address generation function that handles all Bitcoin address types
/// including legacy (P2PKH, P2SH) and SegWit (P2WPKH, P2WSH, P2TR) formats.
///
/// #### Arguments
/// * `public_key` - The Bitcoin public key (x, y coordinates and compression flag)
/// * `address_type` - The type of Bitcoin address to generate
/// * `network` - The Bitcoin network (Mainnet, Testnet, or Regtest)
///
/// #### Returns
/// * `BitcoinAddress` - Complete address structure including encoded address and script_pubkey
///
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

/// Encodes data using Base58Check encoding (Base58 with checksum).
///
/// Implements the Bitcoin Base58Check encoding standard by appending a 4-byte
/// checksum (first 4 bytes of double SHA256) to the payload and encoding with Base58.
///
/// #### Arguments
/// * `payload` - The data to encode (version byte + hash)
///
/// #### Returns
/// * `Array<u8>` - Base58Check encoded address bytes
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

/// Generates a P2PKH (Pay to Public Key Hash) legacy Bitcoin address.
///
/// Creates a traditional Bitcoin address by hashing the public key (HASH160)
/// and encoding it with Base58Check using the appropriate network version byte.
///
/// #### Arguments
/// * `public_key` - The Bitcoin public key to generate address from
/// * `network` - The Bitcoin network (affects version byte)
///
/// #### Returns
/// * `BitcoinAddress` - P2PKH address with corresponding script_pubkey
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
    let address: ByteArray = address_bytes.span().into();

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

/// Generates a P2SH (Pay to Script Hash) address with P2SH-wrapped P2WPKH.
///
/// Creates a P2SH address containing a P2WPKH redeem script, which allows
/// SegWit functionality while maintaining compatibility with older wallets.
///
/// #### Arguments
/// * `public_key` - The Bitcoin public key to generate address from
/// * `network` - The Bitcoin network (affects version byte)
///
/// #### Returns
/// * `BitcoinAddress` - P2SH address with corresponding script_pubkey
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
    let address: ByteArray = address_bytes.span().into();

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

/// Generates a P2WPKH (Pay to Witness Public Key Hash) SegWit address.
///
/// Creates a native SegWit address using Bech32 encoding. This is the most
/// efficient address type for single-signature transactions.
///
/// #### Arguments
/// * `public_key` - The Bitcoin public key to generate address from
/// * `network` - The Bitcoin network (affects HRP: bc/tb/bcrt)
///
/// #### Returns
/// * `BitcoinAddress` - P2WPKH address with corresponding script_pubkey
fn generate_p2wpkh_address(
    public_key: BitcoinPublicKey, network: BitcoinNetwork,
) -> BitcoinAddress {
    let pubkey_hash = public_key_hash(public_key);

    // Convert raw data bytes into 5-bit groups
    let data_5bit: Array<u8> = convert_bits(pubkey_hash.span(), 8, 5, true);

    // Prepend version as 5-bit (0 for v0)
    let mut data = array![0_u8];
    let mut i = 0_u32;

    while i < data_5bit.len() {
        data.append(*data_5bit.at(i));

        i += 1;
    }

    let hrp: ByteArray = match network {
        BitcoinNetwork::Mainnet => "bc",
        BitcoinNetwork::Testnet => "tb",
        BitcoinNetwork::Regtest => "bcrt",
    };
    let address = Encoder::encode(hrp, data.span());
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

/// Generates a P2WSH (Pay to Witness Script Hash) SegWit address.
///
/// Creates a native SegWit address for script-based spending using Bech32 encoding.
/// Uses a simple <pubkey> OP_CHECKSIG script for demonstration.
///
/// #### Arguments
/// * `public_key` - The Bitcoin public key to create the script from
/// * `network` - The Bitcoin network (affects HRP: bc/tb/bcrt)
///
/// #### Returns
/// * `BitcoinAddress` - P2WSH address with corresponding script_pubkey
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

    // Convert script_hash to 5-bit groups
    let data_5bit = convert_bits(script_hash.span(), 8, 5, true);

    // Prepend version as 5-bit (0 for v0)
    let mut data = array![0_u8];
    let mut i = 0_u32;

    while i < data_5bit.len() {
        data.append(*data_5bit.at(i));

        i += 1;
    }

    // Get HRP based on network
    let hrp: ByteArray = match network {
        BitcoinNetwork::Mainnet => "bc",
        BitcoinNetwork::Testnet => "tb",
        BitcoinNetwork::Regtest => "bcrt",
    };

    let address = Encoder::encode(hrp, data.span());

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

/// Generates a P2TR (Pay to Taproot) SegWit v1 address using BIP-341 key tweaking.
///
/// Creates a Taproot address using the public key as the internal key with
/// proper BIP-341 tweaking for key-path spending. Uses Bech32m encoding.
///
/// #### Arguments
/// * `public_key` - The Bitcoin public key to use as internal key
/// * `network` - The Bitcoin network (affects HRP: bc/tb/bcrt)
///
/// #### Returns
/// * `BitcoinAddress` - P2TR address with corresponding script_pubkey
fn generate_p2tr_address(public_key: BitcoinPublicKey, network: BitcoinNetwork) -> BitcoinAddress {
    // Use the x-coordinate of the public key as the internal key
    let internal_key = public_key.get_x_coordinate();

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

    // For P2TR, we need to manually prepare the data for Bech32m:
    // 1. Convert output_key_bytes (32 bytes) to 5-bit representation
    // 2. Prepend witness version (1) as a 5-bit value
    // 3. Encode with Bech32m

    // Convert output key to 5-bit
    let output_key_5bit = convert_bits(output_key_bytes.span(), 8, 5, true);

    // Prepend witness version 1 as 5-bit value
    let mut witness_data = array![1_u8]; // Witness version 1
    let mut i = 0_u32;

    while i < output_key_5bit.len() {
        witness_data.append(*output_key_5bit.at(i));

        i += 1;
    }

    // Get HRP based on network
    let hrp: ByteArray = match network {
        BitcoinNetwork::Mainnet => "bc",
        BitcoinNetwork::Testnet => "tb",
        BitcoinNetwork::Regtest => "bcrt",
    };

    // Encode using Bech32m - pass 5-bit data directly, not 8-bit
    // We need to build the address manually since bech32m::encode expects 8-bit input
    let address = encode_bech32m_with_5bit_data(hrp, witness_data.span());

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

/// Encode Bech32m with 5-bit data (not 8-bit)
/// This is a special case for witness v1+ addresses where data is already in 5-bit format
fn encode_bech32m_with_5bit_data(hrp: ByteArray, data_5bit: Span<u8>) -> ByteArray {
    // Use the bech32m checksum calculation from the encoding package
    let checksum = bech32m::compute_bech32m_checksum(hrp.clone(), data_5bit);

    // Build address: hrp + '1' + data_chars + checksum_chars
    let mut result = hrp;

    // separator
    result.append_byte('1');

    // Append data characters
    let mut i = 0_u32;

    while i < data_5bit.len() {
        let val = *data_5bit.at(i);

        result.append_byte(get_bech32_char(val));

        i += 1;
    }

    // Append checksum characters
    let mut i = 0_u32;

    while i < checksum.len() {
        let val = *checksum.at(i);

        result.append_byte(get_bech32_char(val));

        i += 1;
    }

    result
}

/// Validates a Bitcoin address format for the specified network.
///
/// Performs basic format validation for both legacy (Base58Check) and
/// SegWit (Bech32/Bech32m) address formats. Checks length, prefixes, and
/// basic structural requirements.
///
/// #### Arguments
/// * `address` - The Bitcoin address string to validate
/// * `network` - The expected Bitcoin network
///
/// #### Returns
/// * `bool` - True if the address format appears valid, false otherwise
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

/// Checks if an address uses Bech32 format (SegWit addresses).
///
/// Validates that the address starts with the correct Human Readable Part (HRP)
/// for the specified network: 'bc' for mainnet, 'tb' for testnet, 'bcrt' for regtest.
///
/// #### Arguments
/// * `address` - Reference to the address to check
/// * `network` - The Bitcoin network to validate against
///
/// #### Returns
/// * `bool` - True if address appears to be Bech32 format, false otherwise
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

/// Checks if an address uses Base58Check format (legacy addresses).
///
/// Validates basic structure including length and network-specific prefixes:
/// Mainnet: '1' (P2PKH) or '3' (P2SH)
/// Testnet/Regtest: 'm', 'n' (P2PKH) or '2' (P2SH)
///
/// #### Arguments
/// * `address` - Reference to the address to check
/// * `network` - The Bitcoin network to validate against
///
/// #### Returns
/// * `bool` - True if address appears to be Base58Check format, false otherwise
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

    // See decode and verify checksum
    true
}
