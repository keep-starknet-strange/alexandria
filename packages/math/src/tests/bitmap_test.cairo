use alexandria_math::bitmap::Bitmap;

#[test]
fn test_bitmap_get_bit_at_0() {
    let bitmap: u256 = 0;
    let result = Bitmap::get_bit_at(bitmap, 0);
    assert!(!result, "Bitmap: get bit");
}

#[test]
fn test_bitmap_get_bit_at_1() {
    let bitmap: u256 = 255;
    let result = Bitmap::get_bit_at(bitmap, 1);
    assert!(result, "Bitmap: get bit");
}

#[test]
fn test_bitmap_get_bit_at_10() {
    let bitmap: u256 = 3071;
    let result = Bitmap::get_bit_at(bitmap, 10);
    assert!(!result, "Bitmap: get bit");
}

#[test]
fn test_bitmap_set_bit_at_0() {
    let bitmap: u256 = 0;
    let result = Bitmap::set_bit_at(bitmap, 0, true);
    assert!(result == 1, "Bitmap: set bit at");
    let result = Bitmap::set_bit_at(bitmap, 0, false);
    assert!(result == bitmap, "Bitmap: unset bit at");
}

#[test]
fn test_bitmap_set_bit_at_1() {
    let bitmap: u256 = 1;
    let result = Bitmap::set_bit_at(bitmap, 1, true);
    assert!(result == 3, "Bitmap: set bit at");
    let result = Bitmap::set_bit_at(bitmap, 1, false);
    assert!(result == bitmap, "Bitmap: unset bit at");
}

#[test]
fn test_bitmap_set_bit_at_10() {
    let bitmap: u256 = 3;
    let result = Bitmap::set_bit_at(bitmap, 10, true);
    assert!(result == 1027, "Bitmap: set bit at");
    let result = Bitmap::set_bit_at(bitmap, 10, false);
    assert!(result == bitmap, "Bitmap: unset bit at");
}

#[test]
fn test_bitmap_most_significant_bit() {
    let bitmap: u32 = 1234; // 10011010010
    let msb = Bitmap::most_significant_bit(bitmap);
    assert!(msb.unwrap() == 10, "Bitmap: most significant bit");
}

#[test]
fn test_bitmap_least_significant_bit() {
    let bitmap: u32 = 1234; // 10011010010
    let msb = Bitmap::least_significant_bit(bitmap);
    assert!(msb.unwrap() == 1, "Bitmap: least significant bit");
}

#[test]
fn test_bitmap_nearest_left_significant_bit() {
    let bitmap: u32 = 1234; // 10011010010
    let index = 5;
    let nlsb = Bitmap::nearest_left_significant_bit(bitmap, index);
    assert!(nlsb.unwrap() == 6, "Bitmap: nearest significant bit");
}

#[test]
fn test_bitmap_nearest_right_significant_bit() {
    let bitmap: u32 = 1234; // 10011010010
    let index = 5;
    let nrsb = Bitmap::nearest_right_significant_bit(bitmap, index);
    assert!(nrsb.unwrap() == 4, "Bitmap: nearest significant bit");
}

#[test]
fn test_bitmap_nearest_significant_bit_left_priority() {
    let bitmap: u32 = 1234; // 10011010010
    let index = 5;
    let nsb = Bitmap::nearest_significant_bit(bitmap, index, false);
    assert!(nsb.unwrap() == 6, "Bitmap: nearest significant bit");
}

#[test]
fn test_bitmap_nearest_significant_bit_right_priority() {
    let bitmap: u32 = 1234; // 10011010010
    let index = 5;
    let nsb = Bitmap::nearest_significant_bit(bitmap, index, true);
    assert!(nsb.unwrap() == 4, "Bitmap: nearest significant bit");
}

#[test]
fn test_bitmap_nearest_significant_bit_left_priority_at_index() {
    let bitmap: u32 = 1234; // 10011010010
    let index = 6;
    let nsb = Bitmap::nearest_significant_bit(bitmap, index, false);
    assert!(nsb.unwrap() == 6, "Bitmap: nearest significant bit");
}

#[test]
fn test_bitmap_nearest_significant_bit_right_priority_at_index() {
    let bitmap: u32 = 1234; // 10011010010
    let index = 6;
    let nsb = Bitmap::nearest_significant_bit(bitmap, index, true);
    assert!(nsb.unwrap() == 6, "Bitmap: nearest significant bit");
}
