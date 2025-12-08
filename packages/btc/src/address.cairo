use alexandria_bytes::byte_array_ext::{ByteArrayIntoArrayU8, SpanU8IntoByteArray};
use alexandria_encoding::base58::{Base58Decoder, Base58Encoder};
use alexandria_encoding::bech32::{Decoder as Bech32Decoder, Encoder, convert_bits, get_bech32_char};
use alexandria_encoding::bech32m::{Decoder as Bech32mDecoder, compute_bech32m_checksum};
use crate::hash::{hash160, hash256, sha256};
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
        BitcoinAddressType::P2PKH => {
            let pubkey_hash = public_key_hash(public_key);
            generate_p2pkh_address(pubkey_hash, network)
        },
        BitcoinAddressType::P2SH => {
            let pubkey_hash = public_key_hash(public_key);
            generate_p2sh_address(pubkey_hash, network)
        },
        BitcoinAddressType::P2WPKH => {
            let pubkey_hash = public_key_hash(public_key);
            generate_p2wpkh_address(pubkey_hash, network)
        },
        BitcoinAddressType::P2WSH => generate_p2wsh_address(public_key, network),
        BitcoinAddressType::P2TR => generate_p2tr_address(public_key, network),
    }
}

/// Generates a Bitcoin address from a public key hash for the specified address type and network.
///
/// This function generates addresses for address types that can be derived directly from
/// a public key hash: P2PKH, P2SH, and P2WPKH. For P2WSH and P2TR, use `public_key_to_address`
/// instead as they require additional information beyond the pubkey hash.
///
/// #### Arguments
/// * `pubkey_hash` - The 20-byte public key hash (HASH160 of public key)
/// * `address_type` - The type of Bitcoin address to generate (P2PKH, P2SH, or P2WPKH)
/// * `network` - The Bitcoin network (Mainnet, Testnet, or Regtest)
///
/// #### Returns
/// * `BitcoinAddress` - Complete address structure including encoded address and script_pubkey
///
/// #### Panics
/// Panics if address_type is P2WSH or P2TR (use `public_key_to_address` for these types)
pub fn pubkey_hash_to_address(
    pubkey_hash: Array<u8>, address_type: BitcoinAddressType, network: BitcoinNetwork,
) -> BitcoinAddress {
    match address_type {
        BitcoinAddressType::P2PKH => generate_p2pkh_address(pubkey_hash, network),
        BitcoinAddressType::P2SH => generate_p2sh_address(pubkey_hash, network),
        BitcoinAddressType::P2WPKH => generate_p2wpkh_address(pubkey_hash, network),
        BitcoinAddressType::P2WSH => panic!("P2WSH requires public key, not just pubkey hash"),
        BitcoinAddressType::P2TR => panic!("P2TR requires public key, not just pubkey hash"),
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

/// Creates a P2PKH script_pubkey from a public key hash.
///
/// Generates the standard P2PKH script: OP_DUP OP_HASH160 <pubkey_hash> OP_EQUALVERIFY OP_CHECKSIG
///
/// #### Arguments
/// * `pubkey_hash` - The 20-byte public key hash
///
/// #### Returns
/// * `ByteArray` - The script_pubkey as a ByteArray
pub fn create_p2pkh_script_pubkey(pubkey_hash: Array<u8>) -> ByteArray {
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
    script_pubkey
}

/// Creates a P2SH script_pubkey from a script hash.
///
/// Generates the standard P2SH script: OP_HASH160 <script_hash> OP_EQUAL
///
/// #### Arguments
/// * `script_hash` - The 20-byte script hash
///
/// #### Returns
/// * `ByteArray` - The script_pubkey as a ByteArray
pub fn create_p2sh_script_pubkey(script_hash: Array<u8>) -> ByteArray {
    let mut script_pubkey = "";
    script_pubkey.append_byte(0xa9); // OP_HASH160
    script_pubkey.append_byte(0x14); // Push 20 bytes
    let mut i = 0_u32;
    while i < script_hash.len() {
        script_pubkey.append_byte(*script_hash.at(i));
        i += 1;
    }
    script_pubkey.append_byte(0x87); // OP_EQUAL
    script_pubkey
}

/// Creates a P2WPKH script_pubkey from a public key hash.
///
/// Generates the standard P2WPKH script: OP_0 <pubkey_hash>
///
/// #### Arguments
/// * `pubkey_hash` - The 20-byte public key hash
///
/// #### Returns
/// * `ByteArray` - The script_pubkey as a ByteArray
pub fn create_p2wpkh_script_pubkey(pubkey_hash: Array<u8>) -> ByteArray {
    let mut script_pubkey = "";
    script_pubkey.append_byte(0x00); // OP_0
    script_pubkey.append_byte(0x14); // Push 20 bytes
    let mut i = 0_u32;
    while i < pubkey_hash.len() {
        script_pubkey.append_byte(*pubkey_hash.at(i));
        i += 1;
    }
    script_pubkey
}

/// Creates a P2WSH script_pubkey from a script hash.
///
/// Generates the standard P2WSH script: OP_0 <script_hash>
///
/// #### Arguments
/// * `script_hash` - The 32-byte script hash
///
/// #### Returns
/// * `ByteArray` - The script_pubkey as a ByteArray
pub fn create_p2wsh_script_pubkey(script_hash: Array<u8>) -> ByteArray {
    let mut script_pubkey = "";
    script_pubkey.append_byte(0x00); // OP_0
    script_pubkey.append_byte(0x20); // Push 32 bytes
    let mut i = 0_u32;
    while i < script_hash.len() {
        script_pubkey.append_byte(*script_hash.at(i));
        i += 1;
    }
    script_pubkey
}

/// Creates a P2TR script_pubkey from an output key.
///
/// Generates the standard P2TR script: OP_1 <output_key>
///
/// #### Arguments
/// * `output_key` - The 32-byte Taproot output key
///
/// #### Returns
/// * `ByteArray` - The script_pubkey as a ByteArray
pub fn create_p2tr_script_pubkey(output_key: Array<u8>) -> ByteArray {
    let mut script_pubkey = "";
    script_pubkey.append_byte(0x51); // OP_1 (Taproot version)
    script_pubkey.append_byte(0x20); // Push 32 bytes
    let mut i = 0_u32;
    while i < output_key.len() {
        script_pubkey.append_byte(*output_key.at(i));
        i += 1;
    }
    script_pubkey
}

/// Generates a P2PKH (Pay to Public Key Hash) legacy Bitcoin address.
///
/// Creates a traditional Bitcoin address by hashing the public key (HASH160)
/// and encoding it with Base58Check using the appropriate network version byte.
///
/// #### Arguments
/// * `pubkey_hash` - The 20-byte public key hash (HASH160 of public key)
/// * `network` - The Bitcoin network (affects version byte)
///
/// #### Returns
/// * `BitcoinAddress` - P2PKH address with corresponding script_pubkey
fn generate_p2pkh_address(pubkey_hash: Array<u8>, network: BitcoinNetwork) -> BitcoinAddress {
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

    let script_pubkey = create_p2pkh_script_pubkey(pubkey_hash);

    BitcoinAddress { address, address_type: BitcoinAddressType::P2PKH, network, script_pubkey }
}

/// Generates a P2SH (Pay to Script Hash) address with P2SH-wrapped P2WPKH.
///
/// Creates a P2SH address containing a P2WPKH redeem script, which allows
/// SegWit functionality while maintaining compatibility with older wallets.
///
/// #### Arguments
/// * `pubkey_hash` - The 20-byte public key hash (HASH160 of public key)
/// * `network` - The Bitcoin network (affects version byte)
///
/// #### Returns
/// * `BitcoinAddress` - P2SH address with corresponding script_pubkey
fn generate_p2sh_address(pubkey_hash: Array<u8>, network: BitcoinNetwork) -> BitcoinAddress {
    // For simplicity, we'll create a P2SH-wrapped P2WPKH

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

    let script_pubkey = create_p2sh_script_pubkey(script_hash);

    BitcoinAddress { address, address_type: BitcoinAddressType::P2SH, network, script_pubkey }
}

/// Generates a P2WPKH (Pay to Witness Public Key Hash) SegWit address.
///
/// Creates a native SegWit address using Bech32 encoding. This is the most
/// efficient address type for single-signature transactions.
///
/// #### Arguments
/// * `pubkey_hash` - The 20-byte public key hash (HASH160 of public key)
/// * `network` - The Bitcoin network (affects HRP: bc/tb/bcrt)
///
/// #### Returns
/// * `BitcoinAddress` - P2WPKH address with corresponding script_pubkey
fn generate_p2wpkh_address(pubkey_hash: Array<u8>, network: BitcoinNetwork) -> BitcoinAddress {
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
    let script_pubkey = create_p2wpkh_script_pubkey(pubkey_hash);

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
    let script_pubkey = create_p2wsh_script_pubkey(script_hash);

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
    let script_pubkey = create_p2tr_script_pubkey(output_key_bytes);

    BitcoinAddress { address, address_type: BitcoinAddressType::P2TR, network, script_pubkey }
}

/// Encode Bech32m with 5-bit data (not 8-bit)
/// This is a special case for witness v1+ addresses where data is already in 5-bit format
fn encode_bech32m_with_5bit_data(hrp: ByteArray, data_5bit: Span<u8>) -> ByteArray {
    // Use the bech32m checksum calculation from the encoding package
    let checksum: Array<u8> = compute_bech32m_checksum(hrp.clone(), data_5bit);

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

/// Decodes a Bitcoin address from ByteArray to a BitcoinAddress type.
///
/// This function decodes a Bitcoin address based on the specified address type,
/// validates the checksum, and returns a complete BitcoinAddress structure.
///
/// #### Arguments
/// * `address` - The Bitcoin address as a ByteArray
/// * `address_type` - The type of Bitcoin address to decode
///
/// #### Returns
/// * `BitcoinAddress` - Complete address structure with decoded data and script_pubkey
pub fn decode_address(address: ByteArray, address_type: BitcoinAddressType) -> BitcoinAddress {
    match address_type {
        BitcoinAddressType::P2PKH => decode_p2pkh_address(address),
        BitcoinAddressType::P2SH => decode_p2sh_address(address),
        BitcoinAddressType::P2WPKH => decode_p2wpkh_address(address),
        BitcoinAddressType::P2WSH => decode_p2wsh_address(address),
        BitcoinAddressType::P2TR => decode_p2tr_address(address),
    }
}

/// Decodes a Base58Check encoded address and verifies the checksum.
///
/// Decodes Base58 encoding and verifies the 4-byte checksum (first 4 bytes
/// of double SHA256) matches the expected value.
///
/// #### Arguments
/// * `address` - The Base58Check encoded address
///
/// #### Returns
/// * `(Array<u8>, BitcoinNetwork)` - Tuple containing the decoded payload (version + hash) and
/// network
fn decode_base58_check(address: ByteArray) -> (Array<u8>, BitcoinNetwork) {
    // Convert ByteArray to Array<u8> for decoding
    let address_array: Array<u8> = address.into();
    // Decode Base58
    let decoded = Base58Decoder::decode(address_array.span());

    // Verify minimum length (version byte + hash + 4-byte checksum)
    assert!(decoded.len() >= 5, "Address too short");

    // Extract payload (everything except last 4 bytes which are checksum)
    let payload_len = decoded.len() - 4;
    let mut payload = array![];
    let mut i = 0_u32;
    while i < payload_len {
        payload.append(*decoded.at(i));
        i += 1;
    }

    // Extract checksum (last 4 bytes)
    let mut checksum = array![];
    i = payload_len;
    while i < decoded.len() {
        checksum.append(*decoded.at(i));
        i += 1;
    }

    // Verify checksum
    let expected_checksum = hash256(payload.span());
    assert!(*checksum.at(0) == *expected_checksum.at(0), "Invalid checksum");
    assert!(*checksum.at(1) == *expected_checksum.at(1), "Invalid checksum");
    assert!(*checksum.at(2) == *expected_checksum.at(2), "Invalid checksum");
    assert!(*checksum.at(3) == *expected_checksum.at(3), "Invalid checksum");

    // Determine network from version byte
    let version_byte = *payload.at(0);
    let network = match version_byte {
        0x00 => BitcoinNetwork::Mainnet,
        0x6f => BitcoinNetwork::Testnet,
        0x05 => BitcoinNetwork::Mainnet,
        0xc4 => BitcoinNetwork::Testnet,
        _ => panic!("Invalid version byte"),
    };

    (payload, network)
}

/// Decodes a P2PKH (Pay to Public Key Hash) address.
///
/// Decodes a legacy P2PKH address from Base58Check format and constructs
/// the corresponding script_pubkey.
///
/// #### Arguments
/// * `address` - The P2PKH address as ByteArray
///
/// #### Returns
/// * `BitcoinAddress` - Decoded P2PKH address
fn decode_p2pkh_address(address: ByteArray) -> BitcoinAddress {
    let address_clone = address.clone();
    let (payload, network) = decode_base58_check(address);

    // Verify version byte
    let version_byte = *payload.at(0);
    assert!(
        (version_byte == 0x00 && network == BitcoinNetwork::Mainnet)
            || (version_byte == 0x6f && network == BitcoinNetwork::Testnet),
        "Invalid P2PKH version byte",
    );

    // Extract pubkey hash (20 bytes after version byte)
    assert!(payload.len() >= 21, "Invalid P2PKH payload length");
    let mut pubkey_hash = array![];
    let mut i = 1_u32;
    while i < payload.len() {
        pubkey_hash.append(*payload.at(i));
        i += 1;
    }

    let script_pubkey = create_p2pkh_script_pubkey(pubkey_hash);

    BitcoinAddress {
        address: address_clone, address_type: BitcoinAddressType::P2PKH, network, script_pubkey,
    }
}

/// Decodes a P2SH (Pay to Script Hash) address.
///
/// Decodes a P2SH address from Base58Check format and constructs
/// the corresponding script_pubkey.
///
/// #### Arguments
/// * `address` - The P2SH address as ByteArray
///
/// #### Returns
/// * `BitcoinAddress` - Decoded P2SH address
fn decode_p2sh_address(address: ByteArray) -> BitcoinAddress {
    let address_clone = address.clone();
    let (payload, network) = decode_base58_check(address);

    // Verify version byte
    let version_byte = *payload.at(0);
    assert!(
        (version_byte == 0x05 && network == BitcoinNetwork::Mainnet)
            || (version_byte == 0xc4 && network == BitcoinNetwork::Testnet),
        "Invalid P2SH version byte",
    );

    // Extract script hash (20 bytes after version byte)
    assert!(payload.len() >= 21, "Invalid P2SH payload length");
    let mut script_hash = array![];
    let mut i = 1_u32;
    while i < payload.len() {
        script_hash.append(*payload.at(i));
        i += 1;
    }

    let script_pubkey = create_p2sh_script_pubkey(script_hash);

    BitcoinAddress {
        address: address_clone, address_type: BitcoinAddressType::P2SH, network, script_pubkey,
    }
}

/// Decodes a P2WPKH (Pay to Witness Public Key Hash) address.
///
/// Decodes a native SegWit P2WPKH address from Bech32 format and constructs
/// the corresponding script_pubkey.
///
/// #### Arguments
/// * `address` - The P2WPKH address as ByteArray
///
/// #### Returns
/// * `BitcoinAddress` - Decoded P2WPKH address
fn decode_p2wpkh_address(address: ByteArray) -> BitcoinAddress {
    let address_clone = address.clone();
    // Decode Bech32 (checksum is verified by decoder)
    let (hrp, data, _checksum) = Bech32Decoder::decode(address);

    // Determine network from HRP
    let network = if hrp == "bc" {
        BitcoinNetwork::Mainnet
    } else if hrp == "tb" {
        BitcoinNetwork::Testnet
    } else if hrp == "bcrt" {
        BitcoinNetwork::Regtest
    } else {
        panic!("Invalid HRP for P2WPKH");
    };

    // Verify witness version is 0
    assert!(data.len() > 0, "Empty witness data");
    let witness_version = *data.at(0);
    assert!(witness_version == 0, "Invalid witness version for P2WPKH");

    // Extract witness data (skip version byte)
    let mut witness_data = array![];
    let mut i = 1_u32;
    while i < data.len() {
        witness_data.append(*data.at(i));
        i += 1;
    }

    // Convert 5-bit data to 8-bit bytes
    let pubkey_hash = convert_bits(witness_data.span(), 5, 8, false);

    // Verify hash length is 20 bytes
    assert!(pubkey_hash.len() == 20, "Invalid P2WPKH hash length");

    let script_pubkey = create_p2wpkh_script_pubkey(pubkey_hash);

    BitcoinAddress {
        address: address_clone, address_type: BitcoinAddressType::P2WPKH, network, script_pubkey,
    }
}

/// Decodes a P2WSH (Pay to Witness Script Hash) address.
///
/// Decodes a native SegWit P2WSH address from Bech32 format and constructs
/// the corresponding script_pubkey.
///
/// #### Arguments
/// * `address` - The P2WSH address as ByteArray
///
/// #### Returns
/// * `BitcoinAddress` - Decoded P2WSH address
fn decode_p2wsh_address(address: ByteArray) -> BitcoinAddress {
    let address_clone = address.clone();
    // Decode Bech32 (checksum is verified by decoder)
    let (hrp, data, _checksum) = Bech32Decoder::decode(address);

    // Determine network from HRP
    let network = if hrp == "bc" {
        BitcoinNetwork::Mainnet
    } else if hrp == "tb" {
        BitcoinNetwork::Testnet
    } else if hrp == "bcrt" {
        BitcoinNetwork::Regtest
    } else {
        panic!("Invalid HRP for P2WSH");
    };

    // Verify witness version is 0
    assert!(data.len() > 0, "Empty witness data");
    let witness_version = *data.at(0);
    assert!(witness_version == 0, "Invalid witness version for P2WSH");

    // Extract witness data (skip version byte)
    let mut witness_data = array![];
    let mut i = 1_u32;
    while i < data.len() {
        witness_data.append(*data.at(i));
        i += 1;
    }

    // Convert 5-bit data to 8-bit bytes
    let script_hash = convert_bits(witness_data.span(), 5, 8, false);

    // Verify hash length is 32 bytes
    assert!(script_hash.len() == 32, "Invalid P2WSH hash length");

    let script_pubkey = create_p2wsh_script_pubkey(script_hash);

    BitcoinAddress {
        address: address_clone, address_type: BitcoinAddressType::P2WSH, network, script_pubkey,
    }
}

/// Decodes a P2TR (Pay to Taproot) address.
///
/// Decodes a Taproot P2TR address from Bech32m format and constructs
/// the corresponding script_pubkey.
///
/// #### Arguments
/// * `address` - The P2TR address as ByteArray
///
/// #### Returns
/// * `BitcoinAddress` - Decoded P2TR address
fn decode_p2tr_address(address: ByteArray) -> BitcoinAddress {
    let address_clone = address.clone();
    // Decode Bech32m (checksum is verified by decoder)
    let (hrp, data, _checksum) = Bech32mDecoder::decode(address);

    // Determine network from HRP
    let network = if hrp == "bc" {
        BitcoinNetwork::Mainnet
    } else if hrp == "tb" {
        BitcoinNetwork::Testnet
    } else if hrp == "bcrt" {
        BitcoinNetwork::Regtest
    } else {
        panic!("Invalid HRP for P2TR");
    };

    // Verify witness version is 1
    assert!(data.len() > 0, "Empty witness data");
    let witness_version = *data.at(0);
    assert!(witness_version == 1, "Invalid witness version for P2TR");

    // Extract witness data (skip version byte)
    let mut witness_data = array![];
    let mut i = 1_u32;
    while i < data.len() {
        witness_data.append(*data.at(i));
        i += 1;
    }

    // Convert 5-bit data to 8-bit bytes
    let output_key = convert_bits(witness_data.span(), 5, 8, false);

    // Verify output key length is 32 bytes
    assert!(output_key.len() == 32, "Invalid P2TR output key length");

    let script_pubkey = create_p2tr_script_pubkey(output_key);

    BitcoinAddress {
        address: address_clone, address_type: BitcoinAddressType::P2TR, network, script_pubkey,
    }
}
