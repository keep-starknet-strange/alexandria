use alexandria_math::fast_root::fast_sqrt;
use alexandria_math::fast_root::fast_cbrt;
use alexandria_math::fast_root::fast_nr_optimize;

#[test]
#[available_gas(5000000)]
fn fast_sqrt_test_1() {
    assert(fast_sqrt(100, 10) == 10, 'invalid result');
}

#[test]
#[available_gas(5000000)]
fn fast_sqrt_test_2() {
    assert(fast_sqrt(79, 10) == 9, 'invalid result');
}

#[test]
#[available_gas(5000000)]
fn fast_curt_test_1() {
    assert(fast_cbrt(1000, 10) == 10, 'invalid result');
}

#[test]
#[available_gas(5000000)]
fn fast_nr_optimize_test_1() {
    assert(fast_nr_optimize(10000, 4, 30) == 10, 'invalid result');
}
