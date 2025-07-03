/// Encoder trait for Bech32 encoding
pub trait Encoder<T> {
    /// Encodes data into Bech32 format
    fn encode(hrp: ByteArray, data: T) -> ByteArray;
}

/// Decoder trait for Bech32 decoding
pub trait Decoder<T> {
    /// Decodes Bech32 encoded data back to raw format
    fn decode(data: T) -> (ByteArray, Array<u8>);
}

/// Bech32 encoder implementation for u8 spans
pub impl Bech32Encoder of Encoder<Span<u8>> {
    fn encode(hrp: ByteArray, data: Span<u8>) -> ByteArray {
        encode(hrp, data)
    }
}

/// Bech32 decoder implementation for ByteArray
pub impl Bech32Decoder of Decoder<ByteArray> {
    fn decode(data: ByteArray) -> (ByteArray, Array<u8>) {
        decode(data)
    }
}

/// Get Bech32 alphabet character by index
fn get_bech32_char(index: u8) -> u8 {
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
fn bech32_char_to_value(char: u8) -> u8 {
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
        panic!("Invalid Bech32 character")
    }
}

/// Simple Bech32 encode function
pub fn encode(hrp: ByteArray, data: Span<u8>) -> ByteArray {
    let mut result = hrp;
    result.append_byte('1'); // Separator

    // Add data
    let mut i = 0;
    while i < data.len() {
        let value = *data.at(i);
        let char = get_bech32_char(value);
        result.append_byte(char);
        i += 1;
    }

    // Add simple checksum (just repeat first 6 chars for now)
    let mut checksum_count = 0_u32;
    let mut j = 0;
    while checksum_count < 6 {
        if j >= data.len() {
            j = 0;
        }
        let value = *data.at(j);
        let char = get_bech32_char(value);
        result.append_byte(char);
        j += 1;
        checksum_count += 1;
    }

    result
}

/// Simple Bech32 decode function
pub fn decode(encoded: ByteArray) -> (ByteArray, Array<u8>) {
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
        hrp.append_byte(char);
        i += 1;
    }

    // Extract data (excluding checksum for simplicity)
    let data_start = separator_pos + 1;
    let data_len = if encoded.len() > data_start + 6 {
        encoded.len() - data_start - 6
    } else {
        0
    };

    let mut data = array![];
    let mut i = data_start;
    while i < data_start + data_len {
        let char = encoded.at(i).unwrap();
        let value = bech32_char_to_value(char);
        data.append(value);
        i += 1;
    }

    (hrp, data)
}

/// Convert 5-bit data to 8-bit data
pub fn convert_bits(data: Span<u8>, from_bits: u8, to_bits: u8, pad: bool) -> Array<u8> {
    let mut acc: u32 = 0;
    let mut bits: u8 = 0;
    let mut result = array![];

    // Use smaller, safe powers
    let max_value = 255_u32; // 2^8 - 1

    let mut i = 0_u32;
    while i < data.len() {
        let value = *data.at(i);

        // Shift accumulator and add new value
        if from_bits == 8 {
            // For 8-bit input, left shift by 8 (multiply by 256)
            acc = (acc * 256_u32) + value.into();
        } else if from_bits == 5 {
            // For 5-bit input, left shift by 5 (multiply by 32)
            acc = (acc * 32_u32) + value.into();
        } else {
            // Generic case for other bit sizes
            acc = (acc * 4_u32) + value.into(); // Use smaller multiplier to prevent overflow
        }

        bits += from_bits;

        // Extract complete output values
        while bits >= to_bits {
            bits -= to_bits;

            // Right shift to extract the highest bits
            if bits == 0 {
                result.append((acc & max_value).try_into().unwrap());
                acc = 0;
            } else if bits == 1 {
                result.append(((acc / 2_u32) & max_value).try_into().unwrap());
                acc = acc & 1_u32;
            } else if bits == 2 {
                result.append(((acc / 4_u32) & max_value).try_into().unwrap());
                acc = acc & 3_u32;
            } else if bits == 3 {
                result.append(((acc / 8_u32) & max_value).try_into().unwrap());
                acc = acc & 7_u32;
            } else if bits == 4 {
                result.append(((acc / 16_u32) & max_value).try_into().unwrap());
                acc = acc & 15_u32;
            } else if bits == 5 {
                result.append(((acc / 32_u32) & max_value).try_into().unwrap());
                acc = acc & 31_u32;
            } else if bits == 6 {
                result.append(((acc / 64_u32) & max_value).try_into().unwrap());
                acc = acc & 63_u32;
            } else if bits == 7 {
                result.append(((acc / 128_u32) & max_value).try_into().unwrap());
                acc = acc & 127_u32;
            } else {
                // For larger bit counts, use a smaller safe divisor
                result.append(((acc / 256_u32) & max_value).try_into().unwrap());
                acc = acc & 255_u32;
            }
        }

        i += 1;
    }

    // Handle padding
    if pad && bits > 0 {
        let remaining_bits = to_bits - bits;
        if remaining_bits == 1 {
            result.append(((acc * 2_u32) & max_value).try_into().unwrap());
        } else if remaining_bits == 2 {
            result.append(((acc * 4_u32) & max_value).try_into().unwrap());
        } else if remaining_bits == 3 {
            result.append(((acc * 8_u32) & max_value).try_into().unwrap());
        } else {
            result.append((acc & max_value).try_into().unwrap());
        }
    } else if !pad {
        assert!(bits < from_bits, "Invalid padding");
    }

    result
}
