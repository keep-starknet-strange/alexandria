use alexandria::math::mod_arithmetics::{add_mod, sub_mod, mult_mod, div_mod, pow_mod};

const p: u256 =
    57896044618658097711785492504343953926634992332820282019728792003956564819949; // 2^255 - 19
// 2^255 - 19
const pow_256_minus_1: u256 =
    115792089237316195423570985008687907853269984665640564039457584007913129639935;

#[test]
#[available_gas(500000000)]
fn add_mod_p_test() {
    assert(add_mod(p, p, p) == 0, 'Incorrect result');
    assert(add_mod(p, 1, p) == 1, 'Incorrect result');
    assert(add_mod(1, p, p) == 1, 'Incorrect result');
    assert(add_mod(10, 30, p) == 40, 'Incorrect result');
    assert(add_mod(0, 0, p) == 0, 'Incorrect result');
    assert(add_mod(0, 1, p) == 1, 'Incorrect result');
    assert(add_mod(1, 0, p) == 1, 'Incorrect result');
    assert(add_mod(pow_256_minus_1, 1, p) == 38, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn add_mod_2_test() {
    assert(add_mod(p, 2, 2) == 1, 'Incorrect result');
    assert(add_mod(p, 1, 2) == 0, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn add_mod_1_test() {
    assert(add_mod(p, 2, 1) == 0, 'Incorrect result');
    assert(add_mod(p, p, 1) == 0, 'Incorrect result');
    assert(add_mod(0, 0, 1) == 0, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn sub_mod_test() {
    assert(sub_mod(p, p, p) == 0, 'Incorrect result');
    assert(sub_mod(p, 1, p) == (p - 1), 'Incorrect result');
    assert(sub_mod(1, p, p) == 1, 'Incorrect result');
    assert(sub_mod(10, 30, p) == (p - 30 + 10), 'Incorrect result');
    assert(sub_mod(0, 0, p) == 0, 'Incorrect result');
    assert(sub_mod(0, 1, p) == (p - 1), 'Incorrect result');
    assert(sub_mod(1, 0, p) == 1, 'Incorrect result');
    assert(sub_mod(pow_256_minus_1, 1, p) == 36, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn sub_mod_1_test() {
    assert(sub_mod(p, p, 1) == 0, 'Incorrect result');
    assert(sub_mod(p, 1, 1) == 0, 'Incorrect result');
    assert(sub_mod(1, p, 1) == 0, 'Incorrect result');
    assert(sub_mod(10, 30, 1) == 0, 'Incorrect result');
    assert(sub_mod(0, 0, 1) == 0, 'Incorrect result');
    assert(sub_mod(0, 1, 1) == 0, 'Incorrect result');
    assert(sub_mod(1, 0, 1) == 0, 'Incorrect result');
    assert(sub_mod(pow_256_minus_1, 1, 1) == 0, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn sub_mod_2_test() {
    assert(sub_mod(p, p, 2) == 0, 'Incorrect result');
    assert(sub_mod(p, 1, 2) == 0, 'Incorrect result');
    assert(sub_mod(1, p, 2) == 0, 'Incorrect result');
    assert(sub_mod(10, 30, 2) == 0, 'Incorrect result');
    assert(sub_mod(0, 0, 2) == 0, 'Incorrect result');
    assert(sub_mod(0, 1, 2) == 1, 'Incorrect result');
    assert(sub_mod(1, 0, 2) == 1, 'Incorrect result');
    assert(sub_mod(pow_256_minus_1, 1, 2) == 0, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn mult_mod_test() {
    assert(mult_mod(p, p, p) == 0, 'Incorrect result');
    assert(mult_mod(p, 1, p) == 0, 'Incorrect result');
    assert(mult_mod(1, p, p) == 0, 'Incorrect result');
    assert(mult_mod(10, 30, p) == 300, 'Incorrect result');
    assert(mult_mod(0, 0, p) == 0, 'Incorrect result');
    assert(mult_mod(0, 1, p) == 0, 'Incorrect result');
    assert(mult_mod(1, 0, p) == 0, 'Incorrect result');
    assert(mult_mod(pow_256_minus_1, 1, p) == 37, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn mult_mod_1_test() {
    assert(mult_mod(p, p, 1) == 0, 'Incorrect result');
    assert(mult_mod(p, 1, 1) == 0, 'Incorrect result');
    assert(mult_mod(1, p, 1) == 0, 'Incorrect result');
    assert(mult_mod(10, 30, 1) == 0, 'Incorrect result');
    assert(mult_mod(0, 0, 1) == 0, 'Incorrect result');
    assert(mult_mod(0, 1, 1) == 0, 'Incorrect result');
    assert(mult_mod(1, 0, 1) == 0, 'Incorrect result');
    assert(mult_mod(pow_256_minus_1, 1, 1) == 0, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn mult_mod_2_test() {
    assert(mult_mod(p, p, 2) == 1, 'Incorrect result');
    assert(mult_mod(p, 1, 2) == 1, 'Incorrect result');
    assert(mult_mod(1, p, 2) == 1, 'Incorrect result');
    assert(mult_mod(10, 30, 2) == 0, 'Incorrect result');
    assert(mult_mod(0, 0, 2) == 0, 'Incorrect result');
    assert(mult_mod(0, 1, 2) == 0, 'Incorrect result');
    assert(mult_mod(1, 0, 2) == 0, 'Incorrect result');
    assert(mult_mod(pow_256_minus_1, 1, 2) == 1, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn pow_mod_test() {
    assert(pow_mod(2, 4, p) == 16, 'Incorrect result');
    assert(pow_mod(2, 256, p) == 38, 'Incorrect result');
    assert(pow_mod(2, 260, p) == 608, 'Incorrect result');
    assert(
        pow_mod(
            10, 260, p
        ) == 17820046977743035104984469918379927979184337110507416960697246160624073120874,
        'Incorrect result'
    );
    assert(pow_mod(4, 174, p) == 188166885971377801784666882048, 'Incorrect result');
    assert(pow_mod(100, p, p) == 100, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn pow_mod_1_test() {
    assert(pow_mod(2, 4, 1) == 0, 'Incorrect result');
    assert(pow_mod(2, 256, 1) == 0, 'Incorrect result');
    assert(pow_mod(2, 260, 1) == 0, 'Incorrect result');
    assert(pow_mod(10, 260, 1) == 0, 'Incorrect result');
    assert(pow_mod(4, 174, 1) == 0, 'Incorrect result');
    assert(pow_mod(100, p, 1) == 0, 'Incorrect result');
}

#[test]
#[available_gas(500000000)]
fn pow_mod_2_test() {
    assert(pow_mod(2, 4, 2) == 0, 'Incorrect result');
    assert(pow_mod(2, 256, 2) == 0, 'Incorrect result');
    assert(pow_mod(2, 260, 2) == 0, 'Incorrect result');
    assert(pow_mod(10, 260, 2) == 0, 'Incorrect result');
    assert(pow_mod(4, 174, 2) == 0, 'Incorrect result');
    assert(pow_mod(100, p, 2) == 0, 'Incorrect result');
}
