use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use alexandria_data_structures::array_ext::ArrayTraitExt;


pub trait Encoder<T> {
    fn encode(data: T) -> Array<u8>;
}

pub trait Decoder<T> {
    fn decode(data: T) -> Array<u8>;
}

pub trait ByteArrayEncoder {
    fn encode(data: ByteArray) -> ByteArray;
}

pub trait ByteArrayDecoder {
    fn decode(data: ByteArray) -> ByteArray;
}

pub impl Base64Encoder of Encoder<Array<u8>> {
    fn encode(data: Array<u8>) -> Array<u8> {
        let mut char_set = get_base64_char_set();
        char_set.append('+');
        char_set.append('/');
        encode_u8_array(data, char_set.span())
    }
}

pub impl Base64UrlEncoder of Encoder<Array<u8>> {
    fn encode(data: Array<u8>) -> Array<u8> {
        let mut char_set = get_base64_char_set();
        char_set.append('-');
        char_set.append('_');
        encode_u8_array(data, char_set.span())
    }
}

pub impl Base64FeltEncoder of Encoder<felt252> {
    fn encode(data: felt252) -> Array<u8> {
        let mut char_set = get_base64_char_set();
        char_set.append('+');
        char_set.append('/');
        encode_felt(data, char_set.span())
    }
}

pub impl Base64UrlFeltEncoder of Encoder<felt252> {
    fn encode(data: felt252) -> Array<u8> {
        let mut char_set = get_base64_char_set();
        char_set.append('-');
        char_set.append('_');
        encode_felt(data, char_set.span())
    }
}

pub impl Base64ByteArrayEncoder of ByteArrayEncoder {
    fn encode(data: ByteArray) -> ByteArray {
        let mut char_set = get_base64_char_set();
        char_set.append('+');
        char_set.append('/');
        encode_byte_array(data, char_set.span())
    }
}

pub impl Base64ByteArrayUrlEncoder of ByteArrayEncoder {
    fn encode(data: ByteArray) -> ByteArray {
        let mut char_set = get_base64_char_set();
        char_set.append('-');
        char_set.append('_');
        encode_byte_array(data, char_set.span())
    }
}

pub fn encode_u8_array(mut bytes: Array<u8>, base64_chars: Span<u8>) -> Array<u8> {
    let mut result = array![];
    if bytes.len() == 0 {
        return result;
    }
    let mut p: u8 = 0;
    let c = bytes.len() % 3;
    if c == 1 {
        p = 2;
        bytes.append(0_u8);
        bytes.append(0_u8);
    } else if c == 2 {
        p = 1;
        bytes.append(0_u8);
    }

    let mut i = 0;
    let bytes_len = bytes.len();
    let last_iteration = bytes_len - 3;
    while (i != bytes_len) {
        let n: u32 = (*bytes[i]).into()
            * 65536 | (*bytes[i + 1]).into()
            * 256 | (*bytes[i + 2]).into();
        let e1 = (n / 262144) & 63;
        let e2 = (n / 4096) & 63;
        let e3 = (n / 64) & 63;
        let e4 = n & 63;
        result.append(*base64_chars[e1]);
        result.append(*base64_chars[e2]);
        if i == last_iteration {
            if p == 2 {
                result.append('=');
                result.append('=');
            } else if p == 1 {
                result.append(*base64_chars[e3]);
                result.append('=');
            } else {
                result.append(*base64_chars[e3]);
                result.append(*base64_chars[e4]);
            }
        } else {
            result.append(*base64_chars[e3]);
            result.append(*base64_chars[e4]);
        }
        i += 3;
    }
    result
}

