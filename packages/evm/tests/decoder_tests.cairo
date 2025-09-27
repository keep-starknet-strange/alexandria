use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use alexandria_evm::decoder;
use alexandria_evm::evm_enum::EVMTypes;
use alexandria_evm::evm_struct::EVMCalldata;
use decoder::AbiDecodeTrait;

fn cd(mut data: ByteArray) -> EVMCalldata {
    EVMCalldata { relative_offset: 0_usize, offset: 0_usize, calldata: data }
}

#[test]
fn test_decode_felt252() {
    let mut data: ByteArray = Default::default();
    data.append_u256(0x0000000000000ffff00000000000000000000000000000000000000000000020);

    let mut calldata = cd(data);
    let decoded = calldata.decode(array![EVMTypes::Felt252].span());
    assert!(
        *decoded.at(0) == 0x0000000000000ffff00000000000000000000000000000000000000000000020,
        "evm assertion failed",
    );
}

#[test]
fn test_decode_felt252_max() {
    let mut data: ByteArray = Default::default();
    data.append_u256(0x0800000000000011000000000000000000000000000000000000000000000000);

    let mut calldata = cd(data);
    let decoded = calldata.decode(array![EVMTypes::Felt252].span());
    assert!(
        *decoded.at(0) == 0x800000000000011000000000000000000000000000000000000000000000000,
        "evm assertion failed",
    );
}

#[test]
#[should_panic(expected: 'value higher than felt252 limit')]
fn test_decode_felt252_max_higher() {
    let mut data: ByteArray = Default::default();
    data.append_u256(0xF800000000000011000000000000000000000000000000000000000000000000);

    let mut calldata = cd(data);
    calldata.decode(array![EVMTypes::Felt252].span());
}

#[test]
fn test_decode_array_of_strings_long_elements() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000004);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000080);
    data.append_u256(0x00000000000000000000000000000000000000000000000000000000000000c0);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000100);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000160);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x414c490000000000000000000000000000000000000000000000000000000000);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000004);
    data.append_u256(0x56454c4900000000000000000000000000000000000000000000000000000000);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000002f);
    data.append_u256(0x4c4f4e47535452494e474c4f4e4745525448414e313233313233313233313233);
    data.append_u256(0x3132334153415344415344414441440000000000000000000000000000000000);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000009);
    data.append_u256(0x73686f72746261636b0000000000000000000000000000000000000000000000);

    let mut calldata = cd(data);
    let decoded = calldata.decode(array![EVMTypes::Array(array![EVMTypes::String].span())].span());
    assert!(*decoded.at(0) == 0x4);

    assert!(*decoded.at(1) == 0x0);
    assert!(*decoded.at(2) == 0x414C49); // ALI
    assert!(*decoded.at(3) == 0x3);
    assert!(*decoded.at(4) == 0x0);
    assert!(*decoded.at(5) == 0x56454C49); // VELI
    assert!(*decoded.at(6) == 0x4);
    assert!(*decoded.at(7) == 0x1);
    assert!(
        *decoded.at(8) == 0x4C4F4E47535452494E474C4F4E4745525448414E3132333132333132333132, "match",
    ); // LONGSTRINGLONGERTHAN12312312312
    assert!(
        *decoded.at(9) == 0x33313233415341534441534441444144, "evm assertion failed",
    ); // 3123ASASDASDADAD
    assert!(*decoded.at(10) == 16);
    assert!(*decoded.at(11) == 0x0);
    assert!(*decoded.at(12) == 0x73686F72746261636B); // shortback
    assert!(*decoded.at(13) == 0x9);
}

#[test]
fn test_decode_array_of_strings() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000040);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000080);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x414c490000000000000000000000000000000000000000000000000000000000);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000004);
    data.append_u256(0x56454c4900000000000000000000000000000000000000000000000000000000);

    let mut calldata = cd(data);
    let decoded = calldata.decode(array![EVMTypes::Array(array![EVMTypes::String].span())].span());
    assert!(*decoded.at(0) == 0x2);

    assert!(*decoded.at(1) == 0x0);
    assert!(*decoded.at(2) == 0x414C49); // ALI
    assert!(*decoded.at(3) == 0x3);
    assert!(*decoded.at(4) == 0x0);
    assert!(*decoded.at(5) == 0x56454C49); // VELI
    assert!(*decoded.at(6) == 0x4);
}

