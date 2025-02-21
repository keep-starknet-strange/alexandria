use core::num::traits::Zero;

// a basic struct
#[derive(Zero, Debug, Drop, PartialEq)]
struct B {
    pub a: u8,
    b: u16
}

// a generic struct
#[derive(Zero, Debug, Drop, PartialEq)]
struct G<T1, T2> {
    x: T1,
    pub y: T2,
    z: T2
}

// a complex struct
#[derive(Zero, Debug, Drop, PartialEq)]
struct C {
    pub g: G<u128, u256>,
    i: u64,
    j: u32
}


#[test]
fn test_zero_derive() {
    let b0: B = B { a: 0, b: 0 };
    let b1: B = B { a: 1, b: 2 };

    assert_eq!(b0, Zero::zero());
    assert!(b0.is_zero());
    assert!(b0.is_non_zero() == false);
    assert!(b1.is_zero() == false);
    assert!(b1.is_non_zero());

    let g0: G<u8, u128> = G { x: 0, y: 0, z: 0 };
    let g1: G<u8, u128> = G { x: 1, y: 2, z: 3 };

    assert_eq!(g0, Zero::zero());
    assert!(g0.is_zero());
    assert!(g0.is_non_zero() == false);
    assert!(g1.is_zero() == false);
    assert!(g1.is_non_zero());

    let c0: C = C { g: G { x: 0, y: 0, z: 0 }, i: 0, j: 0 };
    let c1: C = C { g: G { x: 0, y: 0, z: 0 }, i: 4, j: 5 };

    assert_eq!(c0, Zero::zero());
    assert!(c0.is_zero());
    assert!(c0.is_non_zero() == false);
    assert!(c1.is_zero() == false);
    assert!(c1.is_non_zero());
}
