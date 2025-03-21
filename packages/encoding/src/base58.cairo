use alexandria_data_structures::array_ext::ArrayTraitExt;

pub trait Encoder<T> {
    fn encode(data: T) -> Array<u8>;
}

pub trait Decoder<T> {
    fn decode(data: T) -> Array<u8>;
}

pub impl Base58Encoder of Encoder<Array<u8>> {
    fn encode(data: Array<u8>) -> Array<u8> {
        encode_u8_array(data, get_base58_char_set().span())
    }
}

pub impl Base58FeltEncoder of Encoder<felt252> {
    fn encode(data: felt252) -> Array<u8> {
        encode_felt(data, get_base58_char_set().span())
    }
}

pub fn encode_u8_array(mut bytes: Array<u8>, base58_chars: Span<u8>) -> Array<u8> {
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
    };

    // Add leading '1's for each leading zero byte
    i = 0;
    while i < zeros {
        result.append(*base58_chars[0]);
        i += 1;
    };

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
        };

        // Handle any remaining carry
        while carry > 0 {
            new_b58.append((carry % 58).try_into().unwrap());
            carry = carry / 58;
        };

        b58 = new_b58;
        i += 1;
    };

    // Build the result string from the b58 buffer (reversed)
    i = b58.len();
    while i > 0 {
        i -= 1;
        result.append(*base58_chars[(*b58[i]).into()]);
    };

    result
}

pub fn encode_felt(self: felt252, base58_chars: Span<u8>) -> Array<u8> {
    let mut result = array![];

    let mut num: u256 = self.into();
    if num == 0 {
        return array![*base58_chars[0]];
    }

    // Extract base58 digits
    while (num != 0) {
        let (quotient, remainder) = DivRem::div_rem(num, 58_u256.try_into().unwrap());
        // Safe since 'remainder' is always less than 58,
        // which is within the range of usize.
        let remainder: usize = remainder.try_into().unwrap();
        result.append(*base58_chars[remainder]);
        num = quotient;
    };
    
    result = result.reversed();
    result
}

pub impl Base58Decoder of Decoder<Array<u8>> {
    fn decode(data: Array<u8>) -> Array<u8> {
        if data.len() == 0 {
            return array![];
        }

        // Count leading '1's
        let mut zeros = 0;
        let mut i = 0;
        while i < data.len() && *data[i] == *get_base58_char_set()[0] {
            zeros += 1;
            i += 1;
        };

        // Convert from base58
        let mut num = 0_u256;
        let mut power = 1_u256;

        // Process characters from right to left (least significant first)
        i = data.len();
        while i > zeros {
            i -= 1;
            let value = get_base58_value(*data[i]);
            if value == 255 {
                // Invalid character
                break; // Exit the loop instead of returning
            }
            num += value.into() * power;
            power *= 58;
        };
        
        // If we encountered an invalid character, return empty array
        if i > zeros {
            return array![];
        }

        // Convert to bytes
        let mut result = array![];
        if num == 0 {
            // Just zeros
            i = 0;
            while i < zeros {
                result.append(0);
                i += 1;
            };
            return result;
        }

        // Extract bytes from the number
        while num > 0 {
            let (quotient, remainder) = DivRem::div_rem(num, 256_u256.try_into().unwrap());
            let remainder: u8 = remainder.try_into().unwrap();
            result.append(remainder);
            num = quotient;
        };

        // Add leading zeros
        i = 0;
        while i < zeros {
            result.append(0);
            i += 1;
        };

        result = result.reversed();
        result
    }
}

fn get_base58_value(x: u8) -> u8 {
    // Returns the index of the character in the base58 alphabet or 255 if not found
    let char_set = get_base58_char_set();
    let mut i = 0;
    let mut result: u8 = 255; // Default to "not found"
    while i < char_set.len() {
        if *char_set[i] == x {
            result = i.try_into().unwrap();
            break;
        }
        i += 1;
    };
    result
}

fn get_base58_char_set() -> Array<u8> {
    let mut result = array![
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
    ];
    result
}