#[test]
fn test_decode_array_tuple_with_multi_arrays() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000060);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000200);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000340);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000007b);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000080);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000001dfc);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000160);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000006);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000004);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000005);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000006);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000054cf8);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000014d);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000080);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000002b);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000100);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000000);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000005);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000006);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000053d9f);
    data.append_u256(0x00000000000000000000000000000000000000000000000000000000000001bc);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000080);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000021);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000100);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000000a);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000000a);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000000a);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000005);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000016);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000021);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000002c);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000037);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000042);

    let mut calldata = cd(data);
    let decoded = calldata
        .decode(
            array![
                EVMTypes::Array(
                    array![
                        EVMTypes::Tuple(
                            array![
                                EVMTypes::Uint128,
                                EVMTypes::Array(array![EVMTypes::Uint128].span()),
                                EVMTypes::Uint256,
                                EVMTypes::Array(array![EVMTypes::Uint256].span()),
                            ]
                                .span(),
                        ),
                    ]
                        .span(),
                ),
            ]
                .span(),
        );
    // [[123, [1,2,3,4,5,6], 7676, [347384]], [333, [0,5,6], 43, [343455]], [444, [10,10,10],
    // 33, [22,33,44,55,66]]]
    assert!(*decoded.at(0) == 0x3);
    assert!(*decoded.at(1) == 123);
    assert!(*decoded.at(2) == 0x6);
    assert!(*decoded.at(3) == 1);
    assert!(*decoded.at(4) == 2);
    assert!(*decoded.at(5) == 3);
    assert!(*decoded.at(6) == 4);
    assert!(*decoded.at(7) == 5);
    assert!(*decoded.at(8) == 6);
    assert!(*decoded.at(9) == 7676);
    assert!(*decoded.at(10) == 0);
    assert!(*decoded.at(11) == 0x1);
    assert!(*decoded.at(12) == 347384);
    assert!(*decoded.at(13) == 0);
    assert!(*decoded.at(14) == 333);
    assert!(*decoded.at(15) == 3);
    assert!(*decoded.at(16) == 0);
    assert!(*decoded.at(17) == 5);
    assert!(*decoded.at(18) == 6);
    assert!(*decoded.at(19) == 43);
    assert!(*decoded.at(20) == 0);
    assert!(*decoded.at(21) == 1);
    assert!(*decoded.at(22) == 343455);
    assert!(*decoded.at(23) == 0);
    assert!(*decoded.at(24) == 444);
    assert!(*decoded.at(25) == 3);
    assert!(*decoded.at(26) == 10);
    assert!(*decoded.at(27) == 10);
    assert!(*decoded.at(28) == 10);
    assert!(*decoded.at(29) == 33);
    assert!(*decoded.at(30) == 0);
    assert!(*decoded.at(31) == 5);
    assert!(*decoded.at(32) == 22);
    assert!(*decoded.at(33) == 0);
    assert!(*decoded.at(34) == 33);
    assert!(*decoded.at(35) == 0);
    assert!(*decoded.at(36) == 44);
    assert!(*decoded.at(37) == 0);
    assert!(*decoded.at(38) == 55);
    assert!(*decoded.at(39) == 0);
    assert!(*decoded.at(40) == 66);
    assert!(*decoded.at(41) == 0);
}

