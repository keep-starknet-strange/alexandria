use alexandria_searching::levenshtein_distance::levenshtein_distance;


#[test]
#[available_gas(5000000)]
fn bm_search_test_1() {
    // FROG -> 46,52,4f,47
    let mut arr1: ByteArray = Default::default();
    arr1.append_byte(0x46_u8);
    arr1.append_byte(0x52_u8);
    arr1.append_byte(0x4f_u8);
    arr1.append_byte(0x47_u8);
    // DOG -> 44,4f,47
    let mut arr2: ByteArray = Default::default();
    arr2.append_byte(0x44_u8);
    arr2.append_byte(0x4f_u8);
    arr2.append_byte(0x47_u8);

    let dist = levenshtein_distance(@arr1, @arr2);
    assert_eq!(dist, 2);
}

#[test]
#[available_gas(5000000)]
fn bm_search_test_2() {
    let mut arr1: ByteArray = Default::default();
    let mut arr2: ByteArray = Default::default();

    let dist = levenshtein_distance(@arr1, @arr2);
    assert_eq!(dist, 0);
}

#[test]
#[available_gas(5000000)]
fn bm_search_test_3() {
    let mut arr1: ByteArray = Default::default();
    let mut arr2: ByteArray = Default::default();
    arr2.append_byte(0x61_u8);

    let dist = levenshtein_distance(@arr1, @arr2);
    assert_eq!(dist, 1);
}

#[test]
#[available_gas(5000000)]
fn bm_search_test_4() {
    let mut arr1: ByteArray = Default::default();
    arr1.append_byte(0x61_u8);
    let mut arr2: ByteArray = Default::default();

    let dist = levenshtein_distance(@arr1, @arr2);
    assert_eq!(dist, 1);
}

#[test]
#[available_gas(5000000)]
fn bm_search_test_5() {
    let mut arr1: ByteArray = Default::default();
    arr1.append_byte(0x61_u8);
    arr1.append_byte(0x62_u8);
    let mut arr2: ByteArray = Default::default();
    arr2.append_byte(0x61_u8);

    let dist = levenshtein_distance(@arr1, @arr2);
    assert_eq!(dist, 1);
}

#[test]
#[available_gas(5000000)]
fn bm_search_test_6() {
    // foobar -> 66,6f,6f,62,61,72
    let mut arr1: ByteArray = Default::default();
    arr1.append_byte(0x66_u8);
    arr1.append_byte(0x6f_u8);
    arr1.append_byte(0x6f_u8);
    arr1.append_byte(0x62_u8);
    arr1.append_byte(0x61_u8);
    arr1.append_byte(0x72_u8);
    // foobar -> 66,6f,6f,62,61,72
    let mut arr2: ByteArray = Default::default();
    arr2.append_byte(0x66_u8);
    arr2.append_byte(0x6f_u8);
    arr2.append_byte(0x6f_u8);
    arr2.append_byte(0x62_u8);
    arr2.append_byte(0x61_u8);
    arr2.append_byte(0x72_u8);

    let dist = levenshtein_distance(@arr1, @arr2);
    assert_eq!(dist, 0);
}

#[test]
#[available_gas(5000000)]
fn bm_search_test_7() {
    // foobar -> 66,6f,6f,62,61,72
    let mut arr1: ByteArray = Default::default();
    arr1.append_byte(0x66_u8);
    arr1.append_byte(0x6f_u8);
    arr1.append_byte(0x6f_u8);
    arr1.append_byte(0x62_u8);
    arr1.append_byte(0x61_u8);
    arr1.append_byte(0x72_u8);
    // barfoo -> 62,61,72,66,6f,6f
    let mut arr2: ByteArray = Default::default();
    arr2.append_byte(0x62_u8);
    arr2.append_byte(0x61_u8);
    arr2.append_byte(0x72_u8);
    arr2.append_byte(0x66_u8);
    arr2.append_byte(0x6f_u8);
    arr2.append_byte(0x6f_u8);

    let dist = levenshtein_distance(@arr1, @arr2);
    assert_eq!(dist, 6);
}
