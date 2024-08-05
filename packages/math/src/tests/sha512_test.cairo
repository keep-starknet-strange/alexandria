use alexandria_math::sha512::{WordOperations, sha512, Word64, Word64WordOperations};

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

    assert_eq!(res.len(), 64);

    assert_eq!(*res[0], 0xd5);
    assert_eq!(*res[1], 0xa2);
    assert_eq!(*res[2], 0xe1);
    assert_eq!(*res[3], 0x4e);
    assert_eq!(*res[4], 0xf4);
    assert_eq!(*res[5], 0x20);
    assert_eq!(*res[6], 0xf8);
    assert_eq!(*res[7], 0x2d);
    assert_eq!(*res[8], 0x68);
    assert_eq!(*res[9], 0x2b);
    assert_eq!(*res[10], 0x19);
    assert_eq!(*res[11], 0xc3);
    assert_eq!(*res[12], 0xd0);
    assert_eq!(*res[13], 0x70);
    assert_eq!(*res[14], 0xf4);
    assert_eq!(*res[15], 0x81);
    assert_eq!(*res[16], 0x14);
    assert_eq!(*res[17], 0xcb);
    assert_eq!(*res[18], 0xb9);
    assert_eq!(*res[19], 0x74);
    assert_eq!(*res[20], 0x7c);
    assert_eq!(*res[21], 0x7d);
    assert_eq!(*res[22], 0xb1);
    assert_eq!(*res[23], 0x15);
    assert_eq!(*res[24], 0xce);
    assert_eq!(*res[25], 0xa5);
    assert_eq!(*res[26], 0x41);
    assert_eq!(*res[27], 0x3e);
    assert_eq!(*res[28], 0xf8);
    assert_eq!(*res[29], 0xcb);
    assert_eq!(*res[30], 0x8f);
    assert_eq!(*res[31], 0xba);
    assert_eq!(*res[32], 0xc6);
    assert_eq!(*res[33], 0x90);
    assert_eq!(*res[34], 0x17);
    assert_eq!(*res[35], 0xc5);
    assert_eq!(*res[36], 0x17);
    assert_eq!(*res[37], 0x0f);
    assert_eq!(*res[38], 0x01);
    assert_eq!(*res[39], 0xc4);
    assert_eq!(*res[40], 0x77);
    assert_eq!(*res[41], 0xb3);
    assert_eq!(*res[42], 0xdf);
    assert_eq!(*res[43], 0x3d);
    assert_eq!(*res[44], 0xfb);
    assert_eq!(*res[45], 0x34);
    assert_eq!(*res[46], 0xd3);
    assert_eq!(*res[47], 0x50);
    assert_eq!(*res[48], 0x8f);
    assert_eq!(*res[49], 0xa0);
    assert_eq!(*res[50], 0xb2);
    assert_eq!(*res[51], 0xb1);
    assert_eq!(*res[52], 0x37);
    assert_eq!(*res[53], 0xd4);
    assert_eq!(*res[54], 0xcb);
    assert_eq!(*res[55], 0x54);
    assert_eq!(*res[56], 0x60);
    assert_eq!(*res[57], 0x9e);
    assert_eq!(*res[58], 0x63);
    assert_eq!(*res[59], 0x3d);
    assert_eq!(*res[60], 0x14);
    assert_eq!(*res[61], 0x45);
    assert_eq!(*res[62], 0x82);
    assert_eq!(*res[63], 0xc9);
}