#[test]
fn test_decode_array_tuple_statics_dynamic_on_middle() {
    // [[123, [5,6,7], 9999], [876, [1,1,1,1], 34334] ]
    //     struct arr1 {
    //    uint128 b;
    //   uint128[] a;
    //    uint256 c; }

    let mut data: ByteArray = Default::default();
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000040);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000120);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000007b);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000060);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000270f);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000005);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000006);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000007);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000036c);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000060);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000861e);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000004);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);

    let mut calldata = cd(data);
    let decoded = calldata
        .decode(
            array![
                EVMTypes::Array(
                    array![
                        EVMTypes::Tuple(
                            array![
                                EVMTypes::Uint128,
                                EVMTypes::Array(array![EVMTypes::Uint128].span()),
                                EVMTypes::Uint256,
                            ]
                                .span(),
                        ),
                    ]
                        .span(),
                ),
            ]
                .span(),
        );

    assert!(*decoded.at(0) == 0x2);
    assert!(*decoded.at(1) == 123);
    assert!(*decoded.at(2) == 0x3);
    assert!(*decoded.at(3) == 5);
    assert!(*decoded.at(4) == 6);
    assert!(*decoded.at(5) == 7);
    assert!(*decoded.at(6) == 9999);
    assert!(*decoded.at(7) == 0);
    assert!(*decoded.at(8) == 876);
    assert!(*decoded.at(9) == 0x4);
    assert!(*decoded.at(10) == 1);
    assert!(*decoded.at(11) == 1);
    assert!(*decoded.at(12) == 1);
    assert!(*decoded.at(13) == 1);
    assert!(*decoded.at(14) == 34334);
    assert!(*decoded.at(15) == 0);
}

#[test]
fn test_decode_tuple_array_static_first() {
    //    struct arr1 {
    //        uint128 b;
    //        uint128[] a;
    //    }
    //  arr1[] memory)
    // [[123, [1,2,3]], [777, [555,666]]]
    let mut data: ByteArray = Default::default();
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000040);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000100);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000007b);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000040);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000001);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000309);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000040);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000022b);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000029a);

    let mut calldata = cd(data);
    let decoded = calldata
        .decode(
            array![
                EVMTypes::Array(
                    array![
                        EVMTypes::Tuple(
                            array![
                                EVMTypes::Uint128,
                                EVMTypes::Array(array![EVMTypes::Uint128].span()),
                            ]
                                .span(),
                        ),
                    ]
                        .span(),
                ),
            ]
                .span(),
        );

    assert!(*decoded.at(0) == 0x2);
    assert!(*decoded.at(1) == 123);
    assert!(*decoded.at(2) == 0x3);
    assert!(*decoded.at(3) == 1);
    assert!(*decoded.at(4) == 2);
    assert!(*decoded.at(5) == 3);
    assert!(*decoded.at(6) == 777);
    assert!(*decoded.at(7) == 0x2);
    assert!(*decoded.at(8) == 555);
    assert!(*decoded.at(9) == 666);
}

#[test]
fn test_decode_tuple_array() {
    //    struct arr1 {
    //        uint128[] a;
    //        uint128 b;
    //    }
    //  arr1[] memory)
    let mut data: ByteArray = Default::default();

    data
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000020,
        ); // 0x0 Array start offset
    data
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000002,
        ); // 0x20 Array length outer
    data
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000040,
        ); // 0x40 first element - tuple start offset
    data
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000100,
        ); // 0x60 second element - tuple start offset
    data
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000040,
        ); // 0x80 tuples inner dynamic data start offset
    data
        .append_u256(
            0x000000000000000000000000000000000000000000000000000000000000007b,
        ); // 0xa0 static uint128 (b)
    data
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000003,
        ); // 0xc0 inner array length
    data
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000001,
        ); // 0xe0 inner array first elem
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002); // ...
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000004); // ...
    data
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000040,
        ); // second tuples inner dynamic data start offset
    data
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000309,
        ); // second tuples static uint128(b)
    data
        .append_u256(
            0x0000000000000000000000000000000000000000000000000000000000000002,
        ); // second tuple inner array length
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000022b); // elem
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000029a); // elem

    let mut calldata = cd(data);
    let decoded = calldata
        .decode(
            array![
                EVMTypes::Array(
                    array![
                        EVMTypes::Tuple(
                            array![
                                EVMTypes::Array(array![EVMTypes::Uint128].span()),
                                EVMTypes::Uint128,
                            ]
                                .span(),
                        ),
                    ]
                        .span(),
                ),
            ]
                .span(),
        );

    // [ [ [1,2,4], 123], [ [555,666], 777] ]
    assert!(*decoded.at(0) == 0x2);
    assert!(*decoded.at(1) == 0x3);
    assert!(*decoded.at(2) == 1);
    assert!(*decoded.at(3) == 2);
    assert!(*decoded.at(4) == 4);
    assert!(*decoded.at(5) == 123);
    assert!(*decoded.at(6) == 0x2);
    assert!(*decoded.at(7) == 555);
    assert!(*decoded.at(8) == 666);
    assert!(*decoded.at(9) == 777);
}

