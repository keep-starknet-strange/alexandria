use alexandria_searching::binary_search::binary_search_closest as search;

#[test]
fn value_found() {
    let mut arr: Array<u128> = array![100, 200, 300, 400, 500, 600];

    let mut span = arr.span();

    // Test with an even length
    assert!(search(span, 100).unwrap() == 0);
    assert!(search(span, 200).unwrap() == 1);
    assert!(search(span, 300).unwrap() == 2);
    assert!(search(span, 400).unwrap() == 3);
    assert!(search(span, 500).unwrap() == 4);
    assert!(search(span, 600).unwrap() == 5);

    // Odd length
    arr.append(700);
    span = arr.span();
    assert!(search(span, 100).unwrap() == 0);
    assert!(search(span, 200).unwrap() == 1);
    assert!(search(span, 300).unwrap() == 2);
    assert!(search(span, 400).unwrap() == 3);
    assert!(search(span, 500).unwrap() == 4);
    assert!(search(span, 600).unwrap() == 5);
    assert!(search(span, 700).unwrap() == 6);
}

#[test]
fn value_not_found() {
    let mut arr: Array<u128> = array![100, 200, 300, 400, 500, 600];

    // Test with an even length
    let mut span = arr.span();
    assert!(search(span, 20).is_none());
    assert!(search(span, 42000).is_none());
    assert!(search(span, 760).is_none());

    // Odd length
    arr.append(700);
    span = arr.span();
    assert!(search(span, 20).is_none());
    assert!(search(span, 42000).is_none());
    assert!(search(span, 760).is_none());
}

#[test]
fn value_found_length_one() {
    let span: Span<u128> = array![100].span();

    assert!(search(span, 100).unwrap() == 0);
}

#[test]
fn value_not_found_length_one() {
    let span: Span<u128> = array![100].span();
    assert!(search(span, 50).is_none(), "value was found")
}

#[test]
fn zero_length_span() {
    let span: Span<u128> = array![].span();
    assert!(search(span, 100).is_none(), "value was found")
}

// Closest specific tests

#[test]
fn length_two_span() {
    let span: Span<u128> = array![100, 200].span();
    assert!(search(span, 50).is_none());
    assert!(search(span, 100).unwrap() == 0);
    assert!(search(span, 150).unwrap() == 0);
    assert!(search(span, 200).unwrap() == 1);
    assert!(search(span, 250).is_none());
}

#[test]
fn length_three_span() {
    let span: Span<u128> = array![100, 200, 300].span();
    assert!(search(span, 50).is_none());
    assert!(search(span, 100).unwrap() == 0);
    assert!(search(span, 150).unwrap() == 0);
    assert!(search(span, 200).unwrap() == 1);
    assert!(search(span, 250).unwrap() == 1);
    assert!(search(span, 300).unwrap() == 2);
    assert!(search(span, 350).is_none());
}

#[test]
fn closest_value_found() {
    let mut arr: Array<u128> = array![100, 200, 300, 400, 500, 600];

    let mut span = arr.span();

    // Test with an even length
    assert!(search(span, 150).unwrap() == 0);
    assert!(search(span, 250).unwrap() == 1);
    assert!(search(span, 350).unwrap() == 2);
    assert!(search(span, 450).unwrap() == 3);
    assert!(search(span, 550).unwrap() == 4);

    // Odd length
    arr.append(700);
    span = arr.span();
    assert!(search(span, 150).unwrap() == 0);
    assert!(search(span, 250).unwrap() == 1);
    assert!(search(span, 350).unwrap() == 2);
    assert!(search(span, 450).unwrap() == 3);
    assert!(search(span, 550).unwrap() == 4);
    assert!(search(span, 650).unwrap() == 5);
}

#[test]
fn all_values() {
    let mut arr: Array<u128> = array![100, 200, 300, 400, 500, 600];

    let mut span = arr.span();

    // Test with an even length
    assert!(search(span, 50).is_none());
    assert!(search(span, 100).unwrap() == 0);
    assert!(search(span, 150).unwrap() == 0);
    assert!(search(span, 200).unwrap() == 1);
    assert!(search(span, 250).unwrap() == 1);
    assert!(search(span, 300).unwrap() == 2);
    assert!(search(span, 350).unwrap() == 2);
    assert!(search(span, 400).unwrap() == 3);
    assert!(search(span, 450).unwrap() == 3);
    assert!(search(span, 500).unwrap() == 4);
    assert!(search(span, 550).unwrap() == 4);
    assert!(search(span, 600).unwrap() == 5);
    assert!(search(span, 650).is_none());

    // Odd length
    arr.append(700);
    span = arr.span();
    assert!(search(span, 50).is_none());
    assert!(search(span, 100).unwrap() == 0);
    assert!(search(span, 150).unwrap() == 0);
    assert!(search(span, 200).unwrap() == 1);
    assert!(search(span, 250).unwrap() == 1);
    assert!(search(span, 300).unwrap() == 2);
    assert!(search(span, 350).unwrap() == 2);
    assert!(search(span, 400).unwrap() == 3);
    assert!(search(span, 450).unwrap() == 3);
    assert!(search(span, 500).unwrap() == 4);
    assert!(search(span, 550).unwrap() == 4);
    assert!(search(span, 600).unwrap() == 5);
    assert!(search(span, 650).unwrap() == 5);
    assert!(search(span, 700).unwrap() == 6);
    assert!(search(span, 750).is_none());
}
