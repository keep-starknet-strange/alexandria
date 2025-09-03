use alexandria_math::WrappingMath;
use core::num::traits::WideMul;

/// Runtime optimized math utils (n steps / gas)
/// Might increase contract size, but usefull on some critical implementations

// Overflowing

/// Optimized overflowing mul over u128.
/// #### Arguments
/// * `a` - Left hand side of multiplication.
/// * `b` - Right hand side of multiplication.
/// #### Returns
/// * `u128` - result of overflowing multiplication
#[inline(always)]
fn overflowing_mul128(x: u128, y: u128) -> u128 {
    let res = x.wide_mul(y);

    res.low
}

/// Optimized overflowing mul over u64.
/// #### Arguments
/// * `a` - Left hand side of multiplication.
/// * `b` - Right hand side of multiplication.
/// #### Returns
/// * `u64` - result of overflowing multiplication
#[inline(always)]
fn overflowing_mul64(x: u64, y: u64) -> u64 {
    let res = x.wide_mul(y);

    (res & 0xffffffffffffffff).try_into().unwrap()
}

/// Optimized overflowing mul over u32.
/// #### Arguments
/// * `a` - Left hand side of multiplication.
/// * `b` - Right hand side of multiplication.
/// #### Returns
/// * `u32` - result of overflowing multiplication
#[inline(always)]
fn overflowing_mul32(x: u32, y: u32) -> u32 {
    let res = x.wide_mul(y);

    (res & 0xffffffff).try_into().unwrap()
}

/// Optimized overflowing mul over u16.
/// #### Arguments
/// * `a` - Left hand side of multiplication.
/// * `b` - Right hand side of multiplication.
/// #### Returns
/// * `u16` - result of overflowing multiplication
#[inline(always)]
fn overflowing_mul16(x: u16, y: u16) -> u16 {
    let res = x.wide_mul(y);

    (res & 0xffff).try_into().unwrap()
}

/// Optimized overflowing mul over u8.
/// #### Arguments
/// * `a` - Left hand side of multiplication.
/// * `b` - Right hand side of multiplication.
/// #### Returns
/// * `u8` - result of overflowing multiplication
#[inline(always)]
fn overflowing_mul8(a: u8, b: u8) -> u8 {
    let res = a.wide_mul(b);

    (res & 0xff).try_into().unwrap()
}

/// Optimized opt_wrapping math trait (overflowing add, sub, mul).
pub trait OptWrapping<T> {
    /// Returns wrapped result of overflowing addition.
    fn opt_wrapping_add(self: T, v: T) -> T;
    /// Returns wrapped result of overflowing substraction.
    fn opt_wrapping_sub(self: T, v: T) -> T;
    /// Returns wrapped result of overflowing multiplication.
    fn opt_wrapping_mul(self: T, v: T) -> T;
}

pub impl U256OptWrappingImpl of OptWrapping<u256> {
    #[inline(always)]
    fn opt_wrapping_add(self: u256, v: u256) -> u256 {
        self.wrapping_add(v)
    }
    #[inline(always)]
    fn opt_wrapping_sub(self: u256, v: u256) -> u256 {
        self.wrapping_sub(v)
    }
    #[inline(always)]
    fn opt_wrapping_mul(self: u256, v: u256) -> u256 {
        self.wrapping_mul(v)
    }
}

pub impl U128OptWrappingImpl of OptWrapping<u128> {
    #[inline(always)]
    fn opt_wrapping_add(self: u128, v: u128) -> u128 {
        self.wrapping_add(v)
    }
    #[inline(always)]
    fn opt_wrapping_sub(self: u128, v: u128) -> u128 {
        self.wrapping_sub(v)
    }
    #[inline(always)]
    fn opt_wrapping_mul(self: u128, v: u128) -> u128 {
        overflowing_mul128(self, v)
    }
}

pub impl U64OptWrappingAddImpl of OptWrapping<u64> {
    #[inline(always)]
    fn opt_wrapping_add(self: u64, v: u64) -> u64 {
        self.wrapping_add(v)
    }
    #[inline(always)]
    fn opt_wrapping_sub(self: u64, v: u64) -> u64 {
        self.wrapping_sub(v)
    }
    #[inline(always)]
    fn opt_wrapping_mul(self: u64, v: u64) -> u64 {
        overflowing_mul64(self, v)
    }
}

