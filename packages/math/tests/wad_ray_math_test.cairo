use alexandria_math::pow;
use alexandria_math::wad_ray_math::{
    half_ray, half_wad, ray, ray_div, ray_mul, ray_to_wad, wad, wad_div, wad_mul, wad_to_ray,
};

// conversion
#[test]
fn test_wad_to_ray_conversion() {
    let a = 5 * pow(10, 17); // 0.5e18
    let expected = 5 * pow(10, 26); // 0.5e27
    assert!(wad_to_ray(a) == expected);
}

#[test]
fn test_ray_to_wad_conversion() {
    let a = 5 * pow(10, 26); // 0.5e27
    let expected = 5 * pow(10, 17); // 0.5e18
    assert!(ray_to_wad(a) == expected);
}

// wad
#[test]
#[should_panic]
fn test_revertWhen_wad_mul_overflow() {
    wad_mul(pow(2, 128), pow(2, 128));
}

#[test]
fn test_wad_mul_trivial() {
    assert!(wad_mul(pow(2, 128) - 1, wad()) == pow(2, 128) - 1);
    assert!(wad_mul(0, 0) == 0);
    assert!(wad_mul(0, wad()) == 0);
    assert!(wad_mul(wad(), 0) == 0);
    assert!(wad_mul(wad(), wad()) == wad());
}

#[test]
fn test_wad_mul_fractions() {
    let val: u256 = 2 * pow(10, 17); // 0.2e18
    assert!(wad_mul(wad(), val) == val);
    assert!(wad_mul(wad() * 2, val) == val * 2);
}

#[test]
#[should_panic]
fn test_revertWhen_wad_div_zero() {
    wad_div(wad(), 0);
}

#[test]
fn test_wad_div_trivial() {
    assert!(wad_div(pow(2, 128) - 1, wad()) == pow(2, 128) - 1);
    assert!(wad_div(0, pow(2, 128) - 1) == 0);
    assert!(wad_div(wad(), wad()) == wad());
}

#[test]
fn test_wad_div_fractions() {
    assert!(wad_div(wad() * 2, wad() * 2) == wad());
    assert!(wad_div(wad(), wad() * 2) == half_wad());
}

#[test]
fn test_wad_mul_rounding() {
    let a = 950000000000005647;
    let b = 1000000000;
    let expected = 950000000;
    assert!(wad_mul(a, b) == expected);
    assert!(wad_mul(b, a) == expected);
}

#[test]
fn test_wad_mul_rounding_up() {
    let a = pow(10, 18) - 1;
    let b = 2;
    let expected = 2;
    assert!(wad_mul(a, b) == expected);
    assert!(wad_mul(b, a) == expected);
}


// wad
#[test]
#[should_panic]
fn test_revertWhen_ray_mul_overflow() {
    ray_mul(pow(2, 128), pow(2, 128));
}

#[test]
fn test_ray_mul_trivial() {
    assert!(ray_mul(pow(2, 128) - 1, ray()) == pow(2, 128) - 1);
    assert!(ray_mul(0, 0) == 0);
    assert!(ray_mul(0, ray()) == 0);
    assert!(ray_mul(ray(), 0) == 0);
    assert!(ray_mul(ray(), ray()) == ray());
}

#[test]
fn test_ray_mul_fractions() {
    let val: u256 = 2 * pow(10, 26); // 0.2e27
    assert!(ray_mul(ray(), val) == val);
    assert!(ray_mul(ray() * 2, val) == val * 2);
}

#[test]
#[should_panic]
fn test_revertWhen_ray_div_zero() {
    ray_div(ray(), 0);
}

#[test]
fn test_ray_div_trivial() {
    assert!(ray_div(pow(2, 128) - 1, ray()) == pow(2, 128) - 1);
    assert!(ray_div(0, pow(2, 128) - 1) == 0);
    assert!(ray_div(ray(), ray()) == ray());
}

#[test]
fn test_ray_div_fractions() {
    assert!(ray_div(ray() * 2, ray() * 2) == ray());
    assert!(ray_div(ray(), ray() * 2) == half_ray());
}

#[test]
fn test_ray_mul_rounding() {
    let a = pow(10, 18);
    let b = 95 * pow(10, 26) + 5647;
    let expected = 95 * pow(10, 17);
    assert!(ray_mul(a, b) == expected);
    assert!(ray_mul(b, a) == expected);
}


#[test]
fn test_ray_mul_rounding_up() {
    let a = pow(10, 27) - 1;
    let b = 2;
    let expected = 2;
    assert!(ray_mul(a, b) == expected);
    assert!(ray_mul(b, a) == expected);
}
