use core::clone::Clone;
use array::ArrayTrait;
use integer::{upcast, downcast};
use option::OptionTrait;
use debug::PrintTrait;
use alexandria_math::math::{shl, shr, U6_MAX, U8_MAX};

trait Encoder<T> {
    fn encode(data: T) -> Array<u8>;
}

trait Decoder<T> {
    fn decode(data: T) -> Array<u8>;
}

impl Base64Encoder of Encoder<Array<u8>> {
    fn encode(mut data: Array<u8>) -> Array<u8> {
        let mut char_set = get_base64_char_set();
        char_set.append('+');
        char_set.append('/');
        inner_encode(ref data, ref char_set)
    }
}

impl Base64UrlEncoder of Encoder<Array<u8>> {
    fn encode(mut data: Array<u8>) -> Array<u8> {
        let mut char_set = get_base64_char_set();
        char_set.append('-');
        char_set.append('_');
        inner_encode(ref data, ref char_set)
    }
}

impl Base64Decoder of Decoder<Array<u8>> {
    fn decode(mut data: Array<u8>) -> Array<u8> {
        inner_decode(ref data)
    }
}

impl Base64UrlDecoder of Decoder<Array<u8>> {
    fn decode(mut data: Array<u8>) -> Array<u8> {
        inner_decode(ref data)
    }
}

fn inner_encode(ref data: Array<u8>, ref char_set: Array<u8>) -> Array<u8> {
    let mut p = if (data.len() % 3 == 1) {
        data.append(0);
        data.append(0);
        2
    } else if (data.len() % 3 == 2) {
        data.append(0);
        1
    } else {
        0
    };

    let mut char_set = get_base64_char_set();
    char_set.append('-');
    char_set.append('_');
    let mut result = ArrayTrait::new();
    encode_loop(p, ref data, 0, ref char_set, ref result);
    result
}

fn inner_decode(ref data: Array<u8>) -> Array<u8> {
    let mut result = ArrayTrait::new();
    let mut p = 0_u8;
    if data.len() > 0 {
        if *data[data.len() - 1] == '=' {
            p += 1;
        }
        if *data[data.len() - 2] == '=' {
            p += 1;
        }
        decode_loop(p, ref data, 0, ref result);
    }
    result
}

fn decode_loop(p: u8, ref data: Array<u8>, d: usize, ref result: Array<u8>) {
    if (d >= data.len()) {
        return ();
    }
    let x: u128 = shl(
        upcast(get_base64_value(*data[d])), 18
    ) | shl(
        upcast(get_base64_value(*data[d + 1])), 12
    ) | shl(upcast(get_base64_value(*data[d + 2])), 6) | upcast(get_base64_value(*data[d + 3]));

    let i: u8 = downcast(shr(x, 16) & U8_MAX).unwrap();
    result.append(i);
    let i: u8 = downcast(shr(x, 8) & U8_MAX).unwrap();
    if d
        + 4 >= data.len() {
            if p == 2 {
                return ();
            } else {
                result.append(i);
            }
        } else {
            result.append(i);
        }

    let i: u8 = downcast(x & U8_MAX).unwrap();
    if d
        + 4 >= data.len() {
            if p == 1 {
                return ();
            } else {
                result.append(i);
            }
        } else {
            result.append(i);
        }
    decode_loop(p, ref data, d + 4, ref result);
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

fn encode_loop(
    p: u8, ref data: Array<u8>, d: usize, ref char_set: Array<u8>, ref result: Array<u8>
) {
    if (d >= data.len()) {
        return ();
    }
    let x = 0_u128;
    let x = x | shl(upcast(*data[d]), 16);
    let x = x | shl(upcast(*data[d + 1]), 8);
    let x = x | upcast(*data[d + 2]);

    let i: u8 = downcast(shr(x, 18) & U6_MAX).unwrap();
    result.append(*char_set[upcast(i)]);
    let i: u8 = downcast(shr(x, 12) & U6_MAX).unwrap();
    result.append(*char_set[upcast(i)]);
    let i: u8 = downcast(shr(x, 6) & U6_MAX).unwrap();
    if upcast(d)
        + 3 >= data.len() {
            if p == 2 {
                result.append('=');
            } else {
                result.append(*char_set[upcast(i)]);
            }
        } else {
            result.append(*char_set[upcast(i)]);
        }
    let i: u8 = downcast(x & U6_MAX).unwrap();
    if upcast(d)
        + 3 >= data.len() {
            if p >= 1 {
                result.append('=');
            } else {
                result.append(*char_set[upcast(i)]);
            }
        } else {
            result.append(*char_set[upcast(i)]);
        }
    encode_loop(p, ref data, d + 3, ref char_set, ref result);
}

fn get_base64_char_set() -> Array<u8> {
    let mut result = ArrayTrait::new();
    result.append('A');
    result.append('B');
    result.append('C');
    result.append('D');
    result.append('E');
    result.append('F');
    result.append('G');
    result.append('H');
    result.append('I');
    result.append('J');
    result.append('K');
    result.append('L');
    result.append('M');
    result.append('N');
    result.append('O');
    result.append('P');
    result.append('Q');
    result.append('R');
    result.append('S');
    result.append('T');
    result.append('U');
    result.append('V');
    result.append('W');
    result.append('X');
    result.append('Y');
    result.append('Z');
    result.append('a');
    result.append('b');
    result.append('c');
    result.append('d');
    result.append('e');
    result.append('f');
    result.append('g');
    result.append('h');
    result.append('i');
    result.append('j');
    result.append('k');
    result.append('l');
    result.append('m');
    result.append('n');
    result.append('o');
    result.append('p');
    result.append('q');
    result.append('r');
    result.append('s');
    result.append('t');
    result.append('u');
    result.append('v');
    result.append('w');
    result.append('x');
    result.append('y');
    result.append('z');
    result.append('0');
    result.append('1');
    result.append('2');
    result.append('3');
    result.append('4');
    result.append('5');
    result.append('6');
    result.append('7');
    result.append('8');
    result.append('9');
    result
}
