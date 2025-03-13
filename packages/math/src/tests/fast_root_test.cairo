use alexandria_math::fast_root::{fast_cbrt, fast_nr_optimize, fast_sqrt};

#[test]
#[available_gas(5000000)]
fn fast_sqrt_test_1() {
    assert_eq!(fast_sqrt(100, 10), 10);
}

#[test]
#[available_gas(5000000)]
fn fast_sqrt_test_2() {
    assert_eq!(fast_sqrt(79, 10), 9);
}

#[test]
#[available_gas(5000000)]
fn fast_curt_test_1() {
    assert_eq!(fast_cbrt(1000, 10), 10);
}

#[test]
#[available_gas(5000000)]
fn fast_nr_optimize_test_1() {
    assert_eq!(fast_nr_optimize(10000, 4, 30), 10);
}

#[test]
#[available_gas(5000000)]
fn fast_nr_optimize_test_2() {
    assert_eq!(fast_nr_optimize(10, 1, 10), 10);
}
