//! Utilities for quaireaux standard library.
use array::ArrayTrait;
use option::OptionTrait;
use traits::TryInto;
use traits::Into;

/// Panic with a custom message.
/// # Arguments
/// * `msg` - The message to panic with. Must be a short string to fit in a felt252.
fn panic_with(err: felt252) {
    let mut data = ArrayTrait::new();
    data.append(err);
    panic(data);
}

/// Convert a `felt252` to a `NonZero` type.
/// # Arguments
/// * `felt252` - The `felt252` to convert.
/// # Returns
/// * `Option::<NonZero::<felt252>>` - The `felt252` as a `NonZero` type.
/// * `Option::<NonZero::<felt252>>::None` - If `felt252` is 0.
fn to_non_zero(felt252: felt252) -> Option::<NonZero::<felt252>> {
    let res = felt252_is_zero(felt252);
    match res {
        IsZeroResult::Zero(()) => Option::<NonZero::<felt252>>::None(()),
        IsZeroResult::NonZero(val) => Option::<NonZero::<felt252>>::Some(val),
    }
}


/// Force conversion from `felt252` to `u128`.
fn unsafe_felt252_to_u128(a: felt252) -> u128 {
    a.try_into().unwrap()
}

/// Perform euclidean division on `felt252` types.
fn unsafe_euclidean_div_no_remainder(a: felt252, b: felt252) -> felt252 {
    let a_u128 = unsafe_felt252_to_u128(a);
    let b_u128 = unsafe_felt252_to_u128(b);
    (a_u128 / b_u128).into()
}

fn unsafe_euclidean_div(a: felt252, b: felt252) -> (felt252, felt252) {
    let a_u128 = unsafe_felt252_to_u128(a);
    let b_u128 = unsafe_felt252_to_u128(b);
    ((a_u128 / b_u128).into(), (a_u128 % b_u128).into())
}

// Function to count the number of digits in a number.
/// # Arguments
/// * `num` - The number to count the digits of.
/// * `base` - Base in which to count the digits.
/// # Returns
/// * `felt252` - The number of digits in num of base
fn count_digits_of_base(num: felt252, base: felt252) -> felt252 {
    check_gas();

    match num {
        0 => 0,
        _ => {
            let quotient = unsafe_euclidean_div_no_remainder(num, base);
            count_digits_of_base(quotient, base) + 1
        }
    }
}

// Raise a number to a power.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `felt252` - The result of base raised to the power of exp.
fn pow(base: felt252, exp: felt252) -> felt252 {
    check_gas();

    match exp {
        0 => 1,
        _ => base * pow(base, exp - 1),
    }
}

// Split an array into two arrays.
/// * `arr` - The array to split.
/// * `index` - The index to split the array at.
/// # Returns
/// * `(Array::<felt252>, Array::<felt252>)` - The two arrays.
fn split_array(ref arr: Array::<u32>, index: u32) -> (Array::<u32>, Array::<u32>) {
    check_gas();

    let mut arr1 = ArrayTrait::new();
    let mut arr2 = ArrayTrait::new();
    let len = arr.len();

    fill_array(ref arr1, ref arr, 0_u32, index);
    fill_array(ref arr2, ref arr, index, len - index);

    (arr1, arr2)
}

// Fill an array with a value.
/// * `arr` - The array to fill.
/// * `fill_arr` - The array to fill with.
/// * `index` - The index to start filling at.
/// * `count` - The number of elements to fill.
/// # Returns
/// * `Array::<T>` - The filled array.
fn fill_array(ref arr: Array::<u32>, ref fill_arr: Array::<u32>, index: u32, count: u32) {
    check_gas();

    if count == 0_u32 {
        return ();
    }
    let element = fill_arr.at(index);
    arr.append(*element);

    fill_array(ref arr, ref fill_arr, index + 1_u32, count - 1_u32)
}

// Fill an array with a value.
/// * `dst` - The array to fill.
/// * `src` - The array to fill with.
/// * `index` - The index to start filling at.
/// * `count` - The number of elements to fill.
fn fill_array_256(ref dst: Array::<u256>, src: @Array::<u256>, index: u32, count: u32) {
    check_gas();

    if count == 0_u32 {
        return ();
    }
    if index >= src.len() {
        return ();
    }
    let element = src.at(index);
    dst.append(*element);

    fill_array_256(ref dst, src, index + 1_u32, count - 1_u32)
}

// Check if two arrays are equal.
/// * `a` - The first array.
/// * `b` - The second array.
/// * `index` - The index used to loop through the arrays.
/// # Returns
/// * `bool` - True if the arrays are equal, false otherwise.
fn is_equal(ref a: Array::<u32>, ref b: Array::<u32>, index: u32) -> bool {
    check_gas();

    let len = a.len();
    if len != b.len() {
        return false;
    }
    let mut i = 0_u32;
    if index == len {
        return true;
    }

    let a_element = a.at(index);
    let b_element = b.at(index);
    if *a_element != *b_element {
        return false;
    }

    is_equal(ref a, ref b, index + 1_u32)
}

/// Returns the slice of an array.
/// * `arr` - The array to slice.
/// * `begin` - The index to start the slice at.
/// * `end` - The index to end the slice at (not included).
/// # Returns
/// * `Array::<u256>` - The slice of the array.
fn array_slice(src: @Array::<u256>, begin: usize, end: usize) -> Array::<u256> {
    let mut slice = ArrayTrait::new();
    fill_array_256(ref dst: slice, :src, index: begin, count: end);
    slice
}


// TODO comment
// TODO: Remove when automatically handled by compiler.
#[inline(always)]
fn check_gas() {
    match gas::withdraw_gas_all(get_builtin_costs()) {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('Out of gas');
            panic(data);
        }
    }
}
