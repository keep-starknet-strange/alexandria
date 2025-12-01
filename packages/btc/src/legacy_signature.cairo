use alexandria_bytes::byte_array_ext::{
    ByteArrayIntoArrayU8, ByteArrayTraitExt, SpanU8IntoByteArray,
};
use starknet::SyscallResultTrait;
use starknet::secp256_trait::{
    Secp256PointTrait, Signature, is_signature_entry_valid, recover_public_key,
};
use starknet::secp256k1::Secp256k1Point;
use crate::hash::hash256;
use crate::types::{BitcoinPublicKey, BitcoinPublicKeyCoords, BitcoinPublicKeyTrait};

/// SIGHASH types for Bitcoin transaction signing
pub const SIGHASH_ALL: u8 = 0x01;
pub const SIGHASH_NONE: u8 = 0x02;
pub const SIGHASH_SINGLE: u8 = 0x03;
pub const SIGHASH_ANYONECANPAY: u8 = 0x80;

/// Create a signature with known y_parity
///
/// #### Arguments
/// * `r` - The r component of the signature
/// * `s` - The s component of the signature
/// * `y_parity` - Whether the y-coordinate of the R point is even (false) or odd (true)
///
/// #### Returns
/// * `Signature` - The complete signature structure
pub fn create_signature(r: u256, s: u256, y_parity: bool) -> Signature {
    Signature { r, s, y_parity }
}

/// Verify a Bitcoin ECDSA signature using Cairo's built-in verification (legacy coords format)
///
/// This function uses Cairo's optimized ECDSA verification through public key recovery.
/// It validates the signature by recovering the public key from the signature and message,
/// then comparing it with the expected public key.
///
/// #### Arguments
/// * `message_hash` - The hash of the message that was signed (typically a transaction hash)
/// * `signature` - The ECDSA signature (r, s components and y_parity for recovery)
/// * `public_key` - The public key coordinates to verify against
///
/// #### Returns
/// * `bool` - True if signature is valid, false otherwise
pub fn verify_ecdsa_signature_coords(
    message_hash: u256, signature: Signature, public_key: BitcoinPublicKeyCoords,
) -> bool {
    // Step 1: Validate signature components using Cairo's built-in validation
    if !is_signature_entry_valid::<Secp256k1Point>(signature.r) {
        return false;
    }
    if !is_signature_entry_valid::<Secp256k1Point>(signature.s) {
        return false;
    }

    // Step 2: Recover the public key from the signature and message hash
    let recovered_point_result = recover_public_key::<
        Secp256k1Point,
    >(msg_hash: message_hash, signature: signature);

    let Some(recovered_point) = recovered_point_result else {
        return false;
    };

    // Step 3: Get coordinates of the recovered public key
    let (recovered_x, recovered_y) = recovered_point.get_coordinates().unwrap_syscall();

    // Step 4: Compare recovered public key with expected public key coordinates
    // For Bitcoin, we need to check both x and y coordinate
    recovered_x == public_key.x && recovered_y == public_key.y
}

/// Verify a Bitcoin ECDSA signature
///
/// This function works with the new ByteArray-based BitcoinPublicKey structure
/// that properly represents Bitcoin's 33-byte compressed or 65-byte uncompressed format.
///
/// #### Arguments
/// * `message_hash` - The hash of the message that was signed
/// * `signature` - The ECDSA signature (r, s components and y_parity for recovery)
/// * `public_key` - The BitcoinPublicKey to verify against
///
/// #### Returns
/// * `bool` - True if signature is valid, false otherwise
pub fn verify_ecdsa_signature(
    message_hash: u256, signature: Signature, public_key: BitcoinPublicKey,
) -> bool {
    // Convert new format to legacy coords format for verification
    let coords = public_key.to_coords();
    verify_ecdsa_signature_coords(message_hash, signature, coords)
}

/// Verify a Bitcoin ECDSA signature with automatic y_parity detection
///
/// This function tries both y_parity values (false and true) to find a match
/// with the provided public key. This is useful when the y_parity is unknown
/// or when working with DER signatures that don't include recovery information.
///
/// #### Arguments
/// * `message_hash` - The hash of the message that was signed
/// * `r` - The r component of the signature
/// * `s` - The s component of the signature
/// * `public_key` - The public key to verify against
///
/// #### Returns
/// * `bool` - True if signature is valid with either y_parity value
pub fn verify_ecdsa_signature_auto_recovery(
    message_hash: u256, r: u256, s: u256, public_key: BitcoinPublicKey,
) -> bool {
    // Try with y_parity = false (even y)
    let signature_even = Signature { r, s, y_parity: false };
    if verify_ecdsa_signature(message_hash, signature_even, public_key.clone()) {
        return true;
    }

    // Try with y_parity = true (odd y)
    let signature_odd = Signature { r, s, y_parity: true };
    verify_ecdsa_signature(message_hash, signature_odd, public_key)
}

/// Verify a DER-encoded Bitcoin signature
///
/// This function parses a DER-encoded signature and verifies it against
/// the provided message hash and public key. Since DER signatures don't
/// include recovery information, it automatically tries both y_parity values.
///
/// #### Arguments
/// * `message_hash` - The hash of the message that was signed
/// * `der_signature` - DER-encoded signature bytes
/// * `public_key` - The public key to verify against
///
/// #### Returns
/// * `bool` - True if the DER signature is valid
pub fn verify_der_signature(
    message_hash: u256, der_signature: Span<u8>, public_key: BitcoinPublicKey,
) -> bool {
    // Parse the DER signature
    let signature_option = parse_der_signature(der_signature);

    if let Some(signature) = signature_option {
        verify_ecdsa_signature_auto_recovery(message_hash, signature.r, signature.s, public_key)
    } else {
        false
    }
}