pub fn encode_felt(self: felt252, base64_chars: Span<u8>) -> Array<u8> {
    let mut result = array![];

    let mut num: u256 = self.into();
    if num != 0 {
        let (quotient, remainder) = DivRem::div_rem(num, 65536_u256.try_into().unwrap());
        // Safe since 'remainder' is always less than 65536 (2^16),
        // which is within the range of usize (less than 2^32).
        let remainder: usize = remainder.try_into().unwrap();
        let r3 = (remainder / 1024) & 63;
        let r2 = (remainder / 16) & 63;
        let r1 = (remainder * 4) & 63;
        result.append(*base64_chars[r1]);
        result.append(*base64_chars[r2]);
        result.append(*base64_chars[r3]);
        num = quotient;
    }
    while (num != 0) {
        let (quotient, remainder) = DivRem::div_rem(num, 16777216_u256.try_into().unwrap());
        // Safe since 'remainder' is always less than 16777216 (2^24),
        // which is within the range of usize (less than 2^32).
        let remainder: usize = remainder.try_into().unwrap();
        let r4 = remainder / 262144;
        let r3 = (remainder / 4096) & 63;
        let r2 = (remainder / 64) & 63;
        let r1 = remainder & 63;
        result.append(*base64_chars[r1]);
        result.append(*base64_chars[r2]);
        result.append(*base64_chars[r3]);
        result.append(*base64_chars[r4]);
        num = quotient;
    }
    while (result.len() < 43) {
        result.append('A');
    }
    result = result.reversed();
    result.append('=');
    result
}

/// Encodes a ByteArray into a Base64 encoded ByteArray.
///
/// This function processes the input binary data in chunks of 3 bytes,
/// converts them into their corresponding 6-bit values, and combines
/// them into 24-bit numbers. It then maps these values to Base64 characters
/// and handles any necessary padding.
///
/// # Arguments
///
/// * `self` - A mutable ByteArray containing the binary data to be encoded.
/// * `base64_chars` - A Span containing the Base64 character set used for encoding.
///
/// # Returns
/// * A ByteArray containing the Base64 encoded data.
pub fn encode_byte_array(mut self: ByteArray, base64_chars: Span<u8>) -> ByteArray {
    let mut result = Default::default();
    if self.len() == 0 {
        return result;
    }

    let mut p: u8 = 0;
    let c = self.len() % 3;
    if c == 1 {
        p = 2;
        self.append_u16(0x0000);
    } else if c == 2 {
        p = 1;
        self.append_byte(0x00);
    }

    let mut i = 0;
    let len = self.len();
    let last_iteration = len - 3;

    while i != len {
        let (_, n) = self.read_uint_within_size::<u32>(i, 3);
        let e1 = (n / 262144) & 63;
        let e2 = (n / 4096) & 63;
        let e3 = (n / 64) & 63;
        let e4 = n & 63;

        result.append_byte(*base64_chars[e1]);
        result.append_byte(*base64_chars[e2]);
        if i == last_iteration {
            if p == 2 {
                result.append_u16('==');
            } else if p == 1 {
                result.append_byte(*base64_chars[e3]);
                result.append_byte('=');
            } else {
                result.append_byte(*base64_chars[e3]);
                result.append_byte(*base64_chars[e4]);
            }
        } else {
            result.append_byte(*base64_chars[e3]);
            result.append_byte(*base64_chars[e4]);
        }
        i += 3;
    }

    result
}

pub impl Base64Decoder of Decoder<Array<u8>> {
    fn decode(data: Array<u8>) -> Array<u8> {
        inner_decode(data)
    }
}

pub impl Base64UrlDecoder of Decoder<Array<u8>> {
    fn decode(data: Array<u8>) -> Array<u8> {
        inner_decode(data)
    }
}

pub impl Base64ByteArrayDecoder of ByteArrayDecoder {
    fn decode(data: ByteArray) -> ByteArray {
        decode_byte_array(data)
    }
}

fn inner_decode(data: Array<u8>) -> Array<u8> {
    let mut result = array![];

    // Early return for empty input
    if data.len() == 0 {
        return result;
    }

    // Calculate padding
    let mut p = 0_u8;
    let data_len = data.len();

    // Check for padding characters ('=')
    if data_len > 0 && *data[data_len - 1] == '=' {
        p += 1;

        if data_len > 1 && *data[data_len - 2] == '=' {
            p += 1;
        }
    }

    // Process data in groups of 4 characters
    let mut i = 0;
    while i + 3 < data_len {
        // Extract the 3 bytes
        let (combined, b1) = get_decoded_b1(*data[i], *data[i + 1], *data[i + 2], *data[i + 3]);
        result.append(b1);

        // Handle padding - don't add bytes if we're at the end with padding
        if i + 4 >= data_len && p == 2 {
            break;
        }

        let b2: u8 = get_decoded_b2(combined);
        result.append(b2);

        if i + 4 >= data_len && p == 1 {
            break;
        }

        let b3: u8 = get_decoded_b3(combined);
        result.append(b3);

        i += 4;
    }

    result
}

