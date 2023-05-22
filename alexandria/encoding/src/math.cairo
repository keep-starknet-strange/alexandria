const U6_MAX: u128 = 0x3F;
const U8_MAX: u128 = 0xFF;

fn fpow(x: u128, n: u128) -> u128 {
    if n == 0 {
        1
    } else if (n & 1) == 1 {
        x * fpow(x * x, n / 2)
    } else {
        fpow(x * x, n / 2)
    }
}

fn shl(x: u128, n: u128) -> u128 {
    x * fpow(2, n)
}

fn shr(x: u128, n: u128) -> u128 {
    x / fpow(2, n)
}
