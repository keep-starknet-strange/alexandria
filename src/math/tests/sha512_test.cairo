use array::{ArrayTrait};
use alexandria::math::sha512::{WordOperations, sha512, Word64, Word64WordOperations};

fn get_lorem_ipsum() -> Array<u8> {
    let mut input: Array<u8> = array![
        0x4C,
        0x6F,
        0x72,
        0x65,
        0x6D,
        0x20,
        0x69,
        0x70,
        0x73,
        0x75,
        0x6D,
        0x2C,
        0x20,
        0x6F,
        0x72,
        0x20,
        0x6C,
        0x73,
        0x69,
        0x70,
        0x73,
        0x75,
        0x6D,
        0x20,
        0x61,
        0x73,
        0x20,
        0x69,
        0x74,
        0x20,
        0x69,
        0x73,
        0x20,
        0x73,
        0x6F,
        0x6D,
        0x65,
        0x74,
        0x69,
        0x6D,
        0x65,
        0x73,
        0x20,
        0x6B,
        0x6E,
        0x6F,
        0x77,
        0x6E,
        0x2C,
        0x20,
        0x69,
        0x73,
        0x20,
        0x64,
        0x75,
        0x6D,
        0x6D,
        0x79,
        0x20,
        0x74,
        0x65,
        0x78,
        0x74,
        0x20,
        0x75,
        0x73,
        0x65,
        0x64,
        0x20,
        0x69,
        0x6E,
        0x20,
        0x6C,
        0x61,
        0x79,
        0x69,
        0x6E,
        0x67,
        0x20,
        0x6F,
        0x75,
        0x74,
        0x20,
        0x70,
        0x72,
        0x69,
        0x6E,
        0x74,
        0x2C,
        0x20,
        0x67,
        0x72,
        0x61,
        0x70,
        0x68,
        0x69,
        0x63,
        0x20,
        0x6F,
        0x72,
        0x20,
        0x77,
        0x65,
        0x62,
        0x20,
        0x64,
        0x65,
        0x73,
        0x69,
        0x67,
        0x6E,
        0x73,
        0x2E,
        0x20,
        0x54,
        0x68,
        0x65,
        0x20,
        0x70,
        0x61,
        0x73,
        0x73,
        0x61,
        0x67,
        0x65,
        0x20,
        0x69,
        0x73,
        0x20,
        0x61,
        0x74,
        0x74,
        0x72,
        0x69,
        0x62,
        0x75,
        0x74,
        0x65,
        0x64,
        0x20,
        0x74,
        0x6F,
        0x20,
        0x61,
        0x6E,
        0x20,
        0x75,
        0x6E,
        0x6B,
        0x6E,
        0x6F,
        0x77,
        0x6E,
        0x20,
        0x74,
        0x79,
        0x70,
        0x65,
        0x73,
        0x65,
        0x74,
        0x74,
        0x65,
        0x72,
        0x20,
        0x69,
        0x6E,
        0x20,
        0x74,
        0x68,
        0x65,
        0x20,
        0x31,
        0x35,
        0x74,
        0x68,
        0x20,
        0x63,
        0x65,
        0x6E,
        0x74,
        0x75,
        0x72,
        0x79,
        0x20,
        0x77,
        0x68,
        0x6F,
        0x20,
        0x69,
        0x73,
        0x20,
        0x74,
        0x68,
        0x6F,
        0x75,
        0x67,
        0x68,
        0x74,
        0x20,
        0x74,
        0x6F,
        0x20,
        0x68,
        0x61,
        0x76,
        0x65,
        0x20,
        0x73,
        0x63,
        0x72,
        0x61,
        0x6D,
        0x62,
        0x6C,
        0x65,
        0x64,
        0x20,
        0x70,
        0x61,
        0x72,
        0x74,
        0x73,
        0x20,
        0x6F,
        0x66,
        0x20,
        0x43,
        0x69,
        0x63,
        0x65,
        0x72,
        0x6F,
        0x27,
        0x73,
        0x20,
        0x44,
        0x65,
        0x20,
        0x46,
        0x69,
        0x6E,
        0x69,
        0x62,
        0x75,
        0x73,
        0x20,
        0x42,
        0x6F,
        0x6E,
        0x6F,
        0x72,
        0x75,
        0x6D,
        0x20,
        0x65,
        0x74,
        0x20,
        0x4D,
        0x61,
        0x6C,
        0x6F,
        0x72,
        0x75,
        0x6D,
        0x20,
        0x66,
        0x6F,
        0x72,
        0x20,
        0x75,
        0x73,
        0x65,
        0x20,
        0x69,
        0x6E,
        0x20,
        0x61,
        0x20,
        0x74,
        0x79,
        0x70,
        0x65,
        0x20,
        0x73,
        0x70,
        0x65,
        0x63,
        0x69,
        0x6D,
        0x65,
        0x6E,
        0x20,
        0x62,
        0x6F,
        0x6F,
        0x6B,
        0x2E,
        0x20,
        0x49,
        0x74,
        0x20,
        0x75,
        0x73,
        0x75,
        0x61,
        0x6C,
        0x6C,
        0x79,
        0x20,
        0x62,
        0x65,
        0x67,
        0x69,
        0x6E,
        0x73,
        0x20,
        0x77,
        0x69,
        0x74,
        0x68
    ];
    input
}

