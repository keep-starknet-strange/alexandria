use alexandria_math::sha256;

#[test]
#[available_gas(2000000000)]
fn sha256_empty_test() {
    let mut input: Array<u8> = array![];
    let result = sha256::sha256(input);

    // result should be 0xE3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
    assert_eq!(result.len(), 32, "invalid result length");
    assert_eq!(*result[0], 0xE3, "invalid result");
    assert_eq!(*result[1], 0xB0, "invalid result");
    assert_eq!(*result[2], 0xC4, "invalid result");
    assert_eq!(*result[3], 0x42, "invalid result");
    assert_eq!(*result[4], 0x98, "invalid result");
    assert_eq!(*result[5], 0xFC, "invalid result");
    assert_eq!(*result[6], 0x1C, "invalid result");
    assert_eq!(*result[7], 0x14, "invalid result");
    assert_eq!(*result[8], 0x9A, "invalid result");
    assert_eq!(*result[9], 0xFB, "invalid result");
    assert_eq!(*result[10], 0xF4, "invalid result");
    assert_eq!(*result[11], 0xC8, "invalid result");
    assert_eq!(*result[12], 0x99, "invalid result");
    assert_eq!(*result[13], 0x6F, "invalid result");
    assert_eq!(*result[14], 0xB9, "invalid result");
    assert_eq!(*result[15], 0x24, "invalid result");
    assert_eq!(*result[16], 0x27, "invalid result");
    assert_eq!(*result[17], 0xAE, "invalid result");
    assert_eq!(*result[18], 0x41, "invalid result");
    assert_eq!(*result[19], 0xE4, "invalid result");
    assert_eq!(*result[20], 0x64, "invalid result");
    assert_eq!(*result[21], 0x9B, "invalid result");
    assert_eq!(*result[22], 0x93, "invalid result");
    assert_eq!(*result[23], 0x4C, "invalid result");
    assert_eq!(*result[24], 0xA4, "invalid result");
    assert_eq!(*result[25], 0x95, "invalid result");
    assert_eq!(*result[26], 0x99, "invalid result");
    assert_eq!(*result[27], 0x1B, "invalid result");
    assert_eq!(*result[28], 0x78, "invalid result");
    assert_eq!(*result[29], 0x52, "invalid result");
    assert_eq!(*result[30], 0xB8, "invalid result");
    assert_eq!(*result[31], 0x55, "invalid result");
}

#[test]
#[available_gas(200000000000)]
fn sha256_random_data_test() {
    let mut input: Array<u8> = array![
        0x57, 0x77, 0x71, 0x71, 0x66, 0x50, 0x45, 0x51, 0x51, 0x43, 0x39, 0x48, 0x38
    ];
    let result = sha256::sha256(input);
    assert_eq!(*result[0], 61, "invalid result");
    assert_eq!(*result[1], 226, "invalid result");
    assert_eq!(*result[2], 188, "invalid result");
    assert_eq!(*result[3], 242, "invalid result");
    assert_eq!(*result[4], 118, "invalid result");
    assert_eq!(*result[5], 121, "invalid result");
    assert_eq!(*result[6], 7, "invalid result");
    assert_eq!(*result[7], 225, "invalid result");
    assert_eq!(*result[8], 150, "invalid result");
    assert_eq!(*result[9], 220, "invalid result");
    assert_eq!(*result[10], 105, "invalid result");
    assert_eq!(*result[11], 158, "invalid result");
    assert_eq!(*result[12], 185, "invalid result");
    assert_eq!(*result[13], 180, "invalid result");
    assert_eq!(*result[14], 139, "invalid result");
    assert_eq!(*result[15], 103, "invalid result");
    assert_eq!(*result[16], 221, "invalid result");
    assert_eq!(*result[17], 95, "invalid result");
    assert_eq!(*result[18], 56, "invalid result");
    assert_eq!(*result[19], 88, "invalid result");
    assert_eq!(*result[20], 209, "invalid result");
    assert_eq!(*result[21], 159, "invalid result");
    assert_eq!(*result[22], 255, "invalid result");
    assert_eq!(*result[23], 247, "invalid result");
    assert_eq!(*result[24], 145, "invalid result");
    assert_eq!(*result[25], 146, "invalid result");
    assert_eq!(*result[26], 83, "invalid result");
    assert_eq!(*result[27], 110, "invalid result");
    assert_eq!(*result[28], 185, "invalid result");
    assert_eq!(*result[29], 5, "invalid result");
    assert_eq!(*result[30], 248, "invalid result");
    assert_eq!(*result[31], 15, "invalid result");
}