#[test]
fn test_decode_array_of_array() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020); // 0:20
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002); // 20:40
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000040); // 40:60
    data.append_u256(0x00000000000000000000000000000000000000000000000000000000000000a0); // 60:80
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002); // 80:a0
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000007b); // a0:c0
    data.append_u256(0x00000000000000000000000000000000000000000000000000000000000001bc); // c0:e0
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002); // e0:100
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000022b); // 100:120
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000021); // 120:140

    let mut calldata = cd(data);
    let decoded = calldata
        .decode(
            array![
                EVMTypes::Array(array![EVMTypes::Array(array![EVMTypes::Uint128].span())].span()),
            ]
                .span(),
        );

    assert!(*decoded.at(0) == 0x2);
    assert!(*decoded.at(1) == 0x2);
    assert!(*decoded.at(2) == 123);
    assert!(*decoded.at(3) == 444);
    assert!(*decoded.at(4) == 0x2);
    assert!(*decoded.at(5) == 555);
    assert!(*decoded.at(6) == 33);
}


#[test]
fn test_decode_complex() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000080);
    data.append_u256(0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    data.append_u256(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff40e5);
    data.append_u256(0x00000000000000000000000000000000000000000000000000000000000000c0);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000005);
    data.append_u256(0x00bbffaa00000000000000000000000000000000000000000000000000000000);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000002);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000006f);
    data.append_u256(0x00000000000000000000000000000000000000000000000000000000000000de);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000309);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000378);

    let mut calldata = cd(data);

    let decoded = calldata
        .decode(
            array![
                EVMTypes::Bytes, EVMTypes::Uint256, EVMTypes::Int128,
                EVMTypes::Array(
                    array![EVMTypes::Tuple(array![EVMTypes::Uint128, EVMTypes::Uint128].span())]
                        .span(),
                ),
            ]
                .span(),
        );

    assert!(*decoded.at(0) == 0x0);
    assert!(*decoded.at(1) == 0x00bbffaa00);
    assert!(*decoded.at(2) == 0x5); // Bytes len
    assert!(*decoded.at(3) == 0xffffffffffffffffffffffffffffffff); // Uint256
    assert!(*decoded.at(4) == 0xffffffffffffffffffffffffffff);
    assert!(*decoded.at(5) == -48923); // Int128
    assert!(*decoded.at(6) == 0x2); // Arr len
    assert!(*decoded.at(7) == 111);
    assert!(*decoded.at(8) == 222);
    assert!(*decoded.at(9) == 777);
    assert!(*decoded.at(10) == 888);
}

#[test]
fn test_decode_array_of_struct() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000000b);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000016);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000001618);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000036f);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000e8d4a50fff);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000989680);

    let mut calldata = cd(data);

    let decoded = calldata
        .decode(
            array![
                EVMTypes::Array(
                    array![EVMTypes::Tuple(array![EVMTypes::Uint128, EVMTypes::Uint128].span())]
                        .span(),
                ),
            ]
                .span(),
        );
    assert!(*decoded.at(0) == 0x3);
    assert!(*decoded.at(1) == 0xb);
    assert!(*decoded.at(2) == 0x16);
    assert!(*decoded.at(3) == 0x1618);
    assert!(*decoded.at(4) == 0x36f);
    assert!(*decoded.at(5) == 0xe8d4a50fff);
    assert!(*decoded.at(6) == 0x989680);
}

#[test]
fn test_decode_array_uint128s() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0x00000000000000000000000000000000000000000000000000000000000001bd);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000016462);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000001a6e41e3);

    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Array(array![EVMTypes::Uint128].span())].span());

    assert!(*decoded.at(0) == 0x3);
    assert!(*decoded.at(1) == 0x1bd);
    assert!(*decoded.at(2) == 0x16462);
    assert!(*decoded.at(3) == 0x1a6e41e3);
}

