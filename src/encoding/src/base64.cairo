use alexandria_math::BitShift;
use integer::BoundedInt;

const U6_MAX: u128 = 0x3F;

trait Encoder<T> {
    fn encode(data: T) -> Array<u8>;
}

trait Decoder<T> {
    fn decode(data: T) -> Array<u8>;
}

impl Base64Encoder of Encoder<Array<u8>> {
    fn encode(data: Array<u8>) -> Array<u8> {
        let mut char_set = get_base64_char_set();
        char_set.append('+');
        char_set.append('/');
        inner_encode(data, char_set)
    }
}

impl Base64UrlEncoder of Encoder<Array<u8>> {
    fn encode(data: Array<u8>) -> Array<u8> {
        let mut char_set = get_base64_char_set();
        char_set.append('-');
        char_set.append('_');
        inner_encode(data, char_set)
    }
}

fn inner_encode(mut bytes: Array<u8>, base64_chars: Array<u8>) -> Array<u8> {
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
    loop {
        if i == bytes_len {
            break;
        }
        let n: u32 = (*bytes[i]).into() * 65536_u32
            | (*bytes[i + 1]).into() * 256_u32
            | (*bytes[i + 2]).into();
        let e1: usize = ((n / 262144) & 63).try_into().unwrap();
        let e2: usize = ((n / 4096) & 63).try_into().unwrap();
        let e3: usize = ((n / 64) & 63).try_into().unwrap();
        let e4: usize = (n & 63).try_into().unwrap();
        result.append(*base64_chars[e1]);
        result.append(*base64_chars[(e2)]);
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
    };
    result
}

impl Base64Decoder of Decoder<Array<u8>> {
    fn decode(data: Array<u8>) -> Array<u8> {
        inner_decode(data)
    }
}

impl Base64UrlDecoder of Decoder<Array<u8>> {
    fn decode(mut data: Array<u8>) -> Array<u8> {
        inner_decode(data)
    }
}


fn inner_decode(data: Array<u8>) -> Array<u8> {
    let mut result = array![];
    let mut p = 0_u8;
    if data.len() > 0 {
        if *data[data.len() - 1] == '=' {
            p += 1;
        }
        if *data[data.len() - 2] == '=' {
            p += 1;
        }
        decode_loop(p, data, 0, ref result);
    }
    result
}

fn decode_loop(p: u8, data: Array<u8>, d: usize, ref result: Array<u8>) {
    if (d >= data.len()) {
        return;
    }
    let x: u128 = BitShift::shl((get_base64_value(*data[d]).into()), 18)
        | BitShift::shl((get_base64_value(*data[d + 1])).into(), 12)
        | BitShift::shl((get_base64_value(*data[d + 2])).into(), 6)
        | (get_base64_value(*data[d + 3])).into();

    let mut i: u8 = (BitShift::shr(x, 16) & BoundedInt::<u8>::max().into()).try_into().unwrap();
    result.append(i);
    i = (BitShift::shr(x, 8) & BoundedInt::<u8>::max().into()).try_into().unwrap();
    if d + 4 >= data.len() && p == 2 {
        return;
    }
    result.append(i);

    i = (x & BoundedInt::<u8>::max().into()).try_into().unwrap();
    if d + 4 >= data.len() && p == 1 {
        return;
    }
    result.append(i);
    decode_loop(p, data, d + 4, ref result);
}

fn get_base64_value(x: u8) -> u8 {
    if (x == '+') {
        62
    } else if (x == '-') {
        62
    } else if (x == '/') {
        63
    } else if (x <= '9') {
        (x - '0') + 52
    } else if (x == '=') {
        0
    } else if (x <= 'Z') {
        (x - 'A') + 0
    } else if (x == '_') {
        63
    } else if (x <= 'z') {
        (x - 'a') + 26
    } else {
        0
    }
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
        '9'
    ];
    result
}
