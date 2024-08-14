use alexandria_math::sha256;

#[test]
#[available_gas(2000000000)]
fn sha256_empty_test() {
    let mut input: Array<u8> = array![];
    let result = sha256::sha256(input);

    // result should be 0xE3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
    assert_eq!(result.len(), 32);
    assert_eq!(*result[0], 0xE3);
    assert_eq!(*result[1], 0xB0);
    assert_eq!(*result[2], 0xC4);
    assert_eq!(*result[3], 0x42);
    assert_eq!(*result[4], 0x98);
    assert_eq!(*result[5], 0xFC);
    assert_eq!(*result[6], 0x1C);
    assert_eq!(*result[7], 0x14);
    assert_eq!(*result[8], 0x9A);
    assert_eq!(*result[9], 0xFB);
    assert_eq!(*result[10], 0xF4);
    assert_eq!(*result[11], 0xC8);
    assert_eq!(*result[12], 0x99);
    assert_eq!(*result[13], 0x6F);
    assert_eq!(*result[14], 0xB9);
    assert_eq!(*result[15], 0x24);
    assert_eq!(*result[16], 0x27);
    assert_eq!(*result[17], 0xAE);
    assert_eq!(*result[18], 0x41);
    assert_eq!(*result[19], 0xE4);
    assert_eq!(*result[20], 0x64);
    assert_eq!(*result[21], 0x9B);
    assert_eq!(*result[22], 0x93);
    assert_eq!(*result[23], 0x4C);
    assert_eq!(*result[24], 0xA4);
    assert_eq!(*result[25], 0x95);
    assert_eq!(*result[26], 0x99);
    assert_eq!(*result[27], 0x1B);
    assert_eq!(*result[28], 0x78);
    assert_eq!(*result[29], 0x52);
    assert_eq!(*result[30], 0xB8);
    assert_eq!(*result[31], 0x55);
}

#[test]
#[available_gas(200000000000)]
fn sha256_random_data_test() {
    let mut input: Array<u8> = array![
        0x57, 0x77, 0x71, 0x71, 0x66, 0x50, 0x45, 0x51, 0x51, 0x43, 0x39, 0x48, 0x38
    ];
    let result = sha256::sha256(input);
    assert_eq!(*result[0], 61);
    assert_eq!(*result[1], 226);
    assert_eq!(*result[2], 188);
    assert_eq!(*result[3], 242);
    assert_eq!(*result[4], 118);
    assert_eq!(*result[5], 121);
    assert_eq!(*result[6], 7);
    assert_eq!(*result[7], 225);
    assert_eq!(*result[8], 150);
    assert_eq!(*result[9], 220);
    assert_eq!(*result[10], 105);
    assert_eq!(*result[11], 158);
    assert_eq!(*result[12], 185);
    assert_eq!(*result[13], 180);
    assert_eq!(*result[14], 139);
    assert_eq!(*result[15], 103);
    assert_eq!(*result[16], 221);
    assert_eq!(*result[17], 95);
    assert_eq!(*result[18], 56);
    assert_eq!(*result[19], 88);
    assert_eq!(*result[20], 209);
    assert_eq!(*result[21], 159);
    assert_eq!(*result[22], 255);
    assert_eq!(*result[23], 247);
    assert_eq!(*result[24], 145);
    assert_eq!(*result[25], 146);
    assert_eq!(*result[26], 83);
    assert_eq!(*result[27], 110);
    assert_eq!(*result[28], 185);
    assert_eq!(*result[29], 5);
    assert_eq!(*result[30], 248);
    assert_eq!(*result[31], 15);
}