/// Parse DER-encoded signature using ByteArray utilities
///
/// #### Arguments
/// * `der_bytes` - DER-encoded signature bytes
///
/// #### Returns
/// * `Option<Signature>` - Parsed signature or None if invalid
pub fn parse_der_signature(der_bytes: Span<u8>) -> Option<Signature> {
    if der_bytes.len() < 6 {
        return Option::None;
    }

    // Convert to ByteArray for easier parsing
    let mut data: ByteArray = der_bytes.into();

    // Check DER sequence tag (0x30)
    let (offset, sequence_tag) = data.read_u8(0);
    if sequence_tag != 0x30 {
        return Option::None;
    }

    // Skip sequence length byte
    let (mut offset, _sequence_len) = data.read_u8(offset);

    // Parse r component
    let (new_offset, r_tag) = data.read_u8(offset);
    if r_tag != 0x02 {
        return Option::None;
    }
    offset = new_offset;

    let (new_offset, r_len) = data.read_u8(offset);
    offset = new_offset;

    if offset + r_len.into() > data.len() {
        return Option::None;
    }

    let (new_offset, r_bytes_ba) = data.read_bytes(offset, r_len.into());
    let r_bytes: Array<u8> = r_bytes_ba.into();
    let r = bytes_array_to_u256(r_bytes.span());
    offset = new_offset;

    // Parse s component
    let (new_offset, s_tag) = data.read_u8(offset);
    if s_tag != 0x02 {
        return Option::None;
    }
    offset = new_offset;

    let (new_offset, s_len) = data.read_u8(offset);
    offset = new_offset;

    if offset + s_len.into() > data.len() {
        return Option::None;
    }

    let (_, s_bytes_ba) = data.read_bytes(offset, s_len.into());
    let s_bytes: Array<u8> = s_bytes_ba.into();
    let s = bytes_array_to_u256(s_bytes.span());

    // For DER signatures, we don't have recovery information
    // Set y_parity to false as default - use auto_recovery function for verification
    Option::Some(Signature { r, s, y_parity: false })
}

/// Convert Array<u8> to u256 (big-endian)
fn bytes_array_to_u256(bytes: Span<u8>) -> u256 {
    let mut result: u256 = 0;
    let mut i = 0;
    while i < bytes.len() {
        result = result * 256 + (*bytes.at(i)).into();
        i += 1;
    }
    result
}

/// Calculate modular inverse using Fermat's little theorem for prime modulus
///
/// For secp256k1 curve order n (which is prime), we use Fermat's little theorem:
/// If p is prime and a ≢ 0 (mod p), then a^(-1) ≡ a^(p-2) (mod p)
///
/// #### Arguments
/// * `a` - The value to find the modular inverse of
/// * `m` - The modulus (should be prime)
///
/// #### Returns
/// * `u256` - The modular inverse a^(-1) mod m, or 0 if no inverse exists
pub fn mod_inverse(a: u256, m: u256) -> u256 {
    if a == 0 || m <= 1 {
        return 0;
    }

    // Normalize a to be in range [0, m)
    let a_normalized = a % m;
    if a_normalized == 0 {
        return 0;
    }

    // For secp256k1 curve order (which is prime), use Fermat's little theorem:
    // a^(-1) ≡ a^(m-2) (mod m)
    mod_pow(a_normalized, m - 2, m)
}

/// Calculate (base^exp) mod modulus using binary exponentiation
fn mod_pow(mut base: u256, mut exp: u256, modulus: u256) -> u256 {
    if modulus == 1 {
        return 0;
    }

    let mut result: u256 = 1;
    base = base % modulus;

    while exp > 0 {
        if exp % 2 == 1 {
            result = (result * base) % modulus;
        }
        exp = exp / 2;
        base = (base * base) % modulus;
    }

    result
}

/// Create a signature hash for transaction signing using ByteArray
///
/// #### Arguments
/// * `transaction_data` - The transaction data to be signed
/// * `sighash_type` - The type of signature hash (SIGHASH_ALL, etc.)
///
/// #### Returns
/// * `u256` - The hash to be signed
pub fn create_signature_hash(transaction_data: Span<u8>, sighash_type: u8) -> u256 {
    // Convert to ByteArray and append sighash type
    let mut data_with_sighash = transaction_data.into();

    // Append sighash type (4 bytes little-endian)
    data_with_sighash.append_byte(sighash_type);
    data_with_sighash.append_byte(0);
    data_with_sighash.append_byte(0);
    data_with_sighash.append_byte(0);

    // Double SHA256 hash
    let hash_bytes = hash256_from_byte_array(data_with_sighash);

    // Convert to u256 (big-endian)
    bytes_array_to_u256(hash_bytes.span())
}

/// Helper function to hash ByteArray data
fn hash256_from_byte_array(data: ByteArray) -> Array<u8> {
    let mut bytes: Array<u8> = data.into();
    hash256(bytes.span())
}

/// Verify a signature against transaction data
///
/// #### Arguments
/// * `transaction_data` - The transaction data that was signed
/// * `signature` - The ECDSA signature
/// * `public_key` - The public key to verify against
/// * `sighash_type` - The signature hash type used
///
/// #### Returns
/// * `bool` - True if signature is valid for the transaction
pub fn verify_transaction_signature(
    transaction_data: Span<u8>,
    signature: Signature,
    public_key: BitcoinPublicKey,
    sighash_type: u8,
) -> bool {
    let message_hash = create_signature_hash(transaction_data, sighash_type);
    verify_ecdsa_signature(message_hash, signature, public_key)
}
