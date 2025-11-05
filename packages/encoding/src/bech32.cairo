use alexandria_math::opt_math::OptBitShift;

const POW2: [u32; 17] = [1, 2, 4, 8, 16, 32, 64, 128, 256, 0, 0, 0, 0, 0, 0, 0, 65536];
pub const CHECKSUM_LEN: usize = 6;

/// Helper function to compute 2^n
fn pow2(n: u32) -> u32 {
    match n {
        0 => 1,
        1 => 2,
        2 => 4,
        3 => 8,
        4 => 16,
        5 => 32,
        6 => 64,
        7 => 128,
        8 => 256,
        9 => panic!("Unsupported power"),
        10 => panic!("Unsupported power"),
        11 => panic!("Unsupported power"),
        12 => panic!("Unsupported power"),
        13 => panic!("Unsupported power"),
        14 => panic!("Unsupported power"),
        15 => panic!("Unsupported power"),
        16 => 65536,
        _ => panic!("Unsupported power"),
    }
}

/// Helper function to check if a character is lowercase alphanumeric
fn is_lower_alphanum(char: u8) -> bool {
    (char > 96 && char < 123) || (char > 47 && char < 58)
}

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

/// Bech32 encoder implementation for u8 spans
pub impl Bech32Encoder of Encoder<Span<u8>> {
    fn encode(hrp: ByteArray, data: Span<u8>) -> ByteArray {
        let checksum = compute_bech32_checksum(hrp.clone(), data).span();

        encode(hrp, data, checksum)
    }
}

/// Bech32 decoder implementation for ByteArray
pub impl Bech32Decoder of Decoder<ByteArray> {
    fn decode(data: ByteArray) -> (ByteArray, Array<u8>, Array<u8>) {
        let (hrp, data, checksum) = decode(data);

        // Verify checksum with HRP
        assert!(
            verify_bech32_checksum(hrp.clone(), data.span(), checksum.span()), "Invalid checksum",
        );

        (hrp, data, checksum)
    }
}

/// Encode data into Bech32 string
/// Does not verify checksum; caller must ensure checksum is correct
pub fn encode(hrp: ByteArray, data: Span<u8>, checksum: Span<u8>) -> ByteArray {
    // Validate HRP length (should be 1-83 characters)
    assert!(hrp.len() >= 1, "HRP too short");
    assert!(hrp.len() <= 83, "HRP too long");
    // Validate data length (should not exceed practical limits)
    assert!(data.len() <= 65, "Data payload too long");

    let mut combined = array![];
    let mut i = 0_u32;

    while i < data.len() {
        combined.append(*data.at(i));

        i += 1;
    }

    let mut i = 0_u32;

    while i < checksum.len() {
        combined.append(*checksum.at(i));

        i += 1;
    }

    let mut result = hrp;

    result.append_byte('1');

    let mut i = 0;

    while i < combined.len() {
        let c = get_bech32_char(*combined.at(i));

        result.append_byte(c);

        i += 1;
    }

    // Validate total length doesn't exceed 90 chars
    assert!(result.len() <= 90, "Encoded string would exceed maximum length of 90 characters");

    result
}

/// Decode Bech32 string into HRP, data and checksum
/// For consistency, only supports a lowercase string
/// Does not verify checksum; caller must ensure checksum is correct
/// HRP must be lowercase alphanumeric characters only (not supporting ?, !, etc)
pub fn decode(encoded: ByteArray) -> (ByteArray, Array<u8>, Array<u8>) {
    // Validate total length doesn't exceed 90 chars
    assert!(encoded.len() <= 90, "Encoded string would exceed maximum length of 90 characters");
    assert!(encoded.len() >= 8, "Encoded string too short");

    // Find the last '1' separator
    let mut separator_pos = 0_u32;
    let mut i = encoded.len();

    while i > 0 {
        i -= 1;

        let char = encoded.at(i).unwrap();

        if char == '1' {
            separator_pos = i;

            break;
        }
    }

    assert!(separator_pos > 0, "No separator found");

    // Extract HRP
    let mut hrp = "";
    let mut i = 0_u32;

    while i < separator_pos {
        let char = encoded.at(i).unwrap();

        // Only checking HRP as bech chars will be checked later on data and checksum
        assert!(is_lower_alphanum(char), "Invalid HRP character");

        hrp.append_byte(char);

        i += 1;
    }

    // Full data part length (data + checksum)
    let full_data_len = encoded.len() - separator_pos - 1;

    assert!(full_data_len >= CHECKSUM_LEN, "Too short checksum");

    // Extract data (lowercased chars)
    let data_start = separator_pos + 1;
    let data_len = full_data_len - CHECKSUM_LEN;
    let mut data = array![];
    let mut i = data_start;

    while i < data_start + data_len {
        let char = encoded.at(i).unwrap();
        let value = bech32_char_to_value(char);

        data.append(value);

        i += 1;
    }

    // Extract checksum (lowercased chars)
    let mut checksum = array![];
    let mut i = data_start + data_len;

    while i < encoded.len() {
        let char = encoded.at(i).unwrap();
        let value = bech32_char_to_value(char);

        checksum.append(value);

        i += 1;
    }

    (hrp, data, checksum)
}

