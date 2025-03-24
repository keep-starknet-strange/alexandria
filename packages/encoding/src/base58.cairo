use alexandria_data_structures::array_ext::ArrayTraitExt;

pub trait Encoder<T> {
    fn encode(data: T) -> Array<u8>;
}

pub trait Decoder<T> {
    fn decode(data: T) -> Array<u8>;
}

pub impl Base58Encoder of Encoder<Span<u8>> {
    fn encode(data: Span<u8>) -> Array<u8> {
        encode_u8_array(data, get_base58_char_set().span())
    }
}

pub fn encode_u8_array(bytes: Span<u8>, base58_chars: Span<u8>) -> Array<u8> {
    let mut result = array![];
    if bytes.len() == 0 {
        return result;
    }

    // Count leading zeros
    let mut zeros = 0;
    let mut i = 0;
    while i < bytes.len() && *bytes[i] == 0 {
        zeros += 1;
        i += 1;
    }

    // Add leading '1's for each leading zero byte
    i = 0;
    while i < zeros {
        result.append(*base58_chars[0]);
        i += 1;
    }

    // Convert the bytes to base58 using "big integer division"
    // This algorithm processes bytes sequentially to avoid overflow
    let mut b58: Array<u8> = array![];
    i = zeros;
    while i < bytes.len() {
        // Add the current byte to the buffer
        let mut carry: u32 = (*bytes[i]).into();

        // Apply b58 = b58 * 256 + carry using manual long multiplication
        let mut j = 0;
        let mut new_b58: Array<u8> = array![];

        while j < b58.len() {
            let total = ((*b58[j]).into() * 256) + carry;
            new_b58.append((total % 58).try_into().unwrap());
            carry = total / 58;
            j += 1;
        }

        // Handle any remaining carry
        while carry > 0 {
            new_b58.append((carry % 58).try_into().unwrap());
            carry = carry / 58;
        }

        b58 = new_b58;
        i += 1;
    }

    // Build the result string from the b58 buffer (reversed)
    i = b58.len();
    while i > 0 {
        i -= 1;
        result.append(*base58_chars[(*b58[i]).into()]);
    }

    result
}

pub impl Base58Decoder of Decoder<Span<u8>> {
    fn decode(data: Span<u8>) -> Array<u8> {
        if data.len() == 0 {
            return array![];
        }

        // Get the base58 character set once
        let base58_char_set = get_base58_char_set();
        let base58_one = *base58_char_set[0];

        // Count leading '1's
        let mut zeros = 0;
        let mut i = 0;
        while i < data.len() && *data[i] == base58_one {
            zeros += 1;
            i += 1;
        }

        // Early optimization: If input is all '1's, return all zeros
        if zeros == data.len() {
            let mut result = array![];
            i = 0;
            while i < zeros {
                result.append(0);
                i += 1;
            }
            return result;
        }

        // Create a lookup array using get_base58_value to avoid direct indexing
        let mut result = array![];

        // Convert from base58
        let mut num = 0_u256;
        let mut power = 1_u256;

        // Process characters from right to left (least significant first)
        i = data.len();
        let mut valid = true;
        while i > zeros {
            i -= 1;
            let char_value = *data[i];
            let value = get_base58_value(char_value);

            if value == 255 {
                // Invalid character
                valid = false;
                break;
            }

            num += value.into() * power;
            // Limit multiplications by batching power calculations
            if i > zeros {
                power *= 58;
            }
        }

        // If we encountered an invalid character, return empty array
        if !valid {
            return array![];
        }

        // Extract bytes from the number
        if num == 0 {
            // Just zeros
            i = 0;
            while i < zeros {
                result.append(0);
                i += 1;
            }
            return result;
        }

        // Extract bytes from the number
        while num > 0 {
            let (quotient, remainder) = DivRem::div_rem(num, 256_u256.try_into().unwrap());
            let remainder_u8: u8 = remainder.try_into().unwrap();
            result.append(remainder_u8);
            num = quotient;
        }

        // Add leading zeros
        i = 0;
        while i < zeros {
            result.append(0);
            i += 1;
        }

        result = result.reversed();
        result
    }
}

// Lookup function using direct values
fn get_base58_value(x: u8) -> u8 {
    if x == '1' {
        return 0;
    }
    if x == '2' {
        return 1;
    }
    if x == '3' {
        return 2;
    }
    if x == '4' {
        return 3;
    }
    if x == '5' {
        return 4;
    }
    if x == '6' {
        return 5;
    }
    if x == '7' {
        return 6;
    }
    if x == '8' {
        return 7;
    }
    if x == '9' {
        return 8;
    }
    if x == 'A' {
        return 9;
    }
    if x == 'B' {
        return 10;
    }
    if x == 'C' {
        return 11;
    }
    if x == 'D' {
        return 12;
    }
    if x == 'E' {
        return 13;
    }
    if x == 'F' {
        return 14;
    }
    if x == 'G' {
        return 15;
    }
    if x == 'H' {
        return 16;
    }
    if x == 'J' {
        return 17;
    }
    if x == 'K' {
        return 18;
    }
    if x == 'L' {
        return 19;
    }
    if x == 'M' {
        return 20;
    }
    if x == 'N' {
        return 21;
    }
    if x == 'P' {
        return 22;
    }
    if x == 'Q' {
        return 23;
    }
    if x == 'R' {
        return 24;
    }
    if x == 'S' {
        return 25;
    }
    if x == 'T' {
        return 26;
    }
    if x == 'U' {
        return 27;
    }
    if x == 'V' {
        return 28;
    }
    if x == 'W' {
        return 29;
    }
    if x == 'X' {
        return 30;
    }
    if x == 'Y' {
        return 31;
    }
    if x == 'Z' {
        return 32;
    }
    if x == 'a' {
        return 33;
    }
    if x == 'b' {
        return 34;
    }
    if x == 'c' {
        return 35;
    }
    if x == 'd' {
        return 36;
    }
    if x == 'e' {
        return 37;
    }
    if x == 'f' {
        return 38;
    }
    if x == 'g' {
        return 39;
    }
    if x == 'h' {
        return 40;
    }
    if x == 'i' {
        return 41;
    }
    if x == 'j' {
        return 42;
    }
    if x == 'k' {
        return 43;
    }
    if x == 'm' {
        return 44;
    }
    if x == 'n' {
        return 45;
    }
    if x == 'o' {
        return 46;
    }
    if x == 'p' {
        return 47;
    }
    if x == 'q' {
        return 48;
    }
    if x == 'r' {
        return 49;
    }
    if x == 's' {
        return 50;
    }
    if x == 't' {
        return 51;
    }
    if x == 'u' {
        return 52;
    }
    if x == 'v' {
        return 53;
    }
    if x == 'w' {
        return 54;
    }
    if x == 'x' {
        return 55;
    }
    if x == 'y' {
        return 56;
    }
    if x == 'z' {
        return 57;
    }

    // Default (invalid character)
    255
}

fn get_base58_char_set() -> Array<u8> {
    array![
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'J',
        'K',
        'L',
        'M',
        'N',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z',
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
    ]
}

