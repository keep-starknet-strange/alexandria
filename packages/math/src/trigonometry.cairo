use core::traits::TryInto;
const BASE_I64: i64 = 100000000;
const FAST_I90: i64 = 90 * BASE_I64;

const BASE: u64 = 100000000;
const FAST_360: u64 = 360 * BASE;
const FAST_180: u64 = 180 * BASE;
const FAST_90: u64 = 90 * BASE;
const FAST_10: u64 = 10 * BASE;

const sin_table: [
    u64
    ; 10] = [
    0_u64, // sin(0)
    17364818_u64, // sin(10)
    34202014_u64, // sin(20)
    50000000_u64, // sin(30)
    64278761_u64, // sin(40)
    76604444_u64, // sin(50)
    86602540_u64, // sin(60)
    93969262_u64, // sin(70)
    98480775_u64, // sin(80)
    100000000_u64 // sin(90)
];

const cos_table: [
    u64
    ; 10] = [
    100000000_u64, // cos(0)
    99984769_u64, // cos(1)
    99939082_u64, // cos(2)
    99862953_u64, // cos(3)
    99756405_u64, // cos(4)
    99619470_u64, // cos(5)
    99452190_u64, // cos(6)
    99254615_u64, // cos(7)
    99026807_u64, // cos(8)
    98768834_u64, // cos(9)
];

// Calculate fast sin(x)
// Since there is no float in cairo, we multiply every number by 1e8
// # Arguments
// * `x` - The number to calculate sin(x)
// # Returns
// * `bool` - true if the result is positive, false if the result is negative
// * `u64` - sin(x) * 1e8
// # Example
// * fast_sin(3000000000) = (true, 50000000)
pub fn fast_sin_inner(x: u64) -> (bool, u64) {
    let hollyst: u64 = 1745329_u64;

    let mut a = x % FAST_360;
    let mut sig = true;
    if a > FAST_180 {
        sig = false;
        a = a - FAST_180;
    }

    if a > FAST_90 {
        a = FAST_180 - a;
    }

    let i: usize = (a / FAST_10).try_into().unwrap();
    let j = a - i.into() * FAST_10;
    let int_j: usize = (j / BASE).try_into().unwrap();

    let y = *sin_table.span()[i] * *cos_table.span()[int_j] / BASE
        + ((j * hollyst) / BASE) * *sin_table.span()[9
        - i] / BASE;

    return (sig, y);
}

// Calculate fast sin(x)
// Since there is no float in cairo, we multiply every number by 1e8
// # Arguments
// * `x` - The number to calculate sin(x)
// # Returns
// * `i64` - sin(x) * 1e8
// # Example
// * fast_sin(3000000000) = 50000000
pub fn fast_sin(x: i64) -> i64 {
    let mut a = x;
    if x < 0 {
        a = -x;
    }
    let input: u64 = a.try_into().unwrap();
    let (sig_u64, result_u64) = fast_sin_inner(input);
    let mut sig = sig_u64;
    if x < 0 {
        sig = !sig;
    }
    let result: i64 = result_u64.try_into().unwrap();
    if sig {
        return result;
    } else {
        return -result;
    }
}

// Calculate fast cos(x)
// Since there is no float in cairo, we multiply every number by 1e8
// # Arguments
// * `x` - The number to calculate cos(x)
// # Returns
// * `i64` - cos(x) * 1e8
// # Example
// * fast_cos(6000000000) = 50000000
pub fn fast_cos(x: i64) -> i64 {
    let mut a = x + FAST_I90;
    if x < 0 {
        a = -x;
    }
    let input: u64 = a.try_into().unwrap();
    let (sig, result_u64) = fast_sin_inner(input);
    let result: i64 = result_u64.try_into().unwrap();
    if sig {
        return result;
    } else {
        return -result;
    }
}

// Calculate fast tan(x)
// Since there is no float in cairo, we multiply every number by 1e8
// # Arguments
// * `x` - The number to calculate tan(x)
// # Returns
// * `i64` - tan(x) * 1e8
// # Example
// * fast_tan(4500000000) = 100000000
pub fn fast_tan(x: i64) -> i64 {
    let mut a = x;
    if x < 0 {
        a = -x;
    }
    let input_sin: u64 = a.try_into().unwrap();
    let input_cos: u64 = (a + FAST_I90).try_into().unwrap();
    let (sig_sin, result_u64_sin) = fast_sin_inner(input_sin);
    let (sig_cos, result_u64_cos) = fast_sin_inner(input_cos);
    let mut sig = sig_sin || sig_cos;
    if x < 0 {
        sig = !sig;
    }
    let result_u64 = result_u64_sin * BASE / result_u64_cos;
    let result: i64 = result_u64.try_into().unwrap();
    if sig {
        return result;
    } else {
        return -result;
    }
}
