// a basic struct
#[derive(Add, AddAssign, Sub, SubAssign, Mul, MulAssign, Div, DivAssign, Debug, Drop, PartialEq)]
struct B {
    pub a: u8,
    b: u16
}

// a generic struct
#[derive(Add, AddAssign, Sub, SubAssign, Mul, MulAssign, Div, DivAssign, Debug, Drop, PartialEq)]
struct G<T1, T2> {
    x: T1,
    pub y: T2,
    z: T2
}


// a complex struct
#[derive(Add, AddAssign, Sub, SubAssign, Mul, MulAssign, Div, DivAssign, Debug, Drop, PartialEq)]
struct C {
    pub g: G<u128, u256>,
    i: u64,
    j: u32
}

#[test]
fn test_add_derive() {
    let b1 = B { a: 1, b: 2 };
    let b2 = B { a: 3, b: 4 };
    let b3 = b1 + b2;
    assert_eq!(b3, B { a: 4, b: 6 });

    let g1: G<u8, u128> = G { x: 1, y: 2, z: 3 };
    let g2: G<u8, u128> = G { x: 3, y: 4, z: 6 };
    let g3 = g1 + g2;
    assert_eq!(g3, G { x: 4, y: 6, z: 9 });

    let c1 = C { g: G { x: 1, y: 2, z: 3 }, i: 4, j: 5 };
    let c2 = C { g: G { x: 3, y: 4, z: 6 }, i: 8, j: 10 };
    let c3 = c1 + c2;
    assert_eq!(c3, C { g: G { x: 4, y: 6, z: 9 }, i: 12, j: 15 });
}

#[test]
fn test_sub_derive() {
    let b1 = B { a: 4, b: 8 };
    let b2 = B { a: 2, b: 8 };
    let b3 = b1 - b2;
    assert_eq!(b3, B { a: 2, b: 0 });

    let g1: G<u8, u128> = G { x: 4, y: 8, z: 16 };
    let g2: G<u8, u128> = G { x: 2, y: 4, z: 16 };
    let g3 = g1 - g2;
    assert_eq!(g3, G { x: 2, y: 4, z: 0 });

    let c1 = C { g: G { x: 4, y: 8, z: 16 }, i: 32, j: 64 };
    let c2 = C { g: G { x: 2, y: 4, z: 16 }, i: 16, j: 60 };
    let c3 = c1 - c2;
    assert_eq!(c3, C { g: G { x: 2, y: 4, z: 0 }, i: 16, j: 4 });
}

#[test]
fn test_mul_derive() {
    let b1 = B { a: 4, b: 8 };
    let b2 = B { a: 2, b: 8 };
    let b3 = b1 * b2;
    assert_eq!(b3, B { a: 8, b: 64 });

    let g1: G<u8, u128> = G { x: 4, y: 8, z: 16 };
    let g2: G<u8, u128> = G { x: 2, y: 4, z: 16 };
    let g3 = g1 * g2;
    assert_eq!(g3, G { x: 8, y: 32, z: 256 });

    let c1 = C { g: G { x: 4, y: 8, z: 16 }, i: 32, j: 64 };
    let c2 = C { g: G { x: 2, y: 4, z: 16 }, i: 16, j: 60 };
    let c3 = c1 * c2;
    assert_eq!(c3, C { g: G { x: 8, y: 32, z: 256 }, i: 512, j: 3840 });
}

#[test]
fn test_div_derive() {
    let b1 = B { a: 4, b: 8 };
    let b2 = B { a: 2, b: 8 };
    let b3 = b1 / b2;
    assert_eq!(b3, B { a: 2, b: 1 });

    let g1: G<u8, u128> = G { x: 4, y: 8, z: 16 };
    let g2: G<u8, u128> = G { x: 2, y: 4, z: 16 };
    let g3 = g1 / g2;
    assert_eq!(g3, G { x: 2, y: 2, z: 1 });

    let c1 = C { g: G { x: 4, y: 8, z: 16 }, i: 32, j: 64 };
    let c2 = C { g: G { x: 2, y: 4, z: 1 }, i: 16, j: 32 };
    let c3 = c1 / c2;
    assert_eq!(c3, C { g: G { x: 2, y: 2, z: 16 }, i: 2, j: 2 });
}

#[test]
fn test_addassign_derive() {
    let mut b1 = B { a: 1, b: 2 };
    let b2 = B { a: 3, b: 4 };
    b1 += b2;
    assert_eq!(b1, B { a: 4, b: 6 });

    let mut g1: G<u8, u128> = G { x: 1, y: 2, z: 3 };
    let g2: G<u8, u128> = G { x: 3, y: 4, z: 6 };
    g1 += g2;
    assert_eq!(g1, G { x: 4, y: 6, z: 9 });

    let mut c1 = C { g: G { x: 1, y: 2, z: 3 }, i: 4, j: 5 };
    let c2 = C { g: G { x: 3, y: 4, z: 6 }, i: 8, j: 10 };
    c1 += c2;
    assert_eq!(c1, C { g: G { x: 4, y: 6, z: 9 }, i: 12, j: 15 });
}

#[test]
fn test_subassign_derive() {
    let mut b1 = B { a: 4, b: 8 };
    let b2 = B { a: 2, b: 8 };
    b1 -= b2;
    assert_eq!(b1, B { a: 2, b: 0 });

    let mut g1: G<u8, u128> = G { x: 4, y: 8, z: 16 };
    let g2: G<u8, u128> = G { x: 2, y: 4, z: 16 };
    g1 -= g2;
    assert_eq!(g1, G { x: 2, y: 4, z: 0 });

    let mut c1 = C { g: G { x: 4, y: 8, z: 16 }, i: 32, j: 64 };
    let c2 = C { g: G { x: 2, y: 4, z: 16 }, i: 16, j: 60 };
    c1 -= c2;
    assert_eq!(c1, C { g: G { x: 2, y: 4, z: 0 }, i: 16, j: 4 });
}

#[test]
fn test_mulassign_derive() {
    let mut b1 = B { a: 4, b: 8 };
    let b2 = B { a: 2, b: 8 };
    b1 *= b2;
    assert_eq!(b1, B { a: 8, b: 64 });

    let mut g1: G<u8, u128> = G { x: 4, y: 8, z: 16 };
    let g2: G<u8, u128> = G { x: 2, y: 4, z: 16 };
    g1 *= g2;
    assert_eq!(g1, G { x: 8, y: 32, z: 256 });

    let mut c1 = C { g: G { x: 4, y: 8, z: 16 }, i: 32, j: 64 };
    let c2 = C { g: G { x: 2, y: 4, z: 16 }, i: 16, j: 60 };
    c1 *= c2;
    assert_eq!(c1, C { g: G { x: 8, y: 32, z: 256 }, i: 512, j: 3840 });
}

#[test]
fn test_divassign_derive() {
    let mut b1 = B { a: 4, b: 8 };
    let b2 = B { a: 2, b: 8 };
    b1 /= b2;
    assert_eq!(b1, B { a: 2, b: 1 });

    let mut g1: G<u8, u128> = G { x: 4, y: 8, z: 16 };
    let g2: G<u8, u128> = G { x: 2, y: 4, z: 16 };
    g1 /= g2;
    assert_eq!(g1, G { x: 2, y: 2, z: 1 });

    let mut c1 = C { g: G { x: 4, y: 8, z: 16 }, i: 32, j: 64 };
    let c2 = C { g: G { x: 2, y: 4, z: 1 }, i: 16, j: 32 };
    c1 /= c2;
    assert_eq!(c1, C { g: G { x: 2, y: 2, z: 16 }, i: 2, j: 2 });
}
