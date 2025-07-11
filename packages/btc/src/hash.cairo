use alexandria_bytes::byte_array_ext::{ByteArrayIntoArrayU8, SpanU8IntoByteArray};
use alexandria_math::ripemd160::{ripemd160_context_as_bytes, ripemd160_hash};
use core::sha256::compute_sha256_byte_array;


/// Computes Bitcoin Hash160 (RIPEMD160(SHA256(data))) from input data.
///
/// Implements the standard Bitcoin Hash160 function used for address generation
/// and script operations. Applies SHA256 followed by RIPEMD160 to produce a
/// 20-byte hash output.
///
/// # Arguments
/// * `data` - Input data to hash as a span of bytes
///
/// # Returns
/// * `Array<u8>` - 20-byte Hash160 result
///
/// # Usage
/// Primary hashing function for Bitcoin public key hashes and script hashes.
pub fn hash160(data: Span<u8>) -> Array<u8> {
    // Convert span to ByteArray for SHA256
    let byte_array = data.into();

    // SHA256 hash
    let [w0, w1, w2, w3, w4, w5, w6, w7] = compute_sha256_byte_array(@byte_array);

    // Convert SHA256 result to ByteArray for RIPEMD160
    let mut sha256_bytes = "";

    // Process each word directly
    sha256_bytes.append_byte((w0 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w0 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w0 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w0 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w1 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w1 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w1 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w1 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w2 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w2 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w2 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w2 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w3 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w3 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w3 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w3 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w4 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w4 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w4 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w4 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w5 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w5 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w5 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w5 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w6 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w6 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w6 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w6 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w7 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w7 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w7 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w7 % 0x100).try_into().unwrap());

    // RIPEMD160 hash
    let ripemd160_result = ripemd160_hash(@sha256_bytes);
    let ripemd160_bytes = ripemd160_context_as_bytes(@ripemd160_result);

    // Convert ByteArray to Array<u8>
    let mut result = array![];
    let mut i = 0_u32;
    while i < 20 {
        result.append(ripemd160_bytes.at(i).unwrap());
        i += 1;
    }

    result
}

/// Computes Bitcoin Hash256 (SHA256(SHA256(data))) from input data.
///
/// Implements the Bitcoin double SHA256 function used for transaction IDs,
/// block hashes, and Base58Check checksums. Applies SHA256 twice for
/// additional security.
///
/// # Arguments
/// * `data` - Input data to hash as a span of bytes
///
/// # Returns
/// * `Array<u8>` - 32-byte Hash256 result
///
/// # Usage
/// Used for transaction hashes, block hashes, and checksum calculations.
pub fn hash256(data: Span<u8>) -> Array<u8> {
    // First SHA256
    let first_sha256 = sha256(data);

    // Second SHA256
    let second_sha256 = sha256(first_sha256.span());

    second_sha256
}

/// Computes a single SHA256 hash from input data.
///
/// Provides a wrapper around the core SHA256 implementation to convert
/// between different data formats and produce byte array output.
///
/// # Arguments
/// * `data` - Input data to hash as a span of bytes
///
/// # Returns
/// * `Array<u8>` - 32-byte SHA256 hash result
///
/// # Usage
/// Used as a building block for other hash functions and direct SHA256 operations.
pub fn sha256(data: Span<u8>) -> Array<u8> {
    // Convert span to ByteArray for SHA256
    let mut byte_array: ByteArray = data.into();

    // SHA256 hash
    let [w0, w1, w2, w3, w4, w5, w6, w7] = compute_sha256_byte_array(@byte_array);

    // Convert [u32; 8] to Array<u8>
    let mut result = array![];

    // Process each word directly
    result.append((w0 / 0x1000000).try_into().unwrap());
    result.append(((w0 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w0 / 0x100) % 0x100).try_into().unwrap());
    result.append((w0 % 0x100).try_into().unwrap());

    result.append((w1 / 0x1000000).try_into().unwrap());
    result.append(((w1 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w1 / 0x100) % 0x100).try_into().unwrap());
    result.append((w1 % 0x100).try_into().unwrap());

    result.append((w2 / 0x1000000).try_into().unwrap());
    result.append(((w2 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w2 / 0x100) % 0x100).try_into().unwrap());
    result.append((w2 % 0x100).try_into().unwrap());

    result.append((w3 / 0x1000000).try_into().unwrap());
    result.append(((w3 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w3 / 0x100) % 0x100).try_into().unwrap());
    result.append((w3 % 0x100).try_into().unwrap());

    result.append((w4 / 0x1000000).try_into().unwrap());
    result.append(((w4 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w4 / 0x100) % 0x100).try_into().unwrap());
    result.append((w4 % 0x100).try_into().unwrap());

    result.append((w5 / 0x1000000).try_into().unwrap());
    result.append(((w5 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w5 / 0x100) % 0x100).try_into().unwrap());
    result.append((w5 % 0x100).try_into().unwrap());

    result.append((w6 / 0x1000000).try_into().unwrap());
    result.append(((w6 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w6 / 0x100) % 0x100).try_into().unwrap());
    result.append((w6 % 0x100).try_into().unwrap());

    result.append((w7 / 0x1000000).try_into().unwrap());
    result.append(((w7 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w7 / 0x100) % 0x100).try_into().unwrap());
    result.append((w7 % 0x100).try_into().unwrap());

    result
}

