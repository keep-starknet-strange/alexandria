use alexandria_encoding::base58::{Base58Decoder, Base58Encoder};

#[test]
#[available_gas(2000000000)]
fn base58encode_empty_test() {
    let input = array![];
    let result = Base58Encoder::encode(input.span());
    assert_eq!(result.len(), 0);
}

#[test]
#[available_gas(2000000000)]
fn base58encode_simple_test() {
    let input = array!['a'];

    let result = Base58Encoder::encode(input.span());
    assert_eq!(result.len(), 2);
    assert_eq!(*result[0], '2');
    assert_eq!(*result[1], 'g');
}

#[test]
#[available_gas(2000000000)]
fn base58encode_hello_world_test() {
    let input = array!['h', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd'];

    let result = Base58Encoder::encode(input.span());
    assert_eq!(result.len(), 15);
    assert_eq!(*result[0], 'S');
    assert_eq!(*result[1], 't');
    assert_eq!(*result[2], 'V');
    assert_eq!(*result[3], '1');
    assert_eq!(*result[4], 'D');
    assert_eq!(*result[5], 'L');
    assert_eq!(*result[6], '6');
    assert_eq!(*result[7], 'C');
    assert_eq!(*result[8], 'w');
    assert_eq!(*result[9], 'T');
    assert_eq!(*result[10], 'r');
    assert_eq!(*result[11], 'y');
    assert_eq!(*result[12], 'K');
    assert_eq!(*result[13], 'y');
    assert_eq!(*result[14], 'V');
}

#[test]
#[available_gas(2000000000)]
fn base58encode_address_test() {
    let input = array![
        15,
        181,
        131,
        219,
        98,
        77,
        9,
        216,
        225,
        154,
        138,
        91,
        195,
        49,
        118,
        165,
        0,
        95,
        61,
        77,
        212,
        150,
        215,
        98,
        99,
        14,
        7,
        163,
        32,
        175,
        12,
        99,
    ];

    let result = Base58Encoder::encode(input.span());

    // Test the encoding of a large address value
    // 7105402090825929429175904905463395401553389172147634447678779439631685323875
    assert_eq!(result.len(), 44);

    // Verify the encoded result matches expected value
    let expected = array![
        '2',
        '4',
        'K',
        'e',
        'b',
        'v',
        'J',
        'C',
        's',
        'c',
        'D',
        'w',
        'V',
        'm',
        '5',
        'K',
        'D',
        'M',
        'F',
        '3',
        'B',
        'J',
        'z',
        'Z',
        '8',
        'F',
        '6',
        'N',
        'q',
        'X',
        'p',
        'P',
        'U',
        'G',
        'G',
        'V',
        'C',
        '9',
        'N',
        'z',
        '1',
        'b',
        'G',
        '6',
    ];
    let mut i = 0;
    while i < result.len() {
        assert_eq!(*result[i], *expected[i]);
        i += 1;
    };
}

#[test]
#[available_gas(2000000000)]
fn base58decode_empty_test() {
    let input = array![];

    let result = Base58Decoder::decode(input.span());
    assert_eq!(result.len(), 0);
}

#[test]
#[available_gas(2000000000)]
fn base58decode_simple_test() {
    let input = array!['2', 'g'];

    let result = Base58Decoder::decode(input.span());
    assert_eq!(result.len(), 1);
    assert_eq!(*result[0], 'a');
}

#[test]
#[available_gas(2000000000)]
fn base58decode_hello_world_test() {
    let input = array!['S', 't', 'V', '1', 'D', 'L', '6', 'C', 'w', 'T', 'r', 'y', 'K', 'y', 'V'];

    let result = Base58Decoder::decode(input.span());
    assert_eq!(result.len(), 11);
    assert_eq!(*result[0], 'h');
    assert_eq!(*result[1], 'e');
    assert_eq!(*result[2], 'l');
    assert_eq!(*result[3], 'l');
    assert_eq!(*result[4], 'o');
    assert_eq!(*result[5], ' ');
    assert_eq!(*result[6], 'w');
    assert_eq!(*result[7], 'o');
    assert_eq!(*result[8], 'r');
    assert_eq!(*result[9], 'l');
    assert_eq!(*result[10], 'd');
}

#[test]
#[available_gas(2000000000)]
fn base58encode_with_leading_zeros() {
    let input = array![0, 0, 'a'];

    let result = Base58Encoder::encode(input.span());
    assert_eq!(result.len(), 4);
    assert_eq!(*result[0], '1');
    assert_eq!(*result[1], '1');
    assert_eq!(*result[2], '2');
    assert_eq!(*result[3], 'g');
}

#[test]
#[available_gas(2000000000)]
fn base58decode_with_leading_zeros() {
    let input = array!['1', '1', '2', 'g'];

    let result = Base58Decoder::decode(input.span());
    assert_eq!(result.len(), 3);
    assert_eq!(*result[0], 0);
    assert_eq!(*result[1], 0);
    assert_eq!(*result[2], 'a');
}

#[test]
#[available_gas(2000000000)]
fn base58_all_zeros_test() {
    // Test encoding of all zeros
    let input = array![0, 0, 0, 0, 0];
    let result = Base58Encoder::encode(input.span());
    assert_eq!(result.len(), 5);

    let mut i = 0;
    while i < result.len() {
        assert_eq!(*result[i], '1');
        i += 1;
    }

    // Test decoding of all '1's
    let decoded = Base58Decoder::decode(result.span());
    assert_eq!(decoded.len(), 5);

    i = 0;
    while i < decoded.len() {
        assert_eq!(*decoded[i], 0);
        i += 1;
    }
}

#[test]
#[available_gas(2000000000)]
fn base58_binary_data_test() {
    // Test with binary data (non-ASCII)
    let input = array![255, 254, 253, 252, 251];
    let encoded = Base58Encoder::encode(input.span());

    // Decode and verify roundtrip
    let decoded = Base58Decoder::decode(encoded.span());
    assert_eq!(decoded.len(), input.len());

    let mut i = 0;
    while i < input.len() {
        assert_eq!(*decoded[i], *input[i]);
        i += 1;
    }
}

#[test]
#[available_gas(2000000000)]
fn base58_invalid_characters_test() {
    // Test with invalid characters

    // Contains '0' (zero) which is not in base58 alphabet
    let input1 = array!['1', '0', 'A'];
    let result1 = Base58Decoder::decode(input1.span());
    assert_eq!(result1.len(), 0, "Invalid input '0' should return empty array");

    // Contains 'O' (capital o) which is not in base58 alphabet
    let input2 = array!['1', 'O', 'A'];
    let result2 = Base58Decoder::decode(input2.span());
    assert_eq!(result2.len(), 0, "Invalid input 'O' should return empty array");

    // Contains 'I' (capital i) which is not in base58 alphabet
    let input3 = array!['1', 'I', 'A'];
    let result3 = Base58Decoder::decode(input3.span());
    assert_eq!(result3.len(), 0, "Invalid input 'I' should return empty array");

    // Contains 'l' (lowercase L) which is not in base58 alphabet
    let input4 = array!['1', 'l', 'A'];
    let result4 = Base58Decoder::decode(input4.span());
    assert_eq!(result4.len(), 0, "Invalid input 'l' should return empty array");

    // Contains '+' (plus) which is not in base58 alphabet
    let input5 = array!['1', '+', 'A'];
    let result5 = Base58Decoder::decode(input5.span());
    assert_eq!(result5.len(), 0, "Invalid input '+' should return empty array");
}

#[test]
#[available_gas(2000000000)]
fn base58_round_trip_test_1() {
    // ASCII text
    let original = array!['T', 'e', 's', 't', ' ', 'c', 'a', 's', 'e'];
    let encoded = Base58Encoder::encode(original.span());
    let decoded = Base58Decoder::decode(encoded.span());

    assert_eq!(decoded.len(), original.len(), "Round trip length mismatch");

    let mut j = 0;
    while j < original.len() {
        assert_eq!(*decoded[j], *original[j], "Round trip data mismatch");
        j += 1;
    }
}

#[test]
#[available_gas(2000000000)]
fn base58_round_trip_test_2() {
    // Binary data mixed with text
    let original = array!['C', 'a', 'i', 'r', 'o', 0, 1, 2, 255];
    let encoded = Base58Encoder::encode(original.span());
    let decoded = Base58Decoder::decode(encoded.span());

    assert_eq!(decoded.len(), original.len(), "Round trip length mismatch");

    let mut j = 0;
    while j < original.len() {
        assert_eq!(*decoded[j], *original[j], "Round trip data mismatch");
        j += 1;
    }
}

#[test]
#[available_gas(2000000000)]
fn base58_round_trip_test_3() {
    // Sequential numbers
    let original = array![1, 2, 3, 4, 5, 6, 7, 8, 9];
    let encoded = Base58Encoder::encode(original.span());
    let decoded = Base58Decoder::decode(encoded.span());

    assert_eq!(decoded.len(), original.len(), "Round trip length mismatch");

    let mut j = 0;
    while j < original.len() {
        assert_eq!(*decoded[j], *original[j], "Round trip data mismatch");
        j += 1;
    }
}

#[test]
#[available_gas(2000000000)]
fn base58_single_byte_edge_cases() {
    // Test a few select byte values instead of all 256
    let test_bytes = array![0, 1, 127, 128, 255];

    let mut i = 0;
    while i < test_bytes.len() {
        let byte = *test_bytes[i];
        let input = array![byte];
        let encoded = Base58Encoder::encode(input.span());
        let decoded = Base58Decoder::decode(encoded.span());

        assert_eq!(decoded.len(), 1, "Round trip failed for byte");
        assert_eq!(*decoded[0], byte, "Round trip data mismatch for byte");

        i += 1;
    }
}
