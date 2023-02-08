//! Utilities for quaireaux standard library.
use array::ArrayTrait;
use option::OptionTrait;

/// Panic with a custom message.
/// # Arguments
/// * `msg` - The message to panic with. Must be a short string to fit in a felt.
fn panic_with(err: felt) {
    let mut data = ArrayTrait::new();
    data.append(err);
    panic(data);
}

/// Convert a `felt` to a `NonZero` type.
/// # Arguments
/// * `felt` - The `felt` to convert.
/// # Returns
/// * `Option::<NonZero::<felt>>` - The `felt` as a `NonZero` type.
/// * `Option::<NonZero::<felt>>::None` - If `felt` is 0.
fn to_non_zero(felt: felt) -> Option::<NonZero::<felt>> {
    let res = felt_is_zero(felt);
    match res {
        IsZeroResult::Zero(()) => Option::<NonZero::<felt>>::None(()),
        IsZeroResult::NonZero(val) => Option::<NonZero::<felt>>::Some(val),
    }
}


/// Force conversion from `felt` to `u128`.
fn unsafe_felt_to_u128(a: felt) -> u128 {
    let res = u128_try_from_felt(a);
    res.unwrap()
}

/// Perform euclidean division on `felt` types.
fn unsafe_euclidean_div_no_remainder(a: felt, b: felt) -> felt {
    let a_u128 = unsafe_felt_to_u128(a);
    let b_u128 = unsafe_felt_to_u128(b);
    u128_to_felt(a_u128 / b_u128)
}

fn unsafe_euclidean_div(a: felt, b: felt) -> (felt, felt) {
    let a_u128 = unsafe_felt_to_u128(a);
    let b_u128 = unsafe_felt_to_u128(b);
    (u128_to_felt(a_u128 / b_u128), u128_to_felt(a_u128 % b_u128))
}

fn max(a: felt, b: felt) -> felt {
    if a > b {
        return a;
    } else {
        return b;
    }
}

// Function to count the number of digits in a number.
/// # Arguments
/// * `num` - The number to count the digits of.
/// # Returns
/// * `felt` - The number of digits in num.
fn count_digits(num: felt) -> felt {
    _count_digits(num, 0, 1)
}

// Recursive helper function for 'count_digits'.
/// * `num` - The number to count the digits of.
/// * `count` - The current count of digits.
/// * `divisor` - The divisor used in the calculation to separate the digits.
/// # Returns
/// * `felt` - The number of digits in num.
fn _count_digits(num: felt, count: felt, divisor: felt) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    let quotient = unsafe_euclidean_div_no_remainder(num, divisor);
    if quotient < 10 {
        return count + 1;
    }
    return _count_digits(num, count + 1, divisor * 10);
}

// Raise a number to a power.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `felt` - The result of base raised to the power of exp.
fn pow(base: felt, exp: felt) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    match exp {
        0 => 1,
        _ => base * pow(base, exp - 1),
    }
}