pub impl U32OptWrappingImpl of OptWrapping<u32> {
    #[inline(always)]
    fn opt_wrapping_add(self: u32, v: u32) -> u32 {
        self.wrapping_add(v)
    }
    #[inline(always)]
    fn opt_wrapping_sub(self: u32, v: u32) -> u32 {
        self.wrapping_sub(v)
    }
    #[inline(always)]
    fn opt_wrapping_mul(self: u32, v: u32) -> u32 {
        overflowing_mul32(self, v)
    }
}

pub impl U16OptWrappingmpl of OptWrapping<u16> {
    #[inline(always)]
    fn opt_wrapping_add(self: u16, v: u16) -> u16 {
        self.wrapping_add(v)
    }
    #[inline(always)]
    fn opt_wrapping_sub(self: u16, v: u16) -> u16 {
        self.wrapping_sub(v)
    }
    #[inline(always)]
    fn opt_wrapping_mul(self: u16, v: u16) -> u16 {
        overflowing_mul16(self, v)
    }
}

pub impl U8OptWrappingImpl of OptWrapping<u8> {
    #[inline(always)]
    fn opt_wrapping_add(self: u8, v: u8) -> u8 {
        self.wrapping_add(v)
    }
    #[inline(always)]
    fn opt_wrapping_sub(self: u8, v: u8) -> u8 {
        self.wrapping_sub(v)
    }
    #[inline(always)]
    fn opt_wrapping_mul(self: u8, v: u8) -> u8 {
        overflowing_mul8(self, v)
    }
}

// Bit shifts

/// Bit shift table u8
const SHIFT_TABLE8: [u8; 8] = [0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80];

/// Bit shift table u16
const SHIFT_TABLE16: [u16; 16] = [
    0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000,
    0x8000,
];

/// Bit shift table u32
const SHIFT_TABLE32: [u32; 32] = [
    0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000,
    0x8000, 0x10000, 0x20000, 0x40000, 0x80000, 0x100000, 0x200000, 0x400000, 0x800000, 0x1000000,
    0x2000000, 0x4000000, 0x8000000, 0x10000000, 0x20000000, 0x40000000, 0x80000000,
];

/// Bit shift table u64
const SHIFT_TABLE64: [u64; 64] = [
    0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000,
    0x8000, 0x10000, 0x20000, 0x40000, 0x80000, 0x100000, 0x200000, 0x400000, 0x800000, 0x1000000,
    0x2000000, 0x4000000, 0x8000000, 0x10000000, 0x20000000, 0x40000000, 0x80000000, 0x100000000,
    0x200000000, 0x400000000, 0x800000000, 0x1000000000, 0x2000000000, 0x4000000000, 0x8000000000,
    0x10000000000, 0x20000000000, 0x40000000000, 0x80000000000, 0x100000000000, 0x200000000000,
    0x400000000000, 0x800000000000, 0x1000000000000, 0x2000000000000, 0x4000000000000,
    0x8000000000000, 0x10000000000000, 0x20000000000000, 0x40000000000000, 0x80000000000000,
    0x100000000000000, 0x200000000000000, 0x400000000000000, 0x800000000000000, 0x1000000000000000,
    0x2000000000000000, 0x4000000000000000, 0x8000000000000000,
];

