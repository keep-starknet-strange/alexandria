use alexandria_math::u512_arithmetics::{u512_add, u512_sub};
use core::integer::u512;

const MAX_128: u128 = 0xffffffffffffffffffffffffffffffff;
const A: u256 = 9099547013904003590785796930435194473319680151794113978918064868415326638035;
const B: u256 = 8021715850804026033197027745655159931503181100513576347155970296011118125764;

#[inline(always)]
fn mu512(limb0: u128, limb1: u128, limb2: u128, limb3: u128) -> u512 {
    u512 { limb0, limb1, limb2, limb3 }
}

#[test]
fn test_u512_add() {
    assert!(u512_add(mu512(1, 2, 3, 4), mu512(5, 6, 7, 8)) == mu512(6, 8, 10, 12));
    assert!(u512_add(mu512(MAX_128, 1, 2, 3), mu512(4, 5, 6, 7)) == mu512(3, 7, 8, 10));
}

#[test]
fn test_u512_sub() {
    let sub0 = u512_sub(mu512(5, 6, 7, 8), mu512(1, 2, 3, 4));
    assert!(sub0 == mu512(4, 4, 4, 4));

    let sub1 = u512_sub(mu512(3, 2, 1, MAX_128,), mu512(7, 6, 5, 4));
    assert!(
        sub1 == mu512(
            0xfffffffffffffffffffffffffffffffc,
            0xfffffffffffffffffffffffffffffffb,
            0xfffffffffffffffffffffffffffffffb,
            0xfffffffffffffffffffffffffffffffa
        )
    );

    let sub2 = u512_sub(mu512(3, 2, 1, 1), mu512(7, 6, 5, 0));
    assert!(
        sub2 == mu512(
            0xfffffffffffffffffffffffffffffffc,
            0xfffffffffffffffffffffffffffffffb,
            0xfffffffffffffffffffffffffffffffb,
            0
        )
    );
}
