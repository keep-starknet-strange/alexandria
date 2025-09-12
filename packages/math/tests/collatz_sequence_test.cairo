use alexandria_math::collatz_sequence::sequence;

#[test]
fn collatz_sequence_10_test() {
    assert!(sequence(10).len() == 7);
}

#[test]
fn collatz_sequence_15_test() {
    assert!(sequence(15).len() == 18);
}

#[test]
fn collatz_sequence_empty_test() {
    assert!(sequence(0).len() == 0);
}
