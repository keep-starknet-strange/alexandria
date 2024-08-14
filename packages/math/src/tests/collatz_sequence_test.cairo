use alexandria_math::collatz_sequence::sequence;

#[test]
#[available_gas(2000000)]
fn collatz_sequence_10_test() {
    assert_eq!(sequence(10).len(), 7);
}

#[test]
#[available_gas(2000000)]
fn collatz_sequence_15_test() {
    assert_eq!(sequence(15).len(), 18);
}

#[test]
#[available_gas(2000000)]
fn collatz_sequence_empty_test() {
    assert_eq!(sequence(0).len(), 0);
}