#[test]
#[available_gas(20000000000)]
fn test_sha512_size_one() {
    let mut arr: Array<u8> = array![49];
    let mut res = sha512(arr);

    assert_eq!(res.len(), 64);

    assert_eq!(*res[0], 0x4d);
    assert_eq!(*res[1], 0xff);
    assert_eq!(*res[2], 0x4e);
    assert_eq!(*res[3], 0xa3);
    assert_eq!(*res[4], 0x40);
    assert_eq!(*res[5], 0xf0);
    assert_eq!(*res[6], 0xa8);
    assert_eq!(*res[7], 0x23);
    assert_eq!(*res[8], 0xf1);
    assert_eq!(*res[9], 0x5d);
    assert_eq!(*res[10], 0x3f);
    assert_eq!(*res[11], 0x4f);
    assert_eq!(*res[12], 0x01);
    assert_eq!(*res[13], 0xab);
    assert_eq!(*res[14], 0x62);
    assert_eq!(*res[15], 0xea);
    assert_eq!(*res[16], 0xe0);
    assert_eq!(*res[17], 0xe5);
    assert_eq!(*res[18], 0xda);
    assert_eq!(*res[19], 0x57);
    assert_eq!(*res[20], 0x9c);
    assert_eq!(*res[21], 0xcb);
    assert_eq!(*res[22], 0x85);
    assert_eq!(*res[23], 0x1f);
    assert_eq!(*res[24], 0x8d);
    assert_eq!(*res[25], 0xb9);
    assert_eq!(*res[26], 0xdf);
    assert_eq!(*res[27], 0xe8);
    assert_eq!(*res[28], 0x4c);
    assert_eq!(*res[29], 0x58);
    assert_eq!(*res[30], 0xb2);
    assert_eq!(*res[31], 0xb3);
    assert_eq!(*res[32], 0x7b);
    assert_eq!(*res[33], 0x89);
    assert_eq!(*res[34], 0x90);
    assert_eq!(*res[35], 0x3a);
    assert_eq!(*res[36], 0x74);
    assert_eq!(*res[37], 0x0e);
    assert_eq!(*res[38], 0x1e);
    assert_eq!(*res[39], 0xe1);
    assert_eq!(*res[40], 0x72);
    assert_eq!(*res[41], 0xda);
    assert_eq!(*res[42], 0x79);
    assert_eq!(*res[43], 0x3a);
    assert_eq!(*res[44], 0x6e);
    assert_eq!(*res[45], 0x79);
    assert_eq!(*res[46], 0xd5);
    assert_eq!(*res[47], 0x60);
    assert_eq!(*res[48], 0xe5);
    assert_eq!(*res[49], 0xf7);
    assert_eq!(*res[50], 0xf9);
    assert_eq!(*res[51], 0xbd);
    assert_eq!(*res[52], 0x05);
    assert_eq!(*res[53], 0x8a);
    assert_eq!(*res[54], 0x12);
    assert_eq!(*res[55], 0xa2);
    assert_eq!(*res[56], 0x80);
    assert_eq!(*res[57], 0x43);
    assert_eq!(*res[58], 0x3e);
    assert_eq!(*res[59], 0xd6);
    assert_eq!(*res[60], 0xfa);
    assert_eq!(*res[61], 0x46);
    assert_eq!(*res[62], 0x51);
    assert_eq!(*res[63], 0x0a);
}

#[test]
#[available_gas(20000000000)]
fn test_size_zero() {
    let msg = array![];

    let res = sha512(msg);

    assert_eq!(res.len(), 64);
    assert_eq!(*res[0], 0xcf);
    assert_eq!(*res[1], 0x83);
    assert_eq!(*res[2], 0xe1);
    assert_eq!(*res[3], 0x35);
    assert_eq!(*res[4], 0x7e);
    assert_eq!(*res[5], 0xef);
    assert_eq!(*res[6], 0xb8);
    assert_eq!(*res[7], 0xbd);
    assert_eq!(*res[8], 0xf1);
    assert_eq!(*res[9], 0x54);
    assert_eq!(*res[10], 0x28);
    assert_eq!(*res[11], 0x50);
    assert_eq!(*res[12], 0xd6);
    assert_eq!(*res[13], 0x6d);
    assert_eq!(*res[14], 0x80);
    assert_eq!(*res[15], 0x07);
    assert_eq!(*res[16], 0xd6);
    assert_eq!(*res[17], 0x20);
    assert_eq!(*res[18], 0xe4);
    assert_eq!(*res[19], 0x05);
    assert_eq!(*res[20], 0x0b);
    assert_eq!(*res[21], 0x57);
    assert_eq!(*res[22], 0x15);
    assert_eq!(*res[23], 0xdc);
    assert_eq!(*res[24], 0x83);
    assert_eq!(*res[25], 0xf4);
    assert_eq!(*res[26], 0xa9);
    assert_eq!(*res[27], 0x21);
    assert_eq!(*res[28], 0xd3);
    assert_eq!(*res[29], 0x6c);
    assert_eq!(*res[30], 0xe9);
    assert_eq!(*res[31], 0xce);
    assert_eq!(*res[32], 0x47);
    assert_eq!(*res[33], 0xd0);
    assert_eq!(*res[34], 0xd1);
    assert_eq!(*res[35], 0x3c);
    assert_eq!(*res[36], 0x5d);
    assert_eq!(*res[37], 0x85);
    assert_eq!(*res[38], 0xf2);
    assert_eq!(*res[39], 0xb0);
    assert_eq!(*res[40], 0xff);
    assert_eq!(*res[41], 0x83);
    assert_eq!(*res[42], 0x18);
    assert_eq!(*res[43], 0xd2);
    assert_eq!(*res[44], 0x87);
    assert_eq!(*res[45], 0x7e);
    assert_eq!(*res[46], 0xec);
    assert_eq!(*res[47], 0x2f);
    assert_eq!(*res[48], 0x63);
    assert_eq!(*res[49], 0xb9);
    assert_eq!(*res[50], 0x31);
    assert_eq!(*res[51], 0xbd);
    assert_eq!(*res[52], 0x47);
    assert_eq!(*res[53], 0x41);
    assert_eq!(*res[54], 0x7a);
    assert_eq!(*res[55], 0x81);
    assert_eq!(*res[56], 0xa5);
    assert_eq!(*res[57], 0x38);
    assert_eq!(*res[58], 0x32);
    assert_eq!(*res[59], 0x7a);
    assert_eq!(*res[60], 0xf9);
    assert_eq!(*res[61], 0x27);
    assert_eq!(*res[62], 0xda);
    assert_eq!(*res[63], 0x3e);
}