/// Bit shift table u128
const SHIFT_TABLE128: [u128; 128] = [
    0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000,
    0x8000, 0x10000, 0x20000, 0x40000, 0x80000, 0x100000, 0x200000, 0x400000, 0x800000, 0x1000000,
    0x2000000, 0x4000000, 0x8000000, 0x10000000, 0x20000000, 0x40000000, 0x80000000, 0x100000000,
    0x200000000, 0x400000000, 0x800000000, 0x1000000000, 0x2000000000, 0x4000000000, 0x8000000000,
    0x10000000000, 0x20000000000, 0x40000000000, 0x80000000000, 0x100000000000, 0x200000000000,
    0x400000000000, 0x800000000000, 0x1000000000000, 0x2000000000000, 0x4000000000000,
    0x8000000000000, 0x10000000000000, 0x20000000000000, 0x40000000000000, 0x80000000000000,
    0x100000000000000, 0x200000000000000, 0x400000000000000, 0x800000000000000, 0x1000000000000000,
    0x2000000000000000, 0x4000000000000000, 0x8000000000000000, 0x10000000000000000,
    0x20000000000000000, 0x40000000000000000, 0x80000000000000000, 0x100000000000000000,
    0x200000000000000000, 0x400000000000000000, 0x800000000000000000, 0x1000000000000000000,
    0x2000000000000000000, 0x4000000000000000000, 0x8000000000000000000, 0x10000000000000000000,
    0x20000000000000000000, 0x40000000000000000000, 0x80000000000000000000, 0x100000000000000000000,
    0x200000000000000000000, 0x400000000000000000000, 0x800000000000000000000,
    0x1000000000000000000000, 0x2000000000000000000000, 0x4000000000000000000000,
    0x8000000000000000000000, 0x10000000000000000000000, 0x20000000000000000000000,
    0x40000000000000000000000, 0x80000000000000000000000, 0x100000000000000000000000,
    0x200000000000000000000000, 0x400000000000000000000000, 0x800000000000000000000000,
    0x1000000000000000000000000, 0x2000000000000000000000000, 0x4000000000000000000000000,
    0x8000000000000000000000000, 0x10000000000000000000000000, 0x20000000000000000000000000,
    0x40000000000000000000000000, 0x80000000000000000000000000, 0x100000000000000000000000000,
    0x200000000000000000000000000, 0x400000000000000000000000000, 0x800000000000000000000000000,
    0x1000000000000000000000000000, 0x2000000000000000000000000000, 0x4000000000000000000000000000,
    0x8000000000000000000000000000, 0x10000000000000000000000000000,
    0x20000000000000000000000000000, 0x40000000000000000000000000000,
    0x80000000000000000000000000000, 0x100000000000000000000000000000,
    0x200000000000000000000000000000, 0x400000000000000000000000000000,
    0x800000000000000000000000000000, 0x1000000000000000000000000000000,
    0x2000000000000000000000000000000, 0x4000000000000000000000000000000,
    0x8000000000000000000000000000000, 0x10000000000000000000000000000000,
    0x20000000000000000000000000000000, 0x40000000000000000000000000000000,
    0x80000000000000000000000000000000,
];