#[test]
fn test_decode_tuple_of_two() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000007b);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000022b);

    let mut calldata = cd(data);

    let decoded = calldata
        .decode(
            array![EVMTypes::Tuple(array![EVMTypes::Uint128, EVMTypes::Uint128].span())].span(),
        );

    assert!(*decoded.at(0) == 0x7b);
    assert!(*decoded.at(1) == 0x22b);
}

#[test]
fn test_decode_tuple_of_two_uint256() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000007b);
    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000022b);

    let mut calldata = cd(data);

    let decoded = calldata
        .decode(
            array![EVMTypes::Tuple(array![EVMTypes::Uint256, EVMTypes::Uint256].span())].span(),
        );

    assert!(*decoded.at(0) == 0x7b);
    assert!(*decoded.at(1) == 0x0);
    assert!(*decoded.at(2) == 0x22b);
    assert!(*decoded.at(3) == 0x0);
}

#[test]
fn test_decode_int128_neg() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff80);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Int128].span());
    assert!(*decoded.at(0) == -128);
}

#[test]
fn test_decode_multi_uint256() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000044);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Uint256, EVMTypes::Uint128].span());
    assert!(*decoded.at(0) == 0x20);
    assert!(*decoded.at(1) == 0x0);
    assert!(*decoded.at(2) == 0x44);
}

#[test]
fn test_decode_multi_uint128() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000044);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Uint128, EVMTypes::Uint128].span());
    assert!(*decoded.at(0) == 0x20);
    assert!(*decoded.at(1) == 0x44);
}

#[test]
fn test_decode_bytes_one_full_slot() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0xffffffffffffffffffaaaaaaaaaaaaaaaaaaafffffffffffffffffafafafaffa);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Bytes].span());
    assert!(*decoded.at(0) == 0x1);
    assert!(
        *decoded.at(1) == 0xffffffffffffffffffaaaaaaaaaaaaaaaaaaafffffffffffffffffafafafaf,
        "evm assertion failed",
    );
    assert!(*decoded.at(2) == 0xfa);
    assert!(*decoded.at(3) == 0x1);
}

#[test]
fn test_decode_bytes_one_slot() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000003);
    data.append_u256(0xffaabb0000000000000000000000000000000000000000000000000000000000);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Bytes].span());
    assert!(*decoded.at(0) == 0x0);
    assert!(*decoded.at(1) == 0xffaabb);
    assert!(*decoded.at(2) == 0x3);
}

#[test]
fn test_decode_bytes() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000020);
    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000039);
    data.append_u256(0xffaabbffaabbffaabbffaabbffaabbffaabbffaabbffaabbffaabbffaabbffaa);
    data.append_u256(0xbbffaabbffaabbffaabbffaabbffaabbffaabbffaabbffaabb00000000000000);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Bytes].span());
    assert!(*decoded.at(0) == 0x1);
    assert!(
        *decoded.at(1) == 0xffaabbffaabbffaabbffaabbffaabbffaabbffaabbffaabbffaabbffaabbff,
        "evm assertion failed",
    );
    assert!(
        *decoded.at(2) == 0xaabbffaabbffaabbffaabbffaabbffaabbffaabbffaabbffaabb,
        "evm assertion failed",
    );
    assert!(*decoded.at(3) == 0x1a);
}

#[test]
fn test_decode_bytes32_zeroes() {
    let mut data: ByteArray = Default::default();
    data.append_u256(0x00000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Bytes32].span());
    assert!(*decoded.at(0) == 1);
    assert!(
        *decoded.at(1) == 0x00000fffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        "evm assertion failed",
    );
    assert!(*decoded.at(2) == 0xff);
    assert!(*decoded.at(3) == 1);
}

#[test]
fn test_decode_bytes32() {
    let mut data: ByteArray = Default::default();
    data.append_u256(0xaaffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    let mut calldata = cd(data);
    let decoded = calldata.decode(array![EVMTypes::Bytes32].span());

    assert!(*decoded.at(0) == 1);
    assert!(
        *decoded.at(1) == 0xaaffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        "evm assertion failed",
    );
    assert!(*decoded.at(2) == 0xff);
    assert!(*decoded.at(3) == 1);
}

#[test]
fn test_decode_bytes2() {
    let mut data: ByteArray = Default::default();
    data.append_u256(0xff22000000000000000000000000000000000000000000000000000000000000);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Bytes2].span());

    assert!(*decoded.at(0) == 1);
    assert!(*decoded.at(1) == 0xff);
    assert!(*decoded.at(2) == 0x22);
    assert!(*decoded.at(3) == 1);
}

