use alexandria_math::pow_macro::pow_inline;

#[test]
fn test_pow_inline_macro() {
    assert!(pow_inline!(2, 10) == 1024_u64);
    assert!(pow_inline!(2, 5) == 32_u64);
    assert!(pow_inline!(10, 2) == 100_u64);
    assert!(pow_inline!(3, 4) == 81_u64);
    assert!(pow_inline!(2, 20) == 1048576_u64);
}

#[test]
fn test_pow_inline_macro_zero_base() {
    assert!(pow_inline!(0, 5) == 0_u64);
    assert!(pow_inline!(0, 0) == 1_u64);
}
