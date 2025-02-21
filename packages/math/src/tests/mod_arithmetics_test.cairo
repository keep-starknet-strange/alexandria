use alexandria_math::mod_arithmetics::{add_mod, sub_mod, mult_mod, sqr_mod, div_mod, pow_mod};
use core::traits::TryInto;

const p: u256 =
    57896044618658097711785492504343953926634992332820282019728792003956564819949; // 2^255 - 19
// 2^255 - 19
const pow_256_minus_1: u256 =
    115792089237316195423570985008687907853269984665640564039457584007913129639935;

#[test]
#[available_gas(500000000)]
fn add_mod_p_test() {
    let prime_non_zero = p.try_into().unwrap();

    assert_eq!(add_mod(p, p, prime_non_zero), 0);
    assert_eq!(add_mod(p, 1, prime_non_zero), 1);
    assert_eq!(add_mod(1, p, prime_non_zero), 1);
    assert_eq!(add_mod(10, 30, prime_non_zero), 40);
    assert_eq!(add_mod(0, 0, prime_non_zero), 0);
    assert_eq!(add_mod(0, 1, prime_non_zero), 1);
    assert_eq!(add_mod(1, 0, prime_non_zero), 1);
}

#[test]
#[available_gas(500000000)]
fn add_mod_2_test() {
    assert_eq!(add_mod(p, 2, 2), 1);
    assert_eq!(add_mod(p, 1, 2), 0);
}

#[test]
#[available_gas(500000000)]
fn add_mod_1_test() {
    assert_eq!(add_mod(p, 2, 1), 0);
    assert_eq!(add_mod(p, p, 1), 0);
    assert_eq!(add_mod(0, 0, 1), 0);
}

#[test]
#[available_gas(500000000)]
fn sub_mod_test() {
    assert_eq!(sub_mod(p, p, p), 0);
    assert_eq!(sub_mod(p, 1, p), (p - 1));
    assert_eq!(sub_mod(1, p, p), 1);
    assert_eq!(sub_mod(10, 30, p), (p - 30 + 10));
    assert_eq!(sub_mod(0, 0, p), 0);
    assert_eq!(sub_mod(0, 1, p), (p - 1));
    assert_eq!(sub_mod(1, 0, p), 1);
    assert_eq!(sub_mod(pow_256_minus_1, 1, p), 36);
}

#[test]
#[available_gas(500000000)]
fn sub_mod_1_test() {
    assert_eq!(sub_mod(p, p, 1), 0);
    assert_eq!(sub_mod(p, 1, 1), 0);
    assert_eq!(sub_mod(1, p, 1), 0);
    assert_eq!(sub_mod(10, 30, 1), 0);
    assert_eq!(sub_mod(0, 0, 1), 0);
    assert_eq!(sub_mod(0, 1, 1), 0);
    assert_eq!(sub_mod(1, 0, 1), 0);
    assert_eq!(sub_mod(pow_256_minus_1, 1, 1), 0);
}

#[test]
#[available_gas(500000000)]
fn sub_mod_2_test() {
    assert_eq!(sub_mod(p, p, 2), 0);
    assert_eq!(sub_mod(p, 1, 2), 0);
    assert_eq!(sub_mod(1, p, 2), 0);
    assert_eq!(sub_mod(10, 30, 2), 0);
    assert_eq!(sub_mod(0, 0, 2), 0);
    assert_eq!(sub_mod(0, 1, 2), 1);
    assert_eq!(sub_mod(1, 0, 2), 1);
    assert_eq!(sub_mod(pow_256_minus_1, 1, 2), 0);
}

#[test]
#[available_gas(500000000)]
fn mult_mod_test() {
    let prime_non_zero = p.try_into().unwrap();
    assert_eq!(mult_mod(p, p, prime_non_zero), 0);
    assert_eq!(mult_mod(p, 1, prime_non_zero), 0);
    assert_eq!(mult_mod(1, p, prime_non_zero), 0);
    assert_eq!(mult_mod(10, 30, prime_non_zero), 300);
    assert_eq!(mult_mod(0, 0, prime_non_zero), 0);
    assert_eq!(mult_mod(0, 1, prime_non_zero), 0);
    assert_eq!(mult_mod(1, 0, prime_non_zero), 0);
    assert_eq!(mult_mod(pow_256_minus_1, 1, prime_non_zero), 37);
}