/// Bit shift table u256
const SHIFT_TABLE256: [u256; 256] = [
    0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000,
    0x8000, 0x10000, 0x20000, 0x40000, 0x80000, 0x100000, 0x200000, 0x400000, 0x800000, 0x1000000,
    0x2000000, 0x4000000, 0x8000000, 0x10000000, 0x20000000, 0x40000000, 0x80000000, 0x100000000,
    0x200000000, 0x400000000, 0x800000000, 0x1000000000, 0x2000000000, 0x4000000000, 0x8000000000,
    0x10000000000, 0x20000000000, 0x40000000000, 0x80000000000, 0x100000000000, 0x200000000000,
    0x400000000000, 0x800000000000, 0x1000000000000, 0x2000000000000, 0x4000000000000,
    0x8000000000000, 0x10000000000000, 0x20000000000000, 0x40000000000000, 0x80000000000000,
    0x100000000000000, 0x200000000000000, 0x400000000000000, 0x800000000000000, 0x1000000000000000,
    0x2000000000000000, 0x4000000000000000, 0x8000000000000000, 0x10000000000000000,
    0x20000000000000000, 0x40000000000000000, 0x80000000000000000, 0x100000000000000000,
    0x200000000000000000, 0x400000000000000000, 0x800000000000000000, 0x1000000000000000000,
    0x2000000000000000000, 0x4000000000000000000, 0x8000000000000000000, 0x10000000000000000000,
    0x20000000000000000000, 0x40000000000000000000, 0x80000000000000000000, 0x100000000000000000000,
    0x200000000000000000000, 0x400000000000000000000, 0x800000000000000000000,
    0x1000000000000000000000, 0x2000000000000000000000, 0x4000000000000000000000,
    0x8000000000000000000000, 0x10000000000000000000000, 0x20000000000000000000000,
    0x40000000000000000000000, 0x80000000000000000000000, 0x100000000000000000000000,
    0x200000000000000000000000, 0x400000000000000000000000, 0x800000000000000000000000,
    0x1000000000000000000000000, 0x2000000000000000000000000, 0x4000000000000000000000000,
    0x8000000000000000000000000, 0x10000000000000000000000000, 0x20000000000000000000000000,
    0x40000000000000000000000000, 0x80000000000000000000000000, 0x100000000000000000000000000,
    0x200000000000000000000000000, 0x400000000000000000000000000, 0x800000000000000000000000000,
    0x1000000000000000000000000000, 0x2000000000000000000000000000, 0x4000000000000000000000000000,
    0x8000000000000000000000000000, 0x10000000000000000000000000000,
    0x20000000000000000000000000000, 0x40000000000000000000000000000,
    0x80000000000000000000000000000, 0x100000000000000000000000000000,
    0x200000000000000000000000000000, 0x400000000000000000000000000000,
    0x800000000000000000000000000000, 0x1000000000000000000000000000000,
    0x2000000000000000000000000000000, 0x4000000000000000000000000000000,
    0x8000000000000000000000000000000, 0x10000000000000000000000000000000,
    0x20000000000000000000000000000000, 0x40000000000000000000000000000000,
    0x80000000000000000000000000000000, 0x100000000000000000000000000000000,
    0x200000000000000000000000000000000, 0x400000000000000000000000000000000,
    0x800000000000000000000000000000000, 0x1000000000000000000000000000000000,
    0x2000000000000000000000000000000000, 0x4000000000000000000000000000000000,
    0x8000000000000000000000000000000000, 0x10000000000000000000000000000000000,
    0x20000000000000000000000000000000000, 0x40000000000000000000000000000000000,
    0x80000000000000000000000000000000000, 0x100000000000000000000000000000000000,
    0x200000000000000000000000000000000000, 0x400000000000000000000000000000000000,
    0x800000000000000000000000000000000000, 0x1000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000, 0x4000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000, 0x10000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000, 0x40000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000, 0x100000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000, 0x400000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000, 0x1000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000, 0x4000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000, 0x10000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000, 0x40000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000, 0x100000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000, 0x400000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000, 0x1000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000, 0x4000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000, 0x10000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000, 0x40000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000, 0x100000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000000000000000,
    0x10000000000000000000000000000000000000000000000000000000000000,
    0x20000000000000000000000000000000000000000000000000000000000000,
    0x40000000000000000000000000000000000000000000000000000000000000,
    0x80000000000000000000000000000000000000000000000000000000000000,
    0x100000000000000000000000000000000000000000000000000000000000000,
    0x200000000000000000000000000000000000000000000000000000000000000,
    0x400000000000000000000000000000000000000000000000000000000000000,
    0x800000000000000000000000000000000000000000000000000000000000000,
    0x1000000000000000000000000000000000000000000000000000000000000000,
    0x2000000000000000000000000000000000000000000000000000000000000000,
    0x4000000000000000000000000000000000000000000000000000000000000000,
    0x8000000000000000000000000000000000000000000000000000000000000000,
];

/// Optimized right bit shift of `b` by `a` over u256.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 255).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u256` - result of right shift
#[inline(always)]
pub fn shr256(a: u8, b: u256) -> u256 {
    b / *SHIFT_TABLE256.span()[a.into()]
}

/// Optimized left bit shift of `b` by `a` over u256.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 255).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u256` - result of left shift
#[inline(always)]
pub fn shl256(a: u8, b: u256) -> u256 {
    b.wrapping_mul(*SHIFT_TABLE256.span()[a.into()])
}

/// Optimized right bit shift of `b` by `a` over u128.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 127).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u128` - result of right shift
#[inline(always)]
pub fn shr128(a: u8, b: u128) -> u128 {
    b / *SHIFT_TABLE128.span()[a.into()]
}