#[test]
#[available_gas(2000000000)]
fn sha256_lorem_ipsum_test() {
    // Lorem ipsum, or lsipsum as it is sometimes known, is dummy text used in laying out print,
    // graphic or web designs.
    // The passage is attributed to an unknown typesetter in the 15th century who is thought to have
    // scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It
    // usually begins with
    let mut input = array![];
    input.append('L');
    input.append('o');
    input.append('r');
    input.append('e');
    input.append('m');
    input.append(' ');
    input.append(0x69);
    input.append(0x70);
    input.append(0x73);
    input.append(0x75);
    input.append(0x6D);
    input.append(0x2C);
    input.append(0x20);
    input.append(0x6F);
    input.append(0x72);
    input.append(0x20);
    input.append(0x6C);
    input.append(0x73);
    input.append(0x69);
    input.append(0x70);
    input.append(0x73);
    input.append(0x75);
    input.append(0x6D);
    input.append(0x20);
    input.append(0x61);
    input.append(0x73);
    input.append(0x20);
    input.append(0x69);
    input.append(0x74);
    input.append(0x20);
    input.append(0x69);
    input.append(0x73);
    input.append(0x20);
    input.append(0x73);
    input.append(0x6F);
    input.append(0x6D);
    input.append(0x65);
    input.append(0x74);
    input.append(0x69);
    input.append(0x6D);
    input.append(0x65);
    input.append(0x73);
    input.append(0x20);
    input.append(0x6B);
    input.append(0x6E);
    input.append(0x6F);
    input.append(0x77);
    input.append(0x6E);
    input.append(0x2C);
    input.append(0x20);
    input.append(0x69);
    input.append(0x73);
    input.append(0x20);
    input.append(0x64);
    input.append(0x75);
    input.append(0x6D);
    input.append(0x6D);
    input.append(0x79);
    input.append(0x20);
    input.append(0x74);
    input.append(0x65);
    input.append(0x78);
    input.append(0x74);
    input.append(0x20);
    input.append(0x75);
    input.append(0x73);
    input.append(0x65);
    input.append(0x64);
    input.append(0x20);
    input.append(0x69);
    input.append(0x6E);
    input.append(0x20);
    input.append(0x6C);
    input.append(0x61);
    input.append(0x79);
    input.append(0x69);
    input.append(0x6E);
    input.append(0x67);
    input.append(0x20);
    input.append(0x6F);
    input.append(0x75);
    input.append(0x74);
    input.append(0x20);
    input.append(0x70);
    input.append(0x72);
    input.append(0x69);
    input.append(0x6E);
    input.append(0x74);
    input.append(0x2C);
    input.append(0x20);
    input.append(0x67);
    input.append(0x72);
    input.append(0x61);
    input.append(0x70);
    input.append(0x68);
    input.append(0x69);
    input.append(0x63);
    input.append(0x20);
    input.append(0x6F);
    input.append(0x72);
    input.append(0x20);
    input.append(0x77);
    input.append(0x65);
    input.append(0x62);
    input.append(0x20);
    input.append(0x64);
    input.append(0x65);
    input.append(0x73);
    input.append(0x69);
    input.append(0x67);
    input.append(0x6E);
    input.append(0x73);
    input.append(0x2E);
    input.append(0x20);
    input.append(0x54);
    input.append(0x68);
    input.append(0x65);
    input.append(0x20);
    input.append(0x70);
    input.append(0x61);
    input.append(0x73);
    input.append(0x73);
    input.append(0x61);
    input.append(0x67);
    input.append(0x65);
    input.append(0x20);
    input.append(0x69);
    input.append(0x73);
    input.append(0x20);
    input.append(0x61);
    input.append(0x74);
    input.append(0x74);
    input.append(0x72);
    input.append(0x69);
    input.append(0x62);
    input.append(0x75);
    input.append(0x74);
    input.append(0x65);
    input.append(0x64);
    input.append(0x20);
    input.append(0x74);
    input.append(0x6F);
    input.append(0x20);
    input.append(0x61);
    input.append(0x6E);
    input.append(0x20);
    input.append(0x75);
    input.append(0x6E);
    input.append(0x6B);
    input.append(0x6E);
    input.append(0x6F);
    input.append(0x77);
    input.append(0x6E);
    input.append(0x20);
    input.append(0x74);
    input.append(0x79);
    input.append(0x70);
    input.append(0x65);
    input.append(0x73);
    input.append(0x65);
    input.append(0x74);
    input.append(0x74);
    input.append(0x65);
    input.append(0x72);
    input.append(0x20);
    input.append(0x69);
    input.append(0x6E);
    input.append(0x20);
    input.append(0x74);
    input.append(0x68);
    input.append(0x65);
    input.append(0x20);
    input.append(0x31);
    input.append(0x35);
    input.append(0x74);
    input.append(0x68);
    input.append(0x20);
    input.append(0x63);
    input.append(0x65);
    input.append(0x6E);
    input.append(0x74);
    input.append(0x75);
    input.append(0x72);
    input.append(0x79);
    input.append(0x20);
    input.append(0x77);
    input.append(0x68);
    input.append(0x6F);
    input.append(0x20);
    input.append(0x69);
    input.append(0x73);
    input.append(0x20);
    input.append(0x74);
    input.append(0x68);
    input.append(0x6F);
    input.append(0x75);
    input.append(0x67);
    input.append(0x68);
    input.append(0x74);
    input.append(0x20);
    input.append(0x74);
    input.append(0x6F);
    input.append(0x20);
    input.append(0x68);
    input.append(0x61);
    input.append(0x76);
    input.append(0x65);
    input.append(0x20);
    input.append(0x73);
    input.append(0x63);
    input.append(0x72);
    input.append(0x61);
    input.append(0x6D);
    input.append(0x62);
    input.append(0x6C);
    input.append(0x65);
    input.append(0x64);
    input.append(0x20);
    input.append(0x70);
    input.append(0x61);
    input.append(0x72);
    input.append(0x74);
    input.append(0x73);
    input.append(0x20);
    input.append(0x6F);
    input.append(0x66);
    input.append(0x20);
    input.append(0x43);
    input.append(0x69);
    input.append(0x63);
    input.append(0x65);
    input.append(0x72);
    input.append(0x6F);
    input.append(0x27);
    input.append(0x73);
    input.append(0x20);
    input.append(0x44);
    input.append(0x65);
    input.append(0x20);
    input.append(0x46);
    input.append(0x69);
    input.append(0x6E);
    input.append(0x69);
    input.append(0x62);
    input.append(0x75);
    input.append(0x73);
    input.append(0x20);
    input.append(0x42);
    input.append(0x6F);
    input.append(0x6E);
    input.append(0x6F);
    input.append(0x72);
    input.append(0x75);
    input.append(0x6D);
    input.append(0x20);
    input.append(0x65);
    input.append(0x74);
    input.append(0x20);
    input.append(0x4D);
    input.append(0x61);
    input.append(0x6C);
    input.append(0x6F);
    input.append(0x72);
    input.append(0x75);
    input.append(0x6D);
    input.append(0x20);
    input.append(0x66);
    input.append(0x6F);
    input.append(0x72);
    input.append(0x20);
    input.append(0x75);
    input.append(0x73);
    input.append(0x65);
    input.append(0x20);
    input.append(0x69);
    input.append(0x6E);
    input.append(0x20);
    input.append(0x61);
    input.append(0x20);
    input.append(0x74);
    input.append(0x79);
    input.append(0x70);
    input.append(0x65);
    input.append(0x20);
    input.append(0x73);
    input.append(0x70);
    input.append(0x65);
    input.append(0x63);
    input.append(0x69);
    input.append(0x6D);
    input.append(0x65);
    input.append(0x6E);
    input.append(0x20);
    input.append(0x62);
    input.append(0x6F);
    input.append(0x6F);
    input.append(0x6B);
    input.append(0x2E);
    input.append(0x20);
    input.append(0x49);
    input.append(0x74);
    input.append(0x20);
    input.append(0x75);
    input.append(0x73);
    input.append(0x75);
    input.append(0x61);
    input.append(0x6C);
    input.append(0x6C);
    input.append(0x79);
    input.append(0x20);
    input.append(0x62);
    input.append(0x65);
    input.append(0x67);
    input.append(0x69);
    input.append(0x6E);
    input.append(0x73);
    input.append(0x20);
    input.append(0x77);
    input.append(0x69);
    input.append(0x74);
    input.append(0x68);

    let result = sha256::sha256(input);

    // result should be 0xD35BF81DDF990122F8B96C7BF88C0737D5080E0C9BC3F7ABF68E6FF0D5F9EA44
    assert_eq!(result.len(), 32);
    assert_eq!(*result[0], 0xD3);
    assert_eq!(*result[1], 0x5B);
    assert_eq!(*result[2], 0xF8);
    assert_eq!(*result[3], 0x1D);
    assert_eq!(*result[4], 0xDF);
    assert_eq!(*result[5], 0x99);
    assert_eq!(*result[6], 0x01);
    assert_eq!(*result[7], 0x22);
    assert_eq!(*result[8], 0xF8);
    assert_eq!(*result[9], 0xB9);
    assert_eq!(*result[10], 0x6C);
    assert_eq!(*result[11], 0x7B);
    assert_eq!(*result[12], 0xF8);
    assert_eq!(*result[13], 0x8C);
    assert_eq!(*result[14], 0x07);
    assert_eq!(*result[15], 0x37);
    assert_eq!(*result[16], 0xD5);
    assert_eq!(*result[17], 0x08);
    assert_eq!(*result[18], 0x0E);
    assert_eq!(*result[19], 0x0C);
    assert_eq!(*result[20], 0x9B);
    assert_eq!(*result[21], 0xC3);
    assert_eq!(*result[22], 0xF7);
    assert_eq!(*result[23], 0xAB);
    assert_eq!(*result[24], 0xF6);
    assert_eq!(*result[25], 0x8E);
    assert_eq!(*result[26], 0x6F);
    assert_eq!(*result[27], 0xF0);
    assert_eq!(*result[28], 0xD5);
    assert_eq!(*result[29], 0xF9);
    assert_eq!(*result[30], 0xEA);
    assert_eq!(*result[31], 0x44);
}
#[test]
#[available_gas(10_000_000_000)]
fn sha256_url() {
    let data = array![
        '{',
        '"',
        't',
        'y',
        'p',
        'e',
        '"',
        ':',
        '"',
        'w',
        'e',
        'b',
        'a',
        'u',
        't',
        'h',
        'n',
        '.',
        'g',
        'e',
        't',
        '"',
        ',',
        '"',
        'c',
        'h',
        'a',
        'l',
        'l',
        'e',
        'n',
        'g',
        'e',
        '"',
        ':',
        '"',
        '3',
        'q',
        '2',
        '-',
        '7',
        '_',
        '-',
        'q',
        '"',
        ',',
        '"',
        'o',
        'r',
        'i',
        'g',
        'i',
        'n',
        '"',
        ':',
        '"',
        'h',
        't',
        't',
        'p',
        ':',
        '/',
        '/',
        'l',
        'o',
        'c',
        'a',
        'l',
        'h',
        'o',
        's',
        't',
        ':',
        '5',
        '1',
        '7',
        '3',
        '"',
        ',',
        '"',
        'c',
        'r',
        'o',
        's',
        's',
        'O',
        'r',
        'i',
        'g',
        'i',
        'n',
        '"',
        ':',
        'f',
        'a',
        'l',
        's',
        'e',
        ',',
        '"',
        'o',
        't',
        'h',
        'e',
        'r',
        '_',
        'k',
        'e',
        'y',
        's',
        '_',
        'c',
        'a',
        'n',
        '_',
        'b',
        'e',
        '_',
        'a',
        'd',
        'd',
        'e',
        'd',
        '_',
        'h',
        'e',
        'r',
        'e',
        '"',
        ':',
        '"',
        'd',
        'o',
        ' ',
        'n',
        'o',
        't',
        ' ',
        'c',
        'o',
        'm',
        'p',
        'a',
        'r',
        'e',
        ' ',
        'c',
        'l',
        'i',
        'e',
        'n',
        't',
        'D',
        'a',
        't',
        'a',
        'J',
        'S',
        'O',
        'N',
        ' ',
        'a',
        'g',
        'a',
        'i',
        'n',
        's',
        't',
        ' ',
        'a',
        ' ',
        't',
        'e',
        'm',
        'p',
        'l',
        'a',
        't',
        'e',
        '.',
        ' ',
        'S',
        'e',
        'e',
        ' ',
        'h',
        't',
        't',
        'p',
        's',
        ':',
        '/',
        '/',
        'g',
        'o',
        'o',
        '.',
        'g',
        'l',
        '/',
        'y',
        'a',
        'b',
        'P',
        'e',
        'x',
        '"',
        '}'
    ];
    let result = sha256::sha256(data);

    // result should be 0xe5ddd0d703d54d024a1e49cdb614d1f4e9dfa81fff119ca01554ec22d1a45f59
    assert_eq!(result.len(), 32);
    assert_eq!(*result[0], 0xE5);
    assert_eq!(*result[1], 0xDD);
    assert_eq!(*result[2], 0xD0);
    assert_eq!(*result[3], 0xD7);
    assert_eq!(*result[4], 0x03);
    assert_eq!(*result[5], 0xD5);
    assert_eq!(*result[6], 0x4D);
    assert_eq!(*result[7], 0x02);
    assert_eq!(*result[8], 0x4A);
    assert_eq!(*result[9], 0x1E);
    assert_eq!(*result[10], 0x49);
    assert_eq!(*result[11], 0xCD);
    assert_eq!(*result[12], 0xB6);
    assert_eq!(*result[13], 0x14);
    assert_eq!(*result[14], 0xD1);
    assert_eq!(*result[15], 0xF4);
    assert_eq!(*result[16], 0xE9);
    assert_eq!(*result[17], 0xDF);
    assert_eq!(*result[18], 0xA8);
    assert_eq!(*result[19], 0x1F);
    assert_eq!(*result[20], 0xFF);
    assert_eq!(*result[21], 0x11);
    assert_eq!(*result[22], 0x9C);
    assert_eq!(*result[23], 0xA0);
    assert_eq!(*result[24], 0x15);
    assert_eq!(*result[25], 0x54);
    assert_eq!(*result[26], 0xEC);
    assert_eq!(*result[27], 0x22);
    assert_eq!(*result[28], 0xD1);
    assert_eq!(*result[29], 0xA4);
    assert_eq!(*result[30], 0x5F);
    assert_eq!(*result[31], 0x59);
}
