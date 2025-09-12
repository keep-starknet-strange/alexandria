use alexandria_math::perfect_number::{is_perfect_number, perfect_numbers};


// is_perfect_number
#[test]
fn perfect_small_number_test() {
    assert!(is_perfect_number(6), "invalid result");
    assert!(is_perfect_number(28), "invalid result");
}

#[test]
fn perfect_big_number_test() {
    assert!(is_perfect_number(496), "invalid result");
}

#[test]
fn not_perfect_small_number_test() {
    assert!(!is_perfect_number(5), "invalid result");
    assert!(!is_perfect_number(86), "invalid result");
}

#[test]
fn not_perfect_big_number_test() {
    assert!(!is_perfect_number(497), "invalid result");
}

// perfect_numbers
#[test]
fn perfect_numbers_test() {
    let mut res = perfect_numbers(10);
    assert!(res.len() == 1);
}