#[test]
#[available_gas(20000000000)]
fn test_sha512_lorem_ipsum() {
    let msg = get_lorem_ipsum();
    let res = sha512(msg);

    assert(res.len() == 64, 'Incorrect hash length');

    assert(*res[0] == 0xd5, 'Incorrect hash value');
    assert(*res[1] == 0xa2, 'Incorrect hash value');
    assert(*res[2] == 0xe1, 'Incorrect hash value');
    assert(*res[3] == 0x4e, 'Incorrect hash value');
    assert(*res[4] == 0xf4, 'Incorrect hash value');
    assert(*res[5] == 0x20, 'Incorrect hash value');
    assert(*res[6] == 0xf8, 'Incorrect hash value');
    assert(*res[7] == 0x2d, 'Incorrect hash value');
    assert(*res[8] == 0x68, 'Incorrect hash value');
    assert(*res[9] == 0x2b, 'Incorrect hash value');
    assert(*res[10] == 0x19, 'Incorrect hash value');
    assert(*res[11] == 0xc3, 'Incorrect hash value');
    assert(*res[12] == 0xd0, 'Incorrect hash value');
    assert(*res[13] == 0x70, 'Incorrect hash value');
    assert(*res[14] == 0xf4, 'Incorrect hash value');
    assert(*res[15] == 0x81, 'Incorrect hash value');
    assert(*res[16] == 0x14, 'Incorrect hash value');
    assert(*res[17] == 0xcb, 'Incorrect hash value');
    assert(*res[18] == 0xb9, 'Incorrect hash value');
    assert(*res[19] == 0x74, 'Incorrect hash value');
    assert(*res[20] == 0x7c, 'Incorrect hash value');
    assert(*res[21] == 0x7d, 'Incorrect hash value');
    assert(*res[22] == 0xb1, 'Incorrect hash value');
    assert(*res[23] == 0x15, 'Incorrect hash value');
    assert(*res[24] == 0xce, 'Incorrect hash value');
    assert(*res[25] == 0xa5, 'Incorrect hash value');
    assert(*res[26] == 0x41, 'Incorrect hash value');
    assert(*res[27] == 0x3e, 'Incorrect hash value');
    assert(*res[28] == 0xf8, 'Incorrect hash value');
    assert(*res[29] == 0xcb, 'Incorrect hash value');
    assert(*res[30] == 0x8f, 'Incorrect hash value');
    assert(*res[31] == 0xba, 'Incorrect hash value');
    assert(*res[32] == 0xc6, 'Incorrect hash value');
    assert(*res[33] == 0x90, 'Incorrect hash value');
    assert(*res[34] == 0x17, 'Incorrect hash value');
    assert(*res[35] == 0xc5, 'Incorrect hash value');
    assert(*res[36] == 0x17, 'Incorrect hash value');
    assert(*res[37] == 0x0f, 'Incorrect hash value');
    assert(*res[38] == 0x01, 'Incorrect hash value');
    assert(*res[39] == 0xc4, 'Incorrect hash value');
    assert(*res[40] == 0x77, 'Incorrect hash value');
    assert(*res[41] == 0xb3, 'Incorrect hash value');
    assert(*res[42] == 0xdf, 'Incorrect hash value');
    assert(*res[43] == 0x3d, 'Incorrect hash value');
    assert(*res[44] == 0xfb, 'Incorrect hash value');
    assert(*res[45] == 0x34, 'Incorrect hash value');
    assert(*res[46] == 0xd3, 'Incorrect hash value');
    assert(*res[47] == 0x50, 'Incorrect hash value');
    assert(*res[48] == 0x8f, 'Incorrect hash value');
    assert(*res[49] == 0xa0, 'Incorrect hash value');
    assert(*res[50] == 0xb2, 'Incorrect hash value');
    assert(*res[51] == 0xb1, 'Incorrect hash value');
    assert(*res[52] == 0x37, 'Incorrect hash value');
    assert(*res[53] == 0xd4, 'Incorrect hash value');
    assert(*res[54] == 0xcb, 'Incorrect hash value');
    assert(*res[55] == 0x54, 'Incorrect hash value');
    assert(*res[56] == 0x60, 'Incorrect hash value');
    assert(*res[57] == 0x9e, 'Incorrect hash value');
    assert(*res[58] == 0x63, 'Incorrect hash value');
    assert(*res[59] == 0x3d, 'Incorrect hash value');
    assert(*res[60] == 0x14, 'Incorrect hash value');
    assert(*res[61] == 0x45, 'Incorrect hash value');
    assert(*res[62] == 0x82, 'Incorrect hash value');
    assert(*res[63] == 0xc9, 'Incorrect hash value');
}