/// Optimized left bit shift of `b` by `a` over u128.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 127).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u128` - result of left shift
#[inline(always)]
pub fn shl128(a: u8, b: u128) -> u128 {
    overflowing_mul128(b, *SHIFT_TABLE128.span()[a.into()])
}

/// Optimized right bit shift of `b` by `a` over u64.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 63).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u64` - result of right shift
#[inline(always)]
pub fn shr64(a: u8, b: u64) -> u64 {
    b / *SHIFT_TABLE64.span()[a.into()]
}

/// Optimized left bit shift of `b` by `a` over u64.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 63).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u64` - result of left shift
#[inline(always)]
pub fn shl64(a: u8, b: u64) -> u64 {
    overflowing_mul64(b, *SHIFT_TABLE64.span()[a.into()])
}

/// Optimized right bit shift of `b` by `a` over u32.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 31).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u32` - result of right shift
#[inline(always)]
pub fn shr32(a: u8, b: u32) -> u32 {
    b / *SHIFT_TABLE32.span()[a.into()]
}

/// Optimized left bit shift of `b` by `a` over u64.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 31).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u32` - result of left shift
#[inline(always)]
pub fn shl32(a: u8, b: u32) -> u32 {
    overflowing_mul32(b, *SHIFT_TABLE32.span()[a.into()])
}

/// Optimized right bit shift of `b` by `a` over u16.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 15).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u16` - result of right shift
#[inline(always)]
pub fn shr16(a: u8, b: u16) -> u16 {
    b / *SHIFT_TABLE16.span()[a.into()]
}

/// Optimized left bit shift of `b` by `a` over u64.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 15).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u16` - result of left shift
#[inline(always)]
pub fn shl16(a: u8, b: u16) -> u16 {
    overflowing_mul16(b, *SHIFT_TABLE16.span()[a.into()])
}

/// Optimized right bit shift of `b` by `a` over u8.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 7).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u8` - result of right shift
#[inline(always)]
pub fn shr8(a: u8, b: u8) -> u8 {
    b / *SHIFT_TABLE8.span()[a.into()]
}

/// Optimized left bit shift of `b` by `a` over u64.
/// #### Arguments
/// * `a` - Number of shifts (must be <= 7).
/// * `b` - Value to be shifted.
/// #### Returns
/// * `u8` - result of left shift
#[inline(always)]
pub fn shl8(a: u8, b: u8) -> u8 {
    overflowing_mul8(b, *SHIFT_TABLE8.span()[a.into()])
}

/// Optimized bit shift trait.
pub trait OptBitShift<T, +WideMul<T, T>> {
    /// Optimized left bit shift of `x` by `y` up to T.bits - 1.
    /// #### Arguments
    /// * `x` - Value to be shifted.
    /// * `y` - Number of shifts.
    /// #### Returns
    /// * `T` - result of left shift
    fn shl(x: T, n: u8) -> T;
    /// Optimized right bit shift of `x` by `y` up to T.bits - 1.
    /// #### Arguments
    /// * `x` - Value to be shifted.
    /// * `y` - Number of shifts.
    /// #### Returns
    /// * `T` - result of left shift
    fn shr(x: T, n: u8) -> T;
}

pub impl U256OptBitShift of OptBitShift<u256> {
    #[inline(always)]
    fn shl(x: u256, n: u8) -> u256 {
        shl256(n, x)
    }
    #[inline(always)]
    fn shr(x: u256, n: u8) -> u256 {
        shr256(n, x)
    }
}

pub impl U128OptBitShift of OptBitShift<u128> {
    #[inline(always)]
    fn shl(x: u128, n: u8) -> u128 {
        assert!(n < 0x80, "`n` must be < 128");

        shl128(n, x)
    }
    #[inline(always)]
    fn shr(x: u128, n: u8) -> u128 {
        assert!(n < 0x80, "`n` must be < 128");

        shr128(n, x)
    }
}