#[test]
fn test_decode_bytes31() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0xff22000000000000000000000000000000000000000000000000000000000000);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Bytes31].span());

    assert!(*decoded.at(0) == 1);
    assert!(
        *decoded.at(1) == 0xff2200000000000000000000000000000000000000000000000000000000,
        "evm assertion failed",
    );
    assert!(*decoded.at(2) == 0x0);
    assert!(*decoded.at(3) == 1);
}

#[test]
fn test_decode_bytes2_zero() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0022000000000000000000000000000000000000000000000000000000000000);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Bytes2].span());

    assert!(*decoded.at(0) == 1);
    assert!(*decoded.at(1) == 0x0);
    assert!(*decoded.at(2) == 0x22);
    assert!(*decoded.at(3) == 1);
}

#[test]
fn test_decode_int256_neg() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffce);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Int256].span());
    assert!(*decoded.at(0) == 50);
    assert!(*decoded.at(1) == 0);
    assert!(*decoded.at(2) == 0x1);
}

#[test]
fn test_decode_int256_pos() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x000000000000000000000000000000000000000000000000000000000000003c);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Int256].span());
    assert!(*decoded.at(0) == 60);
    assert!(*decoded.at(1) == 0);
    assert!(*decoded.at(2) == 0x0);
}

#[test]
fn test_decode_int256_zero() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000000);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Int256].span());
    assert!(*decoded.at(0) == 0);
    assert!(*decoded.at(1) == 0);
    assert!(*decoded.at(2) == 0x0);
}

#[test]
fn test_decode_int8_neg() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Int8].span());
    assert!(*decoded.at(0) == -5);
}

#[test]
fn test_decode_int8_pos() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000005);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Int8].span());
    assert!(*decoded.at(0) == 5);
}

#[test]
fn test_decode_int8_zero() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x0000000000000000000000000000000000000000000000000000000000000000);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Int8].span());
    assert!(*decoded.at(0) == 0);
}

#[test]
fn test_decode_address() {
    let mut data: ByteArray = Default::default();

    data.append_u256(0x000000000000000000000000742d35Cc6634C0532925a3b844Bc454e4438f44e);
    let mut calldata = cd(data);

    let decoded = calldata.decode(array![EVMTypes::Address].span());
    assert!(*decoded.at(0) == 0x742d35Cc6634C0532925a3b844Bc454e4438f44e);
}

#[test]
fn test_decode_transfer_from() {
    let mut data: ByteArray = Default::default();

    // Function selector (first 4 bytes)
    data.append_u32(0x23b872dd); // keccak256('match')

    // From address: 0x1111111111111111111111111111111111111111
    let from = 0x0000000000000000000000001111111111111111111111111111111111111111;
    data.append_u256(from);

    // To address: 0x2222222222222222222222222222222222222222
    let to = 0x0000000000000000000000002222222222222222222222222222222222222222;
    data.append_u256(to);

    // Amount: 1 ether
    data.append_u256(0x0000000000000000000000000000000000000000000000000de0b6b3a7640000);

    let mut calldata = cd(data);

    let decoded = calldata
        .decode(
            array![
                EVMTypes::FunctionSignature, EVMTypes::Address, EVMTypes::Address,
                EVMTypes::Uint256,
            ]
                .span(),
        );

    let selector = 0x23b872dd;
    let expected_from = 0x1111111111111111111111111111111111111111;
    let expected_to = 0x2222222222222222222222222222222222222222;
    let expected_amount = 1000000000000000000;

    assert!(*decoded.at(0) == selector.into());
    assert!(*decoded.at(1) == expected_from.into());
    assert!(*decoded.at(2) == expected_to.into());
    assert!(*decoded.at(3) == expected_amount.into());
}
