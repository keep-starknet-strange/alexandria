use alexandria_math::fast_root::{fast_cbrt, fast_nr_optimize, fast_sqrt};

#[test]
fn fast_sqrt_test_1() {
    assert!(fast_sqrt(100, 10) == 10);
}

#[test]
fn fast_sqrt_test_2() {
    assert!(fast_sqrt(79, 10) == 9);
}

#[test]
fn fast_curt_test_1() {
    assert!(fast_cbrt(1000, 10) == 10);
}

#[test]
fn fast_nr_optimize_test_1() {
    assert!(fast_nr_optimize(10000, 4, 30) == 10);
}

#[test]
fn fast_nr_optimize_test_2() {
    assert!(fast_nr_optimize(10, 1, 10) == 10);
}
