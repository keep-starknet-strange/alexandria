mod Decoder {
    use array::ArrayTrait;
    use integer::{upcast, downcast};
    use option::OptionTrait;
    use debug::PrintTrait;
    use quaireaux_math::math::{shl, shr, U6_MAX, U8_MAX};

    fn decode(mut data: Array<u8>) -> Array<u8> {
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
        let x = 0_u128;
        let x = x | shl(upcast(get_base64_value(*data[d])), 18);
        let x = x | shl(upcast(get_base64_value(*data[d + 1])), 12);
        let x = x | shl(upcast(get_base64_value(*data[d + 2])), 6);
        let x = x | upcast(get_base64_value(*data[d + 3]));

        let i: u8 = downcast(shr(x, 16) & U8_MAX).unwrap();
        result.append(i);
        let i: u8 = downcast(shr(x, 8) & U8_MAX).unwrap();
        if d + 4 >= data.len() {
                if p == 2 {
                    return ();
                } else {
                    result.append(i);
                }
            } else {
                result.append(i);
            }

        let i: u8 = downcast(x & U8_MAX).unwrap();
        if d + 4 >= data.len() {
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
}

mod Encoder {
    use array::ArrayTrait;
    use integer::{upcast, downcast};
    use option::OptionTrait;
    use debug::PrintTrait;
    use quaireaux_math::math::{shl, shr, U6_MAX, U8_MAX};

    fn encode(mut data: Array<u8>) -> Array<u8> {
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

        let mut result = ArrayTrait::new();
        encode_loop(p, ref data, 0, ref result);

        result
    }


    fn encode_loop(p: u8, ref data: Array<u8>, d: usize, ref result: Array<u8>) {
        if (d >= data.len()) {
            return ();
        }
        let x = 0_u128;
        let x = x | shl(upcast(*data[d]), 16);
        let x = x | shl(upcast(*data[d + 1]), 8);
        let x = x | upcast(*data[d + 2]);

        let i: u8 = downcast(shr(x, 18) & U6_MAX).unwrap();
        result.append(get_base64_char(i));
        let i: u8 = downcast(shr(x, 12) & U6_MAX).unwrap();
        result.append(get_base64_char(i));
        let i: u8 = downcast(shr(x, 6) & U6_MAX).unwrap();
        if upcast(d) + 3 >= data.len() {
                if p == 2 {
                    result.append('=');
                } else {
                    result.append(get_base64_char(i));
                }
            } else {
                result.append(get_base64_char(i));
            }
        let i: u8 = downcast(x & U6_MAX).unwrap();
        if upcast(d) + 3 >= data.len() {
                if p >= 1 {
                    result.append('=');
                } else {
                    result.append(get_base64_char(i));
                }
            } else {
                result.append(get_base64_char(i));
            }
        encode_loop(p, ref data, d + 3, ref result);
    }

    fn get_base64_char(x: u8) -> u8 {
        if (x < 26) {
            x + 'A'
        } else if (x < 52) {
            (x - 26) + 'a'
        } else if (x < 62) {
            (x - 52) + '0'
        } else if (x == 62) {
            '+'
        } else {
            '/'
        }
    }

    fn encode_url(mut data: Array<u8>) -> Array<u8> {
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

        let mut result = ArrayTrait::new();
        encode_loop(p, ref data, 0, ref result);

        result
    }

    fn encode_url_loop(p: u8, ref data: Array<u8>, d: usize, ref result: Array<u8>) {
        if (d >= data.len()) {
            return ();
        }
        let x = 0_u128;
        let x = x | shl(upcast(*data[d]), 16);
        let x = x | shl(upcast(*data[d + 1]), 8);
        let x = x | upcast(*data[d + 2]);

        let i: u8 = downcast(shr(x, 18) & U6_MAX).unwrap();
        result.append(get_base64_url_char(i));
        let i: u8 = downcast(shr(x, 12) & U6_MAX).unwrap();
        result.append(get_base64_url_char(i));
        let i: u8 = downcast(shr(x, 6) & U6_MAX).unwrap();
        if upcast(d) + 3 >= data.len() {
                if p == 2 {
                    result.append('=');
                } else {
                    result.append(get_base64_url_char(i));
                }
            } else {
                result.append(get_base64_url_char(i));
            }
        let i: u8 = downcast(x & U6_MAX).unwrap();
        if upcast(d) + 3 >= data.len() {
                if p >= 1 {
                    result.append('=');
                } else {
                    result.append(get_base64_url_char(i));
                }
            } else {
                result.append(get_base64_url_char(i));
            }
        encode_url_loop(p, ref data, d + 3, ref result);
    }

    fn get_base64_url_char(x: u8) -> u8 {
        if (x < 26) {
            x + 'A'
        } else if (x < 52) {
            (x - 26) + 'a'
        } else if (x < 62) {
            (x - 52) + '0'
        } else if (x == 62) {
            '-'
        } else {
            '_'
        }
    }
}