pub impl U64OptBitShift of OptBitShift<u64> {
    #[inline(always)]
    fn shl(x: u64, n: u8) -> u64 {
        assert!(n < 0x40, "`n` must be < 64");

        shl64(n, x)
    }
    #[inline(always)]
    fn shr(x: u64, n: u8) -> u64 {
        assert!(n < 0x40, "`n` must be < 64");

        shr64(n, x)
    }
}

pub impl U32OptBitShift of OptBitShift<u32> {
    #[inline(always)]
    fn shl(x: u32, n: u8) -> u32 {
        assert!(n < 0x20, "`n` must be < 32");

        shl32(n, x)
    }
    #[inline(always)]
    fn shr(x: u32, n: u8) -> u32 {
        assert!(n < 0x20, "`n` must be < 32");

        shr32(n, x)
    }
}

pub impl U16OptBitShift of OptBitShift<u16> {
    #[inline(always)]
    fn shl(x: u16, n: u8) -> u16 {
        assert!(n < 0x10, "`n` must be < 16");

        shl16(n, x)
    }
    #[inline(always)]
    fn shr(x: u16, n: u8) -> u16 {
        assert!(n < 0x10, "`n` must be < 16");

        shr16(n, x)
    }
}

pub impl U8OptBitShift of OptBitShift<u8> {
    #[inline(always)]
    fn shl(x: u8, n: u8) -> u8 {
        assert!(n < 0x8, "`n` must be < 8");

        shl8(n, x)
    }
    #[inline(always)]
    fn shr(x: u8, n: u8) -> u8 {
        assert!(n < 0x8, "`n` must be < 8");

        shr8(n, x)
    }
}

// Bit rotate

/// Optimized left bit rotate of `b` by `a` over u256.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 255).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u256` - result of left rotate
#[inline(always)]
pub fn rotl256(a: u8, b: u256) -> u256 {
    shl256(a, b) | shr256((0x100 - a.into()).try_into().unwrap(), b)
}

/// Optimized right bit rotate of `b` by `a` over u256.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 255).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u256` - result of left rotate
#[inline(always)]
pub fn rotr256(a: u8, b: u256) -> u256 {
    shr256(a, b) | shl256((0x100 - a.into()).try_into().unwrap(), b)
}

/// Optimized left bit rotate of `b` by `a` over u128.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 127).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u128` - result of left rotate
#[inline(always)]
pub fn rotl128(a: u8, b: u128) -> u128 {
    shl128(a, b) | shr128((0x80 - a.into()).try_into().unwrap(), b)
}

/// Optimized right bit rotate of `b` by `a` over u128.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 127).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u128` - result of left rotate
#[inline(always)]
pub fn rotr128(a: u8, b: u128) -> u128 {
    shr128(a, b) | shl128((0x80 - a.into()).try_into().unwrap(), b)
}

/// Optimized left bit rotate of `b` by `a` over u64.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 63).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u64` - result of left rotate
#[inline(always)]
pub fn rotl64(a: u8, b: u64) -> u64 {
    shl64(a, b) | shr64((0x40 - a.into()).try_into().unwrap(), b)
}

/// Optimized right bit rotate of `b` by `a` over u64.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 63).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u64` - result of left rotate
#[inline(always)]
pub fn rotr64(a: u8, b: u64) -> u64 {
    shr64(a, b) | shl64((0x40 - a.into()).try_into().unwrap(), b)
}

/// Optimized left bit rotate of `b` by `a` over u32.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 31).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u32` - result of left rotate
#[inline(always)]
pub fn rotl32(a: u8, b: u32) -> u32 {
    shl32(a, b) | shr32((0x20 - a.into()).try_into().unwrap(), b)
}

/// Optimized right bit rotate of `b` by `a` over u32.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 31).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u32` - result of left rotate
#[inline(always)]
pub fn rotr32(a: u8, b: u32) -> u32 {
    shr32(a, b) | shl32((0x20 - a.into()).try_into().unwrap(), b)
}

/// Optimized left bit rotate of `b` by `a` over u16.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 15).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u16` - result of left rotate
#[inline(always)]
pub fn rotl16(a: u8, b: u16) -> u16 {
    shl16(a, b) | shr16((0x10 - a.into()).try_into().unwrap(), b)
}

