use alexandria_searching::bm_search::bm_search;

#[test]
#[available_gas(5000000)]
fn bm_search_test_1() {
    // AABCAB12AFAABCABFFEGABCAB ->
    // 41,41,42,43,41,42,31,32,41,46,41,41,42,43,41,42,46,46,45,47,41,42,43,41,42
    let mut text: ByteArray = Default::default();
    text.append_byte(0x41_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x43_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x31_u8);
    text.append_byte(0x32_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x46_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x43_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x46_u8);
    text.append_byte(0x46_u8);
    text.append_byte(0x45_u8);
    text.append_byte(0x47_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x43_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    // ABCAB -> 41,42,43,41,42
    let mut pattern: ByteArray = Default::default();
    pattern.append_byte(0x41_u8);
    pattern.append_byte(0x42_u8);
    pattern.append_byte(0x43_u8);
    pattern.append_byte(0x41_u8);
    pattern.append_byte(0x42_u8);

    let positions = bm_search(@text, @pattern);
    let ground_truth: Array<usize> = array![1, 11, 20];
    assert_eq!(positions.span(), ground_truth.span());
}

#[test]
#[available_gas(5000000)]
fn bm_search_test_2() {
    // AABCAB12AFAABCABFFEGABCAB ->
    // 41,41,42,43,41,42,31,32,41,46,41,41,42,43,41,42,46,46,45,47,41,42,43,41,42
    let mut text: ByteArray = Default::default();
    text.append_byte(0x41_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x43_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x31_u8);
    text.append_byte(0x32_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x46_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x43_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x46_u8);
    text.append_byte(0x46_u8);
    text.append_byte(0x45_u8);
    text.append_byte(0x47_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x43_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    // FFF -> 46,46,46
    let mut pattern: ByteArray = Default::default();
    pattern.append_byte(0x46_u8);
    pattern.append_byte(0x46_u8);
    pattern.append_byte(0x46_u8);

    let positions = bm_search(@text, @pattern);
    let ground_truth: Array<usize> = array![];
    assert_eq!(positions.span(), ground_truth.span());
}

#[test]
#[available_gas(5000000)]
fn bm_search_test_3() {
    // AABCAB12AFAABCABFFEGABCAB ->
    // 41,41,42,43,41,42,31,32,41,46,41,41,42,43,41,42,46,46,45,47,41,42,43,41,42
    let mut text: ByteArray = Default::default();
    text.append_byte(0x41_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x43_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x31_u8);
    text.append_byte(0x32_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x46_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x43_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x46_u8);
    text.append_byte(0x46_u8);
    text.append_byte(0x45_u8);
    text.append_byte(0x47_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    text.append_byte(0x43_u8);
    text.append_byte(0x41_u8);
    text.append_byte(0x42_u8);
    // CAB -> 43,41,42
    let mut pattern: ByteArray = Default::default();
    pattern.append_byte(0x43_u8);
    pattern.append_byte(0x41_u8);
    pattern.append_byte(0x42_u8);

    let positions = bm_search(@text, @pattern);
    let ground_truth: Array<usize> = array![3, 13, 22];
    assert_eq!(positions.span(), ground_truth.span());
}