/// Decodes a Base64 encoded ByteArray into its original binary form.
///
/// This function processes the input data in chunks of 4 characters,
/// converts them into their corresponding 6-bit values, and combines
/// them into 24-bit numbers. It then extracts the original bytes from
/// these 24-bit numbers and handles any padding that may be present.
///
/// # Arguments
/// * `data` - A ByteArray containing Base64 encoded data.
///
/// # Returns
/// * A ByteArray containing the decoded binary data.
fn decode_byte_array(data: ByteArray) -> ByteArray {
    let mut result: ByteArray = Default::default();

    // Early return for empty input
    if data.len() == 0 {
        return result;
    }

    // Calculate padding
    let mut p = 0_u8;
    let data_len = data.len();

    // Check for padding characters ('=')
    if data_len > 0 && data.at(data_len - 1).unwrap().into() == '=' {
        p += 1;

        if data_len > 1 && data.at(data_len - 2).unwrap() == '=' {
            p += 1;
        }
    }

    // Process data in groups of 4 characters
    let mut i = 0;
    while i + 3 < data_len {
        // Extract the 3 bytes
        let (combined, b1) = get_decoded_b1(
            data.at(i).unwrap(),
            data.at(i + 1).unwrap(),
            data.at(i + 2).unwrap(),
            data.at(i + 3).unwrap(),
        );
        result.append_byte(b1);
        // Handle padding - don't add bytes if we're at the end with padding
        if i + 4 >= data_len && p == 2 {
            break;
        }

        let b2: u8 = get_decoded_b2(combined);
        result.append_byte(b2);

        if i + 4 >= data_len && p == 1 {
            break;
        }

        let b3: u8 = get_decoded_b3(combined);
        result.append_byte(b3);

        i += 4;
    }

    result
}

/// Decodes the first byte from a group of four Base64 characters.
///
/// This function takes four Base64 values, combines them into a 24-bit number,
/// and extracts the first byte from this number.
///
/// # Arguments
/// * `val1` - The first Base64 character value.
/// * `val2` - The second Base64 character value.
/// * `val3` - The third Base64 character value.
/// * `val4` - The fourth Base64 character value.
///
/// # Returns
/// * A tuple containing the combined 24-bit number and the first decoded byte.
fn get_decoded_b1(val1: u8, val2: u8, val3: u8, val4: u8) -> (u32, u8) {
    let v1: u32 = get_base64_value(val1).into();
    let v2: u32 = get_base64_value(val2).into();
    let v3: u32 = get_base64_value(val3).into();
    let v4: u32 = get_base64_value(val4).into();

    let combined: u32 = (v1 * 262144) + (v2 * 4096) + (v3 * 64) + v4;
    (combined, ((combined / 65536) & 0xFF).try_into().unwrap())
}

/// Decodes the second byte from a 24-bit combined number.
///
/// This function extracts the second byte from a 24-bit number
/// that was previously combined from four Base64 character values.
///
/// # Arguments
/// * `val` - The 24-bit combined number.
///
/// # Returns
/// * decoded byte.
fn get_decoded_b2(val: u32) -> u8 {
    ((val / 256) & 0xFF).try_into().unwrap()
}

/// Decodes the third byte from a 24-bit combined number.
///
/// This function extracts the third byte from a 24-bit number
/// that was previously combined from four Base64 character values.
///
/// # Arguments
/// * `val` - The 24-bit combined number.
///
/// # Returns
/// * decoded byte.
fn get_decoded_b3(val: u32) -> u8 {
    (val & 0xFF).try_into().unwrap()
}

fn get_base64_value(x: u8) -> u8 {
    // Fast lookup based on ASCII values
    if x == '+' || x == '-' {
        return 62;
    }

    if x == '/' || x == '_' {
        return 63;
    }

    if x >= 'A' && x <= 'Z' {
        return x - 'A';
    }

    if x >= 'a' && x <= 'z' {
        return (x - 'a') + 26;
    }

    if x >= '0' && x <= '9' {
        return (x - '0') + 52;
    }

    // '=' padding character or any other character
    return 0;
}

fn get_base64_char_set() -> Array<u8> {
    let mut result = array![
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
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
        'l',
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
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
    ];
    result
}