#[test]
#[available_gas(20000000000)]
fn test_sha512_size_one() {
    let mut arr: Array<u8> = array![49];
    let mut res = sha512(arr);

    assert(res.len() == 64, 'Len should be 64');

    assert(*res[0] == 0x4d, 'invalid value for hash');
    assert(*res[1] == 0xff, 'invalid value for hash');
    assert(*res[2] == 0x4e, 'invalid value for hash');
    assert(*res[3] == 0xa3, 'invalid value for hash');
    assert(*res[4] == 0x40, 'invalid value for hash');
    assert(*res[5] == 0xf0, 'invalid value for hash');
    assert(*res[6] == 0xa8, 'invalid value for hash');
    assert(*res[7] == 0x23, 'invalid value for hash');
    assert(*res[8] == 0xf1, 'invalid value for hash');
    assert(*res[9] == 0x5d, 'invalid value for hash');
    assert(*res[10] == 0x3f, 'invalid value for hash');
    assert(*res[11] == 0x4f, 'invalid value for hash');
    assert(*res[12] == 0x01, 'invalid value for hash');
    assert(*res[13] == 0xab, 'invalid value for hash');
    assert(*res[14] == 0x62, 'invalid value for hash');
    assert(*res[15] == 0xea, 'invalid value for hash');
    assert(*res[16] == 0xe0, 'invalid value for hash');
    assert(*res[17] == 0xe5, 'invalid value for hash');
    assert(*res[18] == 0xda, 'invalid value for hash');
    assert(*res[19] == 0x57, 'invalid value for hash');
    assert(*res[20] == 0x9c, 'invalid value for hash');
    assert(*res[21] == 0xcb, 'invalid value for hash');
    assert(*res[22] == 0x85, 'invalid value for hash');
    assert(*res[23] == 0x1f, 'invalid value for hash');
    assert(*res[24] == 0x8d, 'invalid value for hash');
    assert(*res[25] == 0xb9, 'invalid value for hash');
    assert(*res[26] == 0xdf, 'invalid value for hash');
    assert(*res[27] == 0xe8, 'invalid value for hash');
    assert(*res[28] == 0x4c, 'invalid value for hash');
    assert(*res[29] == 0x58, 'invalid value for hash');
    assert(*res[30] == 0xb2, 'invalid value for hash');
    assert(*res[31] == 0xb3, 'invalid value for hash');
    assert(*res[32] == 0x7b, 'invalid value for hash');
    assert(*res[33] == 0x89, 'invalid value for hash');
    assert(*res[34] == 0x90, 'invalid value for hash');
    assert(*res[35] == 0x3a, 'invalid value for hash');
    assert(*res[36] == 0x74, 'invalid value for hash');
    assert(*res[37] == 0x0e, 'invalid value for hash');
    assert(*res[38] == 0x1e, 'invalid value for hash');
    assert(*res[39] == 0xe1, 'invalid value for hash');
    assert(*res[40] == 0x72, 'invalid value for hash');
    assert(*res[41] == 0xda, 'invalid value for hash');
    assert(*res[42] == 0x79, 'invalid value for hash');
    assert(*res[43] == 0x3a, 'invalid value for hash');
    assert(*res[44] == 0x6e, 'invalid value for hash');
    assert(*res[45] == 0x79, 'invalid value for hash');
    assert(*res[46] == 0xd5, 'invalid value for hash');
    assert(*res[47] == 0x60, 'invalid value for hash');
    assert(*res[48] == 0xe5, 'invalid value for hash');
    assert(*res[49] == 0xf7, 'invalid value for hash');
    assert(*res[50] == 0xf9, 'invalid value for hash');
    assert(*res[51] == 0xbd, 'invalid value for hash');
    assert(*res[52] == 0x05, 'invalid value for hash');
    assert(*res[53] == 0x8a, 'invalid value for hash');
    assert(*res[54] == 0x12, 'invalid value for hash');
    assert(*res[55] == 0xa2, 'invalid value for hash');
    assert(*res[56] == 0x80, 'invalid value for hash');
    assert(*res[57] == 0x43, 'invalid value for hash');
    assert(*res[58] == 0x3e, 'invalid value for hash');
    assert(*res[59] == 0xd6, 'invalid value for hash');
    assert(*res[60] == 0xfa, 'invalid value for hash');
    assert(*res[61] == 0x46, 'invalid value for hash');
    assert(*res[62] == 0x51, 'invalid value for hash');
    assert(*res[63] == 0x0a, 'invalid value for hash');
}