/// Optimized right bit rotate of `b` by `a` over u16.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 15).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u16` - result of left rotate
#[inline(always)]
pub fn rotr16(a: u8, b: u16) -> u16 {
    shr16(a, b) | shl16((0x10 - a.into()).try_into().unwrap(), b)
}

/// Optimized left bit rotate of `b` by `a` over u8.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 7).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u8` - result of left rotate
#[inline(always)]
pub fn rotl8(a: u8, b: u8) -> u8 {
    shl8(a, b) | shr8((0x8 - a.into()).try_into().unwrap(), b)
}

/// Optimized right bit rotate of `b` by `a` over u8.
/// #### Arguments
/// * `a` - Number of rotations (0 < `a` <= 7).
/// * `b` - Value to be rotated.
/// #### Returns
/// * `u8` - result of left rotate
#[inline(always)]
pub fn rotr8(a: u8, b: u8) -> u8 {
    shr8(a, b) | shl8((0x8 - a.into()).try_into().unwrap(), b)
}

/// Optimized bit rotation trait.
pub trait OptBitRotate<T, +WideMul<T, T>> {
    fn rotl(x: T, n: u8) -> T;
    fn rotr(x: T, n: u8) -> T;
}

/// Does not support 0 rotations (will panic).
pub impl U256OptBitRotate of OptBitRotate<u256> {
    #[inline(always)]
    fn rotl(x: u256, n: u8) -> u256 {
        rotl256(n, x)
    }
    #[inline(always)]
    fn rotr(x: u256, n: u8) -> u256 {
        rotr256(n, x)
    }
}

pub impl U128OptBitRotate of OptBitRotate<u128> {
    #[inline(always)]
    fn rotl(x: u128, n: u8) -> u128 {
        if n == 0 {
            return x;
        }

        assert!(n < 0x80, "`n` must be < 128");

        rotl128(n, x)
    }
    #[inline(always)]
    fn rotr(x: u128, n: u8) -> u128 {
        if n == 0 {
            return x;
        }

        assert!(n < 0x80, "`n` must be < 128");

        rotr128(n, x)
    }
}

pub impl U64OptBitRotate of OptBitRotate<u64> {
    #[inline(always)]
    fn rotl(x: u64, n: u8) -> u64 {
        if n == 0 {
            return x;
        }

        assert!(n < 0x40, "`n` must be < 64");

        rotl64(n, x)
    }
    #[inline(always)]
    fn rotr(x: u64, n: u8) -> u64 {
        if n == 0 {
            return x;
        }

        assert!(n < 0x40, "`n` must be < 64");

        rotr64(n, x)
    }
}

pub impl U32OptBitRotate of OptBitRotate<u32> {
    #[inline(always)]
    fn rotl(x: u32, n: u8) -> u32 {
        if n == 0 {
            return x;
        }

        assert!(n < 0x20, "`n` must be < 32");

        rotl32(n, x)
    }
    #[inline(always)]
    fn rotr(x: u32, n: u8) -> u32 {
        if n == 0 {
            return x;
        }

        assert!(n < 0x20, "`n` must be < 32");

        rotr32(n, x)
    }
}

pub impl U16OptBitRotate of OptBitRotate<u16> {
    #[inline(always)]
    fn rotl(x: u16, n: u8) -> u16 {
        if n == 0 {
            return x;
        }

        assert!(n < 0x10, "`n` must be < 16");

        rotl16(n, x)
    }
    #[inline(always)]
    fn rotr(x: u16, n: u8) -> u16 {
        if n == 0 {
            return x;
        }

        assert!(n < 0x10, "`n` must be < 16");

        rotr16(n, x)
    }
}

pub impl U8OptBitRotate of OptBitRotate<u8> {
    #[inline(always)]
    fn rotl(x: u8, n: u8) -> u8 {
        if n == 0 {
            return x;
        }

        assert!(n < 0x8, "`n` must be < 8");

        rotl8(n, x)
    }
    #[inline(always)]
    fn rotr(x: u8, n: u8) -> u8 {
        if n == 0 {
            return x;
        }

        assert!(n < 0x8, "`n` must be < 8");

        rotr8(n, x)
    }
}