#[test]
#[available_gas(2000000000)]
fn sha256_lorem_ipsum_test() {
    // Lorem ipsum, or lsipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.
    // The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of
    // Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins with
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
    assert_eq!(result.len(), 32, "invalid result length");
    assert_eq!(*result[0], 0xD3, "invalid result");
    assert_eq!(*result[1], 0x5B, "invalid result");
    assert_eq!(*result[2], 0xF8, "invalid result");
    assert_eq!(*result[3], 0x1D, "invalid result");
    assert_eq!(*result[4], 0xDF, "invalid result");
    assert_eq!(*result[5], 0x99, "invalid result");
    assert_eq!(*result[6], 0x01, "invalid result");
    assert_eq!(*result[7], 0x22, "invalid result");
    assert_eq!(*result[8], 0xF8, "invalid result");
    assert_eq!(*result[9], 0xB9, "invalid result");
    assert_eq!(*result[10], 0x6C, "invalid result");
    assert_eq!(*result[11], 0x7B, "invalid result");
    assert_eq!(*result[12], 0xF8, "invalid result");
    assert_eq!(*result[13], 0x8C, "invalid result");
    assert_eq!(*result[14], 0x07, "invalid result");
    assert_eq!(*result[15], 0x37, "invalid result");
    assert_eq!(*result[16], 0xD5, "invalid result");
    assert_eq!(*result[17], 0x08, "invalid result");
    assert_eq!(*result[18], 0x0E, "invalid result");
    assert_eq!(*result[19], 0x0C, "invalid result");
    assert_eq!(*result[20], 0x9B, "invalid result");
    assert_eq!(*result[21], 0xC3, "invalid result");
    assert_eq!(*result[22], 0xF7, "invalid result");
    assert_eq!(*result[23], 0xAB, "invalid result");
    assert_eq!(*result[24], 0xF6, "invalid result");
    assert_eq!(*result[25], 0x8E, "invalid result");
    assert_eq!(*result[26], 0x6F, "invalid result");
    assert_eq!(*result[27], 0xF0, "invalid result");
    assert_eq!(*result[28], 0xD5, "invalid result");
    assert_eq!(*result[29], 0xF9, "invalid result");
    assert_eq!(*result[30], 0xEA, "invalid result");
    assert_eq!(*result[31], 0x44, "invalid result");
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
    assert_eq!(result.len(), 32, "invalid result length");
    assert_eq!(*result[0], 0xE5, "invalid result");
    assert_eq!(*result[1], 0xDD, "invalid result");
    assert_eq!(*result[2], 0xD0, "invalid result");
    assert_eq!(*result[3], 0xD7, "invalid result");
    assert_eq!(*result[4], 0x03, "invalid result");
    assert_eq!(*result[5], 0xD5, "invalid result");
    assert_eq!(*result[6], 0x4D, "invalid result");
    assert_eq!(*result[7], 0x02, "invalid result");
    assert_eq!(*result[8], 0x4A, "invalid result");
    assert_eq!(*result[9], 0x1E, "invalid result");
    assert_eq!(*result[10], 0x49, "invalid result");
    assert_eq!(*result[11], 0xCD, "invalid result");
    assert_eq!(*result[12], 0xB6, "invalid result");
    assert_eq!(*result[13], 0x14, "invalid result");
    assert_eq!(*result[14], 0xD1, "invalid result");
    assert_eq!(*result[15], 0xF4, "invalid result");
    assert_eq!(*result[16], 0xE9, "invalid result");
    assert_eq!(*result[17], 0xDF, "invalid result");
    assert_eq!(*result[18], 0xA8, "invalid result");
    assert_eq!(*result[19], 0x1F, "invalid result");
    assert_eq!(*result[20], 0xFF, "invalid result");
    assert_eq!(*result[21], 0x11, "invalid result");
    assert_eq!(*result[22], 0x9C, "invalid result");
    assert_eq!(*result[23], 0xA0, "invalid result");
    assert_eq!(*result[24], 0x15, "invalid result");
    assert_eq!(*result[25], 0x54, "invalid result");
    assert_eq!(*result[26], 0xEC, "invalid result");
    assert_eq!(*result[27], 0x22, "invalid result");
    assert_eq!(*result[28], 0xD1, "invalid result");
    assert_eq!(*result[29], 0xA4, "invalid result");
    assert_eq!(*result[30], 0x5F, "invalid result");
    assert_eq!(*result[31], 0x59, "invalid result");
}
