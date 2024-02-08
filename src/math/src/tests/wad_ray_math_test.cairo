use alexandria_math::wad_ray_math::{
    ray_div, ray_mul, wad_div, wad_mul, ray_to_wad, wad_to_ray, ray, wad, half_ray, half_wad
};
use alexandria_math::{pow};

// conversion
#[test]
#[available_gas(2000000)]
fn test_wad_to_ray_conversion() {
    let a = 5 * pow(10, 17); // 0.5e18
    let expected = 5 * pow(10, 26); // 0.5e27
    assert_eq!(wad_to_ray(a), expected, "Wrong wad_to_ray conversion");
}

#[test]
#[available_gas(2000000)]
fn test_ray_to_wad_conversion() {
    let a = 5 * pow(10, 26); // 0.5e27
    let expected = 5 * pow(10, 17); // 0.5e18
    assert_eq!(ray_to_wad(a), expected, "Wrong ray_to_wad conversion");
}

// wad
#[test]
#[available_gas(2000000)]
#[should_panic()]
fn test_revertWhen_wad_mul_overflow() {
    wad_mul(pow(2, 128), pow(2, 128));
}

#[test]
#[available_gas(2000000)]
fn test_wad_mul_trivial() {
    assert_eq!(wad_mul(pow(2, 128) - 1, wad()), pow(2, 128) - 1, "Wrong result: 2**128 -1 * 1e18");
    assert_eq!(wad_mul(0, 0), 0, "Wrong result: 0 * 0");
    assert_eq!(wad_mul(0, wad()), 0, "Wrong result: 0 * 1e18");
    assert_eq!(wad_mul(wad(), 0), 0, "Wrong result: 1e18 * 0");
    assert_eq!(wad_mul(wad(), wad()), wad(), "Wrong result: 1e18 * 1e18 ");
}

#[test]
#[available_gas(2000000)]
fn test_wad_mul_fractions() {
    let val: u256 = 2 * pow(10, 17); // 0.2e18
    assert_eq!(wad_mul(wad(), val), val, "Wrong result: 1e18 * 0.2e18");
    assert_eq!(wad_mul(wad() * 2, val), val * 2, "Wrong result: 2e18 * 0.2e18");
}

#[test]
#[available_gas(2000000)]
#[should_panic()]
fn test_revertWhen_wad_div_zero() {
    wad_div(wad(), 0);
}

#[test]
#[available_gas(3000000)]
fn test_wad_div_trivial() {
    assert_eq!(wad_div(pow(2, 128) - 1, wad()), pow(2, 128) - 1, "Wrong result: 2**128 -1 / 1e18");
    assert_eq!(wad_div(0, pow(2, 128) - 1), 0, "Wrong result: 0 / 2**128 -1");
    assert_eq!(wad_div(wad(), wad()), wad(), "Wrong result: 1e18 / 1e18");
}

#[test]
#[available_gas(2000000)]
fn test_wad_div_fractions() {
    assert_eq!(wad_div(wad() * 2, wad() * 2), wad(), "Wrong result: 2e18 / 2e18");
    assert_eq!(wad_div(wad(), wad() * 2), half_wad(), "Wrong result: 1e18 / 2e18");
}

#[test]
#[available_gas(2000000)]
fn test_wad_mul_rounding() {
    let a = 950000000000005647;
    let b = 1000000000;
    let expected = 950000000;
    assert_eq!(wad_mul(a, b), expected, "Wrong rounding down: a * b");
    assert_eq!(wad_mul(b, a), expected, "Wrong rounding down: b * a");
}

#[test]
#[available_gas(2000000)]
fn test_wad_mul_rounding_up() {
    let a = pow(10, 18) - 1;
    let b = 2;
    let expected = 2;
    assert_eq!(wad_mul(a, b), expected, "Wrong rounding: a * b");
    assert_eq!(wad_mul(b, a), expected, "Wrong rounding: b * a");
}


// wad
#[test]
#[available_gas(2000000)]
#[should_panic()]
fn test_revertWhen_ray_mul_overflow() {
    ray_mul(pow(2, 128), pow(2, 128));
}

#[test]
#[available_gas(2000000)]
fn test_ray_mul_trivial() {
    assert_eq!(ray_mul(pow(2, 128) - 1, ray()), pow(2, 128) - 1, "Wrong result: 2**128 -1 * 1e27");
    assert_eq!(ray_mul(0, 0), 0, "Wrong result: 0 * 0");
    assert_eq!(ray_mul(0, ray()), 0, "Wrong result: 0 * 1e27");
    assert_eq!(ray_mul(ray(), 0), 0, "Wrong result: 1e27 * 0");
    assert_eq!(ray_mul(ray(), ray()), ray(), "Wrong result: 1e27 * 1e27 ");
}

#[test]
#[available_gas(2000000)]
fn test_ray_mul_fractions() {
    let val: u256 = 2 * pow(10, 26); // 0.2e27
    assert_eq!(ray_mul(ray(), val), val, "Wrong result: 1e27 * 0.2e27");
    assert_eq!(ray_mul(ray() * 2, val), val * 2, "Wrong result: 2e27 * 0.2e27");
}

#[test]
#[available_gas(2000000)]
#[should_panic()]
fn test_revertWhen_ray_div_zero() {
    ray_div(ray(), 0);
}

#[test]
#[available_gas(3000000)]
fn test_ray_div_trivial() {
    assert_eq!(ray_div(pow(2, 128) - 1, ray()), pow(2, 128) - 1, "Wrong result: 2**128 -1 / 1e27");
    assert_eq!(ray_div(0, pow(2, 128) - 1), 0, "Wrong result: 0 / 2**128 -1");
    assert_eq!(ray_div(ray(), ray()), ray(), "Wrong result: 1e27 / 1e27");
}

#[test]
#[available_gas(2000000)]
fn test_ray_div_fractions() {
    assert_eq!(ray_div(ray() * 2, ray() * 2), ray(), "Wrong result: 2e27 / 2e27");
    assert_eq!(ray_div(ray(), ray() * 2), half_ray(), "Wrong result: 1e27 / 2e27");
}

#[test]
#[available_gas(2000000)]
fn test_ray_mul_rounding() {
    let a = pow(10, 18);
    let b = 95 * pow(10, 26) + 5647;
    let expected = 95 * pow(10, 17);
    assert_eq!(ray_mul(a, b), expected, "Wrong rounding down: a * b");
    assert_eq!(ray_mul(b, a), expected, "Wrong rounding down: b * a");
}


#[test]
#[available_gas(2000000)]
fn test_ray_mul_rounding_up() {
    let a = pow(10, 27) - 1;
    let b = 2;
    let expected = 2;
    assert_eq!(ray_mul(a, b), expected, "Wrong rounding up: a * b");
    assert_eq!(ray_mul(b, a), expected, "Wrong rounding up: b * a");
}
