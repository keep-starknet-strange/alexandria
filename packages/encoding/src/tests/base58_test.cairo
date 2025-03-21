use alexandria_encoding::base58::{Base58Decoder, Base58Encoder, Base58FeltEncoder};

#[test]
#[available_gas(2000000000)]
fn base58encode_empty_test() {
    let input = array![];
    let result = Base58Encoder::encode(input);
    assert_eq!(result.len(), 0);
}

#[test]
#[available_gas(2000000000)]
fn base58encode_simple_test() {
    let input = array!['a'];

    let result = Base58Encoder::encode(input);
    assert_eq!(result.len(), 2);
    assert_eq!(*result[0], '2');
    assert_eq!(*result[1], 'g');
}

#[test]
#[available_gas(2000000000)]
fn base58encode_hello_world_test() {
    let input = array!['h', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd'];

    let result = Base58Encoder::encode(input);
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
        15, 181, 131, 219, 98, 77, 9, 216, 225, 154, 138, 91, 195, 49, 118, 165, 
        0, 95, 61, 77, 212, 150, 215, 98, 99, 14, 7, 163, 32, 175, 12, 99
    ];

    let result = Base58Encoder::encode(input);
    
    // Test the encoding of a large address value
    // 7105402090825929429175904905463395401553389172147634447678779439631685323875
    assert_eq!(result.len(), 44);
    
    // Verify the encoded result matches expected value
    let expected = array![
        '2', '4', 'K', 'e', 'b', 'v', 'J', 'C', 's', 'c', 'D', 'w', 'V', 'm', '5', 'K',
        'D', 'M', 'F', '3', 'B', 'J', 'z', 'Z', '8', 'F', '6', 'N', 'q', 'X', 'p', 'P',
        'U', 'G', 'G', 'V', 'C', '9', 'N', 'z', '1', 'b', 'G', '6'
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

    let result = Base58Decoder::decode(input);
    assert_eq!(result.len(), 0);
}

#[test]
#[available_gas(2000000000)]
fn base58decode_simple_test() {
    let input = array!['2', 'g'];

    let result = Base58Decoder::decode(input);
    assert_eq!(result.len(), 1);
    assert_eq!(*result[0], 'a');
}

#[test]
#[available_gas(2000000000)]
fn base58decode_hello_world_test() {
    let input = array![
        'S', 't', 'V', '1', 'D', 'L', '6', 'C', 'w', 'T', 'r', 'y', 'K', 'y', 'V',
    ];

    let result = Base58Decoder::decode(input);
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

    let result = Base58Encoder::encode(input);
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

    let result = Base58Decoder::decode(input);
    assert_eq!(result.len(), 3);
    assert_eq!(*result[0], 0);
    assert_eq!(*result[1], 0);
    assert_eq!(*result[2], 'a');
}

#[test]
#[available_gas(2000000000)]
fn base58felt_encode_test() {
    let input = 123456789;

    let result = Base58FeltEncoder::encode(input);
    assert_eq!(result.len(), 5);
    assert_eq!(*result[0], 'B');
    assert_eq!(*result[1], 'u');
    assert_eq!(*result[2], 'k');
    assert_eq!(*result[3], 'Q');
    assert_eq!(*result[4], 'L');
}