#[test]
#[available_gas(500000000)]
fn mult_mod_1_test() {
    assert_eq!(mult_mod(p, p, 1), 0);
    assert_eq!(mult_mod(p, 1, 1), 0);
    assert_eq!(mult_mod(1, p, 1), 0);
    assert_eq!(mult_mod(10, 30, 1), 0);
    assert_eq!(mult_mod(0, 0, 1), 0);
    assert_eq!(mult_mod(0, 1, 1), 0);
    assert_eq!(mult_mod(1, 0, 1), 0);
    assert_eq!(mult_mod(pow_256_minus_1, 1, 1), 0);
}

#[test]
#[available_gas(500000000)]
fn mult_mod_2_test() {
    assert_eq!(mult_mod(p, p, 2), 1);
    assert_eq!(mult_mod(p, 1, 2), 1);
    assert_eq!(mult_mod(1, p, 2), 1);
    assert_eq!(mult_mod(10, 30, 2), 0);
    assert_eq!(mult_mod(0, 0, 2), 0);
    assert_eq!(mult_mod(0, 1, 2), 0);
    assert_eq!(mult_mod(1, 0, 2), 0);
    assert_eq!(mult_mod(pow_256_minus_1, 1, 2), 1);
}

#[test]
#[available_gas(500000000)]
fn sqr_mod_test() {
    assert_eq!(sqr_mod(p, 2), 1);
    assert_eq!(
        sqr_mod(p, pow_256_minus_1.try_into().unwrap()),
        mult_mod(p, p, pow_256_minus_1.try_into().unwrap()),
        "Incorrect result"
    );
    assert_eq!(
        sqr_mod(pow_256_minus_1, p.try_into().unwrap()),
        mult_mod(pow_256_minus_1, pow_256_minus_1, p.try_into().unwrap()),
        "Incorrect result"
    );
}

#[test]
#[available_gas(500000000)]
fn div_mod_test() {
    let prime_non_zero = p.try_into().unwrap();
    let div_10_30_mod_p =
        38597363079105398474523661669562635951089994888546854679819194669304376546633;
    assert_eq!(div_mod(p, 1, prime_non_zero), 0);
    assert_eq!(div_mod(30, 10, prime_non_zero), 3);
    assert_eq!(div_mod(10, 30, prime_non_zero), div_10_30_mod_p);
}

#[test]
#[available_gas(500000000)]
fn pow_mod_test() {
    let prime_non_zero = p.try_into().unwrap();
    assert_eq!(pow_mod(2, 4, prime_non_zero), 16);
    assert_eq!(pow_mod(2, 256, prime_non_zero), 38);
    assert_eq!(pow_mod(2, 260, prime_non_zero), 608);
    assert_eq!(
        pow_mod(10, 260, prime_non_zero),
        17820046977743035104984469918379927979184337110507416960697246160624073120874
    );
    assert_eq!(pow_mod(4, 174, prime_non_zero), 188166885971377801784666882048);
    assert_eq!(pow_mod(100, p, prime_non_zero), 100);
}

#[test]
#[available_gas(500000000)]
fn pow_mod_1_test() {
    assert_eq!(pow_mod(2, 4, 1), 0);
    assert_eq!(pow_mod(2, 256, 1), 0);
    assert_eq!(pow_mod(2, 260, 1), 0);
    assert_eq!(pow_mod(10, 260, 1), 0);
    assert_eq!(pow_mod(4, 174, 1), 0);
    assert_eq!(pow_mod(100, p, 1), 0);
}

#[test]
#[available_gas(500000000)]
fn pow_mod_2_test() {
    assert_eq!(pow_mod(2, 4, 2), 0);
    assert_eq!(pow_mod(2, 256, 2), 0);
    assert_eq!(pow_mod(2, 260, 2), 0);
    assert_eq!(pow_mod(10, 260, 2), 0);
    assert_eq!(pow_mod(4, 174, 2), 0);
    assert_eq!(pow_mod(100, p, 2), 0);
}
