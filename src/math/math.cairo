use option::OptionTrait;
use math::Oneable;
use traits::{Into, TryInto};

/// Raise a number to a power.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `u128` - The result of base raised to the power of exp.
fn pow(base: u128, mut exp: u128) -> u128 {
    if exp == 0 {
        1
    } else {
        base * pow(base, exp - 1)
    }
}

/// Function to count the number of digits in a number.
/// # Arguments
/// * `num` - The number to count the digits of.
/// * `base` - Base in which to count the digits.
/// # Returns
/// * `felt252` - The number of digits in num of base
fn count_digits_of_base(mut num: u128, base: u128) -> u128 {
    let mut res = 0;
    loop {
        if num == 0 {
            break res;
        } else {
            num = num / base;
        }
        res += 1;
    }
}

fn fpow<
    T,
    impl TNumericLiteral: NumericLiteral<T>,
    impl TPartialEq: PartialEq<T>,
    impl TAdd: Add<T>,
    impl TBitAnd: BitAnd<T>,
    impl TMul: Mul<T>,
    impl TDiv: Div<T>,
    impl TOneable: Oneable<T>,
    impl TZeroable: Zeroable<T>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>,
>(
    x: T, n: T
) -> T {
    let one = Oneable::one();
    let two = one + Oneable::one();
    if n == Zeroable::zero() {
        one
    } else if (n & one) == one {
        x * fpow(x * x, n / two)
    } else {
        fpow(x * x, n / two)
    }
}
fn shl<
    T,
    impl TNumericLiteral: NumericLiteral<T>,
    impl TPartialEq: PartialEq<T>,
    impl TAdd: Add<T>,
    impl TBitAnd: BitAnd<T>,
    impl TMul: Mul<T>,
    impl TDiv: Div<T>,
    impl TZeroable: Zeroable<T>,
    impl TOneable: Oneable<T>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>,
>(
    x: T, n: T
) -> T {
    let two = Oneable::one() + Oneable::one();
    x * fpow(two, n)
}

fn shr<
    T,
    impl TNumericLiteral: NumericLiteral<T>,
    impl TPartialEq: PartialEq<T>,
    impl TAdd: Add<T>,
    impl TBitAnd: BitAnd<T>,
    impl TMul: Mul<T>,
    impl TDiv: Div<T>,
    impl TZeroable: Zeroable<T>,
    impl TOneable: Oneable<T>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>
>(
    x: T, n: T
) -> T {
    let two = Oneable::one() + Oneable::one();
    x / fpow(two, n)
}

