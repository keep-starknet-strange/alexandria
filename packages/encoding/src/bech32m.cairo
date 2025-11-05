use alexandria_math::opt_math::OptBitShift;
use crate::bech32::{decode, encode, hrp_to_values};

/// Encoder trait for Bech32 encoding
pub trait Encoder<T> {
    /// Encodes data into Bech32 format
    fn encode(hrp: ByteArray, data: T) -> ByteArray;
}

/// Decoder trait for Bech32 decoding
pub trait Decoder<T> {
    /// Decodes Bech32 encoded data back to raw format
    fn decode(data: T) -> (ByteArray, Array<u8>, Array<u8>);
}

/// Bech32m encoder implementation for u8 spans
pub impl Bech32mEncoder of Encoder<Span<u8>> {
    fn encode(hrp: ByteArray, data: Span<u8>) -> ByteArray {
        let checksum = compute_bech32m_checksum(hrp.clone(), data).span();

        encode(hrp, data, checksum)
    }
}

/// Bech32m decoder implementation for ByteArray
pub impl Bech32mDecoder of Decoder<ByteArray> {
    fn decode(data: ByteArray) -> (ByteArray, Array<u8>, Array<u8>) {
        let (hrp, data, checksum) = decode(data);

        // Verify checksum with HRP
        assert!(verify_bech32m_checksum(hrp.clone(), data.span(), checksum.span()), "Invalid checksum");

        (hrp, data, checksum)
    }
}

/// Compute Bech32m checksum according to BIP-350
pub fn compute_bech32m_checksum(hrp: ByteArray, data: Span<u8>) -> Array<u8> {
    // Convert HRP to values (already includes separator)
    let hrp_values = hrp_to_values(hrp);
    // Combine: hrp_values (with separator) || data || [0,0,0,0,0,0]
    let mut values = array![];
    let mut i = 0_u32;

    while i < hrp_values.len() {
        values.append(*hrp_values.at(i));

        i += 1;
    }

    let mut i = 0_u32;

    while i < data.len() {
        values.append(*data.at(i));

        i += 1;
    }

    // Append 6 zeros for checksum space
    values.append(0);
    values.append(0);
    values.append(0);
    values.append(0);
    values.append(0);
    values.append(0);

    // Calculate polymod
    let polymod = bech32m_polymod(values.span()) ^ 0x2bc830a3;

    // Extract 6 5-bit values from polymod
    let mut checksum = array![];
    let mut i = 0_u32;

    while i < 6 {
        let shift_amount: u8 = (5 * (5 - i)).try_into().unwrap();

        checksum.append((OptBitShift::shr(polymod, shift_amount.into()) & 31).try_into().unwrap());

        i += 1;
    }

    checksum
}

/// Verify Bech32m checksum
fn verify_bech32m_checksum(hrp: ByteArray, data: Span<u8>, checksum: Span<u8>) -> bool {
    // Convert HRP to values (already includes separator)
    let hrp_values = hrp_to_values(hrp);

    // Combine: hrp_values (with separator) || data || checksum
    let mut values = array![];
    let mut i = 0_u32;

    while i < hrp_values.len() {
        values.append(*hrp_values.at(i));

        i += 1;
    }

    let mut i = 0_u32;

    while i < data.len() {
        values.append(*data.at(i));

        i += 1;
    }

    let mut i = 0_u32;

    while i < checksum.len() {
        values.append(*checksum.at(i));

        i += 1;
    }

    // Calculate polymod - for Bech32m, the result should be 0x2bc830a3
    let polymod = bech32m_polymod(values.span());

    polymod == 0x2bc830a3
}

/// Calculate Bech32m polymod
fn bech32m_polymod(values: Span<u8>) -> u32 {
    // Generator constants for Bech32
    let gen: Array<u32> = array![0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3];
    let mut chk: u32 = 1;
    let mut i = 0_u32;

    while i < values.len() {
        let top = OptBitShift::shr(chk, 25);
        chk = OptBitShift::shl(chk & 0x1ffffff, 5) ^ (*values.at(i)).into();
        let mut j = 0_u32;

        while j < 5 {
            let j_u8: u8 = j.try_into().unwrap();

            if (OptBitShift::shr(top, j_u8.into()) & 1) == 1 {
                chk = chk ^ *gen.at(j);
            }

            j += 1;
        }

        i += 1;
    }

    chk
}