#[test]
#[available_gas(20000000000)]
fn test_size_zero() {
    let msg = array![];

    let res = sha512(msg);

    assert(res.len() == 64, 'Incorrect hash len');
    assert(*res[0] == 0xcf, 'Incorrect hash len');
    assert(*res[1] == 0x83, 'Incorrect hash len');
    assert(*res[2] == 0xe1, 'Incorrect hash len');
    assert(*res[3] == 0x35, 'Incorrect hash len');
    assert(*res[4] == 0x7e, 'Incorrect hash len');
    assert(*res[5] == 0xef, 'Incorrect hash len');
    assert(*res[6] == 0xb8, 'Incorrect hash len');
    assert(*res[7] == 0xbd, 'Incorrect hash len');
    assert(*res[8] == 0xf1, 'Incorrect hash len');
    assert(*res[9] == 0x54, 'Incorrect hash len');
    assert(*res[10] == 0x28, 'Incorrect hash len');
    assert(*res[11] == 0x50, 'Incorrect hash len');
    assert(*res[12] == 0xd6, 'Incorrect hash len');
    assert(*res[13] == 0x6d, 'Incorrect hash len');
    assert(*res[14] == 0x80, 'Incorrect hash len');
    assert(*res[15] == 0x07, 'Incorrect hash len');
    assert(*res[16] == 0xd6, 'Incorrect hash len');
    assert(*res[17] == 0x20, 'Incorrect hash len');
    assert(*res[18] == 0xe4, 'Incorrect hash len');
    assert(*res[19] == 0x05, 'Incorrect hash len');
    assert(*res[20] == 0x0b, 'Incorrect hash len');
    assert(*res[21] == 0x57, 'Incorrect hash len');
    assert(*res[22] == 0x15, 'Incorrect hash len');
    assert(*res[23] == 0xdc, 'Incorrect hash len');
    assert(*res[24] == 0x83, 'Incorrect hash len');
    assert(*res[25] == 0xf4, 'Incorrect hash len');
    assert(*res[26] == 0xa9, 'Incorrect hash len');
    assert(*res[27] == 0x21, 'Incorrect hash len');
    assert(*res[28] == 0xd3, 'Incorrect hash len');
    assert(*res[29] == 0x6c, 'Incorrect hash len');
    assert(*res[30] == 0xe9, 'Incorrect hash len');
    assert(*res[31] == 0xce, 'Incorrect hash len');
    assert(*res[32] == 0x47, 'Incorrect hash len');
    assert(*res[33] == 0xd0, 'Incorrect hash len');
    assert(*res[34] == 0xd1, 'Incorrect hash len');
    assert(*res[35] == 0x3c, 'Incorrect hash len');
    assert(*res[36] == 0x5d, 'Incorrect hash len');
    assert(*res[37] == 0x85, 'Incorrect hash len');
    assert(*res[38] == 0xf2, 'Incorrect hash len');
    assert(*res[39] == 0xb0, 'Incorrect hash len');
    assert(*res[40] == 0xff, 'Incorrect hash len');
    assert(*res[41] == 0x83, 'Incorrect hash len');
    assert(*res[42] == 0x18, 'Incorrect hash len');
    assert(*res[43] == 0xd2, 'Incorrect hash len');
    assert(*res[44] == 0x87, 'Incorrect hash len');
    assert(*res[45] == 0x7e, 'Incorrect hash len');
    assert(*res[46] == 0xec, 'Incorrect hash len');
    assert(*res[47] == 0x2f, 'Incorrect hash len');
    assert(*res[48] == 0x63, 'Incorrect hash len');
    assert(*res[49] == 0xb9, 'Incorrect hash len');
    assert(*res[50] == 0x31, 'Incorrect hash len');
    assert(*res[51] == 0xbd, 'Incorrect hash len');
    assert(*res[52] == 0x47, 'Incorrect hash len');
    assert(*res[53] == 0x41, 'Incorrect hash len');
    assert(*res[54] == 0x7a, 'Incorrect hash len');
    assert(*res[55] == 0x81, 'Incorrect hash len');
    assert(*res[56] == 0xa5, 'Incorrect hash len');
    assert(*res[57] == 0x38, 'Incorrect hash len');
    assert(*res[58] == 0x32, 'Incorrect hash len');
    assert(*res[59] == 0x7a, 'Incorrect hash len');
    assert(*res[60] == 0xf9, 'Incorrect hash len');
    assert(*res[61] == 0x27, 'Incorrect hash len');
    assert(*res[62] == 0xda, 'Incorrect hash len');
    assert(*res[63] == 0x3e, 'Incorrect hash len');
}