/// Calculates a 4-byte checksum for Base58Check encoding.
///
/// Computes Hash256 of the input data and returns the first 4 bytes
/// as a checksum for Base58Check encoding used in legacy Bitcoin addresses.
///
/// # Arguments
/// * `data` - Input data (version byte + payload) to calculate checksum for
///
/// # Returns
/// * `Array<u8>` - 4-byte checksum
///
/// # Usage
/// Used in Base58Check encoding for legacy Bitcoin address format validation.
pub fn checksum(data: Span<u8>) -> Array<u8> {
    let hash = hash256(data);
    // Return first 4 bytes
    array![*hash.at(0), *hash.at(1), *hash.at(2), *hash.at(3)]
}

// ByteArray-native versions for easier use

/// Computes Bitcoin Hash160 directly from ByteArray input.
///
/// Optimized version of hash160 that works directly with ByteArray data
/// without requiring conversion to Span<u8> first.
///
/// # Arguments
/// * `data` - Input data as a ByteArray reference
///
/// # Returns
/// * `Array<u8>` - 20-byte Hash160 result
///
/// # Usage
/// Efficient Hash160 computation when working with ByteArray data structures.
pub fn hash160_from_byte_array(data: @ByteArray) -> Array<u8> {
    // SHA256 hash
    let [w0, w1, w2, w3, w4, w5, w6, w7] = compute_sha256_byte_array(data);

    // Convert SHA256 result to ByteArray for RIPEMD160
    let mut sha256_bytes = "";

    // Process each word directly
    sha256_bytes.append_byte((w0 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w0 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w0 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w0 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w1 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w1 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w1 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w1 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w2 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w2 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w2 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w2 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w3 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w3 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w3 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w3 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w4 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w4 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w4 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w4 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w5 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w5 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w5 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w5 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w6 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w6 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w6 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w6 % 0x100).try_into().unwrap());

    sha256_bytes.append_byte((w7 / 0x1000000).try_into().unwrap());
    sha256_bytes.append_byte(((w7 / 0x10000) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte(((w7 / 0x100) % 0x100).try_into().unwrap());
    sha256_bytes.append_byte((w7 % 0x100).try_into().unwrap());

    // RIPEMD160 hash
    let ripemd160_result = ripemd160_hash(@sha256_bytes);
    let ripemd160_bytes = ripemd160_context_as_bytes(@ripemd160_result);

    // Convert ByteArray to Array<u8>
    ripemd160_bytes.into()
}

/// Computes SHA256 hash directly from ByteArray input.
///
/// Optimized version of sha256 that works directly with ByteArray data
/// without requiring conversion to Span<u8> first.
///
/// # Arguments
/// * `data` - Input data as a ByteArray reference
///
/// # Returns
/// * `Array<u8>` - 32-byte SHA256 hash result
///
/// # Usage
/// Efficient SHA256 computation when working with ByteArray data structures.
pub fn sha256_from_byte_array(data: @ByteArray) -> Array<u8> {
    // SHA256 hash
    let [w0, w1, w2, w3, w4, w5, w6, w7] = compute_sha256_byte_array(data);

    // Convert [u32; 8] to Array<u8>
    let mut result = array![];

    // Process each word directly
    result.append((w0 / 0x1000000).try_into().unwrap());
    result.append(((w0 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w0 / 0x100) % 0x100).try_into().unwrap());
    result.append((w0 % 0x100).try_into().unwrap());

    result.append((w1 / 0x1000000).try_into().unwrap());
    result.append(((w1 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w1 / 0x100) % 0x100).try_into().unwrap());
    result.append((w1 % 0x100).try_into().unwrap());

    result.append((w2 / 0x1000000).try_into().unwrap());
    result.append(((w2 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w2 / 0x100) % 0x100).try_into().unwrap());
    result.append((w2 % 0x100).try_into().unwrap());

    result.append((w3 / 0x1000000).try_into().unwrap());
    result.append(((w3 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w3 / 0x100) % 0x100).try_into().unwrap());
    result.append((w3 % 0x100).try_into().unwrap());

    result.append((w4 / 0x1000000).try_into().unwrap());
    result.append(((w4 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w4 / 0x100) % 0x100).try_into().unwrap());
    result.append((w4 % 0x100).try_into().unwrap());

    result.append((w5 / 0x1000000).try_into().unwrap());
    result.append(((w5 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w5 / 0x100) % 0x100).try_into().unwrap());
    result.append((w5 % 0x100).try_into().unwrap());

    result.append((w6 / 0x1000000).try_into().unwrap());
    result.append(((w6 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w6 / 0x100) % 0x100).try_into().unwrap());
    result.append((w6 % 0x100).try_into().unwrap());

    result.append((w7 / 0x1000000).try_into().unwrap());
    result.append(((w7 / 0x10000) % 0x100).try_into().unwrap());
    result.append(((w7 / 0x100) % 0x100).try_into().unwrap());
    result.append((w7 % 0x100).try_into().unwrap());

    result
}

/// Computes SHA256 hash directly from ByteArray input to ByteArray output.
///
/// Optimized version of sha256 that works directly with ByteArray data
/// without requiring last conversion to ByteArray.
///
/// # Arguments
/// * `data` - Input data as a ByteArray reference
///
/// # Returns
/// * `ByteArray` - 32-byte SHA256 hash result
///
/// # Usage
/// Efficient SHA256 computation when working with ByteArray outputs.
pub fn sha256_byte_array(data: @ByteArray) -> ByteArray {
    // SHA256 hash
    let [w0, w1, w2, w3, w4, w5, w6, w7] = compute_sha256_byte_array(data);

    // Convert [u32; 8] to ByteArray
    let mut result: ByteArray = "";

    // Process each word directly
    result.append_byte((w0 / 0x1000000).try_into().unwrap());
    result.append_byte(((w0 / 0x10000) % 0x100).try_into().unwrap());
    result.append_byte(((w0 / 0x100) % 0x100).try_into().unwrap());
    result.append_byte((w0 % 0x100).try_into().unwrap());

    result.append_byte((w1 / 0x1000000).try_into().unwrap());
    result.append_byte(((w1 / 0x10000) % 0x100).try_into().unwrap());
    result.append_byte(((w1 / 0x100) % 0x100).try_into().unwrap());
    result.append_byte((w1 % 0x100).try_into().unwrap());

    result.append_byte((w2 / 0x1000000).try_into().unwrap());
    result.append_byte(((w2 / 0x10000) % 0x100).try_into().unwrap());
    result.append_byte(((w2 / 0x100) % 0x100).try_into().unwrap());
    result.append_byte((w2 % 0x100).try_into().unwrap());

    result.append_byte((w3 / 0x1000000).try_into().unwrap());
    result.append_byte(((w3 / 0x10000) % 0x100).try_into().unwrap());
    result.append_byte(((w3 / 0x100) % 0x100).try_into().unwrap());
    result.append_byte((w3 % 0x100).try_into().unwrap());

    result.append_byte((w4 / 0x1000000).try_into().unwrap());
    result.append_byte(((w4 / 0x10000) % 0x100).try_into().unwrap());
    result.append_byte(((w4 / 0x100) % 0x100).try_into().unwrap());
    result.append_byte((w4 % 0x100).try_into().unwrap());

    result.append_byte((w5 / 0x1000000).try_into().unwrap());
    result.append_byte(((w5 / 0x10000) % 0x100).try_into().unwrap());
    result.append_byte(((w5 / 0x100) % 0x100).try_into().unwrap());
    result.append_byte((w5 % 0x100).try_into().unwrap());

    result.append_byte((w6 / 0x1000000).try_into().unwrap());
    result.append_byte(((w6 / 0x10000) % 0x100).try_into().unwrap());
    result.append_byte(((w6 / 0x100) % 0x100).try_into().unwrap());
    result.append_byte((w6 % 0x100).try_into().unwrap());

    result.append_byte((w7 / 0x1000000).try_into().unwrap());
    result.append_byte(((w7 / 0x10000) % 0x100).try_into().unwrap());
    result.append_byte(((w7 / 0x100) % 0x100).try_into().unwrap());
    result.append_byte((w7 % 0x100).try_into().unwrap());

    result
}

/// Computes SHA256 hash directly from ByteArray input to u256 output.
///
/// Optimized version of sha256 that works directly with ByteArray data
/// without requiring last conversion to u256.
///
/// # Arguments
/// * `data` - Input data as a ByteArray reference
///
/// # Returns
/// * `u256` - 32-byte SHA256 hash result
///
/// # Usage
/// Efficient SHA256 computation when working with u256 outputs.
pub fn sha256_u256(data: @ByteArray) -> u256 {
    // SHA256 hash
    let [w0, w1, w2, w3, w4, w5, w6, w7] = compute_sha256_byte_array(data);

    // Convert [u32; 8] to ByteArray
    // Process each word directly
    (w0 / 0x1000000).into() *
        0x100000000000000000000000000000000000000000000000000000000000000 |
        ((w0 / 0x10000) % 0x100).into() *
        0x1000000000000000000000000000000000000000000000000000000000000 |
        ((w0 / 0x100) % 0x100).into() *
        0x10000000000000000000000000000000000000000000000000000000000 |
        (w0 % 0x100).into() *
        0x100000000000000000000000000000000000000000000000000000000 |
        (w1 / 0x1000000).into() *
        0x1000000000000000000000000000000000000000000000000000000 |
        ((w1 / 0x10000) % 0x100).into() *
        0x10000000000000000000000000000000000000000000000000000 |
        ((w1 / 0x100) % 0x100).into() *
        0x100000000000000000000000000000000000000000000000000 |
        (w1 % 0x100).into() *
        0x1000000000000000000000000000000000000000000000000 |
        (w2 / 0x1000000).into() *
        0x10000000000000000000000000000000000000000000000 |
        ((w2 / 0x10000) % 0x100).into() *
        0x100000000000000000000000000000000000000000000 |
        ((w2 / 0x100) % 0x100).into() *
        0x1000000000000000000000000000000000000000000 |
        (w2 % 0x100).into() *
        0x10000000000000000000000000000000000000000 |
        (w3 / 0x1000000).into() *
        0x100000000000000000000000000000000000000 |
        ((w3 / 0x10000) % 0x100).into() *
        0x1000000000000000000000000000000000000 |
        ((w3 / 0x100) % 0x100).into() *
        0x10000000000000000000000000000000000 |
        (w3 % 0x100).into() *
        0x100000000000000000000000000000000 |
        (w4 / 0x1000000).into() *
        0x1000000000000000000000000000000 |
        ((w4 / 0x10000) % 0x100).into() *
        0x10000000000000000000000000000 |
        ((w4 / 0x100) % 0x100).into() *
        0x100000000000000000000000000 |
        (w4 % 0x100).into() *
        0x1000000000000000000000000 |
        (w5 / 0x1000000).into() *
        0x10000000000000000000000 |
        ((w5 / 0x10000) % 0x100).into() *
        0x100000000000000000000 |
        ((w5 / 0x100) % 0x100).into() *
        0x1000000000000000000 |
        (w5 % 0x100).into() *
        0x10000000000000000 |
        (w6 / 0x1000000).into() *
        0x100000000000000 |
        ((w6 / 0x10000) % 0x100).into() *
        0x1000000000000 |
        ((w6 / 0x100) % 0x100).into() *
        0x10000000000 |
        (w6 % 0x100).into() *
        0x100000000 |
        (w7 / 0x1000000).into() *
        0x1000000 |
        ((w7 / 0x10000) % 0x100).into() *
        0x10000 |
        ((w7 / 0x100) % 0x100).into() *
        0x100 |
        (w7 % 0x100).into()
}

/// Computes Bitcoin Hash256 (double SHA256) directly from ByteArray input.
///
/// Optimized version of hash256 that works directly with ByteArray data
/// without requiring conversion to Span<u8> first.
///
/// # Arguments
/// * `data` - Input data as a ByteArray reference
///
/// # Returns
/// * `Array<u8>` - 32-byte Hash256 result
///
/// # Usage
/// Efficient Hash256 computation when working with ByteArray data structures.
pub fn hash256_from_byte_array(data: @ByteArray) -> Array<u8> {
    // First SHA256
    let first_hash_bytes = sha256_from_byte_array(data);
    let first_hash_ba = first_hash_bytes.span().into();

    // Second SHA256
    sha256_from_byte_array(@first_hash_ba)
}
