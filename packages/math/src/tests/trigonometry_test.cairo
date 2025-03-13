use alexandria_math::trigonometry::{fast_cos, fast_sin, fast_tan};

#[test]
#[available_gas(200000)]
fn sin_positive_test_1() {
    assert!(fast_sin(3000000000) == 50000000, "invalid result");
}

#[test]
#[available_gas(200000)]
fn sin_negative_test_1() {
    assert!(fast_sin(21000000000) == -50000000, "invalid result");
}

#[test]
#[available_gas(200000)]
fn sin_positive_test_2() {
    assert!(fast_sin(3500000000) == 57367231, "invalid result");
}

#[test]
#[available_gas(200000)]
fn sin_negative_test_2() {
    assert!(fast_sin(24300000000) == -89101846, "invalid result");
}

#[test]
#[available_gas(200000)]
fn sin_positive_test_3() {
    assert!(fast_sin(75000000000) == 50000000, "invalid result");
}

#[test]
#[available_gas(200000)]
fn cos_positive_test_1() {
    assert!(fast_cos(6000000000) == 50000000, "invalid result");
}

#[test]
#[available_gas(200000)]
fn cos_negative_test_1() {
    assert!(fast_cos(12000000000) == -50000000, "invalid result");
}

#[test]
#[available_gas(200000)]
fn tan_positive_test_1() {
    assert!(fast_tan(4500000000) == 100000000, "invalid result");
}

#[test]
#[available_gas(200000)]
fn tan_negative_test_1() {
    assert!(fast_tan(-4500000000) == -100000000, "invalid result");
}