/// Convert 5-bit data to 8-bit data
pub fn convert_bits(data: Span<u8>, from_bits: u8, to_bits: u8, pad: bool) -> Array<u8> {
    let mut acc: u32 = 0;
    let mut bits: u8 = 0;
    let mut result = array![];

    // max value for to_bits
    let maxv: u32 = pow2(to_bits.into()) - 1_u32;

    let mut i = 0_u32;

    while i < data.len() {
        let value = *data.at(i);

        assert!(value.into() < pow2(from_bits.into()), "Invalid value for convert_bits");

        acc = OptBitShift::shl(acc, from_bits.into()) | value.into();
        bits += from_bits;

        while bits >= to_bits {
            bits -= to_bits;
            let v: u8 = (OptBitShift::shr(acc, bits.into()) & maxv).try_into().unwrap();

            result.append(v);
        }

        i += 1;
    }

    if pad {
        if bits > 0 {
            result
                .append(
                    (OptBitShift::shl(acc, (to_bits - bits).into()) & maxv).try_into().unwrap(),
                );
        }
    } else {
        assert!(bits < from_bits, "Invalid padding");
        // see if handling leftover bits on incorrect padding
    // if bits > 0 {
    //     assert!(acc & (OptBitShift::shl(1, bits) - 1) == 0, "Non-zero padding in
    //     convert_bits");
    // }
    }

    result
}

/// Convert HRP string to values for polymod
pub fn hrp_to_values(hrp: ByteArray) -> Array<u8> {
    let mut values = array![];

    // First, add the high bits of each character (>> 5)
    let mut i = 0_u32;

    while i < hrp.len() {
        let char = hrp.at(i).unwrap();

        values.append(OptBitShift::shr(char, 5));

        i += 1;
    }

    // Add separator
    values.append(0);

    // Then add the low bits of each character (& 31)
    let mut i = 0_u32;

    while i < hrp.len() {
        let char = hrp.at(i).unwrap();

        values.append(char & 31);

        i += 1;
    }

    values
}

/// Create the 6-byte checksum for HRP and data
pub fn compute_bech32_checksum(hrp: ByteArray, data: Span<u8>) -> Array<u8> {
    let hrp_values = hrp_to_values(hrp);

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

    let polymod = bech32_polymod(values.span()) ^ 1;
    // Extract 6 5-bit values from polymod
    let mut checksum = array![];
    let mut i = 0_u32;

    while i < 6 {
        let shift_amount: u8 = (5 * (5 - i)).try_into().unwrap();

        checksum.append((OptBitShift::shr(polymod, shift_amount) & 31).try_into().unwrap());

        i += 1;
    }

    checksum
}

/// Verify checksum for encoded Bech32 string
pub fn verify_bech32_checksum(hrp: ByteArray, data: Span<u8>, checksum: Span<u8>) -> bool {
    // Convert HRP to values (already includes separator)
    let hrp_values = hrp_to_values(hrp);
    // Combine: hrp_values (with separator) || data || checksum
    let mut values = array![];
    // hrp_expand(hrp)
    let mut i = 0_u32;

    while i < hrp_values.len() {
        values.append(*hrp_values.at(i));

        i += 1;
    }

    // data
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

    // Must equal 1 for valid Bech32
    bech32_polymod(values.span()) == 1
}

/// Calculate Bech32 polymod
fn bech32_polymod(values: Span<u8>) -> u32 {
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

/// Get Bech32 alphabet character by index
pub fn get_bech32_char(index: u8) -> u8 {
    if index == 0 {
        'q'
    } else if index == 1 {
        'p'
    } else if index == 2 {
        'z'
    } else if index == 3 {
        'r'
    } else if index == 4 {
        'y'
    } else if index == 5 {
        '9'
    } else if index == 6 {
        'x'
    } else if index == 7 {
        '8'
    } else if index == 8 {
        'g'
    } else if index == 9 {
        'f'
    } else if index == 10 {
        '2'
    } else if index == 11 {
        't'
    } else if index == 12 {
        'v'
    } else if index == 13 {
        'd'
    } else if index == 14 {
        'w'
    } else if index == 15 {
        '0'
    } else if index == 16 {
        's'
    } else if index == 17 {
        '3'
    } else if index == 18 {
        'j'
    } else if index == 19 {
        'n'
    } else if index == 20 {
        '5'
    } else if index == 21 {
        '4'
    } else if index == 22 {
        'k'
    } else if index == 23 {
        'h'
    } else if index == 24 {
        'c'
    } else if index == 25 {
        'e'
    } else if index == 26 {
        '6'
    } else if index == 27 {
        'm'
    } else if index == 28 {
        'u'
    } else if index == 29 {
        'a'
    } else if index == 30 {
        '7'
    } else if index == 31 {
        'l'
    } else {
        panic!("Invalid Bech32 index")
    }
}

/// Convert Bech32 character to value
pub fn bech32_char_to_value(char: u8) -> u8 {
    if char == 'q' {
        0
    } else if char == 'p' {
        1
    } else if char == 'z' {
        2
    } else if char == 'r' {
        3
    } else if char == 'y' {
        4
    } else if char == '9' {
        5
    } else if char == 'x' {
        6
    } else if char == '8' {
        7
    } else if char == 'g' {
        8
    } else if char == 'f' {
        9
    } else if char == '2' {
        10
    } else if char == 't' {
        11
    } else if char == 'v' {
        12
    } else if char == 'd' {
        13
    } else if char == 'w' {
        14
    } else if char == '0' {
        15
    } else if char == 's' {
        16
    } else if char == '3' {
        17
    } else if char == 'j' {
        18
    } else if char == 'n' {
        19
    } else if char == '5' {
        20
    } else if char == '4' {
        21
    } else if char == 'k' {
        22
    } else if char == 'h' {
        23
    } else if char == 'c' {
        24
    } else if char == 'e' {
        25
    } else if char == '6' {
        26
    } else if char == 'm' {
        27
    } else if char == 'u' {
        28
    } else if char == 'a' {
        29
    } else if char == '7' {
        30
    } else if char == 'l' {
        31
    } else {
        panic!("Invalid Bech32(m) character")
    }
}
